// Global variable
var distance = 0;
// 5 secondes save to prevent reload
var increment5 = 0;
const logTime5 = 5;

function runTestLogAction(tracelog){
    var iterator = sessionStorage.getItem("traceAction");
    //console.log('value of iterator');
    //console.log(iterator);
    if(iterator == null){
      iterator = 0;
    }
    var dateobj = new Date();
    sessionStorage.setItem('trace_' + iterator, tracelog + ' <i class="mg-main-color">' + dateobj.toString() + '</i>');
    iterator = parseInt(iterator) + 1;
    sessionStorage.setItem("traceAction", iterator);
}

function getTraceRunTest(){
  var iterator = sessionStorage.getItem("traceAction");
  var msg_log = '';
  if(iterator != null){
    for(var i=0; i<parseInt(iterator); i++){
      var readTrace = sessionStorage.getItem('trace_' + i);
      msg_log = msg_log + 'T' + i + ' > ' + readTrace + '<br>';
    }
    $('#mg-invest-log').html(msg_log);
  }
  //console.log(msg_log);
}

function counterManager(initTimerRead, timerRead){

    if(initTimerRead == 'Y'){
      // Set the date we're counting down to
      //var countDownDate = new Date("Apr 24, 2022 21:37:25").getTime();
      var d = new Date();
      d.setMinutes(d.getMinutes() + 5);
    }
    else{
      // Here we add the timer to the countdown
      var d = new Date
      // In case of refresh we need to get the minus timer left
      var leftTimer = sessionStorage.getItem("logTimer", distance);
      if ((leftTimer != null) && (parseInt(leftTimer) < parseInt(timerRead))){
        runTestLogAction('Ajustement/' + $('#demo').html() + ' : ');
        d.setMilliseconds(d.getMilliseconds() + parseInt(leftTimer));
      }
      else{
        d.setMilliseconds(d.getMilliseconds() + parseInt(timerRead));
      }
    }
    var countDownDate = d.getTime();

    // Update the count down every 1 second
    var x = setInterval(function() {

      // Get today's date and time
      var now = new Date().getTime();

      // Find the distance between now and the count down date
      distance = countDownDate - now;
      // 10min = 598999 - 9min = 540000 - 4min = 240000
      if(distance < 240000){
          $(".mg-timer-red").show(800);
      }

      if(increment5<logTime5){
        increment5++;
      }
      else{
        increment5 = 0;
        sessionStorage.setItem("logTimer", distance);
      }
      // Time calculations for days, hours, minutes and seconds
      var days = Math.floor(distance / (1000 * 60 * 60 * 24));
      var hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
      var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
      var seconds = Math.floor((distance % (1000 * 60)) / 1000);

      // Display the result in the element with id="demo"
      // document.getElementById("demo").innerHTML = days + "d " + hours + "h " + minutes + "m " + seconds + "s ";
      document.getElementById("demo").innerHTML = hours + "h " + minutes + "m " + seconds + "s ";
      $(".mg-timer").show(800);
      // If the count down is finished, write some text
      if (distance < 0) {
        clearInterval(x);
        document.getElementById("demo").innerHTML = "EXPIRED";
        $("#inputMGRTTime").val(0);
        runTestLogAction('Temps écoulé: ');
        runTestLogAction('Submit automatique: ');
        $( "#mg-current-form" ).submit();
      }
    }, 1000);
}

function forwardBtnManager(){
  //console.log('You can see the distance: ' + distance + ' initTimerRead: ' + initTimerRead + ' timerRead: ' + timerRead);
  $("#inputMGRTTime").val(distance);
  runTestLogAction('Click sur fwd: ');
  runTestLogAction('Temps/' + $('#demo').html() + ' : ');
}
