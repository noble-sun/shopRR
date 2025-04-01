# ShopRR

[![en](https://img.shields.io/badge/lang-en-red)](https://github.com/noble-sun/shopRR/blob/main/README.md)

Um ***Shop*** online feito com ***R***uby on ***R***ails.

# Stack Tecnológica
- **Controle de Versão**: [Git](https://git-scm.com/)
- **Linguagem:** [Ruby 3.4.1](https://www.ruby-lang.org/en/downloads/)
- **Framework:** [Rails 8.0.1](https://rubyonrails.org/)
- **Banco de Dados:** [PostgreSQL 17.2](https://www.postgresql.org/download/)
- **Gerenciamento de Imagens:** [ActiveStorage](https://guides.rubyonrails.org/active_storage_overview.html)
- **Containerização:** [Docker](https://www.docker.com/get-started/) e [Docker Compose](https://docs.docker.com/compose/)
- **Autenticação:** [Google Oauth2](https://developers.google.com/identity/openid-connect/openid-connect)
- **Testes:** [Rspec](https://rspec.info/)

# Construção e Instalação

### Pré-requisitos
1. Instale o [git](https://git-scm.com/downloads).
2. Instale o [Docker](https://docs.docker.com/get-started/get-docker/) e o [Docker Compose](https://docs.docker.com/compose/install/).
3. Configure as variáveis de ambiente

    - ```
      cp .env.example .env
      ```
4. Configure o ID do Cliente e a Chave secreta do Cliente da Google

    - Acesse o [Google Cloud Console](https://console.cloud.google.com)
    - Selecione seu projeto ou [crie](https://developers.google.com/workspace/guides/create-project) um novo
    - Acesse [APIs e Serviços](https://console.cloud.google.com/apis) e depois vá para **Credenciais**
        - Clique em **Criar credenciais** e selecione **ID do cliente OAuth**
            - Em tipo de aplicativo, selecione **Aplicativo web**
            - Escolha o nome que preferir
            - Em **URIs de redirecionamento autorizados** adicione a URI `http://localhost:3000/auth/google/callback`
            - Copie o ID do cliente e o segredo do cliente para **GOOGLE_CLIENT_ID** e **GOOGLE_CLIENT_SECRET** no arquivo **.env**

# Executar o Projeto
- Dentro do diretório do projeto *shoprr*
- Construa o contêiner da aplicação
    ```bash
    docker compose build
    ```
- Entre no contêiner com o comando:
    ```bash
    docker compose run --rm --service-ports web bash
    ```
    - Execute as migrações e as sementes do banco de dados
        ```bash
        rails db:setup
        ```
    - Inicie o servidor com **`rails s -b 0`** ou **`bin/dev`**
    - Para acessar a aplicação:
        ```bash
        http://localhost:300
        ```
        - Você pode criar um novo usuário ou fazer login com o Google, ou usar os usuários existentes abaixo:
            ```bash
            email: buyer@email.com
            senha: Senha@123
            
            email: seller@email.com
            senha: Senha@123
            ```

# Testes
Para executar os testes, entre no contêiner:
```bash
docker compose run --rm --service-ports web bash
```

Execute o comando para rodar todos os testes:
```bash
rspec
```

# O que vem a seguir para o Shoprr
- [x] Login com Google
- [ ] Fluxo de checkout completo
- [ ] Cupons
- [ ] Área do vendedor
- [ ] Favoritar produtos
- [ ] Métodos de pagamento
- [ ] Categorias de produtos
- [ ] Tamanhos de produtos
- [ ] Variações de produtos
- [x] Avaliação e comentários de produtos
- [x] Seleção de idioma
---
