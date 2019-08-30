module Topograf
  class Parser

    def initialize(log, filtered_urls = [])
      @log = log
      @filtered_urls = filtered_urls
    end

    def parse
      lines = @log.split("\n")
      lines = requests(lines)

      results = []

      lines.each do |line|
        if line.include? 'GET'
          results << item(line, 'GET')
        elsif line.include? 'POST'
          results << item(line, 'POST')
        elsif line.include? 'PUT'
          results << item(line, 'PUT')
        elsif line.include? 'DELETE'
          results << item(line, 'DELETE')
        end
      end

      results.select do |url|
        !filtered?(url['url'])
      end
    end

    private
    def filtered?(url)
      @filtered_urls.any? { |filter| url.include?(filter) }
    end

    def extract_url(line, method)
      line.split(method.upcase)[1].split(" ")[0].gsub('"', '')
    end

    def extract_params(url)
      params = []
      params = url.split('?')[1] if params.include?('?')
      params = params.split('&') if params.include?('&')
      params
    end

    def item(line, method)
      url = extract_url(line, method)

      {
        'method' => method.downcase,
        'url' => url.split('?')[0],
        'params' => extract_params(url)
      }
    end

    def requests(lines)
      requests = lines.select do |line|
        line.include?("Started")
      end
    end

  end
end
