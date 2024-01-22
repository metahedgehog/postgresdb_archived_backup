### Dockerized PostgreSQL with automated archived backup
_____

This repository provides a Dockerized setup for PostgreSQL with an integrated backup script. It includes a Dockerfile that extends the official PostgreSQL image, setting up cron jobs for automated backups and PostgreSQL initialization during container startup.

- **PostgreSQL Version:** 14.1
- **Backup Script:** Automated backups with tarball. Running in customizable cron schedule and data retention period. 
- **Superuser Password:**  To change the superuser password modify /.secrets/postgresql_password.txt file which is referenced in docker-compose.yml
- **Initialization SQL:** init.sql contains parameters to create a default database while the container initialization
- **Database Management Tool:**  Adminer 4.8.1


___

### Usage:

1. Clone this repository
   
```bash
git clone https://github.com/metahedgehog/postgresdb_archived_backup.git
```

2. Build the Docker image 
   
``` bash
docker-compose build
```
   
3. Run the container stack

```bash
docker-compose up -d
```

4. Access the management tool on *localhost:8080*

___

### Docker-Compose Overview

```yml
version: '3.8'

services:
  postgres_db:
    container_name: postgres_db
    build:
      context: .
      dockerfile: Dockerfile
    restart: always
    environment:
      POSTGRES_PASSWORD_FILE: /run/secrets/postgres_password
      BACKUP_RETENTION: 10 #Change backup retention days count
    volumes:
      - pgdata:/var/lib/postgresql/data
      - ./pgbackup:/var/lib/postgresql/backup
    secrets:
      - postgres_password
    networks:
      - backend
  
  adminer:
    container_name: adminer
    image: adminer
    restart: always
    ports:
      - 8080:8080
    depends_on:
      - postgres_db
    networks:
      - backend
      - frontend

secrets:
  postgres_password:
    file: ./.secrets/postgres_password.txt

networks:
  backend:
  frontend:

volumes:
  pgdata:
```

**Networks**: There are *frontend* and *backend* networks created to decouple the management tool and the database engine without exposing it's port outside of the container.

**Docker Secrets:**  PostgreSQL Superuser's password is stored in a file /.secrets/postgres_password.txt. You can change it's location or store it inside a container.

**Backup Retention**: This parameter defines how long a tarball backup with the databases will be stored. Default value is 10 (days).

___

### Cron parameters

You can modify Dockerfile and change crontab parametes. Default value is set to _0 5 * * *_ , which means _every day at 5 AM_.


___

### Default database initialization

__init.sql__ file contains a default _user_ , _password_ and _database_ owned by _user_. When container starts, this parameters are implemented automatically. You can modify them according to your needs.
