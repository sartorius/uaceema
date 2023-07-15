
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
  let getTempCountStu = getQtyStu(classeId);
  tempCountStu = parseInt(getTempCountStu[0]);
  tempPageNbr = parseInt(Math.floor(tempCountStu / pageLimit));
  if(getTempCountStu[1] > 0){
    tempPageNbr = tempPageNbr + 1;
  }
  $("#sel-stu-qty").html(tempCountStu);
  $("#sel-pag-qty").html(tempPageNbr);
  verifyExamMetadata();
}

function getQtyStu(classeId){
    for(let i=0; i<dataCountStuToJsonArray.length; i++){
      if(dataCountStuToJsonArray[i].COHORT_ID == classeId){
        return [dataCountStuToJsonArray[i].CPT_STU, dataCountStuToJsonArray[i].CPT_MODULO];
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

    //allowBannerAndMainPage(areMetaDataFilled);
    if(areMetaDataFilled == 'Y'){
        $("#gra-val-hea").prop("disabled", false);
    }else{
        $("#gra-val-hea").prop("disabled", true);
    }
}


function initializePage(){

    // Fill the data
    fillCartoucheMention();

    // No need to catch change for the Classe because it is inside the select function

    // catch the change of the date
    let examDate = document.getElementById('exam-day');
    examDate.addEventListener('change', function(e){
        verifyExamMetadata();
    });

    // TODO catch the change of the matiere

    // catch the change of the teacher
    $(document).on('change', 'input', function() {
        verifyExamMetadata();
    });
}

$(document).ready(function() {
    console.log('We are in gra load');

    if($('#mg-graph-identifier').text() == 'load-gra'){
      // Do something
      initializePage();

    }
    else{
      //Do nothing
    }
  
  });