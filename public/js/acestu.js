


/***************************************************************************/
/***************************************************************************/
/***************************************************************************/
/***************************************************************************/
/****************************   PRINT 9   **********************************/
/***************************************************************************/
/***************************************************************************/
/***************************************************************************/
/***************************************************************************/


function printBatchStudentCard(limit, maxIs){

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



function managePrint9(){
  // You need to manage the maximum value here : _printmax.html.twig
  console.log('You are in managePrint9');
  const printMax = 60;
  let nbrToPrint = printMax;
  if (filteredDataAllSTUToJsonArray.length < printMax){
      nbrToPrint = filteredDataAllSTUToJsonArray.length;
  }
  console.log('nbrToPrint: ' + nbrToPrint);

  // Feed all images
  for(let i=0; i<nbrToPrint; i++){
      JsBarcode("#item-bc-" + i, filteredDataAllSTUToJsonArray[i].USERNAME, {
        width: 1.5,
        height: 70,
        displayValue: true
      });
      $('#pf-'+ i).attr('src', '/img/mdl_data/' + filteredDataAllSTUToJsonArray[i].USERNAME.toLowerCase() + '.jpg');


      $('#prt-nom-'+ i).html(filteredDataAllSTUToJsonArray[i].LASTNAME.substr(0, 23));
      $('#prt-pnom-'+ i).html(filteredDataAllSTUToJsonArray[i].FIRSTNAME.substr(0, 28));

      //getBase64Image('/img/mdl_data/' + filteredDataAllSTUToJsonArray[i].USERNAME.toLowerCase() + '.jpg', 'can-'+ i);
  }

  // Print all
  //print();
  $("#waiting-blc").show(500);
  $("#grid-all-blc").hide(500);
  $("#grid-crit-blc").hide(500);
  let millisecondsToWait = printMax * 100;
  setTimeout(function() {
      // Whatever you want to do after the wait
      printBatchStudentCard(nbrToPrint, printMax);
  }, millisecondsToWait);



};



/***************************************************************************/
/***************************************************************************/
/***************************************************************************/
/***************************************************************************/
/**************************** DID I APPLY **********************************/
/***************************************************************************/
/***************************************************************************/
/***************************************************************************/
/***************************************************************************/
function verityFieldDidIApply(){
  let allFieldOK = true;

  // Check Lastname
  if($('#inputLN').val().length < 1){
    allFieldOK = false;
    $("#help-mess").show();
  }
  else{
    $("#help-mess").hide();
  }

  if((!(/(?:0[1-9]|[12][0-9]|3[01])[-](?:0[1-9]|1[012])[-](?:19\d{2}|20[01][0-9]|2020)/.test($('#inputBirthD').val())))
        || ($('#inputBirthD').val().length < 1)){
    allFieldOK = false;
    $("#help-mess").show();
  }
  else{
    $("#help-mess").hide();
  }


  if(allFieldOK){
      $("#btnCheckDidApp").prop('disabled', false);
      $("#help-mess").hide();
  }
  else{
      $("#btnCheckDidApp").prop('disabled', true);
      $("#help-mess").show();
  }
};

function checkFieldDidIApply(){

  $( ".form-control" ).keyup(function() {
    verityFieldDidIApply();
  });
};


/***************************************************************************/
/***************************************************************************/
/***************************************************************************/
/***************************************************************************/
/****************************** ALL STU ************************************/
/***************************************************************************/
/***************************************************************************/
/***************************************************************************/
/***************************************************************************/

function filterDataAllSTU(){
  if(($('#filter-all-stu').val().length > 1) && ($('#filter-all-stu').val().length < 35)){
    //console.log('We need to filter !' + $('#filter-all').val());
    filteredDataAllSTUToJsonArray = dataAllSTUToJsonArray.filter(function (el) {
                                      return el.raw_data.includes($('#filter-all-stu').val().toUpperCase())
                                  });
    loadAllSTUGrid();
  }
  else if(($('#filter-all-stu').val().length < 2)) {
    // We clear data
    clearDataAllSTU();
  }
  else{
    // DO nothing
  }
}

function clearDataAllSTU(){
  filteredDataAllSTUToJsonArray = Array.from(dataAllSTUToJsonArray);
  loadAllSTUGrid();
};


function initAllSTUGrid(){
  $('#filter-all-stu').keyup(function() {
    filterDataAllSTU();
  });
  $('#re-init-dash-stu').click(function() {
    $('#filter-all-stu').val('');
    clearDataAllSTU();
  });
}


function loadAllSTUGrid(){

      // Centralize here the count of filter
      $('#mst-filcnt').html(filteredDataAllSTUToJsonArray.length);

      allSTUfields = [
        { name: "USERNAME",
          title: 'Username',
          type: "text",
          align: "left",
          width: 40,
          css: "cell-recap-l-num",
          headercss: "cell-recap-hd"
        },
        //Default width is auto
        { name: "FIRSTNAME",
          title: "Prénom",
          type: "text",
          width: 60,
          headercss: "cell-recap-hd",
          css: "cell-recap-l"
        },
        //Default width is auto
        { name: "LASTNAME",
          title: "Nom de famille",
          type: "text",
          headercss: "cell-recap-hd",
          css: "cell-recap-l"
        },
        //Default width is auto
        { name: "CLASS_MENTION",
          title: "Mention",
          type: "text",
          width: 60,
          headercss: "cell-recap-hd",
          css: "cell-recap-l"
        },
        //Default width is auto
        { name: "CLASS_NIVEAU",
          title: 'Niveau',
          type: "text",
          width: 15,
          headercss: "cell-recap-hd",
          css: "cell-recap-l"
        },
        //Default width is auto
        { name: "CLASS_PARCOURS",
          title: 'Parcours',
          type: "text",
          width: 30,
          headercss: "cell-recap-hd",
          css: "cell-recap-l"
        },
        //Default width is auto
        { name: "CLASS_GROUPE",
          title: 'Groupe',
          type: "text",
          width: 33,
          headercss: "cell-recap-hd",
          css: "cell-recap-l"
        }
    ];

    $("#jsGridAllSTU").jsGrid({
        height: "auto",
        width: "100%",
        noDataContent: "Aucun étudiant n'a été trouvé",
        pageIndex: 1,
        pageSize: 38,
        pagerFormat: "Pages: {first} {prev} {pages} {next} {last}    {pageIndex} sur {pageCount}",
        pagePrevText: "Prec",
        pageNextText: "Suiv",
        pageFirstText: "Prem",
        pageLastText: "Dern",

        sorting: true,
        paging: true,
        data: filteredDataAllSTUToJsonArray,
        fields: allSTUfields,
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
              goToSTU(args.item.PAGE);
          }
    });
}

