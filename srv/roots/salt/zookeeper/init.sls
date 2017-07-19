{% from "zookeeper/map.jinja" import zookeeper with context %}
include:
  - supervisor
  - core

zookeeperd:
  pkg.installed:
    - require:
      - pkg: base_packages
  
  
zookeeper:
  pkg.installed:
    - require:
      - pkg: base_packages
  service:
    - running
    - enable: true
    - watch:
      - file: /etc/zookeeper/conf/zoo.cfg
      - file: /etc/zookeeper/conf/environment


 
{% for file in ['zoo.cfg', 'environment', 'log4j.properties', 'java.env'] %}
/etc/zookeeper/conf/{{ file }}:
  file.managed:
    - source: salt://zookeeper/files/opt/zookeeper/conf/{{ file }}
    - user: zookeeper
    - group: zookeeper
{% endfor %}

/var/zookeeper:
  file.directory:
    - user: zookeeper
    - group: zookeeper
    - dir_mode: 755
    - file_mode: 644

/var/zookeeper/myid:
  file.managed:
    - source: salt://zookeeper/files/var/zookeeper/myid
    - user: zookeeper
    - group: zookeeper
    - mode: 644
    - template: jinja

/etc/supervisor/conf.d/zookeeper.conf:
  file.managed:
    - source: salt://zookeeper/files/etc/supervisord.d/zookeeper.conf
    - user: zookeeper
    - group: zookeeper
    - mode: 644
    - require:
      - file: /etc/supervisor/supervisord.conf

