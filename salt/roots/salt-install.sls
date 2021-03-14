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

docker_user_group:
  group.present:
    - name: docker
    - addusers:
      - vagrant

renew:
  schedule.present:
    - function: state.sls
    - job_args:
      - salt-renew
    - seconds: 10