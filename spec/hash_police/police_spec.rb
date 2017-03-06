require "hash_police"
require "json"

describe HashPolice::Police do
  describe "::new(rule)" do
    it "takes a rule hash to init" do
      police = HashPolice::Police.new({ :hello => "world" })
    end
  end

  describe "#check(target)" do
    let(:police) { HashPolice::Police.new(rule) }
    let(:rule) { "a string" }
    let(:target) { rule.clone }
    let(:result) { double(:result, :concat => nil ) }

    before(:each) do
      allow(HashPolice::CheckResult).to receive(:new).and_return(result)
    end

    context "when rule is scalar value" do
      it "passes if a string" do
        allow(HashPolice::CheckResult).to receive(:new).and_return(double)
        police.check "another string"
      end

      it "failed if type not match" do
        expect(result).to receive(:differ_type).with(:expect => String, :got => Fixnum)
        police.check 12345
      end
    end

    context "when rule is scalar value and rule is kind of Proc" do
      let(:rule) { lambda { |str| str.nil? || str.kind_of?(String) } }

      it "passes if a string" do
        allow(HashPolice::CheckResult).to receive(:new).and_return(double)
        police.check('yo')
      end

      it "passes if a nil" do
        allow(HashPolice::CheckResult).to receive(:new).and_return(double)
        police.check(nil)
      end

      it "failed if lambda return false" do
        expect(result).to receive(:invalid_by_proc)
        police.check 12345
      end
    end

    context "when rule is an array of scalar" do
      let(:rule) { [ 1 ] }
      let(:nested_result1) { double(:nested_result1) }
      let(:nested_result2) { double(:nested_result2) }

      before(:each) do
        allow(HashPolice::CheckResult).to receive(:new).and_return(result,
                                                                   nested_result1,
                                                                   nested_result2)
      end

      it "passes if target is an of the same type" do
        police.check [ 1, 3, 4 ]
      end

      it "failed if target is not an array" do
        expect(result).to receive(:differ_type).with(:expect => Array, :got => Fixnum)
        police.check 12345
      end

      it "faild if not all elements are of the same type" do
        expect(result).to receive(:concat).with(nested_result1)
        expect(result).to receive(:concat).with(nested_result2)
        expect(nested_result2).to receive(:differ_type).with(:expect => Fixnum, :got => String)

        police.check [ 123, "string" ]
      end
    end

    context "when rule is a nested hash" do
      let(:rule) do
        {
          :name => "Jack",
          :married => true,
          :nested => {
            :key => "val"
          }
        }
      end
      let(:result_name) { double(:result_name) }
      let(:result_married) { double(:result_married) }
      let(:result_nested) { double(:result_nested, :concat => nil) }
      let(:result_key) { double(:result_key) }

      before(:each) do
        allow(HashPolice::CheckResult).to receive(:new).and_return(result,
                                                                   result_name,
                                                                   result_married,
                                                                   result_nested,
                                                                   result_key)
      end

      it "passes if all keys are matched" do
        police.check(target)
      end

      it "passes if target with stringed key" do
        target["name"] = target.delete :name

        police.check(target)
      end

      it "failed if missing key" do
        allow(HashPolice::CheckResult).to receive(:new).and_return(result,
                                                                   result_married,
                                                                   result_nested,
                                                                   result_key)

        target.delete :name
        expect(result).to receive(:missing).with("name")

        police.check(target)
      end

      it "failed if expect string but nil" do
        target[:nested] = { :key => nil }
        expect(result_key).to receive(:differ_type).with(:expect => String, :got => NilClass)

        police.check(target)
      end

      it "failed if nested key missing" do
        target[:nested] = {}

        expect(result_nested).to receive(:missing).with("nested.key")

        police.check(target)
      end
    end
  end
end
