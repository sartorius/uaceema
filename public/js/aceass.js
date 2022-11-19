function basicEncodeACE(str){
  return '' + str;
}
let globalMaxRead = 1000;
// Main PRINT PDF is here !

function printCarteEtudiantPDF(){

  console.log('Click on generatePrintedPDF');

  // Document of 210mm wide and 297mm high > A4
  // new jsPDF('p', 'mm', [297, 210]);
  // Here format A7
  let doc = new jsPDF('p', 'mm', [120, 70]);

  doc.setFont("Courier");
  doc.setFontType("bold");
  doc.setFontSize(9);
  doc.setTextColor(175,180,187);
  doc.text(15, 15, "Code barre d'assiduité");



  doc.addImage(document.getElementById('selfie'), //img src
                'JPG', //format
                20, //x oddOffsetX is to define if position 1 or 2
                20, //y
                30, //Width
                30, null, 'FAST'); //Height // Fast is to get less big files


  doc.addImage(document.getElementById('mask-selfie'), //img src
                'PNG', //format
                17, //x oddOffsetX is to define if position 1 or 2
                19, //y
                36, //Width
                32, null, 'FAST'); //Height // Fast is to get less big files


  doc.addImage(document.getElementById('barcode').src, //img src
                'PNG', //format
                10, //x oddOffsetX is to define if position 1 or 2
                70, //y
                50, //Width
                30, null, 'FAST'); //Height // Fast is to get less big files
  doc.setTextColor(48,91,159);
  doc.setFontSize(14);
  doc.text(20, 63, $('#id-username').html().toUpperCase());

  doc.addImage(document.getElementById('logo-carte'), //img src
                'PNG', //format
                42, //x oddOffsetX is to define if position 1 or 2
                110, //y
                25, //Width
                8, null, 'FAST'); //Height // Fast is to get less big files

  //doc.addSvgAsImage(document.getElementById('mbc-1'), 50, 50, 200, 85);

  doc.save('CarteEtudiantUACEEM_Print');


  //$("body").removeClass("loading");
  //$("#screen-load").hide();
}
function convertAZERTY(letter){
    let value = '';
    switch (letter) {
      case 'Q':
        value = 'a';
        break;
      case ',':
        value = 'm';
        break;
      case '?':
        value = 'm';
        break;
      case 'A':
        value = 'q';
        break;
      case 'Z':
        value = 'w';
        break;
      case 'W':
        value = 'z';
        break;
      case 'q':
        value = 'a';
        break;
      case 'a':
        value = 'q';
        break;
      case 'z':
        value = 'w';
        break;
      case 'w':
        value = 'z';
        break;
      case '&':
        value = '1';
        break;
      case 'é':
        value = '2';
        break;
      case '"':
        value = '3';
        break;
      case '\'':
        value = '4';
        break;
      case '(':
        value = '5';
        break;
      case '-':
        value = '6';
        break;
      case '§':
        value = '6';
        break;
      case 'è':
        value = '7';
        break;
      case '_':
        value = '8';
        break;
      case '!':
        value = '8';
        break;
      case 'ç':
        value = '9';
        break;
      case 'à':
        value = '0';
        break;
      default:
        value = letter;
    }
  return value;
}
function convertWordAZERTY(inputStr){
  let retValue = '';
  for(let i=0; i<inputStr.length; i++){
    //console.log(i + ' /' + inputStr.substring(i, i+1));
    retValue = retValue + convertAZERTY(inputStr.substring(i, i+1));
  }
  return retValue;
}
function verityContentScan(){
  // Do something

  if ($('#scan-ace').val().length == 10){

    let originalRedInput = $('#scan-ace').val();
    let readInput = $('#scan-ace').val().replace(/[^a-z0-9]/gi,'').toUpperCase();
    console.log("Diagnostic 2 Read Input : " + readInput.length + ' : ' + readInput + ' - ' + originalRedInput + ' 0/' + convertWordAZERTY(originalRedInput) + ' 1/' + convertWordAZERTY(originalRedInput).toUpperCase() + ' 2/' + convertWordAZERTY(originalRedInput).toUpperCase().replace(/[^a-z0-9]/gi,'') + ' 3/' + convertWordAZERTY(originalRedInput).toLowerCase().replace(/[^a-z0-9]/gi,''));

    if(readInput.length < 10){
      // We are on the wrong keyboard config as it must be 10
      readInput = convertWordAZERTY(originalRedInput).replace(/[^a-z0-9]/gi,'').toUpperCase();
    }

    let scanOrderToCheck = ' <i class="mgs-rd-o-in">&nbsp;Entrée&nbsp;</i>';
    if(($('#mg-graph-identifier').text() == 'ua-scan-out')){
      scanOrderToCheck = ' <i class="mgs-rd-o-out">&nbsp;Sortie&nbsp;</i>';
    }

    //console.log('We have read: ' + $('#scan-ace').val());
    $('#last-read-bc').html(readInput + scanOrderToCheck);

    let today = new Date();
    let date = today.getFullYear()+'-'+(today.getMonth()+1).toString().padStart(2, '0')+'-'+today.getDate().toString().padStart(2, '0');
    let time = today.getHours().toString().padStart(2, '0') + ":" + today.getMinutes().toString().padStart(2, '0') + ":" + today.getSeconds().toString().padStart(2, '0');
    let dateTime = date+' '+time;
    $('#last-read-time').html(time);

    dataTagToJsonArray.push({
         "username" : readInput,
         "date" : date,
         "time" : time
    });
    // Save for any internet issue here
    let storeOrder = 'listOfScanIn';
    if(($('#mg-graph-identifier').text() == 'ua-scan-out')){
      storeOrder = 'listOfScanOut';
    }
    localStorage.removeItem(storeOrder);
    localStorage.setItem(storeOrder, JSON.stringify(dataTagToJsonArray));
    //console.log('A - Here is my save: ' + JSON.stringify(dataTagToJsonArray));

    if((globalMaxRead - dataTagToJsonArray.length) < 10){
        $('#left-cloud').html('<i style="color:red;">' + (globalMaxRead - dataTagToJsonArray.length) + '<i>');
    }
    else{
        $('#left-cloud').html(globalMaxRead - dataTagToJsonArray.length);
    }
    let lastread = $('#code-lu').html();
    $('#code-lu').html(readInput + ' à ' + time + '<br>' + lastread);
    $('#scan-ace').val('');
    $("#btn-load-bc").show();

    if((globalMaxRead - dataTagToJsonArray.length) < 1){
        loadScan();
    }
  }
  else if($('#scan-ace').val().length > 10) {
    // Great length
    $('#scan-ace').val('');
  }
  else {
    //Do nothing


  }
}

