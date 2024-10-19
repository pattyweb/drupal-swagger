# Use a imagem oficial do Drupal como base
FROM drupal:latest

# Instale o Redis e habilite a extensão do Redis no PHP
RUN apt-get update && apt-get install -y libz-dev libpq-dev \
    && pecl install redis \
    && docker-php-ext-enable redis

# Copie o script de inicialização para o contêiner
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

# Copie o arquivo do dump do banco de dados
COPY ./web/sites/default/config/sync/db-dump.sql /db-dump.sql

# Dê permissão de execução ao script
RUN chmod +x /usr/local/bin/entrypoint.sh

# Use o script como entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Exponha a porta padrão do Apache
EXPOSE 80
