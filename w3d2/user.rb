require_relative 'questions_database.rb'
require_relative 'question.rb'
require_relative 'reply.rb'
require_relative 'question_follow.rb'

class User
  attr_accessor :id, :fname, :lname,

  def self.count
    QuestionsDatabase.execute(<<-SQL)
      SELECT
        COUNT(*)
      FROM
        users
    SQL
      .at(0)[0]
  end

  def self.find_by_id(id)

    results = QuestionsDatabase.execute(<<-SQL, id)
              SELECT *
                FROM users
                WHERE id = ?
              SQL
    results.empty? ? nil : User.new(results[0])
  end

  def self.find_by_name(fname, lname)
    results = QuestionsDatabase.execute(<<-SQL, fname, lname)
              SELECT *
                FROM users
                WHERE fname = ? AND lname = ?
              SQL
    results.empty? ? nil : User.new(results[0])
  end

  def initialize(attrs = {})
    @id = attrs["id"]
    @fname, @lname = attrs["fname"], attrs["lname"]
  end

  def authored_questions
    return [] if @id.nil?
    Question.find_by_author_id(@id)
  end

  def authored_replies
    return [] if @id.nil?
    Reply.find_by_user_id(@id)
  end

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(@id)
  end

  def save
    @id.nil? ? insert : update
  end

  def update
    QuestionsDatabase.execute(<<-SQL, @fname, @lname, @id)
      UPDATE
        users
      SET
        fname = ?,
        lname = ?
      WHERE
        id = ?
    SQL
  end

  def insert
    QuestionsDatabase.execute(<<-SQL, @fname, @lname)
      INSERT INTO
        users (fname, lname)
      VALUES
        ( ?, ? )
    SQL
    @id = QuestionsDatabase.last_id
  end
end
