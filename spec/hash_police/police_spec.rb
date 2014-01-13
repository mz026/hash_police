require "hash_police/police"

describe HashPolice::Police do
  describe "::new(rule)" do
    it "takes a rule hash to init" do
      police = HashPolice::Police.new({ :hello => "world" })
    end
  end

  describe "#check" do
    let(:rule) do
      {
        :name => "jack",
        :age => 30,
        :married => true
      }
    end
    let(:hash) { rule.clone }
    let(:police) { HashPolice::Police.new(rule) }
    let(:result) { double(:result, :missing => nil ) }

    before(:each) do
      HashPolice::CheckResult.stub(:new => result)
    end

    it "passes if passed" do
      HashPolice::CheckResult.stub(:new => double)
      police.check(hash)
    end

    it "missing the key if hash missing key" do
      hash.delete :name
      result.should_receive(:missing).with(:name)

      police.check(hash)
    end

    it "failed check if hash value is of different class" do
      hash[:name] = [ 'no a string' ]
      result.should_receive(:differ_type).with(:name, :expect => String, 
                                                      :got => Array)

      police.check(hash)
    end

    it "passes if different bool values" do
      hash[:married] = false
      result.should_not_receive(:differ_type)

      police.check(hash)
    end
  end
end
