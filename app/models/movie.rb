class Movie < ActiveRecord::Base

    def self.ratings() 
        return self.select(:rating).map(&:rating).uniq.sort
    end
end
