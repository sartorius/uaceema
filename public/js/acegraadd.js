function generategradetoexamDB(){
    $('#loading').show(50);
    $.ajax('/generategradetoexamDB', {
        type: 'POST',  // http method
        data: {
          agentId: AGENT_ID,
          masterId: POST_MASTER_ID,
          loadGradeData: JSON.stringify(dataAllUSRToJsonArray),
          loadOtherGradeData: JSON.stringify(addMoreDataOtherUSRToJsonArray),
          crossBookmark: snapshotCurrentParamImg(),
          browser: getBrowserId(),
          token : GET_TOKEN
        },  // data to submit
        success: function (data, status, xhr) {
            //We have to locally create the reduction in case of re-scan 
            //let iMyReduction = data['param_user_id'];
            
            goToCreateGrades(data['param_master_id']);
        },
        error: function (jqXhr, textStatus, errorMessage) {
          $('#loading').hide(50);
          $('#msg-alert').html("ERR411GRA: exam #" + POST_MASTER_ID + " une erreur s'est produite pour la saisie, veuillez contacter le support technique.");
          $('#type-alert').removeClass('alert-primary').addClass('alert-danger');
          $('#ace-alert-msg').show(100);
          scrollToTop();
        }
    });
}

function generatereviewexamDB(){
    $('#loading').show(50);
    $.ajax('/generatereviewexamDB', {
        type: 'POST',  // http method
        data: {
          agentId: AGENT_ID,
          masterId: POST_MASTER_ID,
          loadReviewData: JSON.stringify(updateDataAllUSRToJsonArray),
          loadOtherGradeData: JSON.stringify(addMoreDataOtherUSRToJsonArray),
          crossBookmark: snapshotCurrentParamImg(),
          browser: getBrowserId(),
          token : GET_TOKEN
        },  // data to submit
        success: function (data, status, xhr) {
            //We have to locally create the reduction in case of re-scan 
            //let iMyReduction = data['param_user_id'];
            
            goToReviewGrades(data['param_master_id']);
        },
        error: function (jqXhr, textStatus, errorMessage) {
          $('#loading').hide(50);
          $('#msg-alert').html("ERR412GRA: exam #" + POST_MASTER_ID + " une erreur s'est produite pour la vérification, veuillez contacter le support technique.");
          $('#type-alert').removeClass('alert-primary').addClass('alert-danger');
          $('#ace-alert-msg').show(100);
          scrollToTop();
        }
    });
}


function goToCreateGrades(param){
    $("#create-master-id").val(param);
    $("#review-master-id").val(0);
    $("#mg-create-review-grades-form").submit();
}

function goToReviewGrades(param){
    $("#create-master-id").val(0);
    $("#review-master-id").val(param);
    $("#mg-create-review-grades-form").submit();
}

// ********************************************************************************************************************
// ********************************************************************************************************************
// ********************************************************************************************************************
// ****************************************       Fill pop up      ****************************************************
// ********************************************************************************************************************
// ********************************************************************************************************************
// ********************************************************************************************************************


function resetPopUpAddGrade(){
    $('#addpay-ace').val('');
    $('#gr1000').val('');
    $('#gr1000').removeClass('ok-txtar');
    $('#gr1000').removeClass('err-txtar');
    $('#last-read-bc').html('');
    $('#scan-gra-input').show(100);
    $('#ctrl-name').html('');

    $('#othg-lname').html('');
    $('#othg-fname').html('');
    $('#othg-sclass').html('');

    $("#btn-idegra").hide(100);
    $("#btn-canidegra").hide(100);

    vshUsernameOthg = "";
    vshLastnameOthg = "";
    vshFirstnameOthg = "";
    vshIdOthg = 0;
    hidGraOthg = 0;

    // Block management TODO
    $('#assign-gra').show(100);
    $('#gra-detail-othergra').hide(100);
    $('#btn-addothend').hide(100);
}

function openAddOtherGraBlk(){
    // Block management
    $('#assign-gra').hide(100);
    $('#gra-detail-othergra').show(100);
}

