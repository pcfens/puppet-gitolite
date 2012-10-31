# gitolite puppet module

## Overview

Installs [gitolite](http://sitaramc.github.com/gitolite).

### class gitolite

Parameters:
* keycontent - the first ssh key that has full access to the gitolite-admin repository (required)
* keyname - The name of the SSH key to use for the keycontent (default: default)
* user - gitolite management user (default: gitolite)
* password - hashed password of gitolite user - if undefined then the class will assume the user already exists
* homedir - home directory of gitolite management user (default: /var/gitolite)
* version - tag, branch, or commit of gitolite revision to clone from github (default: v3.1)

Examples:

    class gitolite {
      keycontent => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJjq3GcTvIUVmvsTbhcD32rRegW6HxJIrEDC4QtWW38y789Q9Z88C00gclytKmccLx7Ekei3bz5AOG/vxb1N3LqVHWeNJU0nOl6Bf2Og8wQ89ZKS56VnvlpgKSAYMsTbAQDvIl1DJIDW2mF08ccE23kuRsfAMnGAbO/DxrVGmCdkKpttNtQ5aopm+X5KMccrehUDJcJJcJ3Khzs6c2opN3cW0b5JodP2CPdPcD7qrLdPHDlWIwAKLKN6/N/Z94dpfELePiJYIXfGu1wnCpDcwEQZpNeLtqQ0SgnAF4LGU8A6Ifgk8W0SyLr1yl0Rz+j3v8Tu5hFv1Ic+bo8OcyLSJh git-admin',
    }

    class gitolite {
      user           => 'git',
      homedir        => '/var/git',
      password       => '!'
      keycontent => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJjq3GcTvIUVmvsTbhcD32rRegW6HxJIrEDC4QtWW38y789Q9Z88C00gclytKmccLx7Ekei3bz5AOG/vxb1N3LqVHWeNJU0nOl6Bf2Og8wQ89ZKS56VnvlpgKSAYMsTbAQDvIl1DJIDW2mF08ccE23kuRsfAMnGAbO/DxrVGmCdkKpttNtQ5aopm+X5KMccrehUDJcJJcJ3Khzs6c2opN3cW0b5JodP2CPdPcD7qrLdPHDlWIwAKLKN6/N/Z94dpfELePiJYIXfGu1wnCpDcwEQZpNeLtqQ0SgnAF4LGU8A6Ifgk8W0SyLr1yl0Rz+j3v8Tu5hFv1Ic+bo8OcyLSJh git-admin',
    }

## Supported Platforms

* Debian
* Ubuntu
* RHEL 6
