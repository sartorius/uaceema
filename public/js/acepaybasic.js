
function generateAttribuerMvo(){

  // Put loading for the call DB
  $('#mvo-details-modal').modal('toggle');
  $('#loading').show(50);
  let foundUsername = $('#fnd-usrn').html();
  let foundMvolaId = $('#fnd-mvoid').html();
  //console.log("foundUsername: " + foundUsername);

  $.ajax('/generateattribuerMvoDB', {
      type: 'POST',  // http method
      data: {
        currentAgentIdStr: CURRENT_AGENT_ID_STR,
        paramFoundUsername: foundUsername,
        paramMvoId: foundMvolaId,
        paramInvCaseOperation: invCaseOperation,
        token: getToken
      },  // data to submit
      success: function (data, status, xhr) {

          if(data['status'] == 'NL'){
            $('#loading').hide(50);
            $('#msg-alert').html("ERRFM55: " + foundUsername + " attribution du Mvola impossible, cet étudiant a déjà TOUT PAYÉ. Il ne lui reste rien à régler. Veuillez vérifier. ");
            $('#type-alert').removeClass('alert-primary').addClass('alert-danger');
            $('#ace-alert-msg').show(100);
            document.body.scrollTop = document.documentElement.scrollTop = 0;
            clearDataAllMVO();
          }
          else{
              let i = getAllMvoToJsonArrayId(parseInt(foundMvolaId));
              if(i>-1){
                  //We found it
                  // Do some changes first in the array
                  dataAllMVOToJsonArray[i].USERNAME_LU = foundUsername;
                  dataAllMVOToJsonArray[i].STATUS_TRANSACTION = 'ATT';
                  showPopUpMvola(dataAllMVOToJsonArray[i], 'Y');
              }
              else{
                  //We did not found it
                  //console.log('Err : getRawPaymentDetail ' + param + '/' + i);
              };
              $('#msg-alert').html("Attribution: " + foundUsername + " réalisée avec succés. Vous pouvez vérifier dans le dashboard.");
              $('#type-alert').removeClass('alert-danger').addClass('alert-primary');
              $('#ace-alert-msg').show(100);
              document.body.scrollTop = document.documentElement.scrollTop = 0;
              clearDataAllMVO();
              $('#loading').hide(50);
          }
      },
      error: function (jqXhr, textStatus, errorMessage) {
        $('#loading').hide(50);
        $('#msg-alert').html("ERRM034:" + foundUsername + " attribution du Mvola impossible, contactez le support. ");
        $('#type-alert').removeClass('alert-primary').addClass('alert-danger');
        $('#ace-alert-msg').show(100);
        clearDataAllMVO();
      }
  });
}

/***********************************************************************************************************/
/***********************************************************************************************************/
// PAYMENT 
/***********************************************************************************************************/
/***********************************************************************************************************/
/***********************************************************************************************************/
/***********************************************************************************************************/
/***********************************************************************************************************/

