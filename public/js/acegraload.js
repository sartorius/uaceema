// Add matricule
function printPresenceSheet(){

    console.log('Click on printPresenceSheet');
  
    // Initiate list of student
    let presenceList = new Array();
    for(let i=0; i<dataAllStuToJsonArray.length; i++){
        if(tempArrayClass.includes((dataAllStuToJsonArray[i].VSH_COHORT_ID).toString())){
            presenceList.push(i);
        }
    }
    //console.log('presenceList: ' + presenceList.length);

    // Here format A4
    let doc = new jsPDF('p','mm',[297, 210]);
  
    doc.setFont("Courier");
    doc.setFontType("bold");
    doc.setFontSize(9);
    doc.setTextColor(175,180,187);
  
    const rawHeight = 8.35;
    const maxStrS = 10;
    const maxStrM = 15;
    const maxStrL1 = 15;
    const maxStrL2 = 23;
    const maxStrL3 = 35;

    const maxStrMatricule = 6;
    
    doc.addImage(document.getElementById('bg-tmpl'), //img src
                        'PNG', //format
                        0,//x oddOffsetX is to define if position 1 or 2
                        0, //y
                        210, //Width
                        297, null, 'FAST'); //Height // Fast is to get less big files

    doc.addImage(document.getElementById('logo-ace'), //img src
                        'PNG', //format
                        1,//x oddOffsetX is to define if position 1 or 2
                        1, //y
                        19, //Width
                        8, null, 'FAST'); //Height // Fast is to get less big files
    //pageLimit
    let pgCount = 0;
    let pgNbr = 1;
    let AllPage = (Math.floor(tempCountStu/pageLimit) == tempCountStu/pageLimit) ? Math.floor(tempCountStu/pageLimit) : Math.floor(tempCountStu/pageLimit) + 1;
    let refDate = new Date(Date.parse($('#exam-day').val()));

    // DO THE LOOP !
    for(let i=0; i<tempCountStu; i++){

        if(pgCount == 0){
            //Write header
            doc.setFont('Helvetica');
            doc.setFontStyle('normal');
            doc.setTextColor(0, 0, 0);
            doc.setFontSize(10);
            doc.text(
                20, //x oddOffsetX is to define if position 1 or 2
                8, //y
                '[' + $('#drp-select').html().substr(0, maxStrM) + ' - ' + $('#selected-niv').html() + ']  *** Matière : ' + $('#selected-subj').html().substr(0, maxStrL3)
                );
            doc.text(
                50, //x oddOffsetX is to define if position 1 or 2
                23 + pageLimit*rawHeight, //y
                 $('#teach-sel-gra').val().substr(0, maxStrL3) + ' - Date : ' + formatterDateFR.format(refDate) + ' - Page ' + pgNbr + ' sur ' + AllPage
                );
            doc.setFontSize(8);
            doc.text(
                45, //x oddOffsetX is to define if position 1 or 2
                13, //y
                tempInvClass
                );
        }

        doc.setFont('Courier');
        doc.setFontStyle('normal');
        doc.setTextColor(0, 0, 0);
        doc.setFontSize(11);
        doc.text(
            7, //x oddOffsetX is to define if position 1 or 2
            23 + pgCount*rawHeight, //y
            (i+1).toString()
            );
        doc.text(
            63, //x oddOffsetX is to define if position 1 or 2
            23 + pgCount*rawHeight, //y
            //VSH_LASTNAME VSH_FIRSTNAME
            dataAllStuToJsonArray[parseInt(presenceList[i])].VSH_USERNAME
            );
        doc.text(
            44, //x oddOffsetX is to define if position 1 or 2
            23 + pgCount*rawHeight, //y
            //VSH_LASTNAME VSH_FIRSTNAME
            //We assume the maximum of Matricule is 5 digit
            dataAllStuToJsonArray[parseInt(presenceList[i])].VSH_SMATRICULE.toString().padStart(maxStrMatricule, PADD_CHAR)
            );
        doc.text(
            90, //x oddOffsetX is to define if position 1 or 2
            23 + pgCount*rawHeight, //y
            dataAllStuToJsonArray[parseInt(presenceList[i])].VSH_LASTNAME.substr(0, maxStrL2).padStart(maxStrL2, PADD_CHAR)
            );
        doc.text(
            146.5, //x oddOffsetX is to define if position 1 or 2
            23 + pgCount*rawHeight, //y
            dataAllStuToJsonArray[parseInt(presenceList[i])].VSH_FIRSTNAME.substr(0, maxStrL1).padStart(maxStrL1, PADD_CHAR)
            );

        
        if(pgCount<pageLimit-1){
            pgCount = pgCount +1;
        }
        else{
            pgCount = 0;
            pgNbr = pgNbr + 1;
            doc.addPage();
            doc.addImage(document.getElementById('bg-tmpl'), //img src
                        'PNG', //format
                        0,//x oddOffsetX is to define if position 1 or 2
                        0, //y
                        210, //Width
                        297, null, 'FAST'); //Height // Fast is to get less big files
            
            doc.addImage(document.getElementById('logo-ace'), //img src
                        'PNG', //format
                        1,//x oddOffsetX is to define if position 1 or 2
                        1, //y
                        19, //Width
                        8, null, 'FAST'); //Height // Fast is to get less big files
        }
    }
  
    // Release the screen
    // We don't go at the end of the loop to avoid
    $("#waiting-blc").hide(500);
    $("#grid-all-blc").show(500);
    $("#grid-crit-blc").show(500);
  
    doc.save('Exam_' + $('#drp-select').html().substr(0, maxStrS) + '_' + $('#selected-niv').html().replaceAll('/', '_') + '_' + formatterDateFR.format(refDate).replaceAll('/', '') + '_PRESENCE');
  
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
    $("#fPageNbr").val(tempPageNbr);
    $("#fSubToken").val('0');

    $("#disp-all-classes").html('<i class="icon-columns nav-text"></i>&nbsp;' + tempInvClass);
    $("#sel-credit-qty").html(parseInt(tempCredit));
}

