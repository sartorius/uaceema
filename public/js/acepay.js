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
  $("#btn-addpay").hide(100);
}

function verityAddPayContentScan(){
  // Do something
  let foundCode = $("#exist-code-read").html();
  if(foundCode == 'N'){
    $("#btn-addpay").hide(200);
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
        $("#btn-addpay").show(200);
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

    $( "#btn-addpay-clear" ).click(function() {
      addPayClear();
    });
  }
  else if($('#mg-graph-identifier').text() == 'xxx'){
    // Do something
  }
  else{
    //Do nothing
  }



});