function addOtherGradeEnd(){
    //Check first if the line exists or not
    let alreadyAdded = false;
    let i = 0;

    while ((i<addMoreDataOtherUSRToJsonArray.length)
                && (!alreadyAdded)) {
        // code block to be executed
        if(addMoreDataOtherUSRToJsonArray[i].VSH_ID == vshIdOthg){
            alreadyAdded = true;
            addMoreDataOtherUSRToJsonArray[i].HID_GRA = hidGraOthg;
        }
        i = i + 1;
    }

    if(!alreadyAdded){
        let myOtherGradeLine = {
                DIRTY_GRA: "x",
                GRA_ID: 0,
                GRA_STATUS: "x",
                HID_GRA: hidGraOthg,
                VSH_FIRSTNAME: vshFirstnameOthg,
                VSH_ID: vshIdOthg,
                VSH_LASTNAME: vshLastnameOthg,
                VSH_USERNAME: vshUsernameOthg
            };
        //Can be added several time
        addMoreDataOtherUSRToJsonArray.push(myOtherGradeLine);
    }
    fillStudent((parseInt(currentPage) - 1));
    $('#gra-details-modal').modal('toggle');
}

function mngAddOtherGraUserExists(val){
    //CARIZOU151 BEBIMAM925 STEVAND135 CHRIHER744
    for (let i = 0; i < dataAllOtherMentionUSRToJsonArray.length; i++) {
      if (dataAllOtherMentionUSRToJsonArray[i].VSH_USERNAME === val){
        
  
        $('#addpay-ace').val('');
        $('#scan-gra-input').hide(100);
        $('#ctrl-name').html(dataAllOtherMentionUSRToJsonArray[i].VSH_FIRSTNAME + ' - ' + dataAllOtherMentionUSRToJsonArray[i].OTH_CLASS);
        $("#btn-idegra").show(100);
        $("#btn-canidegra").show(100);

        $('#othg-lname').html(dataAllOtherMentionUSRToJsonArray[i].VSH_LASTNAME);
        $('#othg-fname').html(dataAllOtherMentionUSRToJsonArray[i].VSH_FIRSTNAME);
        $('#othg-sclass').html(dataAllOtherMentionUSRToJsonArray[i].OTH_CLASS);
        
        vshUsernameOthg = dataAllOtherMentionUSRToJsonArray[i].VSH_USERNAME;
        vshLastnameOthg = dataAllOtherMentionUSRToJsonArray[i].VSH_LASTNAME;
        vshFirstnameOthg = dataAllOtherMentionUSRToJsonArray[i].VSH_FIRSTNAME;
        vshIdOthg = dataAllOtherMentionUSRToJsonArray[i].VSH_ID;

        return true;
      }
    }
    resetPopUpAddGrade();
    return false;
}
  
