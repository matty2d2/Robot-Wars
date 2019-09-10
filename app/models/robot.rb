class  Robot < ActiveRecord::Base
    belongs_to :player
    has_many :batrobs
    has_many :battles, through: :batrobs

    def self.live_robot_names
        self.all.select{|robot| robot.hitpoints >0}.map(&:name)
    end

    def self.robot_names
        self.all.map{|robot| robot.name}
    end

    def choose_fight
        puts ""
        prompt = TTY::Prompt.new
        battle = Battle.create()
        Batrob.create(robot_id: self.id, battle_id: battle.id)
        choice = prompt.select("Choose a robot to fight:", Robot.live_robot_names.reject{|r| r == self.name}.sample(3))

        robot = Robot.find_by(name: choice)
        Batrob.create(robot_id: robot.id, battle_id: battle.id)
        battle
    end

    def lose_hp
        self.hitpoints -= 100
        self.save
    end

    def check_hp
        if self.hitpoints <= 0
            puts ""
            puts "#{self.name} has been destroyed."
            self.hitpoints = 0
            self.save
            self
        end
    end

    def wins
        battles.uniq.select{|battle| battle.winner == self.name}.length
    end


end
    
