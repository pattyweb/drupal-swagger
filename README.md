# README

## 1. Configuração Docker

### Passos para Clonar e Configurar o Projeto com Docker:

1. **Clonar o repositório**:
   
   ```bash
   git clone https://github.com/pattyweb/drupal-swagger.git
   cd drupal-swagger
   ```

2. **Construir e iniciar o projeto com Docker**:
   
   Execute o comando abaixo para construir a imagem do Drupal e iniciar o ambiente:

   ```bash
   docker-compose build
   docker-compose up -d
   ```

3. **URL**:

   Após a criação do ambiente, a aplicação estará disponibilizada em:

   ```bash
   http://localhost:8080/
   ```
   
4. **Senha e usuário do admin**:

   Senha e usuário da aplicação:

   ```bash
   User: Admin
   Senha: CasesTesteL2@
   ```

## 2. Página que Mostra os Cases Cadastrados

Para visualizar os **cases** cadastrados, acesse a URL no seu navegador após iniciar o ambiente Docker:

- **URL**: [http://localhost:8080/lista-de-cases](http://localhost:8080/lista-de-cases)

Essa página lista todos os **cases** previamente cadastrados no sistema.

## 3. Admin para Cadastro de Cases em Drupal

Para cadastrar um novo **case**, siga os seguintes passos no painel administrativo do Drupal:

1. Faça login como administrador.
2. No menu superior, navegue até **Gerenciar** > **Conteúdo** > **Adicionar Conteúdo**.
3. Clique em **Case** para criar um novo conteúdo do tipo **Case**.

Preencha os campos necessários e salve o conteúdo para que ele apareça na lista de cases.

## 4. Criar uma API com Swagger

Para gerar e explorar a documentação da API dos **cases** usando **Swagger**, siga os passos abaixo:

1. No painel administrativo do Drupal, vá até **Configurações** > **openAPI**.
2. Clique em **Explore with Redoc** para visualizar a documentação dos endpoints.

O endpoint para acessar a API dos **cases** é:

- **Endpoint API dos Cases**: [http://localhost:8080/jsonapi/node/case](http://localhost:8080/jsonapi/node/case)

Esse endpoint retorna os **cases** em formato JSON, ideal para consumo por outras aplicações.

## 5. Segurança na Autenticação da API

A API está protegida por **HTTP Basic Authentication**. Para acessar os endpoints da API, é necessário estar logado com um usuário válido. Aqui está o fluxo básico de autenticação:

1. Ao tentar acessar qualquer endpoint da API, como `http://localhost:8080/jsonapi/node/case`, o sistema solicitará suas credenciais.
2. Forneça o **usuário** e **senha** cadastrados no sistema Drupal para autenticação.

Isso garante que somente usuários autenticados possam acessar os dados expostos pela API.

## 6. Configuração de Cache (Redis)

O Redis é utilizado como sistema de cache para melhorar o desempenho da aplicação. A configuração do Redis foi feita no arquivo de configuração do **settings.php** do Drupal. Aqui estão alguns detalhes sobre a configuração:

### Configuração Básica do Redis

1. O Redis está habilitado e configurado para funcionar como backend de cache do Drupal.
2. No menu superior, navegue até **Gerenciar** > **Relatórios** > **Redis** , para ver respectivas configurações e relatório.
3. A configuração está definida no arquivo `settings.php` como segue:

```php
$settings['redis.connection']['interface'] = 'PhpRedis';
$settings['redis.connection']['port'] = 6379;
$settings['cache']['default'] = 'cache.backend.redis';
$settings['cache_prefix'] = 'drupal_redis_';
```

### Vantagens do Redis

- Melhora o tempo de resposta do sistema ao reduzir a necessidade de consultas ao banco de dados para informações frequentemente solicitadas.
- Permite maior escalabilidade em ambientes de produção, garantindo que a aplicação Drupal mantenha alta performance mesmo com grande volume de acessos.

O Redis é configurado automaticamente quando o contêiner é iniciado, não sendo necessária nenhuma configuração adicional por parte do usuário.

---

Com essas instruções, você poderá configurar, visualizar e interagir com a aplicação Drupal, cadastrando **cases**, explorando a **API** e garantindo que o sistema esteja funcionando de forma otimizada com **Redis** e **Swagger** para documentação da API.
