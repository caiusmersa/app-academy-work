require 'singleton'
require 'sqlite3'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def self.execute(*args, &blk)
    instance.execute(*args, &blk)
  end

  def self.last_id
    instance.last_insert_row_id
  end

  def initialize
    super("questions.db")
    self.results_as_hash = true
  end
end
