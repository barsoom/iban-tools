require 'iban-tools'

module IBANTools
  describe BIC do

    it "should validate BIC code" do
      # http://sv.wikipedia.org/wiki/ISO_9362
      # http://en.wikipedia.org/wiki/ISO_9362#Examples
      BIC.valid?("ESSESESS").should be_true
      BIC.valid?("DABASESX").should be_true
      BIC.valid?("UNCRIT2B912").should be_true
      BIC.valid?("DSBACNBXSHA").should be_true
    end

    it "should reject BIC with invalid characters" do
      BIC.valid?("ESS%SS").should be_false
    end

    it "should reject BIC with invalid length" do
      BIC.valid?("ES").should be_false
    end

    it "should reject BIC with invalid country code" do
      BIC.valid?("SWEDXXSS").should be_false
    end

  end
end
