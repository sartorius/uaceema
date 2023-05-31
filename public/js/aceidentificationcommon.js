function renderAmount(param){
	var len = param.toString().length;
	var result = '';
	var k = 0;
	for(var i=0;i<len+1;i++){
		result = param.toString().substr(len-i,1) + result;
		if(k == 3){
			result = ' ' + result;
			k = 0;
		}
		k++;
	}
	return result + ' AR';
}

/***********************************************************************************************************/

function loadRefPayGrid(){

    refPayField = [
        { name: "id",
          title: '#',
          type: "number",
          align: "right",
          width: 15,
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm"
        },
        //Default width is auto
        { name: "title",
          title: "Titre",
          type: "text",
          width: 120,
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm"
        },
        //Default width is auto
        { name: "amount",
          title: "Montant",
          type: "number",
          align: "right",
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm",
          itemTemplate: function(value, item) {
            return formatterCurrency.format(value).replace("MGA", "AR");
          }
        },
        { name: "type",
          title: "Paiement",
          type: "text",
          width: 45,
          align: "right",
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm",
          itemTemplate: function(value, item) {
            if(value == 'U'){
              return "Unique";
            }
            else if(value == 'M'){
              return "Multiple";
            }
            else{
              return "Tranche";
            }
          }
        },
        { name: "deadline",
          title: "Limite",
          type: "text",
          width: 50,
          align: "right",
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm",
          itemTemplate: function(value, item) {
            let refDate = new Date(Date.parse(value));
            return formatterDateFR.format(refDate);
          }
        },
        //Default width is auto
        { name: "code",
          title: "Code",
          type: "text",
          width: 50,
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm-mono"
        }
    ];

    $("#jsGridRefPay").jsGrid({
        height: "auto",
        width: "100%",
        noDataContent: "Aucune référence disponible",
        pageIndex: 1,
        pageSize: 50,
        pagePrevText: "Prec",
        pageNextText: "Suiv",
        pageFirstText: "Prem",
        pageLastText: "Dern",

        sorting: true,
        paging: true,
        data: dataREFPAYToJsonArray,
        fields: refPayField
    });
}

/***********************************************************************************************************/
/***********************************************************************************************************/
/***********************************************************************************************************/
/***********************************************************************************************************/
/*********************************************** AJAX ******************************************************/
/***********************************************************************************************************/
/***********************************************************************************************************/
/***********************************************************************************************************/
/***********************************************************************************************************/

function getAllPaymentForFoundUser(){
  $("#waiting-gif").show(100);
  $.ajax('/getpaymentforuserDB', {
      type: 'POST',  // http method
      data: {
        foundUserName: foundUserName,
        token : getToken
      },  // data to submit
      success: function (data, status, xhr) {
          $("#waiting-gif").hide(100);
          //console.log('End of the Ajax correctly');
          //console.log(data['result']);
          dataPaymentForUserJsonArray = data['result'].slice();
          dataLeftOperationForUserJsonArray = data['resultLeftOperation'].slice();
          // Only here we allow to progress
          for(let i=0; i<dataLeftOperationForUserJsonArray.length; i++){
            if(dataLeftOperationForUserJsonArray[i].REF_TYPE == 'T'){
                // Still Tranche operation remains
                // Only if there are Tranche left we allow cut
                $('#btn-addpay').removeClass('deactive-btn');
                $('#btn-addcut').removeClass('deactive-btn');
            }
            
            if(dataLeftOperationForUserJsonArray[i].REF_TYPE == 'U'){
                // Still Unique operation remains
                $('#btn-adduni').removeClass('deactive-btn');
            }
          }

          if(currentTicketMode == 'P'){
              $("#addp-mainop").show(100);
          }
          else if(currentTicketMode == 'R'){
              $("#addp-valred").show(100);
          }
          else{
            //Do nothing
            $('#msg-alert').html("Err138D:" + foundUserName + " erreur affichage, contactez le support.");
          }
          $("#btn-print-recap").show(100);
          // Display paiements
          displayHistoryPayment();
      },
      error: function (jqXhr, textStatus, errorMessage) {
        $("#waiting-gif").hide(100);
        $('#msg-alert').html("Err134P:" + foundUserName + " impossible de récupérer ses paiements, contactez le support.");
        $('#type-alert').removeClass('alert-primary').addClass('alert-danger');
        $('#ace-alert-msg').show(100);
        addPayClear();
      }
  });
}



