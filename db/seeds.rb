


10.times do
    Player.create(username: Faker::Name.unique.first_name)
end

80.times do
    Robot.create(name: Faker::Games::Pokemon.unique.name, player_id: rand(1..10))
end


