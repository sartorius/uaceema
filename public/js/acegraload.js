
function printPresenceSheet(limit, maxIs){

    console.log('Click on printBatchStudentCard');
  
    // Here format A4
    let doc = new jsPDF('p','mm',[297, 210]);
  
    doc.setFont("Courier");
    doc.setFontType("bold");
    doc.setFontSize(9);
    doc.setTextColor(175,180,187);
  
    let rowSeter = 0;
    let columnSeter = 0;
    let itemPageCount = 10;
    const cardWidth = 105;
    const cardHeight = 59;
  
  
    for(let i=0; i<limit; i++){
          /************************/
  
          columnSeter = (i % 2);
  
          /************************/
  
  
          //
          doc.addImage(document.getElementById('pf-'+ i), //img src
                        'JPG', //format
                        3 + columnSeter*(cardWidth), //x oddOffsetX is to define if position 1 or 2
                        14 + rowSeter * cardHeight, //y
                        31, //Width
                        31, null, 'FAST'); //Height // Fast is to get less big files
  
          //getBase64Image('/img/mdl_data/' + filteredDataAllSTUToJsonArray[i].USERNAME.toLowerCase() + '.jpg', 'can-'+ i, doc);
  
  
          doc.addImage(document.getElementById('bg-'+ i), //img src
                        'PNG', //format
                        0 + columnSeter*(cardWidth),//x oddOffsetX is to define if position 1 or 2
                        0 + rowSeter * cardHeight, //y
                        cardWidth, //Width
                        cardHeight, null, 'FAST'); //Height // Fast is to get less big files
  
  
  
          doc.addImage(document.getElementById("item-bc-" + i).src, //img src
                        'PNG', //format
                        38 + columnSeter*(cardWidth), //x oddOffsetX is to define if position 1 or 2
                        25 + rowSeter * cardHeight, //y
                        50, //Width
                        25, null, 'FAST'); //Height // Fast is to get less big files
  
          doc.setTextColor('#242424');
          doc.setFont('Helvetica');
          doc.setFontStyle('normal');
          doc.setFontSize(12);
          doc.text(
            40 + columnSeter*(cardWidth), //x oddOffsetX is to define if position 1 or 2
            20 + rowSeter * cardHeight, //y
            filteredDataAllSTUToJsonArray[i].LASTNAME.substr(0, 20));
  
          doc.setFontSize(12);
          doc.text(
            40 + columnSeter*(cardWidth), //x oddOffsetX is to define if position 1 or 2
            25 + rowSeter * cardHeight, //y
            filteredDataAllSTUToJsonArray[i].FIRSTNAME.substr(0, 18));
  
            //$('#prt-pnom-'+ i).html(filteredDataAllSTUToJsonArray[i].FIRSTNAME.substr(0, 28));
  
  
          doc.setTextColor(48,91,159);
          doc.setFontSize(14);
          doc.addImage(document.getElementById('logo-carte'), //img src
                        'PNG', //format
                        77 + columnSeter*(cardWidth), //x oddOffsetX is to define if position 1 or 2
                        4 + rowSeter * cardHeight, //y
                        25, //Width
                        8, null, 'FAST'); //Height // Fast is to get less big files
  
          doc.setTextColor('#ADC2D2');
          doc.setFontSize(6);
          doc.text(
            15 + columnSeter*(cardWidth), //x oddOffsetX is to define if position 1 or 2
            57 + rowSeter * cardHeight, //y
            'uaceem.com - aceemgroupe.com - PRVO 26B Manakambahiny Antananarivo 101');
  
  
           // We have reach the 2nd column so we need to carriege return
           if(columnSeter == 1){
             rowSeter++;
           }
  
  
           if(itemPageCount == 1){
             doc.addPage();
             rowSeter = 0;
             itemPageCount = 10;
             if(i == (maxIs - 1)){
               doc.setTextColor('#242424');
               doc.setFont('Helvetica');
               doc.setFontStyle('normal');
               doc.setFontSize(15);
               doc.text(
                 10, //x oddOffsetX is to define if position 1 or 2
                 30, //y
                 'Le nombre de carte imprimable est limité à : ' + maxIs);
               doc.setTextColor('#242424');
               doc.setFont('Helvetica');
               doc.setFontStyle('normal');
               doc.setFontSize(12);
               doc.text(
                 10, //x oddOffsetX is to define if position 1 or 2
                 40, //y
                 'Pensez à utiliser le filtre du Manager étudiant pour imprimer des cartes en particulier.');
             }
           }
           else{
             itemPageCount = itemPageCount - 1;
           }
  
  
    }
  
    // Release the screen
    // We don't go at the end of the loop to avoid
    $("#waiting-blc").hide(500);
    $("#grid-all-blc").show(500);
    $("#grid-crit-blc").show(500);
  
    doc.save('BatchCartEtudiantUACEEM_Print');
  
}

function genInvPresenceSheet(){

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

function clearCartouche(){
    // reset the rest
    tempSubjectID = 0;
    tempSubject = '';
    tempCredit = 0;
    tempInvClass = 'na';
    tempArrayClass = new Array();
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
        let iTempInvClass = getInvolvedClasses();
        tempInvClass = iTempInvClass[0];
        tempArrayClass = (iTempInvClass[1]).toString().split('|');
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
        return [dataClassPerSubjectToJsonArray[i].GRP_VCC_SHORT_CLASS, dataClassPerSubjectToJsonArray[i].GRP_VCC_ID];
      }
    }
    return ['na', 'na'];
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

/*
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
} */

function allowGenerateAndMainPage(param){
    if(param == 'Y'){
        // This is to show input on each grade
        $('#main-gra').removeClass('mask-pg');
        $("#gra-gen-prs").prop("disabled", false);
        document.getElementById("file-upl-loader-gra").style.visibility = "visible";
        
    }
    else{
        // This is to hide input on each grade
        $('#main-gra').addClass('mask-pg');
        $("#gra-gen-prs").prop("disabled", true);
        document.getElementById("file-upl-loader-gra").style.visibility = "hidden";
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
    allowGenerateAndMainPage(areMetaDataFilled);
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