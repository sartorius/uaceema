

function initAllExamGrid(){
  $('#filter-all-pri').keyup(function() {
    filterDataAllPri();
  });
  $('#re-init-dash-pri').click(function() {
    $('#filter-all-pri').val('');
    clearDataAllPri();
  });
}

 

function filterDataAllPri(){
  if(($('#filter-all-pri').val().length > 1) && ($('#filter-all-pri').val().length < 35)){
    //console.log('We need to filter !' + $('#filter-all').val());
    //console.log('in : filterDataAllPri');
    filtereddataPrimitifLineToJsonArray = dataPrimitifLineToJsonArray.filter(function (el) {
                                      return el.raw_data.includes($('#filter-all-pri').val().toUpperCase())
                                  });
    loadPrimitifMain();
  }
  else if(($('#filter-all-pri').val().length < 2)) {
    // We clear data
    clearDataAllPri();
  }
  else{
    // DO nothing
  }
}

function clearDataAllPri(){
  filtereddataPrimitifLineToJsonArray = Array.from(dataPrimitifLineToJsonArray);
  
  loadPrimitifMain();
};


function loadPrimitifMain(){
    //console.log('in : loadPrimitifMain');
    let tabStr = '<table>';

    const EMPTY_HEAD_PRELINE_SUBJ = '<tr id="hd-pri-subj" class="hd-freez head-prim-line"><th class="prim-emp"></th><th class="prim-emp"></th><th class="prim-emp"></th><th class="prim-emp"></th>';
    const EMPTY_HEAD_PRELINE = '<th class="prim-emp"></th><th class="prim-emp"></th><th class="prim-emp"></th><th style="text-align: right;">';

    // Line of subject

    // Line of semester
    let headerStr = '<tr id="hd-pri-sem" class="hd-freez head-prim-std">' + '<th>' + SHORT_CLASS + '</th><th>' + YEAR + '</th><th></th><th style="text-align: right;">' + 'Semestre' + '</th>';
    for(let i=0; i<NBR_EXAM; i++){
      headerStr += "<th class='gra-c' style='width: 60px;'>" + dataPrimitifLineToJsonArray[i].URS_SEMESTER + '</th>';
    }
    headerStr += '<th class="prim-emp"></th></tr>';
    tabStr += headerStr;

    // Line of Reference
    headerStr = '<tr id="hd-pri-subjid" class="hd-freez head-prim-std">' + EMPTY_HEAD_PRELINE + '#' + '</th>';
    for(let i=0; i<NBR_EXAM; i++){
      headerStr += "<th class='gra-c' style='width: 60px;'>" + dataPrimitifLineToJsonArray[i].URS_ID + '</th>';
    }
    headerStr += '<th class="prim-emp"></th></tr>';
    tabStr += headerStr;

    headerStr = EMPTY_HEAD_PRELINE_SUBJ;
    for(let i=0; i<NBR_EXAM; i++){
      headerStr += "<th class='head-prim' style='width: 60px;'>" + dataPrimitifLineToJsonArray[i].URS_TITLE.substr(0, 25) + '</th>';
    }
    headerStr += '<th class="prim-emp"></th></tr>';
    tabStr += headerStr;

    // Line of credit
    headerStr = '<tr id="hd-pri-crd" class="hd-freez head-prim-std">' + EMPTY_HEAD_PRELINE + sumOfCredit/10 + '/60&nbsp;Crédits' + '</th>';
    for(let i=0; i<NBR_EXAM; i++){
      headerStr += "<th class='gra-c' style='width: 60px;'>" + dataPrimitifLineToJsonArray[i].URS_CREDIT/10 + '</th>';
    }
    headerStr += '<th class="prim-emp"></th></tr>';
    tabStr += headerStr;

    // Line of credit
    headerStr = '<tr id="hd-pri-avg" class="hd-freez head-prim-std">' + EMPTY_HEAD_PRELINE + 'Moyenne' + '</th>';
    for(let i=0; i<NBR_EXAM; i++){
      headerStr += "<th class='gra-c' style='width: 60px;'>" + dataPrimitifLineToJsonArray[i].UGG_AVG + '</th>';
    }
    headerStr += '<th class="prim-emp"></th></tr>';
    tabStr += headerStr;

    // Line of date
    headerStr = "<tr id='hd-pri-date' class='hd-freez head-prim-std'>" + EMPTY_HEAD_PRELINE + 'Date' + '</th>';
    for(let i=0; i<NBR_EXAM; i++){
      headerStr += "<th class='gra-c' style='width: 60px;'>" + dataPrimitifLineToJsonArray[i].UGM_DATE + '</th>';
    }
    headerStr += '<th class="prim-emp" style="width: 170px;">Observation assiduité</th></tr>';
    tabStr += headerStr;

    var i=0;
    while (i<filtereddataPrimitifLineToJsonArray.length){
      //We read student per student
      var lineStr = '';
      lineStr += "<tr><td style='width: 100px;'>" + "<a href='/profile/" + filtereddataPrimitifLineToJsonArray[i].VSH_PAGE + "' target='_blank'>" + filtereddataPrimitifLineToJsonArray[i].VSH_USERNAME + "</a></td><td style='width: 120px;'>" + filtereddataPrimitifLineToJsonArray[i].VSH_FIRSTNAME + "</td><td style='width: 200px;'>" + filtereddataPrimitifLineToJsonArray[i].VSH_LASTNAME + "</td><td style='width: 120px;'>" + filtereddataPrimitifLineToJsonArray[i].VSH_MATRICULE + "</td>";
      for(var j=(0 + i); j<(NBR_EXAM + i); j++){
        if(((filtereddataPrimitifLineToJsonArray[j].UGG_GRADE != 'E')
            || (filtereddataPrimitifLineToJsonArray[j].UGG_GRADE != 'A'))
            && (parseFloat(filtereddataPrimitifLineToJsonArray[j].UGG_GRADE) < 7)){
          lineStr += "<td class='gra-c'  style='width: 60px;'><i class='recap-mis'>" + filtereddataPrimitifLineToJsonArray[j].UGG_GRADE + '</i></td>';
        }
        else if(((filtereddataPrimitifLineToJsonArray[j].UGG_GRADE != 'E')
            || (filtereddataPrimitifLineToJsonArray[j].UGG_GRADE != 'A'))
            && (parseFloat(filtereddataPrimitifLineToJsonArray[j].UGG_GRADE) < 10)){
          lineStr += "<td class='gra-c'  style='width: 60px;'><i class='recap-qui'>" + filtereddataPrimitifLineToJsonArray[j].UGG_GRADE + '</i></td>';
        }
        else{
          lineStr += "<td class='gra-c'  style='width: 60px;'>" + filtereddataPrimitifLineToJsonArray[j].UGG_GRADE + '</td>';
        }
      }
      lineStr += "<td>" + filtereddataPrimitifLineToJsonArray[i].OBSERV_ASS.replaceAll('_', '<br>') + "</td>";
      lineStr += "</tr>";
      tabStr += lineStr;

      // END OF WHILE
      i = i+NBR_EXAM;
    }

    tabStr += '</table>';
    $('#main-pri').html(tabStr);

    $('#nbr-fil-et').html(filtereddataPrimitifLineToJsonArray.length/NBR_EXAM);
}


