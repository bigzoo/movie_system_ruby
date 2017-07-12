require("sinatra")
  require("sinatra/reloader")
  also_reload("lib/**/*.rb")
  require("./lib/actor")
  require("./lib/movie")
  require("pg")

  DB = PG.connect({:dbname => "movie_database"})

  get("/") do
    @actors = Actor.all()
    @movies = Movie.all()
    erb(:index)
  end

  get("/actors") do
    @actors = Actor.all()
    erb(:actors)
  end

  get("/movies") do
    @movies = Movie.all()
    erb(:movies)
  end

  post("/actors") do
   name = params.fetch("name")
   actor = Actor.new({:name => name, :id => nil})
   actor.save()
   @actors = Actor.all()
   erb(:actors)
 end

 post("/movies") do
   name = params.fetch("name")
   movie = Movie.new({:name => name, :id => nil})
   movie.save()
   @movies = Movie.all()
   erb(:movies)
 end

 get("/actors/:id") do
   @actor = Actor.find(params.fetch("id").to_i())
   @movies = Movie.all()
   erb(:actor_info)
 end

 get("/movies/:id") do
   @movie = Movie.find(params.fetch("id").to_i())
   @actors = Actor.all()
   erb(:movie_info)
 end

 patch("/actors/:id") do
     actor_id = params.fetch("id").to_i()
     @actor = Actor.find(actor_id)
     movie_ids = params.fetch("movie_ids")
     @actor.update({:movie_ids => movie_ids})
     @movies = Movie.all()
     erb(:actor_info)
   end

   patch("/movies/:id") do
     movie_id = params.fetch("id").to_i()
     @movie = Movie.find(movie_id)
     actor_ids = params.fetch("actor_ids")
     @movie.update({:actor_ids => actor_ids})
     @actors = Actor.all()
     erb(:movie_info)
   end
