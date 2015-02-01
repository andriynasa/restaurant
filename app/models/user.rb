class User < ActiveRecord::Base
  # Sad but true: i am lazy and have no time to do it without devise
  devise :database_authenticatable, :rememberable
end
