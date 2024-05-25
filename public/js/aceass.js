function initGraShortCut(){
    $("#scmenu-gra").click(function() {
      document.getElementById('anchor-gra').scrollIntoView({
        behavior: 'smooth'
      });
    });
}
function doesPaymentLateExist(){
  let isLate = false;
  if(dataSumPerTrancheToJsonArray != null){
    for(let i=0; i<dataSumPerTrancheToJsonArray.length; i++){
      // If we have something to pay (greater than zero) and late then we are late
      if((parseInt(dataSumPerTrancheToJsonArray[i].REST_TO_PAY) > 0) 
              && (dataSumPerTrancheToJsonArray[i].NEGATIVE_IS_LATE < 0)){
              return true
      }
    }
  }
  else{
    // If there is no payment then we display note
    isLate = false;
  }
  return isLate;
}
function loadGraGrid(){
  let refGraField;

  if(window.screen.availWidth < 1100){
    refGraField = [
          { name: "URS_TITLE",
            title: "Élément constitutif",
            type: "text",
            align: "left",
            headercss: "cell-ref-sm-hd",
            css: "cell-ref-xs",
            itemTemplate: function(value, item) {
                return value.substring(0, 25);
            }
          },
          { name: "UGG_GRADE",
            title: "Note",
            type: "number",
            width: 40,
            align: "right",
            headercss: "cell-ref-sm-hd",
            css: "cell-ref-xs",
            itemTemplate: function(value, item) {
              if(value == 'X'){
                return 'En cours';
              }
              else if(value == 'A'){
                return 'Absent(e)';
              }
              else if(value == 'E'){
                  return 'Excusé(e)';
              }
              else{
                if(parseFloat(value) < 7){
                  return "<i class='recap-mis'>" + value  + "</i>";
                }
                else if(parseFloat(value) < 10){
                  return "<i class='recap-qui'>" + value  + "</i>";
                }
                else{
                  return "<i class='recap-val'>" + value  + "</i>";
                }
              }
            }
          }
      ];
  }
  else{
    refGraField = [
                { name: "URS_TITLE",
                  title: "Élément constitutif",
                  type: "text",
                  align: "left",
                  headercss: "cell-ref-sm-hd",
                  css: "cell-ref-xs",
                  itemTemplate: function(value, item) {
                      return value.substring(0, 25);
                  }
                },
                { name: "UGG_GRADE",
                  title: "Note",
                  type: "number",
                  width: 30,
                  align: "right",
                  headercss: "cell-ref-sm-hd",
                  css: "cell-ref-xs",
                  itemTemplate: function(value, item) {
                    if(value == 'X'){
                      return 'En cours';
                    }
                    else if(value == 'A'){
                      return 'Absent(e)';
                    }
                    else if(value == 'E'){
                        return 'Excusé(e)';
                    }
                    else{
                      if(parseFloat(value) < 7){
                        return "<i class='recap-mis'>" + value  + "</i>";
                      }
                      else if(parseFloat(value) < 10){
                        return "<i class='recap-qui'>" + value  + "</i>";
                      }
                      else{
                        return "<i class='recap-val'>" + value  + "</i>";
                      }
                    }
                  }
                },
                { name: "UGM_DATE",
                  title: "Date",
                  type: "number",
                  width: 40,
                  align: "center",
                  headercss: "cell-ref-sm-hd",
                  css: "cell-ref-xs"
                },
                { name: "UGM_NIV_SEM",
                  title: "Niveau",
                  type: "text",
                  width: 20,
                  align: "right",
                  headercss: "cell-ref-sm-hd",
                  css: "cell-ref-xs"
                },
                { name: "UGG_AVG",
                  title: "Moy. classe",
                  type: "number",
                  width: 25,
                  align: "right",
                  headercss: "cell-ref-sm-hd",
                  css: "cell-ref-xs"
                }
      ];
  }

  $("#jsGridStuGrade").jsGrid({
      height: "auto",
      width: "100%",
      noDataContent: "Aucune note disponible",
      pageIndex: 1,
      pageSize: 50,
      pagePrevText: "Prec",
      pageNextText: "Suiv",
      pageFirstText: "Prem",
      pageLastText: "Dern",

      sorting: true,
      paging: true,
      data: dataAllGradeToJsonArray,
      fields: refGraField 
  });
}


function loadHistoPayGrid(){
  let refHistoPayField;

  if(window.screen.availWidth < 1100){
      refHistoPayField = [
          { name: "REF_TITLE",
            title: "Desc.",
            type: "text",
            width: 65,
            headercss: "cell-ref-sm-hd",
            css: "cell-ref-xs",
            itemTemplate: function(value, item) {
                if(item.UP_STATUS == 'N'){
                    return '<i class="recap-mis">' + value + '</i>';
                }
                else{
                  return value;
                }
              }
          },
          { name: "UP_INPUT_AMOUNT",
            title: "Payé",
            type: "text",
            width: 60,
            align: "right",
            headercss: "cell-ref-sm-hd",
            css: "cell-ref-xs",
            itemTemplate: function(value, item) {
              if(value == null){
                return renderAmount('0');
              }
              else{
                return renderAmount(value);
              }
            }
          },
          { name: "UP_TYPE_OF_PAYMENT",
            title: "T",
            type: "text",
            width: 10,
            headercss: "cell-ref-sm-hd",
            css: "cell-ref-xs"
          },
          { name: "UP_PAY_DATE_READ",
            title: "Date",
            type: "text",
            width: 60,
            headercss: "cell-ref-sm-hd",
            css: "cell-ref-xs",
            itemTemplate: function(value, item) {
              if(value == null){
                return 'Attente';
              }
              else{
                return value;
              }
            }
          }
      ];
  }
  else{
    refHistoPayField = [
          { name: "REF_TITLE",
            title: "Description",
            type: "text",
            width: 70,
            headercss: "cell-ref-sm-hd",
            css: "cell-ref-xs"
          },
          { name: "UP_PAYMENT_REF",
            title: "Ticket",
            type: "text",
            width: 50,
            headercss: "cell-ref-sm-hd",
            css: "cell-ref-sm-mono",
            itemTemplate: function(value, item) {
              if(value == null){
                return 'MANQUANT';
              }
              else{
                return value;
              }
            }
          },
          { 
          name: "UP_STATUS",
          title: "Status",
          type: "text",
          width: 40,
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-xs",
          itemTemplate: function(value, item) {
              if(value == 'P'){
                return '<i class="status-ok">Payé</i>';
              }
              else if(value == 'N'){
                  return '<i class="recap-mis">Non payé</i>';
              }
              else if(value == 'E'){
                  return '<i class="recap-ok">Dispensé</i>';
              }
              else{
                return '<i class="recap-mis">Annulé</i>';
              }
            }
          },
          { name: "UP_INPUT_AMOUNT",
            title: "Payé",
            type: "text",
            width: 60,
            align: "right",
            headercss: "cell-ref-sm-hd",
            css: "cell-ref-xs",
            itemTemplate: function(value, item) {
              if(value == null){
                return renderAmount('0');
              }
              else{
                return renderAmount(value);
              }
            }
          },
          { name: "UP_PAY_DATE_READ",
            title: "Date paiement",
            type: "text",
            width: 60,
            headercss: "cell-ref-sm-hd",
            css: "cell-ref-xs",
            itemTemplate: function(value, item) {
              if(value == null){
                return 'Attente';
              }
              else{
                return value;
              }
            }
          },
          { name: "UP_TYPE_OF_PAYMENT",
            title: "Type",
            type: "text",
            width: 40,
            headercss: "cell-ref-sm-hd",
            css: "cell-ref-xs",
            itemTemplate: function(value, item) {
              if(value == null){
                return 'NA';
              }
              else if(value == 'C'){
                return 'Cash';
              }
              else if(value == 'H'){
                  return 'Chèque';
              }
              else if(value == 'T'){
                  return 'Virement/TPE';
              }
              else if(value == 'M'){
                  return 'Mvola';
              }
              else if(value == 'R'){
                  return 'Réduction';
              }
              else if(value == 'L'){
                  return 'L.E.';
              }
              else if(value == 'E'){
                  return 'Exemption';
              }
              else{
                return 'Erreur 862B';
              }
            }
          },
          { name: "REF_AMOUNT",
            title: "Ref.",
            type: "text",
            width: 50,
            align: "right",
            headercss: "cell-ref-sm-hd",
            css: "cell-ref-xs",
            itemTemplate: function(value, item) {
              if(value == null){
                return '<span class="ref-amt">' + renderAmount('0') + '</span>';
              }
              else{
                return '<span class="ref-amt">' + renderAmount(value)+ '</span>';
              }
            }
          },
          { name: "UP_COMMENT",
            title: "Commentaire",
            type: "number",
            align: "right",
            headercss: "cell-ref-sm-hd",
            css: "cell-ref-xs"
          }
      ];
  }

  $("#jsGridHisto").jsGrid({
      height: "auto",
      width: "100%",
      noDataContent: "Aucun paiement disponible ERR893PS",
      pageIndex: 1,
      pageSize: 50,
      pagePrevText: "Prec",
      pageNextText: "Suiv",
      pageFirstText: "Prem",
      pageLastText: "Dern",

      sorting: true,
      paging: true,
      data: dataHistoPayToJsonArray,
      fields: refHistoPayField 
  });
}