function verifyGraContentScan(){
  
    $('#type-alert').addClass('alert-primary').removeClass('alert-danger');
    $('#ace-alert-msg').hide(100);
    
  
  
    if ($('#addpay-ace').val().length == 10){
  
      let originalRedInput = $('#addpay-ace').val();
      let readInput = $('#addpay-ace').val().replace(/[^a-z0-9]/gi,'').toUpperCase();
      //console.log("Diagnostic 2 Read Input : " + readInput.length + ' : ' + readInput + ' - ' + originalRedInput + ' 0/' + convertWordAZERTY(originalRedInput) + ' 1/' + convertWordAZERTY(originalRedInput).toUpperCase() + ' 2/' + convertWordAZERTY(originalRedInput).toUpperCase().replace(/[^a-z0-9]/gi,'') + ' 3/' + convertWordAZERTY(originalRedInput).toLowerCase().replace(/[^a-z0-9]/gi,''));
  
      if(readInput.length < 10){
        // We are on the wrong keyboard config as it must be 10
        readInput = convertWordAZERTY(originalRedInput).replace(/[^a-z0-9]/gi,'').toUpperCase();
      }
  
      let scanValidToDisplay = ' <i class="mgs-rd-o-err">&nbsp;ERR91Format&nbsp;</i>';
      // Here we check the format
      if(/[a-zA-Z0-9]{9}[0-9]/.test(readInput)){
        // Only if the read is clean
  
        if(mngAddOtherGraUserExists(readInput)){
          /********************************************************** FOUND **********************************************************/
          scanValidToDisplay = ' <i class="mgs-rd-o-in">&nbsp;Étudiant valide&nbsp;</i>';
          //Allow button enabled
  
        }
        else{
          /******************************************************** NOT FOUND ********************************************************/
          scanValidToDisplay = ' <i class="mgs-rd-o-err">&nbsp;Étudiant introuvable&nbsp;</i>';
        }
      }
      else{
          // If we are on the pay screen we need to do somthing
          // We do not match a username
      }
  
      //console.log('We have read: ' + $('#addpay-ace').val());
      $('#last-read-bc').html(readInput + scanValidToDisplay);
  
      // Save for any internet issue here
      //$("#btn-load-bc").show();
  
  
  
    }
    else if($('#addpay-ace').val().length > 10) {
      // Great length
      $('#addpay-ace').val('');
      resetMvoAttribuer();
  
    }
    else {
      //Do nothing
    }
}

function showPopUpAddGrade(){
    resetPopUpAddGrade();
    $('#gra-details-modal').modal('show');
}

// ********************************************************************************************************************
// ********************************************************************************************************************
// ********************************************************************************************************************
// *****************************************       Fill table      ****************************************************
// ********************************************************************************************************************
// ********************************************************************************************************************
// ********************************************************************************************************************

function fillUnitaryPageStudent(paramIndex, paramArray, classEdit, isOthGraList){
    let tempStrTable = '';
    let existingInputGra = '';
    let highlightClassExisting = '';
    let highlightClassDirty = '';
    if((paramArray[paramIndex].HID_GRA != '') &&
        (paramArray[paramIndex].HID_GRA != 'x')){
            // Be carefull when we are A or E then the HID GRA will take the value
            if((paramArray[paramIndex].GRA_STATUS == 'A')
                || (paramArray[paramIndex].GRA_STATUS == 'E')){
                existingInputGra = paramArray[paramIndex].HID_GRA = paramArray[paramIndex].GRA_STATUS;
            }
            existingInputGra = paramArray[paramIndex].HID_GRA;
            highlightClassExisting = 'ok-txtar';
            
            if((mode == 'R')
                    && (paramArray[paramIndex].DIRTY_GRA == 'Y')){
                        highlightClassDirty = 'rev-txtar';
            }
    }
    
    tempStrTable = tempStrTable + '<tr>' ;
    if(isOthGraList == 'Y'){
        tempStrTable = tempStrTable + '<td><i class="oth-grtd uac-step">' + existingInputGra + '</i></td>';
    }
    else{
        tempStrTable = tempStrTable + '<td class="c-t1"><textarea id="gr' + paramIndex + '" name="gr' + paramIndex + '" rows="1" class="gra-txta ' + highlightClassDirty + ' '+ highlightClassExisting + ' ' + classEdit + '" cols="4" onkeyup="validateInputGra(event,' + paramIndex + ')" placeholder="0">' + existingInputGra + '</textarea></td>';
    }
    tempStrTable = tempStrTable + '<td>' + paramArray[paramIndex].VSH_FIRSTNAME.substring(0, maxLengthTable) + '</td>';
    tempStrTable = tempStrTable + '<td>' + paramArray[paramIndex].VSH_LASTNAME.substring(0, maxLengthTable) + '</td>';
    tempStrTable = tempStrTable + '<td>' + paramArray[paramIndex].VSH_USERNAME + '</td>';
    tempStrTable = tempStrTable + '<td>' + (parseInt(paramIndex) + 1) + '</td>';
    tempStrTable = tempStrTable + '</tr>';
    return tempStrTable;
}

