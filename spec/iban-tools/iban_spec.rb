# vim:ts=2:sw=2:et:

require 'iban-tools'

module IBANTools
  RSpec.describe IBAN do
    describe 'with test rules' do
      before(:each) do
        @rules = IBANRules.new({ 'GB' => { 'length' => 22, 'bban_pattern' => /[A-Z]{4}.*/ } })
      end

      it 'validates IBAN code' do
        # Using example from http://en.wikipedia.org/wiki/IBAN#Calculating_and_validating_IBAN_checksums
        expect(IBAN.valid?('GB82WEST12345698765432', @rules)).to eq true
      end

      it 'rejects IBAN code with invalid characters' do
        expect(IBAN.new('gb99 %BC').validation_errors(@rules))
          .to include(:bad_chars)
      end

      it 'rejects IBAN code from unknown country' do
        # Norway is not present in @rules
        expect(IBAN.new('NO9386011117947').validation_errors(@rules))
          .to eq([:unknown_country_code])
      end

      it 'rejects IBAN code that does not match the length for the respective country' do
        expect(IBAN.new('GB88 WEST 1234 5698 7654 3').validation_errors(@rules))
          .to eq([:bad_length])
        # Length is 21, should be 22.
        # check digits are good though
      end

      it 'rejects IBAN code that does not match the pattern for the selected country' do
        expect(IBAN.new('GB69 7654 1234 5698 7654 32').validation_errors(@rules))
          .to eq([:bad_format])
        # Length and check digits are good,
        # but country pattern calls for chars 4-7 to be letters.
      end

      it 'rejects IBAN code with invalid check digits' do
        expect(IBAN.valid?('GB99 WEST 1234 5698 7654 32', @rules)).to eq false

        expect(IBAN.new('GB99 WEST 1234 5698 7654 32').validation_errors(@rules))
          .to eq([:bad_check_digits])
      end
    end

    it 'numerifies IBAN code' do
      expect(IBAN.new('GB82 WEST 1234 5698 7654 32').numerify)
        .to eq '3214282912345698765432161182'
    end

    it 'canonicalizes IBAN code' do
      expect(
        IBAN.new('  gb82 WeSt 1234 5698 7654 32').code
      )
        .to eq('GB82WEST12345698765432')
    end

    it 'pretty-prints IBAN code' do
      expect(
        IBAN.new(' GB82W EST12 34 5698 765432  ').prettify
      ).to eq('GB82 WEST 1234 5698 7654 32')

      expect(
        IBAN.new(' GB82W EST12 34 5698 765432  ').to_s
      )
        .to eq('#<IBANTools::IBAN: GB82 WEST 1234 5698 7654 32>')
    end

    it 'extracts ISO country code' do
      expect(IBAN.new('NO9386011117947').country_code).to eq 'NO'
    end

    it 'extracts check digits' do
      expect(IBAN.new('NO6686011117947').check_digits).to eq '66'
      # extract check digits even if they are invalid!
    end

    it 'extracts BBAN (Basic Bank Account Number)' do
      expect(IBAN.new('NO9386011117947').bban).to eq '86011117947'
    end

    describe 'with default rules' do # rubocop:disable Metrics/BlockLength
      %w[
        AZ21NABZ00000000137010001944
        BR7724891749412660603618210F3
        CR0515202001026284066
        GT82TRAJ01020000001210029690
        MD24AG000225100013104168
        PK36SCBL0000001123456702
        PS92PALS000000000400123456702
        QA58DOHB00001234567890ABCDEFG
        TL380080012345678910157
        VG96VPVG0000012345678901
        XK051212012345678906
      ].each do |iban_code|
        describe iban_code do
          it 'should be valid' do
            pending "IBAN code #{iban_code} is not valid and was introduced in https://github.com/barsoom/iban-tools/commit/793dd95e934dc2cacc3744185cd2c57c9e3fbb4e"
            expect(IBAN.new(iban_code).validation_errors).to eq([])
          end
        end
      end

      # Rules are loaded from lib/iban-tools/rules.yml
      # Samples from http://www.tbg5-finance.org/?ibandocs.shtml/

      %w[AD1200012030200359100100
         AE070331234567890123456
         AL47212110090000000235698741
         AT611904300234573201
         BA391290079401028494
         BE68539007547034
         BG80BNBG96611020345678
         BH67BMAG00001299123456
         CH9300762011623852957
         CY17002001280000001200527600
         CZ6508000000192000145399
         DE89370400440532013000
         DK5000400440116243
         DO28BAGR00000001212453611324
         EE382200221020145685
         ES9121000418450200051332
         FI2112345600000785
         FO7630004440960235
         FR1420041010050500013M02606
         GB29NWBK60161331926819
         GE29NB0000000101904917
         GI75NWBK000000007099453
         GL4330003330229543
         GR1601101250000000012300695
         HR1210010051863000160
         HU42117730161111101800000000
         IE29AIBK93115212345678
         IL620108000000099999999
         IS140159260076545510730339
         IT60X0542811101000000123456
         KW81CBKU0000000000001234560101
         KZ86125KZT5004100100
         LB62099900000001001901229114
         LI21088100002324013AA
         LT121000011101001000
         LU280019400644750000
         LV80BANK0000435195001
         MC1112739000700011111000h79
         ME25505000012345678951
         MK07300000000042425
         MR1300020001010000123456753
         MT84MALT011000012345MTLCAST001S
         MU17BOMM0101101030300200000MUR
         NL91ABNA0417164300
         NO9386011117947
         PL27114020040000300201355387
         PT50000201231234567890154
         RO49AAAA1B31007593840000
         RS35260005601001611379
         SA0380000000608010167519
         SE3550000000054910000003
         SI56191000000123438
         SK3112000000198742637541
         SM86U0322509800000000270100
         TN5914207207100707129648
         TR330006100519786457841326]
        .each do |iban_code|
        describe iban_code do
          it 'should be valid' do
            expect(IBAN.new(iban_code).validation_errors).to eq([])
          end
        end
      end

      it 'fails on known pattern violations' do
        # This IBAN has valid check digits
        # but should fail because of pattern violation
        IBAN.valid?('RO7999991B31007593840000').should eq false
      end
    end
  end
end
