include:
  - kafka
  - supervisor

/etc/supervisord.d/kafka_broker.conf:
  file.managed:
    - source: salt://kafka/files/etc/supervisord.d/kafka_broker.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: /etc/supervisord.d
      - sls: kafka

/opt/kafka/config/server.properties:
  file.managed:
    - source: salt://kafka/files/opt/kafka/config/server.properties
    - user: kafka
    - group: kafka
    - mode: 644
    - template: jinja
    - require:
      - file: /opt/kafka
