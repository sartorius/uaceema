/***********************************************************************************************************/


function getBrowserId(){
  let browserName = (function (agent) {        switch (true) {
          case agent.indexOf("edge") > -1: return "MS Edge";
          case agent.indexOf("edg/") > -1: return "Edge ( chromium based)";
          case agent.indexOf("opr") > -1 && !!window.opr: return "Opera";
          case agent.indexOf("chrome") > -1 && !!window.chrome: return "Chrome";
          case agent.indexOf("trident") > -1: return "MS IE";
          case agent.indexOf("firefox") > -1: return "Mozilla Firefox";
          case agent.indexOf("safari") > -1: return "Safari";
          default: return "other";
      }
  })(window.navigator.userAgent.toLowerCase());
  return browserName;
}

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

function showHeaderAlertMsg(msg, isPrimary){
  $('#msg-alert').html(msg);
  if(isPrimary == 'Y'){
    $('#type-alert').addClass('alert-primary').removeClass('alert-danger');
  }
  else{
    $('#type-alert').removeClass('alert-primary').addClass('alert-danger');
  }
  $('#ace-alert-msg').show(100);
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