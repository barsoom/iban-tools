require 'iban-tools'

module IBANTools
  describe BIC do
    it 'accepts valid BIC codes' do
      # http://sv.wikipedia.org/wiki/ISO_9362
      # http://en.wikipedia.org/wiki/ISO_9362#Examples
      expect(BIC.valid?('ESSESESS')).to eq true
      expect(BIC.valid?('DABASESX')).to eq true
      expect(BIC.valid?('UNCRIT2B912')).to eq true
      expect(BIC.valid?('DSBACNBXSHA')).to eq true
    end

    it 'rejects BIC with invalid characters' do
      expect(BIC.valid?('ESS%SS')).to eq false
    end

    it 'rejects BIC with invalid length' do
      expect(BIC.valid?('ES')).to eq false
    end

    it 'rejects BIC with invalid country code' do
      expect(BIC.valid?('SWEDXXSS')).to eq false
    end

    # We had a bug
    it 'rejects valid BIC embedded in a longer string' do
      expect(BIC.valid?('before ESSESESS after')).to eq false
      expect(BIC.valid?('beforeESSESESSafter')).to eq false
    end
  end
end
