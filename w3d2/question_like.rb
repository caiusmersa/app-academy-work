require_relative 'questions_database.rb'

class QuestionLike
  attr_accessor :id, :question_id, :user_id

  def self.find_by_id(id)

    results = QuestionsDatabase.execute(<<-SQL, id)
              SELECT *
                FROM question_likes
                WHERE id = ?
              SQL
    results.empty? ? nil : QuestionLike.new(results[0])
  end

  def initialize(attrs = {})
    @id, @user_id = attrs["id"], attrs["user_id"]
    @question_id = attrs["question_id"]
  end
end
