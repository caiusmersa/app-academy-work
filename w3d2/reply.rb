class Reply
  attr_accessor :id, :question_id, :reply_id, :user_id, :body

  def self.find_by_id(id)

    results = QuestionsDatabase.execute(<<-SQL, id)
              SELECT *
                FROM replies
                WHERE id = ?
              SQL
    results.empty? ? nil : Reply.new(results[0])
  end
                # a reply record is required to be indexed.

  def self.find_by_user_id(user_id)
    results = QuestionsDatabase.execute(<<-SQL, user_id)
              SELECT *
                FROM replies
                WHERE user_id = ?
              SQL
    results.map { |hash| Reply.new(hash) }
  end

  def self.find_by_question_id(question_id)
    results = QuestionsDatabase.execute(<<-SQL, question_id)
              SELECT *
                FROM replies
                WHERE question_id = ?
              SQL
    results.map { |hash| Reply.new(hash) }
  end

  def initialize(attrs = {})
    @id, @user_id = attrs["id"], attrs["user_id"]
    @question_id, @body = attrs["question_id"], attrs["body"]
    @reply_id = attrs["reply_id"]
  end

  def author
    User.find_by_id(@user_id)
  end

  def question
    Question.find_by_id(@question_id)
  end

  # the reply it's replying to
  def parent_reply
    Reply.find_by_id(@reply_id)
  end

  def child_replies
    results = QuestionsDatabase.execute(<<-SQL, @id)
              SELECT *
                FROM replies
                WHERE reply_id = ?
              SQL
    results.map { |hash| Reply.new(hash) }
  end
end
