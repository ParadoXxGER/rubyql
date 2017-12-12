class RubyQL
  attr_accessor :params

  def initialize(params, json = false)
    if json
      @params = JSON.parse(params)
    else
      @params = params
    end
  end

  def execute
    query.select do |key, value|
      response_attr.key? key
    end.merge query_params
  end

  def query_params
    @params.reject do |key, value|
      value == '' || value.nil?
    end
  end

  private

  def response_attr
    @params.select do |key, value|
      value == '' || value.nil?
    end
  end

  def query; end

end

