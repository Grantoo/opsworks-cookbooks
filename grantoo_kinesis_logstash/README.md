# grantoo_kinesis_logstash-cookbook

Setup the LogStash configuration to extract Grantoo Events from S3 files,
transform them and push them to ElasticSearch.

## Attributes

You should define attributes to connect to the S3 bucket and to the
ElasticSearch server. Here is an example:

```ruby
  java: {
    jdk_version: '7'
  },

  # required by chef-logstash cookbook
  logstash: {
    instance: { agent: {} }
  },

  kinesis_logstash: {
    input: { # via s3
      aws_credentials: ["my-key", "my-secret"],
      bucket: "my-bucket"
    },
    output: { # via elasticsearch_http
      host: "localhost",
      port: "9200",
      # basic auth
      user: "",
      password: ""
    }
  }
```

Please see the example in the `Vagrantfile`.

## Usage

### grantoo_kinesis_logstash::default

Include `grantoo_kinesis_logstash` in your node's `run_list` as well as
its dependencies:

```json
{
  "run_list": [
    "apt",
    "java::default",
    "curl::default",
    "logstash::agent",
    "grantoo_kinesis_logstash::default"
  ]
}
```

## License and Authors

Author:: Philippe Creux for Fuel Powered
