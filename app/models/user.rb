class User < ActiveRecord::Base
    validates :name, presence: true
    validates :password, confirmation: true

    has_many    :chats
    has_many    :rooms
    has_many    :jobs
    has_many    :hires

    accepts_nested_attributes_for :chats, :allow_destroy => true
    accepts_nested_attributes_for :rooms, :allow_destroy => true
    accepts_nested_attributes_for :jobs, :allow_destroy => true
    accepts_nested_attributes_for :hires, :allow_destroy => true

    def self.authenticate(username, password)
        user = User.find_by_name(username)
        if user.blank? || 
            Digest::SHA256.hexdigest(password + user.salt) != user.password
            nil
        else
            user
        end
    end

    def self.identify_user(username)
        user = User.find_by_name(username)
        if user.blank?
            "true"
        else
            "false"
        end
    end


end
