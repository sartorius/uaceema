//***********************************************************************************************************
//***********************************************************************************************************
//***********************************************************************************************************
//***********************************************************************************************************
//***********************************************************************************************************
//***********************************************************************************************************
//***********************************************************************************************************
//***********************************************************************************************************
//***********************************************************************************************************
//***********************************************************************************************************
function generateTeacherModifyCreateDB(){
  $('#tea-details-modal').modal('hide');

  // This is fed already: invArrayId = getArrayDataAllTEAToJsonArrayId(paramId);
  // This is fed already: invId = paramId;
  // This is fed already: invTitle = dataAllTEAToJsonArray[invArrayId].title;
  let tempAllMentionCode = "";
  for(let i=0; i<ARRAY_REF_MENTION_CODE.length; i++){
    if(document.getElementById("id-" + ARRAY_REF_MENTION_CODE[i].par_code).checked){
      tempAllMentionCode = tempAllMentionCode + ARRAY_REF_MENTION_CODE[i].par_code.toUpperCase() + "/";
    }
  }
  invTEA_ALL_MENTION_CODE = tempAllMentionCode;


  // This is fed already: invContract = (dataAllTEAToJsonArray[invArrayId].contract == null ? 'PRF' : dataAllTEAToJsonArray[invArrayId].contract);
  // invContract_label = dataAllTEAToJsonArray[invArrayId].contract_label;
  invEmail = $('#pf-email').val();
  invFirstname = removeAllQuotes(getCapitalize($('#pf-firstname').val().trim()));
  invLastname = removeAllQuotes($('#pf-lastname').val().toUpperCase().trim());
  invOtherFirstname = removeAllQuotes(getCapitalize($('#pf-othfirstname').val().trim()));
  invPhoneAlt = $('#pf-telalt').val();
  invPhoneMain = $('#pf-telmain').val();
  invComment = removeAllQuotes($('#pf-noteass').val());
  invName = removeAllQuotes(getTitleAbbreviation(invTitle) + " " + invLastname.toUpperCase() + " " + getCapitalize(invFirstname) + " " + getCapitalize((invOtherFirstname == null ? "" : invOtherFirstname)).trim());
  if(invMode == 'C'){
    invId = 0;
  }

  $.ajax('/generateTeacherModifyCreateDB', {
      type: 'POST',  // http method
      data: {
        currentAgentIdStr: CURRENT_AGENT_ID_STR,
        paramId: invId,
        paramTitle: invTitle,
        // The kind of array mySQL can handle is seperated comma
        paramTeaAllMentionCode: invTEA_ALL_MENTION_CODE.replaceAll("/", ","),
        paramEmail: invEmail,
        paramName: invName,
        paramFirstname: invFirstname,
        paramOtherfirstname: invOtherFirstname,
        paramLastname: invLastname,
        paramPhoneAlt: invPhoneAlt,
        paramPhoneMain: invPhoneMain,
        paramComment: invComment,
        paramContract: invContract,
        paramMode: invMode,
        token: GET_TOKEN
      },  // data to submit
      success: function (data, status, xhr) {
        $('#msg-alert').html(invName + " a été modifié avec succés.");
        $('#type-alert').addClass('alert-primary').removeClass('alert-danger');
        $('#ace-alert-msg').show(100);
        $('#ace-alert-msg').hide(1000*7);

        /**
         * DO THE FEEDBACK OPERATION
         */

        // Update the data in the grid for dirtymode
        if(invMode == 'E'){
          dataAllTEAToJsonArray[invArrayId].IS_DIRTY = 'Y';
          dataAllTEAToJsonArray[invArrayId].title = invTitle;
          dataAllTEAToJsonArray[invArrayId].TEA_ALL_MENTION_CODE = invTEA_ALL_MENTION_CODE;
          
          dataAllTEAToJsonArray[invArrayId].contract = invContract;
          dataAllTEAToJsonArray[invArrayId].contract_label = getContractLabel(invContract);
          dataAllTEAToJsonArray[invArrayId].email = invEmail;
          dataAllTEAToJsonArray[invArrayId].name = invName;
          dataAllTEAToJsonArray[invArrayId].firstname = invFirstname;
          dataAllTEAToJsonArray[invArrayId].lastname = invLastname;
          dataAllTEAToJsonArray[invArrayId].other_firstname = invOtherFirstname;
          dataAllTEAToJsonArray[invArrayId].phone_alt = invPhoneAlt;
          dataAllTEAToJsonArray[invArrayId].phone_main = invPhoneMain;
          dataAllTEAToJsonArray[invArrayId].teacher_info = invComment;
          loadAllTeaGrid();
        }
        else{
          // We assume we are in a creation mode
          let newTeacherId = parseInt(data['result']);
          let myNewTeacher = {	  
                            TEA_ID: newTeacherId,
                            IS_DIRTY:  'Y',
                            agent_id: 0,
                            title:  invTitle,
                            MANSUM_M_SHIFT_DURATION: "0",
                            MANSUM_P_SHIFT_DURATION: "0",
                            TEA_ALL_MENTION_CODE:  invTEA_ALL_MENTION_CODE,
                            contract:  invContract,
                            contract_label:  getContractLabel(invContract),
                            email:  invEmail,
                            name:  invName,
                            firstname:  invFirstname,
                            lastname:  invLastname,
                            other_firstname:  invOtherFirstname,
                            phone_alt:  invPhoneAlt,
                            phone_main:  invPhoneMain,
                            teacher_info:  invComment,
                            create_date: "",
                            last_update: "",
                            raw_data: newTeacherId + invName.toUpperCase() + invTEA_ALL_MENTION_CODE
                            };
          dataAllTEAToJsonArray.unshift(myNewTeacher);
          clearDataAllTea();
        }

      },
      error: function (jqXhr, textStatus, errorMessage) {
        $('#msg-alert').html("ERR917T: " + invName + " modification enseignant impossible, contactez le support. ");
        $('#type-alert').removeClass('alert-primary').addClass('alert-danger');
        $('#ace-alert-msg').show(100);
      }
  });
}


