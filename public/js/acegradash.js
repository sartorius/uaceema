
function runStatDashboardPay(){
    //Corlor
    let backgroundColorRef = [
        '#e6e6ff',
        '#f2ffe6',
        '#ffbcbc',
        '#b3b3ff',
        '#ffffcc',
        '#f7e6ff',
        '#9999ff',
        '#eeccff',
        '#e6b3ff',
        '#dd99ff'
    ];
    let borderColorRef = [
        '#000099',
        '#4d9900',
        '#6c0101',
        '#000066',
        '#666600',
        '#7700b3',
        '#00004d',
        '#660099',
        '#550080',
        '#440066'
    ];

    //Corlor
    let backgroundColorRefAlt = [
        '#f7f7f7',
        '#ffe9e9',
        '#f1effc',
        '#fcf0ff',
        '#d9ffe2',
        '#fbfcef',
        '#fcf6ef',
        '#effbfc',
        '#fceff9',
        '#effcf2',
        '#ffffb3',
        '#ffff99',
        '#F4E6FF',
        '#FFF4E6',
        '#FFFCC5',
        '#D2FFD2',
        '#e6e6ff',
        '#f2ffe6',
        '#ccccff',
        '#e6e6ff',
        '#f2ffe6',
        '#ccccff',
        '#b3b3ff',
        '#ffffcc'
    ];
    let borderColorRefAlt = [
        '#666600',
        '#7700b3',
        '#00004d',
        '#660099',
        '#550080',
        '#440066',
        '#408000',
        '#336600',
        '#264d00',
        '#808000',
        '#4d4d00',
        '#333300',
        '#7F6F83',
        '#837A6F',
        '#797865',
        '#4D6F4E',
        '#000099',
        '#4d9900',
        '#000080',
        '#000099',
        '#4d9900',
        '#000080',
        '#000066',
        '#666600'
    ];

    //Corlor
    let backgroundColorRefAlt2 = [
        '#e6b3ff',
        '#dd99ff',
        '#e6ffcc',
        '#d9ffb3',
        '#ccff99',
        '#ffffe6',
        '#ffffb3',
        '#ffff99',
        '#F4E6FF',
        '#FFF4E6',
        '#FFFCC5',
        '#D2FFD2',
        '#e6e6ff',
        '#f2ffe6',
        '#ccccff',
        '#e6e6ff',
        '#f2ffe6',
        '#ccccff',
        '#b3b3ff',
        '#ffffcc'
    ];
    let borderColorRefAlt2 = [
        '#550080',
        '#440066',
        '#408000',
        '#336600',
        '#264d00',
        '#808000',
        '#4d4d00',
        '#333300',
        '#7F6F83',
        '#837A6F',
        '#797865',
        '#4D6F4E',
        '#000099',
        '#4d9900',
        '#000080',
        '#000099',
        '#4d9900',
        '#000080',
        '#000066',
        '#666600'
    ];


    // Stat of status population
    let listOfLabelAllGradeAverage = new Array();
    let listOfDataAllGradeAverage = new Array();
    for(let i=0; i<dataStatAverageArray.length; i++){
      listOfLabelAllGradeAverage.push(verboseStatAVGOneExam(dataStatAverageArray[i].CATEGORY));
      listOfDataAllGradeAverage.push(dataStatAverageArray[i].COUNT_PART);
    }

    let ctxTrancheOne = document.getElementById('averagePopulation');
    new Chart(ctxTrancheOne, {
        type: 'pie',
        data: {
          labels: listOfLabelAllGradeAverage,
          datasets: [
            {
              label: "Proportion moyenne 10",
              backgroundColor: backgroundColorRef,
              borderColor: borderColorRef,
              data: listOfDataAllGradeAverage,
              borderWidth: 0.3
            }
          ]
        },
        options: {
        }
    });


    // Stat of status population
    let listOfLabelStatGradeRep = new Array();
    let listOfDataStatGradeRep = new Array();
    for(let i=0; i<dataStatGradeRepArray.length; i++){
      listOfLabelStatGradeRep.push(dataStatGradeRepArray[i].CATEGORY);
      listOfDataStatGradeRep.push(dataStatGradeRepArray[i].CPT);
    }
    let ctxClientBarMis = document.getElementById('gradePopulation');
    new Chart(ctxClientBarMis, {
        type: 'bar',
        data: {
          labels: listOfLabelStatGradeRep,
          datasets: [
            {
              label: "Répartition notes",
              backgroundColor: backgroundColorRefAlt,
              borderColor: borderColorRefAlt,
              data: listOfDataStatGradeRep,
              borderWidth: 0.4
            }
          ]
        },
        options: {
        }
    });

}

