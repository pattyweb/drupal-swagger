#!/bin/bash

# Iniciar o Apache em segundo plano
apache2-foreground &

# Esperar o banco de dados estar pronto antes de proceder
until mysql -h db -u drupal -pdrupal -e 'SELECT 1'; do
  echo "Aguardando o banco de dados..."
  sleep 5
done

# Restaurar o banco de dados do dump
if [ -f /db-dump.sql ]; then
  echo "Restaurando o banco de dados..."
  mysql --binary-mode=1 -h db -u drupal -pdrupal drupal < /db-dump.sql
  echo "Banco de dados restaurado."
else
  echo "Dump do banco de dados não encontrado, pulando restauração..."
fi

# Extração de configurações exportadas
if [ -f /config-site.tar.gz ]; then
  echo "Extraindo as configurações exportadas..."
  tar -xzvf /config-site.tar.gz -C /var/www/html/sites/default/config/sync
  echo "Configurações extraídas."
else
  echo "Arquivo de configurações não encontrado, pulando extração..."
fi

# Fim do script, Apache já está rodando em segundo plano
wait -n
