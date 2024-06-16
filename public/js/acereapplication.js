function verifyUsernameOrEmail(){
    //console.log('1');
    let canBeSave = 'Y';

    if(($('#pf-username').val().trim().length < 1) 
            && ($('#pf-email').val().trim().length < 1)){
        $("#disp-err-msg").html('Remplissez votre username ou votre email ou les deux.');
        canBeSave = 'N';
    }

    
    if(($('#pf-username').val().trim().length > 0)
            && (USERNAME_REG.test($('#pf-username').val().trim()))
            && (canBeSave == 'Y')){
      // If we dont have the exclamation we should be OK
      $("#disp-err-msg").html('&nbsp;');
    }
    else if(($('#pf-email').val().trim().length > 0)
            && ($('#pf-username').val().trim().length < 1)){
      // We do nothing because it is OK that email only is filled
      // But USERNAME must be empty
    }
    else{
      if(($('#pf-username').val().trim().length > 0)
            && (!(USERNAME_REG.test($('#pf-username').val().trim())))){
        $("#disp-err-msg").html('Le username doit être au format 7 lettes + 3 chiffres comme par exemple TSIKRAZ893');
      }
      else{
        //Do nothing
      }
      canBeSave = 'N';
    }
  
    if(($('#pf-email').val().trim().length > 0)
            && ((EMAIL_REG.test($('#pf-email').val().trim())))
            && (canBeSave == 'Y')){
      // If we dont have the exclamation we should be OK
      $("#disp-err-msg").html('&nbsp;');
    }
    else if(($('#pf-username').val().trim().length > 0)
                && ($('#pf-email').val().trim().length < 1)){
        // We do nothing because it is OK that USERNAME only is filled
        // But email must be empty
    }
    else{
      if(($('#pf-email').val().trim().length > 0)
            && (!(EMAIL_REG.test($('#pf-email').val().trim())))){
        $("#disp-err-msg").html('L\'email est au mauvais format');
      }
      else{
        //Do nothing
      }
      canBeSave = 'N';
    }

    // ----------------------
    //Final decition here
    if(canBeSave == 'Y'){
        $('#profile-save-btn').show(300);
    }
    else{
        $('#profile-save-btn').hide(300);
    }
    
    
}

function gotoStep1Reapp(){
    $("#fLocaleName").val(LOCALE_NAME);
    invEmail = $('#pf-email').val().trim().length > 0 ? $('#pf-email').val().trim() : 'na';
    invUsername = $('#pf-username').val().trim().length > 0 ? $('#pf-username').val().trim() : 'na';
    $('#pf-email').val("");
    $('#pf-username').val("");

    $("#fEmail").val(invEmail);
    $("#fUsername").val(invUsername);
    $("#mg-vs1-reapp-form").submit();
}


function gotoSubmitReappEnd(){
  console.log('gotoSubmitReappEnd');
  localStorage.setItem("LAST_REAPP_SUBMIT", FOUND_USERNAME);
  $("#fLocaleName").val(LOCALE_NAME);
  
  invEmail = $('#pf-email').val().trim();
  $('#pf-email').val("");

  invLastname = $('#pf-lastname').val().trim();
  $('#pf-lastname').val("");

  invFirstname = $('#pf-firstname').val().trim();
  $('#pf-firstname').val("");
  invOthfirstname = $('#pf-othfirstname').val().trim();
  $('#pf-othfirstname').val("");
  invMatricule = $('#pf-matricule').val().trim();
  $('#pf-matricule').val("");
  invTelstu = $('#pf-telstu').val().trim();
  $('#pf-telstu').val("");

  $("#fUsername").val(FOUND_USERNAME);

  $("#fEmail").val(invEmail);
  $("#fLastname").val(invLastname);
  $("#fFirstname").val(invFirstname);
  $("#fOthfirstname").val(invOthfirstname);
  $("#fMatricule").val(invMatricule);
  $("#fTelstu").val(invTelstu);

  $("#fLivingconfiguration").val(invModifyLivingConfiguration);
  $("#fClasseid").val(tempClasseID);
  $("#fMakeUp").val(invMakeUpCode);

  $("#mg-sub-reapp-form").submit();
}
/************************************************************/
/************************************************************/
/************************************************************/
/************************************************************/
/************************************************************/
/************************************************************/
/************************************************************/
/************************************************************/


function updateProfStatus(activeId){
  invModifyLivingConfiguration = $('#' + activeId).val();
  $('.stt-group').removeClass('active');  // Remove any existing active classes
  $('#' + activeId).addClass('active'); // Add the class to the nth element
  manageSaveChangeReappBtn();
}

