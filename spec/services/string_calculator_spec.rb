require 'rails_helper'

RSpec.describe StringCalculator do
  describe ".add" do
    context "basic functionality" do
      it "returns 0 for empty string" do
        expect(described_class.add("")).to eq(0)
      end

      it "returns the number for a single number" do
        expect(described_class.add("5")).to eq(5)
      end

      it "returns the sum of comma-separated numbers" do
        expect(described_class.add("1,2,3")).to eq(6)
      end

      it "handles newlines as delimiters" do
        expect(described_class.add("1\n2,3")).to eq(6)
      end
    end

    context "custom delimiters" do
      it "parses and sums numbers with a custom delimiter" do
        expect(described_class.add("//;\n1;2")).to eq(3)
      end

      it "works with custom delimiter and spaces" do
        expect(described_class.add("//:\n 4:5 ")).to eq(9)
      end

      it "supports custom delimiter with regex characters" do
        expect(described_class.add("//|\n3|4")).to eq(7)
        expect(described_class.add("//.\n2.2")).to eq(4)
      end

      it "raises error if custom delimiter format is invalid" do
        expect {
          described_class.add("//;\n")
        }.to raise_error(ArgumentError, "Custom delimiter format must be //<delimiter>\\n<numbers>")
      end

      it "supports multiple custom delimiters" do
        expect(described_class.add("//[***][%]\n1***2%3")).to eq(6)
      end

      it "supports multiple single-char delimiters" do
        expect(described_class.add("//[*][%]\n1*2%3")).to eq(6)
      end
    end

    context "input validation" do
      it "raises error if input starts with delimiter" do
        expect {
          described_class.add(",1,2")
        }.to raise_error(ArgumentError, "Delimiter should not appear at the start or end")
      end

      it "raises error if input ends with delimiter" do
        expect {
          described_class.add("1,2,")
        }.to raise_error(ArgumentError, "Delimiter should not appear at the start or end")
      end

      it "raises error for consecutive delimiters" do
        expect {
          described_class.add("1,,2")
        }.to raise_error(ArgumentError, "Consecutive delimiters are not allowed")
      end

      it "raises error for invalid characters" do
        expect {
          described_class.add("1,a,3")
        }.to raise_error(ArgumentError, "Input contains invalid characters")
      end
    end

    context "negative numbers" do
      it "raises error listing negative numbers" do
        expect {
          described_class.add("1,-2,3,-5")
        }.to raise_error(ArgumentError, "Negatives not allowed: -2, -5")
      end
    end

    context "numbers greater than 1000" do
      it "ignores numbers greater than 1000" do
        expect(described_class.add("2,1001,3")).to eq(5)
      end

      it "includes 1000 in sum" do
        expect(described_class.add("1000,2")).to eq(1002)
      end
    end

    context "performance and edge cases" do
      it "handles large input efficiently" do
        input = (1..1000).to_a.join(",")
        expect(described_class.add(input)).to eq(500500)
      end
    end
  end
end
