require 'json'

class RubyQL
  attr_accessor :params

  def initialize(params)
    if params.is_a?(JSON)
      @params = JSON.parse(params)
    elsif params.is_a?(Hash)
      @params = params
    else
      raise
    end
  end

  def execute
    return {} if query.nil?
    query.select do |key, value|
      response_attr.key? key
    end.merge query_params
  end

  def query_params
    @params.reject do |key, value|
      value == '' || value.nil?
    end
  end

  def response_attr
    @params.select do |key, value|
      value == '' || value.nil?
    end
  end

  def query; end

end

