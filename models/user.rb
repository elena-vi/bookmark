require 'dm-migrations'
require 'data_mapper'
require 'dm-postgres-adapter'
require 'bcrypt'

class User

	include DataMapper::Resource

	property :id, Serial
	property :email, String
	property :password_digest, String, length: 60

	def password=(password)
		self.password_digest = BCrypt::Password.create(password)
	end
end

# 
# DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://localhost/bookmark_manager_#{ENV['RACK_ENV']}")
#
# DataMapper.finalize
# DataMapper.auto_upgrade!
