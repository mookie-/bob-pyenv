define pyenv::install (
  Enum['present', 'absent'] $ensure = 'present',
  String $user,
  String $group,
  String $rc_file,
  String $revision = 'master',
  String $git_url  = 'https://github.com/pyenv/pyenv.git',
  Stdlib::Absolutepath $home = "/home/${user}",
) {

  include dependencies::ubuntu

  vcsrepo { "${user}_${git_url}":
    ensure   => $ensure,
    owner    => $user,
    group    => $group,
    provider => 'git',
    source   => $git_url,
    path     => "${home}/.pyenv",
    revision => $revision,
  }

  file_line { "source_pyenvrc_for_${user}":
    ensure => $ensure,
    path   => "${home}/.profile",
    line   => 'source ${HOME}/.pyenvrc',
  }

  file { "${home}/.pyenvrc":
    ensure => $ensure,
    source => 'puppet:///modules/pyenv/pyenvrc',
    owner  => $user,
    group  => $group,
    mode   => '0640',
  }
}
