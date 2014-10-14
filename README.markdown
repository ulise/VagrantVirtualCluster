# README #

This is a N-node Vagrant Virtual Cluster, where N=5. It's intended to be used
for testing Hadoop and Hadoop related technologies.

Changing the size of the cluster is certainly possible, but not documented.

## Overview ##

The `Vagrantfile` specifies five (5) VM's that will be created when `vagrant
up` is called. Once all the nodes are up, another command needs to be executed:

    (@host)$ vagrant ssh node0
    (@node0)$ sudo salt '*' state.highstate

Salt will provision all the nodes and bring them to their proper state.

## Hadoop ##

To add Hadoop to the cluster, add the `hadoop` state to the `top.sls` file.
Once provisioned, remember to format the HDFS space and start the services:

    (@host)$ vagrant ssh node0
    (@node0)$ sudo salt '*' state.highstate
    (@node0)$ sudo su - hadoop
    (hadoop@node0)$ hdfs namenode -format
    (hadoop@node0)$ start-dfs.sh
    (hadoop@node0)$ start-yarn.sh

Once HDFS is started, pointing your browser to `http://localhost:50070` should
bring you to the HDFS status page.

Similarly, once YARN is finished starting, pointing your browser to
`http://localhost:8088` should give you the YARN web interface.

## Zookeeper ##

Zookeeper can be installed on all nodes by including the `zookeeper` state in
the `top.sls` file.

## Storm Cluster ##

To add Storm to the cluster, add Zookeeper, add the `storm.master` state to the
master node and add `storm.minion` to the worker nodes.

## Spark Cluster ##

To add Spark to the cluster, add the `spark` state to the `top.sls` file.

Spark is configured to use Hadoop YARN. Nothing needs to be done here except
when launching your Spark applications. I.e., to start `spark-shell`, first
ensure HDFS and YARN are running, then:

    (@node0)$ sudo su - spark
    (@node0)$ spark-shell --master yarn-client

This should start up the Spark interactive Scala shell for interactive
analysis.

### Memory Requirements ###

Spark likes a lot of memory, so you may have to disable Storm to get Spark
applications to run. This can be accomplished in one of two ways. 1, before
provisioning all the nodes, modify `srv/roots/salt/top.sls` and remove the
lines containing `storm`. This will likely cause a failure in provisioning
(specifically related to `supervisord`) this is safe to ignore. 2, running a
manual provisioning step that will stop Storm cluster from running. However,
notice, if you ever run `state.highstate` again, Storm will be restarted:

    (@node)$ sudo salt '*' cmd.run 'service supervisord stop'

Notice, this command will also stop Zookeeper, as Zookeeper is using
`supervisord` to run as well.

## Kafka ##

To add Kafka to the cluster, add the `kafka` state to the `top.sls` file.

Before you can send or receive messages from Kafka, you will need to create a
topic. This is easy, but is a manual step at the moment:

    (@host)$ vagrant ssh node0
    (@node0)$ sudo su - kafka
    (kafka@node0)$ cd /opt/kafka/bin
    (kafka@node0)$ ./kafka-topics.sh --create \
      --topic {yourtopic} \
      --partitions {partition count} \
      --replication-factor 1 \
      --zookeeper node0:2181

After this is done, you should be able to send messages to the Kafka broker
using this topic, and similarly be able to consume them from this broker.

## License ##

The code and configurations in this project are made available without warranty
under the terms and conditions of the GNU Public License (v3 or later). For
more information, please see the LICENSE file or, if you did not receive such a
file, [GNU GPL][1].

[1]: http://www.gnu.org/copyleft/gpl.html
