define pyenv::compile (
  $user,
  $group,
  $version,
  $home = "/home/${user}",
) {

  exec { "update_pyenv_for_${user}":
    command => 'git pull -q',
    user    => $user,
    group   => $group,
    path    => ['/usr/bin', '/usr/sbin', '/sbin', '/bin'],
    cwd     => "${home}/.pyenv",
    creates => "${home}/.pyenv/plugins/python-build/share/python-build/${version}",
    require => Class['Pyenv::Install'],
  }

  exec { "compile_python_${version}_for_${user}":
    command => "${home}/.pyenv/bin/pyenv install ${version}",
    user    => $user,
    group   => $group,
    path    => ['/usr/bin', '/usr/sbin', '/sbin', '/bin'],
    cwd     => $home,
    creates => "${home}/.pyenv/versions/${version}/bin/python",
    require => Exec["update_pyenv_for_${user}"],
  }
}
