RSpec::Matchers.define :have_the_same_hash_format_as do |expected|
  result = nil
 
  match do |actual|
    police = HashPolice::Police.new(expected)
    result = police.check(actual)
    result.passed?
  end
 
  failure_message do |actual|
    result.error_messages
  end
end