function generateReportPrimitive(){
    const csvContentType = "data:text/csv;charset=utf-8,";
    let csvContent = "";
    const SEP_ = ";";

    let dataString = "";

    const EMPTY_HEAD_PRELINE_SUBJ = SEP_ + SEP_ + SEP_ + SEP_;
    const EMPTY_HEAD_PRELINE = SEP_ + SEP_ + SEP_;

    // Line of subject

    // Line of semester
    let headerStr = SHORT_CLASS + SEP_ + YEAR + SEP_ + SEP_ + 'Semestre' + SEP_;
    for(let i=0; i<NBR_EXAM; i++){
      headerStr += dataPrimitifLineToJsonArray[i].URS_SEMESTER + SEP_;
    }
    headerStr += SEP_ + "\n";
    dataString += headerStr;

    // Line of Reference
    headerStr =  EMPTY_HEAD_PRELINE + '#' + SEP_;
    for(let i=0; i<NBR_EXAM; i++){
      headerStr += dataPrimitifLineToJsonArray[i].URS_ID + SEP_;
    }
    headerStr += SEP_ + "\n";
    dataString += headerStr;

    headerStr = EMPTY_HEAD_PRELINE_SUBJ;
    for(let i=0; i<NBR_EXAM; i++){
      headerStr += dataPrimitifLineToJsonArray[i].URS_TITLE.substr(0, 25) + SEP_;
    }
    headerStr += SEP_ + "\n";
    dataString += headerStr;

    // Line of credit
    headerStr = EMPTY_HEAD_PRELINE + sumOfCredit/10 + '/60 Crédits' + SEP_;
    for(let i=0; i<NBR_EXAM; i++){
      headerStr += dataPrimitifLineToJsonArray[i].URS_CREDIT/10 + SEP_;
    }
    headerStr += SEP_ + "\n";
    dataString += headerStr;

    // Line of credit
    headerStr = EMPTY_HEAD_PRELINE + 'Moyenne' + SEP_;
    for(let i=0; i<NBR_EXAM; i++){
      headerStr += dataPrimitifLineToJsonArray[i].UGG_AVG + SEP_;
    }
    headerStr += SEP_ + "\n";
    dataString += headerStr;

    // Line of date
    headerStr = EMPTY_HEAD_PRELINE + 'Date' + SEP_;
    for(let i=0; i<NBR_EXAM; i++){
      headerStr += dataPrimitifLineToJsonArray[i].UGM_DATE + SEP_;
    }
    headerStr += "Observation assiduité" + "\n";
    dataString += headerStr;

    var i=0;
    while (i<filtereddataPrimitifLineToJsonArray.length){
      //We read student per student
      var lineStr = '';
      lineStr += filtereddataPrimitifLineToJsonArray[i].VSH_USERNAME + SEP_ + filtereddataPrimitifLineToJsonArray[i].VSH_FIRSTNAME + SEP_ + filtereddataPrimitifLineToJsonArray[i].VSH_LASTNAME + SEP_ + filtereddataPrimitifLineToJsonArray[i].VSH_MATRICULE + SEP_;
      for(var j=(0 + i); j<(NBR_EXAM + i); j++){
        lineStr += filtereddataPrimitifLineToJsonArray[j].UGG_GRADE + SEP_;
      }
      lineStr += filtereddataPrimitifLineToJsonArray[i].OBSERV_ASS + "\n";
      dataString += lineStr;

      // END OF WHILE
      i = i+NBR_EXAM;
    }

    //console.log('Click on csv');
    let encodedUri = encodeURI(dataString);
    let csvData = new Blob([dataString], { type: csvContentType });

        let link = document.createElement("a");
    let csvUrl = URL.createObjectURL(csvData);

    link.href =  csvUrl;
    link.style = "visibility:hidden";
    link.download = 'RapportPrimitif' + SHORT_CLASS.replaceAll('/', '_') + '.csv';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
}


