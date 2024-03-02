function generateFaciliteDBAndPrint(){
  let tempTicketRef = ticketRef + ticketType;


  $.ajax('/generatefaciliteDB', {
      type: 'POST',  // http method
      data: {
        currentAgentIdStr: CURRENT_AGENT_ID_STR,
        foundUserId: foundUserId,
        ticketRef: tempTicketRef,
        redPc: redPc,
        ticketType: ticketType,
        invFscId: invFscId,
        token : getToken
      },  // data to submit
      success: function (data, status, xhr) {
          //We have to locally create the reduction in case of re-scan 
          //let iMyReduction = data['param_user_id'];
          let myReduction = {
            USERNAME: dataAllUSRNToJsonArray[foundiInJson].USERNAME,
            UFP_STATUS: 'I',
            TICKET_REF: tempTicketRef
          };
          dataAllREDUCToJsonArray.push(myReduction);

          dataAllUSRNToJsonArray[foundiInJson].EXISTING_FACILITE = (dataAllUSRNToJsonArray[foundiInJson].EXISTING_FACILITE == null) ? (ticketType + redPc) : (dataAllUSRNToJsonArray[foundiInJson].EXISTING_FACILITE + ',' + ticketType + redPc);
          printReceiptPDF(tempTicketRef);
          

      },
      error: function (jqXhr, textStatus, errorMessage) {
        $('#msg-alert').html("ERR782:" + tempTicketRef + " vérifiez que cet étudiant ne bénéficie pas déjà d'une facilité sinon contactez le support. ");
        $('#type-alert').removeClass('alert-primary').addClass('alert-danger');
        $('#ace-alert-msg').show(100);
        addPayClear();
      }
  });
}

function generateCertificatScoDBAndPrint(){
  let tempTicketRef = ticketRef + ticketType;


  $.ajax('/generateCertificatScoDB', {
      type: 'POST',  // http method
      data: {
        currentAgentIdStr: CURRENT_AGENT_ID_STR,
        foundUserId: foundUserId,
        invTypeOfPayment: invTypeOfPayment,
        ticketRef: tempTicketRef,
        token: getToken
      },  // data to submit
      success: function (data, status, xhr) {
          dataAllUSRNToJsonArray[foundiInJson].EXISTING_FACILITE = (dataAllUSRNToJsonArray[foundiInJson].EXISTING_FACILITE == null) ? (ticketType + redPc) : (dataAllUSRNToJsonArray[foundiInJson].EXISTING_FACILITE + ',' + ticketType + redPc);
          printReceiptPDF(tempTicketRef);
          //We have to locally create the reduction in case of re-scan

      },
      error: function (jqXhr, textStatus, errorMessage) {
        $('#msg-alert').html("ERR792:" + tempTicketRef + " erreur certificat de scolarité, contactez le support. ");
        $('#type-alert').removeClass('alert-primary').addClass('alert-danger');
        $('#ace-alert-msg').show(100);
        addPayClear();
      }
  });
}

