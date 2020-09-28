/var/log/slurm/*.log {
      weekly
      compress
      missingok
      nocopytruncate
      nodelaycompress
      nomail
      notifempty
      noolddir
      rotate 8
      sharedscripts
      size=5M
      create 640 slurm root
      postrotate
              pkill -x --signal SIGUSR2 slurmctld
              pkill -x --signal SIGUSR2 slurmd
              pkill -x --signal SIGUSR2 slurmdbd
              exit 0
      endscript
}