// ******************************************************************************************************************************
// ******************************************************************************************************************************
// ******************************************************************************************************************************
// ******************************************************************************************************************************
// ******************************************************************************************************************************
// ******************************************************************************************************************************
// ******************************************************************************************************************************
// ******************************************************************************************************************************
// ******************************************************************************************************************************
// ******************************************              MANAGER            ***************************************************
// ******************************************************************************************************************************
// ******************************************************************************************************************************
// ******************************************************************************************************************************
// ******************************************************************************************************************************
// ******************************************************************************************************************************
// ******************************************************************************************************************************
// ******************************************************************************************************************************
// ******************************************************************************************************************************
// ******************************************************************************************************************************

function initAllSubGrid(){
    $('#filter-all-sub').keyup(function() {
        filterDataAllSub();
    });
    $('#re-init-dash-sub').click(function() {
      $('#filter-all-sub').val('');
      clearDataAllSub();
    });
}
  
function filterDataAllSub(){
    if(($('#filter-all-sub').val().length > 1) && ($('#filter-all-sub').val().length < 35)){
      //console.log('We need to filter !' + $('#filter-all').val());
      filtereddataAllSubjectToJsonArray = dataAllSubjectToJsonArray.filter(function (el) {
                                        return el.raw_data.includes($('#filter-all-sub').val().toUpperCase())
                                    });
        loadAllSubGrid();
    }
    else if(($('#filter-all-sub').val().length < 2)) {
      // We clear data
      clearDataAllSub();
    }
    else{
      // DO nothing
    }
}
  
function clearDataAllSub(){
    filtereddataAllSubjectToJsonArray = Array.from(dataAllSubjectToJsonArray);
    
    loadAllSubGrid();
};

