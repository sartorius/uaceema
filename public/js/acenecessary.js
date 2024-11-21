/***********************************************************************************************************/
Date.prototype.addDays = function(days) {
  var date = new Date(this.valueOf());
  date.setDate(date.getDate() + days);
  return date;
}

const EMAIL_REG = new RegExp(/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/);
const USERNAME_REG = new RegExp(/[a-zA-Z]{7}[\d]{3}/);

const GLOBAL_SEP_ = ";";
const DEF_ROW_DFT = 20;

const DEF_HEADER_CARTOUCHE_LOGO = { font: { sz: 20, name: 'Aceem' }, alignment: { vertical: 'center', horizontal: 'center' } };
const DEF_HEADER_CARTOUCHE = { font: { sz: 8, name: 'Arial' }, alignment: { vertical: 'center', horizontal: 'left' } };
const DEF_FOOTER_CARTOUCHE = { font: { sz: 6, name: 'Arial' }, alignment: { vertical: 'center', horizontal: 'left' } };



const DEF_ROW_DFT_SETUP = { 'hpt': DEF_ROW_DFT };
const DEF_CELL_HEADER_FILL = { fgColor: { rgb: 'EDECFF' } };
const DEF_CELL_HEADER_FILL_LRED = { fgColor: { rgb: 'FFCBCB' } };
const DEF_CELL_HEADER_FILL_LGRAY = { fgColor: { rgb: 'DBDBDB' } };
const DEF_CELL_HEADER_WHITE = { fgColor: { rgb: 'FFFFFF' } };
const DEF_CELL_HEADER_HEAVY_FILL = { fgColor: { rgb: '1C1C1C' } };
const DEF_CELL_ODD_FILL = { fgColor: { rgb: 'F4F7FF' } };
const DEF_CELL_YELLOW_FILL = { fgColor: { rgb: 'FFF97F' } };
const DEF_CELL_PINK_FILL = { fgColor: { rgb: 'FFE4E7' } };
const DEF_CELL_BORDER = { top: { style: "thin", color: {rgb: "383838"} },
                          bottom: { style: "thin", color: {rgb: "383838"} },
                          left: { style: "thin", color: {rgb: "383838"} },
                          right: { style: "thin", color: {rgb: "383838"} }
                        };

const DEF_EMPTY_CELL = { font: { sz: 8, name: 'Arial' }};
const DEF_HEADER_CELL_HEAVY_RIGHT = { font: { sz: 8, name: 'Arial', bold: true, color: {rgb: "FFFFFF"} }, alignment: { wrapText: true, vertical: 'center', horizontal: 'right' }, border: {...DEF_CELL_BORDER}, fill: {...DEF_CELL_HEADER_HEAVY_FILL} };
const DEF_HEADER_CELL_HEAVY = { font: { sz: 8, name: 'Arial', bold: true, color: {rgb: "FFFFFF"} }, alignment: { wrapText: true, vertical: 'center', horizontal: 'center' }, border: {...DEF_CELL_BORDER}, fill: {...DEF_CELL_HEADER_HEAVY_FILL} };
const DEF_HEADER_CELL = { font: { sz: 8, name: 'Arial' }, alignment: { wrapText: true, vertical: 'center', horizontal: 'center' }, border: {...DEF_CELL_BORDER}, fill: {...DEF_CELL_HEADER_FILL} };
const DEF_CELL = { font: { sz: 7, name: 'Arial' }, alignment: { wrapText: true, vertical: 'center', horizontal: 'center' }, border: {...DEF_CELL_BORDER} };
const DEF_CELL_ODD = { font: { sz: 7, name: 'Arial' }, alignment: { wrapText: true, vertical: 'center', horizontal: 'center' }, border: {...DEF_CELL_BORDER}, fill: {...DEF_CELL_ODD_FILL} };

