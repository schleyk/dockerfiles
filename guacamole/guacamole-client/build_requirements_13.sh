#!/bin/bash

git clone https://github.com/apache/guacamole-client.git
cd guacamole-client/
git checkout 1.3.0
cd ..
mv guacamole-client guacamole-client-stable
