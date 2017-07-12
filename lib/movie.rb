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

    define_singleton_method(:find) do |id|
      result = DB.exec("SELECT * FROM movies WHERE id = #{id};")
      name = result.first().fetch("name")
      Movie.new({:name => name, :id => id})
    end

    define_method(:save) do
      result = DB.exec("INSERT INTO movies (name) VALUES ('#{@name}') RETURNING id;")
      @id = result.first().fetch("id").to_i()
    end

    define_method(:==) do |another_movie|
      self.name().==(another_movie.name()).&(self.id().==(another_movie.id()))
    end

    define_method(:update) do |attributes|
      @name = attributes.fetch(:name, @name)
      @id = self.id()
      DB.exec("UPDATE movies SET name = '#{@name}' WHERE id = #{@id};")
      attributes.fetch(:actor_ids, []).each() do |actor_id|
        DB.exec("INSERT INTO actors_movies (actor_id, movie_id) VALUES (#{actor_id}, #{self.id()});")
      end
    end

  end