function printReceiptPDF(tempTicketRef){

  //console.log('Click on printReceiptPDF');


  // Let say we are in a cut
  JsBarcode("#barcode", tempTicketRef, {
    width: 1.5,
    height: 85,
    displayValue: false
  });


  // Document of 210mm wide and 297mm high > A4
  // new jsPDF('p', 'mm', [297, 210]);
  // Here format A7
  let doc = new jsPDF('p', 'mm', [150, 75]);

  doc.setFont("Courier");
  doc.setFontType("bold");

  doc.setTextColor(0, 0, 0);


  doc.addImage(document.getElementById('logo-carte'), //img src
                'PNG', //format
                11, //x oddOffsetX is to define if position 1 or 2
                0, //y
                50, //Width
                16, null, 'FAST'); //Height // Fast is to get less big files


  doc.addImage(document.getElementById('barcode').src, //img src
                'PNG', //format
                14, //x oddOffsetX is to define if position 1 or 2
                18, //y
                50, //Width
                30, null, 'FAST'); //Height // Fast is to get less big files

  doc.setFontSize(14);
  doc.text(24, 50, tempTicketRef);

  doc.setFontSize(7);
  doc.setFontType("normal");
  //doc.text(18, 25, "REDUCTION 50%");
  let margTop = 59;
  let contentHeight = 0;
  doc.setFontSize(8);
  for(var i=0; i<myTicket.length; i++){
    contentHeight = margTop + (i*5);
    if(i>0){
      doc.text(maxPadLeft, contentHeight, myTicket[i].substring(0, (maxLgTicket - maxPrintTicket)));
    }
    else{
      doc.text(maxPadLeft, contentHeight, myTicket[i].substring(maxPrintTicket));
    }
  }

  contentHeight = contentHeight + 40;
  doc.setFontSize(5);
  let filename = 'FS_' + foundUserName + '_' + tempTicketRef + ticketRefFile;
  doc.text(5, contentHeight, "REF_Fich_" + filename + "_FRAIS");

  doc.save(filename);


  //$("body").removeClass("loading");
  //$("#screen-load").hide();
  // 0123456789
  // 0304125678R
  addPayClear();
  // Display file
  $('#msg-alert').html(filename + '.pdf a bien été généré');
  $('#type-alert').addClass('alert-primary').removeClass('alert-danger');
  $('#ace-alert-msg').show(100);
}

/**********************************************************/

function clearFoundUser(){
  foundiInJson = 0;
  foundUserName = '';
  foundMatricule = '';
  foundName = '';
  foundClasse = '';
  foundUserId = 0;
  foundExisting_Facilite = '';
  $("#btn-addcut").removeClass('deactive-btn');
  $(".pay-fac-rm").removeClass('deactive-btn');
  $("#btn-addfac-1").removeClass('deactive-btn');

  $("#btn-clear-addpay").prop("disabled", true);

  // Clear Data
  dataPaymentForUserJsonArray = new Array();
  dataLeftOperationForUserJsonArray = new Array();
  payUniLeftOperationForUserJsonArray = new Array();
  $(".init-deactive").addClass('deactive-btn');
}

function addPayUserExists(val){
  for (var i = 0; i < dataAllUSRNToJsonArray.length; i++) {
    if (dataAllUSRNToJsonArray[i].USERNAME === val){
      foundiInJson = i;
      foundUserName = dataAllUSRNToJsonArray[i].USERNAME;
      foundMatricule = dataAllUSRNToJsonArray[i].MATRICULE;
      foundName = dataAllUSRNToJsonArray[i].NAME;
      foundClasse = dataAllUSRNToJsonArray[i].CLASSE;
      foundUserId = dataAllUSRNToJsonArray[i].ID;
      foundExisting_Facilite = dataAllUSRNToJsonArray[i].EXISTING_FACILITE;

      $("#btn-clear-addpay").prop("disabled", false);

      // Check if we already have a Reduction
      if((foundExisting_Facilite != undefined) && (foundExisting_Facilite != null)){
          if(foundExisting_Facilite.includes('R')){
            $(".pay-fac-rm").addClass('deactive-btn');
          }
          else if(foundExisting_Facilite.includes('M')){
            $("#btn-addfac-1").addClass('deactive-btn');
          }
          else {
            // Do nothing
          }
      }

      /** ********************************************* */
      /** ********************************************* */
      /** ********************************************* */
      /** WE LOAD HISTORY ONLY IF WE ARE ON PAY SCREENS */
      /** ********************************************* */
      /** ********************************************* */
      /** ********************************************* */

      if($('#mg-graph-identifier').text() == 'add-pay'){
            getAllPaymentForFoundUser();
      }

      return true;
    }
  }
  return false;
}

