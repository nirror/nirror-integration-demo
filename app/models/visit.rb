class Visit < ActiveRecord::Base

  belongs_to :proposition, :class_name => 'Proposition', :foreign_key => 'proposition_id'

end
