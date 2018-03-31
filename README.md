# Jenkins jnlp slave with `terraform`

[![Docker Repository on Quay](https://quay.io/repository/mariusv/terraform-jnlp-slave/status "Docker Repository on Quay")](https://quay.io/repository/mariusv/terraform-jnlp-slave)

### Usage 
This repository automatically builds containers for using the [`terraform`](https://terraform.io) command line program. It contains the latest `terraform` version.

#### From the shell

```shell
docker run -i -t mariusv/terraform-jnlp-slave:0.11.5 <command>
```

#### From Jenkins pipeline

```json
pipeline {
  agent none
  stages {
    stage('terraform Version') {
    agent {label 'tf-slave'}
      steps {
        sh "terraform version"
      }
    }
  }
}
```
The above example is used with [Kubernetes plugin](https://plugins.jenkins.io/kubernetes) and it assumes you already created a new `pod` template labeled in this example `tf-slave`.


