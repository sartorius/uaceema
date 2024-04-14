


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
          ' uaceem.com - Groupe ACEEM - PRVO 26B Manakambahiny Antananarivo 101 ');


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
        { name: "MATRICULE",
          title: "Matricule",
          type: "text",
          width: 30,
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
  const SEP_ = ";"

	let dataString = "Username" + SEP_ + "Nom" + SEP_ + "Prénom" + SEP_  + "Matricule" + SEP_  + "Genre" + SEP_  + "email" + SEP_ + "Date de naissance" + SEP_ + "Lieu de naissance" + SEP_ + "Téléphone étudiant" + SEP_ + "Classe ID" + SEP_ + "Mention" + SEP_ + "Niveau" + SEP_ + "Parcours" + SEP_ + "Groupe" + SEP_ + "Inscrit(e) depuis" + SEP_ + "Adresse" + SEP_ + "Quartier" + SEP_ + "Facebook" + SEP_ + "Établissement d'origine" + SEP_ + "Série Bac" + SEP_ + "Année du BAC" + SEP_ + "CIN" + SEP_ + "Date de délivrance" + SEP_ + "Lieu Délivrance CIN" + SEP_ + "Parent 1" + SEP_ + "Téléphone Parent 1" + SEP_ + "Profession Parent 1" + SEP_ + "Adresse Parent 1" + SEP_ + "Quartier Parent 1" + SEP_ + "Parent 2" + SEP_ + "Profession Parent 2" + SEP_ + "Téléphone Parent 2" + SEP_ + "Centres d'intéret" + SEP_ + "Situation Matrimoniale" + SEP_  + "\n";
	csvContent += dataString;
	for(let i=0; i<filteredDataAllSTUToJsonArray.length; i++){
		dataString = filteredDataAllSTUToJsonArray[i].USERNAME + SEP_
    + filteredDataAllSTUToJsonArray[i].LASTNAME + SEP_
    + filteredDataAllSTUToJsonArray[i].FIRSTNAME + SEP_
    + filteredDataAllSTUToJsonArray[i].MATRICULE + SEP_
    + filteredDataAllSTUToJsonArray[i].GENRE + SEP_
    +  filteredDataAllSTUToJsonArray[i].EMAIL + SEP_
    +  filteredDataAllSTUToJsonArray[i].DATEDENAISSANCE + SEP_
    +  filteredDataAllSTUToJsonArray[i].LIEUDN + SEP_
    +  filteredDataAllSTUToJsonArray[i].PHONE + SEP_
    +  filteredDataAllSTUToJsonArray[i].CLASS_ID + SEP_
    +  filteredDataAllSTUToJsonArray[i].CLASS_MENTION + SEP_
    +  filteredDataAllSTUToJsonArray[i].CLASS_NIVEAU + SEP_
    +  filteredDataAllSTUToJsonArray[i].CLASS_PARCOURS + SEP_
    +  filteredDataAllSTUToJsonArray[i].CLASS_GROUPE + SEP_
    +  filteredDataAllSTUToJsonArray[i].INSCDATE + SEP_
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
    + filteredDataAllSTUToJsonArray[i].SITM + SEP_
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

//***********************************************************************************************************
//***********************************************************************************************************
//***********************************************************************************************************
//***********************************************************************************************************
//***********************************************************************************************************
//***********************************************************************************************************
//***********************************************************************************************************
//***********************************************************************************************************
//***********************************************************************************************************
//***********************************************************************************************************
function generateProfileModifyDB(){
  $('#stu-details-modal').modal('hide');

  invModifyLastname = removeAllQuotes($('#pf-lastname').val().trim()).toUpperCase();
  invModifyFirstname = getCapitalize(removeAllQuotes($('#pf-firstname').val().trim()));
  invModifyOtherFirstname = removeAllQuotes($('#pf-othfirstname').val().trim());
  invModifyMatricule = $('#pf-matricule').val();
  invModifyTelStu = $('#pf-telstu').val();
  invModifyTelPar1 = $('#pf-telpar1').val();
  invModifyTelPar2 = $('#pf-telpar2').val();
  invModifyNoteOfStu = removeAllQuotes($('#pf-noteass').val());

  $.ajax('/generateProfileModifyDB', {
      type: 'POST',  // http method
      data: {
        currentAgentIdStr: CURRENT_AGENT_ID_STR,
        foundUserId: FOUND_USER_ID,
        paramLivinConf: invModifyLivingConfiguration.toUpperCase(),
        paramCohortId: tempClasseID,
        paramLastname: invModifyLastname,
        paramFirstname: invModifyFirstname,
        paramOthfirstname: invModifyOtherFirstname,
        paramMatricule: invModifyMatricule,
        paramPhone1: invModifyTelStu,
        paramPhonePar1: invModifyTelPar1,
        paramPhonePar2: invModifyTelPar2,
        paramNoteStu: invModifyNoteOfStu,
        token: GET_TOKEN
      },  // data to submit
      success: function (data, status, xhr) {
        $('#msg-alert').html(FOUND_USERNAME + " a été modifié avec succés.");
        $('#type-alert').addClass('alert-primary').removeClass('alert-danger');
        $('#ace-alert-msg').show(100);
        $('#ace-alert-msg').hide(1000*7);

        $('#stpf-lastname').html(invModifyLastname);
        $('#stpf-firstname').html(invModifyFirstname);
        if(invModifyOtherFirstname.length > 0){
          $('#stpf-othfirstname').html('<span class="icon-id-card nav-icon-fa-sm nav-text"></span>&nbsp;' + invModifyOtherFirstname.toUpperCase());
        }
        else{
          $('#stpf-othfirstname').html('&nbsp;');
        }
        $('#stpf-matricule').html(invModifyMatricule);
        $('#stpf-telstu').html(invModifyTelStu);
        $('#stpf-telpar1').html(getMGPhoneFormat(invModifyTelPar1));

        if(invModifyTelPar2.length > 0){
          $('#stpf-telpar2').html('<span class="icon-medkit nav-icon-fa-sm nav-text"></span>&nbsp;' + getMGPhoneFormat(invModifyTelPar2));
        }
        else{
          $('#stpf-telpar2').html('&nbsp;');
        }
        
        $('#stpf-noteass').html(invModifyNoteOfStu == '' ? 'NA' : invModifyNoteOfStu);

        $('#stpf-shortclasse').html(getClassShortClasse(tempClasseID));
        if(invModifyLivingConfiguration ==  'F'){
	          $('#stpf-livingconf').html('Vit en famille');
        }
        else if(invModifyLivingConfiguration == 'C'){
          $('#stpf-livingconf').html('Vit en colocation');
        }
        else{
          $('#stpf-livingconf').html('Vit seul' + (GENDER_H_F == 'F' ? 'e' : ''));
        }

        // Reset with the new value
        tempClasseIDCONST = tempClasseID;
        invModifyLastnameCONST = invModifyLastname;
        invModifyFirstnameCONST = invModifyFirstname;
        invModifyOtherFirstnameCONST = invModifyOtherFirstname;
        invModifyMatriculeCONST = invModifyMatricule;
        invModifyTelStuCONST = invModifyTelStu;
        invModifyTelPar1CONST = invModifyTelPar1;
        invModifyTelPar2CONST = invModifyTelPar2;
        invModifyLivingConfigurationCONST = invModifyLivingConfiguration;
        invModifyNoteOfStuCONST = invModifyNoteOfStu;

      },
      error: function (jqXhr, textStatus, errorMessage) {
        $('#msg-alert').html("ERR617P: " + FOUND_USERNAME + " modification du profil impossible, contactez le support. ");
        $('#type-alert').removeClass('alert-primary').addClass('alert-danger');
        $('#ace-alert-msg').show(100);
      }
  });
}

function fillCartoucheMentionProfile(){
  let listMention = '';
  for(let i=0; i<DATA_GET_ALL_MENTION_ToJsonArray.length; i++){
      listMention = listMention + '<a class="dropdown-item" onclick="selectMentionProfile(\'' + DATA_GET_ALL_MENTION_ToJsonArray[i].par_code + '\', \'' + DATA_GET_ALL_MENTION_ToJsonArray[i].title + '\')"  href="#">' + DATA_GET_ALL_MENTION_ToJsonArray[i].title + '</a>';
  }
  $('#dpmention-opt').html(listMention);
}

function selectMentionProfile(str, strTitle){
  tempMentionCode = str;
  tempMention = strTitle;
  $('#drp-select').html(strTitle);
  //console.log('You have just click on: ' + str);
  // We reset the dropdown
  selectClasseProfile(0, 'Classe', 0);
  fillCartoucheClasseProfile();
}

function fillCartoucheClasseProfile(){
  let listClasse = '';
  for(let i=0; i<DATA_GET_ALL_CLASS_ToJsonArray.length; i++){
    if(DATA_GET_ALL_CLASS_ToJsonArray[i].VCC_MENTION_CODE == tempMentionCode){
      listClasse = listClasse + '<a class="dropdown-item" onclick="selectClasseProfile(' + DATA_GET_ALL_CLASS_ToJsonArray[i].VCC_ID + ', \'' + DATA_GET_ALL_CLASS_ToJsonArray[i].VCC_SHORT_CLASSE + '\')"  href="#">' + DATA_GET_ALL_CLASS_ToJsonArray[i].VCC_SHORT_CLASSE + '</a>';
    }
  }
  $('#dpclasse-opt').html(listClasse);
}

function getClassShortClasse(paramId){
  for(let i=0; i<DATA_GET_ALL_CLASS_ToJsonArray.length; i++){
    if(DATA_GET_ALL_CLASS_ToJsonArray[i].VCC_ID == paramId){
      return DATA_GET_ALL_CLASS_ToJsonArray[i].VCC_SHORT_CLASSE;
    }
  }
  return 'ERR892CD'
}

function selectClasseProfile(classeId, str){
  tempClasseID = classeId;
  tempClasse = str;
  $("#selected-class").html(str);
  if(classeId == 0){
    $("#inv-class-txt").html('');
  }
  else{
    $("#inv-class-txt").html(str);
  }
  manageSaveChangeProfBtn();
}

function updateProfStatus(activeId){
  invModifyLivingConfiguration = $('#' + activeId).val();
  $('.stt-group').removeClass('active');  // Remove any existing active classes
  $('#' + activeId).addClass('active'); // Add the class to the nth element
  manageSaveChangeProfBtn();
}

function manageNoteAssiduite(){
  let readInputText = $("#pf-noteass").val();
  //console.log('in verifyTextAreaSaveBtn: ' + readInputText);
  let textInputLength = readInputText.length;
  $("#noteass-length").html((MAX_NOTE_LENGTH-textInputLength) < 0 ? 0 : (MAX_NOTE_LENGTH-textInputLength));

  if(textInputLength > MAX_NOTE_LENGTH){
    $("#pf-noteass").val(readInputText.substring(0, MAX_NOTE_LENGTH));
  }

  manageSaveChangeProfBtn();
}


function manageSaveChangeProfBtn(){
  let canBeSave = 'Y';

  //console.log('See 1 canBeSave: ' + canBeSave);
  if(($('#pf-lastname').val().length > 0) 
          && (canBeSave == 'Y')){
    $("#disp-err-msg").html('');
  }
  else{
    if($('#pf-lastname').val().length == 0){
      $("#disp-err-msg").html('Le nom de famille ne peux être vide.');
    }
    canBeSave = 'N';
  }

  //console.log('See 2 canBeSave: ' + canBeSave);
  if(($('#pf-firstname').val().trim().length > 0) 
          && (!(/\s/.test($('#pf-firstname').val().trim())))
          && (canBeSave == 'Y')){
    // If we dont have the exclamation we should be OK
    $("#disp-err-msg").html('');
  }
  else{
    if($('#pf-firstname').val().trim().length == 0){
      $("#disp-err-msg").html('Le prénom ne peux être vide.');
    }
    else if((/\s/.test($('#pf-firstname').val().trim()))){
      $("#disp-err-msg").html('Le premier prénom est le prénom d\'usage ne peut contenir un espace. Ajoutez les autres prénoms dans le champs Autre prénoms.');
    }
    else{
      //Do nothing
    }
    canBeSave = 'N';
  }

  //console.log('See 3 canBeSave: ' + canBeSave);
  if(($('#pf-matricule').val().length > 0) 
          && (/[0-9]+\/(GE|DT|ECO|CO|IE|RI|SS|BBA)\/(IèA|IIèA|IIIèA|IVèA|VèA)/.test($('#pf-matricule').val()))
          && (canBeSave == 'Y')){
    // If we dont have the exclamation we should be OK
    $("#disp-err-msg").html('');
  }
  else{
    if($('#pf-matricule').val().length == 0){
      $("#disp-err-msg").html('Le matricule ne peux être vide.');
    }
    else if(!(/[0-9]+\/(GE|DT|ECO|CO|IE|RI|SS|BBA)\/(IèA|IIèA|IIIèA|IVèA|VèA)/.test($('#pf-matricule').val()))){
      $("#disp-err-msg").html('Le matricule n\'est pas au format NN/XX/IIèA ou NN/XX/IIIèA<br>NN > Nombre<br>XX > DT: Droit; ECO: Économie; CO: Communication; IE: Informatique & Électronique; RI: Relations Internationales & Diplomatie; SS: Sciences de la Santé; BBA: Bachelor of Business Administration.');
    }
    else{
      //Do nothing
    }
    canBeSave = 'N';
  }

  //console.log('See 4 canBeSave: ' + canBeSave);
  if(($('#pf-telstu').val().length > 0) 
          && (/(033|034|032|037|038)[0-9]{7}$/.test($('#pf-telstu').val()))
          && (canBeSave == 'Y')){
    // If we dont have the exclamation we should be OK
    $("#disp-err-msg").html('');
  }
  else{
    if($('#pf-telstu').val().length == 0){
      $("#disp-err-msg").html('Le téléphone de l\'étudiant ne peux être vide.');
    }
    else if(!(/(033|034|032|037|038)[0-9]{7}$/.test($('#pf-telstu').val()))){
      $("#disp-err-msg").html('Le téléphone de l\'étudiant n\'est pas au format 03XNNNNNNN');
    }
    else{
      //Do nothing
    }
    canBeSave = 'N';
  }

  //console.log('See 5 canBeSave: ' + canBeSave);
  if(($('#pf-telpar1').val().length > 0) 
          && (/(033|034|032|037|038)[0-9]{7}$/.test($('#pf-telpar1').val()))
          && (canBeSave == 'Y')){
    // If we dont have the exclamation we should be OK
    $("#disp-err-msg").html('');
  }
  else{
    if($('#pf-telpar1').val().length == 0){
      $("#disp-err-msg").html('Le téléphone 1 du parent/tuteur ne peux être vide.');
    }
    else if(!(/(033|034|032|037|038)[0-9]{7}$/.test($('#pf-telpar1').val()))){
      $("#disp-err-msg").html('Le téléphone 1 n\'est pas au format 03XNNNNNNN');
    }
    else{
      //Do nothing
    }
    canBeSave = 'N';
  }

  //console.log('See 6 canBeSave: ' + canBeSave);
  if((($('#pf-telpar2').val().length > 0) 
          && (/(033|034|032|037|038)[0-9]{7}$/.test($('#pf-telpar2').val()))
          && (canBeSave == 'Y'))
      || (($('#pf-telpar2').val().length == 0)
            && (canBeSave == 'Y')
          )
          ){
    // If we dont have the exclamation we should be OK
    $("#disp-err-msg").html('');
  }
  else{
    if(($('#pf-telpar2').val().length > 0)
        && (!(/(033|034|032|037|038)[0-9]{7}$/.test($('#pf-telpar2').val())))
      ){
      $("#disp-err-msg").html('Le téléphone 2 n\'est pas au format 03XNNNNNNN');
    }
    else{
      //Do nothing
    }
    canBeSave = 'N';
  }

  if((tempClasseID > 0)
    && (canBeSave == 'Y')){
    $("#disp-err-msg").html('');
  }
  else{
    if((tempClasseID == 0)){
      $("#disp-err-msg").html('Veuillez choisir une classe pour cet étudiant');
    }
    canBeSave = 'N';
  }

  //console.log('See 7 canBeSave: ' + canBeSave);
  // ----------------------
  //Final decition here
  if(canBeSave == 'Y'){
    $('#profile-save-btn').show(100);
  }
  else{
    $('#profile-save-btn').hide(100);
  }
}

function hydrateMyProfile(){
  // Retrieve the constant in case of close or cancel case
  tempClasseID = tempClasseIDCONST;
  invModifyLastname = invModifyLastnameCONST;
  invModifyFirstname = invModifyFirstnameCONST;
  invModifyOtherFirstname = invModifyOtherFirstnameCONST;
  invModifyMatricule = invModifyMatriculeCONST;
  invModifyTelStu = invModifyTelStuCONST;
  invModifyTelPar1 = invModifyTelPar1CONST;
  invModifyTelPar2 = invModifyTelPar2CONST;
  invModifyLivingConfiguration = invModifyLivingConfigurationCONST;
  invModifyNoteOfStu = invModifyNoteOfStuCONST;

  manageNoteAssiduite();
  const KEEP_TEMP_CLASSE_ID = tempClasseID;
  let keepTempClasse = "";
  $('#pf-lastname').val(invModifyLastname);
  $('#pf-firstname').val(invModifyFirstname);
  $('#pf-othfirstname').val(invModifyOtherFirstname);
  $('#pf-matricule').val(invModifyMatricule);
  $('#pf-telstu').val(invModifyTelStu);
  $('#pf-telpar1').val(invModifyTelPar1);
  $('#pf-telpar2').val(invModifyTelPar2);
  if(invModifyNoteOfStu.length > 0){
      $('#pf-noteass').val(invModifyNoteOfStu);
  }

  updateProfStatus('stt-'+invModifyLivingConfiguration.toLowerCase());
  fillCartoucheMentionProfile();
  //console.log('Hydrate tempClasseID 1: ' + tempClasseID);
  for(let i=0; i<DATA_GET_ALL_CLASS_ToJsonArray.length; i++){
    if(DATA_GET_ALL_CLASS_ToJsonArray[i].VCC_ID == tempClasseID){
      tempMentionCode = DATA_GET_ALL_CLASS_ToJsonArray[i].VCC_MENTION_CODE;
      tempClasse = DATA_GET_ALL_CLASS_ToJsonArray[i].VCC_SHORT_CLASSE;
      keepTempClasse = tempClasse;

      selectMentionProfile(tempMentionCode, DATA_GET_ALL_CLASS_ToJsonArray[i].VCC_MENTION_TITLE);
      //console.log('Hydrate tempClasseID 2: ' + tempClasseID);
      tempClasseID = KEEP_TEMP_CLASSE_ID;
      tempClasse = keepTempClasse;
      selectClasseProfile(tempClasseID, tempClasse);
      return true;
    }
  }
  return false;
}

function modifyProfile(){
  //console.log('You clicked on modifyProfile');
  hydrateMyProfile();
  $('#stu-details-modal').modal('show');
}


function loadCalendar(){
  let calendarStr = "";
  let invCalendar = "";
  let invSemester = "";
  for(let i=0; i<dataCalendarToJsonArray.length; i++){
    if(!(invCalendar == dataCalendarToJsonArray[i].calendar)){
      invCalendar = dataCalendarToJsonArray[i].calendar;
      calendarStr = calendarStr + '<br><h1>Calendrier ' + invCalendar + '</h1>';
    }

    if(!(invSemester == dataCalendarToJsonArray[i].semester)){
      invSemester = dataCalendarToJsonArray[i].semester;
      calendarStr = calendarStr + '<br><h2><span class="icon-calendar nav-text"></span>&nbsp;Semestre ' + invSemester + '</h2><hr>';
    }

    calendarStr = calendarStr + '<span class="cal-lin">' + dataCalendarToJsonArray[i].DISP_DATE + '</span>' + '<span class="cal-lin">' + dataCalendarToJsonArray[i].DISP_INFO + '</span>' + '<span class="cal-lin">' + (dataCalendarToJsonArray[i].OBSERVATION == '' ? '&nbsp;' : dataCalendarToJsonArray[i].OBSERVATION) + '</span><br>';

    
  }
  $('#disp-cal').html(calendarStr);
  $('#last-upd-cal').html(dataCalendarToJsonArray[dataCalendarToJsonArray.length - 1].CREATE_DATE);
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
  if($('#mg-graph-identifier').text() == 'uac-cal'){
    // Do something on chk-sca
    // Do nothing
    loadCalendar();
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