function fillCartoucheMentionProfile(){
  let listMention = '';
  for(let i=0; i<DATA_GET_ALL_MENTION_ToJsonArray.length; i++){
      listMention = listMention + '<a class="dropdown-item" onclick="selectMentionProfile(\'' + DATA_GET_ALL_MENTION_ToJsonArray[i].par_code + '\', \'' + DATA_GET_ALL_MENTION_ToJsonArray[i].title.substring(0, 30) + '\')" >' + DATA_GET_ALL_MENTION_ToJsonArray[i].title.substring(0, 30) + '</a>';
  }
  $('#dpmention-opt').html(listMention);
}

function selectMentionProfile(str, strTitle){
  tempMentionCode = str;
  tempMention = strTitle;
  $('#drp-select').html(strTitle);
  //console.log('You have just click on: ' + str);
  // We reset the dropdown
  selectClasseProfile(0, 'Classe', 0);
  fillCartoucheClasseProfile();
}

function selectMakeUpReapp(param, paramTitle){
  $('#drp-select-makeup').html(paramTitle);
  invMakeUpCode = param;
}

function fillCartoucheClasseProfile(){
  let listClasse = '';
  for(let i=0; i<DATA_GET_ALL_CLASS_ToJsonArray.length; i++){
    if(DATA_GET_ALL_CLASS_ToJsonArray[i].VCC_MENTION_CODE == tempMentionCode){
      listClasse = listClasse + '<a class="dropdown-item" onclick="selectClasseProfile(' + DATA_GET_ALL_CLASS_ToJsonArray[i].VCC_ID + ', \'' + DATA_GET_ALL_CLASS_ToJsonArray[i].VCC_SHORT_CLASSE + '\')" >' + DATA_GET_ALL_CLASS_ToJsonArray[i].VCC_SHORT_CLASSE + '</a>';
    }
  }
  $('#dpclasse-opt').html(listClasse);
}


function getClassShortClasse(paramId){
  for(let i=0; i<DATA_GET_ALL_CLASS_ToJsonArray.length; i++){
    if(DATA_GET_ALL_CLASS_ToJsonArray[i].VCC_ID == paramId){
      return DATA_GET_ALL_CLASS_ToJsonArray[i].VCC_SHORT_CLASSE;
    }
  }
  return 'ERR892CD'
}


function selectClasseProfile(classeId, str){
  tempClasseID = classeId;
  tempClasse = str;
  $("#selected-class").html(str);
  if(classeId == 0){
    $("#inv-class-txt").html('');
  }
  else{
    $("#inv-class-txt").html(str);
  }
  manageSaveChangeReappBtn();
}


function manageSaveChangeReappBtn(){
  if(FOUND_USERNAME != 'na'){
    usernameFoundManageSaveChangeReappBtn();
  }
  else{
    // Not found so we do nothing
  }
}

