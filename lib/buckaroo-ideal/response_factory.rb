class ResponseFactory
  def initialize params
    if params.is_a? String
      params = parameterise params
    end
    @result =
    case params['brq_apiresult']
      'Success': SuccessResponse.new params
      # 'Reject': RejectResponse.new params
      # 'Cancel': CancelResponse.new params
      'Fail': FailResponse.new params
      # 'Pending': PendingResponse.new params
      # 'ActionRequired': ActionRequiredResponse.new params
      # 'Waiting': WaitingResponse.new params
      # 'OnHold': OnHoldResponse.new params
    else
      raise "Unknown API result"
    end


  end

private
  def parameterise response
    response_hash = {}
    response.split("&").each do |param|
      p = param.split "="
      response_hash[p[0].downcase] = CGI.unescape p[1]
    end
    response_hash
  end
end