function reOrderListAndDisplay(){
    console.log('in reOrderListAndDisplay currentOrder: ' + currentOrder);
    // Order by Matricule
    if(currentOrder == 'M'){
        let dataAllUSRToJsonArraySorted = dataAllUSRToJsonArray.sort((a, b) => {
            return (a.VSH_USERNAME.localeCompare(b.VSH_USERNAME));
        });
        dataAllUSRToJsonArray = dataAllUSRToJsonArraySorted;
        currentOrder = 'U';
    }
    else{
        let dataAllUSRToJsonArraySorted = dataAllUSRToJsonArray.sort((a, b) => {
            return parseInt(a.VSH_SMATRICULE) - parseInt(b.VSH_SMATRICULE);
        });
        dataAllUSRToJsonArray = dataAllUSRToJsonArraySorted;
        currentOrder = 'M';
    }
    fillStudent((parseInt(currentPage) - 1));
    return true;
}

// First page is zero
function fillStudent(paramPage){
    let strTable = '<table>';
    let paramPageLimit = (paramPage+1)*pageLimit;
    let paramStart = paramPage*pageLimit;
    let classEdit = '';
    let classEditUnlist = '';
    
    if(mode == 'O'){
        classEdit = 'edit-sel-off';
        classEditUnlist = 'edit-sel-off';
    }
    if(mode == 'R'){
        classEditUnlist = 'edit-sel-off';
    }
    
    
    if(paramPageLimit > dataAllUSRToJsonArray.length){
        paramPageLimit = dataAllUSRToJsonArray.length;
    }

    for(let i=paramStart; i<paramPageLimit; i++){
        /*
        let existingInputGra = '';
        let highlightClassExisting = '';
        let highlightClassDirty = '';
        if((dataAllUSRToJsonArray[i].HID_GRA != '') &&
            (dataAllUSRToJsonArray[i].HID_GRA != 'x')){
                // Be carefull when we are A or E then the HID GRA will take the value
                if((dataAllUSRToJsonArray[i].GRA_STATUS == 'A')
                    || (dataAllUSRToJsonArray[i].GRA_STATUS == 'E')){
                    existingInputGra = dataAllUSRToJsonArray[i].HID_GRA = dataAllUSRToJsonArray[i].GRA_STATUS;
                }
                existingInputGra = dataAllUSRToJsonArray[i].HID_GRA;
                highlightClassExisting = 'ok-txtar';
                
                if((mode == 'R')
                        && (dataAllUSRToJsonArray[i].DIRTY_GRA == 'Y')){
                            highlightClassDirty = 'rev-txtar';
                }
        }
        
        strTable = strTable + '<tr>' ;
        strTable = strTable + '<td class="c-t1"><textarea id="gr' + i + '" name="gr' + i + '" rows="1" class="gra-txta ' + highlightClassDirty + ' '+ highlightClassExisting + ' ' + classEdit + '" cols="4" onkeyup="validateInputGra(event,' + i + ')" placeholder="0">' + existingInputGra + '</textarea></td>';
        strTable = strTable + '<td>' + dataAllUSRToJsonArray[i].VSH_FIRSTNAME.substring(0, maxLengthTable) + '</td>';
        strTable = strTable + '<td>' + dataAllUSRToJsonArray[i].VSH_LASTNAME.substring(0, maxLengthTable) + '</td>';
        strTable = strTable + '<td>' + dataAllUSRToJsonArray[i].VSH_USERNAME + '</td>';
        strTable = strTable + '<td>' + (parseInt(i) + 1) + '</td>';
        strTable = strTable + '</tr>';
        */
        strTable = strTable + fillUnitaryPageStudent(i, dataAllUSRToJsonArray, classEdit, 'N');
    };

    

    //Need to fill the last page
    if(paramPage == (parseInt(PAGE_MAX) - 1)){
        
        //If we have more we display on last page
        for(let m=paramPageLimit; m<dataAllUSRToJsonArray.length; m++ ){
            strTable = strTable + fillUnitaryPageStudent(m, dataAllUSRToJsonArray, classEdit, 'N');
        }
        //We are on the last page !!!
        // Need to fill with addMoreDataOtherUSRToJsonArray
        for(let k=0; k<addMoreDataOtherUSRToJsonArray.length; k++){
            strTable = strTable + fillUnitaryPageStudent(k, addMoreDataOtherUSRToJsonArray, classEdit, 'Y');
        }


        for(let j=(paramPageLimit + addMoreDataOtherUSRToJsonArray.length); j<(PAGE_MAX*pageLimit); j++){
            strTable = strTable + '<tr>' ;
            //strTable = strTable + '<td class="c-t1"><textarea name="gr' + j + '" rows="1" class="gra-txta ' + classEditUnlist + '" cols="4" placeholder="0"></textarea></td>';
            strTable = strTable + '<td>NA</td>';
            strTable = strTable + '<td>NA</td>';
            strTable = strTable + '<td>NA</td>';
            strTable = strTable + '<td>NA</td>';
            strTable = strTable + '<td>' + (parseInt(j) + 1) + '</td>';
            strTable = strTable + '</tr>';
        }
        
    }
    strTable = strTable + '</table>';
    $("#gra-gr").html(strTable);
}

