


10.times do
    Player.create(username: Faker::Name.unique.first_name)
end

90.times do
    Robot.create(name: Faker::Games::Pokemon.unique.name, player_id: rand(1..10), attack: rand(5..9))
end


