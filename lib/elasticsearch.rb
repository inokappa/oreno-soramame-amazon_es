#!/usr/bin/env ruby

require 'json'
require 'net/http'
require 'uri'
require 'elasticsearch'

def bulk_post(uri, data)
  puts data
  c = Elasticsearch::Client.new log: true, url: uri
  c.bulk body:data
end

def http_request(uri, body)
  uri  = URI.parse(uri)
  http = Net::HTTP.new(uri.host, uri.port)
  # http.use_ssl = true
  req  = Net::HTTP::Post.new(uri.request_uri)
  req["Content-Type"] = "application/json"
  req.body = body
  http.request(req)
end

def create_index(es_host, index)
  uri  = "#{es_host}" + "/" + "#{index}" 
  mapping = <<EOS
{
  "mappings" : {
    "kyushu" : {
      "properties" : {
        "town_name" : {
          "type" : "string"
        },
        "mon_st_name" : {
          "type" : "string"
        },
        "PM2_5" : {
          "type" : "long"
        },
        "TEMP" : {
          "type" : "long"
        },
        "CHECK_TIME" : {
          "type" : "long"
        },
        "CHECK_DATE_TIME" : {
          "format" : "YYYY-MM-dd kk:mm:ss","type" : "date"
        }
      }
    }
  }
}
EOS
  res = http_request(uri, mapping)
  logging.info("code: #{res.code}, msg: #{res.message}, body: #{res.body}")
end

def post_to_elasticsearch(es_host, index, type, record)
  uri  = "#{es_host}" + "/" + "#{index}" + "/" + "#{type}"
  res = http_request(uri, record.to_json)
  logging.info("code: #{res.code}, msg: #{res.message}, body: #{res.body}")
end
