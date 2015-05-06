require_relative 'questions_database.rb'
require_relative 'question_follow.rb'
require_relative 'question_like.rb'
require_relative 'question.rb'
require_relative 'reply.rb'
require_relative 'user.rb'

if __FILE__ == $PROGRAM_NAME
  puts "Top question:"
  p QuestionFollow.most_followed_questions(1)
  puts "Top 3 questions: "
  p QuestionFollow.most_followed_questions(3)
end
