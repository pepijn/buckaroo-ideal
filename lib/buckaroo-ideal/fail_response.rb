class Buckaroo::Ideal::FailResponse < Buckaroo::Ideal::Response
  attr_accessible :error_message
  def set_parameters
    @error_message = @parameters['brq_apierrormessage']
  end
end
