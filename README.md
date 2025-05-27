# String Calculator

A simple Ruby on Rails service that parses a string of numbers separated by delimiters and returns their sum. This project implements the popular String Calculator kata with enhancements, validations, and full RSpec test coverage.

---

## Features

- Supports comma (`,`) and newline (`\n`) delimiters by default
- Supports custom single or multiple delimiters, including multi-character delimiters (e.g. `//[***][%]\n1***2%3`)
- Validates input format and raises errors for:
  - Delimiters at start or end of the string
  - Consecutive delimiters
  - Invalid characters in input
- Detects and raises errors listing **negative numbers**
- Ignores numbers larger than 1000 in the sum
- Thorough RSpec test suite covering normal and edge cases


## Running rspec
bundle exec rspec spec/services/string_calculator_spec.rb
---

## Usage

### Add method

```ruby
StringCalculator.add("1,2,3")                  #=> 6
StringCalculator.add("//;\n1;2")               #=> 3
StringCalculator.add("//[***][%]\n1***2%3")    #=> 6
StringCalculator.add("1000,2,1001")             #=> 1002

StringCalculator.add("1,-2,3")                  # Raises ArgumentError: Negatives not allowed: -2
StringCalculator.add(",1,2")                     # Raises ArgumentError: Delimiter should not appear at the start or end



