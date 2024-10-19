# Use a imagem oficial do Drupal
FROM drupal:latest

# Copie o script de inicialização
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

# Dê permissão de execução ao script
RUN chmod +x /usr/local/bin/entrypoint.sh

# Defina o script de inicialização como entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
