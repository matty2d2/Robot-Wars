class  Battle < ActiveRecord::Base
    has_many :batrobs
    has_many :robots, through: :batrobs

    def fight
        a = self.robots.sample
        a.lose_hp
        a
    end

    def fight_2_vs_2
        
    end
    
end
    