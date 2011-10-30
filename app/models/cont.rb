class Cont < ActiveRecord::Base
  attr_accessor :title
  validates :link, :presence => true,
                   :uniqueness => true
end
