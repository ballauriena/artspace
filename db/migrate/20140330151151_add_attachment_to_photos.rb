class AddAttachmentToPhotos < ActiveRecord::Migration
  def change
  	add_attachment :photos, :uploaded_photo
  end
end