function usernameFoundManageSaveChangeReappBtn(){
  let canBeSave = 'Y';

  
  //console.log('See 1 canBeSave: ' + canBeSave);
  if(($('#pf-lastname').val().length > 0) 
          && (canBeSave == 'Y')){
      $(".mgs-note-nopad-err").html('');
  }
  else{
    if($('#pf-lastname').val().length == 0){
      $(".mgs-note-nopad-err").html('');
      $("#lastname-disp-err-msg").html('Votre nom de famille ne peux être vide.');
    }
    canBeSave = 'N';
  }



  //console.log('See 2 canBeSave: ' + canBeSave);
  if(($('#pf-email').val().trim().length > 0) 
          && (EMAIL_REG.test($('#pf-email').val().trim()))
          && (canBeSave == 'Y')){
    // If we dont have the exclamation we should be OK
    $(".mgs-note-nopad-err").html('');
  }
  else{
    if($('#pf-email').val().trim().length == 0){
      $(".mgs-note-nopad-err").html('');
      $("#email-disp-err-msg").html('Votre email ne peux être vide.');
    }
    else if(!(EMAIL_REG.test($('#pf-email').val().trim()))){
      $(".mgs-note-nopad-err").html('');
      $("#email-disp-err-msg").html('Votre email est au mauvais format.');
    }
    else{
      //Do nothing
    }
    canBeSave = 'N';
  }

  //console.log('See 2 canBeSave: ' + canBeSave);
  if(($('#pf-firstname').val().trim().length > 0) 
          && (!(/\s/.test($('#pf-firstname').val().trim())))
          && (canBeSave == 'Y')){
    // If we dont have the exclamation we should be OK
    $(".mgs-note-nopad-err").html('');
  }
  else{
    if($('#pf-firstname').val().trim().length == 0){
      $(".mgs-note-nopad-err").html('');
      $("#firstname-disp-err-msg").html('Votre premier prénom ne peux être vide.');
    }
    else if((/\s/.test($('#pf-firstname').val().trim()))){
      $(".mgs-note-nopad-err").html('');
      $("#firstname-disp-err-msg").html('Votre premier prénom est le prénom d\'usage ne peut contenir un espace. Ajoutez les autres prénoms dans le champs [Autre prénoms].');
    }
    else{
      //Do nothing
    }
    canBeSave = 'N';
  }

  //console.log('See 3 canBeSave: ' + canBeSave);
  if(($('#pf-matricule').val().length > 0) 
          && (/[0-9]+\/(GE|DT|ECO|CO|IE|RI|SS|BBA)\/(IèA|IIèA|IIIèA|IVèA|VèA)/.test($('#pf-matricule').val()))
          && (canBeSave == 'Y')){
    // If we dont have the exclamation we should be OK
    $(".mgs-note-nopad-err").html('');
  }
  else{
    if($('#pf-matricule').val().length == 0){
      $(".mgs-note-nopad-err").html('');
      $("#matricule-disp-err-msg").html('Votre matricule ne peux être vide.');
    }
    else if(!(/[0-9]+\/(GE|DT|ECO|CO|IE|RI|SS|BBA)\/(IèA|IIèA|IIIèA|IVèA|VèA)/.test($('#pf-matricule').val()))){
      $(".mgs-note-nopad-err").html('');
      $("#matricule-disp-err-msg").html('Le matricule n\'est pas au format NN/XX/IIèA ou NN/XX/IIIèA<br>NN > Nombre<br>XX > DT: Droit; ECO: Économie; CO: Communication; IE: Informatique & Électronique; RI: Relations Internationales & Diplomatie; SS: Sciences de la Santé; BBA: Bachelor of Business Administration.');
    }
    else{
      //Do nothing
    }
    canBeSave = 'N';
  }

  //console.log('See 4 canBeSave: ' + canBeSave);
  if(($('#pf-telstu').val().length > 0) 
          && (/(033|034|032|037|038)[0-9]{7}$/.test($('#pf-telstu').val()))
          && (canBeSave == 'Y')){
    // If we dont have the exclamation we should be OK
    $(".mgs-note-nopad-err").html('');
  }
  else{
    if($('#pf-telstu').val().length == 0){
      $(".mgs-note-nopad-err").html('');
      $("#telstu-disp-err-msg").html('Votre téléphone ne peux être vide.');
    }
    else if(!(/(033|034|032|037|038)[0-9]{7}$/.test($('#pf-telstu').val()))){
      $(".mgs-note-nopad-err").html('');
      $("#telstu-disp-err-msg").html('Votre téléphone n\'est pas au format 03XNNNNNNN.');
    }
    else{
      //Do nothing
    }
    canBeSave = 'N';
  }

  if((tempClasseID > 0)
    && (canBeSave == 'Y')){
      $(".mgs-note-nopad-err").html('');
  }
  else{
    if((tempClasseID == 0)){
      $(".mgs-note-nopad-err").html('');
      $("#disp-err-msg-1").html('Veuillez choisir votre classe pour la nouvelle année');
    }
    canBeSave = 'N';
  }

  //console.log('See 7 canBeSave: ' + canBeSave);
  // ----------------------
  //Final decition here
  if(canBeSave == 'Y'){
    $('#profile-save-btn').show(100);
  }
  else{
    $('#profile-save-btn').hide(100);
  }
}

function initVReapp(){
    $( ".stt-group" ).click(function() {
      updateProfStatus(this.id);
    });
    updateProfStatus('stt-'+invModifyLivingConfiguration.toLowerCase());
    fillCartoucheMentionProfile();
}
/************************************************************/
/************************************************************/
/************************************************************/
/************************************************************/
/************************************************************/
/************************************************************/
/************************************************************/
/************************************************************/

$(document).ready(function() {
    console.log('We are in ACE-REAPP');
    if($('#mg-graph-identifier').text() == 'f-reapp'){
      // Do something
      console.log('in f-reapp');
      // Clear the data to avoid preivous
      // Reset everything here
      localStorage.removeItem("LAST_REAPP_SUBMIT");
      if($('#pf-email').val().trim().length > 0){
        $('#pf-email').val("");
      }
      if($('#pf-username').val().trim().length > 0){
        $('#pf-username').val("");
      }
    }
    else if($('#mg-graph-identifier').text() == 'v-reapp'){
      //We have to check first if the data are pre-filled or not. If not we have to show error
      //If all these data are empty then we need to display an error
      let getLastSubmit = localStorage.getItem("LAST_REAPP_SUBMIT");
      if(getLastSubmit == FOUND_USERNAME){
          //Then we may have been previous because we have already submit this username
          $('#found-form').hide(100);
          $('#not-found-form').show(100);
          console.log('prev');
      }
      else{
        $('#found-form').show(100);
        $('#not-found-form').hide(100);
        console.log('no prev getLastSubmit: ' + getLastSubmit);
        initVReapp();
      }
    }
    else{
      //Do nothing
    }
  
});