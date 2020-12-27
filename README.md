<div align="center" style="font-size:xx-large">Personal Cloud Server</div>
<div align="center" style="font-size:xx-large">-</div>
<div align="center" style="font-size:xx-large">Certificate Service</div>

-------------------
The Personal Cloud Server project aim to provide a full cloud service set for personal or small enterprise usage which is self hosted.

As any solution, hard choice needs to be made on the inherited open-source projects as nothing is perfect. Here are the overall rules/philosphy :
- Run on linux distro
    - Windows can run docker but the overall manager needs linux and a good filesystem ACL management to share files.
- Can be dockerized  
    - Can permit to fit each service to the right kernel/distro for it.
- Is open-source & free
- Respect your data
    - Don't send data to another server than yours or send anonymous one.

The PCS solution is built on hardened & up-to-date solutions that is very easy to set-up.
KISS philosophy is the key here for security and user easy access.
For sure, this is limiting the customization available through PCS but :
- Implementation is very generic and ensure a good level of security.
- Each service is independant and can be replaced by your own if you need it.
    - Although, I'll recommend that you discover or migrate to the service proposed here.

# Certificate Service Introduction
This service is a docker based on :
- [Alpine Linux Distro](https://alpinelinux.org/)
- [Certbot](https://certbot.eff.org/)
- [Gandi Domain Provider](https://www.gandi.net)
    - The best service I know which has everything for newbee, geek, expert and enterprise

# Preliminary set-up
## Requirement
- [Docker](https://www.docker.com/products/container-runtime#/download)
## Gandi API Key
You will need a Gandi API key to provide the certbot script to add/remove DNS record so that certbot can verify that you are the owner of the domain.

To do so, please refer to the Gandi official documentation : [Documentation](https://docs.gandi.net/en/domain_names/advanced_users/api.html)
# Set-Up & Deploy
## Download
```sh
curl -Lso pcs-certbot.zip https://github.com/ClementToche/pcs-certbot/archive/main.zip
unzip pcs-certbot.zip
cd pcs-certbot-*
chmod +x ./pcs
```
## Environment file
1. Copy env_file.example to env_file
```sh
cp env_file.example env_file
```
2. Add the values for your own domain
```sh
# API Key from Gandi
PCS_GANDI_APIKEY=<API KEY>
# The email used by certob for important communication
PCS_CERTBOT_EMAIL_REGISTER=john.doe@gmail.com
# Coma separated list of domain/subdomain you want your certificate to use
PCS_CERTBOT_DOMAIN_LIST=doe.com,john.doe.com
```
## Deploy
The pcs-certbot needs to have "tls" group defined in your host and /etc/letsencrypt/ folder created in your host.
The pcs script is ensuring that both requirement are ensured and will create them if needed.
```sh
# Build docker image.
./pcs build
# Launch docker
./pcs run
# Wait for the job to finish

# You can check the progress by using 'docker ps' command or check logs by using 'docker logs -f <contener id>
```
