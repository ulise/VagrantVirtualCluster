base:
  '*':
    - salt.minion
    - iptables.absent
    - core
    - zookeeper
    - hadoop
    - supervisor
    - kafka
    - spark
    - cassandra
    - hbase
  'node0':
    - salt.master
