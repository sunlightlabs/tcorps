function setToNow(object, field) {
  var base = object + "_" + field;
  var now = new Date();
  var minutes = now.getMinutes();
  if (minutes < 10) minutes = "0" + minutes;
  
  $("#" + base + "_1i").val(now.getYear() + 1900);
  $("#" + base + "_2i").val(now.getMonth() + 1);
  $("#" + base + "_3i").val(now.getDay());
  $("#" + base + "_4i").val(now.getHours());
  $("#" + base + "_5i").val(minutes);
}