// *********************************************************************************************************
// *********************************************************************************************************
// *********************************************************************************************************
// *********************************************************************************************************
// *********************************************************************************************************
// *********************************************************************************************************


function goToEndScan(paramGraId){
  $("#read-master-id").val(paramGraId);
  $("#read-rollback-order").val('N');
  $("#mg-grade-master-id-form").submit();
}


function generateAllGraReport(){
    const csvContentType = "data:text/csv;charset=utf-8,";
    let csvContent = "";
    let involvedArray = filteredDataAllGradeToJsonArray;

	let dataString = "Username" + GLOBAL_SEP_ 
                    + "Prénom" + GLOBAL_SEP_ 
                    + "Nom" + GLOBAL_SEP_ 
                    + "Note" + GLOBAL_SEP_ 
                    + "Classe" + GLOBAL_SEP_ 
                    + "Moyenne de la classe" + GLOBAL_SEP_ 
                    + "Matricule" + GLOBAL_SEP_ 

                    + "Niveau" + GLOBAL_SEP_ 
                    + "Semestre" + GLOBAL_SEP_ 
                    + "Date examen" + GLOBAL_SEP_
                    + "Sujet" + GLOBAL_SEP_ 
                    + "Crédit" + GLOBAL_SEP_ 
                    + "Enseignant" + GLOBAL_SEP_
                    + "Dernière action" + GLOBAL_SEP_ 
                    + "Date dernière action" + GLOBAL_SEP_ + "\n";
	csvContent += dataString;
	for(let i=0; i<involvedArray.length; i++){

            dataString = involvedArray[i].VSH_USERNAME + GLOBAL_SEP_ 
                + isNullMvo(involvedArray[i].VSH_FIRSTNAME) + GLOBAL_SEP_ 
                + isNullMvo(involvedArray[i].VSH_LASTNAME) + GLOBAL_SEP_ 
                + rawOneGrade(involvedArray[i].TECH_GRADE, involvedArray[i].TECH_STATUS) + GLOBAL_SEP_ 
                + isNullMvo(involvedArray[i].VCC_SHORTCLASS) + GLOBAL_SEP_ 
                + isNullMvo(dataOneExamToJsonArray[0].UGG_AVG) + GLOBAL_SEP_ 
                + isNullMvo(involvedArray[i].VSH_MATRICULE) + GLOBAL_SEP_ 

                + isNullMvo(dataOneExamToJsonArray[0].URS_NIVEAU_CODE) + GLOBAL_SEP_ 
                + isNullMvo(dataOneExamToJsonArray[0].URS_SEMESTER) + GLOBAL_SEP_ 
                + isNullMvo(dataOneExamToJsonArray[0].UGM_DATE) + GLOBAL_SEP_ 
                + isNullMvo(dataOneExamToJsonArray[0].URS_TITLE) + GLOBAL_SEP_ 
                + dataOneExamToJsonArray[0].URS_CREDIT/10 + GLOBAL_SEP_ 
                + isNullMvo(dataOneExamToJsonArray[0].UGM_TEACHER_NAME) + GLOBAL_SEP_ 
                + isNullMvo(dataOneExamToJsonArray[0].LAST_AGENT_USERNAME.toUpperCase()) + GLOBAL_SEP_ 
                + isNullMvo(dataOneExamToJsonArray[0].UGM_LAST_UPDATE) + GLOBAL_SEP_ ;
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
    link.download = 'RapportNotes_' + dataOneExamToJsonArray[0].URS_NIVEAU_CODE + '_' + dataOneExamToJsonArray[0].URS_SEMESTER + '_' + removeAccentuated(dataOneExamToJsonArray[0].URS_TITLE.replaceAll(' ', '').substr(0, 15)).toUpperCase() + '.csv';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
}

function verboseStatAVGOneExam(param){
  if(param == 'A'){
      return 'Absent(e)';
  }
  else if(param == 'E'){
      return 'Excusé(e)';
  }
  else if(param == 'AAVG'){
      return 'Au dessus';
  }
  else{
      return 'En dessous';
  }
}

function verboseOneGrade(paramGrade, paramStatus){
    if(paramStatus == 'A'){
        return 'Absent(e)';
    }
    else if(paramStatus == 'E'){
        return 'Excusé(e)';
    }
    else{
        if(parseFloat(paramGrade) < 7){
          return "<i class='recap-mis'>" + paramGrade + "</i>";
        }
        else if(parseFloat(paramGrade) < 10){
          return "<i class='recap-qui'>" + paramGrade + "</i>";
        }
        else{
          return paramGrade;
        }
    }
}

function rawOneGrade(paramGrade, paramStatus){
  if(paramStatus == 'A'){
      return 'Absent(e)';
  }
  else if(paramStatus == 'E'){
      return 'Excusé(e)';
  }
  else{
    return paramGrade;
  }
}

function initOneExamGrid(){
    $('#filter-one-exa').keyup(function() {
        filterDataOneExam();
    });
    $('#re-init-dash-one-exa').click(function() {
      $('#filter-one-exa').val('');
      clearDataOneExam();
    });
}
  
function filterDataOneExam(){
    if(($('#filter-one-exa').val().length > 1) && ($('#filter-one-exa').val().length < 35)){
      //console.log('We need to filter !' + $('#filter-all').val());
      filteredDataAllGradeToJsonArray = dataAllGradeToJsonArray.filter(function (el) {
                                        return el.raw_data.includes($('#filter-one-exa').val().toUpperCase())
                                    });
        loadOneExamGrid();
    }
    else if(($('#filter-one-exa').val().length < 2)) {
      // We clear data
      clearDataOneExam();
    }
    else{
      // DO nothing
    }
}
  
function clearDataOneExam(){
    filteredDataAllGradeToJsonArray = Array.from(dataAllGradeToJsonArray);
    loadOneExamGrid();
};

function loadOneExamGrid(){

    refAllGradesField = [
        { name: "VSH_USERNAME",
          title: "Username",
          type: "text",
          width: 47,
          align: "left",
          headercss: "cell-ref-uac-sm-hd",
          css: "cell-ref-uac-sm",
          itemTemplate: function(value, item) {
            if(item.TECH_OPERATION == 'OTH'){
              return '<i class="blue-txt">' + value + '</i>';
            }
            else{
              return value;
            }
          }
        },
        { name: "VSH_FIRSTNAME",
          title: "Prénom",
          type: "text",
          width: 47,
          align: "left",
          headercss: "cell-ref-uac-sm-hd",
          css: "cell-ref-uac-sm",
          itemTemplate: function(value, item) {
            return value.substr(0, 10);
          }
        },
        { name: "VSH_LASTNAME",
          title: "Nom",
          type: "text",
          width: 92,
          align: "left",
          headercss: "cell-ref-uac-sm-hd",
          css: "cell-ref-uac-sm",
          itemTemplate: function(value, item) {
            return value.substr(0, 20);
          }
        },
        { name: "TECH_GRADE",
          title: "Note",
          type: "text",
          width: 30,
          align: "right",
          headercss: "cell-ref-uac-sm-hd",
          css: "cell-ref-uac-sm",
          itemTemplate: function(value, item) {
             return verboseOneGrade(value, item.TECH_STATUS);
          }
        },
        { name: "VCC_SHORTCLASS",
          title: "Classe",
          type: "text",
          align: "left",
          headercss: "cell-ref-uac-sm-hd",
          css: "cell-ref-uac-sm"
        }
    ];

    $("#jsGridAllGrade").jsGrid({
        height: "auto",
        width: "100%",
        noDataContent: "Aucune note disponible",
        pageIndex: 1,
        pageSize: 25,
        pagePrevText: "Prec",
        pageNextText: "Suiv",
        pageFirstText: "Prem",
        pageLastText: "Dern",

        sorting: true,
        paging: true,
        data: filteredDataAllGradeToJsonArray,
        fields: refAllGradesField
    });

    // Update the count
    $('#count-gra').html(filteredDataAllGradeToJsonArray.length);
}

// **************************************************************************

$(document).ready(function() {
    console.log('We are in Gra Dashboard');
    if($('#mg-graph-identifier').text() == 'one-exa'){
        loadOneExamGrid();
        initOneExamGrid();
        runStatDashboardPay();
    }
    else{
      //Do nothing
    }
  
  });