function loadScan(){
  // We call an asynchronous ajax
  $("#btn-load-bc").hide();
  $("#scan-ace").hide();
  $("#waiting-gif").show();
  $('#last-read-bc').html('En attente chargement');

  //We say here if it is an in or an out
  let order = 'I';
  if(($('#mg-graph-identifier').text() == 'ua-scan-out')){
    order = 'O';
  }

  $.ajax('/loadscan', {
      type: 'POST',  // http method
      data: { loadusername: $('#load-username').html(),
              loaduserid: $('#load-userid').html(),
              loaddata: JSON.stringify(dataTagToJsonArray),
              loardorder: order
      },  // data to submit
      success: function (data, status, xhr) {
          $("#waiting-gif").hide();
          $('#last-read-bc').html('<i class="mgs-rd-load-ok"><span class="icon-check-square nav-icon-fa nav-text"></span>&nbsp;Chargement réussi.<br>Vous pouvez continuer les scans.</i>');
          $('#last-read-time').html('');
          $('#left-cloud').html(globalMaxRead);
          $('#code-lu').html('');
          $('#scan-ace').val('');
          $("#scan-ace").show();
          dataTagToJsonArray = [];

          // Save for any internet issue here
          let storeOrder = 'listOfScanIn';
          if(($('#mg-graph-identifier').text() == 'ua-scan-out')){
            storeOrder = 'listOfScanOut';
          }
          localStorage.removeItem(storeOrder);
          //console.log('answer: ' + xhr.responseText + ' - data: ' + data.toString());


      },
      error: function (jqXhr, textStatus, errorMessage) {
          $("#waiting-gif").hide();
          $("#btn-load-bc").show();
          $("#scan-ace").show();
          $('#last-read-bc').html('<span class="icon-times-circle nav-icon-fa nav-text"></span>&nbsp;Échec du chargement - erreur: ' + textStatus + '/' + errorMessage + '. Veuillez recommencer.');
          console.log('Error')
      }
  });
}

