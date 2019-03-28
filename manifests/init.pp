#
# == Class: bash_prompt
#
# Set root user's prompt so that it shows a prefix (defaults to $::deployment) 
# and an optional suffix. This helps avoid working on the wrong server when 
# several different deployments (e.g. production/staging/development) include
# identical or nearly identical nodes.
#
# == Parameters
#
# [*prefix*]
#   First part of the prompt. Defaults to $::deployment, but can be overridden.
# [*suffix*]
#   Second part of the prompt separated from the prefix with a dash. For example 
#   'cloud'.
#
class bash_prompt
(
  String           $prefix = $::deployment,
  Optional[String] $suffix = undef
)
{

  # On CentOS we don't want to remove root's .bashrc as that resets root's bash 
  # into really barebone settings. On Ubuntu (and probably Debian) using the 
  # system-wide /etc/bash.bashrc allows the correct prompt to show when using
  # "sudo -s" as well as "sudo -i". Modifying just /root/.bashrc would only
  # show the prompt with "sudo -i".
  # 
  if $::osfamily == 'Debian' {
    file { '/root/.bashrc':
      ensure  => 'absent',
    }
  }

  $bashrc_file = $::osfamily ? {
    'RedHat' => '/root/.bashrc',
    'Debian' => '/etc/bash.bashrc',
  }

  $prompt_string = $suffix ? {
    undef   => $prefix,
    default => "${prefix}-${suffix}",
  }

  file_line { 'show-deployment-in-root-prompt':
    ensure => 'present',
    path   => $bashrc_file,
    line   => "export PS1=\"(${prompt_string}) \u@\h:\w\$ \"",
  }
}
