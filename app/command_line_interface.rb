require_relative '../config/environment'
#########################################################################################################
def run
    greeting
    login_menu
    player_menu
end
#########################################################################################################
#########################################################################################################

def greeting
    box = TTY::Box.frame(width: 90, height: 10, align: :center, padding: 1) do
         '         ______       _                   _  _  _                 
        (_____ \     | |           _     (_)(_)(_)                
         _____) )___ | |__   ___ _| |_    _  _  _ _____  ____ ___ 
        |  __  // _ \|  _ \ / _ (_   _)  | || || (____ |/ ___)___)
        | |  \ \ |_| | |_) ) |_| || |_   | || || / ___ | |  |___ |
        |_|   |_\___/|____/ \___/  \__)   \_____/\_____|_|  (___/ '
      end
      print box
end
########################################
########################################
def login_menu
    puts ""
    prompt = TTY::Prompt.new
    choice = prompt.select("Are you a returning player? Or a new player?", 'Existing Player', 'Create New Player', 'Quit Game')

    if choice == "Existing Player"
        sign_in
    elsif choice == "Create New Player"
        create_user
    elsif choice == "Quit Game"
        quit_game_message
    end
end
########################################
########################################
def sign_in
    puts ""
    prompt = TTY::Prompt.new
    choice = prompt.select("Select player:", Player.player_names, "Create New Player", "Back to Main Menu", filter: true)

    if choice == "Create New Player"
        create_user
    elsif choice == "Back to Main Menu"
        login_menu
    else
        puts "Welcome back #{choice}!"
        $user = Player.find_by(username: choice)
    end
end
########################################
########################################
def create_user
    puts ""
    prompt = TTY::Prompt.new
    new_name = prompt.ask("Enter new username:", required: true)

    if Player.player_names.include?(new_name)
        choice = prompt.select("Username taken.", "Create New Player", "Back to Main Menu")
        if choice == "Create New Player"
            create_user
        else
            login_menu
        end
    else
        $user = Player.create(username: new_name)
        puts "Welcome #{new_name}!"
        
    end
end
########################################
########################################
def player_menu
    puts ""
    prompt = TTY::Prompt.new

    choice = prompt.select("", "Create a new Robot!", "My Robots", "My Destroyed Robots", "Stats", "Back to Log-in Menu", "Quit Game")

    if choice == "Create a new Robot!"
        create_a_robot
        player_menu
    elsif choice == "My Robots"
        my_robots
    elsif choice == "My Destroyed Robots"
        destroyed_robots
    elsif choice == "Stats"
        stats
    elsif choice == "Back to Log-in Menu"
        login_menu
        player_menu
    elsif choice == "Quit Game"
        quit_game_message
        return
    end
end
########################################
########################################

 def my_robots
    puts ""
    prompt = TTY::Prompt.new
    choice = prompt.select("Select a Robot:", $user.reload.live_robo_names, "Back to Player Menu", "Quit Game")

    if choice == "Back to Player Menu"
        player_menu
    elsif choice == "Quit Game"
        quit_game_message
        return
    else
        myrobot = $user.robots.find_by(name: choice)
        $robot = myrobot
        sleep(0.4)
        puts ""
        puts myrobot.attributes.reject{|k,v| k == "id" || k == "player_id" || k == "name"}
        puts "Has won #{myrobot.wins} battle(s)."
        sleep(1)

        choice = prompt.select("", "Fight with this Robot!", "Configure Robot", "Return to my Robots")
        if choice == "Configure Robot"
            configure_robot
            my_robots
        elsif choice == "Fight with this Robot!"
            choose_gamemode
        elsif choice == "Return to my Robots"
            my_robots
        end
    end
end
########################################
def choose_gamemode
    prompt = TTY::Prompt.new
    choice = prompt.select("Choose a game-mode:", "Battle-Royale", "2 v 2")
    
    if choice == "Battle-Royale"
        fight
        player_menu
    elsif choice == "2 v 2"
        select_teammate
        fight_2vs2
        player_menu
    end
end
########################################
def fight
    myrobot = $robot
    battle = myrobot.choose_fight
    b = battle.robots
    rob_names = b.map(&:name)

    until b.length == 1
        victim = battle.fight
        a = victim.check_hp
        b -= [a]
    end

    puts "\n The winner is #{b[0].name}!!!!!!"
    puts "\n #{rob_names - [b[0].name]} has been destroyed."
    battle.winner = [b[0].name]
    battle.save

    $user = Player.find_by(username: $user.username)
end
########################################
def fight_2vs2
    battle = $robot.choose_2vs2_fight($robot2)
    player_team = battle.robots.select{|robot| robot.player_id == $user.id}
    opposition_team = battle.robots.select{|robot| robot.player_id != $user.id}
    teams = [player_team] + [opposition_team]
    win = battle.fight_2_vs_2(player_team, opposition_team)
        # binding.pry
    losers = battle.robots - win
    # binding.pry
    if win.length == 2
         puts "\n The winners are #{win.map(&:name).join(", ")}!!!!!!"
    elsif win.length == 0
        puts "Every robot has died for your cause"
    elsif win.length == 1
        puts "\n The winner is #{win.map(&:name).join(", ")}!!!!!!"
    end
        puts "\n ... #{losers.map(&:name).join(", ")} have been destroyed."
        battle.winner = win.map(&:name)
        # win.update_hitpoints
        battle.save
                # binding.pry
        win.each{|winner| winner.update_hitpoints}
        $user = Player.find_by(username: $user.username)
end
########################################
def select_teammate
    prompt = TTY::Prompt.new
    choice_2 = prompt.select("Select your 2nd Robot:", $user.live_robo_names.reject{|robot| robot == $robot.name}, "Back to Player Menu", "Quit Game")
    if choice_2 == "Back to Player Menu"
        player_menu
    elsif choice_2 == "Quit Game"
        quit_game_message
        return
    else
        $robot2 = $user.robots.find_by(name: choice_2)
    end
end

########################################
def destroyed_robots
    puts ""
    prompt = TTY::Prompt.new
    choice = prompt.select("Select a Robot:", $user.reload.dead_robo_names, "Back to Player Menu", "Sell all leftover parts (deletes robots)", "Quit Game")

    if choice == "Back to Player Menu"
        player_menu
    elsif choice == "Sell all leftover parts (deletes robots)"
        $user.dead_robots.each(&:delete)
        puts "\n There were no salvageable parts. Better luck next time!"
        player_menu
    elsif choice == "Quit Game"
        quit_game_message
        return
    else
        myrobot = Robot.find_by(name: choice)
        sleep(0.4)
        puts ""
        puts myrobot.attributes.reject{|k,v| k == "id" || k == "player_id" || k == "name"}
        puts "Has won #{myrobot.wins} battle(s)."
        sleep(1)
        destroyed_robots
    end
end
########################################
########################################
def create_a_robot
    prompt = TTY::Prompt.new
    rob_name = prompt.ask("Enter a robot name:", required: true)

    if valid_robot_name?(rob_name)
        myrobot = Robot.create(name: rob_name, player_id: $user.id)
        puts myrobot.attributes.reject{|k,v| k == "id" || k == "player_id" || k == "name"}
    else
        puts "Robot has not been created. There is already a robot with that name."
    end
end

def valid_robot_name?(name)
    !Robot.robot_names.include?(name)
end
########################################
########################################
def quit_game_message
    puts "Thanks for playing. Come back soon."
    puts ""
    exit
end
########################################
########################################
def stats
    prompt = TTY::Prompt.new

    sleep(0.2)
    puts "Total Wins: #{$user.total_wins}"
    sleep(0.5)
    puts "Number of Robots: #{$user.live_robots.length}"
    sleep(0.5)
    puts "Number of Destroyed Robots: #{$user.dead_robots.length}"
    sleep(0.5)
    puts "Robot with the most wins: #{$user.best_robot.name} ~ #{$user.best_robot.wins}"
    sleep(0.5)
    prompt.ask("Press Enter to return back to the player menu.")
    player_menu
end
########################################
########################################
def configure_robot
    prompt = TTY::Prompt.new
    choice = prompt.select("What would you like to configure?", "Change Robot Name", "Back to Player Menu", "Quit Game")

    if choice == "Change Robot Name"
        change_name
    elsif choice == "Back to Player Menu"
        player_menu
    elsif choice == "Quit Game"
        quit_game
        return
    end
end

def change_name
    prompt = TTY::Prompt.new
    rob_name = prompt.ask("What would you like to change your robot name to:", required: true)

    if valid_robot_name?(rob_name)
        $robot.update(name: rob_name)
    else
        puts "Robot name has not been changed. There is already a robot with that name."
    end
end