#!/usr/bin/env bash

pushd $(cd $(dirname $0) && pwd)
    docker build -t iac-jenkins .
popd
