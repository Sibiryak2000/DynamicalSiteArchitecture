{% set net = "10.33.33."%}
{%- set con = salt.cmd.shell('curl -s localhost/status 2>/dev/null|grep Activ')|regex_replace(".*([0-9]+).*$","\\1")|default(1,true) %}
{%- set back_list = [] %}
{%- for i in range(con|int) %}
  {%- do back_list.append("docker_back" ~ i) %}
{%- endfor %}

docker_image:
  docker_image.present:
    - name: nginx
    - tag: stable-alpine

network_internal:
  docker_network.present:
    - subnet: {{net}}0/24

docker_template:
  file.managed:
    - name: /srv/default.conf.template
    - source: salt://{{slspath}}/files/default.conf.template
    - template: jinja
    - context:
      list: {{ back_list }}

{% for host in back_list %}
{{host}}:
  docker_container.running:
    - image: nginx:stable-alpine
    - hostname: {{host}}
    - networks:
      - network_internal
    - require:
      - docker_image: docker_image
{% endfor %}

docker_balancer:
  docker_container.running:
    - image: nginx:stable-alpine
    - networks:
      - bridge
      - network_internal
    - port_bindings:
      - 80:80
    - binds:
      - /srv/default.conf.template:/etc/nginx/conf.d/default.conf
    - require:
      - docker_image: docker_image

{%- set container_list = salt.docker.list_containers()|difference(["docker_balancer"]) %}

docker_uneeded:
  docker_container.absent:
    - force: True
    - names: {{container_list|difference(back_list)}}

{# debug_connection:
  test.show_notification:
    - text:
      - '{{ con }}'
      - '{{ container_list|tojson }}'
      - '{{back_list|tojson}}' #}