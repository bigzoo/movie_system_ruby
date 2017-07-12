class Actor
  attr_reader(:name, :id)

  define_method(:initialize) do |attributes|
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

  define_singleton_method(:all) do
    returned_actors = DB.exec('SELECT * FROM actors;')
    actors = []
    returned_actors.each do |actor|
      name = actor.fetch('name')
      id = actor.fetch('id').to_i
      actors.push(Actor.new(name: name, id: id))
    end
    actors
  end

  define_singleton_method(:find) do |id|
    result = DB.exec("SELECT * FROM actors WHERE id = #{id};")
    name = result.first.fetch('name')
    Actor.new(name: name, id: id)
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO actors (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first.fetch('id').to_i
  end

  define_method(:==) do |another_actor|
    name.==(another_actor.name).&(id.==(another_actor.id))
  end

  define_method(:update) do |attributes|
    @name = attributes.fetch(:name, @name)
    @id = id
    DB.exec("UPDATE actors SET name = '#{@name}' WHERE id = #{@id};")
    attributes.fetch(:movie_ids, []).each do |movie_id|
      DB.exec("INSERT INTO actors_movies (actor_id, movie_id) VALUES (#{id}, #{movie_id});")
    end
  end

  define_method(:movies) do
    actor_movies = []
    results = DB.exec("SELECT movie_id FROM actors_movies WHERE actor_id = #{id};")
    results.each do |result|
      movie_id = result.fetch('movie_id').to_i
      movie = DB.exec("SELECT * FROM movies WHERE id = #{movie_id};")
      name = movie.first.fetch('name')
      actor_movies.push(Movie.new(name: name, id: movie_id))
    end
    actor_movies
  end

end
