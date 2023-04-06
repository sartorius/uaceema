function printReceiptPDF(){

  console.log('Click on printReceiptPDF');

  // Let say we are in a cut
  JsBarcode("#barcode", "000010423R", {
    width: 1.5,
    height: 85,
    displayValue: false
  });


  // Document of 210mm wide and 297mm high > A4
  // new jsPDF('p', 'mm', [297, 210]);
  // Here format A7
  let doc = new jsPDF('p', 'mm', [120, 75]);

  doc.setFont("Courier");
  doc.setFontType("bold");
  doc.setFontSize(9);
  doc.setTextColor(0, 0, 0);
  doc.text(18, 35, "BON DE REDUCTION 50%");


  doc.addImage(document.getElementById('logo-carte'), //img src
                'PNG', //format
                11, //x oddOffsetX is to define if position 1 or 2
                0, //y
                50, //Width
                16, null, 'FAST'); //Height // Fast is to get less big files


  doc.addImage(document.getElementById('barcode').src, //img src
                'PNG', //format
                12, //x oddOffsetX is to define if position 1 or 2
                60, //y
                50, //Width
                30, null, 'FAST'); //Height // Fast is to get less big files

  doc.setFontSize(14);
  doc.text(23, 53, '000010423R');

  doc.save('ReceiptUACEEM_Print');


  //$("body").removeClass("loading");
  //$("#screen-load").hide();
}

/**********************************************************/


function addPayUserExists(val){
  for (var i = 0; i < dataAllUSRNToJsonArray.length; i++) {
    if (dataAllUSRNToJsonArray[i].USERNAME === val) return true;
  }
  return false;
}

function addPayClear(){
  $('#addpay-ace').val('');
  $('#last-read-bc').html('');
  $("#valid-code-read").html('');
  $('#last-read-time').html('');
  $("#exist-code-read").html('N');
  $('#addpay-ace').show(100);

  $("#addp-mainop").hide(100);
  $("#addp-red-option").hide(100);
  $("#addPayClear").hide(100);

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

      let existsFound = ' not found NO !';
      if(addPayUserExists(readInput)){
        /********************************************************** FOUND **********************************************************/
        existsFound = ' found YES !';
        scanValidToDisplay = ' <i class="mgs-rd-o-in">&nbsp;Étudiant valide&nbsp;</i>';
        $("#exist-code-read").html('Y');
        $('#addpay-ace').hide(100);

        $("#addp-mainop").show(100);
      }
      else{
        /******************************************************** NOT FOUND ********************************************************/
        scanValidToDisplay = ' <i class="mgs-rd-o-err">&nbsp;Étudiant introuvable&nbsp;</i>';
      }
      $("#valid-code-read").html(readInput + existsFound);
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
      $("#addp-mainop").hide(100);
      $("#addp-red-option").show(300);

    });
    // Add a payment
    $( "#btn-addpay" ).click(function() {
      console.log("You click on #btn-addpay");
    });

    // Create the cut
    $( "#btn-addcut-1" ).click(function() {
      console.log("You click on #btn-addcut-1");

      $("#addp-print").show(300);

    });
    $( "#btn-addcut-2" ).click(function() {
      console.log("You click on #btn-addcut-2");

      $("#addp-print").show(300);
    });


    // PRINT BUTTON !!!
    $( "#addp-print" ).click(function() {
      console.log("You click on #addp-print");
      printReceiptPDF();


      // Then reclean all againt !!!
    });

  }
  else if($('#mg-graph-identifier').text() == 'xxx'){
    // Do something
  }
  else{
    //Do nothing
  }



});
