#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), 'lib/topograf')

@config = Topograf::Config.new

def process(requests_by_method)
  aggregated_results = {}

  requests_by_method.each do |request|
    if aggregated_results[request['url']] && aggregated_results[request['url']]['method'] == request['method']
      aggregated_results[request['url']]['count'] += 1
    else
      aggregated_results[request['url']] = {'count' => 1, 'method' => request['method'], 'params' => request['params']}
    end
  end

  aggregated_results
end

def report(requests)
  puts "****** Method Counts ******"
  puts "GET:    #{requests.select { |request, metadata| metadata['method'] == 'get' }.length}"
  puts "POST:   #{requests.select { |request, metadata| metadata['method'] == 'post' }.length}"
  puts "PUT:    #{requests.select { |request, metadata| metadata['method'] == 'put' }.length}"
  puts "DELETE: #{requests.select { |request, metadata| metadata['method'] == 'delete' }.length}"

  requests = requests.sort_by { |request, metadata| metadata['count'] }
  requests.reverse!
  puts
  puts "****** Request Counts *****"
  puts "Total Requests: #{total_requests(requests)}"
  requests[0...@config.settings.results_max].each do |request, metadata|
    puts "#{metadata['count']}(#{((metadata['count'].to_f/total_requests(requests).to_f) * 100).round(2)}%): #{metadata['method'].upcase} #{request}"
  end
end

def total_requests(urls)
  urls.map { |url, metadata| metadata['count'] }.reduce(:+)
end

exit(1) unless ARGV.length == 1
param = ARGV[0]

log = Topograf::Log.new(param).log

results = Topograf::Parser.new(log, @config.settings.filtered_urls).parse
results = process(results)

generalizer = Generalizer.new(results)
urls = generalizer.generalized_urls

report(urls)
