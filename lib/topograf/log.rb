module Topograf
  class Log

    attr_reader :log

    def initialize(file)
      @file = file
    end

    def log
      @log ||= read
    end

    private

    def read
      if File.exists?(@file) && File.directory?(@file)
        logs = Dir.glob("#{@file}/*").collect { |log_file| File.read(log_file) }
        logs.join("\n")
      elsif File.exists?(@file)
        File.read(@file)
      end
    end

  end
end
