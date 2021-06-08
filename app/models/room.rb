class Room < ActiveRecord::Base
    has_many    :chats
    belongs_to  :user

    accepts_nested_attributes_for :chats, :allow_destroy => true
    accepts_nested_attributes_for :user, :allow_destroy => true

    def self.save(upload)
        name = upload['image_url'].original_filename
        directory = "app/assets/images/rooms"
        # create the file path
        path = File.join(directory, name)
        # write the file
        File.open(path, "wb") { |f| f.write(upload['image_url'].read) }
    end
end
