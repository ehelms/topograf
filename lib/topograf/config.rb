require 'yaml'
require 'ostruct'

module Topograf
  class Config

    attr_reader :settings

    def initialize
      @settings = OpenStruct.new(load_settings)
    end

    def load_settings
      YAML.load_file('config/settings.yaml')
    end

  end
end
