#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'json'
require 'net/http'
require 'uri'

def post_to_elasticsearch(json, id)
  uri  = "https://" + ENV["ES_HOST"] + "/.kibana-4/search/#{id}"
  uri  = URI.parse(uri)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  req  = Net::HTTP::Post.new(uri.request_uri)

  puts json
  req["Content-Type"] = "application/json"
  req.body = json
  res = http.request(req)

  puts "code -> #{res.code}"
  puts "msg  -> #{res.message}"
  puts "body -> #{res.body}"
end

lines = 0
File.open('/tmp/place_name.tsv', "r:UTF-8") do |file|
  file.each_line do |line|
    puts line
    array = line.split("\t")
    template = <<EOS
{
  "title": "#{array[0].chomp}",
  "description": "",
  "hits": 0,
  "columns": [
    "_source"
  ],
  "sort": [
    "CHECK_DATE_TIME",
    "desc"
  ],
  "version": 1,
  "kibanaSavedObjectMeta": {
    "searchSourceJSON": "{\\"index\\":\\"[pm25_]YYYY-MM-DD\\",\\"highlight\\":{\\"pre_tags\\":\\"@kibana-highlighted-field@\\",\\"post_tags\\":\\"@/kibana-highlighted-field@\\",\\"fields\\":{\\"*\\":{}},\\"fragment_size\\":2147483647},\\"filter\\":[],\\"query\\":{\\"query_string\\":{\\"query\\":\\"mon_st_name:\\\\\\"#{array[0].chomp}\\\\\\"\\",\\"analyze_wildcard\\":true}}}"
  }
}
EOS
    lines += 1
    File.write("/tmp/search/#{lines}-#{line.chomp}.txt", template)
    # puts template
    post_to_elasticsearch(template, array[1].chomp)
  end
end
