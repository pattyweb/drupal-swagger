#!/bin/bash

# Esperar até que o banco de dados esteja disponível
echo "Aguardando o banco de dados..."
until mysql -h "$DRUPAL_DB_HOST" -u "$DRUPAL_DB_USER" -p"$DRUPAL_DB_PASSWORD" -e 'show databases;' > /dev/null 2>&1; do
  echo "Esperando o banco de dados iniciar..."
  sleep 3
done

# Restaurar o banco de dados se o dump existir
if [ -f "/db-dump.sql" ]; then
  echo "Restaurando o banco de dados..."
  mysql -h "$DRUPAL_DB_HOST" -u "$DRUPAL_DB_USER" -p"$DRUPAL_DB_PASSWORD" "$DRUPAL_DB_NAME" < /db-dump.sql
  echo "Banco de dados restaurado."
fi

# Extrair configurações do arquivo config-site.tar.gz
if [ -f "/config-site.tar.gz" ]; then
  echo "Extraindo as configurações exportadas..."
  tar -xzf /config-site.tar.gz -C /var/www/html/sites/default/config/sync
  echo "Configurações extraídas."
fi

# Configurar Redis
if [ -f "/var/www/html/sites/default/settings.php" ]; then
  echo "Configurando Redis no settings.php..."
  cat <<EOT >> /var/www/html/sites/default/settings.php

# Configurações para Redis
\$settings['redis.connection']['interface'] = 'PhpRedis';
\$settings['redis.connection']['host'] = 'redis';
\$settings['cache']['default'] = 'cache.backend.redis';
\$settings['cache_prefix'] = 'drupal_redis_';
\$settings['container_yamls'][] = 'modules/contrib/redis/example.services.yml';
EOT
  echo "Redis configurado."
fi

# Alterar permissões da pasta
chown -R www-data:www-data /var/www/html/sites/default/config/sync

# Iniciar o Apache
echo "Iniciando Apache..."
apache2-foreground