function loadAllSubGrid(){

    refSubField = [
        { name: "URS_MENTION_CODE",
          title: "Mention",
          type: "text",
          width: 20,
          align: "center",
          headercss: "cell-ref-uac-sm-hd",
          css: "cell-ref-uac-sm",
          itemTemplate: function(value, item) {
            if (item.IS_NEW == 'Y'){
              return '<i class="recap-dirty">' + value + '</i>';
            }
            else{
              return value;
            }
          }
        },
        { name: "URS_NIVEAU_CODE",
          title: "Niveau",
          type: "text",
          width: 10,
          align: "center",
          headercss: "cell-ref-uac-sm-hd",
          css: "cell-ref-uac-sm",
          itemTemplate: function(value, item) {
            if (item.IS_NEW == 'Y'){
              return '<i class="recap-dirty">' + value + '</i>';
            }
            else{
              return value;
            }
          }
        },
        { name: "URS_SEMESTER",
          title: "Sem.",
          type: "text",
          width: 10,
          align: "center",
          headercss: "cell-ref-uac-sm-hd",
          css: "cell-ref-uac-sm",
          itemTemplate: function(value, item) {
            if (item.IS_NEW == 'Y'){
              return '<i class="recap-dirty">' + value + '</i>';
            }
            else{
              return value;
            }
          }
        },
        { name: "URS_CREDIT",
          title: "Crédit",
          type: "text",
          width: 10,
          align: "center",
          headercss: "cell-ref-uac-sm-hd",
          css: "cell-ref-uac-sm",
          itemTemplate: function(value, item) {
            if (item.IS_NEW == 'Y'){
              return '<i class="recap-dirty">' + value/10 + '</i>';
            }
            else{
              return value/10;
            }
          }
        },
        { name: "ALL_PARCOURS",
          title: "Parcours",
          type: "text",
          align: "left",
          width: 30,
          headercss: "cell-ref-uac-sm-hd",
          css: "cell-ref-uac-sm",
          itemTemplate: function(value, item) {
            if (item.IS_NEW == 'Y'){
              return '<i class="recap-dirty">' + value.substr(0, 17) + '</i>';
            }
            else{
              return value.substr(0, 17);
            }
          }
        },
        { name: "URS_SUBJECT_TITLE",
          title: "Titre",
          type: "text",
          align: "left",
          headercss: "cell-ref-uac-sm-hd",
          css: "cell-ref-uac-sm",
          itemTemplate: function(value, item) {
            if (item.IS_NEW == 'Y'){
              return '<i class="recap-dirty">' + value.substr(0, 75) + '</i>';
            }
            else{
              return value.substr(0, 75);
            }
          }
        },
        { name: "URS_ID",
          title: "&nbsp;",
          width: 20,
          type: "text",
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm-center",
          itemTemplate: function(value, item) {
            if((WRITE_ACCESS_SUBJECT == 'Y') 
                  && (parseInt(item.GRA_EXIST_EXAM_ID) == 0)){
              return '<button class="btn btn-dark tg-del" onclick="deleteSubjectDialog(' + value + ', \'' + item.URS_SUBJECT_TITLE + '\', \'' + item.URS_MENTION_CODE + '/' + item.URS_NIVEAU_CODE + '/' + item.URS_SEMESTER + '/' + item.ALL_PARCOURS + '\')"><i class="icon-trash-o"></i></button>';
            }
            else{
              return '<i class="recap-deactivate icon-trash-o"></i>';
            }
          }
        }
    ];

    $("#jsGridAllSub").jsGrid({
        height: "auto",
        width: "100%",
        noDataContent: "Aucun sujet disponible",
        pageIndex: 1,
        pageSize: 50,
        pagePrevText: "Prec",
        pageNextText: "Suiv",
        pageFirstText: "Prem",
        pageLastText: "Dern",

        sorting: true,
        paging: true,
        data: filtereddataAllSubjectToJsonArray,
        fields: refSubField,
        rowClick: function(args){
          // Do something
        }
    });

    // Update the count
    $('#count-sub').html(filtereddataAllSubjectToJsonArray.length);
}

// ************************************************************************************
function initAllNivGrid(){
    $('#filter-all-niv').keyup(function() {
        filterDataAllNiv();
    });
    $('#re-init-dash-niv').click(function() {
      $('#filter-all-niv').val('');
      clearDataAllNiv();
    });
}
  
