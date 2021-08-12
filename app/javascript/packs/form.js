$('#micropost_image').bind('change', function() {
  var size_mega = Settings.image.size_in_megabytes
  var size_in_megabytes = this.files[0].size/size_mega/size_mega;
  if (size_in_megabytes > Settings.image.size) {
    alert(t(".message_limit"));
  }
});