function testRegexGrade(param){
    const RE = /^[1-2]?[0-9][\.|,]?[0-9]?[0-9]?$|^[a|A]{1}$|^[e|E]{1}$/;
    if(param.length == 0){
        return true;
    }
    else if(RE.test(param)){
        if(param.toString().toUpperCase() == 'A'){
            // This is for missing/absent
            return true;
        }
        else if(param.toString().toUpperCase() == 'E'){
            // This is for exempté/Redoublant
            return true;
        }
        else if(parseFloat(param.replace(',', '.')) < 20.01){
            return true;
        }
        else{
            // We are not a or A or we are bigger than 20
            return false;
        }
    }
    else{
        return false;
    }
}


function validateInputGra(event, line){
    // console.log('click gra: ' + line + '/' + $('#gr'+line).val());
    // add this class err-txtar if error
    /*
    console.log('Read event: [' + event.key + '] code: [' + event.code + ']');
    if((event.code !== "Enter")
        && (event.code !== "Space")){
    }
    else{
        blockInputKeyboard(event);
    }
    */
    if(testRegexGrade($('#gr'+line).val())){
        $('#gr'+line).removeClass('err-txtar');
        if($('#gr'+line).val() != ''){
            $('#gr'+line).addClass('ok-txtar');
            if(mode == 'R'){
                $('#gr'+line).addClass('rev-txtar');
            }
        }
        if(line == 1000){
            // We are in other cases
            hidGraOthg = $('#gr'+line).val().replace(',', '.');
            $('#btn-addothend').show(100);
        }
        else{
            // We are on usual
            dataAllUSRToJsonArray[line].HID_GRA = $('#gr'+line).val().replace(',', '.');
            dataAllUSRToJsonArray[line].DIRTY_GRA = 'Y';
            //console.log('-- valid');
        }
    }
    else{
        $('#gr'+line).removeClass('ok-txtar').addClass('err-txtar');
        if(line == 1000){
            hidGraOthg = 'x';
            $('#btn-addothend').hide(100);
        }
        else{
            dataAllUSRToJsonArray[line].HID_GRA = 'x';
            //console.log('-- invalid');
        }
    }
}


