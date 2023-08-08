
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

    const EMPTY_HEAD_PRELINE_SUBJ = '<tr class="head-prim-line"><th class="prim-emp"></th><th class="prim-emp"></th><th class="prim-emp"></th><th class="prim-emp"></th>';
    const EMPTY_HEAD_PRELINE = '<th class="prim-emp"></th><th class="prim-emp"></th><th class="prim-emp"></th><th style="text-align: right;">';

    // Line of subject

    // Line of semester
    let headerStr = '<tr>' + '<th>' + SHORT_CLASS + '</th><th>' + YEAR + '</th><th></th><th style="text-align: right;">' + 'Semestre' + '</th>';
    for(let i=0; i<NBR_EXAM; i++){
      headerStr += "<th class='gra-c' style='width: 60px;'>" + dataPrimitifLineToJsonArray[i].URS_SEMESTER + '</th>';
    }
    headerStr += '</tr>';
    tabStr += headerStr;

    // Line of Reference
    headerStr = '<tr>' + EMPTY_HEAD_PRELINE + '#' + '</th>';
    for(let i=0; i<NBR_EXAM; i++){
      headerStr += "<th class='gra-c' style='width: 60px;'>" + dataPrimitifLineToJsonArray[i].URS_ID + '</th>';
    }
    headerStr += '</tr>';
    tabStr += headerStr;

    headerStr = EMPTY_HEAD_PRELINE_SUBJ;
    for(let i=0; i<NBR_EXAM; i++){
      headerStr += "<th class='head-prim' style='width: 60px;'>" + dataPrimitifLineToJsonArray[i].URS_TITLE.substr(0, 25) + '</th>';
    }
    headerStr += '</tr>';
    tabStr += headerStr;

    // Line of credit
    headerStr = '<tr>' + EMPTY_HEAD_PRELINE + sumOfCredit/10 + '/60&nbsp;Crédits' + '</th>';
    for(let i=0; i<NBR_EXAM; i++){
      headerStr += "<th class='gra-c' style='width: 60px;'>" + dataPrimitifLineToJsonArray[i].URS_CREDIT/10 + '</th>';
    }
    headerStr += '</tr>';
    tabStr += headerStr;

    // Line of credit
    headerStr = '<tr>' + EMPTY_HEAD_PRELINE + 'Moyenne' + '</th>';
    for(let i=0; i<NBR_EXAM; i++){
      headerStr += "<th class='gra-c' style='width: 60px;'>" + dataPrimitifLineToJsonArray[i].UGG_AVG + '</th>';
    }
    headerStr += '</tr>';
    tabStr += headerStr;

    // Line of date
    headerStr = "<tr style='border-bottom: 2.5px solid black;'>" + EMPTY_HEAD_PRELINE + 'Date' + '</th>';
    for(let i=0; i<NBR_EXAM; i++){
      headerStr += "<th class='gra-c' style='width: 60px;'>" + dataPrimitifLineToJsonArray[i].UGM_DATE + '</th>';
    }
    headerStr += '</tr>';
    tabStr += headerStr;

    let i=0;
    while (i<filtereddataPrimitifLineToJsonArray.length){
      //We read student per student
      let lineStr = '';
      lineStr += "<tr><td style='width: 100px;'>" + filtereddataPrimitifLineToJsonArray[i].VSH_USERNAME + "</td><td style='width: 120px;'>" + filtereddataPrimitifLineToJsonArray[i].VSH_FIRSTNAME + "</td><td style='width: 200px;'>" + filtereddataPrimitifLineToJsonArray[i].VSH_LASTNAME + "</td><td style='width: 120px;'>" + filtereddataPrimitifLineToJsonArray[i].VSH_MATRICULE + "</td>";
      for(let j=(0 + i); j<(NBR_EXAM + i); j++){
        lineStr += "<td class='gra-c'  style='width: 60px;'>" + filtereddataPrimitifLineToJsonArray[j].UGG_GRADE + '</td>';
      }
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
    const SEP_ = ";"

    let dataString = "";

    const EMPTY_HEAD_PRELINE_SUBJ = SEP_ + SEP_ + SEP_ + SEP_;
    const EMPTY_HEAD_PRELINE = SEP_ + SEP_ + SEP_;

    // Line of subject

    // Line of semester
    let headerStr = SHORT_CLASS + SEP_ + YEAR + SEP_ + SEP_ + 'Semestre' + SEP_;
    for(let i=0; i<NBR_EXAM; i++){
      headerStr += dataPrimitifLineToJsonArray[i].URS_SEMESTER + SEP_;
    }
    headerStr += "\n";
    dataString += headerStr;

    // Line of Reference
    headerStr =  EMPTY_HEAD_PRELINE + '#' + SEP_;
    for(let i=0; i<NBR_EXAM; i++){
      headerStr += dataPrimitifLineToJsonArray[i].URS_ID + SEP_;
    }
    headerStr += "\n";
    dataString += headerStr;

    headerStr = EMPTY_HEAD_PRELINE_SUBJ;
    for(let i=0; i<NBR_EXAM; i++){
      headerStr += dataPrimitifLineToJsonArray[i].URS_TITLE.substr(0, 25) + SEP_;
    }
    headerStr += "\n";
    dataString += headerStr;

    // Line of credit
    headerStr = EMPTY_HEAD_PRELINE + sumOfCredit/10 + '/60 Crédits' + SEP_;
    for(let i=0; i<NBR_EXAM; i++){
      headerStr += dataPrimitifLineToJsonArray[i].URS_CREDIT/10 + SEP_;
    }
    headerStr += "\n";
    dataString += headerStr;

    // Line of credit
    headerStr = EMPTY_HEAD_PRELINE + 'Moyenne' + SEP_;
    for(let i=0; i<NBR_EXAM; i++){
      headerStr += dataPrimitifLineToJsonArray[i].UGG_AVG + SEP_;
    }
    headerStr += "\n";
    dataString += headerStr;

    // Line of date
    headerStr = EMPTY_HEAD_PRELINE + 'Date' + SEP_;
    for(let i=0; i<NBR_EXAM; i++){
      headerStr += dataPrimitifLineToJsonArray[i].UGM_DATE + SEP_;
    }
    headerStr += "\n";
    dataString += headerStr;

    let i=0;
    while (i<filtereddataPrimitifLineToJsonArray.length){
      //We read student per student
      let lineStr = '';
      lineStr += filtereddataPrimitifLineToJsonArray[i].VSH_USERNAME + SEP_ + filtereddataPrimitifLineToJsonArray[i].VSH_FIRSTNAME + SEP_ + filtereddataPrimitifLineToJsonArray[i].VSH_LASTNAME + SEP_ + filtereddataPrimitifLineToJsonArray[i].VSH_MATRICULE + SEP_;
      for(let j=(0 + i); j<(NBR_EXAM + i); j++){
        lineStr += filtereddataPrimitifLineToJsonArray[j].UGG_GRADE + SEP_;
      }
      lineStr += "\n";
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
          width: 10,
          align: "left",
          headercss: "cell-ref-uac-sm-hd",
          css: "cell-ref-uac-sm"
        },
        { name: "URS_NIVEAU_CODE",
          title: "Niveau",
          type: "text",
          width: 10,
          align: "center",
          headercss: "cell-ref-uac-sm-hd",
          css: "cell-ref-uac-sm"
        },
        { name: "URS_SEMESTER",
          title: "Semestre",
          type: "text",
          width: 10,
          align: "center",
          headercss: "cell-ref-uac-sm-hd",
          css: "cell-ref-uac-sm"
        },
        { name: "URS_CREDIT",
          title: "Crédit",
          type: "text",
          width: 10,
          align: "center",
          headercss: "cell-ref-uac-sm-hd",
          css: "cell-ref-uac-sm",
          itemTemplate: function(value, item) {
            return value/10;
          }
        },
        { name: "URS_SUBJECT_TITLE",
          title: "Titre",
          type: "text",
          align: "left",
          headercss: "cell-ref-uac-sm-hd",
          css: "cell-ref-uac-sm",
          itemTemplate: function(value, item) {
            return value.substr(0, 75);
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
          width: 20,
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
          title: "Examen(s)",
          type: "text",
          width: 30,
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