function filterDataAllNiv(){
    if(($('#filter-all-niv').val().length > 1) && ($('#filter-all-niv').val().length < 35)){
      //console.log('We need to filter !' + $('#filter-all').val());
      filtereddataAllPrimitifToJsonArray = dataAllPrimitifToJsonArray.filter(function (el) {
                                        return el.raw_data.includes($('#filter-all-niv').val().toUpperCase())
                                    });
        loadAllNivGrid();
    }
    else if(($('#filter-all-niv').val().length < 2)) {
      // We clear data
      clearDataAllNiv();
    }
    else{
      // DO nothing
    }
}
  
function clearDataAllNiv(){
    filtereddataAllPrimitifToJsonArray = Array.from(dataAllPrimitifToJsonArray);
    
    loadAllNivGrid();
};

function loadAllNivGrid(){

    refNivField = [
        { name: "URS_MENTION_CODE",
          title: "Mention",
          type: "text",
          width: 15,
          align: "center",
          headercss: "cell-dark-uac-sm-hd",
          css: "cell-ref-uac-sm"
        },
        { name: "URS_NIVEAU_CODE",
          title: "Niv.",
          type: "text",
          width: 10,
          align: "center",
          headercss: "cell-dark-uac-sm-hd",
          css: "cell-ref-uac-sm"
        },
        { name: "VCC_SHORTCLASS",
          title: "Classe",
          type: "text",
          width: 30,
          align: "center",
          headercss: "cell-dark-uac-sm-hd",
          css: "cell-ref-uac-sm"
        },
        { name: "URS_CPT",
          title: "Nbr",
          type: "text",
          width: 10,
          align: "center",
          headercss: "cell-dark-uac-sm-hd",
          css: "cell-ref-uac-sm"
        }
    ];

    $("#jsGridAllNiv").jsGrid({
        height: "auto",
        width: "100%",
        noDataContent: "Aucun examen disponible",
        pageIndex: 1,
        pageSize: 50,
        pagePrevText: "Prec",
        pageNextText: "Suiv",
        pageFirstText: "Prem",
        pageLastText: "Dern",

        sorting: true,
        paging: true,
        data: filtereddataAllPrimitifToJsonArray,
        fields: refNivField,
        rowClick: function(args){
            // Do something
            $('#loading').show(50);
            goToPrimitif(args.item.VCC_ID, args.item.VCC_SHORTCLASS, args.item.URS_CPT);
        }
    });

    // Update the count
    $('#count-niv').html(filtereddataAllPrimitifToJsonArray.length);
}


function goToPrimitif(paramId, paramName, paramNbrExam){
  $("#vcc-id").val(paramId);
  $("#vcc-shortclass").val(paramName);
  $("#nbrExam").val(paramNbrExam);
  $("#mg-goto-primitif-line").submit();
}


// ***********************************************************
// ***********************************************************
// ***********************************************************
// Create a new subject via Ajax !
// ***********************************************************
// ***********************************************************
// ***********************************************************

function createNewGRASubject(){
  fillCartoucheMention();
  selectNiveau('', '', 'Niveau');
  tempMentionCode = "";
  tempMention = "";
  tempTitle = "";
  tempCredit = 0;
  $("#parcours-opt").html(getCheckBoxHTML('na'));
  $('#subj-crd-input').val('');
  $('#addpay-ace').val('');
  clearCartoucheCrdParcours();
  $('#new-subject-modal').modal('show');
}

