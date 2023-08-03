// First page is zero
function fillStudent(paramPage, ableToEdit){
    let strTable = '<table>';
    let paramPageLimit = (paramPage+1)*pageLimit;
    let paramStart = paramPage*pageLimit;
    let classEdit = 'gra-ta-in';
    if(ableToEdit == 'Y'){
        classEdit = '';
    }
    
    if(paramPageLimit > dataAllUSRToJsonArray.length){
        paramPageLimit = dataAllUSRToJsonArray.length;
    }

    for(let i=paramStart; i<paramPageLimit; i++){
        let existingInputGra = '';
        let highlightClassExisting = '';
        if((dataAllUSRToJsonArray[i].HID_GRA != '') &&
            (dataAllUSRToJsonArray[i].HID_GRA != 'x')){
                existingInputGra = dataAllUSRToJsonArray[i].HID_GRA;
                highlightClassExisting = 'ok-txtar';
        }
        
        strTable = strTable + '<tr>' ;
        strTable = strTable + '<td class="c-t1"><textarea id="gr' + i + '" name="gr' + i + '" rows="1" class="gra-txta ' + highlightClassExisting + ' ' + classEdit + '" cols="4" onkeyup="validateInputGra(' + i + ')" placeholder="0">' + existingInputGra + '</textarea></td>';
        strTable = strTable + '<td>' + dataAllUSRToJsonArray[i].VSH_FIRSTNAME.substring(0, maxLengthTable) + '</td>';
        strTable = strTable + '<td>' + dataAllUSRToJsonArray[i].VSH_LASTNAME.substring(0, maxLengthTable) + '</td>';
        strTable = strTable + '<td>' + dataAllUSRToJsonArray[i].VSH_USERNAME + '</td>';
        strTable = strTable + '<td>' + (parseInt(i) + 1) + '</td>';
        strTable = strTable + '</tr>';
    };
    //Need to fill the last page
    if(paramPage == (parseInt(PAGE_MAX) - 1)){
        for(let j=paramPageLimit; j<(PAGE_MAX*pageLimit); j++){
            strTable = strTable + '<tr>' ;
            strTable = strTable + '<td class="c-t1"><textarea name="gr' + j + '" rows="1" class="gra-txta gra-ta-in" cols="4" placeholder="0"></textarea></td>';
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

function validateInputGra(line){
    //console.log('click gra: ' + line + '/' + $('#gr'+line).val());
    // add this class err-txtar if error
    if(testRegexGrade($('#gr'+line).val())){
        $('#gr'+line).removeClass('err-txtar');
        if($('#gr'+line).val() != ''){
            $('#gr'+line).addClass('ok-txtar');
        }
        dataAllUSRToJsonArray[line].HID_GRA = $('#gr'+line).val().replace(',', '.');
    }
    else{
        $('#gr'+line).removeClass('ok-txtar').addClass('err-txtar');
        dataAllUSRToJsonArray[line].HID_GRA = 'x';
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
        // This is to show input on each grade
        $('.gra-txta').removeClass('gra-ta-in');

        $('#main-gra').removeClass('mask-pg');
        document.getElementById("ctrl-ban").style.visibility = "visible";
        document.getElementById("pg-nav").style.visibility = "visible";
        
    }
    else{
        // This is to hide input on each grade
        applyCrossBookmark('R');
        $('.gra-txta').addClass('gra-ta-in');
        
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
        document.getElementById("pg-btn-save").style.visibility = "hidden";
    }
    else if ((PAGE_MAX == 1)
        && (currentPage ==  1)){
        document.getElementById("pg-btn-prec").style.visibility = "hidden";
        document.getElementById("pg-btn-next").style.visibility = "hidden";
        document.getElementById("pg-btn-save").style.visibility = "visible";
    }
    else if(currentPage ==  PAGE_MAX){
        document.getElementById("pg-btn-prec").style.visibility = "visible";
        document.getElementById("pg-btn-next").style.visibility = "hidden";
        document.getElementById("pg-btn-save").style.visibility = "visible";
    }
    else{
        document.getElementById("pg-btn-prec").style.visibility = "visible";
        document.getElementById("pg-btn-next").style.visibility = "visible";
        document.getElementById("pg-btn-save").style.visibility = "hidden";
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
    fillStudent((parseInt(currentPage) - 1), 'Y');

    //Handle image here
    document.getElementById("ex-1").src =  PATH_IMG + SUB_PATH_IMG + dataAllPageToJsonArray[(currentPage - 1)].gra_path + dataAllPageToJsonArray[(currentPage - 1)].gra_filename;

    $('#disp-inv-pg').html(currentPage);
    resetNavFooterBtn();
    document.body.scrollTop = document.documentElement.scrollTop = 0;
    //Handle if first and last page
    
}





$(document).ready(function() {
    console.log('We are in gra add');
    if($('#mg-graph-identifier').text() == 'gra-add'){
    
      initInitialPosition();
      $('.disp-max-pg').html(PAGE_MAX);
      updatePageNav('page-1');
      $( ".pow-group" ).click(function() {
        updatePageNav(this.id);
      });
      fillStudent(0, 'N'); 
      $( ".upd-bkm" ).click(function() {
        $('#disp-bookm').html(snapshotCurrentParamImg());
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