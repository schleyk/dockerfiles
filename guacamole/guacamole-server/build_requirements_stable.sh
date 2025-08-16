#!/bin/bash

git clone https://github.com/apache/guacamole-server.git
cd guacamole-server/
git checkout 1.6.0
#rm Dockerfile
#wget https://raw.githubusercontent.com/apache/guacamole-server/main/Dockerfile
#cd ..
mv guacamole-server guacamole-server-stable
