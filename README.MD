*This project has been created as part of the 42 curriculum by rafaelro.*

# Inception

## Description

Inception is a system administration project focused on containerization using Docker. The goal is to set up a small infrastructure composed of different services following specific rules. The entire infrastructure runs in a virtual machine using Docker Compose.

The project consists of:
- **NGINX**: Web server with TLSv1.2 or TLSv1.3
- **WordPress**: Content Management System with php-fpm
- **MariaDB**: Database server for WordPress

Each service runs in a dedicated Docker container built from either the penultimate stable version of Alpine Linux or Debian Bullseye/Bookworm. All containers are connected through a docker-network and use volumes for persistent data storage.

## Instructions

### Prerequisites

- Docker and Docker Compose installed
- Make utility
- Root or sudo access to create directories in `/home/<user>/data`

### Building and Running

1. Clone the repository:
```bash
git clone <repository-url>
cd inception
```

2. Configure environment variables in `srcs/.env`:
```bash
# Database Configuration
WP_DB_NAME=wordpress
DB_USER=your_db_user
DB_PASSWORD=your_db_password

# WordPress Admin
WP_ADMIN_USER=admin
WP_ADMIN_PASSWORD=your_admin_password
WP_ADMIN_EMAIL=admin@example.com
WP_SITE_TITLE="My WordPress Site"

# WordPress User
WP_USER=user
WP_PASSWORD=user_password
WP_EMAIL=user@example.com

# Database Host
DB_HOST=mariadb
```

3. Build and start the infrastructure:
```bash
make
```

4. Prepare hosts entry for local HTTPS:
```bash
sudo echo "127.0.0.1 rafaelro.42.fr" | sudo tee -a /etc/hosts
```
or

- Open /etc/hosts
- Add this at the end of the file
```
127.0.0.1 rafaelro.42.fr
```

5. Access the website at `https://localhost` or `https://rafaelro.42.fr`

6. To check container status use:
```bash
docker ps
```

### Available Make Commands

- `make` or `make all`: Build and start all containers (in foreground)
- `make build`: Create data directories and build container images
- `make up`: Build and start all containers (in foreground)
- `make detach`: Build and start all containers in detached mode (-d)
- `make down`: Stop and remove containers
- `make re`: Stop containers and restart (down + up)

### Project Structure

```
inception/
├── Makefile
├── srcs/
│   ├── docker-compose.yml
│   ├── .env
│   └── requirements/
│       ├── mariadb/
│       │   ├── Dockerfile
│       │   ├── my.cnf
│       │   └── setup.sh
│       ├── nginx/
│       │   ├── Dockerfile
│       │   └── conf/
│       │       ├── nginx.conf
│       │       └── certgen.sh
│       └── wordpress/
│           ├── Dockerfile
│           ├── config.sh
│           └── www.conf
```

## Resources

