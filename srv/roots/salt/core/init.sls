base_packages:
  pkg.latest:
    - pkgs:
      - vim
      - git
      - curl
      - rsync
      - unzip
      - tree
      - netcat
      - openjdk-8-jdk-headless
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
