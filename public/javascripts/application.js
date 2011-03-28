// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


//#{student.id}_login_top
function over_student(id, position){
  $('#student_'+ id + '_login_' + position).toggle();
}

function close_shadow(){
  $('#shadow_login').remove();
  $('#shadow_div').remove();
}
