include:
  - core

cassandra:
  pkgrepo.managed:
    - humanname: Apache repository
    - name: deb http://www.apache.org/dist/cassandra/debian 39x main
    - file: /etc/apt/sources.list.d/cassandra.sources.list
    - keyid: A278B781FE4B2BDA
    - keyserver: pool.sks-keyservers.net
    - require_in:
      - pkg: cassandra
  pkg.installed:
    - require:
      - pkg: base_packages
  service:
    - running
    - enable: true
    - watch:
      - file: /etc/cassandra/cassandra.yaml

/etc/cassandra/cassandra.yaml:
  file.managed:
    - source: salt://cassandra/files/etc/cassandra.yaml
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: cassandra

