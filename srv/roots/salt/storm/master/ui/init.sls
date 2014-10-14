include:
  - storm
  - supervisor

/etc/supervisord.d/storm_ui.conf:
  file.managed:
    - source: salt://storm/files/etc/supervisord.d/storm_ui.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: /etc/supervisord.d
      - sls: storm