function loadSumUpGrid(){
  let refSumUpField;

  if(window.screen.availWidth < 1100){
        refSumUpField = [
          { name: "DESCRIPTION",
            title: "Tranche",
            type: "text",
            width: 65,
            headercss: "cell-ref-sm-hd",
            css: "cell-ref-sm"
          },
          { name: "REST_TO_PAY",
            title: "Reste à payer",
            type: "text",
            width: 50,
            align: "right",
            headercss: "cell-ref-sm-hd",
            css: "cell-ref-sm",
            itemTemplate: function(value, item) {
              return renderAmount(value);
            }
          },
          { name: "NEGATIVE_IS_LATE",
            title: "Status",
            type: "text",
            width: 40,
            headercss: "cell-ref-sm-hd",
            css: "cell-ref-sm",
            itemTemplate: function(value, item) {
              if(parseInt(item.REST_TO_PAY) > 0){
                  if(parseInt(value) < 0){
                    return '<i class="recap-mis">Retard ' + item.TRANCHE_DDL + '</i>';
                  }
                  else{
                    return '<i class="status-ok">Attente ' + item.TRANCHE_DDL + '</i>';
                  }
              }
              else{
                return '<i class="status-ok">Payé</i>';
              }
            }
          }
      ];

  }
  else{
        refSumUpField = [
          { name: "DESCRIPTION",
            title: "Tranche",
            type: "text",
            width: 65,
            headercss: "cell-ref-sm-hd",
            css: "cell-ref-sm"
          },
          { name: "TRANCHE_CODE",
            title: "Code",
            type: "text",
            width: 35,
            headercss: "cell-ref-sm-hd",
            css: "cell-ref-sm-mono"
          },
          { name: "TRANCHE_AMOUNT",
            title: "Ref.",
            type: "text",
            width: 50,
            align: "right",
            headercss: "cell-ref-sm-hd",
            css: "cell-ref-sm",
            itemTemplate: function(value, item) {
              return '<span class="ref-amt">' + renderAmount(value) + '</span>';
            }
          },
          { name: "ALREADY_PAID",
            title: "Déjà payé",
            type: "text",
            width: 50,
            align: "right",
            headercss: "cell-ref-sm-hd",
            css: "cell-ref-sm",
            itemTemplate: function(value, item) {
              return renderAmount(value);
            }
          },
          { name: "REST_TO_PAY",
            title: "Reste à payer",
            type: "text",
            width: 50,
            align: "right",
            headercss: "cell-ref-sm-hd",
            css: "cell-ref-sm",
            itemTemplate: function(value, item) {
              return renderAmount(value);
            }
          },
          { name: "TRANCHE_DDL",
            title: "Limite",
            type: "text",
            width: 40,
            headercss: "cell-ref-sm-hd",
            css: "cell-ref-sm"
          },
          { name: "NEGATIVE_IS_LATE",
            title: "Status",
            type: "text",
            width: 40,
            headercss: "cell-ref-sm-hd",
            css: "cell-ref-sm",
            itemTemplate: function(value, item) {
              if(parseInt(item.REST_TO_PAY) > 0){
                  if(parseInt(value) < 0){
                    return '<i class="recap-mis">en retard</i>';
                  }
                  else{
                    return '<i class="status-ok">En attente</i>';
                  }
              }
              else{
                return '<i class="status-ok">Payé</i>';
              }
            }
          },
          { name: "COMMITMENT_LETTER",
            title: "L.E.",
            type: "text",
            width: 30,
            headercss: "cell-ref-sm-hd",
            css: "cell-ref-sm",
            itemTemplate: function(value, item) {
              if(parseInt(item.REST_TO_PAY) > 0){
                    if((parseInt(item.NEGATIVE_IS_LATE) < 0) && (value != 'N')){
                      return '<i class="status-ok">Oui</i>';
                    }
                    else if (parseInt(item.NEGATIVE_IS_LATE) < 0){
                      return '<i class="recap-mis">Non</i>';
                    }
                    else{
                      return '';
                    }
              }
              else{
                return 'NA';
              }
            }
          }
      ];
  }

  $("#jsGridSumPerTranche").jsGrid({
      height: "auto",
      width: "100%",
      noDataContent: "Aucun paiement disponible ERR893PS",
      pageIndex: 1,
      pageSize: 50,
      pagePrevText: "Prec",
      pageNextText: "Suiv",
      pageFirstText: "Prem",
      pageLastText: "Dern",

      sorting: true,
      paging: true,
      data: dataSumPerTrancheToJsonArray,
      fields: refSumUpField 
  });
}




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

