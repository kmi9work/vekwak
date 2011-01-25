// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function goRight(str){
  
}

function goLeft(str){
  $(str).animate({
    left: '-=286'
  }, 500, function() {
  });
}