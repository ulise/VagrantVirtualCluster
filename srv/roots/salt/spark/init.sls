{% from "spark/map.jinja" import spark with context %}
include:
  - core

spark:
  group.present:
    - name: spark
    - system: true
  user.present:
    - name: spark
    - shell: /bin/bash
    - home: /home/spark
    - groups:
      - spark
    - require:
      - group: spark
      - file: /etc/skel/.ssh
  file.managed:
    - name: /home/spark/.bashrc
    - source: salt://spark/files/home/spark/bashrc
    - require:
      - user: spark

spark_install:
  archive:
    - extracted
    - name: /opt/
    - source: http://apache.claz.org/spark/spark-{{spark.version}}/spark-{{spark.version_full}}.tgz
    - source_hash: "md5={{spark.checksum}}"
    - archive_format: tar
    - tar_options: z
    - if_missing: /opt/spark-{{spark.version_full}}

/opt/spark-{{spark.version_full}}:
  file.directory:
    - user: spark
    - group: spark
    - recurse:
      - user
      - group
    - require:
      - archive: spark_install
      - user: spark

/opt/spark:
  file.symlink:
    - target: /opt/spark-{{spark.version_full}}
    - user: spark
    - group: spark
    - recurse:
      - user
      - group
    - require:
      - user: spark
      - archive: spark_install

{% for file in ['log4j.properties',
                'spark-defaults.conf',
                'spark-env.sh',
                'slaves',
                'metrics.properties',
                'fairscheduler.xml'] %}
/opt/spark/conf/{{ file }}:
  file.managed:
    - source: salt://spark/files/opt/spark/conf/{{ file }}
    - user: spark
    - group: spark
    - mode: 644
    - require:
      - user: spark
      - file: /opt/spark
{% endfor %}
