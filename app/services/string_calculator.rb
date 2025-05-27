class StringCalculator
  def self.add(input)
    return 0 if input.blank?

    delimiter, numbers_string = parse_input(input)
    validate_format!(numbers_string, delimiter)

    numbers = numbers_string
              .split(Regexp.new(delimiter))
              .reject(&:blank?)
              .map(&:to_i)

    negatives = numbers.select(&:negative?)
    if negatives.any?
      raise ArgumentError, "Negatives not allowed: #{negatives.join(', ')}"
    end

    numbers.reject { |n| n > 1000 }.sum
  end

  private

  def self.parse_input(input)
    if input.start_with?("//")
      # Handle multiple delimiters: //[delim1][delim2]...\n
      parts = input.split("\n", 2)
      if parts.size < 2 || parts[1].strip.empty?
        raise ArgumentError, "Custom delimiter format must be //<delimiter>\\n<numbers>"
      end

      delimiter_section = parts[0][2..]

      # Multiple delimiters e.g. //[***][%]\n1***2%3
      if delimiter_section.start_with?("[") && delimiter_section.end_with?("]")
        delimiters = delimiter_section.scan(/\[(.*?)\]/).flatten
        escaped_delims = delimiters.map { |d| Regexp.escape(d) }
        delimiter_regex = escaped_delims.join("|")
      else
        delimiter_regex = Regexp.escape(delimiter_section)
      end

      [delimiter_regex, parts[1]]
    else
      [",|\n", input]
    end
  end

  def self.validate_format!(numbers_string, delimiter)
    regex = Regexp.new(delimiter)
  
    if numbers_string.match?(/\A#{regex}/) || numbers_string.match?(/#{regex}\z/)
      raise ArgumentError, "Delimiter should not appear at the start or end"
    end
  
    if numbers_string.match?(/#{regex}{2,}/)
      raise ArgumentError, "Consecutive delimiters are not allowed"
    end
  
    # Allow digits, delimiters, newlines, whitespace, and minus sign for negatives
    unless numbers_string.match?(/\A[\d\-#{Regexp.escape(delimiter)}\n\s]*\z/)
      raise ArgumentError, "Input contains invalid characters"
    end
  end
end