function generateOpeMultiDBAndPrint(param){
  let tempTicketRef = ticketRef + ticketType;


  $.ajax('/generateOpeMultiDB', {
      type: 'POST',  // http method
      data: {
        currentAgentIdStr: CURRENT_AGENT_ID_STR,
        foundUserId: foundUserId,
        invTypeOfPayment: invTypeOfPayment,
        ticketRef: tempTicketRef,
        token: getToken,
        typeOfOperation: param
      },  // data to submit
      success: function (data, status, xhr) {
          dataAllUSRNToJsonArray[foundiInJson].EXISTING_FACILITE = (dataAllUSRNToJsonArray[foundiInJson].EXISTING_FACILITE == null) ? (ticketType + redPc) : (dataAllUSRNToJsonArray[foundiInJson].EXISTING_FACILITE + ',' + ticketType + redPc);
          printReceiptPDF(tempTicketRef);
          //We have to locally create the reduction in case of re-scan

      },
      error: function (jqXhr, textStatus, errorMessage) {
        $('#msg-alert').html("ERR792:" + tempTicketRef + " erreur operation, contactez le support. ");
        $('#type-alert').removeClass('alert-primary').addClass('alert-danger');
        $('#ace-alert-msg').show(100);
        addPayClear();
      }
  });
}
function generateValidateRedDBAndPrint(){

  $.ajax('/generateValidateRedDB', {
      type: 'POST',  // http method
      data: {
        currentAgentIdStr: CURRENT_AGENT_ID_STR,
        foundUserId: foundUserId,
        ticketRef: ticketRefToValidate,
        token: getToken
      },  // data to submit
      success: function (data, status, xhr) {
          
          // **********************************************************************
          let tempTicketAjaxValid = data['paramTicketRef'];
          // We need to delete it locally else we need to reload
          let validateUsername = '';
          for(let j=0; j<dataAllREDUCToJsonArray.length; j++){
            if(dataAllREDUCToJsonArray[j].TICKET_REF == tempTicketAjaxValid){
              validateUsername = dataAllREDUCToJsonArray[j].USERNAME;
              dataAllREDUCToJsonArray.splice(j, 1);
            }
          } // end of j loop
          let myReduction = {
            USERNAME: validateUsername,
            UFP_STATUS: 'A',
            TICKET_REF: tempTicketAjaxValid
          };
          dataAllREDUCToJsonArray.push(myReduction);
          // **********************************************************************

          dataAllUSRNToJsonArray[foundiInJson].EXISTING_FACILITE = (dataAllUSRNToJsonArray[foundiInJson].EXISTING_FACILITE == null) ? (ticketType + redPc) : (dataAllUSRNToJsonArray[foundiInJson].EXISTING_FACILITE + ',' + ticketType + redPc);
          printReceiptPDF(ticketRefToValidate);
          //We have to locally create the reduction in case of re-scan

      },
      error: function (jqXhr, textStatus, errorMessage) {
        $('#msg-alert').html("ERR712:" + ticketRefToValidate + " vérifiez que cet étudiant ne bénéficie pas déjà d'une facilité sinon contactez le support. ");
        $('#type-alert').removeClass('alert-primary').addClass('alert-danger');
        $('#ace-alert-msg').show(100);
        addPayClear();
      }
  });
}
function generatePayDBAndPrint(){
  let tempTicketRef = ticketRef + ticketType;

  let arrayOperationToPass = payUniLeftOperationForUserJsonArray;
  if(parseInt(invShortCutDiscountId) > 0){
    arrayOperationToPass = payShortCutOperationForUserJsonArray;
  }


  $.ajax('/generatepaymentDB', {
      type: 'POST',  // http method
      data: {
        currentAgentIdStr: CURRENT_AGENT_ID_STR,
        foundUserId: foundUserId,
        ticketRef: tempTicketRef,
        invAmountToPay: invAmountToPay,
        invFscId: invFscId,
        // If this is used then we are doing a shortcut
        invShortCutDiscountId: invShortCutDiscountId,
        invTypeOfPayment: invTypeOfPayment,
        invComment: invComment,
        payMultiOperationForUserJsonArray: JSON.stringify(arrayOperationToPass),
        token: getToken
      },  // data to submit
      success: function (data, status, xhr) {
          //dataAllUSRNToJsonArray[foundiInJson].EXISTING_FACILITE = (dataAllUSRNToJsonArray[foundiInJson].EXISTING_FACILITE == null) ? (ticketType + redPc) : (dataAllUSRNToJsonArray[foundiInJson].EXISTING_FACILITE + ',' + ticketType + redPc);
          printReceiptPDF(tempTicketRef);
      },
      error: function (jqXhr, textStatus, errorMessage) {
        $('#msg-alert').html("ERR785:" + tempTicketRef + " enregistrement du paiement impossible, contactez le support. ");
        $('#type-alert').removeClass('alert-primary').addClass('alert-danger');
        $('#ace-alert-msg').show(100);
        addPayClear();
      }
  });
}

function generateDeleteRedDBAndPrint(){

  $.ajax('/generateDeleteRedDB', {
      type: 'POST',  // http method
      data: {
        ticketRef: ticketRefToDelete,
        token: getToken
      },  // data to submit
      success: function (data, status, xhr) {
          // We need to delete it locally else we need to reload
          let deleteUsername = '';
          for(let j=0; j<dataAllREDUCToJsonArray.length; j++){
            //console.log(dataAllREDUCToJsonArray[j].TICKET_REF + ' vs ' + tempTicketAjaxDelete);
            if(dataAllREDUCToJsonArray[j].TICKET_REF == tempTicketAjaxDelete){
              //console.log('I read: ' + dataAllREDUCToJsonArray[j].USERNAME);
              deleteUsername = dataAllREDUCToJsonArray[j].USERNAME;
              dataAllREDUCToJsonArray.splice(j, 1);
            }
          } // end of j loop
          let myReduction = {
            USERNAME: deleteUsername,
            UFP_STATUS: 'D',
            TICKET_REF: tempTicketAjaxDelete
          };
          dataAllREDUCToJsonArray.push(myReduction);
          //dataAllUSRNToJsonArray[foundiInJson].EXISTING_FACILITE = (dataAllUSRNToJsonArray[foundiInJson].EXISTING_FACILITE == null) ? (ticketType + redPc) : (dataAllUSRNToJsonArray[foundiInJson].EXISTING_FACILITE + ',' + ticketType + redPc);
          let tempTicketAjaxDelete = data['paramTicketRef'];
          printReceiptPDF(tempTicketAjaxDelete);
      },
      error: function (jqXhr, textStatus, errorMessage) {
        $('#msg-alert').html("ERR789:" + ticketRefToDelete + " suppression du ticket impossible, contactez le support. ");
        $('#type-alert').removeClass('alert-primary').addClass('alert-danger');
        $('#ace-alert-msg').show(100);
        addPayClear();
      }
  });
}


