base:
  '*':
    - salt.minion
    - iptables.absent
    - core
    - supervisor
  'node0':
    - salt.master
