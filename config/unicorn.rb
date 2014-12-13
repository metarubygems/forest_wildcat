# Minimal sample configuration file for Unicorn (not Rack) when used
# with daemonization (unicorn -D) started in your working directory.
#
# See http://unicorn.bogomips.org/Unicorn/Configurator.html for complete
# documentation.
# See also http://unicorn.bogomips.org/examples/unicorn.conf.rb for
# a more verbose configuration using more features.

# FIXME: Use env and spread by capistrano
listen 2007 # by default Unicorn listens on port 8080
listen '/path/to/app/shared/tmp/sockets/unicorn.sock', backlog: 64
worker_processes 2 # this should be >= nr_cpus
pid '/path/to/app/shared/pids/unicorn.pid'
stderr_path '/path/to/app/shared/log/unicorn.log'
stdout_path '/path/to/app/shared/log/unicorn.log'
