# puppet-bash_prompt

Simple module for configuring (root's) bash prompt so that it shows where the
user "is" in the sense of deployment (e.g. production, staging, development).
This increases usability and avoid having to spend time debugging why things
are not working when one has simply logged into the wrong computer.

# Module usage

By default this module will add the value of $::deployment fact to the prompt
surrounded by parentheses, e.g.

    (staging) root@server:~$

The deployment fact can generally be an external (yaml) fact created during
provisioning. If you don't have or want to use one, you can override it with
$prefix and optionally add a suffix while you're at it:

    class { 'bash_prompt':
      prefix => 'production',
      suffix => 'cloud',
    }

In the above case the prompt will look like this:

    (production-cloud) root@server:~$
