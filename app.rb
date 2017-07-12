require("sinatra")
  require("sinatra/reloader")
  also_reload("lib/**/*.rb")
  require("./lib/actor")
  require("./lib/movie")
  require("pg")

  DB = PG.connect({:dbname => "movie_database"})