function getPaymentDetailsDB(param){

  $.ajax('/getPaymentDetailsDB', {
      type: 'POST',  // http method
      data: {
        ticketRef: ticketRefPayment,
        paramDetails: param,
        token: getToken
      },  // data to submit
      success: function (data, status, xhr) {
          let dataPaymentDetailsArray = data['result'].slice();
          if(dataPaymentDetailsArray.length > 0){
                // We need to check how many payment are involved
                // It can be several
                $("#exist-code-read").html('Y');
                $('#addpay-ace').hide(100);
                let j = 1;
                //logInAddPay
                logInAddPay('username:'+dataPaymentDetailsArray[0].VSH_USERNAME);
                logInAddPay(dataPaymentDetailsArray[0].MATRICULE);
                logInAddPay(dataPaymentDetailsArray[0].FIRSTNAME + ' ' + dataPaymentDetailsArray[0].LASTNAME);
                logInAddPay(dataPaymentDetailsArray[0].SHORTCLASS);

                for(let i=0; i<dataPaymentDetailsArray.length; i++){
                  //logInAddPay
                  logInAddPay(ticketRefPayment + '/' + j);
                  logInAddPay(dataPaymentDetailsArray[i].REF_CODE);
                  logInAddPay(renderAmount(dataPaymentDetailsArray[i].UP_INPUT_AMOUNT));
                  j = j+1;
                }
                $('#pay-recap').hide(100);
                $("#btn-clear-addpay").prop("disabled", false);
                $("#addp-canpay").show(300);
          }
          else{
            $('#msg-alert').html("ERR799:" + ticketRefPayment + " le paiement est introuvable, vérifiez-le et si besoin contactez le support. ");
            $('#type-alert').removeClass('alert-primary').addClass('alert-danger');
            $('#ace-alert-msg').show(100);
            addPayClear();
          }
      },
      error: function (jqXhr, textStatus, errorMessage) {
        $('#msg-alert').html("ERR787:" + ticketRefPayment + " récupération du paiement impossible, contactez le support. ");
        $('#type-alert').removeClass('alert-primary').addClass('alert-danger');
        $('#ace-alert-msg').show(100);
        addPayClear();
      }
  });
}

function generateCancelPaymentDBAndPrint(){

  $.ajax('/generateCancelPaymentDB', {
      type: 'POST',  // http method
      data: {
        currentAgentIdStr: CURRENT_AGENT_ID_STR,
        ticketRef: ticketRefPayment,
        token: getToken
      },  // data to submit
      success: function (data, status, xhr) {
          //xxx
          let tempTicketAjaxCancelPayment = data['paramTicketRef'];
          printReceiptPDF(tempTicketAjaxCancelPayment);
          $('#msg-alert').html(tempTicketAjaxCancelPayment + " a été annulé avec succés.");
          $('#type-alert').addClass('alert-primary').removeClass('alert-danger');
          $('#ace-alert-msg').show(100);
      },
      error: function (jqXhr, textStatus, errorMessage) {
        $('#msg-alert').html("ERR780:" + ticketRefPayment + " annulation du paiement impossible, contactez le support. ");
        $('#type-alert').removeClass('alert-primary').addClass('alert-danger');
        $('#ace-alert-msg').show(100);
        addPayClear();
      }
  });
}


function generateHistoryPrint(){
  /**************** HISTORY *****************/
  let doc = new jsPDF('p', 'mm', [(55 + (myRecap.length * 7)), 75]);
  doc.setFont("Courier");
  doc.setFontType("bold");

  doc.setTextColor(0, 0, 0);
  doc.addImage(document.getElementById('logo-carte'), //img src
                'PNG', //format
                11, //x oddOffsetX is to define if position 1 or 2
                0, //y
                50, //Width
                16, null, 'FAST'); //Height // Fast is to get less big files


  doc.setFontSize(7);
  doc.setFontType("normal");
  //doc.text(18, 25, "REDUCTION 50%");
  let margTop = 22;
  let contentHeight = 0;
  doc.setFontSize(8);
  // Print Ticket Identification Information but to 5 lines only
  // Test comment
  for(var i=0; i< 5; i++){
    contentHeight = margTop + (i*5);
    if(i>0){
      doc.text(maxPadLeft, contentHeight, myTicket[i].substring(0, (maxLgTicket - maxPrintTicket)));
    }
    else{
      doc.text(maxPadLeft, contentHeight, myTicket[i].substring(maxPrintTicket));
    }
  }

  doc.setFontSize(8);
  margTop = margTop + (7*5);
  for(var i=0; i<myRecap.length; i++){
    contentHeight = margTop + (i*5);
    doc.text(maxPadLeft, contentHeight, myRecap[i]);
  }

  contentHeight = contentHeight + 20;
  doc.setFontSize(5);
  let filename = 'HIS_' + foundUserName + '_' + ticketRefFile;
  doc.text(5, contentHeight, "HIS_Fich_" + filename + "_HISTORIQUE");

  doc.save(filename);

}

function validateAmountMIN(parAmount){
  const re = /^\d+$/;
  return re.test(parAmount);
}

function verifyManualAmount(){
  let isValidMIN = false;

  if ($('#addman-amo').val().length > 3){
    
    if($('#addman-amo').val().endsWith('00')){
      if(validateAmountMIN($('#addman-amo').val())){
        // I have a valid amount here
        let tempAmount = parseInt($('#addman-amo').val());
        if(tempAmount > MIN_AMOUNT){
          if(tempAmount <= maxManualAmount){
            //console.log('read input: ' + $('#addman-amo').val());
            isValidMIN = true;
          }
        }
      }
    }
  }

  if(isValidMIN){
    $("#btn-part-man-subm").removeClass('deactive-btn');
    $("#id-amo-note").html(renderAmount($('#addman-amo').val()));
    invAmountToPay = $('#addman-amo').val();
  }
  else{
    $("#btn-part-man-subm").addClass('deactive-btn');
    $("#id-amo-note").html(INVALID_AMOUNT + ' min.' + MIN_AMOUNT + ' AR - max.' + renderAmount(maxManualAmount));
    invAmountToPay = 0;
  }
}

