FROM gcr.io/kaniko-project/executor:latest as kaniko
FROM jenkins/jnlp-slave:latest-jdk11

ARG SONAR_SCANNER_HOME=/opt/sonar-scanner
ARG SONAR_SCANNER_VERSION=4.7.0.2747-linux

ENV TERRAFORM_VERSION=1.2.2
ENV JAVA_HOME=/opt/java/openjdk
ENV SONAR_SCANNER_HOME=${SONAR_SCANNER_HOME}
ENV SONAR_USER_HOME=${SONAR_SCANNER_HOME}/.sonar
ENV SRC_PATH=/usr/src
ENV PATH=${SONAR_SCANNER_HOME}/bin:${PATH}

USER root
RUN apt-get update
RUN apt-get install -y make git curl wget
RUN apt-get install -y zip unzip
RUN curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip > terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /bin
RUN rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN apt-get update
RUN apt-get install -y ruby ruby-bundler libffi-dev ruby-dev python3-pip
RUN ln -s /usr/bin/pip3 /usr/bin/pip
RUN wget -U "scannercli" -q -O /opt/sonar-scanner-cli.zip https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip
RUN pip3 install pylint
ADD Gemfile .
RUN bundle install
COPY --from=kaniko /kaniko /kaniko

WORKDIR /opt
RUN unzip sonar-scanner-cli.zip;\
    rm sonar-scanner-cli.zip; \
    mv sonar-scanner-${SONAR_SCANNER_VERSION} ${SONAR_SCANNER_HOME};\
    mkdir -p "${SRC_PATH}" "${SONAR_USER_HOME}" "${SONAR_USER_HOME}/cache";\
    chmod -R 777 "${SRC_PATH}" "${SONAR_USER_HOME}";

WORKDIR /kaniko
