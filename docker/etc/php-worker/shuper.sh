supervisord -c /etc/supervisor/supervisord.conf
supervisorctl -c /etc/supervisor/supervisord.conf reload
supervisorctl -c /etc/supervisor/supervisord.conf start laravel-worker:*
