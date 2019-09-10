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
    box = TTY::Box.frame(width: 100, height: 10, align: :center, padding: [1,3,1,3]) do
        "Welcome to ROBOT WARS! \n \n
        A game where you can create your own robot and pit it against other robots.\n \n
        Can you succeed in beating the competition or will your robot end up the scrapyard? \n"
      end
      print box
end


def login_menu
    puts ""
    prompt = TTY::Prompt.new
    choice = prompt.select("Are you a returning player? Or a new player?", 'Existing Player', 'Create New Player')

    if choice == "Existing Player"
        sign_in
    else
        create_user
    end
end


def sign_in
    puts ""
    prompt = TTY::Prompt.new
    choice = prompt.select("Select player:", Player.player_names, "Re-enter username", "Create New Player", "Back to Main Menu", filter: true)

    if choice == "Re-enter username"
        sign_in
    elsif choice == "Create New Player"
        create_user
    elsif choice == "Back to Main Menu"
        login_menu
    else
        puts "Welcome back #{choice}!"
        $user = Player.find_by(username: choice)
    end
end


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

def player_menu
    puts ""
    prompt = TTY::Prompt.new

    choice = prompt.select("", "Create a new Robot!", "My Robots", "My Destroyed Robots", "Back to Log-in Menu", "Quit Game")

    if choice == "Create a new Robot!"
        create_a_robot
        player_menu
    elsif choice == "My Robots"
        my_robots
    elsif choice == "My Destroyed Robots"
        destroyed_robots
    elsif choice == "Back to Log-in Menu"
        login_menu
        player_menu
    elsif choice == "Quit Game"
        quit_game
        return
    end
end

def fight
    myrobot = $robot
    battle = myrobot.choose_fight
    victim = battle.fight
    a = victim.check_hp
    b = battle.robots - [a]
    battle.winner = b[0].name
    battle.save
    # binding.pry
    $user = Player.find_by(username: $user.username)
end

def my_robots
    puts ""
    prompt = TTY::Prompt.new
    choice = prompt.select("Select a Robot:", $user.live_robo_names, "Back to Player Menu", "Quit Game")

    if choice == "Back to Player Menu"
        player_menu
    elsif choice == "Quit Game"
        quit_game
        return
    else
        myrobot = $user.robots.find_by(name: choice)
        sleep(0.4)
        puts ""
        puts myrobot.attributes.reject{|k,v| k == "id" || k == "player_id" || k == "name"}
        puts "Has won #{myrobot.wins} battle(s)."
        sleep(1)
        choice = prompt.select("", "Fight with this Robot!", "Return to my Robots")

        if choice == "Fight with this Robot!"
            $robot = myrobot
            fight
            player_menu
        elsif choice == "Return to my Robots"
            my_robots
        end
    end
end


def destroyed_robots
    puts ""
    prompt = TTY::Prompt.new
    choice = prompt.select("Select a Robot:", $user.dead_robo_names, "Back to Player Menu", "Sell all leftover parts (deletes robots)", "Quit Game")

    if choice == "Back to Player Menu"
        player_menu
    elsif choice == "Sell all leftover parts (deletes robots)"
        $user.dead_robots.each(&:delete)
        player_menu
    elsif choice == "Quit Game"
        quit_game
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

def create_a_robot
    prompt = TTY::Prompt.new
    rob_name = prompt.ask("Enter a robot name:", required: true)

    myrobot = Robot.create(name: rob_name, player_id: $user.id)
    puts myrobot.attributes.reject{|k,v| k == "id" || k == "player_id" || k == "name"}
end


def quit_game
    puts "Thanks for playing. Come back soon."
    puts ""
end