const DEF_CELL_YELLOW = { font: { sz: 7, name: 'Arial' }, alignment: { wrapText: true, vertical: 'center', horizontal: 'center' }, border: {...DEF_CELL_BORDER}, fill: {...DEF_CELL_YELLOW_FILL} };
const DEF_CELL_PINK = { font: { sz: 7, name: 'Arial' }, alignment: { wrapText: true, vertical: 'center', horizontal: 'center' }, border: {...DEF_CELL_BORDER}, fill: {...DEF_CELL_PINK_FILL} };

const DEF_NBR_CELL = { font: { sz: 7, name: 'Roboto Mono' }, alignment: { wrapText: true, vertical: 'center', horizontal: 'right' }, border: {...DEF_CELL_BORDER} };
const DEF_NBR_CELL_ODD = { font: { sz: 7, name: 'Roboto Mono' }, alignment: { wrapText: true, vertical: 'center', horizontal: 'right' }, border: {...DEF_CELL_BORDER}, fill: {...DEF_CELL_ODD_FILL} };


const DEF_CELL_MONO = { font: { sz: 7, name: 'Courier New', bold: true }, alignment: { wrapText: true, vertical: 'center', horizontal: 'center' }, border: {...DEF_CELL_BORDER} };

const DEF_RESUME_HDR_CELL = { font: { sz: 9, name: 'Arial' }, alignment: { wrapText: true, vertical: 'center', horizontal: 'right' }, border: {...DEF_CELL_BORDER}, fill: {...DEF_CELL_HEADER_FILL} };
const DEF_RESUME_VAL_CELL = { font: { sz: 9, name: 'Roboto Mono' }, alignment: { wrapText: true, vertical: 'center', horizontal: 'right' }, border: {...DEF_CELL_BORDER}, fill: {...DEF_CELL_HEADER_WHITE} };
const DEF_RESUME_VAL_CELL_LRED = { font: { sz: 9, name: 'Roboto Mono' }, alignment: { wrapText: true, vertical: 'center', horizontal: 'right' }, border: {...DEF_CELL_BORDER}, fill: {...DEF_CELL_HEADER_FILL_LRED} };
const DEF_RESUME_VAL_CELL_LGRAY = { font: { sz: 9, name: 'Roboto Mono' }, alignment: { wrapText: true, vertical: 'center', horizontal: 'right' }, border: {...DEF_CELL_BORDER}, fill: {...DEF_CELL_HEADER_FILL_LGRAY} };

function removeAccentuated(param){
  return param.normalize('NFD').replace(/[\u0300-\u036f]/g, '');
}

