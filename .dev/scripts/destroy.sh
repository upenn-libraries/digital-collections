#! /bin/env bash

container="digital-collections"
context_alias="dc"

docker context use default

docker context rm ${context_alias}

vagrant destroy -f
