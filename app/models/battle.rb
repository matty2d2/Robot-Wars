class  Battle < ActiveRecord::Base
    has_many :batrobs
    has_many :robots, through: :batrobs

    def fight
        a = self.robots.sample
        a.lose_hp
        a
    end

    def fight_2_vs_2 (player_robots, opposition_robots)
        # binding.pry
        until player_robots.map{|robot| robot.hitpoints}.sum <= 0 || opposition_robots.map{|robot| robot.hitpoints}.sum <= 0 
            self.robots.each do |robot|
                # binding.pry
                robot.lose_hitpoints
                robot.check_hp
            end
        end
        self.robots.all.select{|robot| robot.hitpoints > 0}
        # binding.pry
    end
end
    
