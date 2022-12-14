require 'securerandom'

class Book
  attr_accessor :title, :author, :rentals_list, :id

  def initialize(title, author, id = nil)
    @id = id || SecureRandom.random_number(1000)
    @title = title
    @author = author
    @rentals_list = []
  end

  def add_rental(person, date)
    Rental.new(date, person, self)
  end

  def self.list_all_books(books)
    if books.empty?
      puts 'There are no books yet! Kindly add books.'
    else
      books.each_with_index do |book, index|
        puts "#{index} ) Title: #{book.title}, Author: #{book.author}"
      end
    end
  end

  def self.create_book(books)
    print 'Title: '
    title = gets.chomp

    print 'Author: '
    author = gets.chomp

    book = Book.new(title, author)
    books << book

    puts 'Book added successfully'
  end
end
