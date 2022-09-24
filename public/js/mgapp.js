function basicEncodeACE(str){
  return '123'+ str;
}

// Main PRINT PDF is here !

function printCarteEtudiantPDF(){

  console.log('Click on generatePrintedPDF');

  // Document of 210mm wide and 297mm high > A4
  // new jsPDF('p', 'mm', [297, 210]);
  // Here format A7
  let doc = new jsPDF('p', 'mm', [120, 70]);

  doc.setFont("Courier");
  doc.setFontType("bold");
  doc.setFontSize(9);
  doc.setTextColor(175,180,187);
  doc.text(15, 15, "Code barre d'assiduité");



  doc.addImage(document.getElementById('selfie'), //img src
                'JPG', //format
                20, //x oddOffsetX is to define if position 1 or 2
                20, //y
                30, //Width
                30, null, 'FAST'); //Height // Fast is to get less big files


  doc.addImage(document.getElementById('mask-selfie'), //img src
                'PNG', //format
                17, //x oddOffsetX is to define if position 1 or 2
                19, //y
                36, //Width
                32, null, 'FAST'); //Height // Fast is to get less big files


  doc.addImage(document.getElementById('barcode').src, //img src
                'PNG', //format
                10, //x oddOffsetX is to define if position 1 or 2
                70, //y
                50, //Width
                40, null, 'FAST'); //Height // Fast is to get less big files
  doc.setTextColor(48,91,159);
  doc.setFontSize(14);
  doc.text(20, 63, $('#id-username').html().toUpperCase());

  doc.addImage(document.getElementById('logo-carte'), //img src
                'PNG', //format
                42, //x oddOffsetX is to define if position 1 or 2
                110, //y
                25, //Width
                8, null, 'FAST'); //Height // Fast is to get less big files

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
  console.log('We are in MGAPP JS 1');

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
