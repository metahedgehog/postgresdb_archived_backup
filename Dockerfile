FROM postgres:14.1

# Install cron
RUN apt-get update && apt-get install -y cron

# Copy backup script
COPY backup.sh /usr/local/bin/backup.sh
RUN chmod +x /usr/local/bin/backup.sh

# Copy database initialization script
COPY init.sql /docker-entrypoint-initdb.d/init.sql

# Add cron job to crontab
RUN echo "0 5 * * * /usr/local/bin/backup.sh" | crontab -

# Initialize database
CMD ["docker-entrypoint.sh", "postgres"]