function verifyExistAndFDS(param){
  let foundParam = 'N';
  for(let i=0; i<DATA_STU_PAY_SUMUPJsonArray.length; i++){
    if(DATA_STU_PAY_SUMUPJsonArray[i].RES_USN == param){
      //We found so we went out
      if(parseInt(DATA_STU_PAY_SUMUPJsonArray[i].RES_SCRTP) > 0){
        return 'L';
      }
      else{
        return 'P';
      }
    }
  }
  return foundParam;
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

    let scanOrderToCheck = ' <i class="mgs-rd-o-err msg-rd-basic">&nbsp;ERR90&nbsp;</i>';
    if(/[a-zA-Z0-9]{9}[0-9]/.test(readInput)){
      // Only if the read is clean
      // Here we do a check to know if the readInput is foundable and has paid.
      // N is Not found; P is FDS paid; L is Late
      let dispExistFDS = verifyExistAndFDS(readInput);
      if(dispExistFDS == 'P'){
        // On time
        if(($('#mg-graph-identifier').text() == 'ua-scan-in')){
          scanOrderToCheck = ' <span class="mgs-rd-o-in msg-rd-basic">&nbsp;Entrée&nbsp;<span class="icon-check-square icon-light"></span></span>';
        }
        else{
          scanOrderToCheck = ' <span class="mgs-rd-o-out msg-rd-basic">&nbsp;Sortie&nbsp;<span class="icon-check-square icon-light"></span></span>';
        }

      }
      else if(dispExistFDS == 'L'){
        // LATE
        if(($('#mg-graph-identifier').text() == 'ua-scan-in')){
          scanOrderToCheck = ' <span class="mgs-rd-late msg-rd-basic">&nbsp;Entrée&nbsp;<span class="icon-exclamation-triangle icon-light"></span>&nbsp;FDS</span>';
        }
        else{
          scanOrderToCheck = ' <span class="mgs-rd-late msg-rd-basic">&nbsp;Sortie&nbsp;<span class="icon-exclamation-triangle icon-light"></span>&nbsp;FDS</span>';
        }

      }
      else{
        scanOrderToCheck = ' <span class="mgs-rd-o-err msg-rd-basic">&nbsp;Introuvable&nbsp;</span>';
      }
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
            let dayEn = item.LABEL_DAY_EN.substring(0, 2);
            switch(dayEn) {
              case 'MO':
                return  'LUN' + ' ' + value;
              case 'TU':
                return  'MAR' + ' ' + value;
              case 'WE':
                return  'MER' + ' ' + value;
              case 'TH':
                return  'JEU' + ' ' + value;
              case 'FR':
                return  'VEN' + ' ' + value;
              case 'SA':
                return  'SAM' + ' ' + value;
              default:
                return  'DIM' + ' ' + value;
            }
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
            if(item.TECH_DEBUT_HALF == '30'){
              return (value.toString().length == 1) ? ('0' + value + 'h30') : (value + 'h30');
            }
            else{
              return (value.toString().length == 1) ? ('0' + value + 'h00') : (value + 'h00');
            }
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
            else if(value == 'VLA'){
              val = '<i class="recap-vla">Très en retard</i>';
            }
            else if(value == 'ABS'){
              val = '<i class="recap-mis">Absent(e)</i>';
            }
            else if(value == 'QUI'){
              val = '<i class="recap-qui">Qav.</i>';
            }
            else if(value == 'NEX'){
              val = '<i class="recap-nex"><i class="icon-exclamation-triangle nav-text"></i>&nbsp;Sortie</i>';
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
      noDataContent: "Aucun scan d'entrée/sortie enregistré",
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

  responsivefieldsStat = [
      { name: "ASS_STATUS",
        title: 'Categorie',
        type: "text",
        align: "center",
        css: "cell-recap",
        headercss: "cell-recap-hd",
        itemTemplate: function(value, item) {
          let val = '';
          if(value == 'LAT'){
            val = '<i class="recap-lat">Retard</i>';
          }
          else if(value == 'VLA'){
            val = '<i class="recap-vla">Très en retard</i>';
          }
          else if(value == 'ABS'){
            val = '<i class="recap-mis">Absent(e)</i>';
          }
          else if(value == 'QUI'){
            val = '<i class="recap-qui">Qav.</i>';
          }
          else if(value == 'NEX'){
            val = '<i class="recap-nex"><i class="icon-exclamation-triangle nav-text"></i>&nbsp;Sortie</i>';
          }
          else if(value == 'JUS'){
            val = 'Justifié';
          }
          else{
            val = '<strong>ERR1283S<strong>';
          }
          return val;
        }
      },
      //Default width is auto
      { name: "STU_COUNT",
        title: "Étudiant",
        type: "text",
        width: 80,
        align: "center",
        headercss: "cell-recap-hd",
        css: "cell-recap",
        itemTemplate: function(value, item){
          let val = '';
          if(parseFloat(value) > parseFloat(item.ASS_AVG)){
            val = '<i class="recap-mis">' + value + '</i>';
          }
          else{
            val = '<i class="recap-val">' + value + '</i>';
          }
          return val;
        }
      },
      //Default width is auto
      { name: "ASS_AVG",
        title: 'Moyenne classe',
        type: "text",
        width: 85,
        align: "center",
        headercss: "cell-recap-hd",
        css: "cell-recap"
      }
  ];

  $("#jsGridStatAss").jsGrid({
      height: "auto",
      width: "100%",
      noDataContent: "Aucune statistique",
      pageIndex: 1,
      pageSize: 5,
      pagerFormat: "Pages: {first} {prev} {pages} {next} {last}    {pageIndex} sur {pageCount}",
      pagePrevText: "Prec",
      pageNextText: "Suiv",
      pageFirstText: "Prem",
      pageLastText: "Dern",
      sorting: true,
      paging: true,
      data: dataTagToJsonArrayStat,
      fields: responsivefieldsStat
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

function copyEDTS0(){
  $('#title-copy-paste').html('<i class="icon-calendar nav-text"></i>&nbsp;S0 : EDT de la semaine courante');
  let greetingMsg = "Bonjour, voici les emploi du temps de la semaine courante :<br>" + dashRapMsg + "<br>";
  $('#copy-paste-txt').html(greetingMsg + textWarningS0 + '<br>' + textS0 + endMsg);
  $('#copy-paste-modal').modal('show');
}

function copyEDTS1(){
  $('#title-copy-paste').html('<i class="icon-calendar nav-text"></i>&nbsp;S1 : EDT de la semaine prochaine');
  let greetingMsg = "Bonjour, voici les emploi du temps de la semaine prochaine :<br>" + dashRapMsg + "<br>";
  $('#copy-paste-txt').html(greetingMsg + textWarningS1 + '<br>' + textS1 + endMsg);
  $('#copy-paste-modal').modal('show');
}

function copyEDTD(){
  $('#title-copy-paste').html("<i class='icon-calendar nav-text'></i>&nbsp;Modification EDT d'aujourd'hui");
  if(textDToJsonArray.length > 0){
    let greetingMsg = "Bonjour, voici les dernières modifications d'emploi du temps. Annule et remplace les précédentes de la même [classe + semaine], veuillez nous excuser pour la gêne occasionnée :<br>" + dashRapMsg + "<br>";
    $('#copy-paste-txt').html(greetingMsg + textD + endMsg);
  }
  else{
    $('#copy-paste-txt').html(emptyMsg);
  }
  $('#copy-paste-modal').modal('show');
}

function initWarningEDT(){
  textWarningS0 = '';
  textWarningS1 = '';
  const introM = '[Manquant]&nbsp;';
  const introE = '[Pas de cours]&nbsp;';
  const separatorWarn = '<br>';
  let headerS0 = null;
  let headerS1 = null;
  for(let i=0; i<textWarnToJsonArray.length; i++){
    if(textWarnToJsonArray[i].inv_s == 'S0'){
      if(headerS0 == null){
        let mondayDateS0 = new Date(textWarnToJsonArray[i].monday_ofthew);
        headerS0 = 'Semaine du lundi : ' + new Intl.DateTimeFormat('fr-FR').format(mondayDateS0) + '<br><br>';
      }
      if(textWarnToJsonArray[i].status == 'M'){
        textWarningS0 = textWarningS0 + introM + textWarnToJsonArray[i].vcc_short_classe + separatorWarn;
      }
      else{
        textWarningS0 = textWarningS0 + introE + textWarnToJsonArray[i].vcc_short_classe + separatorWarn;
      }
    }
    else{
      if(headerS1 == null){
        let mondayDateS1 = new Date(textWarnToJsonArray[i].monday_ofthew);
        headerS1 = 'Semaine du lundi : ' + new Intl.DateTimeFormat('fr-FR').format(mondayDateS1) + '<br><br>';
      }
      if(textWarnToJsonArray[i].status == 'M'){
        textWarningS1 = textWarningS1 + introM + textWarnToJsonArray[i].vcc_short_classe  + separatorWarn;
      }
      else{
        textWarningS1 = textWarningS1 + introE + textWarnToJsonArray[i].vcc_short_classe + separatorWarn;
      }
    }
  }
  // We add the hearder only if we have data
  if(textWarningS0.length  > 0){
    textWarningS0 = headerS0 + textWarningS0;
  }
  // We add the hearder only if we have data
  if(textWarningS1.length  > 0){
    textWarningS1 = headerS1 + textWarningS1;
  }
}

function initTextExport(jsonArray){
  let invClasse = 0;
  const cReturn = '<br>';
  const smbreakClasse = '--' + cReturn;
  const breakClasse = '---------------------------------';
  let text = '';
  
  for(let i=0; i<jsonArray.length; i++){
    //console.log('in initTextExport');
    if(parseInt(invClasse) !== parseInt(jsonArray[i].cohort_id)){
      if(i>0){
        text = text + cReturn;
      }
      invClasse = jsonArray[i].cohort_id;
      text = text + breakClasse + cReturn + jsonArray[i].short_classe  + ' - ' + jsonArray[i].master_title + cReturn;
      text = text + breakClasse + cReturn;
    }
    text = text + jsonArray[i].label_day_fr + ' - ' + jsonArray[i].nday + ' début: ' + jsonArray[i].uel_start_time + ' fin: ' + jsonArray[i].uel_end_time  + cReturn;
    switch(jsonArray[i].course_status) {
      case 'A':
        // Do nothing
        break;
      case 'C':
        text = text + '[ATTENTION] ANNULÉ ';
        break;
      case 'M':
        text = text + '[ATTENTION] ANNULÉ PROF ABSENT ';
        break;
      case 'O':
        text = text + '[Optionnel] ';
        break;
      default:
        text = text + '[Hors site Manakambahiny] ';
    }
    text = text + jsonArray[i].raw_course_title + cReturn;
    text = text + 'Salle : ' + jsonArray[i].urr_name + cReturn;
    if(parseInt(jsonArray[i].teacher_id) !== '0'){
      text = text + jsonArray[i].teacher_name;
    }
    text = text + cReturn + smbreakClasse;
  }
  return text;
}

/*****************************************************************************************/
/*****************************************************************************************/
/*****************************************************************************************/
/************************** START FILTER FUNTION *****************************************/
/*****************************************************************************************/
/*****************************************************************************************/
/*****************************************************************************************/

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


/*****************************************************************************************/
/*****************************************************************************************/
/*****************************************************************************************/
/**************************  END FILTER FUNTION  *****************************************/
/*****************************************************************************************/
/*****************************************************************************************/
/*****************************************************************************************/

function loadAllEDTGrid(){


      allEDTfields = [
        { name: "s",
          title: 'S#',
          type: "text",
          align: "center",
          width: 15,
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
          title: "Classe",
          type: "text",
          width: 15,
          headercss: "cell-recap-hd",
          css: "cell-recap-l"
        },
        //Default width is auto
        { name: "mention",
          title: "Mention",
          type: "text",
          width: 75,
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
          width: 28,
          headercss: "cell-recap-hd",
          css: "cell-recap-l"
        },
        //Default width is auto
        { name: "last_update",
          title: "Maj",
          type: "text",
          width: 20,
          headercss: "cell-recap-hd",
          css: "cell-recap-l"
        },
        //Default width is auto
        { name: "uem_jq_edt_type",
          title: "Type",
          type: "text",
          width: 10,
          headercss: "cell-recap-hd",
          css: "cell-recap-m",
          itemTemplate: function(value, item) {
            let val = '';
            if((item.master_id == '') || (item.master_id == null)){
              // do nothing
            }
            else{
                if(value == 'N'){
                  val = '<span class="icon-file-excel-o nav-icon-fa-sm nav-text"></span>';
                }
                else{
                  val = '<span class="icon-pencil-square-o nav-icon-fa-sm nav-text"></span>';
                }
            }
            return val;
          }
        },
        //Default width is auto
        { name: "uem_visibility",
          title: "Status",
          type: "text",
          width: 20,
          headercss: "cell-recap-hd",
          css: "cell-recap-m",
          itemTemplate: function(value, item) {
            let val = '';
            if((item.master_id == '') || (item.master_id == null)){
              // do nothing
            }
            else{
                if(value == 'V'){
                  val = '<span class="icon-paper-plane-o nav-icon-fa-sm nav-text"></span>';
                }
                else{
                  val = '<span class="icon-floppy-o nav-icon-fa-sm nav-text"></span>';
                }
            }
            return val;
          }
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
                goToEDT(args.item.master_id, args.item.uem_jq_edt_type);
              }
          }
    });
}

function goToEDT(masterId, jqEDTType){
  $("#read-master-id").val(masterId);
  $("#read-jq-type").val(jqEDTType);

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


  let ctxClient = document.getElementById('statPieLate');
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


  let ctxClientBarMis = document.getElementById('statBarMis');
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
      { name: "CLASSE",
        title: 'Classe',
        type: "text",
        align: "center",
        width: 65,
        css: "cell-recap",
        headercss: "cell-recap-hd"
      },
      { name: "NAME",
        title: 'Étudiant',
        type: "text",
        align: "left",
        css: "cell-recap",
        headercss: "cell-recap-hd",
        itemTemplate: function(value, item) {
          return value.substring(0, 25);
        }
      },
      //Default width is auto
      { name: "VAL",
        title: "Absence",
        type: "text",
        align: "center",
        width: 25,
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
        fields: responsivefieldsPP,
        // args are item - itemIndex - event
        rowClick: function(args){
              //goToSTU(args.item.PAGE);
              //console.log('You click on jsGrid: ' + args.item.PAGE);
              goToSTUFromDashAssiduite(args.item.PAGE);
          }
    });
    // After the grid
    //refreshListener();
  }
  else{
    $("#jsGrid").hide();
  }
}

// goToSTUFromDashAssiduite(args.item.PAGE);
function goToSTUFromDashAssiduite(page){
  $("#read-stu-page").val(page);
  $("#mg-stu-page-form").submit();
}

function generateGlobalAssCSV(){
	const csvContentType = "data:text/csv;charset=utf-8,";
  let csvContent = "";
  const SEP_ = ";"

	let dataString = "Username" + SEP_ + "Matricule" + SEP_ + "Etudiant" + SEP_ + "Status" + SEP_ + "Jour" + SEP_ + "Date du cours" + SEP_  + "Debute" + SEP_ + "Classe" + SEP_ + "Detail du cours" + SEP_ + "\n";
	csvContent += dataString;
	for(var i=0; i<dataTagToJsonArrayReport.length; i++){
		// dataString = removeDiacritics(dataTagToJsonArrayReport[i].NAME) + SEP_ + removeDiacritics(dataTagToJsonArrayReport[i].STATUS) + SEP_ + removeDiacritics(dataTagToJsonArrayReport[i].JOUR) + SEP_ +  removeDiacritics(dataTagToJsonArrayReport[i].COURS_DATE) + SEP_ +  removeDiacritics(dataTagToJsonArray[i].DEBUT_COURS) + SEP_ + removeDiacritics(dataTagToJsonArray[i].CLASSE) + SEP_ + removeDiacritics(dataTagToJsonArray[i].COURS_DETAILS) + SEP_ ;
    dataString = dataTagToJsonArrayReport[i].USERNAME + SEP_ + dataTagToJsonArrayReport[i].MATRICULE + SEP_ + dataTagToJsonArrayReport[i].NAME + SEP_ + dataTagToJsonArrayReport[i].STATUS + SEP_ + dataTagToJsonArrayReport[i].JOUR + SEP_ +  dataTagToJsonArrayReport[i].COURS_DATE + SEP_ +  dataTagToJsonArrayReport[i].DEBUT_COURS + SEP_ + dataTagToJsonArrayReport[i].CLASSE + SEP_ + dataTagToJsonArrayReport[i].COURS_DETAILS + SEP_ ;
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
  link.download = 'RapportGlobalAssiduite9j_' + getReportACEDateStrFR(0).replaceAll('/', '_') + '.csv';
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
}

/*
function generateGlobalPsdXLS_todelete(){
  
  var wb = XLSX.utils.table_to_book(document.getElementById('my-main-table'));
  XLSX.writeFile(wb, 'EDT' + invMondayStr.replaceAll('-', '_') + tempClasse.replaceAll(' ', '_').replaceAll('/', '_') + '.xlsx');
  var wb_sans_sheets = XLSX.utils.book_new();
  var wb_with_sheet_named_Blatte = XLSX.utils.book_new(worksheet, "Blatte");

  See https://redstapler.co/sheetjs-tutorial-create-xlsx/
  */

  /*
  // This is working
  var wb = XLSX.utils.book_new();
  wb.Props = { Title: "Rapport Hebdomadaire",
                Subject: "Absence UACEEM",
                Author: "UACEEM",
                CreatedDate: new Date(2018, 12, 19)};
  wb.SheetNames.push("Sheet1");
  var ws_data = [['hello', 'world']];
  var ws = XLSX.utils.aoa_to_sheet(ws_data);
  wb.Sheets["Sheet1"] = ws;

  XLSX.writeFile(wb, 'test.xlsx');

  
  const DEF_Size14Vert = { font: { sz: 14 }, alignment: { vertical: 'center', horizontal: 'center' } };
  const DEF_ColW = 30;
	const DEF_RowH = 60;
  
  const wb = XLSX.utils.book_new();
  // STEP 2: Create data rows and styles
  let row = [
    { v: "This is courrier 24", t: "s", s: { font: { name: "Courier", sz: 24 }, alignment: { wrapText: true}, border: { bottom: { style: "thin", color: {rgb: "FFCC00"} } } } },
    { v: "bold & color", t: "s", s: { font: { bold: true, color: { rgb: "FF0000" } } } },
    { v: 'javascript', t: 's', s: { ...DEF_Size14Vert, fill: { fgColor: { rgb: 'ff5900' } }, font: { sz: 18, color: { rgb: 'f1f1f1' } } } },
    { v: "fill: color", t: "s", s: { fill: { fgColor: { rgb: "E9E9E9" } } } },
    { v: "line\nbreak", t: "s", s: { alignment: { wrapText: true } } }
  ];

  // STEP 3: Create worksheet with rows; Add worksheet to workbook
  const ws = XLSX.utils.aoa_to_sheet([row]);
  ws['!cols'] = [{ width: DEF_ColW }, { width: DEF_ColW }, { width: DEF_ColW }, { width: DEF_ColW }, { width: DEF_ColW }];
  ws['!rows'] = [{ 'hpt': DEF_RowH }];

  XLSX.utils.book_append_sheet(wb, ws, "readme demo");

  // STEP 4: Write Excel file to browser
  XLSX.writeFile(wb, "RapportAbsence7j.xlsx");
  
}
*/

function generateGlobalPsdXLSWorksheet(paramLines, paramIsGlobalSheet){
  //const DEF_COL_DFT = 30;
  /*
	const DEF_ROW_DFT = 20;

  const DEF_HEADER_CARTOUCHE = { font: { sz: 8, name: 'Arial' }, alignment: { vertical: 'center', horizontal: 'left' } };
  const DEF_FOOTER_CARTOUCHE = { font: { sz: 6, name: 'Arial' }, alignment: { vertical: 'center', horizontal: 'left' } };
  
  const DEF_ROW_DFT_SETUP = { 'hpt': DEF_ROW_DFT };
  const DEF_CELL_HEADER_FILL = { fgColor: { rgb: 'EDECFF' } };
  const DEF_CELL_HEADER_HEAVY_FILL = { fgColor: { rgb: '1C1C1C' } };
  const DEF_CELL_ODD_FILL = { fgColor: { rgb: 'F4F7FF' } };
  const DEF_CELL_BORDER = { top: { style: "thin", color: {rgb: "383838"} },
                            bottom: { style: "thin", color: {rgb: "383838"} },
                            left: { style: "thin", color: {rgb: "383838"} },
                            right: { style: "thin", color: {rgb: "383838"} }
                          };

  const DEF_EMPTY_CELL = { font: { sz: 8, name: 'Arial' }};
  const DEF_HEADER_CELL_HEAVY = { font: { sz: 8, name: 'Arial', bold: true, color: {rgb: "FFFFFF"} }, alignment: { wrapText: true, vertical: 'center', horizontal: 'center' }, border: {...DEF_CELL_BORDER}, fill: {...DEF_CELL_HEADER_HEAVY_FILL} };
  const DEF_HEADER_CELL = { font: { sz: 8, name: 'Arial' }, alignment: { wrapText: true, vertical: 'center', horizontal: 'center' }, border: {...DEF_CELL_BORDER}, fill: {...DEF_CELL_HEADER_FILL} };
  const DEF_CELL = { font: { sz: 7, name: 'Arial' }, alignment: { wrapText: true, vertical: 'center', horizontal: 'center' }, border: {...DEF_CELL_BORDER} };
  const DEF_CELL_ODD = { font: { sz: 7, name: 'Arial' }, alignment: { wrapText: true, vertical: 'center', horizontal: 'center' }, border: {...DEF_CELL_BORDER}, fill: {...DEF_CELL_ODD_FILL} };
  const DEF_CELL_MONO = { font: { sz: 7, name: 'Courier New', bold: true }, alignment: { wrapText: true, vertical: 'center', horizontal: 'center' }, border: {...DEF_CELL_BORDER} };
  */

  

  //************************ START HEADER ************************
  
  let rowHeader1 = [
    { v: 'A', t: 's', s: { ...DEF_HEADER_CARTOUCHE_LOGO } },
    { v: 'UNIVERSITÉ ACEEM', t: 's', s: { ...DEF_HEADER_CARTOUCHE } }
  ];
  
  let rowHeader2 = [
    { v: 'MANAKAMBAHINY', t: 's', s: { ...DEF_HEADER_CARTOUCHE } }
  ];
  let rowHeader3 = [
    { v: 'Service scolarité', t: 's', s: { ...DEF_HEADER_CARTOUCHE } }
  ];
  let rowHeader4 = [
    { v: 'Version papier', t: 's', s: { ...DEF_HEADER_CARTOUCHE } },
    { v: '', t: 's', s: { ...DEF_HEADER_CARTOUCHE } },
    { v: '', t: 's', s: { ...DEF_HEADER_CARTOUCHE } },
    { v: 'AU: ' + CONST_PARAM_YEAR, t: 's', s: { ...DEF_HEADER_CARTOUCHE } }
  ];
  let rowHeader5 = [
    { v: '', t: 's', s: { ...DEF_HEADER_CARTOUCHE } }
  ];
  let rowHeader6 = [
    { v: 'État des assiduités du ' + getReportACEDateStrFR(-30) + ' au ' + getReportACEDateStrFR(0), t: 's', s: { ...DEF_HEADER_CARTOUCHE } }
  ];
  let rowHeader7 = [
    { v: '', t: 's', s: { DEF_HEADER_CARTOUCHE } }
  ];
  
  let rowCollection = [rowHeader1, rowHeader2, rowHeader3, rowHeader4, rowHeader5, rowHeader6, rowHeader7];

  

  //************************ END HEADER ***********************

  // If we are not Global
  if(paramIsGlobalSheet == 'N'){

        // Header NOT GLOBAL
        let rowHeaderLineHeader = [
          { v: '', t: 's', s: { ...DEF_EMPTY_CELL } },
          { v: 'Niveau', t: 's', s: { ...DEF_HEADER_CELL } },
          { v: 'Parcours', t: 's', s: { ...DEF_HEADER_CELL } },
          { v: 'Groupe', t: 's', s: { ...DEF_HEADER_CELL } },
          { v: 'Username', t: 's', s: { ...DEF_HEADER_CELL } },
          { v: 'Matricule', t: 's', s: { ...DEF_HEADER_CELL } },
          { v: 'Nom complet', t: 's', s: { ...DEF_HEADER_CELL } },
          { v: 'Assiduité', t: 's', s: { ...DEF_HEADER_CELL } },
          { v: 'Occurence', t: 's', s: { ...DEF_HEADER_CELL } }
        ];
        rowCollection.push(rowHeaderLineHeader);


        let merge = [];
      
        const paddingCartouche = 8;
      
        let mrgNiveauRowStart = 0;
        let mrgNiveauLastRead = "";
      
        let mrgParcoursRowStart = 0;
        let mrgParcoursLastRead = "";
      
        let mrgGroupeRowStart = 0;
        let mrgGroupeLastRead = "";
      
        // Now we have to work on the lines !
        for(let i=0; i<paramLines.length; i++){
          
          let fullNameCell;
          if(paramLines[i].LIVING_CONFIG == 'A'){
            fullNameCell = { v: paramLines[i].FULLNAME, t: 's', s: { ...DEF_CELL_YELLOW } };
          }
          else{
            fullNameCell = { v: paramLines[i].FULLNAME, t: 's', s: { ...DEF_CELL } };
          }
          let rowHeaderLine = [
            { v: '', t: 's', s: { ...DEF_EMPTY_CELL } },
            { v: paramLines[i].NIVEAU, t: 's', s: { ...DEF_CELL } },
            { v: paramLines[i].PARCOURS, t: 's', s: { ...DEF_CELL } },
            { v: paramLines[i].GROUPE, t: 's', s: { ...DEF_CELL } },
            { v: paramLines[i].USERNAME, t: 's', s: { ...DEF_CELL_MONO } },
            { v: paramLines[i].MATRICULE, t: 's', s: { ...DEF_CELL } },
            fullNameCell,
            { v: paramLines[i].STATUS, t: 's', s: { ...DEF_CELL } },
            { v: paramLines[i].OCCURENCE, t: 's', s: { ...DEF_CELL } }
          ];
          rowCollection.push(rowHeaderLine);
      
          // Now work on the merge !
          // Niveau
          //We need to update because we change !
      
          // I have to initialise the first Mention
          if(i == 0){
            mrgNiveauLastRead = paramLines[i].NIVEAU;
            mrgParcoursLastRead = paramLines[i].PARCOURS;
            mrgGroupeLastRead = paramLines[i].GROUPE;
          }
          if(mrgNiveauLastRead != paramLines[i].NIVEAU){
            // We create the merge order : { s: { r: 8, c: 1 }, e: { r: 10, c: 1 } }
            // NIVEAU IS COLUMN 1
            let mrgOrderNiveau = { s: { r: paddingCartouche + mrgNiveauRowStart, c: 1 }, e: { r: paddingCartouche + i - 1, c: 1 } };
            merge.push(mrgOrderNiveau);
            // You also have to merge the other !
            mrgOrderNiveau = { s: { r: paddingCartouche + mrgParcoursRowStart, c: 2 }, e: { r: paddingCartouche + i - 1, c: 2 } };
            merge.push(mrgOrderNiveau);
      
            mrgOrderNiveau = { s: { r: paddingCartouche + mrgGroupeRowStart, c: 3 }, e: { r: paddingCartouche + i - 1, c: 3 } };
            merge.push(mrgOrderNiveau);
      
            mrgNiveauRowStart = i;
            mrgNiveauLastRead = paramLines[i].NIVEAU;
            mrgParcoursRowStart = i;
            mrgParcoursLastRead = paramLines[i].PARCOURS;
            mrgGroupeRowStart = i;
            mrgGroupeLastRead = paramLines[i].GROUPE;
          }
      
          if(mrgParcoursLastRead != paramLines[i].PARCOURS){
            let mrgOrderParcours = { s: { r: paddingCartouche + mrgParcoursRowStart, c: 2 }, e: { r: paddingCartouche + i - 1, c: 2 } };
            merge.push(mrgOrderParcours);
      
            // You also have to merge the other !
            mrgOrderParcours = { s: { r: paddingCartouche + mrgGroupeRowStart, c: 3 }, e: { r: paddingCartouche + i - 1, c: 3 } };
            merge.push(mrgOrderParcours);
      
            mrgParcoursRowStart = i;
            mrgParcoursLastRead = paramLines[i].PARCOURS;
            mrgGroupeRowStart = i;
            mrgGroupeLastRead = paramLines[i].GROUPE;
          }
      
          if(mrgGroupeLastRead != paramLines[i].GROUPE){
            let mrgOrderGroupe = { s: { r: paddingCartouche + mrgGroupeRowStart, c: 3 }, e: { r: paddingCartouche + i - 1, c: 3 } };
            merge.push(mrgOrderGroupe);
      
            mrgGroupeRowStart = i;
            mrgGroupeLastRead = paramLines[i].GROUPE;
          }
          /*
          if(paramLines[i].MENTION == 'DROIT'){
            console.log('i: ' + i + '/mrgNiveauLastRead: ' + mrgNiveauLastRead + ' /paramLines[i].NIVEAU: ' + paramLines[i].NIVEAU);
          }
          */
          // Merge the student
          if((i > 0) &&
              (paramLines[i-1].USERNAME == paramLines[i].USERNAME)){
              let mrgOrderStudent = { s: { r: paddingCartouche + i - 1, c: 4 }, e: { r: paddingCartouche + i, c: 4 } };
              merge.push(mrgOrderStudent);
              mrgOrderStudent = { s: { r: paddingCartouche + i - 1, c: 5 }, e: { r: paddingCartouche + i, c: 5 } };
              merge.push(mrgOrderStudent);
              mrgOrderStudent = { s: { r: paddingCartouche + i - 1, c: 6 }, e: { r: paddingCartouche + i, c: 6 } };
              merge.push(mrgOrderStudent);
          }
        }
        // We manage last lines
        let mrgOrderNiveauEnd = { s: { r: paddingCartouche + mrgNiveauRowStart, c: 1 }, e: { r: paddingCartouche + paramLines.length - 1, c: 1 } };
        merge.push(mrgOrderNiveauEnd);
        let mrgOrderParcoursEnd = { s: { r: paddingCartouche + mrgParcoursRowStart, c: 2 }, e: { r: paddingCartouche + paramLines.length - 1, c: 2 } };
        merge.push(mrgOrderParcoursEnd);
        let mrgOrderGroupeEnd = { s: { r: paddingCartouche + mrgGroupeRowStart, c: 3 }, e: { r: paddingCartouche + paramLines.length - 1, c: 3 } };
        merge.push(mrgOrderGroupeEnd);
      
        let rowFooter1 = [
          { v: '', t: 's', s: { ...DEF_FOOTER_CARTOUCHE } }
        ];
        rowCollection.push(rowFooter1);
        let rowFooter2 = [
          { v: 'NB 1 : ireo no isan\'ny Mpianatra nanapaka nandritra ny herinandro fa misy "details" raha mitady ny "parent" na "tuteur" (version papier)', t: 's', s: { ...DEF_FOOTER_CARTOUCHE } }
        ];
        rowCollection.push(rowFooter2);
        let rowFooter3 = [
          { v: 'NB 2 : ireo mpianatra voasoratra ireo no tena mpanapaka matetika tokony andraisana fepetra amin\'ny CD (version papier) io, efa manomboka milaza sy manontany ireo mpianatra tena manapaka matetika izahay !!!!', t: 's', s: { ...DEF_FOOTER_CARTOUCHE } }
        ];
        rowCollection.push(rowFooter3);
        let rowFooter4 = [
          { v: 'NB 3 : les matricules sont saisies à la main par les étudiants dans un formulaire. Nous ne pouvons les vérifier automatiquement, il y a donc un risque d\'erreur possible sur leur matricule.', t: 's', s: { ...DEF_FOOTER_CARTOUCHE } }
        ];
        rowCollection.push(rowFooter4);

        let rowFooter5 = [
          { v: 'NB 4 : Les noms en jaune sont les étudiants qui ont déclaré vivre seul(e).', t: 's', s: { ...DEF_FOOTER_CARTOUCHE } }
        ];
        rowCollection.push(rowFooter5);
      
        const ws = XLSX.utils.aoa_to_sheet(rowCollection);
        ws['!cols'] = [
          { width: 10 }, //Empty
          { width: 8 }, //Niveau
          { width: 20 }, //Parcours
          { width: 20 }, //Groupe
          { width: 17 }, //Username
          { width: 9 }, //Matricule
          { width: 40 }, //FullName
          { width: 10 }, //Status
          { width: 10 }]; //Occurence
        //ws['!rows'] = [{ 'hpt': DEF_ROW_DFT }, { 'hpt': DEF_ROW_DFT }, { 'hpt': DEF_ROW_DFT }, { 'hpt': DEF_ROW_DFT }, { 'hpt': DEF_ROW_DFT }, { 'hpt': DEF_ROW_DFT }, { 'hpt': DEF_ROW_DFT }];
        const rowDefinition = [];
        for(let i=0; i<rowCollection.length; i++){
          rowDefinition.push(DEF_ROW_DFT_SETUP);
        }
        ws['!rows'] = rowDefinition;


        //************************ MERGE OPERATION ***********************
        // Here s = start, r = row, c=col, e= end
        // Start with 0
        /*
        const merge = [
          { s: { r: 8, c: 1 }, e: { r: 10, c: 1 } }
        ];
        */
        ws["!merges"] = merge;

        return ws;
  }
  else{
        // *******************************************************
        // *******************************************************
        // *******************************************************
        // *******************************************************
        // *******************************************************
        // ********************   GLOBAL   ***********************
        // *******************************************************
        // *******************************************************
        // *******************************************************
        // *******************************************************
        // *******************************************************
        // Header GLOBAL
        let rowHeaderLineHeader = [
          { v: '', t: 's', s: { ...DEF_EMPTY_CELL } },
          { v: 'Mention', t: 's', s: { ...DEF_HEADER_CELL_HEAVY } },
          { v: 'Niveau', t: 's', s: { ...DEF_HEADER_CELL_HEAVY } },
          { v: 'Parcours', t: 's', s: { ...DEF_HEADER_CELL_HEAVY } },
          { v: 'Groupe', t: 's', s: { ...DEF_HEADER_CELL_HEAVY } },
          { v: 'Total étudiant', t: 's', s: { ...DEF_HEADER_CELL_HEAVY } },
          { v: 'Total retard', t: 's', s: { ...DEF_HEADER_CELL_HEAVY } },
          { v: 'Total absence', t: 's', s: { ...DEF_HEADER_CELL_HEAVY } }
        ];
        rowCollection.push(rowHeaderLineHeader);

        for(let i=0; i<paramLines.length; i++){
          //is DEF_CELL_ODD
          if(i % 2 === 0){
            let rowHeaderLine = [
              { v: '', t: 's', s: { ...DEF_EMPTY_CELL } },
              { v: paramLines[i].MENTION, t: 's', s: { ...DEF_CELL_ODD } },
              { v: paramLines[i].NIVEAU, t: 's', s: { ...DEF_CELL_ODD } },
              { v: paramLines[i].PARCOURS, t: 's', s: { ...DEF_CELL_ODD } },
              { v: paramLines[i].GROUPE, t: 's', s: { ...DEF_CELL_ODD } },
              { v: paramLines[i].POPULATION, t: 's', s: { ...DEF_CELL_ODD } },
              { v: paramLines[i].LATE_OCC, t: 's', s: { ...DEF_CELL_ODD } },
              { v: paramLines[i].MIS_OCC, t: 's', s: { ...DEF_CELL_ODD } }
            ];
            rowCollection.push(rowHeaderLine);
          }
          else{
              let rowHeaderLine = [
                { v: '', t: 's', s: { ...DEF_EMPTY_CELL } },
                { v: paramLines[i].MENTION, t: 's', s: { ...DEF_CELL } },
                { v: paramLines[i].NIVEAU, t: 's', s: { ...DEF_CELL } },
                { v: paramLines[i].PARCOURS, t: 's', s: { ...DEF_CELL } },
                { v: paramLines[i].GROUPE, t: 's', s: { ...DEF_CELL } },
                { v: paramLines[i].POPULATION, t: 's', s: { ...DEF_CELL } },
                { v: paramLines[i].LATE_OCC, t: 's', s: { ...DEF_CELL } },
                { v: paramLines[i].MIS_OCC, t: 's', s: { ...DEF_CELL } }
              ];
              rowCollection.push(rowHeaderLine);
          }
        }

        const ws = XLSX.utils.aoa_to_sheet(rowCollection);
        ws['!cols'] = [
          { width: 10 }, //Empty
          { width: 40 }, //MENTION
          { width: 8 }, //NIVEAU
          { width: 20 }, //PARCOURS
          { width: 20 }, //GROUPE
          { width: 20 }, //POPULATION
          { width: 12 }, //LATE_OCC
          { width: 12 }]; //MIS_OCC
        //ws['!rows'] = [{ 'hpt': DEF_ROW_DFT }, { 'hpt': DEF_ROW_DFT }, { 'hpt': DEF_ROW_DFT }, { 'hpt': DEF_ROW_DFT }, { 'hpt': DEF_ROW_DFT }, { 'hpt': DEF_ROW_DFT }, { 'hpt': DEF_ROW_DFT }];
        const rowDefinition = [];
        for(let i=0; i<rowCollection.length; i++){
          rowDefinition.push(DEF_ROW_DFT_SETUP);
        }
        ws['!rows'] = rowDefinition;

        return ws;
  }
}


function generateGlobalPsdXLS(){
  const wb = XLSX.utils.book_new();

  // Create first the global worksheet
  // dataTagToJsonArrayExcelGblComputeReport
  XLSX.utils.book_append_sheet(wb, generateGlobalPsdXLSWorksheet(dataTagToJsonArrayExcelGblComputeReport, 'Y'), 'RESUME');

  // We assume that the collection is ordered : dataTagToJsonArrayExcelGblReport
  let iMentionLines = [];
  let iMention = '';
  const LIMIT_WORKSHEET_SIZE = 25;
  for(let i = 0; i< dataTagToJsonArrayExcelGblReport.length; i++){
    if(dataTagToJsonArrayExcelGblReport[i].MENTION == iMention){
      // We are still in the same mention !!!
    }
    else{
      // We create a new mention !
      // First we manage existing.
      if(iMention != ''){
        //We avoid empty case
        XLSX.utils.book_append_sheet(wb, generateGlobalPsdXLSWorksheet(iMentionLines, 'N'), iMention.substring(0, LIMIT_WORKSHEET_SIZE));
      }
      //console.log("Attach worksheet: " + iMention);
      iMention = dataTagToJsonArrayExcelGblReport[i].MENTION;
      iMentionLines = [];
    }
    //Whatever we push it
    iMentionLines.push(dataTagToJsonArrayExcelGblReport[i]);
  }
  // Because we have to handle the last Mention
  XLSX.utils.book_append_sheet(wb, generateGlobalPsdXLSWorksheet(iMentionLines, 'N'), iMention.substring(0, LIMIT_WORKSHEET_SIZE));
  //console.log("Attach worksheet: " + iMention);

  // STEP 4: Write Excel file to browser
  XLSX.writeFile(wb, "RapportAbsence30j_" + getReportACEDateStrFR(0).replaceAll('/', '_') + ".xlsx");
}




function initButtonPublishS1(){
  let draftS1ToPublish = 0;

  for(let i=0; i<dataAllEDTToJsonArray.length; i++){
    if((dataAllEDTToJsonArray[i].s == 'S1') && (dataAllEDTToJsonArray[i].visibility ==  "D")){
      draftS1ToPublish = draftS1ToPublish + 1;
    }
  }
  
  $("#nb-dft-S1").html(draftS1ToPublish);
  if(draftS1ToPublish > 0){
    console.log('We found an S1 to display');
    //document.getElementById("pub-s1").disabled = false;
    
    $("#pub-s1").prop('disabled', false);
  }
  else{
    console.log('We did not found an S1 to display');
    //document.getElementById("pub-s1").disabled = true;
    $("#pub-s1").prop('disabled', true);
  }
}

function goToPublishAllS1(){
  $("#mg-publish-all-S1").submit();
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

    // Lignes de backup
    $("#edt-disp-line").click(function() {
        console.log('Click #edt-disp-line');
        //$(".uac-bkp-version").css("visibility", "visible");
        $(".uac-bkp-version").show();
        $("#edt-disp-line").hide();
    });

    // Traces SCAN
    $("#edt-switch-in-out").click(function() {
      if (!($("#blc-trace-in-out").css('display') == 'none')){
        $("#blc-trace-in-out").hide();
      }
      else{
        $("#blc-trace-in-out").show();
      }
    });

    $("#scmenu-edt").click(function() {
      //console.log('You click on scmenu-edt');

      document.getElementById('anchor-edt').scrollIntoView({
        behavior: 'smooth'
      });
    });
    
    /****************************************************/
    /****************************************************/
    /******************  Modif profile  *****************/
    /****************************************************/
    /****************************************************/
    //fillCartoucheMentionProfile();
    // Refresh status
    $( ".stt-group" ).click(function() {
      updateProfStatus(this.id);
    });


    /****************************************************/
    /****************************************************/
    /****************** START : PAYMENT *****************/
    /****************************************************/
    /****************************************************/
    if(PARAM_DOES_PAY_DISPLAY == 'Y'){
      let displayPayBlock = 'N';
      if(FROM_ADMIN != 'N'){
        // We display because we are from admin
        displayPayBlock = 'Y';
      }
      else if(PARAM_DOES_PAY_PUBLIC == 'Y'){
        // So in this case we are not admin but the block is public
        displayPayBlock = 'Y';
      }
      else{
        displayPayBlock = 'N';
      };

      if(displayPayBlock == 'Y'){
        $("#scmenu-pay").click(function() {
          document.getElementById('anchor-pay').scrollIntoView({
            behavior: 'smooth'
          });
        });
        loadSumUpGrid();
        loadHistoPayGrid();
  
        $(".go-to-top").click(function() {
          document.getElementById('anchor-top').scrollIntoView({
            behavior: 'smooth'
          });
        });
      }

      if(paramDispGraAdmin == 'Y'){
          loadGraGrid();
          initGraShortCut();
          if(CAN_WE_DISPLAY_TEMP_GRA == 'N'){
              $('#jury-info').html("Vous continuez à les voir en tant qu'administrateur mais les notes ne sont plus visibles sur le dashboard étudiant parce que le jury a fini de délibérer.<br>Les résultats finaux sont affichés en papier à l'université&nbsp;<span class='icon-exclamation-triangle nav-icon-fa-sm nav-text'></span>");
          }
      }
      else if(paramDispGraPublic == 'Y'){
          initGraShortCut();
          if(doesPaymentLateExist()){
            // Payment late exists
            $('#jsGridStuGrade').html("<div id='gra-late-warn'>Veuillez régler vos frais de scolarité en retard pour afficher votre tableau de notes&nbsp;<span class='icon-exclamation-triangle nav-icon-fa-sm nav-text'></span></div>");
          }
          else if(CAN_WE_DISPLAY_TEMP_GRA == 'N'){
            //In that case the jury has already given the grade and are published at school
            $('#jsGridStuGrade').html("<div id='gra-late-warn'>Le jury a fini de délibérer et vos résultats définitifs de l'année scolaire sont affichés en papier à l'université.<br>Les notes temporaires des éléments constitutifs ne sont plus disponibles sur votre dashboard&nbsp;<span class='icon-exclamation-triangle nav-icon-fa-sm nav-text'></span></div>");
          }
          else{
            // There is no payment late so we can show grades
            loadGraGrid();
          }
          
      }
      else{

      }

    }
    /****************************************************/
    /****************************************************/
    /******************  END  : PAYMENT *****************/
    /****************************************************/
    /****************************************************/
    
    // Ephemeride
    $('#eph-date').html(getWrittenFRLongDateStrFR(0, 'N'));
  }
  else if($('#mg-graph-identifier').text() == 'dash-ass'){
    // Do nothing dash-ass
    runStat();
    $( "#uac-ass-glb-csv" ).click(function() {
      generateGlobalAssCSV();
    });
    $( "#uac-abs-pdt-xls" ).click(function() {
      generateGlobalPsdXLS();
    });

  }
  else if($('#mg-graph-identifier').text() == 'man-edt'){
    // Do nothing
    initAllEDTGrid();
    loadAllEDTGrid();
    initWarningEDT();
    initButtonPublishS1();
    textS0 = initTextExport(textS0ToJsonArray);
    textS1 = initTextExport(textS1ToJsonArray);
    textD = initTextExport(textDToJsonArray);
  }
  else if($('#mg-graph-identifier').text() == 'aft-mvo'){
    
      $("#aftload-mvo-nav-up").click(function() {
        console.log('You click on aftload-edt-nav-up');

        document.getElementById('anchor-up-mvo').scrollIntoView({
          behavior: 'smooth'
        });
      });


  }
  else if($('#mg-graph-identifier').text() == 'aft-loa'){
    // Do nothing
    $(".after-load-edt-trace").click(function() {
        $(".report-dis").show();
        $(".after-load-edt-trace").hide();
    });

    $("#aftload-edt-nav-up").click(function() {
      console.log('You click on aftload-edt-nav-up');

      document.getElementById('anchor-up-edt').scrollIntoView({
        behavior: 'smooth'
      });
    });

    // We must warn the user that there are warning on duration
    if($(".err-219").length > 0){
      $("#warn-219").html("<i class='err'>"+ $(".err-219").length + " warning(s). Scrollez vers le bas, cherchez l'erreur ERR219 et vérifiez la durée des cours.</i>");
    }
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
  else if($('#mg-graph-identifier').text() == 'stt-men'){
    // Do nothing

    $(".men-up").click(function() {
      document.getElementById('anchor-menup').scrollIntoView({
        behavior: 'smooth'
      });
    });


    console.log('You are in stt-men');
    $("#men-drt").click(function() {
      console.log('You click on scmenu-edt');

      document.getElementById('anchor-drt').scrollIntoView({
        behavior: 'smooth'
      });
    });

    $("#men-ges").click(function() {
      document.getElementById('anchor-ges').scrollIntoView({
        behavior: 'smooth'
      });
    });

    $("#men-eco").click(function() {
      document.getElementById('anchor-eco').scrollIntoView({
        behavior: 'smooth'
      });
    });

    $("#men-inf").click(function() {
      document.getElementById('anchor-inf').scrollIntoView({
        behavior: 'smooth'
      });
    });

    $("#men-com").click(function() {
      document.getElementById('anchor-com').scrollIntoView({
        behavior: 'smooth'
      });
    });

    $("#men-ssa").click(function() {
      document.getElementById('anchor-ssa').scrollIntoView({
        behavior: 'smooth'
      });
    });

    $("#men-rid").click(function() {
      document.getElementById('anchor-rid').scrollIntoView({
        behavior: 'smooth'
      });
    });



  }
  else{
    //Do nothing
  }



});
