class StringCalculator
  def self.add(input)
    return 0 if input.blank?

    delimiter_regex, numbers_string = parse_input(input)
    validate_format!(numbers_string, delimiter_regex)

    numbers = extract_numbers(numbers_string, delimiter_regex)

    check_for_negatives!(numbers)

    numbers.reject { |n| n > 1000 }.sum
  end

  private

  def self.parse_input(input)
    return [default_delimiter, input] unless input.start_with?("//")

    delimiter_line, numbers_string = input.split("\n", 2)

    raise ArgumentError, "Custom delimiter format must be //<delimiter>\\n<numbers>" if numbers_string.blank?

    delimiter_section = delimiter_line[2..]
    delimiter_regex = build_delimiter_regex(delimiter_section)

    [delimiter_regex, numbers_string]
  end

  def self.build_delimiter_regex(delimiter_section)
    if delimiter_section.start_with?("[") && delimiter_section.end_with?("]")
      delimiters = delimiter_section.scan(/\[(.*?)\]/).flatten
      delimiters.map! { |d| Regexp.escape(d) }
      delimiters.join("|")
    else
      Regexp.escape(delimiter_section)
    end
  end

  def self.validate_format!(numbers_string, delimiter_regex)
    regex = Regexp.new(delimiter_regex)

    if numbers_string.match?(/\A#{regex}/) || numbers_string.match?(/#{regex}\z/)
      raise ArgumentError, "Delimiter should not appear at the start or end"
    end

    if numbers_string.match?(/#{regex}{2,}/)
      raise ArgumentError, "Consecutive delimiters are not allowed"
    end

    unless numbers_string.match?(/\A[\d\-\s#{delimiter_regex}]*\z/)
      raise ArgumentError, "Input contains invalid characters"
    end
  end

  def self.extract_numbers(string, delimiter_regex)
    string.split(Regexp.new(delimiter_regex))
          .reject(&:blank?)
          .map(&:to_i)
  end

  def self.check_for_negatives!(numbers)
    negatives = numbers.select(&:negative?)
    return if negatives.empty?

    raise ArgumentError, "Negatives not allowed: #{negatives.join(', ')}"
  end

  def self.default_delimiter
    ",|\n"
  end
end
