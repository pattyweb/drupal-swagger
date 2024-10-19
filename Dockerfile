# Use a imagem oficial do Drupal como base
FROM drupal:latest

# Instale o Redis e habilite a extensão do Redis no PHP
RUN apt-get update && apt-get install -y libz-dev libpq-dev \
    && pecl install redis \
    && docker-php-ext-enable redis

# Expor a porta padrão do Apache
EXPOSE 80