function checkAndValidateExam(){
    // do we find any error ? If we get -1 then all OK
    let allFilled = checkAllExam();
    if(allFilled > -1){
        $('#msg-alert').html("Enregistrement impossible. Vérifier la position: " + (allFilled + 1));
        $('#type-alert').removeClass('alert-primary').addClass('alert-danger');
        $('#ace-alert-msg').show(100);
        document.body.scrollTop = document.documentElement.scrollTop = 0;

        setTimeout(closeAlertMsg, 3000);
    }
    else{
        console.log('Check All exam - we are good: ' + allFilled);
        //Go to saving !!!
        if(mode == 'C'){
            generategradetoexamDB();
        }
        else{
            //TO DO duplicate Dirty Lines
            updateDataAllUSRToJsonArray = new Array();
            for(let i=0; i<dataAllUSRToJsonArray.length; i++){
                if(dataAllUSRToJsonArray[i].DIRTY_GRA == 'Y'){
                    updateDataAllUSRToJsonArray.push(dataAllUSRToJsonArray[i]);
                }
            }
            generatereviewexamDB();
        }
    }
}

function checkAllExam(){
    //dataAllUSRToJsonArray
    for(let i=0; i<dataAllUSRToJsonArray.length; i++ ){
        if(dataAllUSRToJsonArray[i].HID_GRA == ''){
            return i;
        }
        else if(dataAllUSRToJsonArray[i].HID_GRA == 'x'){
            return i;
        }
        else{
            // Nothing to do we are good
        }
    }
    return -1;
}

function grow(param){
    let growValue = 1 + (0.01*getRange());
    if (param == 'A'){
        growValue = 1 - (0.01*getRange());
    }
    let currentW = parseInt($('#ex-1').width())*growValue;
    $('#ex-1').width(currentW);
}

function left(param){
    let direction = 1;
    if (param == 'A'){
        direction = -1;
    }
    // Set the power value here
    direction =  direction * getRange();
    let currentLeft = $("#ex-1").css("left");
    currentLeft = currentLeft.substring(0, currentLeft.length-2);
    document.getElementById("ex-1").style.left = parseInt(currentLeft) + (PAD_POWER * direction) + "px";
}

function itop(param){
    let direction = 1;
    if (param == 'A'){
        direction = -1;
    }
    // Set the power value here
    direction =  direction * getRange();
    let currentTop = $("#ex-1").css("top");
    currentTop = currentTop.substring(0, currentTop.length-2);
    document.getElementById("ex-1").style.top = parseInt(currentTop) + (PAD_POWER * direction) + "px";
}


function getRotationAngle(target) {
  const obj = window.getComputedStyle(target, null);
  const matrix = obj.getPropertyValue('-webkit-transform') || 
    obj.getPropertyValue('-moz-transform') ||
    obj.getPropertyValue('-ms-transform') ||
    obj.getPropertyValue('-o-transform') ||
    obj.getPropertyValue('transform');

  let angle = 0; 

  if (matrix !== 'none') 
  {
    const values = matrix.split('(')[1].split(')')[0].split(',');
    const a = values[0];
    const b = values[1];
    angle = Math.round(Math.atan2(b, a) * (180/Math.PI));
  } 
  return (angle < 0) ? angle +=360 : angle;
}


function clockW(param){
    // Access DOM element object
    let direction = 1;
    if (param == 'A'){
        direction = -1;
    }
    let rotated = document.getElementById('ex-1');
    let currentR = parseInt(getRotationAngle(rotated)) + (1*direction);
    // Rotate element by 90 degrees clockwise
    rotated.style.transform = 'rotate(' + currentR + 'deg)';
}


function snapshotCurrentParamImg(){
    return ($('#ex-1').width()).toString() + '/' + ($("#ex-1").css("left")).toString() + '/' + ($("#ex-1").css("top")).toString() + '/' + (parseInt(getRotationAngle(document.getElementById('ex-1')))).toString();
}

function initInitialPosition(){
    initialPosition = snapshotCurrentParamImg();
}


function persoSaveParam(){
    localStorage.setItem('prsCrsParam', snapshotCurrentParamImg());
    $('#prs-bkmk').prop("disabled", false);
    $('#msg-alert').html("Enregistrement paramètre : " + snapshotCurrentParamImg());
    $('#type-alert').addClass('alert-primary').removeClass('alert-danger');
    $('#ace-alert-msg').show(100);
    document.body.scrollTop = document.documentElement.scrollTop = 0;

    setTimeout(closeAlertMsg, 3000);
}

