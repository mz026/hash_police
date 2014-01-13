require "hash_police/check_result"
module HashPolice
  class Police
    attr_reader :rule, :context_key
    def initialize rule, context_key = ""
      @rule = rule
      @passed = false
      @context_key = context_key
    end

    def check target
      result = CheckResult.new(context_key)
      unless type_matched?(rule, target)
        if context_key != "" && target.nil?
          result.missing
        else
          result.differ_type(:expect => rule.class, :got => target.class)
        end
        return result
      end

      unless scalar?(rule)
        if rule.kind_of?(Array)
          target.each_with_index do |t, index|
            police = self.class.new(rule.first, "#{context_key}.#{index}")
            result.concat(police.check(t))
          end
        end

        if rule.kind_of?(Hash)
          rule.each do |rule_key, rule_val|
            police = self.class.new(rule_val, "#{context_key}.#{rule_key}")
            result.concat(police.check(target[rule_key]))
          end
        end
      end

      result
    end

    private
    def type_matched? rule, target
      return true if bool?(rule) && bool?(target)
      rule.class == target.class
    end

    def bool? val
      !! val == val
    end

    def scalar? val
      ! val.kind_of?(Array) && ! val.kind_of?(Hash)
    end

  end
end
