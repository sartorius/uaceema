
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
                    + "Prénom" + SEP_ 
                    + "Nom" + SEP_ 
                    + "Matricule" + SEP_ 
                    + "Transaction Mvola" + SEP_ 
                    + "Expéditeur Mvola" + SEP_ 
                    + "Libellé Mvola" + SEP_ 
                    + "Ticket réduction" + SEP_ 
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
                + isNullMvo(involvedArray[i].VSH_FIRSTNAME) + SEP_ 
                + isNullMvo(involvedArray[i].VSH_LASTNAME) + SEP_ 
                + isNullMvo(involvedArray[i].VSH_MATRICULE) + SEP_ 
                + isNullMvo(involvedArray[i].MVO_TRANSACTION) + SEP_ 
                + isNullMvo(involvedArray[i].MVO_FROM_PHONE) + SEP_
                + isNullMvo(involvedArray[i].MVO_DETAILS_A) + SEP_ 
                + isNullMvo(involvedArray[i].UFP_TICKET) + SEP_ 
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
    link.download = 'RapportGlobalMvola.csv';
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
        if(dataAllPAYToJsonArray[i].UP_ID === val){
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
    detailsMsg = detailsMsg + '<strong>Montant &nbsp;:&nbsp;</strong>' + formatterCurrency.format(param.UP_INPUT_AMOUNT).replace("MGA", "AR") + '<br>';
    detailsMsg = detailsMsg + '<strong>Status &nbsp;:&nbsp;</strong>' + verboseStatusOfPayment(param.UP_STATUS) + '<br>';
    detailsMsg = detailsMsg + '<strong>Type &nbsp;:&nbsp;</strong>' + verboseTypeOfPayment(param.UP_TYPE_OF_PAYMENT) + '<br>';
    detailsMsg = detailsMsg + '<strong>Commentaire &nbsp;:&nbsp;</strong>' + isNullMvo(param.UP_COMMENT) + '<br><br>';
    detailsMsg = detailsMsg + '<strong>Code de référence &nbsp;:&nbsp;</strong>' + param.REF_CODE + '<br>';
    detailsMsg = detailsMsg + '<strong>Description Paiement &nbsp;:&nbsp;</strong>' + param.REF_DESCRIPTION + '<br>';
    detailsMsg = detailsMsg + '<strong>Limite Paiement &nbsp;:&nbsp;</strong>' + param.REF_DDL + '<br>';
    detailsMsg = detailsMsg + '<strong>Montant de référence &nbsp;:&nbsp;</strong>' + formatterCurrency.format(param.REF_AMOUNT).replace("MGA", "AR") + '<br><br>';
    detailsMsg = detailsMsg + '<strong>Classe &nbsp;:&nbsp;</strong>' + param.VSH_SHORT_CLASS + '<br>';
    detailsMsg = detailsMsg + '<strong>Prénom &nbsp;:&nbsp;</strong>' + param.VSH_FIRSTNAME + '<br>';
    detailsMsg = detailsMsg + '<strong>Nom &nbsp;:&nbsp;</strong>' + param.VSH_LASTNAME + '<br>';
    detailsMsg = detailsMsg + '<strong>Matricule &nbsp;:&nbsp;</strong>' + param.VSH_MATRICULE + '<br>';

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
      else{
        return 'Erreur 892B';
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
            return formatterCurrency.format(value).replace("MGA", "AR");
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
          width: 40,
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
        { name: "UFP_TICKET",
          title: "Ticket",
          width: 40,
          type: "text",
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm-mono"
        },
        { name: "UP_ID",
          title: "Détails",
          width: 20,
          type: "text",
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm-center",
          itemTemplate: function(value, item) {
            //return value + '%';
            return '<button onclick="getRawPaymentDetail(' + value +  ')" class="btn btn-outline-dark"><i class="icon-eye"></i></button>';
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
        fields: refPayField,
        rowClick: function(args){
            goToSTUFromPayMngr(args.item.PAGE);
        }
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
    loadAllMVOGrid();
  };
  
  
  /*****************************************************************************************/
  /*****************************************************************************************/
  /*****************************************************************************************/
  /**************************  END FILTER FUNTION  *****************************************/
  /*****************************************************************************************/
  /*****************************************************************************************/
  /*****************************************************************************************/
  
function isNullMvo(param){
    return (param ==  null ? '' : param);
}

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

function verboseStatus(paramValue){
    if(paramValue == 'END'){
        return "Transaction valide";
      }
      else if(paramValue == 'NUD'){
        return 'Username introuvable. Vérifier que le username envoyé par Mvola est valide.';
      }
      else if(paramValue == 'DUP'){
        return 'Doublon - référence déjà intégrée';
      }
      else{
        return 'Ligne invalide';
      }
}

function showPopUpMvola(param){
    let detailsMsg = '';
    let detailsFile = '';
    $('#title-mvo-details').html(param.REF_TRANSACTION);
    detailsMsg = detailsMsg + '<strong>Date heure de transaction &nbsp;:&nbsp;</strong>' + param.DATE_HEURE_TRANSACTION + '<br>';
    detailsMsg = detailsMsg + '<strong>Date heure de transaction lu &nbsp;:&nbsp;</strong>' + param.DATE_HEURE_TRANSACTION_LU + '<br>';
    detailsMsg = detailsMsg + '<strong>Status &nbsp;:&nbsp;</strong>' + verboseStatus(param.STATUS_TRANSACTION) + '<br>';
    detailsMsg = detailsMsg + '<strong>Type &nbsp;:&nbsp;</strong>' + param.TYPE_TRANSACTION + '<br>';
    detailsMsg = detailsMsg + '<strong>Montant &nbsp;:&nbsp;</strong>' + formatterCurrency.format(param.MONTANT_TRANSACTION).replace("MGA", "AR") + '<br>';
    detailsMsg = detailsMsg + '<strong>Expéditeur &nbsp;:&nbsp;</strong>' + param.TELEPHONE_EXPEDITEUR + '<br>';
    detailsMsg = detailsMsg + '<strong>Destinataire &nbsp;:&nbsp;</strong>' + param.TELEPHONE_DESTINATAIRE + '<br>';
    detailsMsg = detailsMsg + '<strong>Libellé envoi &nbsp;:&nbsp;</strong>' + param.DETAIL_A + '<br>';
    detailsMsg = detailsMsg + '<strong>Username lu &nbsp;:&nbsp;</strong>' + (param.USERNAME_LU == null ? 'NA' : param.USERNAME_LU) + '<br>';
    detailsMsg = detailsMsg + '<strong>Raison du rejet &nbsp;:&nbsp;</strong>' + (param.RAISON_REJET == null ? 'NA' : param.RAISON_REJET) + '<br>';

    detailsFile = detailsFile + '<strong>Fichier CSV &nbsp;:&nbsp;</strong>' + param.NOM_FICHIER + '<br>';
    detailsFile = detailsFile + '<strong>Date heure intégration fichier &nbsp;:&nbsp;</strong>' + param.DATE_HEURE_INTEGRATION + '<br>';
    detailsFile = detailsFile + '<strong>Solde fichier avant &nbsp;:&nbsp;</strong>' + formatterCurrency.format(param.SOLDE_FICHIER_AVANT).replace("MGA", "AR") + '<br>';
    detailsFile = detailsFile + '<strong>Solde fichier après &nbsp;:&nbsp;</strong>' + formatterCurrency.format(param.SOLDE_FICHIER_APRES).replace("MGA", "AR") + '<br>';
    
    $('#mvo-details-txt').html(detailsMsg);
    $('#mvo-file-txt').html(detailsFile + "<br><br>");
    
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
            return formatterCurrency.format(value).replace("MGA", "AR");
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
              showPopUpMvola(args.item);
        }
    });
}

/***********************************************************************************************************/

$(document).ready(function() {
    console.log('We are in ACE-PAYBASIC');
  
    if($('#mg-graph-identifier').text() == 'man-mvo'){
      // Do something
      console.log('in man-mvo');
      loadAllMVOGrid();
      initAllMVOGrid();
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