function generateGRANewSubject(){
  tempTitle = removeAllQuotes($('#addpay-ace').val());
  tempCredit = $('#subj-crd-input').val().replace(/,/g, '.');
  $.ajax('/generateNewSubjectDB', {
      type: 'POST',  // http method
      data: {
        tempMentionCode: tempMentionCode,
        tempNiveauID: tempNiveauID,
        tempSemestreID: tempSemestreID,
        tempCredit: tempCredit,
        tempTitle: tempTitle,
        tempParcoursArray: JSON.stringify(tempArrayParcoursChecked),
        token: GET_TOKEN
      },  // data to submit
      success: function (data, status, xhr) {
          //dataAllUSRNToJsonArray[foundiInJson].EXISTING_FACILITE = (dataAllUSRNToJsonArray[foundiInJson].EXISTING_FACILITE == null) ? (ticketType + redPc) : (dataAllUSRNToJsonArray[foundiInJson].EXISTING_FACILITE + ',' + ticketType + redPc);
          // Add the element in the grid
          /*
          ALL_PARCOURS
          : 
          "na"
          IS_NEW
          : 
          "N"
          URS_CREDIT
          : 
          20
          URS_MENTION_CODE
          : 
          "COMMU"
          URS_NIVEAU_CODE
          : 
          "L1"
          URS_SEMESTER
          : 
          1
          URS_SUBJECT_TITLE
          : 
          "Allemand/Espagnol"
          raw_data
          : 
          "COMMUL11ALLEMAND/ESPAGNOL"
          */
          logMyDataBack = data;
          let listOfParcours = "";
          for(let i = 0; i<tempArrayParcoursChecked.length; i++){
            listOfParcours = listOfParcours + tempArrayParcoursChecked[i] + '/';
          }
          let newSubjGrid = {
            URS_ID: logMyDataBack.return_new_subject_id,
            ALL_PARCOURS: listOfParcours,
            IS_NEW: 'Y',
            URS_CREDIT: tempCredit * 10,
            URS_MENTION_CODE: tempMentionCode,
            URS_NIVEAU_CODE: tempNiveauID,
            URS_SEMESTER: tempSemestreID,
            GRA_EXIST_EXAM_ID: 0,
            URS_SUBJECT_TITLE: tempTitle,
            raw_data: (tempMentionCode + tempNiveauID + tempSemestreID + tempTitle).toUpperCase()
          };
          dataAllSubjectToJsonArray.unshift(newSubjGrid);
          filtereddataAllSubjectToJsonArray.unshift(newSubjGrid);

          clearDataAllSub();

          // END
          $('#msg-alert').html("Le sujet : [" + tempTitle + "] a été créé avec succés.");
          $('#type-alert').addClass('alert-primary').removeClass('alert-danger');
          $('#ace-alert-msg').show(100);
          $('#ace-alert-msg').hide(7000);
          $('#new-subject-modal').modal('hide');
      },
      error: function (jqXhr, textStatus, errorMessage) {
        $('#msg-alert').html("ERR162S : " + tempTitle + " enregistrement du nouveau sujet impossible, contactez le support.");
        $('#type-alert').removeClass('alert-primary').addClass('alert-danger');
        $('#ace-alert-msg').show(100);
        $('#new-subject-modal').modal('hide');
      }
  });
}

function deleteSubjectFromArray(paramId, paramArrayList){
  for(let i=0; i<paramArrayList.length; i++){
    if(paramArrayList[i].URS_ID == paramId){
      paramArrayList.splice(i, 1);
      return true;
    }
  }
  return false;
}

function generateGRADelSubject(){
  $.ajax('/generateDeleteSubjectDB', {
      type: 'POST',  // http method
      data: {
        tempSubjectIdToDelete: tempSubjectIdToDelete,
        token: GET_TOKEN
      },  // data to submit
      success: function (data, status, xhr) {

          deleteSubjectFromArray(tempSubjectIdToDelete, dataAllSubjectToJsonArray);
          deleteSubjectFromArray(tempSubjectIdToDelete, filtereddataAllSubjectToJsonArray);

          clearDataAllSub();

          // END
          $('#msg-alert').html("Le sujet : [" + tempSubjectTitleToDelete + "] a été supprimé avec succés.");
          $('#type-alert').addClass('alert-primary').removeClass('alert-danger');
          $('#ace-alert-msg').show(100);
          $('#ace-alert-msg').hide(7000);
          $('#delete-subj-modal').modal('hide');
      },
      error: function (jqXhr, textStatus, errorMessage) {
        $('#msg-alert').html("ERR160S : " + tempSubjectTitleToDelete + " suppression du sujet impossible, contactez le support.");
        $('#type-alert').removeClass('alert-primary').addClass('alert-danger');
        $('#ace-alert-msg').show(100);
        $('#delete-subj-modal').modal('hide');
      }
  });
}

function deleteSubjectDialog(paramId, paramTitle, paramClasse){
  tempSubjectIdToDelete = paramId;
  tempSubjectTitleToDelete = paramTitle;
  $('#confirmation-txt-blk').html('Confirmer la suppression du sujet: <strong>' + paramTitle + '</strong><br>Classe(s) : <strong>' + paramClasse + '</strong>');
  $('#delete-subj-modal').modal('show');
}

