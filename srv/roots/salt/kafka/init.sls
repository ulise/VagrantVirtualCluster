{% from "kafka/map.jinja" import kafka with context %}
include:
  - core

kafka:
  group.present:
    - system: True
  user.present:
    - shell: /bin/bash
    - home: /home/kafka
    - groups:
      - kafka
    - require:
      - group: kafka
      - file: /etc/skel/.ssh
  file.managed:
    - name: /home/kafka/.bashrc
    - source: salt://kafka/files/home/kafka/bashrc
    - user: kafka
    - group: kafka
    - require:
      - user: kafka

kafka_install:
  archive:
    - extracted
    - name: /opt/
    - source: http://apache.claz.org/kafka/{{kafka.version}}/kafka_{{kafka.scala_version}}-{{kafka.version}}.tgz
    - source_hash: "md5={{kafka.checksum}}"
    - archive_format: tar
    - tar_options: z
    - if_missing: /opt/kafka_{{kafka.scala_version}}-{{kafka.version}}

/opt/kafka_{{kafka.scala_version}}-{{kafka.version}}:
  file.directory:
    - user: kafka
    - group: kafka
    - recurse:
      - user
      - group
    - require:
      - archive: kafka_install
      - user: kafka

/opt/kafka:
  file.symlink:
    - target: /opt/kafka_{{kafka.scala_version}}-{{kafka.version}}
    - user: kafka
    - group: kafka
    - recurse:
      - user
      - group
    - require:
      - archive: kafka_install

/opt/kafka/config/log4j.properties:
  file.managed:
    - source: salt://kafka/files/opt/kafka/config/log4j.properties
    - user: kafka
    - group: kafka
    - require:
      - file: /opt/kafka

/etc/init.d/kafka:
  file.managed:
    - source: salt://kafka/files/etc/kafka
    - user: root
    - group: root
    - mode: 755
    - require:
      - file: /opt/kafka

/opt/kafka/bin/kafka-server-start.sh:
  file.managed:
    - source: salt://kafka/files/opt/kafka/bin/kafka-server-start.sh
    - user: kafka
    - group: kafka
    - mode: 755
    - require:
      - file: /opt/kafka

/var/log/kafka/:
  file.directory:
    - user: kafka
    - group: kafka
    - mode: 755
    - require:
      - user: kafka
