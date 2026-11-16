# iban-tools

iban-tools is a Ruby library for manipulating and validating IBAN account numbers. You can [read more about IBAN](http://en.wikipedia.org/wiki/International_Bank_Account_Number) on Wikipedia

[![CI](https://github.com/barsoom/iban-tools/actions/workflows/ci.yml/badge.svg)](https://github.com/barsoom/iban-tools/actions/workflows/ci.yml)

## INSTALLATION

    gem install iban-tools

The gem should be compatible with most Ruby versions.

## USAGE

```rb
require 'iban-tools'

IBANTools::IBAN.valid?("GB82 WEST 1234 5698 7654 32") #=> true
```

Advanced usage, gives more detailed error messages

```rb
IBANTools::IBAN.new("XQ75 BADCODE 666").validation_errors
# => [:unknown_country_code, :bad_check_digits]
```

Pretty print, canonicalize, and extract fields from an IBAN code

```rb
iban = IBANTools::IBAN.new(" ro49  aaaa 1B31007593840000")

iban.code # => "RO49AAAA1B31007593840000"
iban.country_code # => "RO"
iban.prettify # => "RO49 AAAA 1B31 0075 9384 0000"
```
    
Convert local account numbers to IBAN and back to local. 

```rb
iban = IBANTools::IBAN.from_local('NO', bank_code: '9710', account_number: '1112222', check_digit: '7')

iban.code # => "NO6197101112227"
iban.to_local # => {:bank_code=>"9710", :account_number=>"111222", :check_digit=>"7"}
```


Very basic BIC validation

```rb
IBANTools::BIC.valid?("UNCRIT2B912") # => true
```

## Credit

[Iulianu](http://github.com/iulianu) originally wrote [iban-tools](http://github.com/iulianu/iban-tools). The team at [AlphaSights](https://engineering.alphasights.com) is currently maintaining the gem.
