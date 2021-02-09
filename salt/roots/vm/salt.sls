docker.io:
  pkg.latest:
    - refresh: true
  service.running:
    - name: containerd
    - enable: true
    - require:
      - pkg: docker.io