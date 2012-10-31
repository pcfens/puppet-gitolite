# == Class: gitolite
#
# This class installs gitolite and sets the first key
#
# === Parameters:
#
#   [*keycontent*]
#      the first ssh key that has full access to the gitolite-admin repository (required)
#   [*keyname*]
#     The name of the SSH key to use for the keycontent (default: default)
#   [*user*]
#     gitolite management user (default: gitolite)
#   [*password*]
#     hashed password of gitolite user - if undefined then the class will assume the user already exists
#   [*homedir*]
#     home directory of gitolite management user (default: /var/gitolite)
#   [*version*]
#     tag, branch, or commit of gitolite revision to clone from github (default: v3.1)
#
# === Examples
#
#   class gitolite {
#     keycontent => 'ssh-rsa bo8O...cyLSJh git-admin',
#   }
#
#   class gitolite {
#     user       => 'git',
#     homedir    => '/var/git',
#     password   => '!',
#     keycontent => 'ssh-rsa bo8O...cyLSJh git-admin',
#     keyname    => 'my-user',
#   }
#
# === Authors
# 
# Phil Fenstermacher <pcfens@wm.edu>
# Based on work by Steve Huff <steve_huff@harvard.edu>
# and Oleg Chunikhin <oleg.chunikhin@gmail.com>
#
#
class gitolite (
  $keycontent,
  $keyname = 'default',
  $user = 'gitolite',
  $password = 'undef',
  $homedir = '/var/gitolite',
  $version = 'v3.1',
) {

  $gitpkg = $::operatingsystem ? {
    /(?i:redhat|centos|fedora)/ => 'git',
    /(?i:debian|ubuntu)/        => 'git-core',
    default                     => 'git',
  }

  package { $gitolite::gitpkg:
    ensure => latest,
  }

  if $gitolite::password != 'undef' {
    group { $gitolite::user:
      ensure => present,
    }

    user { $gitolite::user:
      ensure     => present,
      require    => Group[$gitolite::user],
      comment    => 'Gitolite Hosting',
      gid        => $gitolite::user,
      home       => $gitolite::homedir,
      password   => $gitolite::password,
      system     => true,
      managehome => true,
    }
  }

  vcsrepo { '/usr/src/gitolite':
    ensure   => present,
    provider => git,
    source   => 'http://github.com/sitaramc/gitolite.git',
    revision => $gitolite::version,
    owner    => 'root',
    group    => 'root',
    require  => Package[$gitolite::gitpkg],
  }

  file { "${gitolite::homedir}/${gitolite::keyname}.pub":
    ensure  => file,
    owner   => $gitolite::user,
    group   => $gitolite::user,
    content => $gitolite::keycontent,
    mode    => '0640',
    require => User[$gitolite::user],
  }

  exec { 'gitolite/install':
    require     => [
      File["${gitolite::homedir}/${gitolite::keyname}.pub"], 
      Vcsrepo['/usr/src/gitolite'] 
    ],
    command     => "/usr/src/gitolite/install -ln /usr/local/bin",
    user        => 'root',
    group       => 'root',
    subscribe   => Vcsrepo['/usr/src/gitolite'],
    logoutput   => 'on_failure',
    path        => ['/usr/local/sbin', '/usr/local/bin', '/usr/sbin', '/usr/bin', '/sbin', '/bin'],
    refreshonly => true,
  }

  exec { 'gitolite_setup':
    require     => [ 
      File["${gitolite::homedir}/${gitolite::keyname}.pub"], 
      Vcsrepo['/usr/src/gitolite'], 
      Exec['gitolite/install'] 
    ],
    environment => [
      "HOME=${gitolite::homedir}",
      "USER=${gitolite::user}",
    ],
    subscribe   => File["${gitolite::homedir}/${gitolite::keyname}.pub"],
    command     => "gitolite setup -pk ${gitolite::keyname}.pub",
    cwd         => $gitolite::homedir,
    user        => $gitolite::user,
    group       => $gitolite::user,
    logoutput   => 'on_failure',
    path        => ['/usr/local/sbin', '/usr/local/bin', '/usr/sbin', '/usr/bin', '/sbin', '/bin'],
    refreshonly => true,
  }
}
