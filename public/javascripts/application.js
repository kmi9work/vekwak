// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function over_student(){
  $('<div id=\"student_#{student.id}_login\" class=\"student_login\">#{student.login}</div>').
    appendTo('#student_#{student.id}');
}
function out_student(){
  $('#student_#{student.id}_login').remove();
}