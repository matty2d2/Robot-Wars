class  Robot < ActiveRecord::Base
    belongs_to :player
    has_many :batrobs
    has_many :battles, through: :batrobs

    def self.live_robots
        self.all.select{|robot| robot.hitpoints >0}
    end

    def self.live_robot_names
        self.live_robots.map(&:name)
    end

    def self.robot_names
        self.all.map{|robot| robot.name}
    end

    def choose_fight
        puts ""
        prompt = TTY::Prompt.new
        battle = Battle.create()
        robot_options = Robot.live_robots.reject{|r| r == self}.sample(5)
        options = robot_options.map(&:name)

        choices = prompt.multi_select("Choose a robot to fight:", options, max: 3, default: 1 )
        selected_robots =  robot_options.select{|obj| choices.include?(obj.name)}
        
        Batrob.create(robot_id: self.id, battle_id: battle.id)

        selected_robots.each do |robot|
            Batrob.create(robot_id: robot.id, battle_id: battle.id)
        end
        battle
    end

    def lose_hp
        self.hitpoints -= 100
        self.save
    end

    def check_hp
        if self.hitpoints <= 0
            self.hitpoints = 0
            self.save
            self
        end
    end

    def wins
        battles.uniq.select{|battle| battle.winner == self.name}.length
    end


end
    
