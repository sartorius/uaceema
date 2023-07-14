/***********************************************************************************************************/

function closeAlertMsg() {
  $('#ace-alert-msg').hide(1000);
}


$(document).ready(function() {
    console.log('We are in minimum necessary');

    $( ".ace-nav-adj" ).click(function() {
        $('#loading').show(50);
    });

    if($('#mg-graph-identifier').text() == 'xxx'){
      // Do something
    }
    else{
      //Do nothing
    }
  
  });