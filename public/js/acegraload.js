
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

function clearCartouche(){
    // reset the rest
    tempSubjectID = 0;
    tempSubject = '';
    tempCredit = 0;
    tempInvClass = 'na';
    tempCountStu = 0;
    tempPageNbr = 0;
    $("#sel-stu-qty").html(tempCountStu);
    $("#sel-pag-qty").html(tempPageNbr);
    $("#disp-all-classes").html(tempInvClass);
    $("#sel-credit-qty").html(parseInt(tempCredit));
}

function selectMention(str, strTitle){
    tempMentionCode = str;
    tempMention = strTitle;

    $('#drp-select').html(strTitle);

    //console.log('You have just click on: ' + str);
    // We reset the dropdown
    selectNiveau(0, 'Niveau');
    fillCartoucheNiveau();
    fillModalTeacher();
    $('#teach-sel-gra').val('');
    $('#teacher-blk-gra').show(100);
    $('#exam-day').val('');

    // TODO Reinitialize Matiere
}

function selectNiveau(niveauId, str){
  tempNiveauID = niveauId;
  tempNiveau = str;

  $("#selected-niv").html(str);
  selectSubject(0, 'Matière', 0);
  fillCartoucheSubject();
  verifyExamMetadata();
  if(niveauId == 0){
    clearCartouche();
  }
}

function selectSubject(subjectId, str, credit){

    $("#selected-subj").html(str);
    if(subjectId == 0){
        clearCartouche();
    }
    else{
        tempSubjectID = subjectId;
        tempSubject = str;
        tempCredit = credit;
        tempInvClass = getInvolvedClasses();
        $("#disp-all-classes").html(tempInvClass);
    
        let getTempCountStu = getQtyStu();
        tempCountStu = parseInt(getTempCountStu[0]);
        tempPageNbr = parseInt(Math.floor(tempCountStu / pageLimit));
        if(parseInt(getTempCountStu[1]) > 0){
          tempPageNbr = tempPageNbr + 1;
        }
        $("#sel-stu-qty").html(tempCountStu);
        $("#sel-pag-qty").html(tempPageNbr);
        
        $("#sel-credit-qty").html(parseInt(tempCredit)/10);
    }
    verifyExamMetadata();
  }

function getQtyStu(){
    for(let i=0; i<dataNbrOfStuModToJsonArray.length; i++){
      if(dataNbrOfStuModToJsonArray[i].URS_ID == tempSubjectID){
        return [dataNbrOfStuModToJsonArray[i].CPT_STU, dataNbrOfStuModToJsonArray[i].CPT_MODULO];
      }
    }
    return 0;
}

function getInvolvedClasses(){
    for(let i=0; i<dataClassPerSubjectToJsonArray.length; i++){
      if(dataClassPerSubjectToJsonArray[i].URS_ID == tempSubjectID){
        return dataClassPerSubjectToJsonArray[i].GRP_VCC_SHORT_CLASS;
      }
    }
    return 'na';
}

function fillCartoucheNiveau(){
    let listNiveau = '';
    for(let i=0; i<dataNivSemesterToJsonArray.length; i++){
      if(dataNivSemesterToJsonArray[i].URS_MENTION_CODE == tempMentionCode){
        listNiveau = listNiveau + '<a class="dropdown-item" onclick="selectNiveau(' + i + ', \'' + dataNivSemesterToJsonArray[i].URS_NIVSEM + '\')"  href="#">' + dataNivSemesterToJsonArray[i].URS_NIVSEM + '</a>';
      }
    }
    $('#dpniv-opt').html(listNiveau);
}

function fillCartoucheSubject(){
    let listSubject = '';
    for(let i=0; i<dataTitlePerNivToJsonArray.length; i++){
      if((dataTitlePerNivToJsonArray[i].URS_MENTION_CODE == tempMentionCode) && (dataTitlePerNivToJsonArray[i].URS_NIVSEM == tempNiveau)){
        listSubject = listSubject + '<a class="dropdown-item" onclick="selectSubject(' + dataTitlePerNivToJsonArray[i].URS_ID + ', \'' + dataTitlePerNivToJsonArray[i].URS_SUBJECT_TITLE + '\'' + ', ' + dataTitlePerNivToJsonArray[i].URS_CREDIT + ')"  href="#">' + dataTitlePerNivToJsonArray[i].URS_SUBJECT_TITLE + '</a>';
      }
    }
    $('#dpsubj-opt').html(listSubject);
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
    if($('#selected-niv').html() != 'Niveau'){
        areMetaDataFilled = 'Y';
        $('#selected-niv').removeClass('ctrl-mis');
    }
    else{
        areMetaDataFilled = 'N';
        $('#selected-niv').addClass('ctrl-mis');
    }

    // TODO Check Matiere
    if($('#selected-subj').html() != 'Matière'){
        areMetaDataFilled = 'Y';
        $('#selected-subj').removeClass('ctrl-mis');
    }
    else{
        areMetaDataFilled = 'N';
        $('#selected-subj').addClass('ctrl-mis');
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