function addPayReductionExists(val){
    for (var i = 0; i < dataAllREDUCToJsonArray.length; i++) {
      if (dataAllREDUCToJsonArray[i].TICKET_REF === val){
        return dataAllREDUCToJsonArray[i].USERNAME;
      }
    }
    return 'na';
  }

// Common element
function addPayClear(){
  $('#addpay-ace').val('');
  $('#last-read-bc').html('');
  $('#last-read-time').html('');
  $("#exist-code-read").html('N');
  $('#addpay-ace').show(100);

  $("#addp-mainop").hide(100);
  $("#addp-print").hide(100);
  $("#addp-type-pay").hide(100);

  /** SPECIFIC PAYMENT */
  $("#addp-red-option").hide(100);
  $("#addp-pay-part").hide(100);
  $("#addp-pay-uni").hide(100);
  $("#addp-pay-success").hide(100);
  $("#addp-valred").hide(100);
  invAmountToPay = 0;
  invFscId = 0;
  invTypeOfPayment = 'C';
  invOperation = 'F';

  updateTicketType('X');
  clearFoundUser();
  // Clear the log;
  logInAddPay('');
  $('#pay-recap-tra').html('');
  $("#btn-print-recap").hide(100);
  myTicket = new Array();
  myRecap = new Array();
  dataPaymentForUserJsonArray = new Array();
  $("#waiting-gif").hide(100);
}

function commonOperationIfFoundUsername(paramUsername){
    $("#exist-code-read").html('Y');
    $('#addpay-ace').hide(100);
    logInAddPay('username:' + paramUsername);
    logInAddPay(foundMatricule);
    logInAddPay(foundName);
    logInAddPay(foundClasse);
    logInAddPay('A DÉJÀ DEMANDÉ: ' + ((foundExisting_Facilite == null) ? 'NÉANT' : foundExisting_Facilite));
}


