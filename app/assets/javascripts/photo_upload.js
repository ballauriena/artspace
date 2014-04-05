function remove_photos(link) {
	$(link).prev("input[type=hidden").value = "1";
	$(link).closest(".photo_fields").hide();
}