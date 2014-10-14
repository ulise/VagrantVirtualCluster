class salt::master {
    package {'salt-master':
        ensure  => 'latest',
    }

    service {'salt-master':
        ensure  => 'running',
        enable  => true,
        before  => Class['salt::minion'],
        require => File['node0-key',
                        'node1-key',
                        'node2-key',
                        'node3-key',
                        'node4-key'],
    }

    file {'/etc/salt/master':
        ensure  => 'present',
        source  => 'puppet:///modules/salt/etc/salt/master',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        before  => Service['salt-master'],
        require => Package['salt-master'],
    }

    file {'/etc/salt/pki/master/minions/node0':
        ensure  => 'present',
        source  => 'puppet:///modules/salt/etc/salt/pki/minion/node0.pub',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        alias   => 'node0-key',
        before  => Service['salt-master'],
        require => Package['salt-master'],
    }

    file {'/etc/salt/pki/master/minions/node1':
        ensure  => 'present',
        source  => 'puppet:///modules/salt/etc/salt/pki/minion/node1.pub',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        alias   => 'node1-key',
        before  => Service['salt-master'],
        require => Package['salt-master'],
    }
    file {'/etc/salt/pki/master/minions/node2':
        ensure  => 'present',
        source  => 'puppet:///modules/salt/etc/salt/pki/minion/node2.pub',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        alias   => 'node2-key',
        before  => Service['salt-master'],
        require => Package['salt-master'],
    }
    file {'/etc/salt/pki/master/minions/node3':
        ensure  => 'present',
        source  => 'puppet:///modules/salt/etc/salt/pki/minion/node3.pub',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        alias   => 'node3-key',
        before  => Service['salt-master'],
        require => Package['salt-master'],
    }
    file { '/etc/salt/pki/master/minions/node4':
        ensure  => 'present',
        source  => 'puppet:///modules/salt/etc/salt/pki/minion/node4.pub',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        alias   => 'node4-key',
        before  => Service['salt-master'],
        require => Package['salt-master'],
    }
}
