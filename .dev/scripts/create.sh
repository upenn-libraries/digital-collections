#! /bin/env bash

container="digital-collections"
context_alias="dc"

vagrant up --provision

docker cp ${container}:/certs/client/. .swarm_certificates/

docker context create ${context_alias} --description "${container}" --docker "host=tcp://${container}:2376,ca=.swarm_certificates/ca.pem,cert=.swarm_certificates/cert.pem,key=.swarm_certificates/key.pem"

docker context use ${context_alias}
