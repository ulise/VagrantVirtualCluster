/etc/salt/master:
  file.managed:
    - source: salt://salt/files/etc/salt/master
    - user: root
    - group: root
    - mode: 644
