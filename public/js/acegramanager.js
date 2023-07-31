
function initAllExamGrid(){
    $('#filter-all-exa').keyup(function() {
        filterDataAllExam();
    });
    $('#re-init-dash-exa').click(function() {
      $('#filter-all-exa').val('');
      clearDataAllExam();
    });
}
  
function filterDataAllExam(){
    if(($('#filter-all-exa').val().length > 1) && ($('#filter-all-exa').val().length < 35)){
      //console.log('We need to filter !' + $('#filter-all').val());
      filtereddataAllExamToJsonArray = dataAllExamToJsonArray.filter(function (el) {
                                        return el.raw_data.includes($('#filter-all-exa').val().toUpperCase())
                                    });
        loadAllExamGrid();
    }
    else if(($('#filter-all-exa').val().length < 2)) {
      // We clear data
      clearDataAllExam();
    }
    else{
      // DO nothing
    }
}
  
function clearDataAllExam(){
    filtereddataAllExamToJsonArray = Array.from(dataAllExamToJsonArray);
    loadAllExamGrid();
};

function getVerboseExamStatus(param){
    if(param == 'LOA'){
        return 'Chargé'
    }
    else if(param == 'NEW'){
        return 'Nouveau'
    }
    else{
        return 'Terminé'
    }
}

function loadAllExamGrid(){

    refExamField = [
        { name: "UGM_ID",
          title: "#",
          type: "number",
          width: 10,
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-uac-sm"
        },
        { name: "UGM_STATUS",
          title: "Status",
          type: "text",
          width: 40,
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm",
          itemTemplate: function(value, item) {
            return getVerboseExamStatus(value);
          }
        },
        { name: "URS_MENTION_CODE",
          title: "Mention",
          type: "text",
          width: 40,
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm"
        },
        { name: "URS_NIVEAU_CODE",
          title: "<i class='icon-list-ol'></i>",
          type: "text",
          width: 10,
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm",
          itemTemplate: function(value, item) {
            return value + '/' + item.URS_SEMESTER;
          }
        },
        { name: "UGM_DATE",
          title: "Date",
          type: "text",
          width: 25,
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-uac-sm"
        },
        { name: "URS_TITLE",
          title: "Sujet",
          type: "text",
          width: 75,
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-uac-sm",
          itemTemplate: function(value, item) {
            return value.substr(0, MAX_STR_L1);
          }
        },
        { name: "UGM_FILENAME",
          title: "Fichier",
          type: "text",
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-uac-sm",
          itemTemplate: function(value, item) {
            return value.substr(0, MAX_STR_L2);
          }
        },
        { name: "UGM_NBR_OF_PAGE",
          title: "Pg",
          type: "number",
          width: 10,
          align: "right",
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm"
        },
        { name: "URS_CREDIT",
          title: "Cdt",
          type: "number",
          width: 10,
          align: "right",
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm",
          itemTemplate: function(value, item) {
            return value/10;
          }
        },
        { name: "UGM_TEACHER_NAME",
          title: "Enseignant",
          type: "text",
          width: 50,
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-uac-sm",
          itemTemplate: function(value, item) {
            return value.substr(0, MAX_STR_L3);
          }
        },
        { name: "LAST_AGENT_USERNAME",
          title: "<i class='icon-person nav-text'></i>",
          type: "text",
          width: 40,
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-uac-sm",
          itemTemplate: function(value, item) {
            return value.toUpperCase();
          }
        },
        { name: "UGM_LAST_UPDATE",
          title: "<i class='icon-clock-1 nav-text'></i>",
          type: "text",
          width: 30,
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-uac-sm"
        }
    ];

    $("#jsGridAllExam").jsGrid({
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
        data: filtereddataAllExamToJsonArray,
        fields: refExamField/*,
        rowClick: function(args){
            goToSTUFromPayMngr(args.item.PAGE);
        }*/
    });
}

$(document).ready(function() {
    console.log('We are in Gra Manager');


    if($('#mg-graph-identifier').text() == 'man-exa'){
      // Do something
      initAllExamGrid();
      loadAllExamGrid();
    }
    else if($('#mg-graph-identifier').text() == 'man-not'){
        // Do something
    }
    else{
      //Do nothing
    }
  
  });