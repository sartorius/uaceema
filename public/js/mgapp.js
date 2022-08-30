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

  // We check here the graph
  if($('#mg-graph-identifier').text() == 'advert'){
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
