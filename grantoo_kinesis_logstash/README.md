# grantoo_kinesis_logstash-cookbook

Setup the LogStash configuration to extract Grantoo Events from S3 files,
transform them and push them to ElasticSearch.

## Attributes

Please see the example in the `Vagrantfile`.

## Usage

### grantoo_kinesis_logstash::default

Include `grantoo_kinesis_logstash` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[grantoo_kinesis_logstash::default]"
  ]
}
```

## License and Authors

Author:: Philippe Creux