function selectMention(str, strTitle){
    tempMentionCode = str;
    tempMention = strTitle;


    
    $('#drp-select').html(strTitle);
    // Necessary to save the file
    $("#fMentionCode").val(tempMentionCode);

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
        $("#disp-all-classes").html('<i class="icon-columns nav-text"></i>&nbsp;' + tempInvClass);
    
        let getTempCountStu = getQtyStu();
        tempCountStu = parseInt(getTempCountStu[0]);
        tempPageNbr = parseInt(Math.floor(tempCountStu / pageLimit));
        if(parseInt(getTempCountStu[1]) > 0){
          tempPageNbr = tempPageNbr + 1;
        }
        $("#sel-stu-qty").html(tempCountStu);
        $("#sel-pag-qty").html(tempPageNbr);
        $("#fPageNbr").val(tempPageNbr);
        $("#fSubToken").val(SUB_TOKEN);
        
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

function setAndGetTeacherId(){
    // fTeacherId fCustTeacherName fSubjectId fExamDate
    let selectedTeacherId = $('#teach-list option').filter(function() {
                                return this.value === $('#teach-sel-gra').val();
                            }).data("id");
    if(selectedTeacherId == undefined){
                tempTeacherId = 0;
    }
    else{
                tempTeacherId = selectedTeacherId;
    }
    tempTeacherName = $('#teach-sel-gra').val();
    return selectedTeacherId;
}


function allowGenerateAndMainPage(param){
    if(param == 'Y'){
        // This is to show input on each grade
        $('#main-gra').removeClass('mask-pg');
        $("#gra-gen-prs").prop("disabled", false);
        document.getElementById("file-upl-loader-gra").style.visibility = "visible";
        document.getElementById("loader-block-gra").style.visibility = "visible";

        
        $("#fTeacherId").val(setAndGetTeacherId());
        $("#fCustTeacherName").val($('#teach-sel-gra').val());
        $("#fSubjectId").val(tempSubjectID);
        $("#fExamDate").val($('#exam-day').val());
        $("#fBrowser").val(getBrowserId());
        $("#fNiveau").val($('#selected-niv').html());
        $("#fSubject").val($('#selected-subj').html());
        
    }
    else{
        // This is to hide input on each grade
        $('#main-gra').addClass('mask-pg');
        $("#gra-gen-prs").prop("disabled", true);
        document.getElementById("file-upl-loader-gra").style.visibility = "hidden";
        document.getElementById("loader-block-gra").style.visibility = "hidden";
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