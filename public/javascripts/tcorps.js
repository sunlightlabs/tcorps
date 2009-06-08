var GB_ANIMATION = true;
$(document).ready(function(){
    
    $("div#signup_aol").hide();
	$("div#signup_standard").show();
	$("div#signup_yahoo").hide();
	$("div#signup_google").hide();
	$("div#signup_facebook").hide();
	$("div#signup_openid").hide();
    
	$("li#nav_standard a").click(function(){
		$("div#signup_aol").hide();
		$("div#signup_standard").show();
		$("div#signup_yahoo").hide();
		$("div#signup_google").hide();
		$("div#signup_facebook").hide();
		$("div#signup_openid").hide();
	});
	
	$("li#nav_aol a").click(function(){
		$("div#signup_aol").show();
		$("div#signup_standard").hide();
		$("div#signup_yahoo").hide();
		$("div#signup_google").hide();
		$("div#signup_facebook").hide();
		$("div#signup_openid").hide();
	});
	
	$("li#nav_yahoo a").click(function(){
		$("div#signup_aol").hide();
		$("div#signup_standard").hide();
		$("div#signup_yahoo").show();
		$("div#signup_google").hide();
		$("div#signup_facebook").hide();
		$("div#signup_openid").hide();
	});
	
	$("li#nav_google a").click(function(){
		$("div#signup_aol").hide();
		$("div#signup_standard").hide();
		$("div#signup_yahoo").hide();
		$("div#signup_google").show();
		$("div#signup_facebook").hide();
		$("div#signup_openid").hide();
	});
	
	$("li#nav_facebook a").click(function(){
		$("div#signup_aol").hide();
		$("div#signup_standard").hide();
		$("div#signup_yahoo").hide();
		$("div#signup_google").hide();
		$("div#signup_facebook").show();
		$("div#signup_openid").hide();
	});
	
	$("li#nav_openid a").click(function(){
		$("div#signup_aol").hide();
		$("div#signup_standard").hide();
		$("div#signup_yahoo").hide();
		$("div#signup_google").hide();
		$("div#signup_facebook").hide();
		$("div#signup_openid").show();
	});
	
	
	$("div#signin_aol").hide();
	$("div#signin_standard").show();
	$("div#signin_yahoo").hide();
	$("div#signin_google").hide();
	$("div#signin_facebook").hide();
	$("div#signin_openid").hide();
    
	$("li#nav_standard a").click(function(){
		$("div#signin_aol").hide();
		$("div#signin_standard").show();
		$("div#signin_yahoo").hide();
		$("div#signin_google").hide();
		$("div#signin_facebook").hide();
		$("div#signin_openid").hide();
	});
	
	$("li#nav_aol a").click(function(){
		$("div#signin_aol").show();
		$("div#signin_standard").hide();
		$("div#signin_yahoo").hide();
		$("div#signin_google").hide();
		$("div#signin_facebook").hide();
		$("div#signin_openid").hide();
	});
	
	$("li#nav_yahoo a").click(function(){
		$("div#signin_aol").hide();
		$("div#signin_standard").hide();
		$("div#signin_yahoo").show();
		$("div#signin_google").hide();
		$("div#signin_facebook").hide();
		$("div#signin_openid").hide();
	});
	
	$("li#nav_google a").click(function(){
		$("div#signin_aol").hide();
		$("div#signin_standard").hide();
		$("div#signin_yahoo").hide();
		$("div#signin_google").show();
		$("div#signin_facebook").hide();
		$("div#signin_openid").hide();
	});
	
	$("li#nav_facebook a").click(function(){
		$("div#signin_aol").hide();
		$("div#signin_standard").hide();
		$("div#signin_yahoo").hide();
		$("div#signin_google").hide();
		$("div#signin_facebook").show();
		$("div#signin_openid").hide();
	});
	
	$("li#nav_openid a").click(function(){
		$("div#signin_aol").hide();
		$("div#signin_standard").hide();
		$("div#signin_yahoo").hide();
		$("div#signin_google").hide();
		$("div#signin_facebook").hide();
		$("div#signin_openid").show();
	});
	
});
