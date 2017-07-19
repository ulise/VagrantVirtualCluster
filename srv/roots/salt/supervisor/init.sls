include:
  - core

supervisor:
  pkg.installed:
    - require:
      - pkg: base_packages
  service:
    - running
    - enable: true
    - watch:
      - file: /etc/supervisor/supervisord.conf
      - file: /etc/supervisor/conf.d/*
    - require:
      - file: /etc/supervisor/supervisord.conf

/etc/supervisor/supervisord.conf:
  file.managed:
    - source: salt://supervisor/files/etc/supervisord.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: supervisor


