class Generalizer

  def initialize(urls)
    @urls = urls
  end

  def generalized_urls
    url_patterns = {}

    @urls.each do |url, metadata|
      replaced = replace(url)

      if url_patterns[replaced]
        url_patterns[replaced]['count'] += metadata['count']
        url_patterns[replaced]['params'] << metadata['params']
      else
        url_patterns[replaced] = {
          'count' => metadata['count'],
          'method' => metadata['method'],
          'params' => []
        }
      end
    end

    url_patterns
  end

  def replace(url)
    parts = url.split('/')
    parts.shift

    parts = parts.reject { |part| part == 'v2' }

    parts = parts.map do |part|
      if part.match(/.*[0-9].*/) && !part.include?('.json')
        ':id'
      else
        part
      end
    end

    '/' + parts.join('/')
  end

end
