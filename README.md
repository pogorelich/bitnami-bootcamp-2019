## Session 1, deliverable 3: Etcd Bash Container
> * Modify the “runtime” stage of ex. 1 so you transform the etcd container on a “Bash” container.
> * Use the “Bitnami” approach using the scripts:
>    * prepare.sh
>    * entrypoint.sh
>    * setup.sh
>    * run.sh
> * Include the following (at least) customizations:
>    * Use a “non-root” approach
>    * etcd should reuse data from previous deployments if existing
>    * Allow Enabling Authentication using env. variables.
>    * Allow the user mounting its own configuration file.
>    * Add a “docker-compose.yml” to orchestrate volumes

#### Use 
```bash
$ docker-compose up
```
#### Environment variables
The etcd container can be customized by specifying environment variables on the first run. The following environment values are provided to custom etcd:

- `DATA_DIR`: etcd data directory. Default: **/default.etcd**
- `MEMBER_DIR`: etcd member directory. Default: **/default.etcd/member**
- `DISABLE_AUTHENTICATION`: Set to **yes** if you don't want to enable authentication, which is **NOT recommended**.
- `ETCD_CONFIGURATION_FILE`: Path to etcd configuration file. No configuration file by default.
- `WORDPRESS_LAST_NAME`: WordPress user last name. Default: **LastName**
- `WORDPRESS_BLOG_NAME`: WordPress blog name. Default: 
**User's blog**

ENV DATA_DIR="/default.etcd" \
    MEMBER_DIR="/default.etcd/member" \
    DISABLE_AUTHENTICATION="no" \
    ETCDCTL_ROOT_PASSWORD="toor" \
    ETCD_CONFIGURATION_FILE=""
