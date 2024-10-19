#!/bin/bash

# Caminho onde o arquivo de configuração exportado está armazenado (na raiz da aplicação)
CONFIG_ARCHIVE="/config.tar.gz"

# Verificar se o arquivo de configuração existe
if [ -f "$CONFIG_ARCHIVE" ]; then
  echo "Arquivo de configuração encontrado: $CONFIG_ARCHIVE"

  # Extrair o arquivo de configuração para o diretório de sincronização do Drupal
  tar -xzf $CONFIG_ARCHIVE -C /var/www/html/sites/default/config/sync/

  echo "Configurações extraídas com sucesso."

  # Aguarde até que o banco de dados esteja pronto
  until mysql -h $DRUPAL_DB_HOST -u $DRUPAL_DB_USER -p$DRUPAL_DB_PASSWORD $DRUPAL_DB_NAME; do
    echo "Esperando pelo banco de dados..."
    sleep 3
  done

  # Importar as configurações do Drupal
  cd /var/www/html/web
  php core/scripts/drupal quick-start --no-interaction

  # Importar configurações usando API do Drupal
  php -r "
  use Drupal\Core\DrupalKernel;
  use Symfony\Component\HttpFoundation\Request;

  require_once 'autoload.php';
  $autoloader = require_once 'autoload.php';
  $request = Request::createFromGlobals();
  $kernel = DrupalKernel::createFromRequest($request, $autoloader, 'prod');
  $kernel->boot();

  // Importar configurações
  \$configImporter = \Drupal::service('config.manager')->getImporter();
  \$configImporter->import();
  echo 'Configurações importadas com sucesso.';
  "

else
  echo "Nenhum arquivo de configuração encontrado em $CONFIG_ARCHIVE"
fi

# Iniciar o Apache (ou outro servidor web)
apache2-foreground
