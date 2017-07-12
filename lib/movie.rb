class Movie
    attr_reader(:name, :id)

    define_method(:initialize) do |attributes|
      @name = attributes.fetch(:name)
      @id = attributes.fetch(:id)
    end

    define_singleton_method(:all) do
      returned_movies = DB.exec("SELECT * FROM movies;")
      movies = []
      returned_movies.each() do |movie|
        name = movie.fetch("name")
        id = movie.fetch("id").to_i()
        movies.push(Movie.new({:name => name, :id => id}))
      end
      movies
    end

  end
