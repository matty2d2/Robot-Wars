class  Battle < ActiveRecord::Base
    has_many :batrobs
    has_many :robots, through: :batrobs

    def fight
        fighting_robots = self.robots
        until fighting_robots.length == 1
            fighting_robots.each do |robot|
                robot.lose_hitpoints
                r = robot.check_hp

                if r.hitpoints <= 0
                    fighting_robots -= [r]
                end
            end
        end
        fighting_robots
    end

    def fight_2_vs_2 (player_robots, opposition_robots)
        until player_robots.map{|robot| robot.hitpoints}.sum <= 0 || opposition_robots.map{|robot| robot.hitpoints}.sum <= 0 
            self.robots.each do |robot|
                robot.lose_hitpoints
                robot.check_hp
            end
        end
        self.robots.all.select{|robot| robot.hitpoints > 0}
    end
end
    
