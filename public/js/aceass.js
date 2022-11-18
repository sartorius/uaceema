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

/*
function removeDiacritics(u){let E=[{base:"A",letters:/[\u0041\u24B6\uFF21\u00C0\u00C1\u00C2\u1EA6\u1EA4\u1EAA\u1EA8\u00C3\u0100\u0102\u1EB0\u1EAE\u1EB4\u1EB2\u0226\u01E0\u00C4\u01DE\u1EA2\u00C5\u01FA\u01CD\u0200\u0202\u1EA0\u1EAC\u1EB6\u1E00\u0104\u023A\u2C6F]/g},{base:"AA",letters:/[\uA732]/g},{base:"AE",letters:/[\u00C6\u01FC\u01E2]/g},{base:"AO",letters:/[\uA734]/g},{base:"AU",letters:/[\uA736]/g},{base:"AV",letters:/[\uA738\uA73A]/g},{base:"AY",letters:/[\uA73C]/g},{base:"B",letters:/[\u0042\u24B7\uFF22\u1E02\u1E04\u1E06\u0243\u0182\u0181]/g},{base:"C",letters:/[\u0043\u24B8\uFF23\u0106\u0108\u010A\u010C\u00C7\u1E08\u0187\u023B\uA73E]/g},{base:"D",letters:/[\u0044\u24B9\uFF24\u1E0A\u010E\u1E0C\u1E10\u1E12\u1E0E\u0110\u018B\u018A\u0189\uA779]/g},{base:"DZ",letters:/[\u01F1\u01C4]/g},{base:"Dz",letters:/[\u01F2\u01C5]/g},{base:"E",letters:/[\u0045\u24BA\uFF25\u00C8\u00C9\u00CA\u1EC0\u1EBE\u1EC4\u1EC2\u1EBC\u0112\u1E14\u1E16\u0114\u0116\u00CB\u1EBA\u011A\u0204\u0206\u1EB8\u1EC6\u0228\u1E1C\u0118\u1E18\u1E1A\u0190\u018E]/g},{base:"F",letters:/[\u0046\u24BB\uFF26\u1E1E\u0191\uA77B]/g},{base:"G",letters:/[\u0047\u24BC\uFF27\u01F4\u011C\u1E20\u011E\u0120\u01E6\u0122\u01E4\u0193\uA7A0\uA77D\uA77E]/g},{base:"H",letters:/[\u0048\u24BD\uFF28\u0124\u1E22\u1E26\u021E\u1E24\u1E28\u1E2A\u0126\u2C67\u2C75\uA78D]/g},{base:"I",letters:/[\u0049\u24BE\uFF29\u00CC\u00CD\u00CE\u0128\u012A\u012C\u0130\u00CF\u1E2E\u1EC8\u01CF\u0208\u020A\u1ECA\u012E\u1E2C\u0197]/g},{base:"J",letters:/[\u004A\u24BF\uFF2A\u0134\u0248]/g},{base:"K",letters:/[\u004B\u24C0\uFF2B\u1E30\u01E8\u1E32\u0136\u1E34\u0198\u2C69\uA740\uA742\uA744\uA7A2]/g},{base:"L",letters:/[\u004C\u24C1\uFF2C\u013F\u0139\u013D\u1E36\u1E38\u013B\u1E3C\u1E3A\u0141\u023D\u2C62\u2C60\uA748\uA746\uA780]/g},{base:"LJ",letters:/[\u01C7]/g},{base:"Lj",letters:/[\u01C8]/g},{base:"M",letters:/[\u004D\u24C2\uFF2D\u1E3E\u1E40\u1E42\u2C6E\u019C]/g},{base:"N",letters:/[\u004E\u24C3\uFF2E\u01F8\u0143\u00D1\u1E44\u0147\u1E46\u0145\u1E4A\u1E48\u0220\u019D\uA790\uA7A4]/g},{base:"NJ",letters:/[\u01CA]/g},{base:"Nj",letters:/[\u01CB]/g},{base:"O",letters:/[\u004F\u24C4\uFF2F\u00D2\u00D3\u00D4\u1ED2\u1ED0\u1ED6\u1ED4\u00D5\u1E4C\u022C\u1E4E\u014C\u1E50\u1E52\u014E\u022E\u0230\u00D6\u022A\u1ECE\u0150\u01D1\u020C\u020E\u01A0\u1EDC\u1EDA\u1EE0\u1EDE\u1EE2\u1ECC\u1ED8\u01EA\u01EC\u00D8\u01FE\u0186\u019F\uA74A\uA74C]/g},{base:"OI",letters:/[\u01A2]/g},{base:"OO",letters:/[\uA74E]/g},{base:"OU",letters:/[\u0222]/g},{base:"P",letters:/[\u0050\u24C5\uFF30\u1E54\u1E56\u01A4\u2C63\uA750\uA752\uA754]/g},{base:"Q",letters:/[\u0051\u24C6\uFF31\uA756\uA758\u024A]/g},{base:"R",letters:/[\u0052\u24C7\uFF32\u0154\u1E58\u0158\u0210\u0212\u1E5A\u1E5C\u0156\u1E5E\u024C\u2C64\uA75A\uA7A6\uA782]/g},{base:"S",letters:/[\u0053\u24C8\uFF33\u1E9E\u015A\u1E64\u015C\u1E60\u0160\u1E66\u1E62\u1E68\u0218\u015E\u2C7E\uA7A8\uA784]/g},{base:"T",letters:/[\u0054\u24C9\uFF34\u1E6A\u0164\u1E6C\u021A\u0162\u1E70\u1E6E\u0166\u01AC\u01AE\u023E\uA786]/g},{base:"TZ",letters:/[\uA728]/g},{base:"U",letters:/[\u0055\u24CA\uFF35\u00D9\u00DA\u00DB\u0168\u1E78\u016A\u1E7A\u016C\u00DC\u01DB\u01D7\u01D5\u01D9\u1EE6\u016E\u0170\u01D3\u0214\u0216\u01AF\u1EEA\u1EE8\u1EEE\u1EEC\u1EF0\u1EE4\u1E72\u0172\u1E76\u1E74\u0244]/g},{base:"V",letters:/[\u0056\u24CB\uFF36\u1E7C\u1E7E\u01B2\uA75E\u0245]/g},{base:"VY",letters:/[\uA760]/g},{base:"W",letters:/[\u0057\u24CC\uFF37\u1E80\u1E82\u0174\u1E86\u1E84\u1E88\u2C72]/g},{base:"X",letters:/[\u0058\u24CD\uFF38\u1E8A\u1E8C]/g},{base:"Y",letters:/[\u0059\u24CE\uFF39\u1EF2\u00DD\u0176\u1EF8\u0232\u1E8E\u0178\u1EF6\u1EF4\u01B3\u024E\u1EFE]/g},{base:"Z",letters:/[\u005A\u24CF\uFF3A\u0179\u1E90\u017B\u017D\u1E92\u1E94\u01B5\u0224\u2C7F\u2C6B\uA762]/g},{base:"a",letters:/[\u0061\u24D0\uFF41\u1E9A\u00E0\u00E1\u00E2\u1EA7\u1EA5\u1EAB\u1EA9\u00E3\u0101\u0103\u1EB1\u1EAF\u1EB5\u1EB3\u0227\u01E1\u00E4\u01DF\u1EA3\u00E5\u01FB\u01CE\u0201\u0203\u1EA1\u1EAD\u1EB7\u1E01\u0105\u2C65\u0250]/g},{base:"aa",letters:/[\uA733]/g},{base:"ae",letters:/[\u00E6\u01FD\u01E3]/g},{base:"ao",letters:/[\uA735]/g},{base:"au",letters:/[\uA737]/g},{base:"av",letters:/[\uA739\uA73B]/g},{base:"ay",letters:/[\uA73D]/g},{base:"b",letters:/[\u0062\u24D1\uFF42\u1E03\u1E05\u1E07\u0180\u0183\u0253]/g},{base:"c",letters:/[\u0063\u24D2\uFF43\u0107\u0109\u010B\u010D\u00E7\u1E09\u0188\u023C\uA73F\u2184]/g},{base:"d",letters:/[\u0064\u24D3\uFF44\u1E0B\u010F\u1E0D\u1E11\u1E13\u1E0F\u0111\u018C\u0256\u0257\uA77A]/g},{base:"dz",letters:/[\u01F3\u01C6]/g},{base:"e",letters:/[\u0065\u24D4\uFF45\u00E8\u00E9\u00EA\u1EC1\u1EBF\u1EC5\u1EC3\u1EBD\u0113\u1E15\u1E17\u0115\u0117\u00EB\u1EBB\u011B\u0205\u0207\u1EB9\u1EC7\u0229\u1E1D\u0119\u1E19\u1E1B\u0247\u025B\u01DD]/g},{base:"f",letters:/[\u0066\u24D5\uFF46\u1E1F\u0192\uA77C]/g},{base:"g",letters:/[\u0067\u24D6\uFF47\u01F5\u011D\u1E21\u011F\u0121\u01E7\u0123\u01E5\u0260\uA7A1\u1D79\uA77F]/g},{base:"h",letters:/[\u0068\u24D7\uFF48\u0125\u1E23\u1E27\u021F\u1E25\u1E29\u1E2B\u1E96\u0127\u2C68\u2C76\u0265]/g},{base:"hv",letters:/[\u0195]/g},{base:"i",letters:/[\u0069\u24D8\uFF49\u00EC\u00ED\u00EE\u0129\u012B\u012D\u00EF\u1E2F\u1EC9\u01D0\u0209\u020B\u1ECB\u012F\u1E2D\u0268\u0131]/g},{base:"j",letters:/[\u006A\u24D9\uFF4A\u0135\u01F0\u0249]/g},{base:"k",letters:/[\u006B\u24DA\uFF4B\u1E31\u01E9\u1E33\u0137\u1E35\u0199\u2C6A\uA741\uA743\uA745\uA7A3]/g},{base:"l",letters:/[\u006C\u24DB\uFF4C\u0140\u013A\u013E\u1E37\u1E39\u013C\u1E3D\u1E3B\u017F\u0142\u019A\u026B\u2C61\uA749\uA781\uA747]/g},{base:"lj",letters:/[\u01C9]/g},{base:"m",letters:/[\u006D\u24DC\uFF4D\u1E3F\u1E41\u1E43\u0271\u026F]/g},{base:"n",letters:/[\u006E\u24DD\uFF4E\u01F9\u0144\u00F1\u1E45\u0148\u1E47\u0146\u1E4B\u1E49\u019E\u0272\u0149\uA791\uA7A5]/g},{base:"nj",letters:/[\u01CC]/g},{base:"o",letters:/[\u006F\u24DE\uFF4F\u00F2\u00F3\u00F4\u1ED3\u1ED1\u1ED7\u1ED5\u00F5\u1E4D\u022D\u1E4F\u014D\u1E51\u1E53\u014F\u022F\u0231\u00F6\u022B\u1ECF\u0151\u01D2\u020D\u020F\u01A1\u1EDD\u1EDB\u1EE1\u1EDF\u1EE3\u1ECD\u1ED9\u01EB\u01ED\u00F8\u01FF\u0254\uA74B\uA74D\u0275]/g},{base:"oi",letters:/[\u01A3]/g},{base:"ou",letters:/[\u0223]/g},{base:"oo",letters:/[\uA74F]/g},{base:"p",letters:/[\u0070\u24DF\uFF50\u1E55\u1E57\u01A5\u1D7D\uA751\uA753\uA755]/g},{base:"q",letters:/[\u0071\u24E0\uFF51\u024B\uA757\uA759]/g},{base:"r",letters:/[\u0072\u24E1\uFF52\u0155\u1E59\u0159\u0211\u0213\u1E5B\u1E5D\u0157\u1E5F\u024D\u027D\uA75B\uA7A7\uA783]/g},{base:"s",letters:/[\u0073\u24E2\uFF53\u00DF\u015B\u1E65\u015D\u1E61\u0161\u1E67\u1E63\u1E69\u0219\u015F\u023F\uA7A9\uA785\u1E9B]/g},{base:"t",letters:/[\u0074\u24E3\uFF54\u1E6B\u1E97\u0165\u1E6D\u021B\u0163\u1E71\u1E6F\u0167\u01AD\u0288\u2C66\uA787]/g},{base:"tz",letters:/[\uA729]/g},{base:"u",letters:/[\u0075\u24E4\uFF55\u00F9\u00FA\u00FB\u0169\u1E79\u016B\u1E7B\u016D\u00FC\u01DC\u01D8\u01D6\u01DA\u1EE7\u016F\u0171\u01D4\u0215\u0217\u01B0\u1EEB\u1EE9\u1EEF\u1EED\u1EF1\u1EE5\u1E73\u0173\u1E77\u1E75\u0289]/g},{base:"v",letters:/[\u0076\u24E5\uFF56\u1E7D\u1E7F\u028B\uA75F\u028C]/g},{base:"vy",letters:/[\uA761]/g},{base:"w",letters:/[\u0077\u24E6\uFF57\u1E81\u1E83\u0175\u1E87\u1E85\u1E98\u1E89\u2C73]/g},{base:"x",letters:/[\u0078\u24E7\uFF58\u1E8B\u1E8D]/g},{base:"y",letters:/[\u0079\u24E8\uFF59\u1EF3\u00FD\u0177\u1EF9\u0233\u1E8F\u00FF\u1EF7\u1E99\u1EF5\u01B4\u024F\u1EFF]/g},{base:"z",letters:/[\u007A\u24E9\uFF5A\u017A\u1E91\u017C\u017E\u1E93\u1E95\u01B6\u0225\u0240\u2C6C\uA763]/g}];for(var e=0;e<E.length;e++)u=u.replace(E[e].letters,E[e].base);return u};
*/

