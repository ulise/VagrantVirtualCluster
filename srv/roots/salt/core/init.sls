base_packages:
  pkg.latest:
    - pkgs:
      - vim-enhanced
      - git
      - curl
      - rsync
      - unzip
      - tree
      - nc
      - java-1.7.0-openjdk
      - java-1.7.0-openjdk-devel
      - java-1.7.0-openjdk-src
      - python
      - python-pip

/etc/skel/.ssh:
  file.recurse:
    - source: salt://core/files/ssh
    - user: root
    - group: root
    - file_mode: 600
    - dir_mode: 700
    - recurse:
      - user
      - group
