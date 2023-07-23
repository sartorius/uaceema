/***********************************************************************************************************/

function isNullMvo(param){
  return (param ==  null ? '' : param);
}

function verboseTypeOfPayment(value){
  if(value == 'C'){
      return 'Cash';
    }
    else if(value == 'H'){
        return 'Chèque';
    }
    else if(value == 'T'){
        return 'Virement/TPE';
    }
    else if(value == 'M'){
        return 'Mvola';
    }
    else if(value == 'R'){
        return 'Réduction';
    }
    else if(value == 'L'){
        return 'Lettre engagement';
    }
    else if(value == 'E'){
        return 'Exemption';
    }
    else{
      return 'Erreur 892C';
    }
}

function verboseStatusOfPayment(value){
  if(value == 'P'){
      return 'Payé';
    }
    else if(value == 'N'){
        return 'Non payé';
    }
    else if(value == 'E'){
        return 'Dispensé';
    }
    else{
      return 'Annulé';
    }
}


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