function basicEncodeACE(str){
  return '123'+ str;
}

// Main PRINT PDF is here !

function printCarteEtudiantPDF(){
	//$("body").addClass("loading");
  //$("#screen-load").show();
  console.log('Click on generatePrintedPDF');

  //console.log('Element print read: mbc-' + i );
  // addImage(imageData, format, x, y, width, height, alias, compression, rotation)
  //console.log('here is i value: ' + i);


  /*
  html2canvas($('#blk-selfie'),{
  useCORS: true, //By passing this option in function Cross origin images will be rendered properly in the downloaded version of the PDF
  onrendered: function (canvas) {
   //your functions here
   var imgSelfie=canvas.toDataURL("image/png");

   window.open(imgSelfie);
  }
  });


  // Manage first the selfie
  html2canvas($('#blk-selfie'),{
        onrendered:function(canvas){

        var imgSelfie=canvas.toDataURL("image/png");

        window.open(imgSelfie);

        //var doc = new jsPDF('l', 'cm');

       }
    });
    */


  var doc = new jsPDF();
  doc.text(15, 15, $('#id-username').html());

  doc.addImage(document.getElementById('selfie'), //img src
                'JPG', //format
                20, //x oddOffsetX is to define if position 1 or 2
                20, //y
                150, //Width
                150, null, 'FAST'); //Height // Fast is to get less big files

  doc.addImage(document.getElementById('barcode').src, //img src
                'PNG', //format
                50, //x oddOffsetX is to define if position 1 or 2
                50, //y
                50, //Width
                40, null, 'FAST'); //Height // Fast is to get less big files

  //doc.addSvgAsImage(document.getElementById('mbc-1'), 50, 50, 200, 85);
  doc.save('CarteEtudiantUACEEM_Print');


  //$("body").removeClass("loading");
  //$("#screen-load").hide();
}

/****************************************   Up is for UACEEM    ****************************************/

function verityFieldNameRef(){
  if(($('#inputMG').val().length > 0)
            && ($('#inputMGCode').val().length > 0)){
      $("#btnVerify").prop('disabled', false);
  }
  else{
      $("#btnVerify").prop('disabled', true);
  }
}

function leftSideUtils(){
  // Do something
  $(".progress-bar").effect('slide', { direction: 'left', mode: 'show' });
}





$(document).ready(function() {
  console.log('We are in MGAPP JS');

  if($('#mg-graph-identifier').text() == 'ua-cartz'){
    // Do something on cartz
    let getBarcodeACE = basicEncodeACE($('#id-username').html());
    /*
    JsBarcode("#mbc-1", getBarcodeACE, {
      width: 1.5,
      height: 85,
      displayValue: false
    });
    */
    JsBarcode("#barcode", getBarcodeACE, {
      width: 1.5,
      height: 85,
      displayValue: false
    });

    let getUrlProfile = $('#mg-profile-url').text();
    new QRCode(document.getElementById("mbc-0"), { text: getUrlProfile, width: 200, height: 200 });

    $("#btn-print-bc").click(function() {
        printCarteEtudiantPDF();
    });


  }
  // We check here the graph **************************************************** OLD
  else if($('#mg-graph-identifier').text() == 'advert'){
    demo1();
    demo2();
    demo3();
  }
  else if($('#mg-graph-identifier').text() == 'traintest'){
    //Show message train test
    $(".mg-timer-red-train").show(800);
    leftSideUtils();
  }
  else if($('#mg-graph-identifier').text() == 'runtest'){
    // Read the received information here
    var initTimerRead = $("#mg-init-timer").text();
    var timerRead = $("#mg-fwd-timer").text();

    if(initTimerRead == 'Y'){
      sessionStorage.clear();
      runTestLogAction('Début du test: ');
    }
    //MG Counter include the first log
    counterManager(initTimerRead, timerRead);
    $( "#mg-rtest-fwd" ).click(function() {
        forwardBtnManager();
    });
    //MG Give Up
    $( "#mg-confirm-giveup" ).click(function() {
        runTestLogAction('Give up button click: ');
    });
    //MG Refresh

    //MG Progress bar
    leftSideUtils();
  }
  else if($('#mg-graph-identifier').text() == 'gotoresult'){
    leftSideUtils();
    goToResultGlobal();
  }
  else if($('#mg-graph-identifier').text() == 'verify'){
    verityFieldNameRef();
    //Work on button
    verifyFieldListener();
  }
  else if($('#mg-graph-identifier').text() == 'showtracefi'){
    getTraceRunTest();
  }
  else if($('#mg-graph-identifier').text() == 'example_qrcode'){
    new QRCode(document.getElementById("qrcode"), "http://jindo.dev.naver.com/collie");
  }
  else{
    //Do nothing
  }



});