/****************************************   Up is for UACEEM    ****************************************/

function verityFieldNameRef(){
  if(($('#inputMG').val().length > 0)
            && ($('#inputMGCode').val().length > 0)){
      $("#btnVerify").prop('disabled', false);
  }
  else{
      $("#btnVerify").prop('disabled', true);
  }
}

function leftSideUtils(){
  // Do something
  $(".progress-bar").effect('slide', { direction: 'left', mode: 'show' });
}


function loadAssRecapGrid(){

    responsivefields = [
        { name: "JOUR",
          title: 'Date',
          type: "text",
          align: "center",
          width: 25,
          css: "cell-recap",
          headercss: "cell-recap-hd",
          itemTemplate: function(value, item) {
            return item.LABEL_DAY_FR.substring(0, 3) + ' ' + value;
          }
        },
        //Default width is auto
        { name: "DEBUT",
          title: "Début",
          type: "text",
          width: 33,
          headercss: "cell-recap-hd",
          css: "cell-recap",
          itemTemplate: function(value, item) {
            return (value.toString().length == 1) ? ('0' + value + 'h00') : (value + 'h00');
          }
        },
        //Default width is auto
        { name: "SCAN_TIME",
          title: 'Scan',
          type: "text",
          width: 33,
          css: "cell-recap",
          headercss: "cell-recap-hd"
        },
        //Default width is auto
        { name: "STATUS",
          title: "Résultat",
          type: "text",
          width: 33,
          css: "cell-recap",
          headercss: "cell-recap-hd",
          itemTemplate: function(value, item) {
            let val = '';
            if(value == 'PON'){
              val = 'À l\'heure';
            }
            else if(value == 'LAT'){
              val = '<i class="recap-lat">Retard</i>';
            }
            else if(value == 'ABS'){
              val = '<i class="recap-mis">Absent(e)</i>';
            }
            else if(value == 'QUI'){
              val = '<i class="recap-qui">Quitté</i>';
            }
            else if(value == 'JUS'){
              val = 'Justifié';
            }
            else{
              val = '<strong>Jour non-compté<strong>';
            }
            return val;
          }
        }
    ];



  if(dataTagToJsonArray.length > 0){
    $("#jsGrid").jsGrid({
        height: "auto",
        width: "100%",
        noDataContent: "Pas encore d'activité",
        pageIndex: 1,
        pageSize: 10,
        pagerFormat: "Pages: {first} {prev} {pages} {next} {last}    {pageIndex} sur {pageCount}",
        pagePrevText: "Prec",
        pageNextText: "Suiv",
        pageFirstText: "Prem",
        pageLastText: "Dern",

        sorting: true,
        paging: true,
        data: dataTagToJsonArray,
        fields: responsivefields
    });
    // After the grid
    //refreshListener();
  }
  else{
    $("#jsGrid").hide();
  }

  responsivefieldsTrace = [
      { name: "IN_OUT",
        title: 'E/S',
        type: "text",
        align: "center",
        width: 25,
        css: "cell-recap",
        headercss: "cell-trace-hd",
        itemTemplate: function(value, item) {
          let val = '';
          if(value == 'I'){
            val = '<i class="ass-in-time"><span class="icon-arrow-circle-right nav-icon-fa-sm nav-text"></span>&nbsp;Entrée</i>';
          }
          else{
            val = '<i class="ass-out-time"><span class="icon-arrow-circle-left nav-icon-fa-sm nav-text"></span>&nbsp;Sortie</i>';
          }
          return val;
        }
      },
      //Default width is auto
      { name: "SCANDATE",
        title: "Date",
        type: "text",
        width: 33,
        headercss: "cell-trace-hd",
        css: "cell-recap"
      },
      //Default width is auto
      { name: "SCANTIME",
        title: 'Hh:mm:ss',
        type: "text",
        width: 33,
        headercss: "cell-trace-hd",
        css: "cell-recap"
      }
  ];

  $("#jsGridTrace").jsGrid({
      height: "auto",
      width: "100%",
      noDataContent: "Pas encore d'activité",
      pageIndex: 1,
      pageSize: 5,
      pagerFormat: "Pages: {first} {prev} {pages} {next} {last}    {pageIndex} sur {pageCount}",
      pagePrevText: "Prec",
      pageNextText: "Suiv",
      pageFirstText: "Prem",
      pageLastText: "Dern",

      sorting: true,
      paging: true,
      data: dataTagToJsonArrayTrace,
      fields: responsivefieldsTrace
  });



}