function setPartButtonsAndListener(isCommitmentLetter){
  let invRefLineTranche = 1;
  let invCodeTranche = 'XXX';
  let invRefCodeTrancheAmount = 0;

  let invTotalCodeTrancheAmount = 0;
  //We need to consider that tranche initial (as previous) is closed
  let trancheStillOpen = 'N';
  let blockNextTranche = 'N';
  let lblCommitmentLetter = '';
  
  let sumPerTrancheStillOpen = 'Y';
  for(let i=0; i<dataSumPerTranche.length; i++){
      if((parseInt(dataSumPerTranche[i].REST_TO_PAY) > 0) && (sumPerTrancheStillOpen == 'Y')){
        // First time we open the line
        // By default they are closed
        $('#btn-part-' + invRefLineTranche + '-3').removeClass('deactive-btn');
        // And we set here the maximum manual amount
        maxManualAmount = parseInt(dataSumPerTranche[i].REST_TO_PAY);
        invFscId = dataSumPerTranche[i].REF_ID;
        if(isCommitmentLetter == 'Y'){
          lblCommitmentLetter = "<br><br>LETTRE D'ENGAGEMENT<br>";
        }
        sumPerTrancheStillOpen = 'N';
      }
      else{
        lblCommitmentLetter = '';
      }

      $('#id-part-' + invRefLineTranche +  '-3').html(renderAmount(dataSumPerTranche[i].REST_TO_PAY.toString()));
      $('#id-rawpayamt-' + invRefLineTranche +  '-3').html(dataSumPerTranche[i].REST_TO_PAY.toString());
      $('#id-fscid-' + invRefLineTranche +  '-3').html(dataSumPerTranche[i].REF_ID.toString());
      // Hanlde late
      if((dataSumPerTranche[i].NEGATIVE_IS_LATE < 0) && (parseInt(dataSumPerTranche[i].REST_TO_PAY) > 0)){
        $('#btn-part-' + invRefLineTranche + '-3').removeClass('pay-opt-btn-t-a');
        $('#btn-part-' + invRefLineTranche + '-3').addClass('pay-opt-btn-t-late');
        $('#lbl-part-' + invRefLineTranche +  '-3').html(invRefLineTranche + LATE_FLATICON + lblCommitmentLetter);
      }
      else{
        $('#lbl-part-' + invRefLineTranche +  '-3').html(invRefLineTranche + lblCommitmentLetter);
      }
      invRefLineTranche = invRefLineTranche + 1;
  }

  

  for(let k=1; k<4; k++){
      // Add listener
      $("#btn-part-" + k + "-3").off('click');
      $( "#btn-part-" + k + "-3" ).click(function() {
        invFscId = parseInt($('#id-fscid-' + k +  '-3').html());
        //console.log('You click on: ' + k + '/' + invAmountToPay);
        if(isCommitmentLetter == 'Y'){
          invAmountToPay = 0;
          logInAddPay('TRANCHE*' + k);

          $("#addp-pay-part").hide(100);
          $("#addp-print").show(300);
        }
        else{
          invAmountToPay = parseInt($('#id-rawpayamt-' + k +  '-3').html());
          logInAddPay(renderAmount(invAmountToPay));

          $("#addp-pay-part").hide(100);
          $("#addp-type-pay").show(300);
        }
      });
  }

}

function setCommitmentLetterAndListener(){
  setPartButtonsAndListener('Y');
  $('#btn-part-man').hide(100);
  $('#btn-part-man-subm').hide(100);
}


