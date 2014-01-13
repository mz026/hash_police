class HashPolice::CheckResult
  attr_reader :errors
  def missing key
    errors[key.to_s] = "missing key"
  end

  def errors
    @errors ||= {}
  end
  
  def pass?
    errors == {}
  end
end
