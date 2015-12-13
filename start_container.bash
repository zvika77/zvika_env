#!/bin/bash

docker build -t vertica_env

docker run -it --name vertica  vertica_env


