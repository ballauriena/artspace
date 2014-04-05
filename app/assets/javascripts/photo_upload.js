function remove_photos(link) {
	if($('.remove_photo_link').length > 1){
	$(link).prev("input[type=hidden").value = "1";
	$(link).closest(".photo_fields").remove();
  }
}