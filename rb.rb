require 'sqlite3'
require 'singleton'

class QuestionsDBConnection < SQLite3::Database
  include singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class User
  attr_accessor :fname, :lname
  attr_reader :id

  def self.all
    data = QuestionsDBConnection.initialize.execute("SELECT * FROM users")
    data.map {|datum| User.new(datum)}
  end

  def find_by_id
    data = QuestionsDBConnection.instance.execute(<<SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
SQL
      data.map { |datum| User.new(datum)}
  end
end

class Question
 attr_accessor :title, :body, :author_id

  def self.all
    data = QuestionsDBConnection.initialize.execute("SELECT * FROM questions")
    data.map {|datum| Question.new(datum)} #creates a new instance for each question
  end

  def find_by_id
    questions = QuestionsDBConnection.instance.execute(<<SQL, questions.id)
      SELECT
        *
      FROM
        questions_follows
      WHERE
        id = ?
SQL
    questions.map{ |q| Question.new(q)}
  end

end

class QuestionFollow
  attr_accessor :user_id, :question_id
  attr_reader :id

#class methods
  def self.all
    data = QuestionsDBConnection.initialize.execute("SELECT * FROM questions_follows")
    data.map {|datum| QuestionFollow.new(datum)}
  end

  def self.find_by_id(id)
    data = QuestionsDBConnection.instance.execute(<<SQL, id)
      SELECT
        *
      FROM
        questions_follows
      WHERE
        id = ?
SQL
    data.map { |datum| QuestionFollow.new(datum)  }
  end
end

class Reply
  attr_accessor :question_id, :parent_reply_id, :author_id, :body
  attr_reader :id

  def self.all
    data = QuestionsDBConnection.initialize.execute("SELECT * FROM replies")
    data.map {|datum| Reply.new(datum)}
  end

  def self.find_by_id(id)
    data = QuestionsDBConnection.instance.execute(<<SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
SQL
      data.map { |datum| Reply.new(datum)}
  end
end

class QuestionLike
  attr_accessor :user_id, :question_id
  attr_reader :id

  def self.all
    data = QuestionsDBConnection.initialize.execute("SELECT * FROM question_likes")
    data.map {|datum| QuestionLike.new(datum)}
  end

  def self.find_by_id(id)
    data = QuestionsDBConnection.instance.execute(<<SQL, id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        id = ?
SQL
      data.map { |datum| QuestionLike.new(datum)}
  end
end
