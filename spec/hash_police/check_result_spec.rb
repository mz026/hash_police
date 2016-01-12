require "hash_police"

describe HashPolice::CheckResult do
  let(:context_key) { "the-key" }
  let(:result) { HashPolice::CheckResult.new context_key }

  describe "::new(context_key)" do
    it "takes a context_key to init" do
      result = HashPolice::CheckResult.new "the-key"
    end
  end

  describe "#error_messages" do
    context "when without children" do
      it "returns plain reason" do
        result.differ_type(:expect => String, :got => Fixnum)
        expect(result.error_messages).to eq("`the-key`: expect String, got Fixnum")
      end
    end

    context "when with children" do
      it "returns message with children's ones" do
        children = [1,2,3].map do |i|
          child = HashPolice::CheckResult.new("key-#{i}")
          result.concat(child)
          child
        end

        children[1].differ_type(:expect => String, :got => Fixnum)
        children[2].missing

        expect(result.error_messages)
          .to eq( "`key-2`: expect String, got Fixnum\n`key-3`: missing")
      end
    end

  end

  describe "#missing(key = nil)" do
    it "adds missing message to errors" do
      result.missing

      expect(result.error_messages).to eq("`#{context_key}`: missing")
    end

    it "assigns missing key if given" do
      result.missing("the-key")

      expect(result.error_messages).to eq( "`the-key`: missing")
    end
  end

  describe "#differ_type(:expect => Class1, :got => Class2)" do
    it "adds message to error_messages" do
      result.differ_type(:expect => String, :got => Array)
      expect(result.error_messages).to eq("`#{context_key}`: expect String, got Array")
    end
  end

  describe "passed?" do
    it "returns true if all_errors empty" do
      expect(result).to be_passed
    end

    it "returns false if all_errors not empty" do
      result.missing

      expect(result).not_to be_passed
    end
  end

  describe "#concat(result)" do
    it "concat the child with its message" do
      child = double
      result.concat(child)
    end
  end
end
