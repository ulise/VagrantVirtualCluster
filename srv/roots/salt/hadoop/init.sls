{% from "hadoop/map.jinja" import hadoop with context %}
include:
  - core

hadoop:
  group.present:
    - system: True
  user.present:
    - shell: /bin/bash
    - home: /home/hadoop
    - groups:
      - hadoop
    - require:
      - group: hadoop
      - file: /etc/skel/.ssh
  file.managed:
    - name: /home/hadoop/.bashrc
    - source: salt://hadoop/files/home/hadoop/bashrc
    - require:
      - user: hadoop

hadoop_install:
  archive.extracted:
    - name: /opt/
    - source: http://apache.claz.org/hadoop/common/hadoop-{{hadoop.version}}/hadoop-{{hadoop.version}}.tar.gz
    - source_hash: "md5={{hadoop.checksum}}"
#    - skip_verify: true
    - archive_format: tar
    - tar_options: z
    - if_missing: /opt/hadoop-{{hadoop.version}}

/opt/hadoop-{{hadoop.version}}:
  file.directory:
    - user: hadoop
    - group: hadoop
    - recurse:
      - user
      - group
    - require:
      - archive: hadoop_install
      - user: hadoop

/opt/hadoop:
  file.symlink:
    - target: /opt/hadoop-{{hadoop.version}}
    - user: hadoop
    - group: hadoop
    - recurse:
      - user
      - group
    - require:
      - archive: hadoop_install

{% for file in ['core-site.xml',
                'hdfs-site.xml',
                'mapred-site.xml',
                'slaves',
                'yarn-site.xml',
                'hadoop-env.sh'] %}
/opt/hadoop/etc/hadoop/{{ file }}:
  file.managed:
    - source: salt://hadoop/files/etc/hadoop/{{ file }}
    - user: hadoop
    - group: hadoop
    - require:
      - file: /opt/hadoop
{% endfor %}

{% for dir in ['/data/hdfs/name', '/data/hdfs/data', '/data/mapred/local'] %}
{{ dir }}:
  file.directory:
    - user: hadoop
    - group: hadoop
    - makedirs: True
    - recurse:
      - user
      - group
    - require:
      - user: hadoop
{% endfor %}
