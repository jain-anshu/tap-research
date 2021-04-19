require 'crypto'

# Abstract class for all REST APIs that are being called
# from this application.
# rubocop:disable Metrics/ClassLength
class RestAPI
  include Sanitization
  attr_accessor :options

  PAYLOAD_VERBS = [:post, :patch, :put].freeze
  FILTER_FIELDS = [:password, 'payload.client_id', 'payload.client_secret', 'payload.password', 'payload.credentials.password.value', 'headers.authorization', 'payload.token', 'auth_token'].freeze
  WAIVED_APIS = ['SalesforceCreditCheckAPI', 'Ml::ElectricMeterApi'].freeze

  def initialize(options)
    @options = options
  end

  def base_url
    raise "You need to specify base_url in the descendant of RESTAPI if you use :path option"
  end

  def default_options
    {
      json: true, # has a meaning only in POST/PATCH/PUT requests
      method: :get
    }
  end

  def call
    options = prepared_call_options
    @response = rest_request(options)
    @response
  end

  def response
    JSON.parse(@response.body, symbolize_names: true)
  end

  def response_code
    @response.code.to_i
  end

  def success?
    response_code == 200
  end

  def rest_request(options)
    log_options = options
    log_api_call("REQUEST", params: log_options)
    response = allow_external? ? external_rest_request(options) : mocked_response
    log_api_call("RESPONSE_SUCCESS", body: response.body.inspect, status: response.code)

    response
  end

  def external_rest_request(options)
    RestClient::Request.execute(options)
  rescue RestClient::ExceptionWithResponse => e
    log_api_call("RESPONSE_FAILED", body: e.response.body.inspect, status: e.response.code)
    raise
  end

  private

  def prepared_call_options
    options = default_options.deep_merge(@options || {})
    process_options(options)
  end

  def process_options(options)
    process_rest_options(options)
  end

  # Adds:
  #  :params - for unified GET/POST request:
  #    for GET it's headers/params, for POST it's payload
  #  :json - in case of a POST request, the request will be converted to JSON
  #  :path - not to need to add base_url on each call
  def process_rest_options(options)
    process_params(options)
    process_path(options)
    process_json_format(options)
    options
  end

  def process_path(options)
    path = options.delete(:path)
    options[:url] = base_url + path if path
    options
  end

  def process_params(options)
    params = options.delete(:params)
    return options unless params

    options[:headers] ||= {}
    if payload_verb?(options)
      options[:payload] = params
    else
      options[:headers][:params] = params
    end
    options
  end

  def process_json_format(options)
    json = options.delete(:json)
    return options unless json && payload_verb?(options)

    options[:payload] = options[:payload].to_json
    options[:headers][:content_type] = :json
    options[:headers][:accept] = :json
    options
  end

  def payload_verb?(options)
    query_method = options[:method].to_sym
    PAYLOAD_VERBS.include?(query_method)
  end

  def allow_external?
    ENV['ALLOW_EXTERNAL_CALLS'] == 'true'
  end

  def mocked_response
    OpenStruct.new(
      code: 200,
      body: { success: true, mocked_response: true }.to_json
    )
  end

  def prod_env?
    ENV['DEFAULT_HOST'] == 'sds.mysunpower.com'
  end

  def request_params_filter?(service)
    prod_env? && !WAIVED_APIS.include?(service)
  end

  def response_body_filter?(stage, service)
    prod_env? && !WAIVED_APIS.include?(service) && stage != 'RESPONSE_FAILED'
  end

  def response_body_encrypt?(stage, service)
    prod_env? && WAIVED_APIS.include?(service) && stage != 'RESPONSE_FAILED'
  end

  # rubocop:disable Metrics/AbcSize
  def log_api_call(stage = 'request', options = {})
    options[:service] ||= self.class

    if options[:params].present?
      options[:params] = options[:params].except(:payload) if request_params_filter?(options[:service]&.name)
      options[:params] = sanitize(options[:params], FILTER_FIELDS)
    end
    options[:body] = Crypto.safe_encode_json_token(options[:body]) if response_body_encrypt?(stage, options[:service]&.name)
    options = options.except(:body) if response_body_filter?(stage, options[:service]&.name)

    real = allow_external?
    prefix = "[API][#{stage}][#{real ? 'REAL' : 'MOCK'}] "
    message = prefix + options.map { |k, v| "#{k}: #{v}" }.join('; ')
    Rails.logger.info message
  end
  # rubocop:enable Metrics/AbcSize
end
# rubocop:enable Metrics/ClassLength