/**************************************************/
/**************************************************/
/**************************************************/
/**************************************************/
/**************************************************/



function updateTeaSTTStatus(activeId){
  invContractHTMLCode = $('#' + activeId).val();
  $('.stt-group').removeClass('active');  // Remove any existing active classes
  $('#' + activeId).addClass('active'); // Add the class to the nth element
  manageSaveChangeProfBtn();
}

function updateTeaTITStatus(activeId){
  invTitleHTMLCode = $('#' + activeId).val();
  $('.tit-group').removeClass('active');  // Remove any existing active classes
  $('#' + activeId).addClass('active'); // Add the class to the nth element
  manageSaveChangeProfBtn();
}

function manageSaveChangeProfBtn(){
  let canBeSave = 'Y';

  
  //console.log('See 1 canBeSave: ' + canBeSave);
  if(($('#pf-lastname').val().length > 0) 
          && (canBeSave == 'Y')){
    $("#disp-err-msg").html('');
  }
  else{
    if($('#pf-lastname').val().length == 0){
      $("#disp-err-msg").html('Le nom de famille ne peux être vide.');
    }
    canBeSave = 'N';
  }

  //console.log('See 2 canBeSave: ' + canBeSave);
  if(($('#pf-firstname').val().trim().length > 0) 
          && (!(/\s/.test($('#pf-firstname').val().trim())))
          && (canBeSave == 'Y')){
    // If we dont have the exclamation we should be OK
    $("#disp-err-msg").html('');
  }
  else{
    if($('#pf-firstname').val().trim().length == 0){
      $("#disp-err-msg").html('Le prénom ne peux être vide.');
    }
    else if((/\s/.test($('#pf-firstname').val().trim()))){
      $("#disp-err-msg").html('Le premier prénom est le prénom d\'usage ne peut contenir un espace. Ajoutez les autres prénoms dans le champs Autre prénoms.');
    }
    else{
      //Do nothing
    }
    canBeSave = 'N';
  }

  //console.log('See 2 canBeSave: ' + canBeSave);
  if(($('#pf-email').val().trim().length > 0) 
          && ((EMAIL_REG.test($('#pf-email').val().trim())))
          && (canBeSave == 'Y')){
    // If we dont have the exclamation we should be OK
    $("#disp-err-msg").html('');
  }
  else{
    if($('#pf-email').val().trim().length == 0){
      $("#disp-err-msg").html('L\'email ne peut pas être vide.');
    }
    else if(!(EMAIL_REG.test($('#pf-email').val().trim()))){
      $("#disp-err-msg").html('L\'email est au mauvais format.');
    }
    else{
      //Do nothing
    }
    canBeSave = 'N';
  }


  
  //console.log('See 4 canBeSave: ' + canBeSave);
  if(($('#pf-telmain').val().length > 0) 
          && (/(033|034|032|037|038)[0-9]{7}$/.test($('#pf-telmain').val()))
          && (canBeSave == 'Y')){
    // If we dont have the exclamation we should be OK
    $("#disp-err-msg").html('');
  }
  else{
    if($('#pf-telmain').val().length == 0){
      $("#disp-err-msg").html('Le téléphone principal ne peux être vide.');
    }
    else if(!(/(033|034|032|037|038)[0-9]{7}$/.test($('#pf-telmain').val()))){
      $("#disp-err-msg").html('Le téléphone principal n\'est pas au format 03XNNNNNNN');
    }
    else{
      //Do nothing
    }
    canBeSave = 'N';
  }

  //console.log('See 6 canBeSave: ' + canBeSave);
  if((($('#pf-telalt').val().length > 0) 
          && (/(033|034|032|037|038)[0-9]{7}$/.test($('#pf-telalt').val()))
          && ($('#pf-telmain').val() != $('#pf-telalt').val())
          && (canBeSave == 'Y'))
      || (($('#pf-telalt').val().length == 0)
            && (canBeSave == 'Y')
          )
          ){
    // If we dont have the exclamation we should be OK
    $("#disp-err-msg").html('');
  }
  else{
    if(($('#pf-telalt').val().length > 0)
        && (!(/(033|034|032|037|038)[0-9]{7}$/.test($('#pf-telalt').val())))
      ){
      $("#disp-err-msg").html('Le téléphone alternatif n\'est pas au format 03XNNNNNNN');
    }
    else if(($('#pf-telmain').val() == $('#pf-telalt').val())
              && ($('#pf-telalt').val().length > 0)
            ){
      $("#disp-err-msg").html('Le téléphone alternatif doit être différent du téléphone principal ou vide');
    }
    else{
      //Do nothing
    }
    canBeSave = 'N';
  }

  if(canBeSave == 'Y'){
    //Here we check if at least one is checked
    canBeSave = verifyIfAtLeastOneMentionIsChecked();
    if(canBeSave == 'N'){
      $("#disp-err-msg").html('Au moins une des mentions doit être selectionnée');
    }
  }

  // Update InvTitle & invContract
  switch(invTitleHTMLCode) {
    case 'O':
      // code block
      invTitle = 'MON';
      break;
    case 'A':
      // code block
      invTitle = 'MAD';
      break;
    case 'P':
      // code block
      invTitle = 'PRF';
      break;
    case 'D':
      // code block
      invTitle = 'DOC';
      break;
    case 'M':
      // code block
      invTitle = 'MAI';
      break;
    default:
      invTitle = 'MON';
      // console.log('Go on default WAR9283');
      // code block
  }
  switch(invContractHTMLCode) {
    case 'P':
      // code block
      invContract = 'PRF';
      break;
    case 'A':
      // code block
      invContract = 'ASS';
      break;
    case 'T':
      // code block
      invContract = 'TIT';
      break;
    case 'C':
      // code block
      invContract = 'CON';
      break;
    case 'M':
      // code block
      invContract = 'MAI';
      break;
    case 'E':
      // code block
      invContract = 'EXP';
      break;
    case 'O':
      // code block
      invContract = 'OTH';
      break;
    default:
      invContract = 'PRF';
      // console.log('Go on default WAR087');
      // code block
  }

  // Vérify there is no duplicate
  if(canBeSave == 'Y'){
    let duplicateNames = "";
    for(let i=0; i<dataAllTEAToJsonArray.length; i++){
      //We must check the other cases not the same ID
      if(dataAllTEAToJsonArray[i].TEA_ID != invId){
        if(((dataAllTEAToJsonArray[i].lastname.toUpperCase() + dataAllTEAToJsonArray[i].firstname.toUpperCase()) 
              == ($('#pf-lastname').val().toUpperCase() + $('#pf-firstname').val().toUpperCase()))
            && (dataAllTEAToJsonArray[i].title == invTitle)){
                duplicateNames = duplicateNames + " - " + dataAllTEAToJsonArray[i].TEA_ID + "/" + dataAllTEAToJsonArray[i].title.toUpperCase() + " " + dataAllTEAToJsonArray[i].lastname.toUpperCase() + " " + dataAllTEAToJsonArray[i].firstname.toUpperCase();
        }
      }
    }
    if(duplicateNames.length > 0){
      //We found duplicates
      canBeSave = 'N';
      $("#disp-err-msg").html("Impossible de sauvegarder : un ou des professeurs du même nom existe déjà. Contactez-nous si vous considérez que c'est une erreur.<br>" + duplicateNames);
    }
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

function verifyIfAtLeastOneMentionIsChecked(){
  let isOneChecked = 'N';
  for(let i=0; i<ARRAY_REF_MENTION_CODE.length; i++){
    if(document.getElementById("id-" + ARRAY_REF_MENTION_CODE[i].par_code).checked){
        return 'Y';
    }
  }
  return isOneChecked;
}
/**********************************************************/
/**********************************************************/
/**********************************************************/

function modifyTeacherPopUp(){
  //console.log('You clicked on modifyProfile');
  $('#tea-details-modal').modal('show');
}

function showTeacherPopUpReadOnly(){
  $('#tea-details-modal-readonly').modal('show');
}

function hydrateMyTeacherReadOnly(paramId){
  invMode = "N";
  console.log("hydrateMyTeacherReadOnly");
  invArrayId = getArrayDataAllTEAToJsonArrayId(paramId);

  invId = paramId;
  invTitle = dataAllTEAToJsonArray[invArrayId].title;
  invTEA_ALL_MENTION_CODE = dataAllTEAToJsonArray[invArrayId].TEA_ALL_MENTION_CODE;

  invContract = dataAllTEAToJsonArray[invArrayId].contract;
  //invContract_label = dataAllTEAToJsonArray[invArrayId].contract_label;
  invEmail = dataAllTEAToJsonArray[invArrayId].email;
  invName = dataAllTEAToJsonArray[invArrayId].name;
  invFirstname = dataAllTEAToJsonArray[invArrayId].firstname;
  invLastname = dataAllTEAToJsonArray[invArrayId].lastname;
  invOtherFirstname = dataAllTEAToJsonArray[invArrayId].other_firstname;
  invPhoneAlt = dataAllTEAToJsonArray[invArrayId].phone_alt;
  invPhoneMain = dataAllTEAToJsonArray[invArrayId].phone_main;
  invComment = dataAllTEAToJsonArray[invArrayId].teacher_info;

  $('#title-stu-details-readonly').html('ID: ' + invId + ' - ' + invName);
  
  $('#ro-lastname').html(invLastname);
  $('#ro-firstname').html(invFirstname);
  $('#ro-othfirstname').html(invOtherFirstname == null ? 'na' : invOtherFirstname);

  $('#ro-telmain').html(invPhoneMain == null ? 'Manquant' : invPhoneMain);
  $('#ro-telalt').html(invPhoneAlt == null ? 'na' : invPhoneAlt);
  $('#ro-email').html((invEmail == null ? 'Manquant' : invEmail));
  $('#ro-noteass').html(invComment == null ? 'na' : invComment);
  $('#ro-mentions').html(invTEA_ALL_MENTION_CODE);

  switch(invTitle) {
    case 'MON':
      // code block
      $('#ro-title').html('Monsieur');
      break;
    case 'MAD':
      // code block
      $('#ro-title').html('Madame');
      break;
    case 'PRF':
      // code block
      $('#ro-title').html('Professeur');
      break;
    case 'DOC':
      // code block
      $('#ro-title').html('Docteur');
      break;
    case 'MAI':
      // code block
      $('#ro-title').html('Maître');
      break;
    default:
      console.log('ERR9280');
      // code block
  }

  switch(invContract) {
    case 'PRF':
      // code block
      $('#ro-contract').html('Professeur');
      break;
    case 'ASS':
      // code block
      $('#ro-contract').html('Assistant');
      break;
    case 'TIT':
      // code block
      $('#ro-contract').html('Titulaire');
      break;
    case 'CON':
      // code block
      $('#ro-contract').html('Consultant');
      break;
    case 'MAI':
      // code block
      $('#ro-contract').html('Maître de conférence');
      break;
    case 'EXP':
      // code block
      $('#ro-contract').html('Exceptionnel');
      break;
    case 'OTH':
      // code block
      $('#ro-contract').html('Autre');
      break;
    case null:
      // code block
      $('#ro-contract').html('Manquant');
      break;
    default:
      console.log('ERR081');
      // code block
  }
}
function hydrateMyTeacher(paramId){
  invMode = "E";

  invArrayId = getArrayDataAllTEAToJsonArrayId(paramId);

  invId = paramId;
  invTitle = dataAllTEAToJsonArray[invArrayId].title;
  invTEA_ALL_MENTION_CODE = dataAllTEAToJsonArray[invArrayId].TEA_ALL_MENTION_CODE;


  blockTEA_UEL_ALL_MENTION_CODE = dataAllTEAToJsonArray[invArrayId].UEL_TEA_MENTION;
  blockTEA_UGM_ALL_MENTION_CODE = dataAllTEAToJsonArray[invArrayId].UGM_TEA_MENTION;
  
  invContract = (dataAllTEAToJsonArray[invArrayId].contract == null ? 'PRF' : dataAllTEAToJsonArray[invArrayId].contract);
  //invContract_label = dataAllTEAToJsonArray[invArrayId].contract_label;
  invEmail = dataAllTEAToJsonArray[invArrayId].email;
  invName = dataAllTEAToJsonArray[invArrayId].name;
  invFirstname = dataAllTEAToJsonArray[invArrayId].firstname;
  invLastname = dataAllTEAToJsonArray[invArrayId].lastname;
  invOtherFirstname = dataAllTEAToJsonArray[invArrayId].other_firstname;
  invPhoneAlt = dataAllTEAToJsonArray[invArrayId].phone_alt;
  invPhoneMain = dataAllTEAToJsonArray[invArrayId].phone_main;
  invComment = dataAllTEAToJsonArray[invArrayId].teacher_info;

  $('#title-stu-details').html('ID: ' + invId + ' - ' + invName);
  
  $('#pf-lastname').val(invLastname);
  $('#pf-firstname').val(invFirstname);
  $('#pf-othfirstname').val(invOtherFirstname);

  $('#pf-telmain').val(invPhoneMain);
  $('#pf-telalt').val(invPhoneAlt);
  $('#pf-email').val(invEmail);
  $('#pf-noteass').val(invComment);



  // INITIALISATION OF ALL CHECK BOX
  //Manage mention list
  for(let j=0; j<ARRAY_REF_MENTION_CODE.length; j++){
    document.getElementById("id-" + ARRAY_REF_MENTION_CODE[j].par_code).checked = false;
    document.getElementById("id-" + ARRAY_REF_MENTION_CODE[j].par_code).disabled = false;
  }
  let listOfMentionCode = invTEA_ALL_MENTION_CODE.split('/');
  for(let i=0; i<listOfMentionCode.length; i++){
    if(listOfMentionCode[i].length > 0){
      document.getElementById("id-" + listOfMentionCode[i]).checked = true;
    }
    else{
      // Do nothing. In the simple case, there will be an end separator
    }
  }

  // Now we have to block if any course uel or exam is passed
  // blockTEA_UEL_ALL_MENTION_CODE blockTEA_UGM_ALL_MENTION_CODE
  disableHydrateBlockedCheckbox(blockTEA_UEL_ALL_MENTION_CODE);
  disableHydrateBlockedCheckbox(blockTEA_UGM_ALL_MENTION_CODE);

  // Handle the specific option cases updateProfStatus('stt-'+invModifyLivingConfiguration.toLowerCase());
  /*
  <button id="tit-o" type="button" value="O" class="btn btn-outline-secondary tit-group active">Monsieur</button>
                            <button id="tit-a" type="button" value="A" class="btn btn-outline-secondary tit-group">Madame</button>
                            <button id="tit-p" type="button" value="P" class="btn btn-outline-secondary tit-group">Professeur</button>
                            <button id="tit-d" type="button" value="D" class="btn btn-outline-secondary tit-group">Docteur</button>
                            <button id="tit-m" type="button" value="M" class="btn btn-outline-secondary tit-group">Maître</button>
  */
  switch(invTitle) {
    case 'MON':
      // code block
      updateTeaTITStatus('tit-o');
      break;
    case 'MAD':
      // code block
      updateTeaTITStatus('tit-a');
      break;
    case 'PRF':
      // code block
      updateTeaTITStatus('tit-p');
      break;
    case 'DOC':
      // code block
      updateTeaTITStatus('tit-d');
      break;
    case 'MAI':
      // code block
      updateTeaTITStatus('tit-m');
      break;
    default:
      console.log('ERR9280');
      // code block
  }

  /*
  <button id="stt-p" type="button" value="P" class="btn btn-outline-secondary stt-group active">Professeur</button>
                            <button id="stt-a" type="button" value="A" class="btn btn-outline-secondary stt-group">Assistant</button>
                            <button id="stt-t" type="button" value="T" class="btn btn-outline-secondary stt-group">Titulaire</button>
                            <button id="stt-c" type="button" value="C" class="btn btn-outline-secondary stt-group">Consultant</button>
                            <button id="stt-m" type="button" value="M" class="btn btn-outline-secondary stt-group">Maître de conférence</button>
                            <button id="stt-e" type="button" value="E" class="btn btn-outline-secondary stt-group">Exceptionnel</button>
                            <button id="stt-o" type="button" value="O" class="btn btn-outline-secondary stt-group">Autre</button>
  */
  switch(invContract) {
    case 'PRF':
      // code block
      updateTeaSTTStatus('stt-p');
      break;
    case 'ASS':
      // code block
      updateTeaSTTStatus('stt-a');
      break;
    case 'TIT':
      // code block
      updateTeaSTTStatus('stt-t');
      break;
    case 'CON':
      // code block
      updateTeaSTTStatus('stt-c');
      break;
    case 'MAI':
      // code block
      updateTeaSTTStatus('stt-m');
      break;
    case 'EXP':
      // code block
      updateTeaSTTStatus('stt-e');
      break;
    case 'OTH':
      // code block
      updateTeaSTTStatus('stt-o');
      break;
    default:
      console.log('ERR080');
      // code block
  }
  manageNoteModifyTeacher(true);

}

function hydrateMyTeacherEmpty(){
  clearHydrate();
  invMode = "C";

  $('#title-stu-details').html('');
  
  $('#pf-lastname').val('');
  $('#pf-firstname').val('');
  $('#pf-othfirstname').val('');

  $('#pf-telmain').val('');
  $('#pf-telalt').val('');
  $('#pf-email').val('');
  $('#pf-noteass').val('');

  manageNoteModifyTeacher(false);

  // INITIALISATION OF ALL CHECK BOX
  //Manage mention list
  for(let j=0; j<ARRAY_REF_MENTION_CODE.length; j++){
    document.getElementById("id-" + ARRAY_REF_MENTION_CODE[j].par_code).checked = false;
    document.getElementById("id-" + ARRAY_REF_MENTION_CODE[j].par_code).disabled = false;
  }
}

function disableHydrateBlockedCheckbox(paramStringArrayMention){
  if(paramStringArrayMention != null){
    let listOfBlockedMention = paramStringArrayMention.split("/");
    for(let i=0; i<listOfBlockedMention.length; i++){
        document.getElementById("id-" + listOfBlockedMention[i]).disabled = true;
    }
  }
}

function clearHydrate(){
    invArrayId = 0;
    invId = 0;
    invTitle = "";
    invTEA_ALL_MENTION_CODE = "";
    blockTEA_UEL_ALL_MENTION_CODE = "";
    blockTEA_UGM_ALL_MENTION_CODE = "";
    invContract = "";
    //invContract_label = "";
    invEmail = "";
    invName = "";
    invFirstname = "";
    invLastname = "";
    invOtherFirstname = "";
    invPhoneAlt = "";
    invPhoneMain = "";
    invComment = "";
    invContractHTMLCode = "";
    invTitleHTMLCode = "";
}


function manageNoteModifyTeacher(paramTriggerCheck){
  let readInputText = $("#pf-noteass").val();
  //console.log('in verifyTextAreaSaveBtn: ' + readInputText);
  let textInputLength = readInputText.length;
  $("#noteass-length").html((MAX_NOTE_LENGTH-textInputLength) < 0 ? 0 : (MAX_NOTE_LENGTH-textInputLength));

  if(textInputLength > MAX_NOTE_LENGTH){
    $("#pf-noteass").val(readInputText.substring(0, MAX_NOTE_LENGTH));
  }

  if(paramTriggerCheck){
    manageSaveChangeProfBtn();
  }
}

function getArrayDataAllTEAToJsonArrayId(paramId){
  for(let i=0; i<dataAllTEAToJsonArray.length; i++){
    if(dataAllTEAToJsonArray[i].TEA_ID == paramId){
      return i;
    }
  }
  return -1;
}

function getTitleAbbreviation(paramCode){
  for(let i = 0; ARRAY_REF_ALL_TITLE.length; i++){
    if(ARRAY_REF_ALL_TITLE[i].title_code == paramCode){
      return ARRAY_REF_ALL_TITLE[i].abreviation;
    }
  }
  return 'ERR349';
}

function getContractLabel(paramCode){
  for(let i = 0; ARRAY_REF_ALL_CONTRACT.length; i++){
    if(ARRAY_REF_ALL_CONTRACT[i].contract_code == paramCode){
      return ARRAY_REF_ALL_CONTRACT[i].contract_label;
    }
  }
  return 'ERR349';
}
/*******************************************************************************/
/*******************************************************************************/
/*******************************************************************************/
/*******************************************************************************/
// GRID
/*******************************************************************************/
/*******************************************************************************/
/*******************************************************************************/
/*******************************************************************************/


function initAllTeaGrid(){
    $('#filter-all-tea').keyup(function() {
        filterDataAllTea();
    });
    $('#re-init-dash-tea').click(function() {
      $('#filter-all-tea').val('');
      clearDataAllTea();
    });
}
  
function filterDataAllTea(){
    if(($('#filter-all-tea').val().length > 1) && ($('#filter-all-tea').val().length < 35)){
      //console.log('We need to filter !' + $('#filter-all').val());
      filtereddataAllTEAToJsonArray = dataAllTEAToJsonArray.filter(function (el) {
                                        return el.raw_data.includes($('#filter-all-tea').val().toUpperCase())
                                    });
        loadAllTeaGrid();
    }
    else if(($('#filter-all-tea').val().length < 2)) {
      // We clear data
      clearDataAllTea();
    }
    else{
      // DO nothing
    }
}
  
function clearDataAllTea(){
    filtereddataAllTEAToJsonArray = Array.from(dataAllTEAToJsonArray);
    loadAllTeaGrid();
};

function loadAllTeaGrid(){
    refTeaField = [
        { name: "TEA_ID",
          title: "#",
          type: "number",
          width: 5,
          align: "center",
          headercss: "cell-ref-uac-sm-hd",
          css: "cell-ref-uac-sm",
          itemTemplate: function(value, item) {
            if (item.IS_DIRTY ==  'Y'){
              return '<span class="recap-dirty">' + value + '</span>';
            }
            else{
              return value;
            }
          }
        },
        { name: "name",
          title: "Nom",
          type: "text",
          headercss: "cell-ref-uac-sm-hd",
          css: "cell-ref-uac-sm",
          itemTemplate: function(value, item) {
            if (item.IS_DIRTY ==  'Y'){
              return '<span class="recap-dirty">' + value + '</span>';
            }
            else{
              return value;
            }
          }
        },
        { name: "MANSUM_P_SHIFT_DURATION",
          title: "Pst",
          type: "number",
          width: 10,
          headercss: "cell-ref-uac-sm-hd",
          css: "cell-ref-uac-sm",
          itemTemplate: function(value, item) {
            if (value ==  0){
              return '0';
            }
            else if( (value % 2) > 0){
              return Math.floor(value / 2) + 'h30';
            }
            else{
              return Math.floor(value / 2) + 'h00';
            }
          }
        },
        { name: "MANSUM_M_SHIFT_DURATION",
          title: "Abs",
          type: "number",
          width: 10,
          headercss: "cell-ref-uac-sm-hd",
          css: "cell-ref-uac-sm",
          itemTemplate: function(value, item) {
            if (value ==  0){
              return '0';
            }
            else if( (value % 2) > 0){
              return Math.floor(value / 2) + 'h30';
            }
            else{
              return Math.floor(value / 2) + 'h00';
            }
          }
        },
        { name: "contract_label",
          title: "Contrat",
          type: "text",
          width: 30,
          headercss: "cell-ref-uac-sm-hd",
          css: "cell-ref-uac-sm",
          itemTemplate: function(value, item) {
            if( value == null){
              return '<span class="recap-mis">Manquant<span>';
            }
            else{
              return value;
            }
          }
        },
        { name: "phone_main",
          title: "Téléphone",
          type: "text",
          width: 10,
          headercss: "cell-ref-uac-sm-hd",
          css: "cell-ref-uac-sm",
          itemTemplate: function(value, item) {
            if( value == null){
              return '<span class="recap-mis">Manquant<span>';
            }
            else{
              return value;
            }
          }
        },
        { name: "TEA_ALL_MENTION_CODE",
          title: "Mention(s)",
          type: "text",
          width: 60,
          headercss: "cell-ref-uac-sm-hd",
          css: "cell-ref-uac-xxs"
        }
    ];
    $("#jsGridAllTEA").jsGrid({
        height: "auto",
        width: "100%",
        noDataContent: "Aucun enseignant disponible",
        pageIndex: 1,
        pageSize: 50,
        pagePrevText: "Prec",
        pageNextText: "Suiv",
        pageFirstText: "Prem",
        pageLastText: "Dern",

        sorting: true,
        paging: true,
        data: filtereddataAllTEAToJsonArray,
        fields: refTeaField,
        rowClick: function(args){
          //let $target = $(args.event.target);
          //console.log("This is element: " + args.item.TEA_ID);
          if(EDIT_ACCESS == 'Y'){
            hydrateMyTeacher(args.item.TEA_ID);
            modifyTeacherPopUp();
          }
          else{
            hydrateMyTeacherReadOnly(args.item.TEA_ID);
            showTeacherPopUpReadOnly();
          }
        }
    });
    // Update the count
    $('#count-tea').html(filtereddataAllTEAToJsonArray.length);
}

function showCreateTeacherModal(){
  if(EDIT_ACCESS == 'Y'){
    //console.log('You clicked on modifyProfile');
    hydrateMyTeacherEmpty();
    $('#tea-details-modal').modal('show');
  }
  else{
    console.log('ERR0293E');
  }
}

/************************************************************/
/************************************************************/
/************************************************************/
/************************************************************/
/************************************************************/
/************************************************************/
/************************************************************/
/************************************************************/

function generateAllTeacherCSV(){
  const csvContentType = "data:text/csv;charset=utf-8,";
  let csvContent = "";
  let involvedArray = filtereddataAllTEAToJsonArray;
  const SEP_ = ";"

  let dataString = "Référence" + SEP_ 
                    + "Nom complet" + SEP_ 
                    + "Titre" + SEP_ 
                    + "Nom de famille" + SEP_ 
                    + "Prénom" + SEP_ 
                    + "Autres prénoms" + SEP_ 
                    + "Téléphone" + SEP_ 
                    + "Autre téléphone" + SEP_
                    + "Email" + SEP_ 
                    + "Nbr heure présent ce mois" + SEP_ 
                    + "Nbr heure absent ce mois" + SEP_ 
                    + "Remarque" + SEP_ + "\n";
  csvContent += dataString;
  for(let i=0; i<involvedArray.length; i++){

            dataString = involvedArray[i].TEA_ID + SEP_ 
                + isNullMvo(involvedArray[i].name) + SEP_ 
                + isNullMvo(involvedArray[i].title) + SEP_ 
                + isNullMvo(involvedArray[i].lastname) + SEP_ 
                + isNullMvo(involvedArray[i].firstname) + SEP_ 
                + isNullMvo(involvedArray[i].other_firstname) + SEP_ 
                + isNullMvo(involvedArray[i].phone_main) + SEP_ 
                + isNullMvo(involvedArray[i].phone_alt) + SEP_ 
                + isNullMvo(involvedArray[i].email) + SEP_ 
                + parseInt(involvedArray[i].MANSUM_P_SHIFT_DURATION)/2 + SEP_ 
                + parseInt(involvedArray[i].MANSUM_M_SHIFT_DURATION)/2 + SEP_ 
                + isNullMvo(involvedArray[i].teacher_info) + SEP_ ;
            // easy close here
            csvContent += i < involvedArray.length ? dataString+ "\n" : dataString;
  }

  //console.log('Click on csv');
  let encodedUri = encodeURI(csvContent);
  let csvData = new Blob([csvContent], { type: csvContentType });

      let link = document.createElement("a");
  let csvUrl = URL.createObjectURL(csvData);

  link.href =  csvUrl;
  link.style = "visibility:hidden";
  link.download = 'RapportManagerEnseignant_' + getReportACEDateStrFR(0).replaceAll('/', '_') + '.csv';
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);

}



function generateCourseReportCSV(paramMonth){
	const csvContentType = "data:text/csv;charset=utf-8,";
  let csvContent = "";
  const SEP_ = ";"
  let verboseMonth = "MoisCourant_";

  let involvedArray = dataTagToJsonArrayCourseReportM0;
  if(paramMonth != 0){
    involvedArray = dataTagToJsonArrayCourseReportM1;
    verboseMonth = "MoisPrecedent_";
  }

	let dataString = "Classe" + SEP_ + "Jour" + SEP_ + "Enseignant en charge" + SEP_ + "Date du cours" + SEP_  + "Mois du cours" + SEP_  + "Status du cours" + SEP_ + "Durée en heure" + SEP_ + "Debute" + SEP_ + "Nombre absence" + SEP_ + "Qav. - Nombre quittant" + SEP_ + "Nbr etudiant total dans la classe" + SEP_ + "%Présent" + SEP_ + "%Qav." + SEP_ + "Journee non-comptee" + SEP_ + "Detail du cours" + SEP_ + "\n";
	csvContent += dataString;
	for(var i=0; i<involvedArray.length; i++){
		dataString = involvedArray[i].CLASSE + SEP_ + involvedArray[i].JOUR + SEP_ + involvedArray[i].TEACHER + SEP_ + involvedArray[i].COURS_DATE + SEP_ +  involvedArray[i].MOIS + SEP_ +  involvedArray[i].COURSE_STATUS 
                  + SEP_ + parseFloat(involvedArray[i].DURATION_HOUR).toFixed(1) + SEP_ + involvedArray[i].DEBUT_COURS 
                  + SEP_ + (involvedArray[i].COURSE_CAN_BE_STAT == "N" ? "na" : involvedArray[i].NBR_ABS)
                  + SEP_ + (involvedArray[i].COURSE_CAN_BE_STAT == "N" ? "na" : involvedArray[i].NBR_QUI)
                  + SEP_ + involvedArray[i].NUMBER_STUD 
                  + SEP_ + (involvedArray[i].COURSE_CAN_BE_STAT == "N" ? "na" : parseFloat((parseInt(involvedArray[i].NUMBER_STUD) - (parseInt(involvedArray[i].NBR_ABS))) * 100 / (parseInt(involvedArray[i].NUMBER_STUD))).toFixed(2))
                  // Be carefull of the division per zero
                  + SEP_ + (involvedArray[i].COURSE_CAN_BE_STAT == "N" ? "na" : ( parseInt(involvedArray[i].NUMBER_STUD) == parseInt(involvedArray[i].NBR_ABS) ? "na" : parseFloat((parseInt(involvedArray[i].NBR_QUI)) * 100 / (parseInt(involvedArray[i].NUMBER_STUD) - parseInt(involvedArray[i].NBR_ABS))).toFixed(2)))
                  + SEP_  + involvedArray[i].OFF_DAY + SEP_ + involvedArray[i].COURS_DETAILS + SEP_ ;
    // easy close here
    csvContent += i < involvedArray.length ? dataString+ "\n" : dataString;
	}

  //console.log('Click on csv');
	let encodedUri = encodeURI(csvContent);
  let csvData = new Blob([csvContent], { type: csvContentType });

	let link = document.createElement("a");
  let csvUrl = URL.createObjectURL(csvData);

  link.href =  csvUrl;
  link.style = "visibility:hidden";
  link.download = 'RapportCours_' + verboseMonth + getReportACEDateStrFR(0).replaceAll('/', '_') + '.csv';
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
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
    console.log('We are in ACE-TEA');
    if($('#mg-graph-identifier').text() == 'man-tea'){
      // Do something
      console.log('man-tea');
      initAllTeaGrid();
      loadAllTeaGrid();

      /****************************************************/
      /****************************************************/
      /******************  Modif profile  *****************/
      /****************************************************/
      /****************************************************/
      //fillCartoucheMentionProfile();
      // Refresh status
      $( ".stt-group" ).click(function() {
        updateTeaSTTStatus(this.id);
      });
      $( ".tit-group" ).click(function() {
        updateTeaTITStatus(this.id);
      });
    }
    else{
      //Do nothing
    }
  
});