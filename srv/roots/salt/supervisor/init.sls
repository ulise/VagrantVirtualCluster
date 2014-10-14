include:
  - core

supervisor:
  pip.installed:
    - require:
      - pkg: base_packages

/etc/supervisord.conf:
  file.managed:
    - source: salt://supervisor/files/etc/supervisord.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pip: supervisor

/etc/init.d/supervisord:
  file.managed:
    - source: salt://supervisor/files/etc/init.d/supervisord
    - user: root
    - group: root
    - mode: 744
    - require:
      - pip: supervisor

{% for dir in ['/var/log/supervisor', '/etc/supervisord.d'] %}
{{ dir }}:
  file.directory:
    - user: root
    - group: root
    - mode: 700
    - require:
      - pip: supervisor
{% endfor %}

supervisord:
  service:
    - running
    - enable: true
    - watch:
      - file: /etc/supervisord.conf
      - file: /etc/supervisord.d/*
    - require:
      - file: /etc/init.d/supervisord
      - file: /var/log/supervisor
      - file: /etc/supervisord.conf
      - file: /etc/supervisord.d
