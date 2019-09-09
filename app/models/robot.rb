class  Robot < ActiveRecord::Base
    belongs_to :player
    has_many :batrobs
    has_many :battles, through: :batrobs


    def self.robot_names
        self.all.map{|robot| robot.name}
    end

end
    
