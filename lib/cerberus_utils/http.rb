
module CerberusUtils

  require_relative('../cerberus/exception/http_error')
  require('net/http')
  require_relative('log')
  require_relative('version')

  ##
  #
  ##
  class Http

    ##
    # Generic HTTP handler for Cerberus Client needs
    # uri: the fully qualified URI object to call
    # method: the HTTP method to use'
    # use_ssl: boolean - use HTTPS or not
    # json_data: if not nil, made the request body and 'Content-Type' header is set to "application/json"
    # headers: if not nil, should be a HashMap of header Key, Values
    ##
    def make_http_call(uri, method, use_ssl, json_data = nil, headers_map = nil)

      begin
        CerberusUtils::Log.instance.debug("Http::make_http_call -> uri: #{uri}, method: #{method}, use_ssl: #{use_ssl}, json_data: #{json_data}")

        http = Net::HTTP.new(uri.host, uri.port)

        request =
            case method
              when 'GET'
                Net::HTTP::Get.new(uri.request_uri)
              when 'POST'
                Net::HTTP::Post.new(uri.request_uri)
              else
                raise NotImplementedError
            end

        if(json_data != nil); request.body = "#{json_data}"; request['Content-Type'] = "application/json"; end

        if(headers_map != nil); headers_map.each{ |headerKey, headerValue| request[headerKey] = headerValue } end
        request['X-Cerberus-Client'] = "CerberusRubyClient/#{CerberusUtils::VERSION}"

        puts request
        http.use_ssl = use_ssl
        response = http.request(request)

        # this is just for convenience handling down the stack... response object inclucded with the exception
        if(response.code.to_i < 200 || response.code.to_i >= 300)
          raise Cerberus::Exception::HttpError.new(
              "Http response code is non-2xx value: #{response.code}, #{response.body}",
              response)
        end

        return response

      rescue => ex
        # log a warning
        Log.instance.warn("Exception executing http: #{ex.message}, ex.class #{ex.class}")

        # check to see if we threw the Http error with a response object
        response = (ex.instance_of?(Cerberus::Exception::HttpError)) ? ex.response : nil

        # raise a specific error that some policy can be enforced on
        raise Cerberus::Exception::HttpError.new(ex.message, response)
      end
    end

  end
end
