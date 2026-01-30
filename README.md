 # RaspberryPi Homelab
 Raspberry Pi homelab container stack.
 
 This repo groups multiple Docker Compose stacks (valid to used from Portainer or CLI) to run services on my Raspberry Pi 

My cable network is as follows: (Wifi, Zigbee, bluetooth and IoT devices are not included in the diagram)
 ![](./images/fossflow_basic_net.svg)
 
 ## How to deploy containers
 - **Portainer (recommended)**
 - **CLI (docker compose)**
   - Run from the folder that contains the stack file:
     - `docker compose -f <stack>.yaml -p project_name up -d`
   - Note: some files use `deploy.resources.limits.memory`. This is **Swarm-only** in upstream Compose; Portainer may still apply it depending on how you deploy. If you need strict limits on standalone Docker, use `mem_limit`/`memswap_limit`.
 
 ## Conventions
 - **Persistent data**: `/your/path/to/docker-services/<service>/...`
 - **Secrets/env**: some stacks reference `env_file: /portainer/or/container/path/to/data/.env.*` (portainer path on the host in my case)
 - **Networking**:
   - Some stacks use `network_mode: host` (Home Assistant / Matter) Mandatory to discover services on the network
   - Some stacks attach to an **external** network (e.g. `databases`)
 
 ## Repo structure
 - **ai/**: AI web UI.
 - **automations/**: workflow automation.
 - **databases/**: Postgres + Adminer.
 - **downloads/**: qBittorrent.
 - **homepage/**: Homepage dashboard + its config.
 - **iot/**: Home Assistant + Matter Server + Node-RED.
 - **media/**: Jellyfin + Navidrome + FreshRSS.
 - **monitoring/**: Grafana + Prometheus + Loki + Alloy + cAdvisor.
 - **networking/**: DuckDNS.
 - **portainer/**: Portainer CE.
 - **samba/**: Samba servers (main, retro, timemachine) with custom images.
 - **sre-tools/**: Excalidraw + IT-Tools + Fossflow.
 
 ## Notes
 - **Bind mounts to files** (e.g. Samba `smb.conf`) require the host file to exist and be a file.
 - Paths like `/your/path/to/docker-services/portainer/.env.*` or samba `smb.conf` files are host paths; ensure they exist on the node where you deploy.
 
 ## License
 MIT.
