function generateFaciliteDBAndPrint(){
  let tempTicketRef = ticketRef + ticketType;


  $.ajax('/generatefaciliteDB', {
      type: 'POST',  // http method
      data: {
        foundUserId: foundUserId,
        ticketRef: tempTicketRef,
        redPc: redPc,
        ticketType: ticketType,
        token : getToken
      },  // data to submit
      success: function (data, status, xhr) {
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

function generatePayDBAndPrint(){
  let tempTicketRef = ticketRef + ticketType;


  $.ajax('/generatepaymentDB', {
      type: 'POST',  // http method
      data: {
        foundUserId: foundUserId,
        ticketRef: tempTicketRef,
        invAmountToPay: invAmountToPay,
        invFscId: invFscId,
        invTypeOfPayment: invTypeOfPayment,
        payUniLeftOperationForUserJsonArray: JSON.stringify(payUniLeftOperationForUserJsonArray),
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

function generateHistoryPrint(){
  /**************** HISTORY *****************/
  let doc = new jsPDF('p', 'mm', [(35 + (myRecap.length * 6)), 75]);
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

function setPartButtonsAndListener(){
  let invRefLineTranche = 1;
  let invCodeTranche = 'XXX';
  let invRefCodeTrancheAmount = 0;

  let invTotalCodeTrancheAmount = 0;
  //We need to consider that tranche initial (as previous) is closed
  let trancheStillOpen = 'N';
  let blockNextTranche = 'N';
  


  for(let i=0; i<dataPaymentForUserJsonArray.length; i++){
    if(dataPaymentForUserJsonArray[i].REF_TYPE.toString() == 'T'){
      //Check first if we handling a new Tranche
      if(dataPaymentForUserJsonArray[i].REF_CODE != invCodeTranche){
        // We have a new tranche code we need to handle it
        // Set the data
        invCodeTranche = dataPaymentForUserJsonArray[i].REF_CODE;
        invRefCodeTrancheAmount = parseInt(dataPaymentForUserJsonArray[i].REF_AMOUNT);

        if(trancheStillOpen == 'Y'){
          // But we have move of Tranche so we need to not allow next tranche open
          blockNextTranche = 'Y';
        }
        // Whatever we need to keep reset to zero but we need to check the previous
        invTotalCodeTrancheAmount = 0;

        // We are on a Tranche
        $('#id-part-' + invRefLineTranche +  '-3').html(renderAmount(dataPaymentForUserJsonArray[i].REF_AMOUNT.toString()));
        $('#id-rawpayamt-' + invRefLineTranche +  '-3').html(dataPaymentForUserJsonArray[i].REF_AMOUNT.toString());
        $('#id-fscid-' + invRefLineTranche +  '-3').html(dataPaymentForUserJsonArray[i].REF_ID.toString());
        //invFscId
        // Hanlde late
        if(dataPaymentForUserJsonArray[i].NEGATIVE_IS_LATE < 0){
          $('#btn-part-' + invRefLineTranche + '-3').removeClass('pay-opt-btn-t-a');
          $('#btn-part-' + invRefLineTranche + '-3').addClass('pay-opt-btn-t-late');
          $('#lbl-part-' + invRefLineTranche +  '-3').html(invRefLineTranche + LATE_FLATICON);
        }
        else{
          $('#lbl-part-' + invRefLineTranche +  '-3').html(invRefLineTranche);
        }

        //Compute the amount here New Tranche
        invTotalCodeTrancheAmount = parseInt(dataPaymentForUserJsonArray[i].UP_INPUT_AMOUNT);
  
        invRefLineTranche = invRefLineTranche + 1;

      }
      else{
        // We need to handle partial payment here
        invTotalCodeTrancheAmount = invTotalCodeTrancheAmount + parseInt(dataPaymentForUserJsonArray[i].UP_INPUT_AMOUNT);
      }


      let tempinvRefLineTrancheMinus1 = (parseInt(invRefLineTranche) -  1);
      // Identify here if the Tranche is filled or not
      if(invTotalCodeTrancheAmount < invRefCodeTrancheAmount){
        //We keep this fisc ID
        if(blockNextTranche == 'N'){
          invFscId = dataPaymentForUserJsonArray[i].REF_ID;
          // This must the be the only option we allow
          // We need to remove 1 because the previous step has added 1
          //Set also Max Manual Amount
          maxManualAmount = invRefCodeTrancheAmount - invTotalCodeTrancheAmount;
          $('#id-part-' + tempinvRefLineTrancheMinus1 +  '-3').html(renderAmount(maxManualAmount.toString()));
          $('#id-rawpayamt-' + tempinvRefLineTrancheMinus1 +  '-3').html(maxManualAmount.toString());

          //console.log('tempinvRefLineTrancheMinus1: ' + tempinvRefLineTrancheMinus1 + ' - maxManualAmount: ' + maxManualAmount);

          $('#btn-part-' + tempinvRefLineTrancheMinus1 + '-3').removeClass('deactive-btn');
          trancheStillOpen = 'Y';
          //console.log('in CP1a');
        }
        else{
          $('#btn-part-' + tempinvRefLineTrancheMinus1 + '-3').addClass('deactive-btn');
          //console.log('in CP1b');
        }
      }
      else{
        // We have found that it is filled so remove it
        maxManualAmount = 0;
        $('#id-part-' + tempinvRefLineTrancheMinus1 +  '-3').html(renderAmount(invRefCodeTrancheAmount.toString()));
        $('#id-rawpayamt-' + tempinvRefLineTrancheMinus1 +  '-3').html(invRefCodeTrancheAmount.toString());
        $('#btn-part-' + tempinvRefLineTrancheMinus1 + '-3').addClass('deactive-btn');
        trancheStillOpen = 'N';
        //console.log('in CP2');
      }
      //console.log('trancheStillOpen: ' + trancheStillOpen + '/blockNextTranche: ' + blockNextTranche);

    }
    else{
      //Do nothing
      //We are not on a Tranche
      //We are on a Unique Payment
    }

  }

  for(let k=1; k<4; k++){
      // Add listener
      $("#btn-part-" + k + "-3").off('click');
      $( "#btn-part-" + k + "-3" ).click(function() {
        invAmountToPay = parseInt($('#id-rawpayamt-' + k +  '-3').html());
        invFscId = parseInt($('#id-fscid-' + k +  '-3').html());
        //console.log('You click on: ' + k + '/' + invAmountToPay);

        logInAddPay(renderAmount(invAmountToPay));
        $("#addp-pay-part").hide(100);
        $("#addp-type-pay").show(300);
      });
  }

}

function setUniButtonsAndListener(){
  let invRefLineUnique = 1;
  let totalUniLeftPay = 0;

  


  for(let i=0; i<dataPaymentForUserJsonArray.length; i++){
    if(dataPaymentForUserJsonArray[i].REF_TYPE.toString() == 'U'){
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
      
      if(dataPaymentForUserJsonArray[i].UP_STATUS ==  'N'){
        $('#lbl-uni-' + invRefLineUnique).html(dataPaymentForUserJsonArray[i].REF_TITLE);
        $( "#btn-uni-" + invRefLineUnique).removeClass('deactive-btn');
        $('#id-rawuniamt-' + invRefLineUnique).html(dataPaymentForUserJsonArray[i].REF_AMOUNT.toString());
        totalUniLeftPay = totalUniLeftPay + parseInt(dataPaymentForUserJsonArray[i].REF_AMOUNT.toString());

        let myUniPayment = {
          fscId: dataPaymentForUserJsonArray[i].REF_ID.toString(),
          typeOfPayment: 'C',
          inputAmount: dataPaymentForUserJsonArray[i].REF_AMOUNT.toString()
          };
        payUniLeftOperationForUserJsonArray.push(myUniPayment);
      }
      else{
        // It has been paid
        $('#id-rawuniamt-' + invRefLineUnique).html('0');
        $('#lbl-uni-' + invRefLineUnique).html(dataPaymentForUserJsonArray[i].REF_TITLE);
        $( "#btn-uni-" + invRefLineUnique).addClass('deactive-btn');
      }
      invRefLineUnique = invRefLineUnique + 1;
    }
    else{
      //Do nothing
      //We are not on a Unique
      //We are on a Tranche Payment
    }

    // Handle the button totalite
    $("#id-uni-left").html(renderAmount(totalUniLeftPay.toString()));


  }

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

/***********************************************************************************************************/

$(document).ready(function() {
  console.log('We are in ACE-PAY');

  if($('#mg-graph-identifier').text() == 'add-pay'){
    // Do something
      // Initialisation
      $("#id-amo-note").html(INVALID_AMOUNT);


      /** START : Specific to add pay */
      $( "#btn-clear-addpay" ).click(function() {
  
        $('#type-alert').addClass('alert-primary').removeClass('alert-danger');
        $('#ace-alert-msg').hide(100);
        addPayClear();
      });

      $( "#btn-type-h" ).click(function() {
        invTypeOfPayment = 'H';
        logInAddPay('*** CHEQUE ***');
        $("#addp-type-pay").hide(100);
        $("#addp-print").show(300);
      });

      $( "#btn-type-c" ).click(function() {
        invTypeOfPayment = 'C';
        logInAddPay('*** CASH ***');
        $("#addp-type-pay").hide(100);
        $("#addp-print").show(300);
      });

      $( "#btn-type-v" ).click(function() {
        invTypeOfPayment = 'V';
        logInAddPay('*** VIREMENT/TPE ***');
        $("#addp-type-pay").hide(100);
        $("#addp-print").show(300);
      });
      // STAIRS 1 **********************************************************************************************************************************
      // Generate a cut
      $( "#btn-addcut" ).click(function() {
        //console.log("You click on #btn-addcut");
        invOperation = 'F';
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
        setPartButtonsAndListener();

        // Add the listener on the amount
        $( "#addman-amo" ).keyup(function() {
          verifyManualAmount();
        });

      });

      // Add a payment unique
      $( "#btn-adduni" ).click(function() {
        console.log("You click on #btn-adduni");
        invOperation = 'P';
        logInAddPay('Opération PAIEMENT Frais Fixe');
  
        updateTicketType('P');
  
        $("#addp-mainop").hide(100);
        $("#addp-pay-uni").show(300);

        // Load payment options
        setUniButtonsAndListener();
      });
  

      // STAIRS 2 **********************************************************************************************************************************
      // CREATE THE LETTEROF COMMITMENT
      // Create the LOC
      $( "#btn-addcut-com" ).click(function() {
        //console.log("You click on #btn-addcut-com");
        updateTicketType('L');
        logInAddPay('*** LETTRE ENGAGEMENT ***');
        logInAddPay(msgFooterLOC);
  
        $("#addp-red-option").hide(100);
        $("#addp-print").show(300);
  
      });
  
      // CREATE THE CUTS
      // Create the cut
      $( "#btn-addcut-1" ).click(function() {
        console.log("You click on #btn-addcut-1");
        updateTicketType('R');
        logInAddPay('>>>>>>>>>>>>>>>> RÉDUCTION DE 10%');
        logInAddPay('DIX POUR CENT');
        logInAddPay(msgFooterRedPdt);
        redPc = 10;
  
  
        $("#addp-red-option").hide(100);
        $("#addp-print").show(300);
  
      });
      $( "#btn-addcut-2" ).click(function() {
        console.log("You click on #btn-addcut-2");
        updateTicketType('R');
        logInAddPay('>>>>>>>>>>>>>>>> RÉDUCTION DE 20%');
        logInAddPay('VINGT POUR CENT');
        logInAddPay(msgFooterRedPdt);
        redPc = 20;
  
  
        $("#addp-red-option").hide(100);
        $("#addp-print").show(300);
  
      });
      $( "#btn-addcut-3" ).click(function() {
        console.log("You click on #btn-addcut-3");
        updateTicketType('R');
        logInAddPay('>>>>>>>>>>>>>>>> RÉDUCTION DE 50%');
        logInAddPay('CINQUANTE POUR CENT');
        logInAddPay(msgFooterRedPdt);
        redPc = 50;
  
  
        $("#addp-red-option").hide(100);
        $("#addp-print").show(300);
  
      });
      $( "#btn-addcut-4" ).click(function() {
        console.log("You click on #btn-addcut-4");
        updateTicketType('R');
        logInAddPay('>>>>>>>>>>>>>>> RÉDUCTION DE 100%');
        logInAddPay('CENT POUR CENT');
        logInAddPay(msgFooterRedPdt);
        redPc = 100;
  
        $("#addp-red-option").hide(100);
        $("#addp-print").show(300);
      });
  
      //btn-addfac-1
      $( "#btn-addfac-1" ).click(function() {
        console.log("You click on #btn-addfac-1");
        updateTicketType('M');
        logInAddPay('MENSUALISATION');
        logInAddPay(msgFooterRedDaf);
  
        $("#addp-red-option").hide(100);
        $("#addp-print").show(300);
      });
  
  
      // PRINT BUTTON !!!
      $( "#addp-print" ).click(function() {
        //console.log("You click on #addp-print");
        // Choose the operation
        if(invOperation == 'F'){
          generateFaciliteDBAndPrint();
        }
        else{
          generatePayDBAndPrint();
        }
        // Then reclean all againt !!!
      });
  
      $( "#btn-print-recap" ).click(function() {
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
