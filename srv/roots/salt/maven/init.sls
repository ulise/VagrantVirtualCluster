{% from "maven/map.jinja" import maven with context %}

maven_install:
  archive:
    - extracted
    - name: /opt/
    - source: http://apache.claz.org/maven/maven-3/{{maven.version}}/binaries/apache-maven-{{maven.version}}-bin.tar.gz
    - source_hash: "md5={{maven.checksum}}"
    - archive_format: tar
    - tar_options: z
    - if_missing: /opt/apache-maven-{{maven.version}}

/opt/apache-maven-{{maven.version}}:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - recurse:
      - user
      - group
      - mode
    - require:
      - archive: maven_install

/opt/maven:
  file.symlink:
    - target: /opt/apache-maven-{{maven.version}}
    - user: root
    - group: root
    - mode: 755
    - recurse:
      - user
      - group
      - mode

/etc/profile.d/maven.sh:
  file.managed:
    - source: salt://maven/files/etc/profile.d/maven.sh
    - user: root
    - group: root
    - mode: 644
