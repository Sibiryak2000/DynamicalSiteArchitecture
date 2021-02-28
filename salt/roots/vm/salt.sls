docker.io:
  pkg.latest:
    - refresh: true
    - pkgs:
      - docker.io
      - python3-pip
  pip.installed:
    - name: docker
    - require:
      - pkg: docker.io
  service.running:
    - name: containerd
    - enable: true
    - require:
      - pkg: docker.io

docker_image:
  docker_image.present:
    - name: nginx
    - tag: stable-alpine

docker_balancer:
  docker_container.running:
    - image: nginx:stable-alpine
    - port_bindings:
      - 80:80