function goToSTU(page){
  $("#read-stu-page").val(page);

  $("#mg-stu-page-form").submit();
}

/***********************************************************************************************************/

function loadLastScanGrid(){

      if(window.screen.availWidth < 1100){
          lastScanFields = [
              { name: "USERNAME",
                title: 'Scan',
                type: "text",
                align: "left",
                width: 50,
                css: "cell-recap-l-num",
                headercss: "cell-recap-hd"
              },
              //Default width is auto
              { name: "SCAN_TIME",
                title: 'Heure',
                type: "text",
                width: 30,
                headercss: "cell-recap-hd",
                css: "cell-recap-l"
              },
              //Default width is auto
              { name: "IN_OUT",
                title: 'E/S',
                type: "text",
                width: 20,
                headercss: "cell-recap-hd",
                css: "cell-recap-l",
                itemTemplate: function(value, item) {
                  let val = '';
                  if(value == 'I'){
                    val = 'E';
                  }
                  else{
                    val = 'S';
                  }
                  return val;
                }
              },
              //Default width is auto
              { name: "SCAN_STATUS",
                title: 'Status',
                type: "text",
                width: 33,
                headercss: "cell-recap-hd",
                css: "cell-recap-l",
                itemTemplate: function(value, item) {
                  let val = '';
                  if(value == 'END'){
                    val = 'Validé';
                  }
                  else if(value == 'NEW'){
                    val = '<i class="recap-lat">En cours</i>';
                  }
                  else {
                    val = '<i class="recap-mis">Erreur</i>';
                  }
                  return val;
                }
              }
          ];

      }else{

          lastScanFields = [
              { name: "USERNAME",
                title: 'Scan',
                type: "text",
                align: "left",
                width: 40,
                css: "cell-recap-l-num",
                headercss: "cell-recap-hd"
              },
              //Default width is auto
              { name: "FIRSTNAME",
                title: "Prénom",
                type: "text",
                width: 50,
                headercss: "cell-recap-hd",
                css: "cell-recap-l"
              },
              //Default width is auto
              { name: "LASTNAME",
                title: "Nom de famille",
                type: "text",
                headercss: "cell-recap-hd",
                css: "cell-recap-l"
              },
              { name: "CLASSE",
                title: "Classe",
                type: "text",
                width: 50,
                headercss: "cell-recap-hd",
                css: "cell-recap-l"
              },
              //Default width is auto
              { name: "SCAN_DATE",
                title: "Date",
                type: "text",
                width: 18,
                headercss: "cell-recap-hd",
                css: "cell-recap-l"
              },
              //Default width is auto
              { name: "SCAN_TIME",
                title: 'Heure',
                type: "text",
                width: 25,
                headercss: "cell-recap-hd",
                css: "cell-recap-l"
              },
              //Default width is auto
              { name: "IN_OUT",
                title: 'E/S',
                type: "text",
                width: 20,
                headercss: "cell-recap-hd",
                css: "cell-recap-l",
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
              { name: "SCAN_STATUS",
                title: 'Status',
                type: "text",
                width: 27,
                headercss: "cell-recap-hd",
                css: "cell-recap-l",
                itemTemplate: function(value, item) {
                  let val = '';
                  if(value == 'END'){
                    val = 'Validé';
                  }
                  else if(value == 'NEW'){
                    val = '<i class="recap-lat">En cours</i>';
                  }
                  else {
                    val = '<i class="recap-mis">Erreur</i>';
                  }
                  return val;
                }
              }
          ];

      };

    $("#jsGridLastScanSTU").jsGrid({
        height: "auto",
        width: "100%",
        noDataContent: "Aucun scan n'a été enregistré aujourd'hui",
        pageIndex: 1,
        pageSize: 50,
        pagerFormat: "Pages: {first} {prev} {pages} {next} {last}    {pageIndex} sur {pageCount}",
        pagePrevText: "Prec",
        pageNextText: "Suiv",
        pageFirstText: "Prem",
        pageLastText: "Dern",

        sorting: true,
        paging: true,
        data: dataLastScanToJsonArray,
        fields: lastScanFields
    });
}

/***********************************************************************************************************/


function generateAllMngStudentReportCSV(){
	const csvContentType = "data:text/csv;charset=utf-8,";

  let csvContent = "";
  const SEP_ = ","

	let dataString = "Username" + SEP_ + "Nom" + SEP_ + "Prénom" + SEP_  + "Genre" + SEP_  + "email" + SEP_ + "Date de naissance" + SEP_ + "Téléphone étudiant" + SEP_ + "Classe ID" + SEP_ + "Mention" + SEP_ + "Niveau" + SEP_ + "Parcours" + SEP_ + "Groupe" + SEP_ + "Adresse" + SEP_ + "Quartier" + SEP_ + "Facebook" + SEP_ + "Établissement d'origine" + SEP_ + "Série Bac" + SEP_ + "Année du BAC" + SEP_ + "CIN" + SEP_ + "Date de délivrance" + SEP_ + "Lieu Délivrance CIN" + SEP_ + "Parent 1" + SEP_ + "Téléphone Parent 1" + SEP_ + "Profession Parent 1" + SEP_ + "Adresse Parent 1" + SEP_ + "Quartier Parent 1" + SEP_ + "Parent 2" + SEP_ + "Profession Parent 2" + SEP_ + "Téléphone Parent 2" + SEP_ + "Centres d'intéret" + SEP_ + "\n";
	csvContent += dataString;
	for(let i=0; i<filteredDataAllSTUToJsonArray.length; i++){
		dataString = filteredDataAllSTUToJsonArray[i].USERNAME + SEP_
    + filteredDataAllSTUToJsonArray[i].LASTNAME + SEP_
    + filteredDataAllSTUToJsonArray[i].FIRSTNAME + SEP_
    + filteredDataAllSTUToJsonArray[i].GENRE + SEP_
    +  filteredDataAllSTUToJsonArray[i].EMAIL + SEP_
    +  filteredDataAllSTUToJsonArray[i].DATEDENAISSANCE + SEP_
    +  filteredDataAllSTUToJsonArray[i].PHONE + SEP_
    +  filteredDataAllSTUToJsonArray[i].CLASS_ID + SEP_
    +  filteredDataAllSTUToJsonArray[i].CLASS_MENTION + SEP_
    +  filteredDataAllSTUToJsonArray[i].CLASS_NIVEAU + SEP_
    +  filteredDataAllSTUToJsonArray[i].CLASS_PARCOURS + SEP_
    +  filteredDataAllSTUToJsonArray[i].CLASS_GROUPE + SEP_
    +  filteredDataAllSTUToJsonArray[i].ADRESSE + SEP_
    +  filteredDataAllSTUToJsonArray[i].QUARTIER + SEP_
    +  filteredDataAllSTUToJsonArray[i].FB + SEP_
    +  filteredDataAllSTUToJsonArray[i].ORIGINE + SEP_
    +  filteredDataAllSTUToJsonArray[i].SERIE_BAC + SEP_
    +  filteredDataAllSTUToJsonArray[i].ANNEE_BAC + SEP_
    +  filteredDataAllSTUToJsonArray[i].NUMCIN + SEP_
    +  filteredDataAllSTUToJsonArray[i].DATECIN + SEP_
    +  filteredDataAllSTUToJsonArray[i].LIEU_CIN + SEP_
    +  filteredDataAllSTUToJsonArray[i].NOMPNOMP1 + SEP_
    +  filteredDataAllSTUToJsonArray[i].PHONEPAR1 + SEP_
    +  filteredDataAllSTUToJsonArray[i].PROFPAR1 + SEP_
    +  filteredDataAllSTUToJsonArray[i].ADDRPAR1 + SEP_
    +  filteredDataAllSTUToJsonArray[i].CITYPAR1 + SEP_
    +  filteredDataAllSTUToJsonArray[i].NOMPNOMP2 + SEP_
    +  filteredDataAllSTUToJsonArray[i].PROFPAR2 + SEP_
    +  filteredDataAllSTUToJsonArray[i].PHONEPAR2 + SEP_
    +  filteredDataAllSTUToJsonArray[i].CENTINT + SEP_
    ;
    // easy close here
    csvContent += i < filteredDataAllSTUToJsonArray.length ? dataString+ "\n" : dataString;

	}

  //console.log('Click on csv');
	let encodedUri = encodeURI(csvContent);
  let csvData = new Blob([csvContent], { type: csvContentType });

	let link = document.createElement("a");
  let csvUrl = URL.createObjectURL(csvData);

  link.href =  csvUrl;
  link.style = "visibility:hidden";
  link.download = 'ListeDesEtudiants.csv';
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);

}

/***********************************************************************************************************/

$(document).ready(function() {
  console.log('We are in ACE-STU');

  if($('#mg-graph-identifier').text() == 'das-stu'){
    // Do something on das-stu
    // Do nothing
    initAllSTUGrid();
    loadAllSTUGrid();
    $( "#uac-mst-all-csv" ).click(function() {
      generateAllMngStudentReportCSV();
    });


    // Manage print
    $("#uac-mst-print").click(function() {
        managePrint9();
    });


  }
  if($('#mg-graph-identifier').text() == 'chk-sca'){
    // Do something on chk-sca
    // Do nothing
    loadLastScanGrid();
  }
  else if($('#mg-graph-identifier').text() == 'pro-didia'){
    // Do something
    //console.log('Here we go');
    //initialize
    $("#btnCheckDidApp").prop('disabled', true);
    verityFieldDidIApply();
    //$('#inputLN').val('');
    //$('#inputBirthD').val('');
    $("#help-mess").hide();

    checkFieldDidIApply();

  }
  else if($('#mg-graph-identifier').text() == 'xxx'){
    // Do something
  }
  else{
    //Do nothing
  }



});