function generateAllPayCSV(){
    const csvContentType = "data:text/csv;charset=utf-8,";
    let csvContent = "";
    let involvedArray = filtereddataAllPAYToJsonArray;
    const SEP_ = ";"

	let dataString = "Référence" + SEP_ 
                    + "Status" + SEP_ 
                    + "Type" + SEP_ 
                    + "Date de paiement" + SEP_ 
                    + "Montant" + SEP_
                    + "Commentaire" + SEP_ 
                    + "Code de référence" + SEP_ 
                    + "Description de référence" + SEP_ 
                    + "Montant de référence" + SEP_ 
                    + "Limite de paiement" + SEP_
                    + "Classe" + SEP_ 
                    + "Username" + SEP_ 
                    + "Prénom" + SEP_ 
                    + "Nom" + SEP_ 
                    + "Matricule" + SEP_ 
                    + "Transaction Mvola" + SEP_ 
                    + "Expéditeur Mvola" + SEP_ 
                    + "Libellé Mvola" + SEP_ 
                    + "Ticket réduction" + SEP_ 
                    + "Agent" + SEP_ 
                    + "Pourcentage réduction" + SEP_ 
                    + "Réduction status" + SEP_ + "\n";
	csvContent += dataString;
	for(let i=0; i<involvedArray.length; i++){

            dataString = involvedArray[i].UP_PAYMENT_REF + SEP_ 
                + verboseStatusOfPayment(involvedArray[i].UP_STATUS) + SEP_ 
                + verboseTypeOfPayment(involvedArray[i].UP_TYPE_OF_PAYMENT) + SEP_ 
                + involvedArray[i].UP_PAY_DATE + SEP_ 
                + isNullMvo(involvedArray[i].UP_INPUT_AMOUNT) + SEP_ 
                + isNullMvo(involvedArray[i].UP_COMMENT) + SEP_ 
                + isNullMvo(involvedArray[i].REF_CODE) + SEP_ 
                + isNullMvo(involvedArray[i].REF_DESCRIPTION) + SEP_ 
                + isNullMvo(involvedArray[i].REF_AMOUNT) + SEP_ 
                + isNullMvo(involvedArray[i].REF_DDL) + SEP_ 
                + isNullMvo(involvedArray[i].VSH_SHORT_CLASS) + SEP_ 
                + isNullMvo(involvedArray[i].VSH_USERNAME) + SEP_ 
                + isNullMvo(involvedArray[i].VSH_FIRSTNAME) + SEP_ 
                + isNullMvo(involvedArray[i].VSH_LASTNAME) + SEP_ 
                + isNullMvo(involvedArray[i].VSH_MATRICULE) + SEP_ 
                + isNullMvo(involvedArray[i].MVO_TRANSACTION) + SEP_ 
                + isNullMvo(involvedArray[i].MVO_FROM_PHONE) + SEP_
                + isNullMvo(involvedArray[i].MVO_DETAILS_A) + SEP_ 
                + isNullMvo(involvedArray[i].UFP_TICKET) + SEP_ 
                + isNullMvo(involvedArray[i].LAST_AGENT_ID) + SEP_ 
                + isNullMvo(involvedArray[i].UFP_POURCENTAGE_REDUCTION) + SEP_ 
                + isNullMvo(involvedArray[i].UFP_STATUS) + SEP_ ;
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
    link.download = 'RapportGlobalPaiement.csv';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
}

function initAllPAYGrid(){
    $('#filter-all-pay').keyup(function() {
        filterDataAllPAY();
    });
    $('#re-init-dash-pay').click(function() {
      $('#filter-all-pay').val('');
      clearDataAllPAY();
    });
  }
  
  function filterDataAllPAY(){
    if(($('#filter-all-pay').val().length > 1) && ($('#filter-all-pay').val().length < 35)){
      //console.log('We need to filter !' + $('#filter-all').val());
      filtereddataAllPAYToJsonArray = dataAllPAYToJsonArray.filter(function (el) {
                                        return el.raw_data.includes($('#filter-all-pay').val().toUpperCase())
                                    });
        $("#mst-filcnt").html(filtereddataAllPAYToJsonArray.length);
        loadAllPAYGrid();
    }
    else if(($('#filter-all-pay').val().length < 2)) {
      // We clear data
      clearDataAllPAY();
    }
    else{
      // DO nothing
    }
  }
  
  function clearDataAllPAY(){
    filtereddataAllPAYToJsonArray = Array.from(dataAllPAYToJsonArray);
    $("#mst-filcnt").html(filtereddataAllPAYToJsonArray.length);
    loadAllPAYGrid();
  };


/*
,,
        { name: "UP_COMMENT",
          title: "Commentaire",
          type: "text",
          width: 35,
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm"
        }
        { name: "MVO_TRANSACTION",
          title: "Transaction Mvola",
          width: 60,
          type: "text",
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm-mono"
        }
        { name: "UFP_STATUS",
          title: "Status Réduction",
          width: 60,
          type: "text",
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm",
          itemTemplate: function(value, item) {
            if(value == 'A'){
              return 'Actif';
            }
            else{
              return 'Inactif';
            }
          }
        }

*/
function getAllPAYToJsonArrayId(val){
    for(let i=0; i<dataAllPAYToJsonArray.length; i++){
        if(dataAllPAYToJsonArray[i].UP_ID == val){
            return i;
        }
    }
    return -1;
}

function getRawPaymentDetail(param){
    console.log('You click on getRawPaymentDetail');
    let i = getAllPAYToJsonArrayId(parseInt(param));
    if(i>-1){
        //We found it
        showPopUpPay(dataAllPAYToJsonArray[i]);
    }
    else{
        //We did not found it
        console.log('Err : getRawPaymentDetail ' + param + '/' + i);
    }
}
 
function showPopUpPay(param){
    let detailsMsg = '';
    let detailsMvo = '';
    let detailsRed = '';
    $('#title-pay-details').html(param.UP_PAYMENT_REF);
    detailsMsg = detailsMsg + '<strong>Username &nbsp;:&nbsp;</strong>' + param.VSH_USERNAME + '<br>';
    detailsMsg = detailsMsg + '<strong>Date heure paiement &nbsp;:&nbsp;</strong>' + param.UP_PAY_DATETIME + '<br>';
    detailsMsg = detailsMsg + '<strong>Montant &nbsp;:&nbsp;</strong>' + renderAmount(param.UP_INPUT_AMOUNT) + '<br>';
    detailsMsg = detailsMsg + '<strong>Status &nbsp;:&nbsp;</strong>' + verboseStatusOfPayment(param.UP_STATUS) + '<br>';
    detailsMsg = detailsMsg + '<strong>Type &nbsp;:&nbsp;</strong>' + verboseTypeOfPayment(param.UP_TYPE_OF_PAYMENT) + '<br>';
    detailsMsg = detailsMsg + '<strong>Commentaire &nbsp;:&nbsp;</strong>' + isNullMvo(param.UP_COMMENT) + '<br><br>';
    detailsMsg = detailsMsg + '<strong>Code de référence &nbsp;:&nbsp;</strong>' + param.REF_CODE + '<br>';
    detailsMsg = detailsMsg + '<strong>Description Paiement &nbsp;:&nbsp;</strong>' + param.REF_DESCRIPTION + '<br>';
    detailsMsg = detailsMsg + '<strong>Limite Paiement &nbsp;:&nbsp;</strong>' + param.REF_DDL + '<br>';
    detailsMsg = detailsMsg + '<strong>Montant de référence &nbsp;:&nbsp;</strong>' + renderAmount(param.REF_AMOUNT) + '<br><br>';
    detailsMsg = detailsMsg + '<strong>Classe &nbsp;:&nbsp;</strong>' + param.VSH_SHORT_CLASS + '<br>';
    detailsMsg = detailsMsg + '<strong>Prénom &nbsp;:&nbsp;</strong>' + param.VSH_FIRSTNAME + '<br>';
    detailsMsg = detailsMsg + '<strong>Nom &nbsp;:&nbsp;</strong>' + param.VSH_LASTNAME + '<br>';
    detailsMsg = detailsMsg + '<strong>Matricule &nbsp;:&nbsp;</strong>' + param.VSH_MATRICULE + '<br><br>';
    detailsMsg = detailsMsg + '<strong>Agent &nbsp;:&nbsp;</strong>' + param.LAST_AGENT_ID + '<br>';

    if(param.MVO_TRANSACTION != ''){
        detailsMvo = detailsMvo + '<strong>Transaction &nbsp;:&nbsp;</strong>' + param.MVO_TRANSACTION + '<br>';
        detailsMvo = detailsMvo + '<strong>Expéditeur &nbsp;:&nbsp;</strong>' + param.MVO_FROM_PHONE + '<br>';
        detailsMvo = detailsMvo + '<strong>Libellé &nbsp;:&nbsp;</strong>' + param.MVO_DETAILS_A + '<br>';
    }
    else{
        detailsMvo = "<i class='gray-txt'>Ce n'est pas un paiement Mvola</i>";
    }

    if(param.UFP_TICKET != ''){
        detailsRed = detailsRed + '<strong>Ticket &nbsp;:&nbsp;</strong>' + param.UFP_TICKET + '<br>';
        detailsRed = detailsRed + '<strong>Type de Réduction &nbsp;:&nbsp;</strong>' + (param.UP_TYPE_OF_PAYMENT == 'L' ? 'Lettre engagement' : 'Réduction') + '<br>';
        detailsRed = detailsRed + '<strong>Pourcentage de Réduction &nbsp;:&nbsp;</strong>' + param.UFP_POURCENTAGE_REDUCTION + '%' + '<br>';
        detailsRed = detailsRed + '<strong>Status &nbsp;:&nbsp;</strong>' + (param.UFP_STATUS == 'A' ? 'Actif' : 'Inactif') + '<br>';
    }
    else{
        detailsRed = "<i class='gray-txt'>Ce n'est pas un ticket de réduction</i>";
    }

    $('#pay-details-txt').html(detailsMsg);
    $('#pay-mvo-txt').html(detailsMvo + "<br>");
    $('#pay-red-txt').html(detailsRed + "<br>");
    
    $('#pay-details-modal').modal('show');
}

/*

function verboseTypeOfPayment(value){
    if(value == 'C'){
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
          return 'Lettre engagement';
      }
      else if(value == 'E'){
          return 'Exemption';
      }
      else{
        return 'Erreur 892C';
      }
}

function verboseStatusOfPayment(value){
    if(value == 'P'){
        return 'Payé';
      }
      else if(value == 'N'){
          return 'Non payé';
      }
      else if(value == 'E'){
          return 'Dispensé';
      }
      else{
        return 'Annulé';
      }
}
*/

function loadAllPAYGrid(){

    refPayField = [
        { name: "UP_PAYMENT_REF",
          title: "Référence",
          type: "text",
          width: 40,
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm-mono"
        },
        { name: "VSH_USERNAME",
          title: "Username",
          type: "text",
          width: 40,
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm-mono"
        },
        { name: "UP_INPUT_AMOUNT",
          title: "Montant",
          type: "number",
          width: 50,
          align: "right",
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm",
          itemTemplate: function(value, item) {
            return renderAmount(value);
          }
        },
        { name: "UP_PAY_DATE",
          title: "Date",
          type: "text",
          width: 50,
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm"
        },
        { name: "UP_STATUS",
          title: "Status",
          type: "text",
          width: 40,
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm",
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
        { name: "UP_TYPE_OF_PAYMENT",
          title: "Type",
          type: "text",
          width: 65,
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm",
          itemTemplate: function(value, item) {
            return verboseTypeOfPayment(value);
          }
        },
        { name: "REF_CODE",
          title: "Code",
          type: "text",
          width: 35,
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm-mono"
        },
        //Default width is auto
        { name: "REF_DESCRIPTION",
          title: "Description",
          type: "text",
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm"
        },
        /*
        { name: "UFP_TICKET",
          title: "Ticket",
          width: 45,
          type: "text",
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm-mono"
        },
        */
        { name: "UP_ID",
          title: "Voir",
          width: 20,
          type: "text",
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm-center",
          itemTemplate: function(value, item) {
            //return value + '%';
            return '<button onclick="getRawPaymentDetail(' + value +  ')" class="btn btn-outline-dark"><i class="icon-eye"></i></button>';
          }
        },
        { name: "PAGE",
          title: "Go",
          width: 20,
          type: "text",
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm-center",
          itemTemplate: function(value, item) {
            return '<button onclick="goToSTUFromPayMngr(\'' + value +  '\')" class="btn btn-dark"><i class="icon-arrow-right"></i></button>';
          }
        }
    ];

    $("#jsGridAllPAY").jsGrid({
        height: "auto",
        width: "100%",
        noDataContent: "Aucun paiement disponible",
        pageIndex: 1,
        pageSize: 50,
        pagePrevText: "Prec",
        pageNextText: "Suiv",
        pageFirstText: "Prem",
        pageLastText: "Dern",

        sorting: true,
        paging: true,
        data: filtereddataAllPAYToJsonArray,
        fields: refPayField/*,
        rowClick: function(args){
            goToSTUFromPayMngr(args.item.PAGE);
        }*/
    });
}

// goToSTUFromDashAssiduite(args.item.PAGE);
function goToSTUFromPayMngr(page){
    $("#read-stu-page").val(page);
    $("#mg-stu-page-form").submit();
  }


/***********************************************************************************************************/
/***********************************************************************************************************/
// MVOLA
/***********************************************************************************************************/
/***********************************************************************************************************/
/***********************************************************************************************************/
/***********************************************************************************************************/
/***********************************************************************************************************/





/*****************************************************************************************/
/*****************************************************************************************/
/*****************************************************************************************/
/************************** START FILTER FUNTION *****************************************/
/*****************************************************************************************/
/*****************************************************************************************/
/*****************************************************************************************/

function initAllMVOGrid(){
    $('#filter-all-mvo').keyup(function() {
      filterDataAllMVO();
    });
    $('#re-init-dash-mvo').click(function() {
      $('#filter-all-mvo').val('');
      clearDataAllMVO();
    });
  }
  
  function filterDataAllMVO(){
    if(($('#filter-all-mvo').val().length > 1) && ($('#filter-all-mvo').val().length < 35)){
      //console.log('We need to filter !' + $('#filter-all').val());
      filteredDataAllMVOToJsonArray = dataAllMVOToJsonArray.filter(function (el) {
                                        return el.raw_data.includes($('#filter-all-mvo').val().toUpperCase())
                                    });
      $("#mst-filcnt").html(filteredDataAllMVOToJsonArray.length);
      loadAllMVOGrid();
    }
    else if(($('#filter-all-mvo').val().length < 2)) {
      // We clear data
      clearDataAllMVO();
    }
    else{
      // DO nothing
    }
  }
  
  function clearDataAllMVO(){
    filteredDataAllMVOToJsonArray = Array.from(dataAllMVOToJsonArray);
    $("#mst-filcnt").html(filteredDataAllMVOToJsonArray.length);
    loadAllMVOGrid();
  };
  
  
  /*****************************************************************************************/
  /*****************************************************************************************/
  /*****************************************************************************************/
  /**************************  END FILTER FUNTION  *****************************************/
  /*****************************************************************************************/
  /*****************************************************************************************/
  /*****************************************************************************************/

/*
function isNullMvo(param){
    return (param ==  null ? '' : param);
}
*/

function generateAllMvolaCSV(){
    const csvContentType = "data:text/csv;charset=utf-8,";
    let csvContent = "";
    let involvedArray = filteredDataAllMVOToJsonArray;
    const SEP_ = ";"

	let dataString = "Transaction" + SEP_ 
                    + "Status" + SEP_ 
                    + "Date Heure" + SEP_ 
                    + "Type" + SEP_ 
                    + "Montant" + SEP_
                    + "Expediteur" + SEP_ 
                    + "Destinataire" + SEP_ 
                    + "Detail A" + SEP_ 
                    + "Detail B" + SEP_ 
                    + "Username Lu" + SEP_ 
                    + "Date Heure Transaction Lu" + SEP_ 
                    + "Raison Rejet" + SEP_ 
                    + "Nom Du Fichier" + SEP_ 
                    + "Date Heure Integration" + SEP_ 
                    + "Solde Fichier Avant" + SEP_ 
                    + "Solde Fichier Apres" + SEP_ 
                    + "Telephone Compte" + SEP_ 
                    + "Nom Du Compte" + SEP_ + "\n";
	csvContent += dataString;
	for(let i=0; i<involvedArray.length; i++){

            dataString = involvedArray[i].REF_TRANSACTION + SEP_ 
                + verboseStatus(involvedArray[i].STATUS_TRANSACTION) + SEP_ 
                + involvedArray[i].DATE_HEURE_TRANSACTION + SEP_ 
                + isNullMvo(involvedArray[i].TYPE_TRANSACTION) + SEP_ 
                + isNullMvo(involvedArray[i].MONTANT_TRANSACTION) + SEP_ 
                + isNullMvo(involvedArray[i].TELEPHONE_EXPEDITEUR) + SEP_ 
                + isNullMvo(involvedArray[i].TELEPHONE_DESTINATAIRE) + SEP_ 
                + isNullMvo(involvedArray[i].DETAIL_A) + SEP_ 
                + isNullMvo(involvedArray[i].DETAIL_B) + SEP_ 
                + isNullMvo(involvedArray[i].USERNAME_LU) + SEP_ 
                + isNullMvo(involvedArray[i].DATE_HEURE_TRANSACTION_LU) + SEP_ 
                + isNullMvo(involvedArray[i].RAISON_REJET) + SEP_ 
                + isNullMvo(involvedArray[i].NOM_FICHIER) + SEP_ 
                + isNullMvo(involvedArray[i].DATE_HEURE_INTEGRATION) + SEP_ 
                + isNullMvo(involvedArray[i].SOLDE_FICHIER_AVANT) + SEP_
                + isNullMvo(involvedArray[i].SOLDE_FICHIER_APRES) + SEP_ 
                + isNullMvo(involvedArray[i].TELEPHONE_COMPTE) + SEP_ 
                + isNullMvo(involvedArray[i].NOM_COMPTE) + SEP_ ;
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
    link.download = 'RapportGlobalMvola.csv';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
}

/***********************************************************************************************************/

function getAllMvoToJsonArrayId(val){
  for(let i=0; i<dataAllMVOToJsonArray.length; i++){
      if(dataAllMVOToJsonArray[i].ULM_ID == val){
          return i;
      }
  }
  return -1;
}


function verboseStatus(paramValue){
    if(paramValue == 'END'){
        return "Transaction valide";
      }
      else if(paramValue == 'ATT'){
        return 'Transaction attribuée';
      }
      else if(paramValue == 'NUD'){
        return 'Username introuvable';
      }
      else if(paramValue == 'DUP'){
        return 'Doublon';
      }
      else{
        return 'Ligne invalide';
      }
}

function showPopUpMvola(param, paramAjaxFeedback){
    let detailsMsg = '';
    let detailsFile = '';
    $('#title-mvo-details').html(param.REF_TRANSACTION + ' #' + param.ULM_ID);
    
    if(param.STATUS_TRANSACTION == 'NUD'){
      detailsMsg = detailsMsg + '<i class="line-pv-res"><span class="icon-eye nav-icon-fa nav-text"></span>&nbsp;<strong>Date heure de transaction &nbsp;:&nbsp;</strong>' + param.DATE_HEURE_TRANSACTION + '</i><br>';
    }
    else{
      detailsMsg = detailsMsg + '<strong>Date heure de transaction &nbsp;:&nbsp;</strong>' + param.DATE_HEURE_TRANSACTION + '<br>';
    };
    
    detailsMsg = detailsMsg + '<strong>Date heure de transaction lu &nbsp;:&nbsp;</strong>' + (param.DATE_HEURE_TRANSACTION_LU == null ? 'NA' : param.DATE_HEURE_TRANSACTION_LU) + '<br>';
    detailsMsg = detailsMsg + '<strong>Status &nbsp;:&nbsp;</strong>' + verboseStatus(param.STATUS_TRANSACTION) + '<br>';
    detailsMsg = detailsMsg + '<strong>Type &nbsp;:&nbsp;</strong>' + param.TYPE_TRANSACTION + '<br>';
    if(param.STATUS_TRANSACTION == 'NUD'){
      invMVOAmountNUD = parseInt(param.MONTANT_TRANSACTION);
      detailsMsg = detailsMsg + '<i class="line-pv-res"><span class="icon-eye nav-icon-fa nav-text"></span>&nbsp;<strong>Montant &nbsp;:&nbsp;</strong>' + renderAmount(param.MONTANT_TRANSACTION) + '</i><br>';
      detailsMsg = detailsMsg + '<i class="line-pv-res"><span class="icon-eye nav-icon-fa nav-text"></span>&nbsp;<strong>Expéditeur/Cash Point&nbsp;:&nbsp;</strong> ' + param.TELEPHONE_EXPEDITEUR.replace(/\D+/g, '').replace(/(\d{3})(\d{2})(\d{2})(\d{3})/, '$1 $2 $3 $4') + ' </i><br>';
    }
    else{
      invMVOAmountNUD = 0;
      detailsMsg = detailsMsg + '<strong>Montant &nbsp;:&nbsp;</strong>' + renderAmount(param.MONTANT_TRANSACTION) + '<br>';
      detailsMsg = detailsMsg + '<strong>Expéditeur/Cash Point&nbsp;:&nbsp;</strong>' + param.TELEPHONE_EXPEDITEUR + '<br>';
    };
    detailsMsg = detailsMsg + '<strong>Destinataire &nbsp;:&nbsp;</strong>' + param.TELEPHONE_DESTINATAIRE + '<br>';
    detailsMsg = detailsMsg + '<strong>Libellé envoi &nbsp;:&nbsp;</strong>' + param.DETAIL_A + '<br>';
    if(paramAjaxFeedback == 'N'){
        detailsMsg = detailsMsg + '<strong>Username lu &nbsp;:&nbsp;</strong>' + (param.USERNAME_LU == null ? 'NA' : param.USERNAME_LU) + '<br>';
    }
    else{
      detailsMsg = detailsMsg + '<i class="recap-val"><span class="icon-check-square nav-icon-fa nav-text"></span>&nbsp;<strong>Username lu &nbsp;:&nbsp;</strong>' + (param.USERNAME_LU == null ? 'NA' : param.USERNAME_LU) + '</i><br>';
    }
    detailsMsg = detailsMsg + '<strong>Raison du rejet &nbsp;:&nbsp;</strong>' + (param.RAISON_REJET == null ? 'NA' : param.RAISON_REJET) + '<br>';

    detailsFile = detailsFile + '<strong>Fichier CSV &nbsp;:&nbsp;</strong>' + param.NOM_FICHIER + '<br>';
    detailsFile = detailsFile + '<strong>Date heure intégration fichier &nbsp;:&nbsp;</strong>' + param.DATE_HEURE_INTEGRATION + '<br>';
    detailsFile = detailsFile + '<strong>Solde fichier avant &nbsp;:&nbsp;</strong>' + renderAmount(param.SOLDE_FICHIER_AVANT) + '<br>';
    detailsFile = detailsFile + '<strong>Solde fichier après &nbsp;:&nbsp;</strong>' + renderAmount(param.SOLDE_FICHIER_APRES) + '<br>';
    
    $('#mvo-details-txt').html(detailsMsg);
    $('#mvo-file-txt').html(detailsFile + "<br><br>");
    
    //Check here if we can attribuer the payment
    if((param.STATUS_TRANSACTION ==  'NUD') && (parseInt(param.MONTANT_TRANSACTION) > 0 )){
      $('#assign-mvo').show(100);
    }
    else{
      //We do nothing as we cannot attribuer the mvola
      $('#assign-mvo').hide(100);
    };
    resetMvoAttribuer();

    $('#mvo-details-modal').modal('show');
}

function loadAllMVOGrid(){

    refMvoField = [
        { name: "REF_TRANSACTION",
          title: "Transaction",
          type: "text",
          width: 40,
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm-mono"
        },
        { name: "DATE_HEURE_TRANSACTION",
          title: "Date Heure",
          type: "text",
          width: 50,
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm"
        },
        { name: "STATUS_TRANSACTION",
          title: "Status",
          type: "text",
          width: 40,
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm",
          itemTemplate: function(value, item) {
            if(value == 'END'){
              return '<i class="status-ok">Valide</i>';
            }
            else if(value == 'NUD'){
              return '<i class="recap-nex"><i class="icon-exclamation-triangle nav-text"></i>&nbsp;Introuvable</i>';
            }
            else if(value == 'DUP'){
              return '<i class="recap-qui">Doublon</i>';
            }
            else if(value == 'ATT'){
              return '<i class="lin-war">Attribué</i>';
            }
            else{
              return '<i class="recap-mis">Invalide</i>';
            }
          }
        },
        { name: "MONTANT_TRANSACTION",
          title: "Montant",
          type: "number",
          width: 50,
          align: "right",
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm",
          itemTemplate: function(value, item) {
            return renderAmount(value);
          }
        },
        { name: "TELEPHONE_EXPEDITEUR",
          title: "Expéditeur",
          type: "text",
          width: 35,
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm-mono"
        },
        { name: "TELEPHONE_DESTINATAIRE",
          title: "Destinataire",
          type: "text",
          width: 35,
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm-mono"
        },
        //Default width is auto
        { name: "DETAIL_A",
          title: "Libellé",
          width: 60,
          type: "text",
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm-mono"
        },
        { name: "RAISON_REJET",
          title: "Raison du rejet",
          type: "text",
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm"
        }
    ];

    $("#jsGridAllMVO").jsGrid({
        height: "auto",
        width: "100%",
        noDataContent: "Aucun Mvola disponible",
        pageIndex: 1,
        pageSize: 50,
        pagePrevText: "Prec",
        pageNextText: "Suiv",
        pageFirstText: "Prem",
        pageLastText: "Dern",

        sorting: true,
        paging: true,
        data: filteredDataAllMVOToJsonArray,
        fields: refMvoField,
        rowClick: function(args){
              //fnd-usrn fnd-mvoid
              $('#fnd-mvoid').html(args.item.ULM_ID);
              showPopUpMvola(args.item, 'N');
        }
    });
}

function resetMvoAttribuer(){
      $('#addpay-ace').val('');
      $('#scan-mvo-input').show(100);
      $('#ctrl-name').html('');
      $('#last-read-bc').html('');
      $("#btn-attmvo").hide(100);
      $("#btn-canattmvo").hide(100);
      $("#att-case-pan").hide(100);
      $("#warn-partial-dic").html("");
      $('#warn-pay-msg').html("");
}

function mngMvoPayUserExists(val){
  // reinitialize the case operation 
  invCaseOperation = '0';

  let userPaidDTSTENT = 0;
  let userPaidDRTINSC = 0;
  let userPaidFRAIGEN = 0;

  const FRAIS_DTSTENT = parseInt(dataAllFixedFaresToJsonArray[0].amount);
  const FRAIS_DRTINSC = parseInt(dataAllFixedFaresToJsonArray[1].amount);
  const FRAIS_FRAIGEN = parseInt(dataAllFixedFaresToJsonArray[2].amount);
  const FRAIS_FRMVOLA = parseInt(dataAllFixedFaresToJsonArray[3].amount);

  const MSG_WARN_MIN_AMT = "<i class='icon-file-broken'></i>&nbsp;Certaines options sont indisponibles car montant insufissant.<br>";
  const MSG_WARN_NORM_ONLY = "<i class='icon-cubes'></i>&nbsp;Certaines options sont indisponibles car seul le cas [nouveau] est possible.<br>";
  const MSG_FRAIS_GENERAUX = "<i class='icon-puzzle-piece'></i>&nbsp;Les frais généraux FRAIGEN [" + renderAmount(FRAIS_FRAIGEN) + "] doivent être payés en une seule fois. Si le montant disponible ne suffit pas, ils vont automatiquement payer la prochaine tranche disponible. Ils faudra alors payer les frais généraux séparément.<br>";

  for (let i = 0; i < dataAllUSRNToJsonArray.length; i++) {
    if ((dataAllUSRNToJsonArray[i].USERNAME === val)
                 && (dataAllUSRNToJsonArray[i].USED_ON_SCREEN == 'N')){
      
      // We remove the flag
      dataAllUSRNToJsonArray[i].USED_ON_SCREEN =  'Y';
      $('#fnd-usrn').html(dataAllUSRNToJsonArray[i].USERNAME);

      $('#addpay-ace').val('');
      $('#scan-mvo-input').hide(100);
      $('#ctrl-name').html(dataAllUSRNToJsonArray[i].VSH_NAME + ' - ' + dataAllUSRNToJsonArray[i].CLASS);
      $("#btn-canattmvo").show(100);
      

      userPaidDTSTENT = parseInt(dataAllUSRNToJsonArray[i].c_DTSTENT_CPT);
      userPaidDRTINSC = parseInt(dataAllUSRNToJsonArray[i].c_DRTINSC_CPT);
      userPaidFRAIGEN = parseInt(dataAllUSRNToJsonArray[i].c_FRAIGEN_CPT);

      let warnPayBlueMsg = "";
      let displayWarnMinimumAmountMsg = 'N';
      /* 
      userPaidDTSTENT/userPaidDRTINSC
      0/0 >>> Open all cases >>> Y
      + FRAIGEN
      0/1 >>> Open all cases >>> Y
      + FRAIGEN
      1/0 >>> Open all cases >>> Y
      + FRAIGEN
      1/1 >>> Close all cases >>> N
      + FRAIGEN
      dataAllFixedFaresToJsonArray

      */

      // *********************************************************************************
      // *********************************************************************************
      // *********************************************************************************
      // *********************************************************************************
      // *********************************************************************************
      // *********************************************************************************
      // Manage the discount button behavor

      // Show specific to the cases
      // Do something witht the amount : invMVOAmountNUD
      // All cases are closed
      //console.log('userPaidDTSTENT: ' + userPaidDTSTENT);
      //console.log('userPaidDRTINSC: ' + userPaidDRTINSC);
      if((userPaidDTSTENT > 0) && (userPaidDRTINSC > 0)){
          // DISPLAY BAR PAY
          $("#btn-attmvo").show(100);
          // The discount panel is here
          $("#att-case-pan").hide(100);
          $("#warn-partial-dic").html("");
      }
      else{

        /* 
        userPaidDTSTENT/userPaidDRTINSC
        0/0 >>> Open all cases >>> Y
        + FRAIGEN
        0/1 >>> We close A and T because we must be normal only. If we are A or T, we pay in once.
        + FRAIGEN
        1/0 >>> We close A and T because we must be normal only. If we are A or T, we pay in once.
        + FRAIGEN
        */
        // TO DO
        // The strategy may be to identify the open frais not yet paid which are zero and open them
        // Do the case by case DTSTENT DRTINSC
        const CURRENT_LEFT_NORMAL_AMT = parseInt(FRAIS_DTSTENT) + parseInt(FRAIS_DRTINSC) + parseInt(FRAIS_FRMVOLA) - parseInt(userPaidDTSTENT) - parseInt(userPaidDRTINSC);
        $('#disc-left-case-n').html(renderAmount(CURRENT_LEFT_NORMAL_AMT));

        // For the rest I need to do remove part by part
        // FRAIS_FRMVOLA to add at the end
        // dataAllSetUpDiscountToJsonArray
        let currentLeftDTSTENTNormalBased =  FRAIS_DTSTENT - parseInt(userPaidDTSTENT);
        let currentLeftDRTINSCNormalBased =  FRAIS_DRTINSC - parseInt(userPaidDRTINSC);

        let currentLeftDTSTENTAncienBased =  currentLeftDTSTENTNormalBased - parseInt(dataAllSetUpDiscountToJsonArray[0].DIS_AMOUNT);
        let currentLeftDRTINSCAncienBased =  currentLeftDRTINSCNormalBased - parseInt(dataAllSetUpDiscountToJsonArray[1].DIS_AMOUNT);

        const CURRENT_LEFT_ANCIEN_AMT = (parseInt(currentLeftDTSTENTAncienBased) + parseInt(currentLeftDRTINSCAncienBased) + parseInt(FRAIS_FRMVOLA)) > 0 ? parseInt(currentLeftDTSTENTAncienBased) + parseInt(currentLeftDRTINSCAncienBased) + parseInt(FRAIS_FRMVOLA) : 0;
        $('#disc-left-case-a').html(renderAmount(CURRENT_LEFT_ANCIEN_AMT));

        let currentLeftDTSTENTTransfertBased =  parseInt(currentLeftDTSTENTNormalBased) - parseInt(dataAllSetUpDiscountToJsonArray[2].DIS_AMOUNT);
        let currentLeftDRTINSCTransfertBased =  parseInt(currentLeftDRTINSCNormalBased) - parseInt(dataAllSetUpDiscountToJsonArray[3].DIS_AMOUNT);

        const CURRENT_LEFT_TRANSFERT_AMT = (parseInt(currentLeftDTSTENTTransfertBased) + parseInt(currentLeftDRTINSCTransfertBased) + parseInt(FRAIS_FRMVOLA)) > 0 ? parseInt(currentLeftDTSTENTTransfertBased) + parseInt(currentLeftDRTINSCTransfertBased) + parseInt(FRAIS_FRMVOLA) : 0;
        $('#disc-left-case-t').html(renderAmount(CURRENT_LEFT_TRANSFERT_AMT));

        
        // NOUVEAU
        // We remove the already paid always
        if((invMVOAmountNUD >= (CURRENT_LEFT_NORMAL_AMT)) &&
                  (CURRENT_LEFT_NORMAL_AMT > FRAIS_FRMVOLA)){
          // Check if we can show Normal
          //console.log('1 N');
          $("#btn-case-1").removeClass('deactive-btn');
        }
        else{
          //console.log('0 N');
          displayWarnMinimumAmountMsg = 'Y';
          $("#btn-case-1").addClass('deactive-btn');
        }

        if(userPaidDTSTENT > 0){
          $("#warn-partial-dic").html('<span class="icon-exclamation-triangle nav-icon-fa nav-text"></span>&nbsp;ATTENTION : Des droits concours ou entretien DTSTENT [' + renderAmount(userPaidDTSTENT) + '] ont déjà été réglé, il ne reste que les droits inscription DRTINSC à régler. Veuillez vérifier dans le dashboard via le manager étudiant.');
          
        }
        if(userPaidDRTINSC > 0){
          $("#warn-partial-dic").html('<span class="icon-exclamation-triangle nav-icon-fa nav-text"></span>&nbsp;ATTENTION : Des droits inscription DRTINSC [' + renderAmount(userPaidDRTINSC) + '] ont déjà été réglé, il ne reste que les droits concours ou entretien DTSTENT à régler. Veuillez vérifier dans le dashboard via le manager étudiant.');

        }
        
        if((userPaidDTSTENT > 0) || (userPaidDRTINSC > 0)){
          //console.log('0 A');
          $("#btn-case-2").addClass('deactive-btn');
          //console.log('0 T');
          $("#btn-case-3").addClass('deactive-btn');
          warnPayBlueMsg = warnPayBlueMsg + MSG_WARN_NORM_ONLY;
        }
        else{
            // Aucun des deux n'est payé
            // ANCIEN
            if((invMVOAmountNUD >= (CURRENT_LEFT_ANCIEN_AMT)) &&
                    (CURRENT_LEFT_ANCIEN_AMT > FRAIS_FRMVOLA)){
            // Check if we can show Ancien
            //console.log('1 A');
            $("#btn-case-2").removeClass('deactive-btn');
            }
            else{
              $("#btn-case-2").addClass('deactive-btn');
              displayWarnMinimumAmountMsg = 'Y';
            }
            // TRANSFERT
            if((invMVOAmountNUD >= (CURRENT_LEFT_TRANSFERT_AMT))&&
                    (CURRENT_LEFT_TRANSFERT_AMT > FRAIS_FRMVOLA)){
            // Check if we can show Transfert
            //console.log('1 T');
            $("#btn-case-3").removeClass('deactive-btn');
            }
            else{
              $("#btn-case-3").addClass('deactive-btn');
              displayWarnMinimumAmountMsg = 'Y';
            }
        }

        $("#btn-attmvo").hide(100);
        // The discount panel is here
        $("#att-case-pan").show(100);
      }
      if(displayWarnMinimumAmountMsg == 'Y'){
        warnPayBlueMsg = warnPayBlueMsg + MSG_WARN_MIN_AMT;
      }
      //console.log('userPaidFRAIGEN: ' + userPaidFRAIGEN);
      if(userPaidFRAIGEN == 0){
        warnPayBlueMsg = warnPayBlueMsg + MSG_FRAIS_GENERAUX;
      }
      $('#warn-pay-msg').html(warnPayBlueMsg);

      return true;
    }
    else if((dataAllUSRNToJsonArray[i].USERNAME === val)){
      // We need to say that the student has already get an attribution we need to reload the page
      resetMvoAttribuer();
      $('#warn-pay-msg').html("<i class='icon-file-broken'></i>&nbsp;Un mvola a déjà été attribué a cet étudiant, rechargez/rafraîchissez la page.<br>");
      return false;
    }
    else{
      // Do nothing
    }
  }
  resetMvoAttribuer();
  return false;
}

function verifyMvoContentScan(){

  $('#type-alert').addClass('alert-primary').removeClass('alert-danger');
  $('#ace-alert-msg').hide(100);
  


  if ($('#addpay-ace').val().length == 10){

    let originalRedInput = $('#addpay-ace').val();
    let readInput = $('#addpay-ace').val().replace(/[^a-z0-9]/gi,'').toUpperCase();
    let convertParamValue = convertWordAZERTY(readInput).toUpperCase();
    //console.log("Diagnostic 2 Read Input : " + readInput.length + ' : ' + readInput + ' - ' + originalRedInput + ' 0/' + convertWordAZERTY(originalRedInput) + ' 1/' + convertWordAZERTY(originalRedInput).toUpperCase() + ' 2/' + convertWordAZERTY(originalRedInput).toUpperCase().replace(/[^a-z0-9]/gi,'') + ' 3/' + convertWordAZERTY(originalRedInput).toLowerCase().replace(/[^a-z0-9]/gi,''));

    if(readInput.length < 10){
      // We are on the wrong keyboard config as it must be 10
      readInput = convertWordAZERTY(originalRedInput).replace(/[^a-z0-9]/gi,'').toUpperCase();
    }

    let scanValidToDisplay = ' <i class="mgs-rd-o-err">&nbsp;ERR91Format&nbsp;</i>';
    // Here we check the format
    if(/[a-zA-Z0-9]{9}[0-9]/.test(readInput)){
      // Only if the read is clean

      
      //console.log('Read input 1 convertWordAZERTY');
      /*****************************/
      /*****************************/
      /*****************************/
      /*** UGLY BUG FIX Conversion */
      /*****************************/
      /*****************************/
      /*****************************/
      if(mngMvoPayUserExists(convertParamValue)){
        readInput = convertParamValue;
        $('#addpay-ace').val(readInput);
        /********************************************************** FOUND **********************************************************/
        scanValidToDisplay = ' <i class="mgs-rd-o-in">&nbsp;Étudiant valide&nbsp;</i>';
        //Allow button enabled
      }
      else if(mngMvoPayUserExists(readInput)){
        /********************************************************** FOUND **********************************************************/
        scanValidToDisplay = ' <i class="mgs-rd-o-in">&nbsp;Étudiant valide&nbsp;</i>';
        //Allow button enabled

      }
      else{
        /******************************************************** NOT FOUND ********************************************************/
        scanValidToDisplay = ' <i class="mgs-rd-o-err">&nbsp;Étudiant introuvable&nbsp;</i>';
      }
    }
    else{
        // If we are on the pay screen we need to do somthing
        // We do not match a username
    }

    //console.log('We have read: ' + $('#addpay-ace').val());
    $('#last-read-bc').html(readInput + scanValidToDisplay);

    // Save for any internet issue here
    //$("#btn-load-bc").show();



  }
  else if($('#addpay-ace').val().length > 10) {
    // Great length
    $('#addpay-ace').val('');
    resetMvoAttribuer();

  }
  else {
    //Do nothing
  }
}


// Fill once for good the data in the discount
// Duplicate code for Add pay in aceidentificationcommon
function displayMVODiscount(){
  const FRAIS_FRMVOLA = dataAllFixedFaresToJsonArray[3].amount;
  if(dataAllDispDiscountToJsonArray.length > 0){
    $("#disc-case-n").html(renderAmount(parseInt(dataAllDispDiscountToJsonArray[0].GENUINE_AMOUNT) + parseInt(FRAIS_FRMVOLA)));
    for(let j=0; j < dataAllDispDiscountToJsonArray.length; j++){
      $("#disc-case-" + dataAllDispDiscountToJsonArray[j].DIS_CASE.toLowerCase()).html(renderAmount(parseInt(dataAllDispDiscountToJsonArray[j].FINAL_AMOUNT) + parseInt(FRAIS_FRMVOLA)));
    }
  }
  else{
    console.log('Reading discount ref: Err1890');
  }
}

function initializeMVODiscountButton(){
  for(let m=1; m<4; m++){
    // Add listener
    // Avoid multiple call
    //$("#btn-case-" + m).off('click');
    //$( "#btn-case-" + m).click(function() {
    $("#btn-case-" + m).off().on('click', function() {

        if(m == 1){
          // Nouveau
          // 200 000AR
          invCaseOperation = 'N';
          //console.log('You clicked on the case N');
        }
        else if(m == 2){
          // Ancien
          // 100 000AR
          invCaseOperation = 'A';
          //console.log('You clicked on the case A');
        }
        else{
          //m == 3
          // Transfert
          // 150 000AR
          invCaseOperation = 'T';
          //console.log('You clicked on the case T');
        }
        generateAttribuerMvo();
    });

  }
}


/***********************************************************************************************************/

$(document).ready(function() {
    console.log('We are in ACE-PAYBASIC');
  
    if($('#mg-graph-identifier').text() == 'man-mvo'){
      // Do something
      console.log('in man-mvo');
      loadAllMVOGrid();
      initAllMVOGrid();
      
      // Init Discount
      displayMVODiscount();
      initializeMVODiscountButton();
      $("#frais-mvola-disp").html(renderAmount(parseInt(dataAllFixedFaresToJsonArray[3].amount)));
      // Do something
      $( "#addpay-ace" ).keyup(function() {
        verifyMvoContentScan();
      });

      // Add click listener with unique firing event
      $("#btn-attmvo").off().on('click', function() {
        generateAttribuerMvo();
      });
    }
    else if($('#mg-graph-identifier').text() == 'man-pay'){
      // Do something
      console.log('in man-pay');
      loadAllPAYGrid();
      initAllPAYGrid();
    }
    else if($('#mg-graph-identifier').text() == 'xxx'){
      // Do something
    }
    else{
      //Do nothing
    }
  
  
  
  });