function createNewSubjectAjax(){
  /*
  console.log('tempMentionCode: ' + tempMentionCode);
  console.log('tempNiveauID: ' + tempNiveauID);
  console.log('tempSemestreID: ' + tempSemestreID);
  console.log("Credit $('#subj-crd-input').val(): " + $('#subj-crd-input').val());
  console.log("Title $('#addpay-ace').val(): " + $('#addpay-ace').val());
  for(let i = 0; i<tempArrayParcoursChecked.length; i++){
    console.log('Parcours: ' + tempArrayParcoursChecked[i]);
  }
  */
  generateGRANewSubject();
}

// We validate if at least one is checked. If none then we return error.
function verifyIfCheckBoxNewSubject(){
  if(tempArrayParcours.length > 0){
    for(let i = 0; i<tempArrayParcours.length; i++){
      if(document.getElementById("par-" + tempArrayParcours[i].parcours).checked){
        return true;
      }
    }
  }
  return false;
}

function getCountStuNumber(param){
  for(let i = 0; i<dataNewSubjParcoursToJsonArray.length; i++){
    if(tempArrayParcours[i].parcours == param){
        return tempArrayParcours[i].countStu;
    }
  }
  return 0;
}

function checkUncheckOperationNewSubj(){
  tempArrayParcoursChecked = new Array();
  let countStuNewSubj = 0;
  for(let i = 0; i<tempArrayParcours.length; i++){
    if(document.getElementById("par-" + tempArrayParcours[i].parcours).checked){
      tempArrayParcoursChecked.push(tempArrayParcours[i].parcours);
      countStuNewSubj = countStuNewSubj + getCountStuNumber(tempArrayParcours[i].parcours);
    }
  }
  $('#sel-stu-qty').html(countStuNewSubj);
  verifyIfAllIsFilledNewSubject();
}

function verifyIfAllIsFilledNewSubject(){
  let isAllvalid = true;

  if((tempMentionCode == "") && (isAllvalid)){
    isAllvalid = false;
  }

  if((tempNiveauID == "") && (isAllvalid)){
    isAllvalid = false;
  }

  if((tempSemestreID == "") && (isAllvalid)){
    isAllvalid = false;
  }

  if((!testRegexCreditSubj($('#subj-crd-input').val())) && (isAllvalid)){
    isAllvalid = false;
  }

  if((removeAllQuotes($('#addpay-ace').val()).length < 1) && (isAllvalid)){
    isAllvalid = false;
  }


  if((!verifyIfCheckBoxNewSubject()) && (isAllvalid)){
    isAllvalid = false;
  }

  // TODO : Then I have to work on the list of parcours to validate.
  
  if(isAllvalid){
    //console.log('New subject can be saved');
    $('#gra-foot-btn').show(100);
  }
  else{
    //console.log('New subject CANNOT be saved');
    $('#gra-foot-btn').hide(100);
  }
  return 0;
}

function testRegexCreditSubj(param){
  const RE = /^[0-9][\.|,]?[0-9]?$/;
  if(param.length == 0){
    return true;
  }
  else if(RE.test(param)){
    if(parseFloat(param.replace(',', '.')) < MAX_CREDIT_VALUE){
      return true;
    }
    else{
        // We are not a or A or we are bigger than 10
        return false;
    }
  }
  else{
    return false;
  }
}


function validateCreditSubj(){
  if(testRegexCreditSubj($('#subj-crd-input').val())){
      $('#subj-crd-input').removeClass('err-txtar');
      if($('#subj-crd-input').val() != ''){
          $('#subj-crd-input').addClass('ok-txtar');
      }
  }
  else{
      $('#subj-crd-input').removeClass('ok-txtar').addClass('err-txtar');
  }

  verifyIfAllIsFilledNewSubject();
}

function clearCartoucheCrdParcours(){
  // reset the rest
  tempCredit = 0;
  tempInvParcours = 'na';
  tempArrayParcours = new Array();
  tempArrayParcoursChecked = new Array();
  $('#sel-stu-qty').html('0');
}

function getCheckBoxHTML(paramId){
  let str = '<div class="form-check">';
  str = str + '<input class="form-check-input" type="checkbox" onchange="checkUncheckOperationNewSubj()" value="" id="par-' + paramId + '" checked ' + ((paramId == 'na') ? 'disabled' : '') + '>';
  str = str + '<span id="lab-' + paramId + '" class="form-check-label" for="flexCheckChecked">';
  str = str + paramId;
  str = str + '</span>';
  str = str + '</div>';
  // Retrieve the value : document.getElementById('par-na').checked
  return str;
}

