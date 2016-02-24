FROM centos:latest
MAINTAINER feiin(http://github.com/feiin)

RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh | bash

ENV NODE_VERSION 4.3.1

RUN . ~/.nvm/nvm.sh && \
    nvm install $NODE_VERSION && \
    nvm alias default $NODE_VERSION && \
    nvm use default

RUN . ~/.nvm/nvm.sh && \
	ln -s /usr/local/nvm/versions/node/v$NODE_VERSION/bin/node /usr/bin/node && \
	npm install -g nrm && \
	nrm use taobao && \
	npm install -g pm2 

RUN yum -y install openssh-server

RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -C '' -N '' && \
    ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -C '' -N ''  && \
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -C '' -N ''

RUN mkdir /www && touch /start.sh && chmod 777 /start.sh

RUN echo '#!/bin/bash' > /start.sh && \
    echo 'source ~/.bashrc' >> /start.sh && \
    echo '# pm2 start /www/app.js' >> /start.sh && \
    echo '/usr/sbin/sshd -D' >>/start.sh

CMD ["/bin/bash", "/start.sh"]
