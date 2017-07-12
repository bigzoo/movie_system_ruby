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

end
