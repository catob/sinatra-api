class BookSerializer
  attr_accessor :book

  def initialize(book)
    @book = book
  end

  def as_json(*)
    data = {
      id: book.id,
      title: book.title,
      author: book.author,
      isbn: book.isbn
    }
    data[:errors] = book.errors if book.errors.any?
    data
  end
end