function applyPersoParam(){
    applyCrossBookmark(localStorage.getItem('prsCrsParam'));
}

// Width/Left/Top/Rotation
// 1463.95/-780px/-210px/0
function applyCrossBookmark(savedParam){
    let savedParamArray;
    if(savedParam == 'R'){
        savedParamArray = initialPosition.split('/');
    }
    else{
        savedParamArray = savedParam.split('/');
    }
    if(savedParamArray.length == 4){
        $('#ex-1').width(savedParamArray[0]);
        document.getElementById("ex-1").style.left = savedParamArray[1];
        document.getElementById("ex-1").style.top = savedParamArray[2];
        document.getElementById('ex-1').style.transform = 'rotate(' + savedParamArray[3]  +'deg)';
    }
    else{
        console.log('Error read: applyCrossBookmark');        
    }
}

function getRange(){
    let currentRange = parseInt(document.getElementById('rg-pck').value);
    if(currentRange < 10){
        return 1;
    }
    else if(currentRange < 60){
        return Math.floor(currentRange/10);
    }
    else if(currentRange > 90){
        return currentRange*5;
    }
    else{
        return currentRange;
    }
}


/*******************************************************************************************************************/
/*******************************************************************************************************************/
/*******************************************************************************************************************/
/*******************************************************************************************************************/
/*********************************                   Fill set up                   *********************************/
/*******************************************************************************************************************/
/*******************************************************************************************************************/
/*******************************************************************************************************************/
/*******************************************************************************************************************/


function startStopGraEdit(){
    if(editMode == 'N'){
      // We start edit here
      editMode = 'Y';
      $('.tag-edit').addClass('edit-sel-off');
      $('.tag-color-edit').addClass('edit-sel-color');
      
      $("#btn-valid-name").html("Modifier");
      allowBannerAndMainPage(editMode);
      resetNavFooterBtn();
    }
    else{
      // If we are here then the button has change and we must edit
      // We block Edit here
      editMode = 'N';
      $('.tag-edit').removeClass('edit-sel-off');
      $('.tag-color-edit').removeClass('edit-sel-color');

      $("#btn-valid-name").html("Valider");
      allowBannerAndMainPage(editMode);
      resetNavFooterBtn();
    }
}


function allowBannerAndMainPage(param){
    if(param == 'Y'){
        

        $('#main-gra').removeClass('mask-pg');
        document.getElementById("ctrl-ban").style.visibility = "visible";
        document.getElementById("pg-nav").style.visibility = "visible";
        
    }
    else{
        // This is to hide input on each grade
        applyCrossBookmark('R');
        $('#main-gra').addClass('mask-pg');
        document.getElementById("ctrl-ban").style.visibility = "hidden";
        document.getElementById("pg-nav").style.visibility = "hidden";
    }
}

function resetNavFooterBtn(){
    if ((PAGE_MAX > 1)
        && (currentPage ==  1)){
        document.getElementById("pg-btn-prec").style.visibility = "hidden";
        document.getElementById("pg-btn-next").style.visibility = "visible";
        document.getElementById("pg-gra-end-blk").style.visibility = "hidden";
    }
    else if ((PAGE_MAX == 1)
        && (currentPage ==  1)){
        document.getElementById("pg-btn-prec").style.visibility = "hidden";
        document.getElementById("pg-btn-next").style.visibility = "hidden";
        if(mode != 'O'){
            document.getElementById("pg-gra-end-blk").style.visibility = "visible";
        }
        else{
            document.getElementById("pg-gra-end-blk").style.visibility = "hidden";
        }
    }
    else if(currentPage ==  PAGE_MAX){
        document.getElementById("pg-btn-prec").style.visibility = "visible";
        document.getElementById("pg-btn-next").style.visibility = "hidden";
        if(mode != 'O'){
            document.getElementById("pg-gra-end-blk").style.visibility = "visible";
        }
        else{
            document.getElementById("pg-gra-end-blk").style.visibility = "hidden";
        }
    }
    else{
        document.getElementById("pg-btn-prec").style.visibility = "visible";
        document.getElementById("pg-btn-next").style.visibility = "visible";
        document.getElementById("pg-gra-end-blk").style.visibility = "hidden";
        //Do nothing
    }
}

