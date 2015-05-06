class QuestionFollow
  attr_accessor :id, :question_id, :user_id

  def self.find_by_id(id)

    results = QuestionsDatabase.execute(<<-SQL, id)
              SELECT *
                FROM question_follows
                WHERE id = ?
              SQL
    results.empty? ? nil : QuestionFollow.new(results[0])
  end
              # * has both users and qf data
              # on inner joins, the order doesn't matter
              # filter for our question_id
  def self.followers_for_question_id(question_id)
    results = QuestionsDatabase.execute(<<-SQL, question_id)
              SELECT
                users.*
              FROM
                users
              JOIN
                question_follows qf ON users.id = qf.user_id
              WHERE
                qf.question_id = ?
            SQL
    results.map { |hash| User.new(hash) }
  end

  def self.followed_questions_for_user_id(user_id)
    results = QuestionsDatabase.execute(<<-SQL, user_id)
              SELECT qs.*
                FROM questions qs
                JOIN question_follows qf ON qs.id = qf.question_id
                WHERE qf.user_id = ?
              SQL
    results.map { |hash| Question.new(hash) }
  end

  # when joining, specifiy select table, i.e. questions.*
  def self.most_followed_questions(n)
    results = QuestionsDatabase.execute(<<-SQL, n)
      SELECT
        questions.*
      FROM
        questions
      JOIN
        question_follows ON  question_follows.question_id = questions.id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(*) DESC
      LIMIT ?
    SQL
    results.map { |hash| Question.new(hash) } # new object matches
  end


  def initialize(attrs = {})
    @id, @user_id = attrs["id"], attrs["user_id"]
    @question_id = attrs["question_id"]
  end
end
