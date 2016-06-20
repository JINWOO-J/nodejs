#!/bin/bash

NodeVersion=$1
cd /usr/local/src
apt-get update
apt-get install -y g++ bzip2 freetype* wget 
wget http://nodejs.org/dist/${NodeVersion}/node-${NodeVersion}-linux-x64.tar.gz
tar zxf node-${NodeVersion}-linux-x64.tar.gz
cp  -rvf /usr/local/src/node-${NodeVersion}-linux-x64/* /usr/local/node/
echo -e '\n# Node.js\nexport PATH="/usr/local/node/bin:$PATH"' >> /root/.bashrc
echo -e '\n# Node.js\nexport PATH="/usr/local/node/bin:$PATH"' >> /etc/profile
# rm -rf /usr/local/src/node-${NodeVersion}-linux-x64.tar.gz
rm -rf rm /tmp/npm-*
mkdir /home/www_nodejs
export PATH="/usr/local/node/bin:$PATH"
ln -sf /usr/local/node/bin/node /usr/bin/node
echo $PATH
#npm install -g 

#npm install --prefix=/usr/local/node/lib/ --only=dev -g .


#npm install -g . --prefix=/usr/local/node/lib/

NPM_LIST="pm2@0.15.10 gulp@3.9.0 bower@1.7.2 nodemon@1.8.1 gulp-livereload@3.8.1"
./npm_installer.sh ${NPM_LIST}
cd /usr/local/node/lib/
/usr/local/node/bin/npm install 

# npm install --only=dev -g .
# cp -rf node_modules/* /usr/local/node/lib/node_modules/