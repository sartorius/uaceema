
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
        pageSize: 50,
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

	let dataString = "Username" + SEP_ + "Nom" + SEP_ + "Prénom" + SEP_  + "email" + SEP_ + "Date de naissance" + SEP_ + "Téléphone étudiant" + SEP_ + "Classe ID" + SEP_ + "Mention" + SEP_ + "Niveau" + SEP_ + "Parcours" + SEP_ + "Groupe" + SEP_ + "Adresse" + SEP_ + "Quartier" + SEP_ + "Facebook" + SEP_ + "Établissement d'origine" + SEP_ + "Série Bac" + SEP_ + "Année du BAC" + SEP_ + "CIN" + SEP_ + "Date de délivrance" + SEP_ + "Lieu Délivrance CIN" + SEP_ + "Parent 1" + SEP_ + "Téléphone Parent 1" + SEP_ + "Profession Parent 1" + SEP_ + "Adresse Parent 1" + SEP_ + "Quartier Parent 1" + SEP_ + "Parent 2" + SEP_ + "Profession Parent 2" + SEP_ + "Téléphone Parent 2" + SEP_ + "Centres d'intéret" + SEP_ + "\n";
	csvContent += dataString;
	for(var i=0; i<filteredDataAllSTUToJsonArray.length; i++){
		dataString = filteredDataAllSTUToJsonArray[i].USERNAME + SEP_
    + filteredDataAllSTUToJsonArray[i].LASTNAME + SEP_
    + filteredDataAllSTUToJsonArray[i].FIRSTNAME + SEP_
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
  }
  if($('#mg-graph-identifier').text() == 'chk-sca'){
    // Do something on chk-sca
    // Do nothing
    loadLastScanGrid();
  }
  else if($('#mg-graph-identifier').text() == 'xxx'){
    // Do something
  }
  else{
    //Do nothing
  }



});
