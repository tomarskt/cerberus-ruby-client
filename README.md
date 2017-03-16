# Cerberus Ruby Client

This is a Ruby based client library for communicating with Vault via HTTP and enables authentication schemes specific
to AWS and Cerberus.

This client currently supports read-only operations (write operations are not yet implemented, feel free to open a
pull request to implement write operations)

To learn more about Cerberus, please visit the [Cerberus website](http://engineering.nike.com/cerberus/).

## Installation

These installation instructions need to be updated after we open source and publish the gems somewhere public

Add this to your application's Gemfile:

```ruby
source "https://xxx/gems/nike-gems"
gem 'cerberus_client' 
```

And then install it:
```bash
$ bundle
```
    
Or do it yourself:
```bash 
$ gem install cerberus_client --source "https://xxx/gems/nike-gems"
```

## Usage

Please start by reading the [Cerberus quick start guide](http://engineering.nike.com/cerberus/docs/user-guide/quick-start).

```ruby
vaultClient = CerberusClient::getVaultClient()
```

There are two ways Cerberus clients are typically used:

1. Local Development using environmental variables created using [cerberus-token.sh](https://raw.githubusercontent.com/Nike-Inc/cerberus/master/docs/user-guide/cerberus-token.sh)
2. Running in AWS using [EC2 instance or Lambda Authentication](http://engineering.nike.com/cerberus/docs/architecture/authentication)

### Local Development

The example Ruby code above uses the DefaultUrlResolver to resolve the URL for Vault. For that to succeed, the
environment variable, CERBERUS_ADDR, must be set:
```bash
export CERBERUS_ADDR=https://cerberus.example.com
```

The example above also use the DefaultCredentialsProviderChain which is used to resolve the token needed to interact 
with Vault. This chain will first look to see if an environemnt variable has been set with a vault token, e.g.
```bash
export CERBERUS_TOKEN=9cfced14-91ae-e3ad-5b9d-1cae6c82362d
```

### Running in AWS

If the environment variables used in local development are not found, the client will try to use the AWS metadata
service and instance metadata to authenticate with Cerberus using the IAM role assigned to the instance.  Instructions
are available in the [Cerberus quick start guide](http://engineering.nike.com/cerberus/docs/user-guide/quick-start).

Optionally, UrlResolver and/or CredentialsProviderChain can be provided to customize how those values are used in
your system. See lib/cerberus_client for alternative factory methods and the functions your custom objects should
support.



