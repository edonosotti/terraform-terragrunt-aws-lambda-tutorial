# AWS Lambda deployment with Terraform & Terragrunt - Tutorial

**NOTE:** _This code was written for an
[article](https://medium.com/rockedscience/hard-lessons-from-deploying-lambda-functions-with-terraform-4b4f98b8fc39)
in the **RockedScience** publication on Medium._

## Description

This tutorial shows how to deploy a `Python` function on
[`AWS Lambda`](https://aws.amazon.com/lambda/) with
[`Terraform`](https://www.terraform.io) and
[`Terragrunt`](https://terragrunt.gruntwork.io).

The `Terraform` configuration can also:
 * install the required `Python` dependencies
 * keep track of changes to the code and dependencies
   to avoid re-deploying an unchanged function

`Terragrunt` is a wrapper for `Terraform` which helps
to manage multiple environments.

## Prerequisites

 * [`Python 3.8`](https://www.python.org/downloads/release/python-386/)
 * [`Terraform v0.13.5`](https://releases.hashicorp.com/terraform/0.13.5/)
 * [`AWS CLI 1.18.69`](https://aws.amazon.com/cli/?nc1=h_ls)
 * [`Terragrunt v0.26.2`](https://github.com/gruntwork-io/terragrunt/releases/tag/v0.26.2) _(optional)_

Optional:

 * [`Miniconda`](https://docs.conda.io/en/latest/miniconda.html),
   [`Conda`](https://docs.conda.io/en/latest/)

## Setup

 * Create an AWS account and get a `Access Key ID` and `Secret Access Key` pair
   ([read the docs](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html))
 * Install and configure the `AWS CLI`
   ([read the docs](https://docs.aws.amazon.com/polly/latest/dg/setup-aws-cli.html))
 * Install `Terraform`
   ([read the docs](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started))
 * Install `Python` or, with `Miniconda` or `Conda`, run:
   ```
   $ conda env create -n tflambda -f environment.yml
   $ source activate tflambda
   ```
   ([Python docs](https://wiki.python.org/moin/BeginnersGuide))
 * `Terragrunt` is optional, install it for a more advanced setup
   ([read the docs](https://terragrunt.gruntwork.io/docs/getting-started/install/#install-terragrunt))

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

### Deploying to AWS Lambda with Terraform

Run:

```
$ cd terraform
$ terraform init
$ terraform apply
```

If you have multiple AWS profiles and you want to set the profile to use:

```
$ AWS_PROFILE=myprofilename terraform apply
```

The `Terraform AWS provider` offers a number of options to set credentials,
[check the docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication)
for further details.

To deploy to a specific AWS `region`
(see [`variables.tf`](terraform/variables.tf) for defaults):

```
$ terraform apply -var aws_region="eu-west-1"
```

### Deploying to AWS Lambda with Terragrunt

2 sample `Terragrunt` configurations are provided:
 * [`terragrunt/eu`](terragrunt/eu) sets the AWS `region` to `eu-west-1`
 * [`terragrunt/us`](terragrunt/us) sets the AWS `region` to `us-east-1`

Run:

```
$ cd terragrunt/eu
$ terragrunt apply
```

change `/eu` to `/us` and repeat to try another region.

AWS profiles selection also applies to `Terragrunt`:

```
$ AWS_PROFILE=myprofilename terragrunt apply
```

### Cleaning up

Run:

```
$ cd terraform
$ terraform destroy
```