function verityAddComContentScan(){

  $('#type-alert').addClass('alert-primary').removeClass('alert-danger');
  $('#ace-alert-msg').hide(100);
  // Do something
  let foundCode = $("#exist-code-read").html();
  if(foundCode == 'N'){
    $("#addp-mainop").hide(200);
  }


  if ($('#addpay-ace').val().length == 10){

    let originalRedInput = $('#addpay-ace').val();
    let readInput = $('#addpay-ace').val().replace(/[^a-z0-9]/gi,'').toUpperCase();
    //console.log("Diagnostic 2 Read Input : " + readInput.length + ' : ' + readInput + ' - ' + originalRedInput + ' 0/' + convertWordAZERTY(originalRedInput) + ' 1/' + convertWordAZERTY(originalRedInput).toUpperCase() + ' 2/' + convertWordAZERTY(originalRedInput).toUpperCase().replace(/[^a-z0-9]/gi,'') + ' 3/' + convertWordAZERTY(originalRedInput).toLowerCase().replace(/[^a-z0-9]/gi,''));

    if(readInput.length < 10){
      // We are on the wrong keyboard config as it must be 10
      readInput = convertWordAZERTY(originalRedInput).replace(/[^a-z0-9]/gi,'').toUpperCase();
    }

    let scanValidToDisplay = ' <i class="mgs-rd-o-err">&nbsp;ERR91Format&nbsp;</i>';
    // Here we check the format
    if(/[a-zA-Z0-9]{9}[0-9]/.test(readInput)){
      // Only if the read is clean
      currentTicketMode = 'P';
      if(addPayUserExists(readInput)){
        /********************************************************** FOUND **********************************************************/
        scanValidToDisplay = ' <i class="mgs-rd-o-in">&nbsp;Étudiant valide&nbsp;</i>';
        commonOperationIfFoundUsername(readInput);

      }
      else{
        /******************************************************** NOT FOUND ********************************************************/
        scanValidToDisplay = ' <i class="mgs-rd-o-err">&nbsp;Étudiant introuvable&nbsp;</i>';
      }
    }
    else{
        // If we are on the pay screen we need to do somthing
        // We do not match a username
        if(($('#mg-graph-identifier').text() == 'add-pay')){
            if(/[0-9]{9}[R]/.test(readInput)){
                console.log('Format OK readInput: ' + readInput);
                /******************************* Look in the list *********************************/
                /********************* Retrieve only Reduction Inactive ***************************/

                currentTicketMode = 'R';
                // xxx
                let reductionUsername = addPayReductionExists(readInput);
                if(reductionUsername != 'na'){
                    if(addPayUserExists(reductionUsername)){
                        /********************************************************** FOUND **********************************************************/
                        scanValidToDisplay = ' <i class="mgs-rd-o-in">&nbsp;Réduction valide&nbsp;</i>';
                        commonOperationIfFoundUsername(reductionUsername);
                        updateTicketType('V');
                        logInAddPay('VALIDATION*' + readInput);
                
                      }
                      else{
                        /******************************************************** NOT FOUND ********************************************************/
                        scanValidToDisplay = ' <i class="mgs-rd-o-err">&nbsp;ERR93 Étudiant&nbsp;</i>';
                      }
                }
                else{
                    // reductionUsername == 'na'
                    /******************************************************** NOT FOUND ********************************************************/
                    scanValidToDisplay = ' <i class="mgs-rd-o-err">&nbsp;Ticket introuvable&nbsp;</i>';
                }
            }
            else{
              /******************************************************** NOT FOUND ********************************************************/
              scanValidToDisplay = ' <i class="mgs-rd-o-err">&nbsp;ERR92Format&nbsp;</i>';
            }
        }
        else{
            //We are not in pay screen we do nothing
        }
    }

    //console.log('We have read: ' + $('#addpay-ace').val());
    $('#last-read-bc').html(readInput + scanValidToDisplay);

    let today = new Date();
    let tdate = today.getFullYear()+'-'+(today.getMonth()+1).toString().padStart(2, '0')+'-'+today.getDate().toString().padStart(2, '0');
    let date = today.getDate().toString().padStart(2, '0')+'/'+(today.getMonth()+1).toString().padStart(2, '0')+'/'+today.getFullYear();
    let time = today.getHours().toString().padStart(2, '0') + ":" + today.getMinutes().toString().padStart(2, '0') + ":" + today.getSeconds().toString().padStart(2, '0');
    let tdateTime = tdate+' '+time;
    let dateTime = date+' à '+time;
    $('#last-read-time').html(dateTime);


    // Save for any internet issue here
    $('#addpay-ace').val('');
    //$("#btn-load-bc").show();



  }
  else if($('#addpay-ace').val().length > 10) {
    // Great length
    $('#addpay-ace').val('');
    $("#exist-code-read").html('N');

  }
  else {
    //Do nothing


  }
}

// Common as right ticket
function logInAddPay(someMsg){

  let myNow = new Date();
  let date = myNow.getDate().toString().padStart(2, '0')+'/'+(myNow.getMonth()+1).toString().padStart(2, '0')+'/'+myNow.getFullYear();
  let time = myNow.getHours().toString().padStart(2, '0') + ":" + myNow.getMinutes().toString().padStart(2, '0') + ":" + myNow.getSeconds().toString().padStart(2, '0');


  let appendLog = '';
  let myBreak = '<br>';
  if(someMsg != ''){
    // I am not on start here
    appendLog = (someMsg.substring(0, (maxLgTicket - sizeTime)) + sepTime + time).toString().padStart(maxLgTicket, paddChar);
  }
  else{
    appendLog = ('GÉNÉRÉ LE ' + date + sepTime + time).toString().padStart(maxLgTicket, paddChar);
    $('#pay-sc-log-tra').html('');
    redPc = 0;
    clearFoundUser();

    myBreak = '';

    let ticketRefTime = myNow.getHours().toString().padStart(2, '4') + myNow.getMinutes().toString().padStart(2, '0') + myNow.getSeconds().toString().padStart(2, '0');
    // This will be HHMMss + Day of the year on 3 digit + Type
    ticketRef = ticketRefTime + (Math.floor((myNow - new Date(myNow.getFullYear(), 0, 0)) / 1000 / 60 / 60 / 24)).toString().padStart(3, '0');

    let tdate = myNow.getDate().toString().padStart(2, '0')+'_'+(myNow.getMonth()+1).toString().padStart(2, '0')+'_'+myNow.getFullYear();
    let ttime = myNow.getHours().toString().padStart(2, '0') + "h" + myNow.getMinutes().toString().padStart(2, '0') + "m" + myNow.getSeconds().toString().padStart(2, '0');

    ticketRefFile = tdate + "_" + ttime;
    updateTicketType('X');
  }
  let myLog = $('#pay-sc-log-tra').html();
  myTicket.push(appendLog);
  $('#pay-sc-log-tra').html(myLog + myBreak + appendLog);

};

