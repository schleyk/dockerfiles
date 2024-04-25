#!/bin/bash

git clone https://github.com/apache/guacamole-client.git
cd guacamole-client/
git checkout 1.5.5
rm Dockerfile
wget https://raw.githubusercontent.com/apache/guacamole-server/main/Dockerfile
cd ..
mv guacamole-client guacamole-client-stable