function btnPagNav(param){
    // Current page is 1..(n+1)
    let targetPage = currentPage + parseInt(param);
    updatePageNav('page-' + targetPage);
}

function updatePageNav(activeId){
    $('.pow-group').removeClass('active');  // Remove any existing active classes
    $('.pow-group').addClass('unsel-grp');  // Remove any existing active classes
    
    $('#' + activeId).addClass('active').removeClass('unsel-grp'); // Add the class to the nth element

    currentPage = parseInt(activeId.split('-')[1]);
    fillStudent((parseInt(currentPage) - 1));

    //Handle image here
    document.getElementById("ex-1").src =  PATH_IMG + SUB_PATH_IMG + dataAllPageToJsonArray[(currentPage - 1)].gra_path + dataAllPageToJsonArray[(currentPage - 1)].gra_filename;

    $('#disp-inv-pg').html(currentPage);
    resetNavFooterBtn();
    document.body.scrollTop = document.documentElement.scrollTop = 0;
    //Handle if first and last page
    
}

function iniModeOfTheAddGrade(){
    // Default is C - C for Creation, R for Review, O for Read-only
    if((EXAM_STATUS == 'FED')
        && (LAST_AGENT_ID_SAME_AS_CURRENT == 'N')){
        mode = 'R';
        $('#id-action-submit').html('Valider');
        $('#title-add-gra').html('Vérifier notes');
        $('#disp-status-cart').html(getVerboseExamStatus(EXAM_STATUS, 'N'));
    }
    else if((EXAM_STATUS == 'LOA') || (EXAM_STATUS == 'NEW')){
        mode = 'C';
        $('#title-add-gra').html('Saisir notes');
        $('#disp-status-cart').html(getVerboseExamStatus(EXAM_STATUS, 'N'));
    }
    else if(EXAM_STATUS == 'END'){
        mode = 'O';
        $('#title-add-gra').html('Revoir les scans & notes');
        //$('#disp-status-cart').html('<i class="uac-step uac-step-purple">Lecture seule' + addMsg + '</i>');
        $('#disp-status-cart').html(getVerboseExamStatus(EXAM_STATUS, 'N'));
    }
    else{
        mode = 'O';
        $('#title-add-gra').html('Voir notes');
        let addMsg = '';
        if((EXAM_STATUS == 'FED')
                && (LAST_AGENT_ID_SAME_AS_CURRENT == 'Y')){
            addMsg = ' : le vérificateur doit être différent du saisisseur';
        }
        $('#disp-status-cart').html('<i class="uac-step uac-step-purple">Lecture seule' + addMsg + '</i>');
    }
}


function goToRollback(paramGraId){
    $("#read-master-id").val(paramGraId);
    $("#read-rollback-order").val('Y');
    $("#mg-grade-master-id-form").submit();
}


$(document).ready(function() {
    console.log('We are in gra add');
    if($('#mg-graph-identifier').text() == 'gra-add'){
      iniModeOfTheAddGrade();
      initInitialPosition();
      $('.disp-max-pg').html(PAGE_MAX);
      updatePageNav('page-1');
      $( ".pow-group" ).click(function() {
        updatePageNav(this.id);
      });
      fillStudent(0); 
      $( ".upd-bkm" ).click(function() {
        $('#disp-bookm').html(snapshotCurrentParamImg());
      });

      // Do something
      $( "#addpay-ace" ).keyup(function() {
        verifyGraContentScan();
      });

      // Set personnal bold
      if(localStorage.getItem('prsCrsParam') == null){
        $('#prs-bkmk').prop("disabled", true);
      }
    }
    else{
      //Do nothing
    }
  
});