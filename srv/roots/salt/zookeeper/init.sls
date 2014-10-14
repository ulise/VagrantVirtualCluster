{% from "zookeeper/map.jinja" import zookeeper with context %}
include:
  - supervisor
  - core

zookeeper:
  group.present:
    - name: zookeeper
    - system: True
  user.present:
    - name: zookeeper
    - shell: /bin/bash
    - home: /home/zookeeper
    - groups:
      - zookeeper
    - require:
      - group: zookeeper
      - file: /etc/skel/.ssh

zookeeper_install:
  archive:
    - extracted
    - name: /opt/
    - source: http://apache.claz.org/zookeeper/zookeeper-{{zookeeper.version}}/zookeeper-{{zookeeper.version}}.tar.gz
    - source_hash: "md5={{zookeeper.checksum}}"
    - archive_format: tar
    - tar_options: z
    - if_missing: /opt/zookeeper-{{zookeeper.version}}

/opt/zookeeper-{{zookeeper.version}}:
  file.directory:
    - user: zookeeper
    - group: zookeeper
    - recurse:
      - user
      - group
    - require:
      - archive: zookeeper_install
      - user: zookeeper

/opt/zookeeper:
  file.symlink:
    - target: /opt/zookeeper-{{zookeeper.version}}
    - user: zookeeper
    - group: zookeeper
    - recurse:
      - user
      - group
    - require:
      - user: zookeeper
      - archive: zookeeper_install
{% for file in ['zoo.cfg', 'log4j.properties', 'java.env'] %}
/opt/zookeeper/conf/{{ file }}:
  file.managed:
    - source: salt://zookeeper/files/opt/zookeeper/conf/{{ file }}
    - user: zookeeper
    - group: zookeeper
    - require:
      - user: zookeeper
      - file: /opt/zookeeper
{% endfor %}

{% for dir in ['zookeeper', 'log/zookeeper'] %}
/var/{{ dir }}:
  file.directory:
    - user: zookeeper
    - group: zookeeper
    - mode: 750
    - require:
      - user: zookeeper
{% endfor %}

/var/zookeeper/myid:
  file.managed:
    - source: salt://zookeeper/files/var/zookeeper/myid
    - user: zookeeper
    - group: zookeeper
    - mode: 644
    - require:
      - user: zookeeper
    - template: jinja

/etc/supervisord.d/zookeeper.conf:
  file.managed:
    - source: salt://zookeeper/files/etc/supervisord.d/zookeeper.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: /etc/supervisord.d
