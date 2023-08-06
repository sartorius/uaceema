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
                + getVerboseExamStatus(involvedArray[i].UGM_STATUS, 'Y') + SEP_ 
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

function loadAllExamGrid(){

    refExamField = [
        { name: "UGM_ID",
          title: "#",
          type: "number",
          width: 10,
          align: "center",
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
            return getVerboseExamStatus(value, 'N');
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
          width: 30,
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
          align: "center",
          headercss: "cell-ref-uac-sm-hd",
          css: "cell-ref-uac-sm"
        },
        { name: "URS_CREDIT",
          title: "Cdt",
          type: "number",
          width: 10,
          align: "center",
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
          title: "&nbsp;",
          width: 20,
          type: "text",
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm-center",
          itemTemplate: function(value, item) {
            if(item.UGM_STATUS == 'CAN'){
              return '<i class="icon-trash"></i>';
            }
            else{
              if(EDIT_ACCESS == 'Y'){
                return '<button class="btn btn-dark tg-del"><i class="icon-trash-o"></i></button>';
              }
              else{
                return '&nbsp;';
              }
              
            }
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
            // We have clicked on the button deletion
            if(args.item.UGM_STATUS != 'CAN'){
              $("#fExamDate").val(args.item.UGM_DATE);
              $("#fMention").val(args.item.URM_MENTION_TITLE);
              $("#fNiveau").val(args.item.URS_NIVEAU_CODE + '/' + args.item.URS_SEMESTER);
              $("#fSubject").val(args.item.URS_TITLE);
              $("#fCustTeacherName").val(args.item.UGM_TEACHER_NAME);
              $("#fCredit").val(args.item.URS_CREDIT);

              $("#can-master-id").val(args.item.UGM_ID);
              $("#mg-cancel-form").submit();
            }
          }
          else{
            // We have clicked on the line
            if( (args.item.UGM_STATUS == 'LOA')
                  || (args.item.UGM_STATUS == 'FED')
              ){
                if(EDIT_ACCESS == 'Y'){
                  goToEXAMForGradeFromGraMngr(args.item.UGM_ID);
                }
                // We do nothing if were have not access right
            }
            else if(args.item.UGM_STATUS == 'END'){
                goToEXAMForReadOnlyFromGraMngr(args.item.UGM_ID);
            }
            else{
              //Do nothing
            }
          }
        }
    });

    // Update the count
    $('#count-exam').html(filtereddataAllExamToJsonArray.length);
}


function goToEXAMForGradeFromGraMngr(param){
  $("#read-master-id").val(param);
  $("#mg-grade-master-id-form").submit();
}

function goToEXAMForReadOnlyFromGraMngr(param){
  $("#readonly-master-id").val(param);
  $("#mg-readonly-master-id-form").submit();
}

function goToConfirmExam(param){
  $("#confirm-cancel-id").val(param);
  $("#mg-confirm-cancel-id-form").submit();
}

$(document).ready(function() {
    console.log('We are in Gra Manager');


    if($('#mg-graph-identifier').text() == 'man-exa'){
      // Do something
      initAllExamGrid();
      loadAllExamGrid();
      // Case of cancellation
      if(confirmCancelId > 0){
        showHeaderAlertMsg("L'annulation de l'examen #" + confirmCancelId + " a été terminée avec succès.", 'Y');
        setTimeout(closeAlertMsg, 7000);
      }
      if(createMasterId > 0){
        showHeaderAlertMsg("L'attribution des notes de l'examen #" + createMasterId + " a été terminée avec succès.", 'Y');
        setTimeout(closeAlertMsg, 7000);
      }
      if(reviewMasterId > 0){
        showHeaderAlertMsg("La revue des notes de l'examen #" + reviewMasterId + " a été terminée avec succès.", 'Y');
        setTimeout(closeAlertMsg, 7000);
      }
    }
    else{
      //Do nothing
    }
  
  });