function setUniButtonsAndListener(){
  let invRefLineUnique = 1;
  let totalUniLeftPay = 0;
  let atLeastOneFraisFixeIsOpen = 0;

  let buttonList = new Array();

  let areAllDroitsShortCutAvailable = 'Y';

  


  for(let i=0; i<dataPaymentForUserJsonArray.length; i++){
    if(dataPaymentForUserJsonArray[i].REF_TYPE.toString() == 'U'){


      if(!(buttonList.includes(dataPaymentForUserJsonArray[i].REF_ID))){
          buttonList.push(dataPaymentForUserJsonArray[i].REF_ID);
          //Check first if we handling a new Tranche
          // We have a new tranche code we need to handle it
          // Set the data
          invCodeTranche = dataPaymentForUserJsonArray[i].REF_CODE;
    
          // We are on a Unique
          $('#id-uni-' + invRefLineUnique).html(renderAmount(dataPaymentForUserJsonArray[i].REF_AMOUNT.toString()));
          $('#id-fscuni-' + invRefLineUnique).html(dataPaymentForUserJsonArray[i].REF_ID.toString());
    
          // Hanlde late
          if((dataPaymentForUserJsonArray[i].UP_STATUS ==  'N') &&
                (dataPaymentForUserJsonArray[i].NEGATIVE_IS_LATE < 0)){
            $('#btn-uni-' + invRefLineUnique).removeClass('pay-opt-btn-t-a');
            $('#btn-uni-' + invRefLineUnique).addClass('pay-opt-btn-t-late');
            $('#lbl-uni-' + invRefLineUnique).html(dataPaymentForUserJsonArray[i].REF_TITLE + LATE_FLATICON);
          }
          else{
            $('#lbl-uni-' + invRefLineUnique).html(dataPaymentForUserJsonArray[i].REF_TITLE);
          }
          
          if(dataPaymentForUserJsonArray[i].UP_STATUS ==  'N'){
            $( "#btn-uni-" + invRefLineUnique).removeClass('deactive-btn');
            $('#id-rawuniamt-' + invRefLineUnique).html(dataPaymentForUserJsonArray[i].REF_AMOUNT.toString());
            totalUniLeftPay = totalUniLeftPay + parseInt(dataPaymentForUserJsonArray[i].REF_AMOUNT.toString());
            atLeastOneFraisFixeIsOpen = atLeastOneFraisFixeIsOpen + 1;
    
            let myUniPayment = {
              fscId: dataPaymentForUserJsonArray[i].REF_ID.toString(),
              typeOfPayment: 'Z',
              inputAmount: dataPaymentForUserJsonArray[i].REF_AMOUNT.toString()
              };
            payUniLeftOperationForUserJsonArray.push(myUniPayment);
          }
          else{
    
            // It has been paid
            
            $('#id-rawuniamt-' + invRefLineUnique).html('0');
            $('#lbl-uni-' + invRefLineUnique).html(dataPaymentForUserJsonArray[i].REF_TITLE);
            $( "#btn-uni-" + invRefLineUnique).addClass('deactive-btn');
            console.log('It has been paid ' + invRefLineUnique);
            // *************************************************************************************
            // *************************************************************************************
            // *************************************************************************************
            // *********** Specific hardcode because of shortcut droits
            // *************************************************************************************
            // *************************************************************************************
            // *************************************************************************************
            // We are on the first line up droit
            // We are Droit test entretien ou inscription
            if((invRefLineUnique == 1) 
                || (invRefLineUnique == 2)){
                  areAllDroitsShortCutAvailable = 'N';
            }
            // *************************************************************************************
          }
          invRefLineUnique = invRefLineUnique + 1;

      }
      else{
        // We need to check if included in the Button list already or not
        // The issue is for discount case we have the ref id with Exemption and the same with cash
        // If not exist we display it

      }
    }
    else{
      //Do nothing
      //We are not on a Unique
      //We are on a Tranche Payment
    }
    
    // Handle the button totalite
    $("#id-uni-left").html(renderAmount(totalUniLeftPay.toString()));


  }

  console.log("buttonList length: " + buttonList.length);
  console.log(buttonList);

  // *************************************************************************************
  // *************************************************************************************
  // *************************************************************************************
  // *********** Specific hardcode because of shortcut droits
  // *************************************************************************************
  // *************************************************************************************
  // *************************************************************************************
  // We are on the first line up droit
  // We are Droit test entretien ou inscription
  if(areAllDroitsShortCutAvailable == 'Y'){
    $('.drt-shortcut').removeClass('deactive-btn');
  }
  else{
    $('.drt-shortcut').addClass('deactive-btn');
  }
  // *************************************************************************************

  for(let k=1; k<4; k++){
      // Add listener
      $("#btn-uni-" + k).off('click');
      $( "#btn-uni-" + k).click(function() {
        invAmountToPay = parseInt($('#id-rawuniamt-' + k).html());
        invFscId = parseInt($('#id-fscuni-' + k).html());
        //console.log('You click on: ' + k + '/' + invAmountToPay);

        logInAddPay(renderAmount(invAmountToPay));
        $("#addp-pay-uni").hide(100);
        $("#addp-type-pay").show(300);
      });
  }

  for(let m=1; m<4; m++){
    // Add listener
    $("#btn-case-" + m).off('click');
    $( "#btn-case-" + m).click(function() {

        // Do specific operation of DROIT HERE
        /*
        invAmountToPay = parseInt($('#id-rawuniamt-' + k).html());
        invFscId = parseInt($('#id-fscuni-' + k).html());
        //console.log('You click on: ' + k + '/' + invAmountToPay);

        logInAddPay(renderAmount(invAmountToPay));
        */
        // Get inspiration from pay the rest ! option left !
        // We go for a discount cases
        invFscId = 0;
        invShortCutDiscountId = m;
        if(m == 1){
          // Nouveau
          // 200 000AR
          logInAddPay('Droit NOUVEAU');
          logInAddPay(renderAmount(dataAllDispDiscountToJsonArray[0].GENUINE_AMOUNT));

          let myPaymentDTSTENT = {
            fscId: dataAllSetUpDiscountToJsonArray[0].FSC_ID.toString(),
            // This will display the fsc id 1
            typeOfPayment: 'Z',
            inputAmount: dataAllSetUpDiscountToJsonArray[0].REF_AMOUNT.toString()
          };
          payShortCutOperationForUserJsonArray.push(myPaymentDTSTENT);

          let myPaymentDRTINSC = {
            fscId: dataAllSetUpDiscountToJsonArray[1].FSC_ID.toString(),
            // This will display the fsc id 2
            typeOfPayment: 'Z',
            inputAmount: dataAllSetUpDiscountToJsonArray[1].REF_AMOUNT.toString()
          };
          payShortCutOperationForUserJsonArray.push(myPaymentDRTINSC);


        }
        else if(m == 2){
          // Ancien
          // 100 000AR
          logInAddPay('Droit ANCIEN avec exemption');
          logInAddPay(renderAmount(dataAllDispDiscountToJsonArray[0].FINAL_AMOUNT));



          let myPaymentExemptDTSTENT = {
            fscId: dataAllSetUpDiscountToJsonArray[0].FSC_ID.toString(),
            // This will display the fsc id 1
            typeOfPayment: 'E',
            inputAmount: dataAllSetUpDiscountToJsonArray[0].DIS_AMOUNT.toString()
          };
          payShortCutOperationForUserJsonArray.push(myPaymentExemptDTSTENT);

          let myPaymentExemptDRTINSC = {
            fscId: dataAllSetUpDiscountToJsonArray[1].FSC_ID.toString(),
            // This will display the fsc id 2
            typeOfPayment: 'E',
            inputAmount: dataAllSetUpDiscountToJsonArray[1].DIS_AMOUNT.toString()
          };
          payShortCutOperationForUserJsonArray.push(myPaymentExemptDRTINSC);

          let myPaymentDRTINSC = {
            fscId: dataAllSetUpDiscountToJsonArray[1].FSC_ID.toString(),
            // This will display the fsc id 2
            typeOfPayment: 'Z',
            inputAmount: dataAllSetUpDiscountToJsonArray[1].FINAL_AMOUNT.toString()
          };
          payShortCutOperationForUserJsonArray.push(myPaymentDRTINSC);

        }
        else{
          //m == 3
          // Transfert
          // 150 000AR
          logInAddPay('Droit TRANSFERT avec exemption');
          logInAddPay(renderAmount(dataAllDispDiscountToJsonArray[1].FINAL_AMOUNT));

          let myPaymentExemptDTSTENT = {
            fscId: dataAllSetUpDiscountToJsonArray[2].FSC_ID.toString(),
            // This will display the fsc id 1
            typeOfPayment: 'E',
            inputAmount: dataAllSetUpDiscountToJsonArray[2].DIS_AMOUNT.toString()
          };
          payShortCutOperationForUserJsonArray.push(myPaymentExemptDTSTENT);

          let myPaymentDRTINSC = {
            fscId: dataAllSetUpDiscountToJsonArray[3].FSC_ID.toString(),
            // This will display the fsc id 2
            typeOfPayment: 'Z',
            inputAmount: dataAllSetUpDiscountToJsonArray[3].FINAL_AMOUNT.toString()
          };
          payShortCutOperationForUserJsonArray.push(myPaymentDRTINSC);

        }
        $("#btn-type-e").addClass('deactive-btn');
        $("#addp-pay-uni").hide(100);
        $("#addp-type-pay").show(300);
    });

  }

  //If the left is more than one then we open the button
  if(atLeastOneFraisFixeIsOpen > 1){
    $("#btn-uni-left").removeClass('deactive-btn');
  }
  $("#btn-uni-left").off('click');
  $("#btn-uni-left").click(function() {
    // All payment will be managed in payUniLeftOperationForUserJsonArray
    invAmountToPay = 0;
    invFscId = 0;
    logInAddPay('Total restant');
    logInAddPay(renderAmount(totalUniLeftPay));
    $("#addp-pay-uni").hide(100);
    $("#addp-type-pay").show(300);
  });

}

