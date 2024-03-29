![test action workflow](https://github.com/joelpereira/terraform-provider-densify/actions/workflows/test.yml/badge.svg?branch=main)
![GitHub issues](https://img.shields.io/github/issues/joelpereira/terraform-provider-densify)
![GitHub](https://img.shields.io/github/license/joelpereira/terraform-provider-densify)

<img src="https://www.densify.com/wp-content/uploads/densify.png" width="250">

# Densify Terraform Provider
This provider interfaces between Densify machine learning analytics and Terraform templates.
It enables two operations:
- automated optimization of instance families/sizes, and container resource requests/limits (making them “self-optimizing”)
- auto-tagging of cloud instances and containers based on Densify’s optimization analysis (making them “self-aware”)

This integration is based on the Densify SaaS engine API which contains operational intelligence, analysis findings, and optimization recommendations for each cloud instance or container in scope.
The result is next-generation resource optimization with the elimination of hard-coded resource specifications.

- [Requirements](#requirements)
- [Usage](#usage)
- [Documentation](#docs)
- [Examples](#examples)
- [Inputs](#inputs)
- [Outputs](#outputs)
- [License](#license)

## Requirements
- Densify service account, which is provided with a Densify subscription or free trial (www.densify.com/product/trial)
- Go (v1.21+ for building the provider only)

## Usage

```hcl
terraform {
  required_providers {
    densify = {
      source = "densify.com/provider/densify"
    }
  }
}

provider "densify" {
  # credentials and other parameters can be passed in to the Densify Provider as environment variables

  tech_platform = "aws"
  account_number = "1234567890"
  system_name = "system-name-321"
}
data "densify_cloud" "optimization" {}
```

Then we can simply utilize the optimized instance that Densify recommended:
```hcl
...
instance_type = data.densify_cloud.optimization.recommended_type
...
```

### Data Sources
There are two data sources available within the Densify Provider:
| Name | Description | Call |
|------|-------------|:-------:|
| Cloud Recommendation | This returns one cloud (AWS/Azure/GCP) recommendation from Densify | _cloud |
| Container Recommendation | This returns one container (Kubernetes) recommendation from Densify | _container |

## Documentation

You can find the generated documentation in the [docs folder](docs/).

## Examples 
* [Cloud Optimization Test Output](examples/data-sources/cloud-optimization-test-output)
* [AWS EC2](examples/data-sources/aws-ec2)
* [Kubernetes Deployment](examples/data-sources/k8s-deployment)
* [Kubernetes Optimization Test Output](examples/data-sources/k8s-optimization-test-output)

## Inputs

### Densify Cloud Recommendation
Inputs for "_cloud" provider call are:

| Name | Description | Type | Environment Variable | Required |
|------|-------------|:----:|:--------------------:|:--------:|
| densify_instance | Your Densify SaaS instance URL to pull recommendations | String | DENSIFY_INSTANCE | Yes |
| username | Densify service account user name (you can request one by contacting your Account Manager or support@densify.com) | String | DENSIFY_USERNAME | Yes |
| password | Densify service account password  | String | DENSIFY_PASSWORD | Yes |
| tech_platform | The technology platform or CSP (cloud service provider) being used. Select one of the following options: aws, azure, gcp, kubernetes. | String | DENSIFY_TECH_PLATFORM | Yes |
| account_number | description | String | DENSIFY_ACCOUNT_NUMBER | Yes |
| system_name | description | String | DENSIFY_SYSTEM_NAME | Yes |
| fallback | The fallback/default instance type | String | DENSIFY_FALLBACK | No |
| continue_if_error | Continue if there is an error so that we don't impact the deployment pipeline | Bool | DENSIFY_CONTINUE_IF_ERROR | No |


### Densify Container Recommendation
Inputs for "_container" provider call are:

| Name | Description | Type | Environment Variable | Required |
|------|-------------|:----:|:--------------------:|:--------:|
| densify_instance | Your Densify SaaS instance URL to pull recommendations | String | DENSIFY_INSTANCE | Yes |
| username | Densify service account user name (you can request one by contacting your Account Manager or support@densify.com) | String | DENSIFY_USERNAME | Yes |
| password | Densify service account password  | String | DENSIFY_PASSWORD | Yes |
| tech_platform | The technology platform or CSP (cloud service provider) being used. Select one of the following options: aws, azure, gcp, kubernetes. | String | DENSIFY_TECH_PLATFORM | Yes |
| cluster | description | String | DENSIFY_CLUSTER | Yes |
| namespace  | description | String | DENSIFY_NAMESPACE | Yes |
| controller_type | description | String | DENSIFY_CONTROLLER_TYPE | Yes |
| pod_name | description | String | DENSIFY_POD_NAME | Yes |
| container_name | description | String | DENSIFY_CONTAINER_NAME | Yes |
| fallback_cpu_req | The fallback/default CPU Request value | String | none | No |
| fallback_cpu_lim | The fallback/default CPU Limit value | String | none | No |
| fallback_mem_req | The fallback/default Memory Request value | String | none | No |
| fallback_mem_lim | The fallback/default Memory Limit value | String | none | No |
| continue_if_error | Continue if there is an error so that we don't impact the deployment pipeline | Bool | DENSIFY_CONTINUE_IF_ERROR | No |


## Outputs

### Densify Cloud Recommendation
Outputs for "_cloud" provider call are:

| Name | Type | Description |
|------|------|-------------|
| entity_id | String | Unique identifier for cloud resource. |
| name | String | System name for the compute resource. |
| current_type | String | Current instance type. |
| recommended_type | String | Recommended instance type generated by Densify. |
| approved_type | String | The approved instance type. This starts with the fallback instance or the current instance type, and may only be replaced by the recommended instance if 'Approval_Type' is set. |
| optimization_type | String | Type of optimization. Ex. Downsize, Upsize, Terminate, etc. |
| account_id | String | Account reference identifier. |
| approval_type | String | Approval type. If ITSM integration has been enabled, this field will identify whether the recommendation has been reviewed & approved. |
| savings_estimate | Float64 | Estimated monthly savings by applying the optimization recommendation. |
| effort_estimate | String | Estimated effort required by applying optimization recommendation. Ex. none, low, med, high. |

### Densify Container Recommendation
Outputs for "_container" provider call are:

| Name | Description |
|------|-------------|
| entity_id | String | Unique identifier for cloud resource. |
| name | String | Container manifest name. |
| optimization_type | String | Type of optimization. Ex. Downsize, Upsize, Terminate, etc. |
| account_id | String | Account reference identifier. |
| approval_type | String | Approval type. If ITSM integration has been enabled, this field will identify whether the recommendation has been reviewed & approved. |
| cluster | String | desc |
| namespace | String | desc |
| controller_type | String | desc |
| pod_name | String | desc |
| container_name | String | desc |
| current_cpu_req | String | The current CPU Request for resources (in millicores or m). |
| current_cpu_limit | String | The current CPU Limit for resources (in millicores or m). |
| current_mem_req | String | The current Memory Request for resources (in mebibytes or Mi). |
| current_mem_limit | String | The current Memory Limit for resources (in mebibytes or Mi). |
| recommended_cpu_req | String | The recommended CPU Request for resources (in millicores or m). |
| recommended_cpu_limit | String | The recommended CPU Limit for resources (in millicores or m). |
| recommended_mem_req | String | The recommended Memory Request for resources (in mebibytes or Mi). |
| recommended_mem_limit | String | The recommended Memory Limit for resources (in mebibytes or Mi). |


## License

Apache 2 Licensed. See LICENSE for full details.


# How to Build the Densify Terraform Provider

## Requirements

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.0
- [Go](https://golang.org/doc/install) >= 1.21

## Building the Provider

If you wish to work on the provider, you'll first need [Go](http://www.golang.org) installed on your machine (see [Requirements](#requirements) above).

To compile the provider as an executable (.exe), run `go build`.

To compile & install the provider, run the steps below to pull the required package(s) and this will build the provider and put the provider binary in the `$GOPATH/bin` directory.
```
go get -u github.com/joelpereira/densify-api-client-go
#or pull a specific/newer tag
go get -u github.com/joelpereira/densify-api-client-go@v0.8.11

go mod tidy
go install .
```

To generate or update documentation, run `go generate`.
