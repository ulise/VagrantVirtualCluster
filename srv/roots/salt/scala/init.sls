{% from "scala/map.jinja" import scala with context %}

scala_install:
  archive:
    - extracted
    - name: /opt/
    - source: http://downloads.typesafe.com/scala/{{scala.version}}/scala-{{scala.version}}.tgz
    - source_hash: "md5={{scala.checksum}}"
    - archive_format: tar
    - tar_options: z
    - if_missing: /opt/scala-{{scala.version}}

/opt/scala-{{scala.version}}:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - recurse:
      - user
      - group
      - mode
    - require:
      - archive: scala_install

/opt/scala:
  file.symlink:
    - target: /opt/scala-{{scala.version}}
    - user: root
    - group: root
    - mode: 755
    - recurse:
      - user
      - group
      - mode

/etc/profile.d/scala.sh:
  file.managed:
    - source: salt://scala/files/etc/profile.d/scala.sh
    - user: root
    - group: root
    - mode: 644
