# resourcespace/docker
The official Docker image for ResourceSpace. Full build instructions can be found on our [Knowledge Base](https://www.resourcespace.com/knowledge-base/systemadmin/install_docker).

# Installation notes
* Before building the Docker image, change the db.env file replacing the default "change-me" passwords to secure values.
* When setting up ResourceSpace ensure you enter "mariadb" as the MySQL server instead of "localhost" and leave the "MySQL binary path" empty.

# Docker environment variables
* `MYSQL_SERVER`
* `MYSQL_USER`
* `MYSQL_PASSWORD`
* `MYSQL_DB` default: resourcespace
* `BASEURL` default: http://localhost
* `APP_NAME` default: ResourceSpace
* `EMAIL_NOTIFY`
* `EMAIL_FROM`
* `SCRAMBLE_KEY`
* `API_SCRAMBLE_KEY`

Optional:
* `SMTP_HOST`
* `SMTP_PORT`
* `SMTP_SECURE`
* `SMTP_USERNAME`
* `SMTP_PASSWORD`