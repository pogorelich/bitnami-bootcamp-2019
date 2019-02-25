## Session 1, exercise 10.
> Access different containers using domain name.
> * I want to have two running installations: one with WordPress and another with Joomla (bitnami/wordpress, bitnami/joomla and bitnami/mariadb). I want to be able to acess one or the other just by using domain names.
> * Edit your /etc/hosts file and add two entries:
> 
> 	```bash
> 	127.0.0.1 myfirstwp.net
> 	127.0.0.1 myjoomla.net
> 	```
> * Create the docker-compose projects of both installations, and find a way (highly likely, a proxy container. Search the net!) that makes it possible. 
> * Notes: 
>    * Joomla and WordPress must be in different networks
>    * Only one MariaDB instance

### Solution
In order to be able to access WordPress http server or Joomla http using the same IP address just by using domain names, we use a reverse Nginx proxy by [jwilder](https://github.com/jwilder/nginx-proxy).

We use two networks: 
1.  `net_wp`: WordPress, MariaDB and Nginx proxy containers are in this network.
2.  `net_joomla`: Joomla, MariaDB and Nginx proxy containers are in this network.

#### Use
```bash
$ docker-compose up 
```