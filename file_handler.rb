require './book'
require 'json'

class FileHandler
  SAVE_DATA = './SAVE_DATA/'.freeze

  def self.read_book(books)
    path = "#{SAVE_DATA}book.json"
    return unless File.exist?(path)

    book_file = File.open(path)
    JSON.parse(book_file.read).each { |book| books << Book.new(book['title'], book['author'], book['id']) }
    book_file.close
  end

  def self.write_book(books)
    return if books.empty?

    path_file = "#{SAVE_DATA}book.json"
    data_books = books.map do |book|
      { id: book.id, title: book.title, author: book.author }
    end
    File.write(path_file, JSON.pretty_generate(data_books))
  end

  def self.read_person(people)
    path = "#{SAVE_DATA}person.json"
    return unless File.exist?(path)

    people_file = File.open(path)
    JSON.parse(people_file.read).each do |person|
      if person['class'] == 'Student'
        new_student = Student.new(person['classroom'], person['age'], person['name'], person['parent_permission'])
        new_student.id = person['id']
        people << new_student
      else
        new_teacher = Teacher.new(person['specialization'], person['age'], person['name'],
                                  person['parent_permission'])
        new_teacher.id = person['id']
        people << new_teacher
      end
    end
    people_file.close
  end

  def self.write_person(people)
    return if people.empty?

    path_file = "#{SAVE_DATA}person.json"
    people_data_array = []
    people.map do |person|
      if person.instance_of?(Student)
        people_data_array << { class: person.class, age: person.age, name: person.name,
                               classroom: person.classroom, id: person.id, parent_permission: person.parent_permission }
      else
        people_data_array << { class: person.class, age: person.age, name: person.name,
                               specialization: person.specialization, id: person.id,
                               parent_permission: person.parent_permission }
      end
    end
    File.write(path_file, JSON.pretty_generate(people_data_array))
  end

  def self.write_rentals(rentals)
    rentals_data_array = []
    rentals.each do |rental|
      rentals_data_array << {
        date: rental.date,
        title: rental.book.title,
        author: rental.book.author,
        id: rental.person.id,
        name: rental.person.name,
        age: rental.person.age,
        parent_permission: rental.person.parent_permission
      }
    end
    File.write('./SAVE_DATA/rental.json', JSON.pretty_generate(rentals_data_array))
  end

  # read rentals
  def self.read_rentals
    array_rentals = []
    return array_rentals unless File.exist?('./SAVE_DATA/rental.json')

    rentals_file = File.open('./SAVE_DATA/rental.json')
    JSON.parse(rentals_file.read).each do |rental|
      single_person = Person.new(rental['age'], rental['name'], rental['parent_permission'])
      single_person.id = rental['id']
      single_book = Book.new(rental['title'], rental['author'])
      single_rental = Rental.new(rental['date'], single_book, single_person)
      array_rentals << single_rental
    end
    rentals_file.close
  end
end
