# Inception - User Documentation

This document provides basic usage instructions for end users and administrators of the Inception infrastructure.

## Table of Contents
1. [Starting and Stopping the Stack](#starting-and-stopping-the-stack)
2. [Accessing the Website](#accessing-the-website)
3. [Managing Credentials](#managing-credentials)
4. [Basic Health Checks](#basic-health-checks)
5. [Troubleshooting](#troubleshooting)

---

## Starting and Stopping the Stack

### Start the Infrastructure

To build and start all services:

```bash
make
```

This command will:
1. Create necessary data directories in `/home/<user>/data/`
2. Build Docker images for all services
3. Start all containers (NGINX, WordPress, MariaDB)

To start in detached mode (background):

```bash
make detach
```

### Stop the Infrastructure

To stop all running containers:

```bash
make down
```

This stops containers but preserves all data in volumes.

### Restart the Infrastructure

To restart everything:

```bash
make re
```

**Warning:** This will delete all data and rebuild from scratch!

### Clean Up

To remove data but keep directories:

```bash
make clean
```

To remove everything including data directories:

```bash
make fclean
```

---

## Accessing the Website

### Access the WordPress Site

Once the stack is running, access the website at:

```
https://rafaelro.42.fr
```


**Note:** The site uses a self-signed SSL certificate, so your browser will show a security warning. Click "Advanced" and "Proceed" to continue.

### Access the WordPress Admin Panel

To access the WordPress administration dashboard:

```
https://rafaelro.42.fr/wp-admin
```


**Default Admin Credentials:**
- Username: (as configured in `WP_ADMIN_USER`)
- Password: (as configured in `WP_ADMIN_PASSWORD`)

---

## Managing Credentials

### Configuration File Location

All credentials are stored in the environment file:

```
srcs/.env
```

### Important Credentials

#### Database Credentials

```bash
# Database name
WP_DB_NAME=wordpress

# Database user
DB_USER=your_database_user

# Database password
DB_PASSWORD=your_secure_password

# Database host (container name)
DB_HOST=mariadb
```

#### WordPress Admin Credentials

```bash
# Admin username
WP_ADMIN_USER=your_admin_user

# Admin password
WP_ADMIN_PASSWORD=your_admin_password

# Admin email
WP_ADMIN_EMAIL=admin@mail.com
```

#### WordPress Regular User Credentials

```bash
# Regular user username
WP_USER=user

# Regular user password
WP_PASSWORD=user_password

# Regular user email
WP_EMAIL=user@example.com
```

### Changing Credentials

**Important:** To change credentials after initial setup:

1. Stop the infrastructure:
   ```bash
   make down
   ```

2. Clean the data:
   ```bash
   make clean
   ```

3. Edit the `.env` file with new credentials:
   ```bash
   nano srcs/.env
   ```

4. Rebuild and restart:
   ```bash
   make
   ```

**Warning:** Changing credentials requires rebuilding the database. All existing data will be lost.

---

## Basic Health Checks

### Check Container Status

To see if all containers are running:

```bash
docker ps
```

Expected output should show 3 running containers:
- `nginx`
- `wordpress`
- `mariadb`

### Check Container Logs

To view logs for a specific service:

```bash
# NGINX logs
docker logs nginx

# WordPress logs
docker logs wordpress

# MariaDB logs
docker logs mariadb
```

To follow logs in real-time:

```bash
docker logs -f wordpress
```

### Verify Network Connectivity

Check if containers can communicate:

```bash
# Test MariaDB connection from WordPress container
docker exec wordpress wp db check --allow-root
```

Expected output: `Success: Database connection confirmed.`

### Check Database

To access the MariaDB database directly:

```bash
docker exec -it mariadb mariadb -u root
```

Then run SQL commands:

```sql
SHOW DATABASES;
USE wordpress;
SHOW TABLES;
EXIT;
```

### Verify WordPress Installation

Check WordPress installation status:

```bash
docker exec wordpress wp core is-installed --allow-root
```

If installed correctly, this returns exit code 0 (success).

### Check PHP-FPM Status

Verify PHP-FPM is running:

```bash
docker exec wordpress ps aux | grep php-fpm
```

Should show multiple `php-fpm8.2` processes.

---

## Troubleshooting

### Website Not Loading

1. **Check if containers are running:**
   ```bash
   docker ps
   ```

2. **Check NGINX logs:**
   ```bash
   docker logs nginx
   ```

3. **Verify port binding:**
   ```bash
   netstat -tulpn | grep 443
   ```

### "Error establishing a database connection"

1. **Check MariaDB container status:**
   ```bash
   docker logs mariadb
   ```

2. **Verify database credentials in `.env`**

3. **Test database connection:**
   ```bash
   docker exec wordpress wp db check --allow-root
   ```

4. **Restart MariaDB:**
   ```bash
   docker restart mariadb
   ```

### Permission Denied Errors

If you see "Permission denied" errors in MariaDB or WordPress logs:

1. **Stop containers:**
   ```bash
   make down
   ```

2. **Fix permissions:**
   ```bash
   sudo chown -R 999:999 ~/data/mariadb
   sudo chown -R 33:33 ~/data/wordpress
   ```

3. **Restart:**
   ```bash
   make up
   ```

### SSL Certificate Warnings

The project uses self-signed SSL certificates for development. Browsers will show security warnings.

**To proceed:**
1. Click "Advanced" in your browser
2. Click "Proceed to localhost (unsafe)" or similar option

**For production:** Replace self-signed certificates with proper certificates (Let's Encrypt, etc.)

### Container Keeps Restarting

1. **Check logs for the specific container:**
   ```bash
   docker logs <container_name>
   ```

2. **Common causes:**
   - Configuration file errors
   - Permission issues
   - Port conflicts
   - Missing dependencies

3. **Rebuild the container:**
   ```bash
   make fclean
   make
   ```

### Cannot Connect to Port 443

**Check if port is already in use:**
```bash
sudo lsof -i :443
```

**If another service is using port 443:**
1. Stop that service, or
2. Change the port in `docker-compose.yml`:
   ```yaml
   ports:
     - "8443:443"  # Use port 8443 instead
   ```

---

## Data Persistence

### Data Locations

All persistent data is stored on the host machine:

- **WordPress files:** `/home/<user>/data/wordpress/`
- **MariaDB data:** `/home/<user>/data/mariadb/`

### Backup

To backup your data:

```bash
# Backup WordPress files
sudo tar -czf wordpress-backup.tar.gz ~/data/wordpress/

# Backup MariaDB database
docker exec mariadb mysqldump -u root --all-databases > mariadb-backup.sql
```

### Restore

To restore from backup:

1. Stop containers:
   ```bash
   make down
   ```

2. Restore WordPress files:
   ```bash
   sudo rm -rf ~/data/wordpress/*
   sudo tar -xzf wordpress-backup.tar.gz -C ~/data/wordpress/
   ```

3. Restore database:
   ```bash
   make up -d mariadb
   docker exec -i mariadb mariadb -u root < mariadb-backup.sql
   ```

4. Start all services:
   ```bash
   make up
   ```

---

## Additional Resources

- [WordPress Documentation](https://wordpress.org/support/)
- [WP-CLI Documentation](https://wp-cli.org/)
- [Docker Documentation](https://docs.docker.com/)
- [MariaDB Knowledge Base](https://mariadb.com/kb/en/)

---

**Need Help?**

If you encounter issues not covered in this documentation, contact your system administrator or refer to the project's README.md for technical details.
