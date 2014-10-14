/etc/salt/minion:
  file.managed:
    - source: salt://salt/files/etc/salt/minion
    - template: jinja
    - user: root
    - group: root
    - mode: 644