### Documentation
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [NGINX Documentation](https://nginx.org/en/docs/)
- [MariaDB Knowledge Base](https://mariadb.com/kb/en/)
- [WordPress Codex](https://codex.wordpress.org/)
- [WP-CLI Documentation](https://wp-cli.org/)

### Tutorials
- [Understanding Docker Networking](https://docs.docker.com/network/)
- [Docker Volumes Explained](https://docs.docker.com/storage/volumes/)
- [Setting up NGINX with SSL](https://nginx.org/en/docs/http/configuring_https_servers.html/)

### AI Usage

AI assistance (Github Copilot) was used in the following parts of this project:

1. **Debugging connectivity issues**: AI helped identify that MariaDB was binding to `127.0.0.1` instead of `0.0.0.0`, preventing WordPress from connecting from another container.

2. **PHP version compatibility**: AI identified the incompatibility between Debian Bookworm and PHP 7.5, suggesting the upgrade to PHP 8.2 to match the Bookworm repositories.

3. **Configuration file optimization**: AI reviewed MariaDB configuration files to ensure proper network binding and socket configuration for inter-container communication.

4. **Documentation**: AI assisted in structuring and writing this README.md.

## Project Design and Technical Choices

### Docker and Sources

This project uses Docker to create an isolated, reproducible infrastructure. Each service runs in its own container:

- **MariaDB Container**: Built from Debian Bookworm, runs the database server with custom configuration to accept remote connections from the WordPress container.

- **WordPress Container**: Built from Debian Bookworm with PHP 8.2-FPM, includes WP-CLI for automated WordPress installation and configuration.

- **NGINX Container**: Built from Debian Bullseye, functions as a reverse proxy with TLS encryption using self-signed certificates.

All Dockerfiles are written from scratch without using pre-built images (except base OS images), following the project requirements for learning purposes.

### Virtual Machines vs Docker

| Aspect | Virtual Machines | Docker |
|--------|------------------|--------|
| **Resource Usage** | Heavy - runs full OS with kernel | Lightweight - shares host kernel |
| **Startup Time** | Minutes | Seconds |
| **Isolation** | Complete OS-level isolation | Process-level isolation |
| **Portability** | Less portable, hypervisor-dependent | Highly portable across systems |
| **Use Case** | Full OS emulation, strong isolation needs | Microservices, rapid deployment |

**For this project**: Docker is ideal because each service (NGINX, WordPress, MariaDB) needs isolation but not a full OS. Docker containers share the kernel, making them efficient and fast to deploy.

### Secrets vs Environment Variables

| Aspect | Secrets | Environment Variables |
|--------|---------|----------------------|
| **Security** | Encrypted at rest, encrypted in transit | Plain text in container config |
| **Visibility** | Not visible in `docker inspect` | Visible in `docker inspect` and process list |
| **Storage** | Stored in Docker Swarm or external secret managers | Stored in `.env` files or compose |
| **Rotation** | Can be rotated without rebuilding | Requires container recreation |
| **Best For** | Production passwords, API keys | Non-sensitive configuration |

**For this project**: Environment variables are used via `.env` file for simplicity and educational purposes. In production, sensitive data (DB passwords, API keys) should use Docker Secrets or HashiCorp Vault.

### Docker Network vs Host Network

| Aspect | Docker Network (Bridge) | Host Network |
|--------|------------------------|--------------|
| **Isolation** | Containers have isolated network stack | Container shares host network stack |
| **Port Mapping** | Requires explicit port mapping | Direct access to all ports |
| **Security** | Better - isolated from host | Less secure - full host network access |
| **DNS** | Docker provides internal DNS | Uses host DNS |
| **Performance** | Slight overhead from NAT | No overhead |

**For this project**: A custom Docker bridge network (`inception_network`) is used to:
- Allow containers to communicate by service name (e.g., `mariadb:3306`)
- Isolate the infrastructure from the host network
- Provide automatic DNS resolution between containers
- Enable better security through network isolation

### Docker Volumes vs Bind Mounts

| Aspect | Docker Volumes | Bind Mounts |
|--------|----------------|-------------|
| **Management** | Managed by Docker | User manages path on host |
| **Location** | `/var/lib/docker/volumes/` | Any path on host filesystem |
| **Portability** | More portable across systems | Depends on host filesystem structure |
| **Performance** | Optimized by Docker | Depends on host filesystem |
| **Backup** | Easier with Docker tools | Manual backup required |
| **Permissions** | Docker manages permissions | Host filesystem permissions apply |

**For this project**: Bind mounts are used (as per project requirements):
- MariaDB data: `/home/rafael/data/mariadb` → `/var/lib/mysql`
- WordPress files: `/home/rafael/data/wordpress` → `/var/www/html`

This approach:
- Makes data easily accessible from the host for backup/inspection
- Persists data even when containers are removed
- Allows direct file editing from the host system
- Meets the project requirement of storing data in specific host directories

However, in production, Docker volumes would typically be preferred for:
- Better performance on Docker Desktop (Windows/Mac)
- Easier migration between hosts
- Better integration with Docker's backup and orchestration tools

---

**Note**: This infrastructure is designed for educational purposes. For production use, additional security measures would be required (proper SSL certificates, password rotation, security updates, monitoring, etc.).