/***************************************************************************/
/***************************************************************************/
/***************************************************************************/
/***************************************************************************/
/****************************** ALL EDT ************************************/
/***************************************************************************/
/***************************************************************************/
/***************************************************************************/
/***************************************************************************/

function initAllEDTGrid(){
  $('#filter-all-edt').keyup(function() {
    filterDataAllEDT();
  });
  $('#re-init-dash-edt').click(function() {
    $('#filter-all-edt').val('');
    clearDataAllEDT();
  });
}

function filterDataAllEDT(){
  if(($('#filter-all-edt').val().length > 1) && ($('#filter-all-edt').val().length < 35)){
    //console.log('We need to filter !' + $('#filter-all').val());
    filteredDataAllEDTToJsonArray = dataAllEDTToJsonArray.filter(function (el) {
                                      return el.raw_data.includes($('#filter-all-edt').val().toUpperCase())
                                  });
    loadAllEDTGrid();
  }
  else if(($('#filter-all-edt').val().length < 2)) {
    // We clear data
    clearDataAllEDT();
  }
  else{
    // DO nothing
  }
}

function clearDataAllEDT(){
  filteredDataAllEDTToJsonArray = Array.from(dataAllEDTToJsonArray);
  loadAllEDTGrid();
};

function loadAllEDTGrid(){


      allEDTfields = [
        { name: "s",
          title: 'S#',
          type: "text",
          align: "center",
          width: 8,
          css: "cell-recap-l",
          headercss: "cell-recap-hd"
        },
        //Default width is auto
        { name: "monday_ofthew",
          title: "Lundi",
          type: "text",
          width: 15,
          headercss: "cell-recap-hd",
          css: "cell-recap-l"
        },
        //Default width is auto
        { name: "cohort_id",
          title: "#Classe",
          type: "text",
          width: 10,
          headercss: "cell-recap-hd",
          css: "cell-recap-l"
        },
        //Default width is auto
        { name: "mention",
          title: "Mention",
          type: "text",
          width: 100,
          headercss: "cell-recap-hd",
          css: "cell-recap-l"
        },
        //Default width is auto
        { name: "niveau",
          title: 'Niveau',
          type: "text",
          width: 15,
          headercss: "cell-recap-hd",
          css: "cell-recap-l"
        },
        //Default width is auto
        { name: "parcours",
          title: 'Parcours',
          type: "text",
          headercss: "cell-recap-hd",
          css: "cell-recap-l"
        },
        //Default width is auto
        { name: "groupe",
          title: 'Groupe',
          type: "text",
          width: 33,
          headercss: "cell-recap-hd",
          css: "cell-recap-l"
        },
        //Default width is auto
        { name: "master_id",
          title: '#',
          type: "text",
          width: 33,
          headercss: "cell-recap-hd",
          css: "cell-recap-l",
          itemTemplate: function(value, item) {
            let val = '';
            if((value == '') || (value == null)){
              val = '<i class="err"><span class="icon-times-circle nav-icon-fa-sm nav-text"></span>&nbsp;Manquant</i>';
            }
            else{
              val = '<i class="report-val"><span class="icon-check-square nav-icon-fa-sm nav-text"></span>&nbsp;Chargé</i>';
            }
            return val;
          }
        }
    ];

    $("#jsGridAllEDT").jsGrid({
        height: "auto",
        width: "100%",
        noDataContent: "Pas encore d'EDT disponible",
        pageIndex: 1,
        pageSize: 50,
        pagerFormat: "Pages: {first} {prev} {pages} {next} {last}    {pageIndex} sur {pageCount}",
        pagePrevText: "Prec",
        pageNextText: "Suiv",
        pageFirstText: "Prem",
        pageLastText: "Dern",

        sorting: true,
        paging: true,
        data: filteredDataAllEDTToJsonArray,
        fields: allEDTfields,
        // args are item - itemIndex - event
        rowClick: function(args){
              //console.log(args.event);
              //alert('test ' + JSON.stringify(args.event));
              // I cannot do anything on the row click for now
              //goToPartBarcode(args.item.id, args.item.secure)
              //var $target = $(args.event.target);
              //console.log(JSON.stringify($target));
              //console.log(JSON.stringify(args.event));
              //console.log(args.item.id);
              if((args.item.master_id == '') || (args.item.master_id == null)){
                // We do nothing the EDT is not loaded
              }
              else{
                //console.log("I read masterId");
                goToEDT(args.item.master_id);
              }
          }
    });
}

