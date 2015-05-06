class Question
  attr_accessor :id, :title, :body, :user_id

  def self.find_by_id(id)

    results = QuestionsDatabase.execute(<<-SQL, id)
              SELECT *
                FROM questions
                WHERE id = ?
              SQL
    results.empty? ? nil : Question.new(results[0])
  end

  def self.find_by_author_id(author_id)
    results = QuestionsDatabase.execute(<<-SQL, author_id)
              SELECT *
                FROM questions
                WHERE user_id = ?
              SQL
    results.map { |hash| Question.new(hash) }
  end

  def initialize(attrs = {})
    @id, @user_id = attrs["id"], attrs["user_id"]
    @title, @body = attrs["title"], attrs["body"]
  end

  def author
    User.find_by_id(@user_id)
  end

  def followers
    QuestionFollow.followers_for_question_id(@id)
  end

# primary key may not be set if we created
# a ruby object and haven't written to db

  def replies
    Reply.find_by_question_id(@id)
  end
end
