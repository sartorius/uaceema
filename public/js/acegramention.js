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
      filtereddataAllMentionGradeToJsonArray = dataAllMentionGradeToJsonArray.filter(function (el) {
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
    filtereddataAllMentionGradeToJsonArray = Array.from(dataAllMentionGradeToJsonArray);
    
    loadAllNivGrid();
};

function loadAllNivGrid(){

    refNivField = [
        { name: "URS_MENTION_CODE",
          title: "Mention",
          type: "text",
          width: 30,
          align: "center",
          headercss: "cell-ref-uac-sm-hd",
          css: "cell-ref-uac-sm"
        },
        { name: "URS_NIVEAU_CODE",
          title: "Niveau",
          type: "text",
          width: 30,
          align: "center",
          headercss: "cell-ref-uac-sm-hd",
          css: "cell-ref-uac-sm"
        },
        { name: "URS_SEMESTER",
          title: "Semestre",
          type: "text",
          width: 30,
          align: "center",
          headercss: "cell-ref-uac-sm-hd",
          css: "cell-ref-uac-sm"
        },
        { name: "URS_CPT",
          title: "Examen(s)",
          type: "text",
          width: 30,
          align: "center",
          headercss: "cell-ref-uac-sm-hd",
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
        data: filtereddataAllMentionGradeToJsonArray,
        fields: refNivField,
        rowClick: function(args){
          // Do something
        }
    });

    // Update the count
    $('#count-niv').html(filtereddataAllMentionGradeToJsonArray.length);
}


// ***************************************************************************************
$(document).ready(function() {
    if($('#mg-graph-identifier').text() == 'man-men'){
      // Do something
      initAllNivGrid();
      loadAllNivGrid();

      initAllSubGrid();
      loadAllSubGrid();
    }
    else{
      //Do nothing
    }
  
});