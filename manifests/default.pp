node default {
    service {'iptables':
        ensure  => 'stopped',
        enable  => false,
    }
    file {'/etc/hosts':
        ensure  => 'present',
        mode    => '0644',
        owner   => 'root',
        group   => 'root',
        content => "127.0.0.1 localhost
10.1.1.10 node0
10.1.1.11 node1
10.1.1.12 node2
10.1.1.13 node3
10.1.1.14 node4",
    }
    file {'/etc/hostname':
        ensure  => 'present',
        mode    => '0644',
        owner   => 'root',
        group   => 'root',
        content => inline_template("<%= @hostname %>"),
    }
    include salt::minion
}

node "node0" inherits default {
    include salt::master
}

node "node1", "node2", "node3", "node4" inherits default {
    service {'salt-master':
        ensure  => 'stopped',
        enable  => false,
    }
}
