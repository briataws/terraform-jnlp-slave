FROM gcr.io/kaniko-project/executor:latest as kaniko
FROM amazon/aws-cli

ENV SRC_PATH=/usr/src

USER root
RUN yum install -y make git curl wget jq gpg unzip tar sudo nodejs
RUN yum install -y lttng-ust openssl-libs krb5-libs zlib libicu libstdc++-devellibstdc++-static glibc-common glibc-devel glibc-headers nscd
RUN useradd ubuntu
COPY --from=kaniko /kaniko /kaniko
WORKDIR /usr/src
ADD ./install_github_actions.sh .
RUN chmod +x install_github_actions.sh
RUN ./install_github_actions.sh
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
RUN source ~/.nvm/nvm.sh && nvm install lts/gallium
RUN ln -s /root/.nvm/versions/node/v16.19.1/bin/node /usr/local/bin/
WORKDIR /home/ubuntu
RUN chown -R ubuntu:ubuntu /home/ubuntu
ADD ./run.sh .
RUN chmod +x ./run.sh
ENTRYPOINT ["./run.sh"]
