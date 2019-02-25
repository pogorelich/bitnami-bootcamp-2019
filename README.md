## Session 1, exercise 9.
> Create two docker-compose projects.
> 1. WordPress + MariaDB: Use bitnami/wordpress and bitnami/mariadb. It should have:
>    * Persistence with volumes.
>    * Isolated in a network.
>
> 2. Database Backup: This project is for running a mysqldump in the "WordPress + MariaDB" database. When executing docker-compose up, it should create a backup of the WordPress database and store it in a host path folder.

### Solution
Files [docker-compose-1.yml](docker-compose-1.yml) and [docker-compose-2.yml](docker-compose-2.yml).
#### Use
```bash
$ docker-compose -f docker-compose-1.yml up
$ docker-compose -f docker-compose-2.yml up
```