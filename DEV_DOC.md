### Prerequisites

- Docker 29.3.0 and Docker Compose installed (https://docs.docker.com/engine/install/ubuntu/)
- GNU Make 4.3
- Root or sudo access to create directories in `/home/<user>/data`

1. Clone the repository:
```bash
git clone <repository-url>
cd inception
```
2. Add user to `docker` group(restart computer):
```bash
sudo usermod -aG docker $USER
```

3. Configure environment variables in `srcs/.env`:
```bash
WP_DB_NAME=wordpress
DB_USER=your_db_user
DB_PASSWORD=your_db_password

# WordPress Admin
WP_ADMIN_USER=admin
WP_ADMIN_PASSWORD=password
WP_ADMIN_EMAIL=admin@example.com
WP_SITE_TITLE="My WordPress Site"

# WordPress User
WP_USER=user
WP_PASSWORD=password
WP_EMAIL=user@example.com

# WP Data
WP_HOST=rafaelro.42.fr
WP_TABLE_PREFIX=wp_

# Database Host
DB_HOST=mariadb
```

4. Build and start the infrastructure:
```bash
make
```

5. Prepare hosts entry for local HTTPS:
```bash
sudo echo "127.0.0.1 rafaelro.42.fr" | sudo tee -a /etc/hosts
```
or

- Open /etc/hosts
- Add this at the end of the file
```bash
127.0.0.1 rafaelro.42.fr
```

6. Access the website at `https://localhost` or `https://rafaelro.42.fr`

7. To check container status use:
```bash
docker ps
```