function generateGlobalAssCSV(){
	const csvContentType = "data:text/csv;charset=utf-8,";
  let csvContent = "";
  const SEP_ = ","

	let dataString = "Étudiant" + SEP_ + "Status" + SEP_ + "Jour" + SEP_ + "Date du cours" + SEP_  + "Débute" + SEP_ + "Classe" + SEP_ + "Détail du cours" + SEP_ + "\n";
	csvContent += dataString;
	for(var i=0; i<dataTagToJsonArrayReport.length; i++){
		// dataString = removeDiacritics(dataTagToJsonArrayReport[i].NAME) + SEP_ + removeDiacritics(dataTagToJsonArrayReport[i].STATUS) + SEP_ + removeDiacritics(dataTagToJsonArrayReport[i].JOUR) + SEP_ +  removeDiacritics(dataTagToJsonArrayReport[i].COURS_DATE) + SEP_ +  removeDiacritics(dataTagToJsonArray[i].DEBUT_COURS) + SEP_ + removeDiacritics(dataTagToJsonArray[i].CLASSE) + SEP_ + removeDiacritics(dataTagToJsonArray[i].COURS_DETAILS) + SEP_ ;
    dataString = dataTagToJsonArrayReport[i].NAME + SEP_ + dataTagToJsonArrayReport[i].STATUS + SEP_ + dataTagToJsonArrayReport[i].JOUR + SEP_ +  dataTagToJsonArrayReport[i].COURS_DATE + SEP_ +  dataTagToJsonArrayReport[i].DEBUT_COURS + SEP_ + dataTagToJsonArrayReport[i].CLASSE + SEP_ + dataTagToJsonArrayReport[i].COURS_DETAILS + SEP_ ;
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
