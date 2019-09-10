class  Battle < ActiveRecord::Base
    has_many :batrobs
    has_many :robots, through: :batrobs

    def fight
        a = self.robots.sample
        a.lose_hp
        a
    end

    def 2vs2
    end
    
end
    