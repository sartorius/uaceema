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


  $.ajax('/generatepayDB', {
      type: 'POST',  // http method
      data: {
        foundUserId: foundUserId,
        ticketRef: tempTicketRef,
        invAmountToPay: invAmountToPay,
        invFscId: invFscId,
        invTypeOfPayment: invTypeOfPayment,
        token : getToken
      },  // data to submit
      success: function (data, status, xhr) {
          //dataAllUSRNToJsonArray[foundiInJson].EXISTING_FACILITE = (dataAllUSRNToJsonArray[foundiInJson].EXISTING_FACILITE == null) ? (ticketType + redPc) : (dataAllUSRNToJsonArray[foundiInJson].EXISTING_FACILITE + ',' + ticketType + redPc);
          printReceiptPDF(tempTicketRef);
      },
      error: function (jqXhr, textStatus, errorMessage) {
        $('#msg-alert').html("ERR785:" + tempTicketRef + " enregistrement du paiement impossible sinon contactez le support. ");
        $('#type-alert').removeClass('alert-primary').addClass('alert-danger');
        $('#ace-alert-msg').show(100);
        addPayClear();
      }
  });
}

function generateHistoryPrint(){
  /**************** HISTORY *****************/
  let doc = new jsPDF('p', 'mm', [200, 75]);
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
          isValidMIN = true;
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
    $("#id-amo-note").html(INVALID_AMOUNT);
    invAmountToPay = 0;
  }
}

function setPartButtonsAndListener(){
  let invTranche = 1;
  for(let i=0; i<dataPaymentForUserJsonArray.length; i++){
    if(dataPaymentForUserJsonArray[i].REF_TYPE.toString() == 'T'){
      // We are on a Tranche
      $('#id-part-' + invTranche +  '-3').html(renderAmount(dataPaymentForUserJsonArray[i].REF_AMOUNT.toString()));
      $('#id-rawpayamt-' + invTranche +  '-3').html(dataPaymentForUserJsonArray[i].REF_AMOUNT.toString());
      $('#id-fscid-' + invTranche +  '-3').html(dataPaymentForUserJsonArray[i].REF_ID.toString());
      //invFscId
      // Hanlde late
      if(dataPaymentForUserJsonArray[i].NEGATIVE_IS_LATE < 0){
        $('#btn-part-' + invTranche + '-3').removeClass('pay-opt-btn-t-a');
        $('#btn-part-' + invTranche + '-3').addClass('pay-opt-btn-t-late');
        $('#lbl-part-' + invTranche +  '-3').html(invTranche + LATE_FLATICON);
      }
      else{
        $('#lbl-part-' + invTranche +  '-3').html(invTranche);
      }

      invTranche = invTranche + 1;
    }
    else{
      //Do nothing
      //We are not on a Tranche
    }
  }

  for(let k=1; k<4; k++){
      // Add listener
      $("#btn-part-" + k + "-3").off('click');
      $( "#btn-part-" + k + "-3" ).click(function() {
        invAmountToPay = parseInt($('#id-rawpayamt-' + k +  '-3').html());
        invFscId = parseInt($('#id-fscid-' + k +  '-3').html());
        console.log('You click on: ' + k + '/' + invAmountToPay);

        logInAddPay(renderAmount(invAmountToPay));
        $("#addp-pay-part").hide(100);
        $("#addp-print").show(300);
      });
  }

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
  
      // STAIRS 1 *****************************************************************
      // Generate a cut
      $( "#btn-addcut" ).click(function() {
        console.log("You click on #btn-addcut");
        invOperation = 'F';
        $('#sh-ticketref').html(ticketRef + ticketType);
        // We do not do updateTicketType('R') here because we may use the Letter of commitment
  
  
        logInAddPay('Opération Facilité de paiement');
        $("#addp-mainop").hide(100);
        $("#addp-red-option").show(300);
      });
      // Add a payment
      $( "#btn-addpay" ).click(function() {
        console.log("You click on #btn-addpay");
        invOperation = 'P';
        logInAddPay('Opération PAIEMENT');
  
        updateTicketType('P');
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
  

      // STAIRS 2 *****************************************************************
      // CREATE THE LETTEROF COMMITMENT
      // Create the LOC
      $( "#btn-addcut-com" ).click(function() {
        console.log("You click on #btn-addcut-com");
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
        console.log("You click on #addp-print");
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
