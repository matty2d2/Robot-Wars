require_relative '../config/environment'
#########################################################################################################
def run
    greeting
    user = login_menu
    player_menu
end
#########################################################################################################
#########################################################################################################

def greeting
    puts "Welcome to Robot Wars!".center(50)
    puts "A game where you can create your own robot and pit it against other robots.\n \n"
    puts "Can you succeed in beating the competition or will your robot end up the scrapyard? \n."
end


def login_menu
    prompt = TTY::Prompt.new
    
    choice = prompt.select("Are you a returning player? Or a new player?", 'Existing Player', 'Create New Player')

    if choice == "Existing Player"
        sign_in
    else
        create_user
    end
end

def sign_in
    prompt = TTY::Prompt.new

    player_name = prompt.ask("Enter your player name:", required: true)
    choice = prompt.select("select player:", Player.find_by_name(player_name), "Re-enter username", "Create New Player", "Back to Main Menu")
    if choice == "Re-enter username"
        sign_in
    elsif choice == "Create New Player"
        create_user
    elsif choice == "Back to Main Menu"
        login_menu
    else
        puts "Welcome back #{choice}!"
        Player.find_by(username: choice)
    end
end


def create_user
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
        p = Player.create(username: new_name)
        puts "Welcome #{new_name}!"
        p
    end
end

def player_menu
    prompt = TTY::Prompt.new


end

