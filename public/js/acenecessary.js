/***********************************************************************************************************/

// param can be : F for French /T for Technical/S for String Technical
function getACEDateStr(param){
  let today = new Date();
  let tdate = today.getFullYear()+'-'+(today.getMonth()+1).toString().padStart(2, '0')+'-'+today.getDate().toString().padStart(2, '0');
  let date = today.getDate().toString().padStart(2, '0')+'/'+(today.getMonth()+1).toString().padStart(2, '0')+'/'+today.getFullYear();
  let time = today.getHours().toString().padStart(2, '0') + ":" + today.getMinutes().toString().padStart(2, '0') + ":" + today.getSeconds().toString().padStart(2, '0');
  let dateTime = date+' à '+time;
  let tdateTime = tdate+' '+time;

  if(param ==  'F'){
    // return '27/07/2023 à 12:34:43'
    return dateTime;
  }
  else if(param == 'T'){
    // return '2023-07-27 12:35:01'
    return tdateTime;
  }else{
    return tdateTime.replaceAll(':', '').replaceAll('-', '').replaceAll(' ', '_');
  }
}

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