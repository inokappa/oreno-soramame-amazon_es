#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'json'
require 'net/http'
require 'uri'

def post_to_elasticsearch(json, id) 
  uri  = "https://" + ENV["ES_HOST"] + "/.kibana-4/visualization/#{id}"
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
    array = line.split("\t")
    template = <<EOS
  {    
    "title": "#{array[0].chomp}",
    "visState": "{\\"type\\":\\"line\\",\\"params\\":{\\"shareYAxis\\":true,\\"addTooltip\\":true,\\"addLegend\\":true,\\"showCircles\\":true,\\"smoothLines\\":false,\\"interpolate\\":\\"linear\\",\\"scale\\":\\"linear\\",\\"drawLinesBetweenPoints\\":true,\\"radiusRatio\\":9,\\"times\\":[],\\"addTimeMarker\\":false,\\"defaultYExtents\\":false,\\"setYExtents\\":false,\\"yAxis\\":{}},\\"aggs\\":[{\\"id\\":\\"1\\",\\"type\\":\\"avg\\",\\"schema\\":\\"metric\\",\\"params\\":{\\"field\\":\\"PM2_5\\"}},{\\"id\\":\\"2\\",\\"type\\":\\"date_histogram\\",\\"schema\\":\\"segment\\",\\"params\\":{\\"field\\":\\"CHECK_DATE_TIME\\",\\"interval\\":\\"auto\\",\\"customInterval\\":\\"2h\\",\\"min_doc_count\\":1,\\"extended_bounds\\":{}}}],\\"listeners\\":{}}",
    "description": "",
    "savedSearchId": "#{array[1].chomp}",
    "version": 1,
    "kibanaSavedObjectMeta": {
      "searchSourceJSON": "{\\"filter\\":[]}"
    }
  }
EOS
    lines += 1
    File.write("/tmp/visualize/#{lines}-#{line.chomp}.txt", template)
    # post_to_elasticsearch(template, array[1].chomp)
    puts "visualize ok"
  end
end
