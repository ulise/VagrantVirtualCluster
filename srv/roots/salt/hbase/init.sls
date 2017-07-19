{% from "hbase/map.jinja" import hbase with context %}
include:
  - core

hbase:
  group.present:
    - system: True
  user.present:
    - shell: /bin/bash
    - home: /home/hbase
    - groups:
      - hbase
    - require:
      - group: hbase
      - file: /etc/skel/.ssh

hbase_install:
  archive.extracted:
    - name: /opt/
    - source: http://apache.claz.org/hbase/{{hbase.version}}/hbase-{{hbase.version}}-bin.tar.gz
    - source_hash: "md5={{hbase.checksum}}"
    - archive_format: tar
    - tar_options: z
    - if_missing: /opt/hbase-{{hbase.version}}

/opt/hbase-{{hbase.version}}:
  file.directory:
    - user: hbase
    - group: hbase
    - recurse:
      - user
      - group
    - require:
      - archive: hbase_install
      - user: hbase

/opt/hbase:
  file.symlink:
    - target: /opt/hbase-{{hbase.version}}
    - user: hbase
    - group: hbase
    - recurse:
      - user
      - group
    - require:
      - archive: hbase_install

{% for file in ['backup-master',
                'hbase-env.sh',
                'hbase-policy.xml',
                'hbase-site.xml',
                'regionservers'] %}
/opt/hbase/conf/{{ file }}:
  file.managed:
    - source: salt://hbase/files/opt/conf/{{ file }}
    - user: hbase
    - group: hbase
    - require:
      - file: /opt/hbase
{% endfor %}

