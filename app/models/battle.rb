class  Battle < ActiveRecord::Base
    has_many :batrobs
    has_many :robots, through: :batrobs
end
    
