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
        battle = Battle.create()
        Batrob.create(robot_id: self.id, battle_id: battle.id)
        Batrob.create(robot_id: teammate.id, battle_id: battle.id)
        robot_options = Robot.live_robots.reject{|r| r.player_id == self.player_id}.sample(6)
        team_options = robot_options.each_slice(2).to_a
        team_1 = "Team 1 : #{team_options[0][0].name} & #{team_options[0][1].name}"
        team_2 = "Team 2 : #{team_options[1][0].name} & #{team_options[1][1].name}"
        team_3 = "Team 3 : #{team_options[2][0].name} & #{team_options[2][1].name}"
        choice = prompt.select("Choose a team to fight:", team_1, team_2, team_3, max: 1)

        if choice == team_1
            Batrob.create(robot_id: team_options[0][0].id, battle_id: battle.id)
            Batrob.create(robot_id: team_options[0][1].id, battle_id: battle.id)
        elsif choice == team_2
            Batrob.create(robot_id: team_options[1][0].id, battle_id: battle.id)
            Batrob.create(robot_id: team_options[1][1].id, battle_id: battle.id)
        elsif choice == team_3
            Batrob.create(robot_id: team_options[2][0].id, battle_id: battle.id)
            Batrob.create(robot_id: team_options[2][1].id, battle_id: battle.id)
        end
        battle
    end

    def lose_hp
        self.hitpoints -= 100
        self.save
    end

    def lose_hitpoints
        self.hitpoints -= rand(0..100)
    end

    def check_hp
        if self.hitpoints <= 0
            self.hitpoints = 0
            self.save
            self
        end
    end

    def wins
        battles.reload.uniq.select{|battle| battle.winner.include?(self.name)}.length
    end

    def update_hitpoints
        self.update(hitpoints: 100 + (45 * self.wins))
    end

end
    
