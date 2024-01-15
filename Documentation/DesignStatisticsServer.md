# Design document for statistics server

* TODO format this correctly
* TODO I think the decision on OS and docker things belong in the design not the architecture documentation.

## Designs

### VM deployment

* TODO put metric collection on both servers and show on statistics server

#### VM deployment for statistics server

* Using the statistics-docker-compose.yaml
  * TODO create a design selection.

#### VM deployment for the CS2 server

* TODO how to provide the filebeat config file
* TOOD how to provide an address for the logstash server, which resides on the statistics server.

### docker-compose deployement

* Put everything into a single docker compose

#### Filebeat in docker-compose

* the csgo data dir is mounted into the filebeat container and thus enable filebeat to read the logs.

https://www.elastic.co/guide/en/beats/filebeat/current/setup-repositories.html

## Design decisions

### VM OS selection

OS to use in the VMs

* Selected: Ubuntu
* Reasons
  * It is the one I am used to using on Azure.

Points to concider when selecting the VM OS

* support for ansible installation
* support for installation via terraform
* ability to run docker host
* security

#### VM OS option: Alpine linux

#### VM OS option: Debian

#### VM OS option: Ubuntu

### Game Server deployment

### Statstics Server deployment

* VM
* container on docker host
* container in k8s cluster

### providing the game statistics html generator

* Selected: cron method
* Reasons
  * ease of installation
    * just need to add an entry to the crontab

Points to concider when selecting the method for running the game statistics html

* Ease of installation
* maintainability

#### game statistics generator via cron

* Description
* OptionEvaluation A
  * Description:
  * Rating

#### game statistics generator via systemctl

* Description
* OptionEvaluation A
  * Description:
  * Rating

#### game statistics generator via container

* Description
* OptionEvaluation A
  * Description:
  * Rating
