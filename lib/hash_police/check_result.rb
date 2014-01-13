class HashPolice::CheckResult
  attr_reader :context_key

  def initialize context_key
    @context_key = context_key
    @errors = []
    @children = []
  end

  def differ_type options
    @errors << "`#{context_key}`: expect #{options[:expect]}, got #{options[:got]}"
  end

  def error_messages
    all_errors.join("; ")
  end

  def all_errors
    @children.reduce(@errors) do |memo, child|
      memo + child.all_errors
    end
  end

  def concat child_result
    @children << child_result
  end

  def missing
    @errors << "`#{context_key}`: missing"
  end
end