function goToEDT(masterId){
  $("#read-master-id").val(masterId);

  $("#mg-master-id-form").submit();
}

function runStat(){
  //Corlor
  var backgroundColorRef = [
      '#e6e6ff',
      '#f2ffe6',
      '#ccccff',
      '#b3b3ff',
      '#ffffcc',
      '#f7e6ff',
      '#9999ff',
      '#eeccff',
      '#e6b3ff',
      '#dd99ff',
      '#e6ffcc',
      '#d9ffb3',
      '#ccff99',
      '#ffffe6',
      '#ffffb3',
      '#ffff99'
  ];
  var borderColorRef = [
      '#000099',
      '#4d9900',
      '#000080',
      '#000066',
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
      '#333300'
  ];

  // Stat of status population
  let listOfLabelStat = new Array();
  let listOfDataStat = new Array();
  for(i=0; i<dataTagToJsonArray.length; i++){
    listOfLabelStat.push(dataTagToJsonArray[i].CITY);
    listOfDataStat.push(dataTagToJsonArray[i].CPT);
  }

  // Stat of status population
  let listOfLabelStatMis = new Array();
  let listOfDataStatMis = new Array();
  for(i=0; i<dataTagToJsonArrayMis.length; i++){
    listOfLabelStatMis.push(dataTagToJsonArrayMis[i].CITY);
    listOfDataStatMis.push(dataTagToJsonArrayMis[i].CPT);
  }


  var ctxClient = document.getElementById('statPieLate');
  new Chart(ctxClient, {
      type: 'doughnut',
      data: {
        labels: listOfLabelStat,
        datasets: [
          {
            label: "Retard par quartier",
            backgroundColor: backgroundColorRef,
            borderColor: borderColorRef,
            data: listOfDataStat,
            borderWidth: 0.3
          }
        ]
      },
      options: {
      }
  });

  var ctxClientBar = document.getElementById('statBarLate');
  new Chart(ctxClientBar, {
      type: 'bar',
      data: {
        labels: listOfLabelStat,
        datasets: [
          {
            label: "Retard par quartier",
            backgroundColor: backgroundColorRef,
            borderColor: borderColorRef,
            data: listOfDataStat,
            borderWidth: 0.4
          }
        ]
      },
      options: {
      }
  });

  var ctxClientBarMis = document.getElementById('statBarMis');
  new Chart(ctxClientBarMis, {
      type: 'bar',
      data: {
        labels: listOfLabelStatMis,
        datasets: [
          {
            label: "Absence par quartier",
            backgroundColor: backgroundColorRef,
            borderColor: borderColorRef,
            data: listOfDataStatMis,
            borderWidth: 0.4
          }
        ]
      },
      options: {
      }
  });

  responsivefieldsPP = [
      { name: "NAME",
        title: 'Étudiant',
        type: "text",
        align: "center",
        width: 25,
        css: "cell-recap",
        headercss: "cell-recap-hd"
      },
      //Default width is auto
      { name: "VAL",
        title: "Nombre absence",
        type: "text",
        align: "center",
        width: 33,
        headercss: "cell-recap-hd",
        css: "cell-recap"
      }
  ];


  if(dataTagToJsonArrayMisPP.length > 0){
    $("#jsGrid").jsGrid({
        height: "auto",
        width: "100%",
        noDataContent: "Pas encore d'activité",
        pageIndex: 1,
        pageSize: 11,
        pagerFormat: "Pages: {first} {prev} {pages} {next} {last}    {pageIndex} sur {pageCount}",
        pagePrevText: "Prec",
        pageNextText: "Suiv",
        pageFirstText: "Prem",
        pageLastText: "Dern",

        sorting: true,
        paging: true,
        data: dataTagToJsonArrayMisPP,
        fields: responsivefieldsPP
    });
    // After the grid
    //refreshListener();
  }
  else{
    $("#jsGrid").hide();
  }
}


