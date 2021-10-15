This ReadMe file is meant to provide a brief overview of

- Terraspace - The Chosen IaC Framework to use with Terraform
- Terraspace - Setup and Configuration
- Required Tools
- Terraspace - Folder Structure
- Terraspace - Sample Commands

## Terraspace - The Chosen IaC Framework

This is a Terraspace project. It contains code to provision Cloud infrastructure built with [Terraform](https://www.terraform.io/) and the [Terraspace Framework](https://terraspace.cloud/).

## What is Terraspace?

Terraspace is a Terraform Framework that optimizes for infrastructure-as-code happiness. It provides an organized structure, conventions over configurations, keeps your code DRY, and adds convenient tooling. Terraspace makes working with Terraform easier and more fun.

## Terraspace - Setup and Configuration

There are a few things that we need to make sure are setup and installed correctly before running or using this framework. You need to have the following installed and setup

- Terraform - v1.0.0
- [Terraspace](https://terraspace.cloud/docs/install/standalone/ubuntu/)
- AWS CLI - v2 or Higher

## Terraspace - Current Folder Structure

The goal here is to create a level of abstraction so that we can have a single set of IaC that can be used to spin up n number of environments.

- app - Directory holds all of the terraform implementation.
- app/modules - Directory holds all the modules that are created in house (Abstract Layer).
- app/stacks - Holds all of the business logic, which is still to some extent an abstract implmentation.
- app/stacks/tfvars - Holds values for all the variables defined in stacks and make up for the stack deployment.
- [Terrafile](https://terraspace.cloud/docs/terrafile/) - This is a file where you add any and all third party provided modules that are being used in the implementation.

Terraspace Generators

```
terraspace new project <PROJECT_NAME>  # Generates new project
cd <PROJECT_NAME>
terraspace new stack <STACK_NAME>    # Generates new stack
terraspace new module NAME   # Generates new module
```

```
├── ReadME.MD
└── terraspace
    ├── app
    │   ├── modules
    │   └── stacks
    │       └── ghost-project
    │           ├── main.tf
    │           ├── outputs.tf
    │           └── variables.tf
    ├── config
    │   ├── app.rb
    │   └── terraform
    │       ├── backend.tf
    │       └── provider.tf
    ├── Gemfile
    ├── Gemfile.lock
    ├── .gitignore
    ├── README.md
    └── Terrafile

7 directories, 12 files
```

## Terraspace - Sample Commands

Let's say we want to run terraspace commands against our *Test* environment. There are a few things that we need to do and make sure before we run the terraspace commands.

```
export AWS_PROFILE=ax-test
export AWS_REGION=us-east-1
export ENV_NAME=test
```

To install the modules, run:

`terraspace bundle`

Initilize the terraform porject

`terraspace init <STACK_NAME>`

To get a plan output run

`TS_ENV=$ENV_NAME terraspace plan <STACK_NAME>`

To provision the infrastructure for a stack

`TS_ENV=$ENV_NAME terraspace up <STACK_NAME>`

To destroy the infrastructure for a stack

`TS_ENV=$ENV_NAME terraspace down <STACK_NAME>`

To clear all the logs and information

`terraspace clean all`

-To clear logs and info for a particular stack

`terraspace clean <STACK_NAME>`

To deploy all the infrastructure stacks:

`terraspace all up`