function displayHistoryPayment(){
  let recapTxt = '';
  let recapLine = '';
  let statusPay = 'Non payé';
  let refDate;
  let recAmount = '';
  let typeOfPayment = '';
  let refRecAmount = '';
  let notifRetard = '';
  const separatorRecap = '----x---x---x---x---x---x---x---x---x---x----';

  for(let i=0; i<dataPaymentForUserJsonArray.length; i++){
    recapLine = dataPaymentForUserJsonArray[i].REF_TITLE.toString().padStart(maxLgRecap, paddChar);
    myRecap.push(recapLine);
    recapTxt = recapTxt + recapLine + '<br>';


    refDate = new Date(Date.parse(dataPaymentForUserJsonArray[i].REF_DEADLINE.toString()));
    recapLine = ('À payer avant le :' + formatterDateFR.format(refDate)).padStart(maxLgRecap, paddChar);
    myRecap.push(recapLine);
    recapTxt = recapTxt + recapLine + '<br>';


    recapLine = '';
    notifRetard = '';
    if(dataPaymentForUserJsonArray[i].UP_STATUS.toString() == 'N'){
      statusPay = 'Non payé';
      if(dataPaymentForUserJsonArray[i].NEGATIVE_IS_LATE < 0){
          notifRetard = 'PAIEMENT EN RETARD !!!';
          recapLine = notifRetard.padStart(maxLgRecap, paddChar);
          notifRetard = '<i class="late-notif">' + notifRetard + '</i>';
      }
      else{
          notifRetard = 'EN ATTENTE DE PAIEMENT';
          recapLine = notifRetard.padStart(maxLgRecap, paddChar);
      }
      myRecap.push(recapLine);
    }
    else if(dataPaymentForUserJsonArray[i].UP_STATUS.toString() == 'P'){
      statusPay = 'Payé';
    }
    else{
      statusPay = 'Complété';
    }

    refRecAmount = (('Tranche :' + renderAmount(dataPaymentForUserJsonArray[i].REF_AMOUNT.toString())) + '/' + (statusPay)).padStart(maxLgRecap, paddChar);
    myRecap.push(refRecAmount);
    recapTxt = recapTxt + refRecAmount + '<br>' + notifRetard + '<br>';
    typeOfPayment = '';
    if(dataPaymentForUserJsonArray[i].UP_TYPE_OF_PAYMENT == 'H'){
        typeOfPayment = '/CHEQ';
    }
    else if(dataPaymentForUserJsonArray[i].UP_TYPE_OF_PAYMENT == 'C'){
        typeOfPayment = '/CASH';
    }
    else if(dataPaymentForUserJsonArray[i].UP_TYPE_OF_PAYMENT == 'T'){
        typeOfPayment = '/VIRTPE';
    }
    else if(dataPaymentForUserJsonArray[i].UP_TYPE_OF_PAYMENT == 'M'){
        typeOfPayment = '/MVOLA';
    }
    else{
        //Do nothing
    }
    recAmount = (('Paiement' + typeOfPayment + ' :' + renderAmount(dataPaymentForUserJsonArray[i].UP_INPUT_AMOUNT.toString()))).padStart(maxLgRecap, paddChar);
    myRecap.push(recAmount);

    recapTxt = recapTxt + recAmount + '<br>';
    recapTxt = recapTxt + separatorRecap + '<br>';
  }
  $('#pay-recap-tra').html(recapTxt);
}


function updateTicketType(type){
  ticketType =  type;
  $('#sh-ticketref').html(ticketRef + type);
}

/***********************************************************************************************************/

$(document).ready(function() {
    console.log('We are in ACE-COM');
  
    if(($('#mg-graph-identifier').text() == 'add-pay') || ($('#mg-graph-identifier').text() == 'add-paydoc')){
      // Do something
      $( "#addpay-ace" ).keyup(function() {
        verityAddComContentScan();
      });
  
      // Right ticket
      logInAddPay('');
  
    }
    else if($('#mg-graph-identifier').text() == 'ref-pay'){
      // Do something
      loadRefPayGrid();
    }
    else if($('#mg-graph-identifier').text() == 'xxx'){
      // Do something
    }
    else{
      //Do nothing
    }
  
  
  
  });
  