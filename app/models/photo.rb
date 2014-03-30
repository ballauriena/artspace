class Photo < ActiveRecord::Base
  belongs_to :space

  # This method associates the attribute ":uploaded_photo" with a file attachment
  has_attached_file :uploaded_photo, styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '300x300>'
  }

  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :uploaded_photo, :content_type => /\Aimage\/.*\Z/
end
