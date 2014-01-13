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
        result.differ_type(:expect => rule.class, :got => target.class)
        return result
      end

      unless scalar?(rule)
        context_prefix = context_key == "" ? "" : "#{context_key}."
        if rule.kind_of?(Array)
          target.each_with_index do |t, index|
            police = self.class.new(rule.first, "#{context_prefix}#{index}")
            result.concat(police.check(t))
          end
        end

        if rule.kind_of?(Hash)
          rule = stringify_keys(self.rule)
          target = stringify_keys(target)

          rule.each do |rule_key, rule_val|
            if target.has_key?(rule_key)
              police = self.class.new(rule_val, "#{context_prefix}#{rule_key}")
              result.concat(police.check(target[rule_key]))
            else
              result.missing("#{context_prefix}#{rule_key}")
            end
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

    def stringify_keys hash
      JSON.parse(hash.to_json, :quirks_mode => true)
    end

  end
end
