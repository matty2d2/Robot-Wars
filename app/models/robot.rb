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


    def choose_2vs2_fight(teammate)
        puts ""
        prompt = TTY::Prompt.new
        # battle = Battle.create()
        robot_options = Robot.live_robots.reject{|r| r == self || r == teammate}.sample(6)
        team_options = robot_options.each_slice(2).to_a
        team_1 = "Team 1 : #{team_options[0][0].name} & #{team_options[0][1].name}"
        team_2 = "Team 2 : #{team_options[1][0].name} & #{team_options[1][1].name}"
        team_3 = "Team 3 : #{team_options[2][0].name} & #{team_options[2][1].name}"
        choice = prompt.select("Choose a team to fight:", team_1, team_2, team_3, max: 1)

        #Batrob.create(robot_id: self.id, battle_id: battle.id)

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
    
