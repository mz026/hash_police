require "hash_police/check_result"
module HashPolice
  class Police
    def initialize rule
      @rule = rule
      @passed = false
    end

    def check hash
      result = CheckResult.new
      @rule.each do |key, val|
        unless hash.has_key?(key)
          result.missing(key)
          next
        end
        unless type_matched?(val, hash[key])
          result.differ_type(key, :expect => val.class, 
                                  :got => hash[key].class) 
          next
        end

      end
      result
    end

    private
    def type_matched? rule, target
      return true if is_bool(rule) && is_bool(target)
      rule.class == target.class
    end

    def is_bool val
      !! val == val
    end

  end
end