function removeAllQuotes(param){
  return param.replace(/"/g, '').replace(/'/g, '');
}

function removeNonASCII(param){
  return param.replace(/[^\x20-\x7E]/g, "").replace(/"/g, '').replace(/'/g, '');
}

// Depreciated !!!
// Use the renderAmount instead !
function getAriaryValue(value){
  return formatterCurrency.format(value).replace("MGA", "AR").replace(",00", "");
}

function getMGPhoneFormat(str){
  if(str.length == 10){
    return str.substring(0, 3) + " " + str.substring(3, 5) + " " + str.substring(5, 7) + " " + str.substring(7);
  }
  else{
    return "ERR1892T"
  }
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

function getCapitalize(param){
  return param.charAt(0).toUpperCase() + param.slice(1).toLowerCase();
}


function splitStringPerSize(chaine, paramSize) {
  let tailleSousChaine = paramSize;
  const sousChaines = [];
  for (let i = 0; i < chaine.length; i += tailleSousChaine) {
      sousChaines.push(chaine.slice(i, i + tailleSousChaine));
  }
  return sousChaines;
}

// This is to get the current datetime
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

// This is to add days to the current day
// getReportACEDateStrFR(0) is date of today
function getReportACEDateStrFR(paramDay){
  let today = new Date();
  let outDay = today.addDays(paramDay);
  let dateSTR = outDay.getDate().toString().padStart(2, '0')+'/'+(outDay.getMonth()+1).toString().padStart(2, '0')+'/'+outDay.getFullYear();

  return dateSTR;
}

function convertSQLDateToDateStrFR(param){
  let refDate = new Date(Date.parse(param));
  return formatterDateFR.format(refDate);
}

function getReportACEMonthYearStrFR(paramIntervalMonth){
  let today = new Date();
  let outDay = today.addDays(0);

  let getMonth = (parseInt(outDay.getMonth())+1) + paramIntervalMonth;
  getMonth = (getMonth < 1) ? (getMonth + 12) : getMonth;
  let getReturnValue = '';
  switch(getMonth) {
    case 1:
      getReturnValue = 'janvier ';
      // code block
      break;
    case 2:
      getReturnValue = 'février ';
      // code block
      break;
    case 3:
      getReturnValue = 'mars ';
      // code block
      break;
    case 4:
      getReturnValue = 'avril ';
      // code block
      break;
    case 5:
      getReturnValue = 'mai ';
      // code block
      break;
    case 6:
      getReturnValue = 'juin ';
      // code block
      break;
    case 7:
      getReturnValue = 'juillet ';
      // code block
      break;
    case 8:
      getReturnValue = 'aout ';
      // code block
      break;
    case 9:
      getReturnValue = 'septembre ';
      // code block
      break;
    case 10:
      getReturnValue = 'octobre ';
      // code block
      break;
    case 11:
      getReturnValue = 'novembre ';
      // code block
      break;
    case 12:
      getReturnValue = 'décembre ';
      // code block
      break;
    default:
      getReturnValue = 'err2917P ';
      // code block
  }

  return getReturnValue +outDay.getFullYear();
}

// getWrittenFRLongDateStrFR(0, 'Y');
function getWrittenFRLongDateStrFR(paramIntervalMonth, paramYear){
  let today = new Date();
  let outDay = today.addDays(0);

  let getMonth = (parseInt(outDay.getMonth())+1) + paramIntervalMonth;
  getMonth = (getMonth < 1) ? (getMonth + 12) : getMonth;
  let getReturnValue = '';
  switch(getMonth) {
    case 1:
      getReturnValue = 'janvier';
      // code block
      break;
    case 2:
      getReturnValue = 'février';
      // code block
      break;
    case 3:
      getReturnValue = 'mars';
      // code block
      break;
    case 4:
      getReturnValue = 'avril';
      // code block
      break;
    case 5:
      getReturnValue = 'mai';
      // code block
      break;
    case 6:
      getReturnValue = 'juin';
      // code block
      break;
    case 7:
      getReturnValue = 'juillet';
      // code block
      break;
    case 8:
      getReturnValue = 'aout';
      // code block
      break;
    case 9:
      getReturnValue = 'septembre';
      // code block
      break;
    case 10:
      getReturnValue = 'octobre';
      // code block
      break;
    case 11:
      getReturnValue = 'novembre';
      // code block
      break;
    case 12:
      getReturnValue = 'décembre';
      // code block
      break;
    default:
      getReturnValue = 'err2917P ';
      // code block
  }

  if(paramYear ==  'Y'){
    return outDay.getDate() + ' ' + getReturnValue + ' ' + outDay.getFullYear();
  }
  else{
    return outDay.getDate() + ' ' + getReturnValue ;
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


function getVerboseExamStatus(param, isText){
  let startTagLoa = '<i class="uac-step uac-step-green">';
  let startTagRev = '<i class="uac-step uac-step-yellow">';
  let startTagEnd = '<i class="uac-step uac-step-dkblue">';
  let endTag = '</i>';
  if(isText ==  'Y'){
    startTagLoa = '';
    startTagRev = '';
    startTagEnd = '';
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

function renderAmount(param){
	let len = param.toString().length;
	let result = '';
	let k = 0;
	for(var i=0;i<len+1;i++){
		result = param.toString().substr(len-i,1) + result;
		if(k == 3){
			result = ' ' + result;
			k = 0;
		}
		k++;
	}
	return result.replace(",00", "") + ' AR';
}

function renderAmountExcel(param){
  return renderAmount(param) + ' ';
}

function renderAmountExcelNegative(param){
  if(renderAmountExcel(param)[0] == ' '){
    return '-' + renderAmountExcel(param);
  }
  else{
    return '- ' + renderAmountExcel(param);
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