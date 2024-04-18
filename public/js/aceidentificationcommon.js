
function generateRefFraisCSV(){
  const csvContentType = "data:text/csv;charset=utf-8,%EF%BB%BF";
  let csvContent = "";
  let involvedArray = dataREFPAYToJsonArray;
  const SEP_ = ";"

let dataString = "#" + SEP_ 
                  + "Titre" + SEP_ 
                  + "Montant" + SEP_ 
                  + "Paiement" + SEP_ 
                  + "Limite" + SEP_ + "\n";
csvContent += dataString;
for(let i=0; i<involvedArray.length; i++){

          dataString = involvedArray[i].id + SEP_ 
              + involvedArray[i].title + SEP_ 
              + renderAmount(involvedArray[i].amount) + SEP_;
          
          if(involvedArray[i].type == 'U'){
            dataString +=  "Fixe" + SEP_ ;
          }
          else if(involvedArray[i].type == 'M'){
            dataString +=  "Divers" + SEP_ ;
          }
          else if(involvedArray[i].type == 'F'){
            dataString +=  "Additionnel" + SEP_ ;
          }
          else{
            dataString +=  "Tranche" + SEP_ ;
          }
          dataString += convertSQLDateToDateStrFR(involvedArray[i].deadline) + SEP_ ;
          // easy close here
          csvContent += i < involvedArray.length ? dataString+ "\n" : dataString;
}

  //console.log('Click on csv');
  //csvContent = encodeURI(csvContent);
  let csvData = new Blob([csvContent], { type: csvContentType });

  let link = document.createElement("a");
  let csvUrl = URL.createObjectURL(csvData);

  link.href =  csvUrl;
  link.style = "visibility:hidden";
  link.download = 'RapportRefFraisScolarite.csv';
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);

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
            return renderAmount(value);
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
              return "Fixe";
            }
            else if(value == 'M'){
              return "Divers";
            }
            else if(value == 'F'){
              return "Additionnel";
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

function loadRefPayGridDiscount(){

  refPayFieldDiscount = [
      { name: "DIS_DESC_DISP",
        title: 'Discount',
        type: "text",
        align: "center",
        width: 10,
        headercss: "cell-ref-sm-hd",
        css: "cell-ref-sm"
      },
      { name: "GENUINE_AMOUNT",
        title: 'Montant standard',
        type: "number",
        align: "right",
        width: 20,
        headercss: "cell-ref-sm-hd",
        css: "cell-ref-sm",
        itemTemplate: function(value, item) {
          return renderAmount(value);
        }
      },
      { name: "FINAL_AMOUNT",
        title: 'Montant final',
        type: "number",
        align: "right",
        width: 20,
        headercss: "cell-ref-sm-hd",
        css: "cell-ref-sm",
        itemTemplate: function(value, item) {
          return renderAmount(value);
        }
      }
  ];

  $("#jsGridRefDiscountPay").jsGrid({
      height: "auto",
      width: "100%",
      noDataContent: "Aucun discount disponible",
      pageIndex: 1,
      pageSize: 50,
      pagePrevText: "Prec",
      pageNextText: "Suiv",
      pageFirstText: "Prem",
      pageLastText: "Dern",

      sorting: true,
      paging: true,
      data: dataAllDispDiscountToJsonArray,
      fields: refPayFieldDiscount
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
          dataSumPerTranche = data['resultSumPerTranche'].slice();
          // Only here we allow to progress
          for(let i=0; i<dataLeftOperationForUserJsonArray.length; i++){
            if(dataLeftOperationForUserJsonArray[i].REF_TYPE == 'T'){
                // Still Tranche operation remains
                // Only if there are Tranche left we allow cut
                $('#btn-addpay').removeClass('deactive-btn');
                $('#btn-addcut').removeClass('deactive-btn');
                $('#btn-addcut-com').removeClass('deactive-btn');
            }
            
            if(dataLeftOperationForUserJsonArray[i].REF_TYPE == 'U'){
                // Still Unique operation remains
                $('#btn-adduni').removeClass('deactive-btn');
            }
          }

          for(let i=0; i<dataSumPerTranche.length; i++){
            // If we have a commitment Letter on rest to pay then no new commitment letter. He has to pay first
            if((parseInt(dataSumPerTranche[i].REST_TO_PAY) > 0) 
                    && (dataSumPerTranche[i].COMMITMENT_LETTER == 'L')){
                $('#btn-addcut-com').addClass('deactive-btn');
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
            $('#msg-alert').html("ERR138D:" + foundUserName + " erreur affichage, contactez le support.");
          }
          $("#btn-print-recap").show(100);
          // Display paiements
          displayHistoryPayment();
      },
      error: function (jqXhr, textStatus, errorMessage) {
        $("#waiting-gif").hide(100);
        $('#msg-alert').html("ERR134P:" + foundUserName + " impossible de récupérer ses paiements, contactez le support.");
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
  let doc = new jsPDF('p', 'mm', [(55 + (myTicket.length * 7)), 75]);

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
  payShortCutOperationForUserJsonArray = new Array();
  $(".init-deactive").addClass('deactive-btn');

  // Comment
  invComment = '';
  $('#pay-com').val(invComment);
  $('#paycom-length').html(MAX_COMENT_LIMIT);
}

// CERTSCO CERTIFC CHGFILL CARTEET
function getAllOPEAmount(paramCode){
  for(let i=0; i < dataAllOPEToJsonArray.length; i++){
    if(dataAllOPEToJsonArray[i].code == paramCode){
      return dataAllOPEToJsonArray[i].amount;
    }
  }
  return 'ERR6239';
}

/*
function addPayUserExists(paramReadInput){
  let convertParamValue = convertWordAZERTY(paramReadInput).toUpperCase();
  if(addPayUserExistsGenuine(convertParamValue)){
    $('#addpay-ace').val(convertParamValue);
    return true;
  }
  else{
    return addPayUserExistsGenuine(paramReadInput);
  }
}
*/

function addPayUserExists(val){
  for (let i = 0; i < dataAllUSRNToJsonArray.length; i++) {
    if (dataAllUSRNToJsonArray[i].USERNAME === val){
      foundiInJson = i;
      foundUserName = dataAllUSRNToJsonArray[i].USERNAME;
      foundMatricule = dataAllUSRNToJsonArray[i].MATRICULE;
      foundName = dataAllUSRNToJsonArray[i].NAME;
      foundClasse = dataAllUSRNToJsonArray[i].CLASSE;
      foundUserId = dataAllUSRNToJsonArray[i].ID;
      foundExisting_Facilite = dataAllUSRNToJsonArray[i].EXISTING_FACILITE;
      //Display the price of the different operation here
      // btn-cert-sco btn-cert-cer btn-cart-etu
      for(let j=0; j < dataAllOPEToJsonArray.length; j++){
        switch(dataAllOPEToJsonArray[j].code) {
          case 'CERTSCO':
            // code block
            $("#cert-sco-am").html(renderAmount(dataAllOPEToJsonArray[j].amount));
            break;
          case 'CERTIFC':
            // code block
            $("#cert-cer-am").html(renderAmount(dataAllOPEToJsonArray[j].amount));
            break;
          case 'CHGFILL':
            // code block
            $("#chg-fil-am").html(renderAmount(dataAllOPEToJsonArray[j].amount));
            break;
          default:
            $("#cart-etu-am").html(renderAmount(dataAllOPEToJsonArray[j].amount));
            // code block
        }
      }



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
        // Handle here if the reduction can be applied or not
        if((dataAllREDUCToJsonArray[i].UFP_STATUS === 'D') || 
                (dataAllREDUCToJsonArray[i].UFP_STATUS === 'A')){
            $('#btn-red-val').addClass('deactive-btn');
            $('#btn-red-can').addClass('deactive-btn');
            $('#used-red').show(100);
            if(dataAllREDUCToJsonArray[i].UFP_STATUS === 'A'){
                logInAddPay('DEJA*VALIDE*' + val);
            }
            else{
                logInAddPay('DEJA*SUPPRIME*' + val);
            }
        }
        else{
            $('#used-red').hide(100);
            $('#btn-red-val').removeClass('deactive-btn');
            $('#btn-red-can').removeClass('deactive-btn');
            logInAddPay('REFERENCE*' + val);
            ticketRefToDelete = val;
            ticketRefToValidate = val;
        }
        return dataAllREDUCToJsonArray[i].USERNAME;
      }
    }
    return 'na';
}

// Fill once for good the data in the discount
// Duplicate code for Management MVO in acepaybasic
function displayDiscount(){
  if(dataAllDispDiscountToJsonArray.length > 0){
    $("#disc-case-n").html(renderAmount(dataAllDispDiscountToJsonArray[0].GENUINE_AMOUNT));
    for(let j=0; j < dataAllDispDiscountToJsonArray.length; j++){
      $("#disc-case-" + dataAllDispDiscountToJsonArray[j].DIS_CASE.toLowerCase()).html(renderAmount(dataAllDispDiscountToJsonArray[j].FINAL_AMOUNT));
    }
  }
  else{
    console.log('Reading discount ref: Err1890');
  }
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
  $('#used-red').hide(100);
  $('#btn-red-val').removeClass('deactive-btn');
  $('#btn-red-can').removeClass('deactive-btn');
  $('#btn-addcut-com').removeClass('deactive-btn');
  $('#btn-part-man').show(100);
  $('#btn-part-man-subm').show(100);
  $('#pay-recap').show(100);
  $("#addp-canpay").hide(100);
  $("#cert-sco-am").html('AMTC AR');
  $("#cert-cer-am").html('AMTC AR');
  $("#cart-etu-am").html('AMTC AR'); 
  lblDate = '';
  invAmountToPay = 0;
  invFscId = 0;
  invShortCutDiscountId = 0;
  invTypeOfPayment = 'C';
  invOperation = 'F';
  ticketRefToDelete = '';
  ticketRefToValidate = '';
  ticketRefPayment = '';

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

  //Reset exemption here
  $("#btn-type-e").removeClass('deactive-btn');

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
    let convertParamValue = convertWordAZERTY(readInput).toUpperCase();
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
      //console.log('Read input 1 convertWordAZERTY');
      /*****************************/
      /*****************************/
      /*****************************/
      /*** UGLY BUG FIX Conversion */
      /*****************************/
      /*****************************/
      /*****************************/
      if(addPayUserExists(convertParamValue)){
        readInput = convertParamValue;
        $('#addpay-ace').val(readInput);
        /********************************************************** FOUND **********************************************************/
        scanValidToDisplay = ' <i class="mgs-rd-o-in">&nbsp;Étudiant valide&nbsp;</i>';
        commonOperationIfFoundUsername(readInput);
      }
      else if(addPayUserExists(readInput)){
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
                //console.log('Format Reduction OK readInput: ' + readInput);
                /******************************* Look in the list *********************************/
                /********************* Retrieve only Reduction Inactive ***************************/

                currentTicketMode = 'R';
                let reductionUsername = addPayReductionExists(readInput);
                if(reductionUsername != 'na'){
                    if(addPayUserExists(reductionUsername)){
                        //xxx
                        /********************************************************** FOUND **********************************************************/
                        scanValidToDisplay = ' <i class="mgs-rd-o-in">&nbsp;Réduction valide&nbsp;</i>';
                        commonOperationIfFoundUsername(reductionUsername);
                        updateTicketType('V');
                        
                
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
            else if(/[0-9]{9}[P]/.test(readInput)){
                //We deal here with Payment cancellation
                console.log('Format Payment OK readInput: ' + readInput);
                scanValidToDisplay = ' <i class="mgs-rd-o-in">&nbsp;Format Paiement valide&nbsp;</i>';
                ticketRefPayment = readInput;
                // xxx
                // Need to retrieve the payment in DB
                getPaymentDetailsDB('PAY');

            }
            else if(/[0-9]{9}[S|T|A|Y]/.test(readInput)){
                //We deal here with Payment cancellation
                console.log('Format Payment OK readInput: ' + readInput);
                scanValidToDisplay = ' <i class="mgs-rd-o-in">&nbsp;Format Paiement valide&nbsp;</i>';
                ticketRefPayment = readInput;
                // xxx
                // Need to retrieve the payment in DB
                getPaymentDetailsDB('MULTI');

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
    lblDate = date;
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

function displayAndPushRecapTrancheHistory(myRecapTxt){
    let recapLine = '';
    let notifRetard = '';
    for(let i=0; i<dataSumPerTranche.length; i++){
        recapLine = ('*******' + dataSumPerTranche[i].DESCRIPTION.toString() +'*'+ dataSumPerTranche[i].TRANCHE_CODE.toString()).padStart(maxLgRecap, paddChar);
        myRecap.push(recapLine);
        myRecapTxt = myRecapTxt + recapLine + '<br>';

        if(dataSumPerTranche[i].COMMITMENT_LETTER.toString() == 'L'){
            recapLine = ('LETTRE*ENGAGEMENT').padStart(maxLgRecap, paddChar);
            myRecap.push(recapLine);
            myRecapTxt = myRecapTxt + recapLine + '<br>';
        }
        
        statusPayDate = 'À payer avant le :';
        recapLine = (statusPayDate + dataSumPerTranche[i].TRANCHE_DDL.toString()).padStart(maxLgRecap, paddChar);
        myRecap.push(recapLine);
        myRecapTxt = myRecapTxt + recapLine + '<br>';

        if((dataSumPerTranche[i].NEGATIVE_IS_LATE < 0) &&
             (dataSumPerTranche[i].REST_TO_PAY > 0)){
            notifRetard = 'PAIEMENT EN RETARD !!!';
            recapLine = notifRetard.padStart(maxLgRecap, paddChar);
            notifRetard = '<i class="late-notif">' + notifRetard + '</i>';
        }
        else if (dataSumPerTranche[i].REST_TO_PAY > 0){
            notifRetard = 'EN ATTENTE DE PAIEMENT';
            recapLine = notifRetard.padStart(maxLgRecap, paddChar);
        }
        else{
            // There is nothing to pay more
            notifRetard = 'DEJA TOUT REGLE';
            recapLine = notifRetard.padStart(maxLgRecap, paddChar);
        }
        myRecap.push(recapLine);
        myRecapTxt = myRecapTxt + notifRetard + '<br>';

        recapLine = (dataSumPerTranche[i].ALREADY_PAID.toString() +'/'+ dataSumPerTranche[i].TRANCHE_AMOUNT.toString()).padStart(maxLgRecap, paddChar);
        myRecap.push(recapLine);
        myRecapTxt = myRecapTxt + recapLine + '<br>';

        recapLine = ('Restant à payer:'+ renderAmount(dataSumPerTranche[i].REST_TO_PAY.toString())).padStart(maxLgRecap, paddChar);
        myRecap.push(recapLine);
        myRecapTxt = myRecapTxt + recapLine + '<br>';

    }
    return myRecapTxt;
}


function displayHistoryPayment(){
  let recapTxt = '';
  let recapLine = '';
  let statusPayDate = '';
  let refDate;
  let recAmount = '';
  let typeOfPayment = '';
  let refRecAmount = '';
  let notifRetard = '';
  // Not to be pushed in recap
  const separatorRecap = '----x---x---x---x---x---x---x---x---x---x----';
  let recapOfPaymentHasStarted = 'N';


  //Recapitulatif Tranche


  for(let i=0; i<dataPaymentForUserJsonArray.length; i++){

    //We do not treat Commitment Letter in the History
    if(dataPaymentForUserJsonArray[i].UP_TYPE_OF_PAYMENT != 'L'){
                /******************************************************************************** */
                /******************************************************************************** */
                /******************************************************************************** */
                /************************** NOT COMMITMENT LETTER ******************************* */
                /******************************************************************************** */
                /******************************************************************************** */
                /******************************************************************************** */


                if(dataPaymentForUserJsonArray[i].REF_TYPE.toString() == 'T'){
                    //We need to call the Recap Tranche first
                    if(recapOfPaymentHasStarted == 'N'){
                        
            
                        recapLine = ('******* SOLDE ACTUEL *******').padStart(maxLgRecap, paddChar);
                        myRecap.push(recapLine);
                        recapTxt = recapTxt + recapLine + '<br>';
            
                        //Call the tranche solde here
                        recapTxt = displayAndPushRecapTrancheHistory(recapTxt);
            
                        recapTxt = recapTxt + separatorRecap + '<br>';
                        recapLine = ('********* HISTORIQUE *********').padStart(maxLgRecap, paddChar);
                        myRecap.push(recapLine);
                        recapTxt = recapTxt + recapLine + '<br>';
            
            
                        recapTxt = recapTxt + separatorRecap + '<br>';
                        
                        recapOfPaymentHasStarted = 'Y';
                    }
                    else{
                        
                    }
                }
                else{
                    //Do nothing
                }
            
                recapLine = dataPaymentForUserJsonArray[i].REF_TITLE.toString().padStart(maxLgRecap, paddChar);
                myRecap.push(recapLine);
                recapTxt = recapTxt + recapLine + '<br>';
            
            
                
            
            
                recapLine = '';
                notifRetard = '';
            
                // List of Frais Generaux cannot be split
                if(dataPaymentForUserJsonArray[i].REF_TYPE.toString() == 'U'){
                        // If unitaire and not tranche
                        if(dataPaymentForUserJsonArray[i].UP_STATUS.toString() == 'N'){
            
                            refDate = new Date(Date.parse(dataPaymentForUserJsonArray[i].REF_DEADLINE.toString()));
                            statusPayDate = 'À payer avant le :';
            
            
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
                }
            
                // Here for U and T if paid
                if(dataPaymentForUserJsonArray[i].UP_STATUS.toString() == 'P'){
                    // if(dataPaymentForUserJsonArray[i].UP_STATUS.toString() == 'P')
                    refDate = new Date(Date.parse(dataPaymentForUserJsonArray[i].UP_PAY_DATE.toString()));
                    statusPayDate = 'Déjà réglé le :';
                }
                else{
                    refDate = new Date(Date.parse(dataPaymentForUserJsonArray[i].REF_DEADLINE.toString()));
                    statusPayDate = 'À payer avant le :';
                }
            
            
            
                
                recapLine = (statusPayDate + formatterDateFR.format(refDate)).padStart(maxLgRecap, paddChar);
                myRecap.push(recapLine);
                recapTxt = recapTxt + recapLine + '<br>';
            
                refRecAmount = (('REF*MONTANT:' + renderAmount(dataPaymentForUserJsonArray[i].REF_AMOUNT.toString()))).padStart(maxLgRecap, paddChar);
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
                else if(dataPaymentForUserJsonArray[i].UP_TYPE_OF_PAYMENT == 'R'){
                    typeOfPayment = '/REDUCTION';
                }
                else if(dataPaymentForUserJsonArray[i].UP_TYPE_OF_PAYMENT == 'E'){
                    typeOfPayment = '/EXEMPTION';
                }
                else{
                    //Do nothing
                    typeOfPayment = '';
                }
                recAmount = (('Paiement' + typeOfPayment + ' :' + renderAmount(dataPaymentForUserJsonArray[i].UP_INPUT_AMOUNT.toString()))).padStart(maxLgRecap, paddChar);
                myRecap.push(recAmount);
            
                recapTxt = recapTxt + recAmount + '<br>';
                recapTxt = recapTxt + separatorRecap + '<br>';

    }
    else{
        //We do nothing were are in Commitment Letter
    }
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
      console.log('in ref-pay');
      loadRefPayGrid();
      loadRefPayGridDiscount();
    }
    else if($('#mg-graph-identifier').text() == 'xxx'){
      // Do something
    }
    else{
      //Do nothing
    }
  
  
  
  });
  