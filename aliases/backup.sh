#!/bin/bash

function backp-k8s-config() {
  cp ~/.kube/config ~/.kube/config.backup.$(date +"%Y-%m-%d")
  cp ~/.k9s/config.yml ~/.k9s/config.yml.backup.$(date +"%Y-%m-%d")
}