function fillCartoucheParcours(){
  // fill the parcours box
  let strHtmlCheckBox = "";
  for(let i=0; i<dataNewSubjParcoursToJsonArray.length; i++){
    if((dataNewSubjParcoursToJsonArray[i].mention_code == tempMentionCode)
        && (dataNewSubjParcoursToJsonArray[i].niveau == tempNiveauID)){

          let myParcours = {parcours: dataNewSubjParcoursToJsonArray[i].parcours, countStu: parseInt(dataNewSubjParcoursToJsonArray[i].CPT_STU)};
          tempArrayParcours.push(myParcours);

          tempArrayParcoursChecked.push(dataNewSubjParcoursToJsonArray[i].parcours);
          // input the value
          strHtmlCheckBox = strHtmlCheckBox + getCheckBoxHTML(dataNewSubjParcoursToJsonArray[i].parcours);
    }
  }
  $("#parcours-opt").html(strHtmlCheckBox);
}

function selectNiveau(niveauId, semestreId, str){
  tempNiveauID = niveauId;
  tempSemestreID = semestreId;
  tempNiveau = str;

  $("#drp-semestre").html(str);
  // Do operation of validation
  clearCartoucheCrdParcours();
  if(niveauId == 0){
    $("#parcours-opt").html(getCheckBoxHTML('na'));
  }
  else{
    fillCartoucheParcours();
  }

  checkUncheckOperationNewSubj();
  verifyIfAllIsFilledNewSubject();
}

function fillCartoucheNiveau(){
  let listNiveau = '';
  for(let i=0; i<dataNewSubjSemesterToJsonArray.length; i++){
    if(dataNewSubjSemesterToJsonArray[i].MENTION_CODE == tempMentionCode){
      listNiveau = listNiveau + '<a class="dropdown-item" onclick="selectNiveau(' + "'" + dataNewSubjSemesterToJsonArray[i].NIVEAU + "'" + ', ' + dataNewSubjSemesterToJsonArray[i].SEMESTRE + ', \'' + dataNewSubjSemesterToJsonArray[i].NIVEAU + '/' + dataNewSubjSemesterToJsonArray[i].SEMESTRE + '\')"  href="#">' + dataNewSubjSemesterToJsonArray[i].NIVEAU + '/' + dataNewSubjSemesterToJsonArray[i].SEMESTRE + '</a>';
    }
  }
  $('#dpsemestre-opt').html(listNiveau);
}


function selectMention(str, strTitle){
  tempMentionCode = str;
  tempMention = strTitle;


  
  $('#drp-select').html(strTitle);
  // Necessary to save the file
  $("#fMentionCode").val(tempMentionCode);

  //console.log('You have just click on: ' + str);
  // We reset the dropdown

  selectNiveau('', '', 'Niveau');
  fillCartoucheNiveau();

  verifyIfAllIsFilledNewSubject();
}


function fillCartoucheMention(){
  let listMention = '';
  for(let i=0; i<dataMentionToJsonArray.length; i++){
      listMention = listMention + '<a class="dropdown-item" onclick="selectMention(\'' + dataMentionToJsonArray[i].par_code + '\', \'' + dataMentionToJsonArray[i].title + '\')"  href="#">' + dataMentionToJsonArray[i].title + '</a>';
  }
  $('#dpmention-opt').html(listMention);
  $('#drp-select').html('Mention');

  // Re-init semestre
  $('#drp-semestre').html('Semestre');
  $('#dpsemestre-opt').html('<a class="dropdown-item" href="#">Sélectionnez une mention</a>');

}

// ***************************************************************************************

$(document).ready(function() {
    if($('#mg-graph-identifier').text() == 'man-pri'){
      // Do something
      initAllNivGrid();
      loadAllNivGrid();

      initAllSubGrid();
      loadAllSubGrid();

      
      
    }
    else if($('#mg-graph-identifier').text() == 'lin-pri'){
      //Do nothing
      console.log('In lin-pri');
      $('#nbr-all-et').html(dataPrimitifLineToJsonArray.length/NBR_EXAM);

      // Initialise the sum of credit
      for(let i=0; i<NBR_EXAM; i++){
        sumOfCredit = sumOfCredit + parseInt(dataPrimitifLineToJsonArray[i].URS_CREDIT);
      }
      initAllExamGrid();
      loadPrimitifMain();
    }
    else{
      //Do nothing
    }
});
