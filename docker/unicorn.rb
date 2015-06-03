# Set the working application directory
# working_directory "/path/to/your/app"
working_directory "/usr/src/opengeometadata-rails"

# Unicorn PID file location
# pid "/path/to/pids/unicorn.pid"
pid "/var/www/ogm/pids/unicorn.pid"

# Path to logs
# stderr_path "/path/to/log/unicorn.log"
# stdout_path "/path/to/log/unicorn.log"
stderr_path "/var/www/ogm/log/unicorn.log"
stdout_path "/var/www/ogm/log/unicorn.log"

# Unicorn socket
#listen "/tmp/unicorn.[app name].sock"
listen "/tmp/unicorn.ogm.sock"
listen "0.0.0.0:3000", :tcp_nopush => true

# Number of processes
# worker_processes 4
worker_processes 2

# Time-out
timeout 30