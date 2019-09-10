class  Player < ActiveRecord::Base
    has_many :robots

    def self.player_names
        self.all.map(&:username)
    end

    def live_robots
        robots.select{|robot| robot.hitpoints > 0}
    end

    def live_robo_names
        live_robots.map(&:name)
    end

    def dead_robots
        robots.select{|robot| robot.hitpoints == 0}
    end

    def dead_robo_names
        dead_robots.map(&:name)
    end

    def total_wins
        robots.sum{|robot| robot.wins}
    end

    def best_robot
        robots.max_by(&:wins)
    end

end
    
