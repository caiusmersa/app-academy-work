require 'byebug'

def rps(user_choice)
  comp_choice = ["Rock", "Paper", "Scissors"].shuffle[0]
  if rps_draw(user_choice, comp_choice)
    puts "#{comp_choice}, Draw"
  elsif rps_win(user_choice, comp_choice)
    puts "#{comp_choice}, Win"
  elsif rps_win(comp_choice, user_choice)
    puts "#{comp_choice}, Lose"
  else
    puts "Choose Rock, Paper or Scissors!"
  end
end

def rps_draw(user_choice, comp_choice)
  user_choice == comp_choice
end

def rps_win(user_choice, comp_choice)
  (user_choice == "Rock" && comp_choice == "Scissors") ||
    (user_choice == "Paper" && comp_choice == "Rock") ||
    (user_choice == "Scissors" && comp_choice == "Paper")
end

def remix(ingredients)
  remixed = []
  alcohols = []
  ingredients.each do |ingredient_set|
    alcohols << ingredient_set[0]
  end
  alcohols.shuffle!
  ingredients.each_with_index do |ingredient_set, index|
    remixed << [alcohols[index], ingredient_set[1]]
  end
  remixed
end

def same_mix?(mix_one, mix_two)
  mix_one.each do |mix|
    return true if mix_two.include?(mix)
  end
  false
end

def remix_guaranteed(ingredients)
  remixed = remix(ingredients)
  remixed = remix(ingredients) until !same_mix?(ingredients, remixed)
  remixed
end

puts remix_guaranteed([
  ["rum", "coke"],
  ["gin", "tonic"],
  ["scotch", "soda"]
])
