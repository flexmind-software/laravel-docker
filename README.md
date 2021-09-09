# Flexmind Laravel Docker

Docker - Base structure for Laravel

## Supported Services
- Apache2
- Percona
- PHP
- Redis
- Mailcatcher
- Adminer

## Configuration

### Apache

For set your vhost please copy file `./etc/apache2/sites/example.test.conf.example` to equivalent of your domain eg.: flexmind.pl file will be name `flexmind.pl.conf`. 

In new file change all occurance name `example.test` to your domain!

### PHP

By default, the latest stable PHP version is configured to run.

The PHP-FPM is responsible for serving your application code, you don’t have to change the PHP-CLI version if you are planning to run your application on different PHP-FPM version.

For change version please open `.env`, and set the desired version number to `PHP_VERSION` variable
