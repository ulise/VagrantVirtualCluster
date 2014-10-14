class salt::minion {
    package {'salt-minion':
        ensure  => 'latest',
    }

    service {'salt-minion':
        ensure  => 'running',
        enable  => true,
        require => File['/etc/salt/minion',
                        '/etc/salt/pki/minion/minion.pem',
                        '/etc/salt/pki/minion/minion.pub'],
    }

    file {'/etc/salt/minion':
        notify  => Service['salt-minion'],
        ensure  => 'present',
        content => template('salt/etc/salt/minion.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '644',
        before  => Service['salt-minion'],
        require => Package['salt-minion'],
    }

    file {"/etc/salt/pki/minion/minion.pem":
        notify  => Service['salt-minion'],
        ensure  => 'present',
        source  => "puppet:///modules/salt/etc/salt/pki/minion/$hostname.pem",
        owner   => 'root',
        group   => 'root',
        mode    => '0600',
        before  => Service['salt-minion'],
        require => Package['salt-minion'],
    }

    file {"/etc/salt/pki/minion/minion.pub":
        notify  => Service['salt-minion'],
        ensure  => 'present',
        source  => "puppet:///modules/salt/etc/salt/pki/minion/$hostname.pub",
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        before  => Service['salt-minion'],
        require => Package['salt-minion'],
    }
}
