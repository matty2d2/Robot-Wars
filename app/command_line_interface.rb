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

    choice = prompt.select("", "Fight!", "My Robots", "Back to Main Menu", "Quit Game")

    if choice == "Fight"
        fight
    elsif choice == "My Robots"
        my_robots
    elsif choice == "Back to Main Menu"
        login_menu
        player_menu
    elsif choice == "Quit Game"
        quit_game
        return
    end
end

def fight

end

def my_robots
    puts ""
    prompt = TTY::Prompt.new
    choice = prompt.select("Select Robot:", $user.robot_names, "Fight with this robot!", "Back to Player Menu", "Quit Game")

    if choice == "Fight"
        fight
    elsif choice == "My Robots"
        my_robots
    elsif choice == "Fight with this robot!"
        fight   
    elsif choice == "Back to Player Menu"
        player_menu
    elsif choice == "Quit Game"
        quit_game
        return
    else
        robot = Robot.find_by(name: choice)
        puts ""
        puts choice
        puts robot.attributes.reject{|k,v| k == "id" || k == "player_id" || k == "name"}
        puts ""
        sleep(2)
        my_robots
    end
end

def quit_game
    puts "Thanks for playing. Come back soon."
    puts ""
end