function manageCommentPay(){
  let readInputText = removeAllQuotes($("#pay-com").val());
  //console.log('in verifyTextAreaSaveBtn: ' + readInputText);
  let textInputLength = readInputText.length;
  $("#paycom-length").html((MAX_COMENT_LIMIT-textInputLength) < 0 ? 0 : (MAX_COMENT_LIMIT-textInputLength));

  if(textInputLength > MAX_COMENT_LIMIT){
    $("#pay-com").val(readInputText.substring(0, MAX_COMENT_LIMIT));
  }
  else{
    $("#pay-com").val(readInputText);
  }
}


/***********************************************************************************************************/

$(document).ready(function() {
  console.log('We are in ACE-PAY');

  if($('#mg-graph-identifier').text() == 'add-pay'){
    // Do something
      // Initialisation
      $("#id-amo-note").html(INVALID_AMOUNT);

      // Initialise discount
      displayDiscount();

      /** START : Specific to add pay */
      $( "#btn-clear-addpay" ).click(function() {
  
        $('#type-alert').addClass('alert-primary').removeClass('alert-danger');
        $('#ace-alert-msg').hide(100);
        addPayClear();
      });

      // Handle here all type of payment
      for(let i=0; i<TYPE_OF_PAYMENT_CODE_ARRAY.length; i++){
          $("#btn-type-" + TYPE_OF_PAYMENT_CODE_ARRAY[i]).click(function() {
            // Handle comment first
            if(($('#pay-com').val() !== null) && ($('#pay-com').val().trim().length > 0)){
              invComment = $('#pay-com').val().trim();
              logInAddPay('c:' + invComment);
            }
            else{
              invComment = '';
            }

            invTypeOfPayment = TYPE_OF_PAYMENT_CODE_ARRAY[i].toString().toUpperCase();
            logInAddPay('*** ' + TYPE_OF_PAYMENT_LBL_ARRAY[i] + ' ***');
            $("#addp-type-pay").hide(100);
            $("#addp-print").show(300);
          });
    
      }


      // STAIRS 1 **********************************************************************************************************************************
      // Generate a cut
      $( "#btn-addcut" ).click(function() {
        //console.log("You click on #btn-addcut");
        invOperation = 'R';
        $('#sh-ticketref').html(ticketRef + ticketType);
        // We do not do updateTicketType('R') here because we may use the Letter of commitment
  
  
        logInAddPay('Opération Facilité de paiement');
        $("#addp-mainop").hide(100);
        $("#addp-red-option").show(300);
      });
      // Add a payment part
      $( "#btn-addpay" ).click(function() {
        //console.log("You click on #btn-addpay");
        invOperation = 'P';
        logInAddPay('Opération PAIEMENT Tranche');
  
        updateTicketType('P');

        // Manual payment management
        // Reset first
        $("#id-amo-note").html(INVALID_AMOUNT);
        $('#addman-amo').val('');
        $("#btn-part-man-subm").off('click');
        

        $("#btn-part-man-subm").click(function() {
          invAmountToPay = parseInt($('#addman-amo').val());
          // No need to set up invFscId as it is done at the load
          console.log('You click on manual input: ' + invFscId + '/' + invAmountToPay);

          logInAddPay(renderAmount(invAmountToPay));
          $("#addp-pay-part").hide(100);
          $("#addp-type-pay").show(300);
        });
        $("#btn-part-man-subm").addClass('deactive-btn');
  
        $("#addp-mainop").hide(100);
        $("#addp-pay-part").show(300);

        // Load payment options
        setPartButtonsAndListener('N');

        // Add the listener on the amount
        $( "#addman-amo" ).keyup(function() {
          verifyManualAmount();
        });

      });

      // Add a payment unique
      $( "#btn-adduni" ).click(function() {
        //console.log("You click on #btn-adduni");
        invOperation = 'P';
        logInAddPay('Opération PAIEMENT Frais Fixe');
  
        updateTicketType('P');
  
        $("#addp-mainop").hide(100);
        $("#addp-pay-uni").show(300);

        // Load payment options
        setUniButtonsAndListener();
      });

      // CREATE THE LETTEROF COMMITMENT
      // Create the LOC
      $( "#btn-addcut-com" ).click(function() {
        //console.log("You click on #btn-addcut-com");
        invOperation = 'L';
        updateTicketType('L');
        logInAddPay('*** LETTRE ENGAGEMENT ***');
        logInAddPay('Délai maximum : ' + LIMIT_LE_DAYS + ' jours');
        logInAddPay(msgFooterLOC);
  
        $("#addp-mainop").hide(100);
        /** Do commitmen letter opertion */
        setCommitmentLetterAndListener();
        $("#addp-pay-part").show(300);
  
      });

      // CREATE CERTIFICAT SCOLARITE
      // Create the LOC
      $( "#btn-cert-sco" ).click(function() {
        //console.log("#btn-cert-sco");
        invOperation = 'S';
        updateTicketType('S');
        //Reset the ticket
        logInAddPay('***');
        logInAddPay('***');
        logInAddPay('***');
        logInAddPay('*** CERTIFICAT DE SCOLARITE ***');
        logInAddPay('Nous,');
        logInAddPay('Université ACEEM Manakambahiny');
        logInAddPay('certifions que Mme/Mlle/M.');
        logInAddPay(foundName);
        logInAddPay('est régulièrement');
        logInAddPay('inscrit(e) en classe de');
        logInAddPay(foundClasse);
        logInAddPay('à date du ' + lblDate);
        logInAddPay("et ce jusqu'à");
        logInAddPay("la fin de l'année en cours.");
        logInAddPay(MSG_FOOTER_CSCO);
        logInAddPay(renderAmount(getAllOPEAmount('CERTSCO')));
  
        $("#addp-mainop").hide(100);
        $("#addp-type-pay").show(300);
  
      });

      // CREATE CERTIFICATION
      $( "#btn-cert-cer" ).click(function() {
        //console.log("#btn-cert-sco");
        invOperation = 'T';
        updateTicketType('T');
        //Reset the ticket
        logInAddPay('***');
        logInAddPay('***');
        logInAddPay('*** CERTIFICATION DOCUMENT ***');
        logInAddPay(renderAmount(getAllOPEAmount('CERTIFC')));
        logInAddPay('***');
        logInAddPay('***');

        $("#addp-mainop").hide(100);
        $("#addp-type-pay").show(300);
  
      });

      // CARTE D ETUDIANT
      $( "#btn-cart-etu" ).click(function() {
        //console.log("#btn-cert-sco");
        invOperation = 'A';
        updateTicketType('A');
        //Reset the ticket
        logInAddPay('***');
        logInAddPay('***');
        logInAddPay('*** CARTE ETUDIANT ***');
        logInAddPay(renderAmount(getAllOPEAmount('CARTEET')));
        logInAddPay('***');
        logInAddPay('***');
  
        $("#addp-mainop").hide(100);
        $("#addp-type-pay").show(300);
  
      });

      // CHANGEMENT DE FILIÈRE
      $( "#btn-chg-fil" ).click(function() {
        //console.log("#btn-cert-sco");
        invOperation = 'Y';
        updateTicketType('Y');
        //Reset the ticket
        logInAddPay('***');
        logInAddPay('***');
        logInAddPay('*** CHANGEMENT FILIERE ***');
        logInAddPay(renderAmount(getAllOPEAmount('CHGFILL')));
        logInAddPay('***');
        logInAddPay('***');
  
        $("#addp-mainop").hide(100);
        $("#addp-type-pay").show(300);
  
      });
  
      // STAIRS 2 **********************************************************************************************************************************
      // Reduction button
      $( "#btn-red-can" ).click(function() {
        console.log("You click on #btn-red-can");
        invOperation = 'D';
        updateTicketType('D');
        logInAddPay('*** SUPPRESSION ***');
  
        $("#addp-valred").hide(100);
        $("#addp-print").show(300);
  
      });

      $( "#btn-red-val" ).click(function() {
        console.log("You click on #btn-red-val");
        invOperation = 'V';
        updateTicketType('V');
        logInAddPay('*** VALIDATION ***');
  
        $("#addp-valred").hide(100);
        $("#addp-print").show(300);
  
      });

      
      $( "#btn-can-pay" ).click(function() {
        console.log("You click on #btn-can-pay");
        
        // No need involved operation as we have set it in ajax
        invOperation = 'C';
        updateTicketType('C');
        logInAddPay('*** ANNULATION PAIEMENT ***');
  
        $("#addp-canpay").hide(100);
        $("#addp-print").show(300);
  
      });

      // STAIRS 3 **********************************************************************************************************************************
      
  
      // CREATE THE CUTS
      // Create the cut
      $( "#btn-addcut-1" ).click(function() {
        //console.log("You click on #btn-addcut-1");
        updateTicketType('R');
        logInAddPay('>>>>>>>>>>>>>>>> RÉDUCTION DE 20%');
        logInAddPay('VINGT POUR CENT');
        logInAddPay(msgFooterRedPdt);
        redPc = 20;
  
  
        $("#addp-red-option").hide(100);
        $("#addp-print").show(300);
  
      });
      $( "#btn-addcut-2" ).click(function() {
        //console.log("You click on #btn-addcut-2");
        updateTicketType('R');
        logInAddPay('>>>>>>>>>>>>>>>> RÉDUCTION DE 50%');
        logInAddPay('CINQUANTE POUR CENT');
        logInAddPay(msgFooterRedPdt);
        redPc = 50;
  
  
        $("#addp-red-option").hide(100);
        $("#addp-print").show(300);
  
      });
      $( "#btn-addcut-3" ).click(function() {
        //console.log("You click on #btn-addcut-3");
        updateTicketType('R');
        logInAddPay('>>>>>>>>>>>>>>>> RÉDUCTION DE 75%');
        logInAddPay('SOIXANTE QUINZE POUR CENT');
        logInAddPay(msgFooterRedPdt);
        redPc = 75;
  
  
        $("#addp-red-option").hide(100);
        $("#addp-print").show(300);
  
      });
      $( "#btn-addcut-4" ).click(function() {
        //console.log("You click on #btn-addcut-4");
        updateTicketType('R');
        logInAddPay('>>>>>>>>>>>>>>> RÉDUCTION DE 100%');
        logInAddPay('CENT POUR CENT');
        logInAddPay(msgFooterRedPdt);
        redPc = 100;
  
        $("#addp-red-option").hide(100);
        $("#addp-print").show(300);
      });
  
      //btn-addfac-1
      /*
      $( "#btn-addfac-1" ).click(function() {
        console.log("You click on #btn-addfac-1");
        updateTicketType('M');
        logInAddPay('MENSUALISATION');
        logInAddPay(msgFooterRedDaf);
  
        $("#addp-red-option").hide(100);
        $("#addp-print").show(300);
      });

      */
  
  
      // PRINT BUTTON !!!
      // Unbind to avoid mutiple fire
      // $( "#addp-print" ).unbind().click(function() {
      $("#addp-print").off().on('click', function() {
        //console.log("You click on #addp-print");
        // Choose the operation
        if(invOperation == 'R'){
          generateFaciliteDBAndPrint();
        }
        else if(invOperation == 'L'){
          //Delete and print
          generateFaciliteDBAndPrint();
        }
        else if(invOperation == 'V'){
          //Delete and print
          generateValidateRedDBAndPrint();
        }
        else if(invOperation == 'D'){
          //Delete and print
          generateDeleteRedDBAndPrint();
        }
        else if(invOperation == 'C'){
          //Delete and print
          generateCancelPaymentDBAndPrint();
        }
        else if(invOperation == 'S'){
          //Delete and print
          generateCertificatScoDBAndPrint();
        }
        else if(invOperation == 'A'){
          // Delete and print
          // Carte étudiant
          generateOpeMultiDBAndPrint(invOperation);
        }
        else if(invOperation == 'Y'){
          // Delete and print
          // Change filiere
          generateOpeMultiDBAndPrint(invOperation);
        }
        else if(invOperation == 'T'){
          // Delete and print
          // Certification
          generateOpeMultiDBAndPrint(invOperation);
        }
        else{
          generatePayDBAndPrint();
        }
        // Then reclean all againt !!!
      });
  
      //$( "#btn-print-recap" ).click(function() {
      $("#btn-print-recap").off().on('click', function() {
        console.log("You click on #btn-print-recap");
        generateHistoryPrint();
        // Then reclean all againt !!!
      });

  
      /** END : Specific to add pay */
  }
  else if($('#mg-graph-identifier').text() == 'xxx'){
    // Do something
  }
  else{
    //Do nothing
  }

});
