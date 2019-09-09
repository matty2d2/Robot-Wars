class  Robot < ActiveRecord::Base
    belongs_to :player
    has_many :batrobs
    has_many :battles, through: :batrobs
end
    
