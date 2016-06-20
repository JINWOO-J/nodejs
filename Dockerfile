#nodejs:v0.10.25
FROM ubuntu:14.04
MAINTAINER jinwoo <jinwoo@yellotravel.com>

ENV NodeVersion v4.4.5
WORKDIR /usr/local/src
RUN ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime
RUN sed -i 's/archive.ubuntu.com/ftp.daum.net/g' /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y g++ bzip2 freetype* wget 
RUN wget http://nodejs.org/dist/${NodeVersion}/node-${NodeVersion}-linux-x64.tar.gz
RUN tar zxf node-${NodeVersion}-linux-x64.tar.gz
RUN mv  /usr/local/src/node-${NodeVersion}-linux-x64 /usr/local/node
#RUN ln -s /usr/local/src/node-${NodeVersion}-linux-x64 /usr/local/node
RUN printf '\n# Node.js\nexport PATH="/usr/local/node/bin:$PATH" \n' >> /root/.bashrc
RUN printf '\n# Node.js\nexport PATH="/usr/local/node/bin:$PATH" \n' >> /etc/profile
RUN rm -rf /usr/local/src/node-${NodeVersion}-linux-x64.tar.gz
RUN rm -rf rm /tmp/npm-*
RUN mkdir /home/www_nodejs
ENV PATH "/usr/local/node/bin:$PATH"
RUN ln -s /usr/local/node/bin/node /usr/bin/node

# App
COPY npm_installer.sh /usr/local/src/
COPY start.sh /
RUN chmod 755 /usr/local/src/npm_installer.sh
RUN chmod 755 /start.sh

# Install app dependencies
ENV NPM_LIST pm2@0.15.10 gulp@3.9.0 bower@1.7.2 
RUN ./npm_installer.sh ${NPM_LIST}
RUN cd /usr/local/node/lib/node_modules/npm; npm ls
RUN apt-get update -y
RUN apt-get install ruby-full -y
RUN gem install sass

#async@1.2.1 bcrypt-nodejs@0.0.3 http@0.0.0 https@1.0.0 moment@2.10.3 mysql@2.6.2 socket.io@1.3.5 uuid@2.0.1 winston@1.0.0 body-parser@1.12.4 connect-flash@0.1.1 cookie-parser@1.3.5 debug@2.2.0 ejs@2.3.1 express@4.12.4 express-mysql-session@0.4.1 express-session@1.11.2 html-minifier@0.7.2 18n-2@0.4.6 jade@1.9.2 mobile-detect@1.2.0 moment@2.10.3 moment-timezone@0.4.0 morgan@1.5.3 
#RUN "for npm in ${NPM_LIST};do /usr/local/node/bin/npm install -g ${npm};echo ${npm} ;done >>/usr/local/src/log"

EXPOSE  3000
