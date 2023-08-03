function generateAllExamCSV(){
    const csvContentType = "data:text/csv;charset=utf-8,";
    let csvContent = "";
    let involvedArray = filtereddataAllExamToJsonArray;
    const SEP_ = ";"

	let dataString = "Référence" + SEP_ 
                    + "Status" + SEP_ 
                    + "Mention" + SEP_ 
                    + "Niveau" + SEP_ 
                    + "Semestre" + SEP_ 
                    + "Date examen" + SEP_
                    + "Sujet" + SEP_ 
                    + "Fichier" + SEP_ 
                    + "Nombre de page(s)" + SEP_ 
                    + "Crédit" + SEP_ 
                    + "Enseignant" + SEP_
                    + "Dernière action" + SEP_ 
                    + "Date dernière action" + SEP_ + "\n";
	csvContent += dataString;
	for(let i=0; i<involvedArray.length; i++){

            dataString = involvedArray[i].UGM_ID + SEP_ 
                + getVerboseExamStatus(involvedArray[i].UGM_STATUS) + SEP_ 
                + isNullMvo(involvedArray[i].URM_MENTION_TITLE) + SEP_ 
                + isNullMvo(involvedArray[i].URS_NIVEAU_CODE) + SEP_ 
                + isNullMvo(involvedArray[i].URS_SEMESTER) + SEP_ 
                + isNullMvo(involvedArray[i].UGM_DATE) + SEP_ 
                + isNullMvo(involvedArray[i].URS_TITLE) + SEP_ 
                + isNullMvo(involvedArray[i].UGM_FILENAME) + SEP_ 
                + isNullMvo(involvedArray[i].UGM_NBR_OF_PAGE) + SEP_ 
                + involvedArray[i].URS_CREDIT/10 + SEP_ 
                + isNullMvo(involvedArray[i].UGM_TEACHER_NAME) + SEP_ 
                + isNullMvo(involvedArray[i].LAST_AGENT_USERNAME.toUpperCase()) + SEP_ 
                + isNullMvo(involvedArray[i].UGM_LAST_UPDATE) + SEP_ ;
            // easy close here
            csvContent += i < involvedArray.length ? dataString+ "\n" : dataString;
	}

    //console.log('Click on csv');
    let encodedUri = encodeURI(csvContent);
    let csvData = new Blob([csvContent], { type: csvContentType });

        let link = document.createElement("a");
    let csvUrl = URL.createObjectURL(csvData);

    link.href =  csvUrl;
    link.style = "visibility:hidden";
    link.download = 'RapportGlobalExamen.csv';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
}


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
          headercss: "cell-ref-uac-sm-hd",
          css: "cell-ref-uac-sm"
        },
        { name: "UGM_STATUS",
          title: "Status",
          type: "text",
          width: 40,
          headercss: "cell-ref-uac-sm-hd",
          css: "cell-ref-uac-sm",
          itemTemplate: function(value, item) {
            return getVerboseExamStatus(value);
          }
        },
        { name: "URS_MENTION_CODE",
          title: "Mention",
          type: "text",
          width: 25,
          headercss: "cell-ref-uac-sm-hd",
          css: "cell-ref-uac-sm"
        },
        { name: "URS_NIVEAU_CODE",
          title: "<i class='icon-list-ordered'></i>",
          type: "text",
          width: 10,
          headercss: "cell-ref-uac-sm-hd",
          css: "cell-ref-uac-sm",
          itemTemplate: function(value, item) {
            return value + '/' + item.URS_SEMESTER;
          }
        },
        { name: "UGM_DATE",
          title: "Date",
          type: "text",
          width: 25,
          headercss: "cell-ref-uac-sm-hd",
          css: "cell-ref-uac-sm"
        },
        { name: "URS_TITLE",
          title: "Sujet",
          type: "text",
          width: 95,
          headercss: "cell-ref-uac-sm-hd",
          css: "cell-ref-uac-sm",
          itemTemplate: function(value, item) {
            return value.substr(0, MAX_STR_L1);
          }
        },
        { name: "UGM_FILENAME",
          title: "Fichier",
          type: "text",
          headercss: "cell-ref-uac-sm-hd",
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
          headercss: "cell-ref-uac-sm-hd",
          css: "cell-ref-uac-sm"
        },
        { name: "URS_CREDIT",
          title: "Cdt",
          type: "number",
          width: 10,
          align: "right",
          headercss: "cell-ref-uac-sm-hd",
          css: "cell-ref-uac-sm",
          itemTemplate: function(value, item) {
            return value/10;
          }
        },
        { name: "UGM_TEACHER_NAME",
          title: "Enseignant",
          type: "text",
          width: 90,
          headercss: "cell-ref-uac-sm-hd",
          css: "cell-ref-uac-sm",
          itemTemplate: function(value, item) {
            return value.substr(0, MAX_STR_L3);
          }
        },
        { name: "LAST_AGENT_USERNAME",
          title: "<i class='icon-person nav-text'></i>",
          type: "text",
          width: 40,
          headercss: "cell-ref-uac-sm-hd",
          css: "cell-ref-uac-sm",
          itemTemplate: function(value, item) {
            return value.toUpperCase();
          }
        },
        { name: "UGM_LAST_UPDATE",
          title: "<i class='icon-clock-1 nav-text'></i>",
          type: "text",
          width: 30,
          headercss: "cell-ref-uac-sm-hd",
          css: "cell-ref-uac-sm"
        },
        { name: "UGM_ID",
          title: "An.",
          width: 20,
          type: "text",
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm-center",
          itemTemplate: function(value, item) {
            return '<button class="btn btn-dark tg-del"><i class="icon-times"></i></button>';
          }
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
        fields: refExamField,
        rowClick: function(args){
          let $target = $(args.event.target);
          if($target.closest(".tg-del").length){
            alert('toto');
          }
          else{
            goToEXAMFromGraMngr(args.item.UGM_ID);
          }
        }
    });
}

// goToSTUFromDashAssiduite(args.item.PAGE);
function goToEXAMFromGraMngr(param){
  $("#read-master-id").val(param);
  $("#mg-master-id-form").submit();
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