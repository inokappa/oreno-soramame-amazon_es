#!/usr/bin/env ruby

require 'open-uri'
require 'uri'
require 'nokogiri'
require 'date'
require 'json'
require 'nkf'
require 'logger'
require './lib/elasticsearch'

#
$url = 'https://' + ENV['ES_HOST']
# 
def logging
  Logger.new(STDOUT)
end
#
def processing_soramame_content(uri, check_date_time, check_time)
  # Split for index_date
  index_date = check_date_time.split(' ')
  # for debug
  # html = NKF.nkf("--utf8", open(ARGV[0]).read)
  html = NKF.nkf("--utf8", open(uri).read)

  # Parse content and post to Elasticsearch
  header = ['CHECK_DATE_TIME','CHECK_TIME','mon_st_code','town_name', 'mon_st_name', 'SO2','NO','NO2','NOX','CO','OX','NMHC','CH4','THC','SPM','PM2_5','SP','WD','WS','TEMP','HUM','mon_st_kind']
  doc = Nokogiri::HTML.parse(html, nil, nil)
  doc.xpath('//tr[td]').each do |tr|
    row = tr.xpath('td').map { |td| td.content.gsub(/[\u00A0\n]|\-\-\-/,'NA') }
    row.unshift(check_time)
    row.unshift(check_date_time)
    ary = [header,row].transpose
    h = Hash[*ary.flatten]
    record = {'CHECK_DATE_TIME' => h['CHECK_DATE_TIME'],
              'CHECK_TIME' => h['CHECK_TIME'],
              'town_name' => h['town_name'],
              'mon_st_name' => h['mon_st_name'],
              'PM2_5' => h['PM2_5'].include?('NA') ? h['PM2_5'] = '' : h['PM2_5'],
              'TEMP' => h['TEMP'].include?('NA') ? h['TEMP'] = '' : h['TEMP']
    }
    logging.info("Put to Elasticsearch...")
    post_to_elasticsearch($url, "pm25_" + index_date[0], "kyushu", record)
  end
end

#
# Main
#
d = (Date.today - 1)
logging.info("Start ...")
# Create Elasticsearch Index
create_index($url, "pm25_" + d.strftime("%Y-%m-%d"))  
#
(1..24).each do |h| 
  h = "%02d" % h
  check_date_time = d.strftime("%Y-%m-%d") + " #{h}:00:00"
  uri = 'http://soramame.taiki.go.jp/Gazou/Hyou/AllMst/' + d.strftime("%Y%m%d") + '/hb' + d.strftime("%Y%m%d") + h + '08.html'
  logging.info("fetch from: " + uri)
  processing_soramame_content(uri, check_date_time, h)
end
