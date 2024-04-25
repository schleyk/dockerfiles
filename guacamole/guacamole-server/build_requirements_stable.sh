#!/bin/bash

git clone https://github.com/apache/guacamole-server.git
cd guacamole-server/
git checkout 1.5.5
rm Dockerfile
wget https://raw.githubusercontent.com/apache/guacamole-server/main/Dockerfile
cd ..
mv guacamole-server guacamole-server-stable
