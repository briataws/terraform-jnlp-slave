FROM jenkins/jnlp-slave:alpine

ENV TERRAFORM_VERSION=1.2.2

USER root
RUN apk add --update make git curl curl-dev
RUN curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip > terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /bin
RUN rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN apk update
RUN apk add ruby ruby-bundler libffi-dev ruby-dev build-base
ADD Gemfile .
RUN bundle install
