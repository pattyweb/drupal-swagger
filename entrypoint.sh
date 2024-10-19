#!/bin/bash

# Verifica se o banco de dados já foi populado
if ! drush sql-query "SHOW TABLES;" | grep -q "users"; then
  echo "Restaurando o banco de dados..."
  # Restaura o dump do banco de dados
  if [ -f /db-dump.sql ]; then
    drush sql-cli < /db-dump.sql
    echo "Banco de dados restaurado."
  fi

  echo "Extraindo as configurações exportadas..."
  # Extrai as configurações exportadas
  tar -xzf /config-site.tar.gz -C /var/www/html/sites/default/config/sync
  echo "Configurações extraídas."

  echo "Importando configurações sincronizadas..."
  drush cim sync -y
  echo "Configurações importadas."
else
  echo "Banco de dados já populado. Pulando restauração."
fi

# Limpa o cache do Drupal
drush cr

# Inicia o Apache (mantém o container rodando)
exec apache2-foreground
