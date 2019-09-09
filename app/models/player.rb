class  Player < ActiveRecord::Base
    has_many :robots

    def self.player_names
        self.all.map{|player| player.username}
    end

    def self.find_by_name(player_name)
        player_names.select{|name| name.include?(player_name)}
    end

end
    