function generateGlobalAssCSV(){
	const csvContentType = "data:text/csv;charset=utf-8,";
  let csvContent = "";
  const SEP_ = ","

	let dataString = "Username" + SEP_ + "Étudiant" + SEP_ + "Status" + SEP_ + "Jour" + SEP_ + "Date du cours" + SEP_  + "Débute" + SEP_ + "Classe" + SEP_ + "Détail du cours" + SEP_ + "\n";
	csvContent += dataString;
	for(var i=0; i<dataTagToJsonArrayReport.length; i++){
		// dataString = removeDiacritics(dataTagToJsonArrayReport[i].NAME) + SEP_ + removeDiacritics(dataTagToJsonArrayReport[i].STATUS) + SEP_ + removeDiacritics(dataTagToJsonArrayReport[i].JOUR) + SEP_ +  removeDiacritics(dataTagToJsonArrayReport[i].COURS_DATE) + SEP_ +  removeDiacritics(dataTagToJsonArray[i].DEBUT_COURS) + SEP_ + removeDiacritics(dataTagToJsonArray[i].CLASSE) + SEP_ + removeDiacritics(dataTagToJsonArray[i].COURS_DETAILS) + SEP_ ;
    dataString = dataTagToJsonArrayReport[i].USERNAME + SEP_ + dataTagToJsonArrayReport[i].NAME + SEP_ + dataTagToJsonArrayReport[i].STATUS + SEP_ + dataTagToJsonArrayReport[i].JOUR + SEP_ +  dataTagToJsonArrayReport[i].COURS_DATE + SEP_ +  dataTagToJsonArrayReport[i].DEBUT_COURS + SEP_ + dataTagToJsonArrayReport[i].CLASSE + SEP_ + dataTagToJsonArrayReport[i].COURS_DETAILS + SEP_ ;
    // easy close here
    csvContent += i < dataTagToJsonArrayReport.length ? dataString+ "\n" : dataString;
	}

  //console.log('Click on csv');
	let encodedUri = encodeURI(csvContent);
  let csvData = new Blob([csvContent], { type: csvContentType });

	let link = document.createElement("a");
  let csvUrl = URL.createObjectURL(csvData);

  link.href =  csvUrl;
  link.style = "visibility:hidden";
  link.download = 'RapportGlobalAssiduite.csv';
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
}

function generateCourseReportCSV(){
	const csvContentType = "data:text/csv;charset=utf-8,";
  let csvContent = "";
  const SEP_ = ","

	let dataString = "Classe" + SEP_ + "Jour" + SEP_ + "Date du cours" + SEP_  + "Mois du cours" + SEP_  + "Status du cours" + SEP_ + "Détail du cours" + SEP_ + "Débute" + SEP_ + "Nombre absence" + SEP_ + "Nombre quittant" + SEP_ + "Nombre d'étudiant classe" + SEP_ + "\n";
	csvContent += dataString;
	for(var i=0; i<dataTagToJsonArrayCourseReport.length; i++){
		dataString = dataTagToJsonArrayCourseReport[i].CLASSE + SEP_ + dataTagToJsonArrayCourseReport[i].JOUR + SEP_ + dataTagToJsonArrayCourseReport[i].COURS_DATE + SEP_ +  dataTagToJsonArrayCourseReport[i].MOIS + SEP_ +  dataTagToJsonArrayCourseReport[i].COURSE_STATUS + SEP_ + dataTagToJsonArrayCourseReport[i].COURS_DETAILS + SEP_ + dataTagToJsonArrayCourseReport[i].DEBUT_COURS + SEP_ + dataTagToJsonArrayCourseReport[i].NBR_ABS + SEP_ + dataTagToJsonArrayCourseReport[i].NBR_QUI + SEP_ + dataTagToJsonArrayCourseReport[i].NUMBER_STUD + SEP_ ;
    // easy close here
    csvContent += i < dataTagToJsonArrayCourseReport.length ? dataString+ "\n" : dataString;
	}

  //console.log('Click on csv');
	let encodedUri = encodeURI(csvContent);
  let csvData = new Blob([csvContent], { type: csvContentType });

	let link = document.createElement("a");
  let csvUrl = URL.createObjectURL(csvData);

  link.href =  csvUrl;
  link.style = "visibility:hidden";
  link.download = 'RapportCoursDispenses.csv';
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
}


/***********************************************************************************************************/

