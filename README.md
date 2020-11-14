# AWS Lambda deployment with Terraform - Tutorial

This tutorial shows how to deploy a `Python` function on
[`AWS Lambda`](https://aws.amazon.com/lambda/) with
[`Terraform`](https://www.terraform.io).

The `Terraform` configuration can also:
 * install the required `Python` dependencies
 * keep track of changes to the code and dependencies
   to avoid re-deploying an unchanged function

## Prerequisites

 * [`Python 3.8`](https://www.python.org/downloads/release/python-386/)
 * [`Terraform 0.13.5`](https://releases.hashicorp.com/terraform/0.13.5/)
 * [`AWS CLI 1.18.69`](https://aws.amazon.com/cli/?nc1=h_ls)

Optional:

 * [`Miniconda`](https://docs.conda.io/en/latest/miniconda.html)

## Usage

### Running locally

```
$ cd lambda
$ pip install -r requirements.txt
$ python lambda.py
```

to view the log output on screen, run:

```
$ LOG_LEVEL=INFO python lambda.py
```

### Deploy to AWS Lambda with Terraform

Run:

```
$ cd terraform
$ terraform init
$ terraform apply
```


To prevent automatic upgrades to new major versions that may contain breaking
changes, we recommend adding version constraints in a required_providers block
in your configuration, with the constraint strings suggested below.

* hashicorp/archive: version = "~> 2.0.0"
* hashicorp/aws: version = "~> 3.15.0"
* hashicorp/null: version = "~> 3.0.0"
* hashicorp/random: version = "~> 3.0.0"
