var GB_ANIMATION = true;
$(document).ready(function(){
    
    $("div.signup_option").hide();
	$("div#signup_standard").show();
    
	$("li#nav_standard a").click(function(){
		$("div.signup_option").hide();
		$("div#signup_standard").show();
	});
	
	$("li#nav_aol a").click(function(){
	    $("div.signup_option").hide();
		$("div#signup_aol").show();
	});
	
	$("li#nav_yahoo a").click(function(){
		$("div.signup_option").hide();
		$("div#signup_yahoo").show();
	});
	
	$("li#nav_google a").click(function(){
	    $("div.signup_option").hide();
		$("div#signup_google").show();
	});
	
	$("li#nav_facebook a").click(function(){
		$("div.signup_option").hide();
		$("div#signup_facebook").show();
	});
	
	$("li#nav_openid a").click(function(){
		$("div.signup_option").hide();
		$("div#signup_openid").show();
	});
	
	
	$("div.signin_option").hide();
	$("div#signin_standard").show();
    
	$("li#nav_standard a").click(function(){
		$("div.signin_option").hide();
		$("div#signin_standard").show();
	});
	
	$("li#nav_aol a").click(function(){
	    $("div.signin_option").hide();
		$("div#signin_aol").show();
	});
	
	$("li#nav_yahoo a").click(function(){
		$("div.signin_option").hide();
		$("div#signin_yahoo").show();
	});
	
	$("li#nav_google a").click(function(){
		$("div.signin_option").hide();
		$("div#signin_google").show();
	});
	
	$("li#nav_facebook a").click(function(){
		$("div.signin_option").hide();
		$("div#signin_facebook").show();
	});
	
	$("li#nav_openid a").click(function(){
		$("div.signin_option").hide();
		$("div#signin_openid").show();
	});
	
});
