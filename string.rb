def num_to_s(num, base)
  exp = 0
  exp += 1 until base ** (exp + 1) > num
  digits = []

  while exp >= 0
    divisor = (base ** exp)
    digits << num / divisor
    num = num % divisor
    exp -= 1
  end

  digits.map! do |digit|
    if digit < 10
      digit.to_s
    else
      ('A'..'F').to_a[digit-10]
    end
  end

  digits.join('')
end

def caesar(string, char_shift)
  letters_array = string.split("")

  answer = letters_array.map do |letter|
    shifted_ascii = letter.ord + char_shift
    if shifted_ascii > 122
      shifted_ascii = (shifted_ascii % 122) + 96
    end
    shifted_ascii.chr
  end
  answer.join("")
end
