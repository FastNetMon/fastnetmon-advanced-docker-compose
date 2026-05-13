# Docker compose for FastNetMon Advanced #

## Install ##

Clone repo.

### .env ###

Then we need create `.env` for our settings (example - `.env.template`)

We set there variables

- `FNM_PATH` - path to our docker compose files.
- `FNM_VERSION` - **FastNetMon** version to install via Docker tags.
- `FNM_WEB_API_V2` - switch between old syle web API and new
- `FNM_NOT_UPLOAD_ASN_MAPPING` - disable upload [asn mapping](https://fastnetmon.com/fastnetmon-asn-peering-reports/)
- `COMPOSE_PROJECT_NAME`  - project name( will be prefix for containers names ).
- `COMPOSE_FILE` - declare what components will be used.  

### COMPOSE_FILE ###

Minimal example

```bash
COMPOSE_FILE=docker-compose.ym
```

Most full example

```bash
COMPOSE_FILE=docker-compose.yml:docker-compose.clickhouse.yml:docker-compose.grafana.yml:docker-compose.trafficdb.yml:docker-compose.web-api.yml
```

Components by file

- docker-compose.yml - minimal base FNM (only FastNetMon and MongoDB)
- docker-compose.gobgp.yml - Add GoBGP daemon
- docker-compose.clickhouse.yml - Add clickhouse for saving metrics
- docker-compose.grafana.yml - Add grafana for [traffic visualisation](https://fastnetmon.com/docs-fnm-advanced/advanced-visual-traffic/)(need enabled clickhouse)
- docker-compose.trafficdb.yml  - enable [traffic persistence](https://fastnetmon.com/docs-fnm-advanced/fastnetmon-advanced-traffic-persistency/)(need enabled clickhouse)
- docker-compose.web-api.yml  - start [web API](https://fastnetmon.com/docs-fnm-advanced/advanced-api/) or with FNM_WEB_API_V2=true start [LiveView](https://fastnetmon.com/docs-fnm-advanced/fastnetmon-panel-ui-installation/)

### Configure volumes and secrets ###

Volumes, secrets and network config separtaed to files volumes.yml,secrets.yml and networks.yml.  
By default volumes is directoies in `storage/`.

Secretes in `secrets/`  and can be generated with `init_secrets.sh` scripts.

### Start services ###

After all previose step configured there should be enought to run

```bash
docker compose up -d 
```

If user not in docker group, than all command need `sudo -E` to lose ENV variables, like

```bash
sudo -E docker compose up -d 
```

## Configure ##

Following instruction for configuration need to change all  
`sudo fcli $COMMAND`  
to  
`docker compose exec fastnetmon fcli $COMMAND` .

Except for `sudo fcli commit` - instaed of commit we restart service now  

```bash
docker compose restart fastnetmon
```

## Logs notice ##

Where possible for now logs send to stdout/stderr to appear at `docker conpose logs`, but some still stored in volumes.  
By default logs for services would be lost after `docker compose down` - could be good to setup `/etc/docker/daemon.json` for journald or remoute collector - <https://docs.docker.com/engine/logging/configure/>
