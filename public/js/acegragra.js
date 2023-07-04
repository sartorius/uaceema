function fillStudent(){
    let strTable = '<table>';
    for(let i=0; i<dataAllUSRToJsonArray.length; i++){
        strTable = strTable + '<tr>'
                    + '<td><textarea id="gr' + i + '" name="gr' + i + '" rows="1" class="gra-ta-in" cols="3" placeholder="0"></textarea></td>'
                    + '<td>' + dataAllUSRToJsonArray[i].VSH_FIRSTNAME + '</td>'
                    + '<td>' + dataAllUSRToJsonArray[i].VSH_LASTNAME + '</td>'
                    + '<td>' + dataAllUSRToJsonArray[i].VSH_USERNAME + '</td>'
                    + '<td>' + (parseInt(i) + 1) + '</td>'
                    + '</tr>';
    };
    strTable = strTable + '</table>';
    $("#gra-gr").html(strTable);
}

function grow(param){
    let growValue = 1 + (0.01*invPower);
    if (param == 'A'){
        growValue = 1 - (0.01*invPower);
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
    direction =  direction * invPower;
    let currentLeft = $("#ex-1").css("left");
    currentLeft = currentLeft.substring(0, currentLeft.length-2);
    document.getElementById("ex-1").style.left = parseInt(currentLeft) + (5 * direction) + "px";
}

function itop(param){
    let direction = 1;
    if (param == 'A'){
        direction = -1;
    }
    // Set the power value here
    direction =  direction * invPower;
    let currentTop = $("#ex-1").css("top");
    currentTop = currentTop.substring(0, currentTop.length-2);
    document.getElementById("ex-1").style.top = parseInt(currentTop) + (5 * direction) + "px";
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

// Width/Left/Top/Rotation
// 1463.95/-780px/-210px/0
function applyCrossBookmark(savedParam){
    let savedParamArray = savedParam.split('/');
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

function updatePower(activeId){
    $('.pow-group').removeClass('active');  // Remove any existing active classes
    $('.pow-group').addClass('unsel-grp');  // Remove any existing active classes
    
    $('#' + activeId).addClass('active').removeClass('unsel-grp'); // Add the class to the nth element

    invPower = parseInt(activeId.split('-')[1]);
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


function fillCartoucheMention(){
    let listMention = '';
    for(let i=0; i<dataMentionToJsonArray.length; i++){
        listMention = listMention + '<a class="dropdown-item" onclick="selectMention(\'' + dataMentionToJsonArray[i].par_code + '\', \'' + dataMentionToJsonArray[i].title + '\')"  href="#">' + dataMentionToJsonArray[i].title + '</a>';
    }
    $('#dpmention-opt').html(listMention);
}

function selectMention(str, strTitle){
    tempMentionCode = str;
    tempMention = strTitle;
    $('#drp-select').html(strTitle);
    //console.log('You have just click on: ' + str);
    // We reset the dropdown
    selectClasse(0, 'Classe');
    fillCartoucheClasse();
    fillModalTeacher();
    $('#teach-sel-gra').val('');
    $('#teacher-blk-gra').show(100);
    $('#exam-day').val('');

    // TODO Reinitialize Matiere
}

function selectClasse(classeId, str){
  tempClasseID = classeId;
  tempClasse = str;

  $("#selected-class").html(str);
  tempCountStu = getQtyStu(classeId);
  $("#sel-stu-qty").html(tempCountStu);
  verifyExamMetadata();
}

function getQtyStu(classeId){
    for(let i=0; i<dataCountStuToJsonArray.length; i++){
      if(dataCountStuToJsonArray[i].COHORT_ID == classeId){
        return dataCountStuToJsonArray[i].CPT_STU;
      }
    }
    return 0;
}

function fillCartoucheClasse(){
    let listClasse = '';
    for(let i=0; i<dataAllClassToJsonArray.length; i++){
      if(dataAllClassToJsonArray[i].mention_code == tempMentionCode){
        listClasse = listClasse + '<a class="dropdown-item" onclick="selectClasse(' + dataAllClassToJsonArray[i].id + ', \'' + dataAllClassToJsonArray[i].short_classe + '\', 1)"  href="#">' + dataAllClassToJsonArray[i].short_classe + '</a>';
      }
    }
    $('#dpclasse-opt').html(listClasse);
}
  
  
function fillModalTeacher(){
    let teacherList = "";
    filteredTeacherList = new Array();
    for(let i=0; i<dataTeacherToJsonArray.length; i++){
      if(dataTeacherToJsonArray[i].mention_code == tempMentionCode){
        //teacherList = teacherList + '<option value="' + dataTeacherToJsonArray[i].id + '" >' + dataTeacherToJsonArray[i].name + '</option>';
        teacherList = teacherList + '<option data-id="' + dataTeacherToJsonArray[i].id + '">' + dataTeacherToJsonArray[i].name + '</option>';
        // Input in the list
        filteredTeacherList.push(dataTeacherToJsonArray[i].name);
      }
      else{
        // do nothing
      }
    }
    $('#teach-list').html(teacherList);
}

function verifyExamMetadata(){
    let areMetaDataFilled = 'N';

    // Check Classe
    if($('#selected-class').html() != 'Classe'){
        areMetaDataFilled = 'Y';
        $('#selected-class').removeClass('ctrl-mis');
    }
    else{
        areMetaDataFilled = 'N';
        $('#selected-class').addClass('ctrl-mis');
    }

    // Check Date
    if(($('#exam-day').val() != '') && (areMetaDataFilled == 'Y')){
        areMetaDataFilled = 'Y';
        $('#exam-day').removeClass('ctrl-mis');
    }
    else{
        areMetaDataFilled = 'N';
        $('#exam-day').addClass('ctrl-mis');
    }

    // TODO Check Matiere
    // TBD

    // Check Teacher
    if(($('#teach-sel-gra').val() != '') && (areMetaDataFilled == 'Y')){
        areMetaDataFilled = 'Y';
        $('#teach-sel-gra').removeClass('ctrl-mis');
    }
    else{
        areMetaDataFilled = 'N';
        $('#teach-sel-gra').addClass('ctrl-mis');
    }

    if(areMetaDataFilled == 'N'){
        console.log('Not all meta are filled');
    }
    else{
        console.log('All meta are filled');
    }
}

function initializePage(){

    // Fill the data
    fillCartoucheMention();

    // No need to catch change for the Classe because it is inside the select function

    // catch the change of the date
    let examDate = document.getElementById('exam-day');
    examDate.addEventListener('change',(e)=>{
        verifyExamMetadata();
    });

    // TODO catch the change of the matiere

    // catch the change of the teacher
    $(document).on('change', 'input', function() {
        verifyExamMetadata();
    });
}



$(document).ready(function() {
    console.log('We are in gra gra');
    if($('#mg-graph-identifier').text() == 'gra-aex'){
      // Do something
      fillStudent();
      //document.getElementById('exam-day').valueAsDate = new Date();
      updatePower('pow-1')
      $( ".pow-group" ).click(function() {
        updatePower(this.id);
      });


      initializePage();

    }
    else{
      //Do nothing
    }
  
});