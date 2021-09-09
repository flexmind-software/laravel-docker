#!/bin/bash

# Add helpers
echo 'exec php artisan "$@"' > /usr/local/bin/artisan
echo 'exec php artisan tinker' > /usr/local/bin/tinker
echo 'exec php -d memory_limit=-1 /usr/local/bin/composer "$@"' > /usr/local/bin/ncomposer
# sed -i '1s;^;#!/bin/bash\n[ "$PWD" != "/var/www/html" ] \&\& echo " - Helper must be run from /var/www/html" \&\& exit 1\n;' /usr/local/bin/artisan /usr/local/bin/tinker
chmod +x /usr/local/bin/artisan /usr/local/bin/tinker /usr/local/bin/ncomposer
