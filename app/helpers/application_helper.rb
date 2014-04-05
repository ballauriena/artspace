module ApplicationHelper

	def link_to_add_photo_fields(name, f)
		new_photo = Photo.new
		fields = f.fields_for(:photos, new_photo, :child_index => "new_photo") do |builder|
			render("photo_fields", :f => builder)
		end
	end

end
