{% from "storm/map.jinja" import storm with context %}
include:
  - core

storm:
  group.present:
    - name: storm
    - system: true
  user.present:
    - name: storm
    - shell: /bin/bash
    - home: /home/storm
    - groups:
      - storm
    - require:
      - group: storm
      - file: /etc/skel/.ssh
  file.managed:
    - name: /home/storm/.bashrc
    - source: salt://storm/files/home/storm/bashrc
    - mode: 644
    - group: storm
    - user: storm
    - require:
      - user: storm

storm_install:
  archive:
    - extracted
    - name: /opt/
    - source: http://apache.claz.org/incubator/storm/apache-storm-{{storm.version}}/apache-storm-{{storm.version}}.tar.gz
    - source_hash: "md5={{storm.checksum}}"
    - archive_format: tar
    - tar_options: z
    - if_missing: /opt/apache-storm-{{storm.version}}

/opt/apache-storm-{{storm.version}}:
  file.directory:
    - user: storm
    - group: storm
    - recurse:
      - user
      - group
    - require:
      - archive: storm_install
      - user: storm

/opt/storm:
  file.symlink:
    - target: /opt/apache-storm-{{storm.version}}
    - user: storm
    - group: storm
    - recurse:
      - user
      - group
    - require:
      - archive: storm_install

/opt/storm/conf/storm.yaml:
  file.managed:
    - source: salt://storm/files/opt/storm/conf/storm.yaml
    - user: storm
    - group: storm
    - mode: 644
    - require:
      - file: /opt/storm
      - user: storm

{% for dir in ['/var/storm', '/var/log/storm'] %}
{{ dir }}:
  file.directory:
    - user: storm
    - group: storm
    - mode: 750
    - require:
      - user: storm
{% endfor %}