$(document).ready(function() {
  console.log('We are in ACE-ASS');

  if($('#mg-graph-identifier').text() == 'ua-cartz'){
    // Do something on cartz
    let getBarcodeACE = basicEncodeACE($('#id-username').html());
    /*
    JsBarcode("#mbc-1", getBarcodeACE, {
      width: 1.5,
      height: 85,
      displayValue: false
    });
    */
    JsBarcode("#barcode", getBarcodeACE, {
      width: 1.5,
      height: 85,
      displayValue: false
    });

    let getUrlProfile = $('#mg-profile-url').text();
    new QRCode(document.getElementById("mbc-0"), { text: getUrlProfile, width: 200, height: 200 });

    $("#btn-print-bc").click(function() {
        printCarteEtudiantPDF();
    });


  }
  // We check here the graph **************************************************** OLD
  else if((($('#mg-graph-identifier').text() == 'ua-scan-in')) ||
            ($('#mg-graph-identifier').text() == 'ua-scan-out')){

    $('#left-cloud').html(globalMaxRead - dataTagToJsonArray.length);

    // Update the list display if not empty
    let retrieveRead = $('#code-lu').html().toString().replace(/ /gi,'').replace(/\n/gi,'');
    let retrieveList = '';
    if(retrieveRead.toString().length == 0){
      // We go here if there is data. Else we don't get in the loop
      for(let iretr = 0; iretr<dataTagToJsonArray.length; iretr++){
          retrieveList = dataTagToJsonArray[iretr].username + ' à ' + dataTagToJsonArray[iretr].time + '<br>' + retrieveList;
      }
      $('#code-lu').html(retrieveList);
    }



    // Do nothing
    $( "#scan-ace" ).keyup(function() {
      verityContentScan();
    });

    $("#btn-load-bc").click(function() {
        loadScan();
    });

    if(dataTagToJsonArray.length == 0){
        $("#btn-load-bc").hide();
    }
    // else it is kept displayed


  }
  // We check here the graph **************************************************** OLD
  else if($('#mg-graph-identifier').text() == 'ua-profile'){
    console.log('in ua Profile');
    loadAssRecapGrid();



    if (!($(".uac-sm-p1-version").css('display') == 'none')){
        // 'element' is hidden
        const d = new Date();
        let currentday = d.getDay();
        //console.log('currentday: ' + currentday);
        if(currentday < 4){
            $(".uac-sm-p1-version").show();
            $(".uac-sm-p2-version").hide();
        }
        else{
            $(".uac-sm-p1-version").hide();
            $(".uac-sm-p2-version").show();
        }
    }
    $("#edt-disp-line").click(function() {
        console.log('Click #edt-disp-line');
        //$(".uac-bkp-version").css("visibility", "visible");
        $(".uac-bkp-version").show();
        $("#edt-disp-line").hide();
    });

    $(".edt-switch-wp").click(function() {
      if (!($(".uac-sm-p1-version").css('display') == 'none')){
          // 'element' is hidden
          $(".uac-sm-p1-version").hide();
          $(".uac-sm-p2-version").show();
      }
      else{
        $(".uac-sm-p1-version").show();
        $(".uac-sm-p2-version").hide();
      }

    });

    $("#edt-switch-in-out").click(function() {
      if (!($("#blc-trace-in-out").css('display') == 'none')){
        $("#blc-trace-in-out").hide();
      }
      else{
        $("#blc-trace-in-out").show();
      }
    });
  }
  else if($('#mg-graph-identifier').text() == 'dash-ass'){
    // Do nothing dash-ass
    runStat();
    $( "#uac-ass-glb-csv" ).click(function() {
      generateGlobalAssCSV();
    });
    $( "#uac-course-glb-csv" ).click(function() {
      generateCourseReportCSV();
    });

  }
  else if($('#mg-graph-identifier').text() == 'man-edt'){
    // Do nothing
    initAllEDTGrid();
    loadAllEDTGrid();
  }
  else if($('#mg-graph-identifier').text() == 'aft-loa'){
    // Do nothing
    $(".after-load-edt-trace").click(function() {
        $(".report-dis").show();
        $(".after-load-edt-trace").hide();
    });
  }
  else if($('#mg-graph-identifier').text() == 'loader-edt'){
    // Do nothing
    $("#file-upl-loader-sub").click(function() {
        console.log('You clicked on #file-upl-loader-sub');
        $("#loader-block").hide();
        $("#loader-img").hide();
        $("#loader-wait").show();
    });
  }
  else{
    //Do nothing
  }



});
