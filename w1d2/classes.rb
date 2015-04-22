class Student
  attr_reader :first_name, :last_name
  attr_reader :courses

  def initialize(first_name, last_name)
    @first_name = first_name
    @last_name = last_name
    @courses = []
  end

  def name
    "#{last_name}, #{first_name}"
  end

  def enroll(course)
    unless courses.include?(course)
      courses << course
      course.add_student(self)
    end
  end
end

class Course
  attr_reader :name, :department, :credits
  attr_reader :students

  def initialize(name, department, credits)
    @name = name
    @department = department
    @credits = credits
    @students = []
  end

  def add_student(student)
    unless students.include?(student)
      students << student
      student.enroll(self)
    end
  end
end
