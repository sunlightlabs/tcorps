var GB_ANIMATION = true;

$(document).ready(function(){    
  $('div#signin_nav li a, div#signup_nav li a').click(function() {
    var name = $(this).parent('li')[0].id.split('_')[1];
    var type = $(this).parents('div.nav')[0].id.split('_')[0];
    return switch_nav(name, type);
  });
});

function switch_nav(name, type) {
  var nav_item = $('li#nav_' + name);
  var other_navs = $('div#' + type + '_nav li:not(#nav_' + name + ')');
  
  $('div.' + type + '_option').hide();
  $('div#' + type + '_' + name).show();
  other_navs.removeClass('active');
  nav_item.addClass('active');
  
  return false;
}

function setToNow(object, field) {
  var base = object + "_" + field;
  var now = new Date();
  var minutes = now.getMinutes();
  if (minutes < 10) minutes = "0" + minutes;
  
  $("#" + base + "_1i").val(now.getYear() + 1900);
  $("#" + base + "_2i").val(now.getMonth() + 1);
  $("#" + base + "_3i").val(now.getDate());
  $("#" + base + "_4i").val(now.getHours());
  $("#" + base + "_5i").val(minutes);
}

// adapted from http://baxil.livejournal.com/266909.html
function mailtoLink(rhs, tld, lhs) {
  document.write("<a href=\"mailto");
  document.write(":" + lhs + "@" + rhs + "." + tld + "\">");
  document.write(lhs + "@" + rhs + "." + tld + "<\/a>");
}