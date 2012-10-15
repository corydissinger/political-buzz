// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(document).ready(function() {
	// nice-scroll effect	
  	var topicsNice = $("#topic-scrollable").niceScroll({touchbehavior:true,cursoropacitymax:0.6,cursorwidth:8});
  	var statementsNice = $("#statement-scrollable").niceScroll({touchbehavior:true,cursoropacitymax:0.6,cursorwidth:8});
  	var detailsNice = $('#details-container').niceScroll({touchbehavior:true,cursoropacitymax:0.6,cursorwidth:8});
  	//masonry effect for statements
  	$(function(){
	  	$("#statement-canvas").masonry({
	  		itemSelector: '.statement',
	  		columnWidth: 400
	  	});
  	});
  	
  	// fit-text effect for topics page only
  	$(".topic-name").fitText();  	
	$(".topic-count").fitText();
});