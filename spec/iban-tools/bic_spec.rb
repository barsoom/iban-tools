require 'iban-tools'

module IBANTools
  describe BIC do

    it "accepts valid BIC codes" do
      # http://sv.wikipedia.org/wiki/ISO_9362
      # http://en.wikipedia.org/wiki/ISO_9362#Examples
      BIC.valid?("ESSESESS").should eq true
      BIC.valid?("DABASESX").should eq true
      BIC.valid?("UNCRIT2B912").should eq true
      BIC.valid?("DSBACNBXSHA").should eq true
    end

    it "rejects BIC with invalid characters" do
      BIC.valid?("ESS%SS").should eq false
    end

    it "rejects BIC with invalid length" do
      BIC.valid?("ES").should eq false
    end

    it "rejects BIC with invalid country code" do
      BIC.valid?("SWEDXXSS").should eq false
    end

    # We had a bug
    it "rejects valid BIC embedded in a longer string" do
      BIC.valid?("before ESSESESS after").should eq false
    end
  end
end
