function printReceiptPDF(){

  console.log('Click on printReceiptPDF');

  let tempTicketRef = ticketRef + ticketType;
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
  for(i=0; i<myTicket.length; i++){
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
  let filename = 'FS' + tempTicketRef + ticketRefFile;
  doc.text(5, contentHeight, "REF_Fich_" + filename + "_FRAISDESCOLARITE");

  doc.save(filename);


  //$("body").removeClass("loading");
  //$("#screen-load").hide();
  // 0123456789
  // 0304125678R
}

/**********************************************************/


function addPayUserExists(val){
  for (var i = 0; i < dataAllUSRNToJsonArray.length; i++) {
    if (dataAllUSRNToJsonArray[i].USERNAME === val){
      foundMatricule = dataAllUSRNToJsonArray[i].MATRICULE;
      foundName = dataAllUSRNToJsonArray[i].NAME;
      foundClasse = dataAllUSRNToJsonArray[i].CLASSE;
      return true;
    }
  }
  return false;
}

function addPayClear(){
  $('#addpay-ace').val('');
  $('#last-read-bc').html('');
  $('#last-read-time').html('');
  $("#exist-code-read").html('N');
  $('#addpay-ace').show(100);

  $("#addp-mainop").hide(100);
  $("#addp-red-option").hide(100);
  $("#addp-print").hide(100);

  ticketType =  'X';
  // Clear the log;
  logInAddPay('');
  myTicket = new Array();

}

function verityAddPayContentScan(){
  // Do something
  let foundCode = $("#exist-code-read").html();
  if(foundCode == 'N'){
    $("#addp-mainop").hide(200);
  }


  if ($('#addpay-ace').val().length == 10){

    let originalRedInput = $('#addpay-ace').val();
    let readInput = $('#addpay-ace').val().replace(/[^a-z0-9]/gi,'').toUpperCase();
    console.log("Diagnostic 2 Read Input : " + readInput.length + ' : ' + readInput + ' - ' + originalRedInput + ' 0/' + convertWordAZERTY(originalRedInput) + ' 1/' + convertWordAZERTY(originalRedInput).toUpperCase() + ' 2/' + convertWordAZERTY(originalRedInput).toUpperCase().replace(/[^a-z0-9]/gi,'') + ' 3/' + convertWordAZERTY(originalRedInput).toLowerCase().replace(/[^a-z0-9]/gi,''));

    if(readInput.length < 10){
      // We are on the wrong keyboard config as it must be 10
      readInput = convertWordAZERTY(originalRedInput).replace(/[^a-z0-9]/gi,'').toUpperCase();
    }

    let scanValidToDisplay = ' <i class="mgs-rd-o-err">&nbsp;ERR91Format&nbsp;</i>';
    // Here we check the format
    if(/[a-zA-Z0-9]{9}[0-9]/.test(readInput)){
      // Only if the read is clean

      if(addPayUserExists(readInput)){
        /********************************************************** FOUND **********************************************************/

        scanValidToDisplay = ' <i class="mgs-rd-o-in">&nbsp;Étudiant valide&nbsp;</i>';
        $("#exist-code-read").html('Y');
        $('#addpay-ace').hide(100);

        $("#addp-mainop").show(100);

        logInAddPay('username:' + readInput);


        logInAddPay(foundMatricule);
        logInAddPay(foundName);
        logInAddPay(foundClasse);

      }
      else{
        /******************************************************** NOT FOUND ********************************************************/
        scanValidToDisplay = ' <i class="mgs-rd-o-err">&nbsp;Étudiant introuvable&nbsp;</i>';
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

    myBreak = '';

    let ticketRefTime = myNow.getHours().toString().padStart(2, '4') + myNow.getMinutes().toString().padStart(2, '0') + myNow.getSeconds().toString().padStart(2, '0');
    ticketRef = ticketRefTime + (Math.floor((myNow - new Date(myNow.getFullYear(), 0, 0)) / 1000 / 60 / 60 / 24)).toString().padStart(3, '0');

    let tdate = myNow.getDate().toString().padStart(2, '0')+'_'+(myNow.getMonth()+1).toString().padStart(2, '0')+'_'+myNow.getFullYear();
    let ttime = myNow.getHours().toString().padStart(2, '0') + "h" + myNow.getMinutes().toString().padStart(2, '0') + "m" + myNow.getSeconds().toString().padStart(2, '0');

    ticketRefFile = tdate + "_" + ttime;
    $('#sh-ticketref').html(ticketRef + ticketType);
  }
  let myLog = $('#pay-sc-log-tra').html();
  myTicket.push(appendLog);
  $('#pay-sc-log-tra').html(myLog + myBreak + appendLog);

};

/***********************************************************************************************************/

$(document).ready(function() {
  console.log('We are in ACE-PAY');

  if($('#mg-graph-identifier').text() == 'add-pay'){
    // Do something
    $( "#addpay-ace" ).keyup(function() {
      verityAddPayContentScan();
    });

    $( "#btn-clear-addpay" ).click(function() {
      addPayClear();
    });

    // Generate a cut
    $( "#btn-addcut" ).click(function() {
      console.log("You click on #btn-addcut");

      ticketType =  'R';
      $('#sh-ticketref').html(ticketRef + ticketType);


      logInAddPay('Opé. RÉDUCTION');
      $("#addp-mainop").hide(100);
      $("#addp-red-option").show(300);

    });
    // Add a payment
    $( "#btn-addpay" ).click(function() {
      console.log("You click on #btn-addpay");
      logInAddPay('Opé. PAIEMENT');

      ticketType =  'P';
      $('#sh-ticketref').html(ticketRef + ticketType);


    });


    // CREATE THE CUTS
    // Create the cut
    $( "#btn-addcut-1" ).click(function() {
      console.log("You click on #btn-addcut-1");
      logInAddPay('>>>>>>>>>>>>>>>> RÉDUCTION DE 50%');
      logInAddPay('CINQUANTE POUR CENT');
      logInAddPay(msgFooterRed);


      $("#addp-red-option").hide(100);
      $("#addp-print").show(300);

    });
    $( "#btn-addcut-2" ).click(function() {
      console.log("You click on #btn-addcut-2");
      logInAddPay('>>>>>>>>>>>>>>> RÉDUCTION DE 100%');
      logInAddPay('CENT POUR CENT');
      logInAddPay(msgFooterRed);

      $("#addp-red-option").hide(100);
      $("#addp-print").show(300);
    });


    // PRINT BUTTON !!!
    $( "#addp-print" ).click(function() {
      console.log("You click on #addp-print");
      printReceiptPDF();
      // Then reclean all againt !!!
    });
    logInAddPay('');

  }
  else if($('#mg-graph-identifier').text() == 'xxx'){
    // Do something
  }
  else{
    //Do nothing
  }



});
