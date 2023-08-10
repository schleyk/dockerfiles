#!/bin/bash

git clone https://github.com/apache/guacamole-server.git
cd guacamole-server/
git checkout 1.5.3
cd ..
mv guacamole-server guacamole-server-stable
