/***********************************************************************************************************/
Date.prototype.addDays = function(days) {
  var date = new Date(this.valueOf());
  date.setDate(date.getDate() + days);
  return date;
}

const GLOBAL_SEP_ = ";";
const DEF_ROW_DFT = 20;

const DEF_HEADER_CARTOUCHE = { font: { sz: 8, name: 'Arial' }, alignment: { vertical: 'center', horizontal: 'left' } };
const DEF_FOOTER_CARTOUCHE = { font: { sz: 6, name: 'Arial' }, alignment: { vertical: 'center', horizontal: 'left' } };

const DEF_ROW_DFT_SETUP = { 'hpt': DEF_ROW_DFT };
const DEF_CELL_HEADER_FILL = { fgColor: { rgb: 'EDECFF' } };
const DEF_CELL_HEADER_HEAVY_FILL = { fgColor: { rgb: '1C1C1C' } };
const DEF_CELL_ODD_FILL = { fgColor: { rgb: 'F4F7FF' } };
const DEF_CELL_BORDER = { top: { style: "thin", color: {rgb: "383838"} },
                          bottom: { style: "thin", color: {rgb: "383838"} },
                          left: { style: "thin", color: {rgb: "383838"} },
                          right: { style: "thin", color: {rgb: "383838"} }
                        };

const DEF_EMPTY_CELL = { font: { sz: 8, name: 'Arial' }};
const DEF_HEADER_CELL_HEAVY = { font: { sz: 8, name: 'Arial', bold: true, color: {rgb: "FFFFFF"} }, alignment: { wrapText: true, vertical: 'center', horizontal: 'center' }, border: {...DEF_CELL_BORDER}, fill: {...DEF_CELL_HEADER_HEAVY_FILL} };
const DEF_HEADER_CELL = { font: { sz: 8, name: 'Arial' }, alignment: { wrapText: true, vertical: 'center', horizontal: 'center' }, border: {...DEF_CELL_BORDER}, fill: {...DEF_CELL_HEADER_FILL} };
const DEF_CELL = { font: { sz: 7, name: 'Arial' }, alignment: { wrapText: true, vertical: 'center', horizontal: 'center' }, border: {...DEF_CELL_BORDER} };
const DEF_CELL_ODD = { font: { sz: 7, name: 'Arial' }, alignment: { wrapText: true, vertical: 'center', horizontal: 'center' }, border: {...DEF_CELL_BORDER}, fill: {...DEF_CELL_ODD_FILL} };
const DEF_CELL_MONO = { font: { sz: 7, name: 'Courier New', bold: true }, alignment: { wrapText: true, vertical: 'center', horizontal: 'center' }, border: {...DEF_CELL_BORDER} };


function removeAccentuated(param){
  return param.normalize('NFD').replace(/[\u0300-\u036f]/g, '');
}

function removeAllQuotes(param){
  return param.replace(/"/g, '').replace(/'/g, '');
}

function getAriaryValue(value){
  return formatterCurrency.format(value).replace("MGA", "AR").replace(",00", "");
}

/***********************************************************************************************************/
function scrollToTop(){
  document.body.scrollTop = document.documentElement.scrollTop = 0;
}

// Send the event and block the input
function blockInputKeyboard(e){
  e = e || window.event;
  // to cancel the event:
  if( e.preventDefault) e.preventDefault();
  return false;
}

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

function getReportACEDateStrFR(paramDay){
  let today = new Date();
  let outDay = today.addDays(paramDay);
  let dateSTR = outDay.getDate().toString().padStart(2, '0')+'/'+(outDay.getMonth()+1).toString().padStart(2, '0')+'/'+outDay.getFullYear();

  return dateSTR;
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


function getVerboseExamStatus(param, isText){
  let startTagLoa = '<i class="uac-step uac-step-green">';
  let startTagRev = '<i class="uac-step uac-step-yellow">';
  let startTagEnd = '<i class="uac-step uac-step-dkblue">';
  let endTag = '</i>';
  if(isText ==  'Y'){
    startTagLoa = '';
    startTagRev = '';
    endTag = '';
  }
  // NEW > LOA > FED > END -- CAN
  if(param == 'LOA'){
      return startTagLoa + 'à saisir' + endTag;
  }
  else if(param == 'NEW'){
      return 'Nouveau';
  }
  else if(param == 'FED'){
      return startTagRev + 'à vérifier' + endTag;;
  }
  else if(param == 'CAN'){
      return 'Annulé';
  }
  else{
      // END
      return startTagEnd + 'Terminé' + endTag;;
  }
}

/***********************************************************************************************************/


function showHeaderAlertMsg(msg, isPrimary){
  $('#msg-alert').html(msg);
  if(isPrimary == 'Y'){
    $('#type-alert').addClass('alert-primary').removeClass('alert-danger');
  }
  else{
    $('#type-alert').removeClass('alert-primary').addClass('alert-danger');
  }
  $('#ace-alert-msg').show(100);
  document.body.scrollTop = document.documentElement.scrollTop = 0;
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