#!/bin/bash

git clone https://github.com/apache/guacamole-server.git
cd guacamole-server/
git checkout 1.5.0
cd ..
mv guacamole-server guacamole-server-stable
