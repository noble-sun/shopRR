# ShopRR

A online ***Shop*** made with ***R***uby on ***R***ails.

# Tech Stack
- **Version Control**: [Git](https://git-scm.com/)
- **Language:** [Ruby 3.4.1](https://www.ruby-lang.org/en/downloads/)
- **Framework:** [Rails 8.0.1](https://rubyonrails.org/)
- **Database:** [PostgreSQL 17.2](https://www.postgresql.org/download/)
- **Image Management:** [ActiveStorage](https://guides.rubyonrails.org/active_storage_overview.html)
- **Containerization:** [Docker](https://www.docker.com/get-started/) and [Docker Compose](https://docs.docker.com/compose/)
- **Authentication:** [Google Oauth2](https://developers.google.com/identity/openid-connect/openid-connect)
- **Tests:** [Rspec](https://rspec.info/)

# Build and Instalation

### Prerequisites
1. Install [git](https://git-scm.com/downloads).
2. Install [Docker](https://docs.docker.com/get-started/get-docker/) and [Docker Compose](https://docs.docker.com/compose/install/).
3. Configure env variables

    - ```
      cp .env.example .env
      ```
4. Configure Google Client ID and Client Secret

    - Enter [Google Cloud Console](https://console.cloud.google.com)
    - Select your project or [create](https://developers.google.com/workspace/guides/create-project) a new one
    - Go to [APIs and Services](https://console.cloud.google.com/apis) and then go to **Credentials**
        - Click in **Create Credentials** and select **OAuth client ID**
            - In application type select **Web application**
            - Use whatever name you want
            - On **Authorised redirect URIs** add the uri `http://localhost:3000/auth/google/callback`
            - Copy the client id and client secret to **GOOGLE_CLIENT_ID** and **GOOGLE_CLIENT_SECRET** on your **.env** file

# Run the Project
- Inside the project directory *shoprr*
- Build the container application
    ```bash
    docker compose build
    ```
- Enter the container with the command:
    ```bash
    docker compose run --rm --service-ports web bash
    ```
    - Run database migrations and seeds
        ```bash
        rails db:setup
        ```
    - Start the server with either **`rails s -b 0`** or **`bin/dev`**
    - To access the application:
        ```bash
        http://localhost:300
        ```
        - You can either create a new user or login with Google, or use the pre-existing users below:
            ```bash
            email: buyer@email.com
            password: Senha@123
            
            email: seller@email.com
            password: Senha@123
            ```

# Tests
To run the test enter the container:
```bash
docker compose run --rm --service-ports web bash
```

Execute the command to run all tests:
```bash
rspec
```

# What's next for Shoprr
- [x] Login with Google
- [ ] A proper cart checkout
- [ ] Cupons
- [ ] Seller area
- [ ] Favoriter products
- [ ] Payments methods
- [ ] Product categories
- [ ] Product sizes
- [ ] Product variations
- [x] Product review and comments
- [ ] Language selection
---
