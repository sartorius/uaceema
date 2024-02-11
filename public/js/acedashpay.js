
    /*
      
    let cobCashOfTheDay = 0;
    let cobCheqOfTheDay = 0;
    let cobVirmTpeOfTheDay = 0;
    let cobReductionOfTheDay = 0;
    let cobTotalOfTheDay = 0;


    let cobBenefitOfTheYear = 0;
    let cobReductionOfTheYear = 0;
    let cobNbrCheqOfTheDay = 0;
    let cobSoldeMvola = 0;
      
    */
/*
function renderAmount(param){
    var len = param.toString().length;
    var result = '';
    var k = 0;
    for(let i=0;i<len+1;i++){
        result = param.toString().substr(len-i,1) + result;
        if(k == 3){
            result = '.' + result;
            k = 0;
        }
        k++;
    }
    return result + '.AR';
}
*/

function generateRecetteJourneeCSV(){
  const csvContentType = "data:text/csv;charset=utf-8,";
  let csvContent = "";
  let involvedArray = dataRepRecetteJourneeJsonArray;
  const SEP_ = ";"

  let today = new Date();
    let date = today.getDate().toString().padStart(2, '0')+'/'+(today.getMonth()+1).toString().padStart(2, '0')+'/'+today.getFullYear();
    let time = today.getHours().toString().padStart(2, '0') + ":" + today.getMinutes().toString().padStart(2, '0') + ":" + today.getSeconds().toString().padStart(2, '0');
    let dateTime = date+' à '+time;

let dataString;

dataString = "Référence" + SEP_ 
                  + "Matricule" + SEP_ 
                  + "Réference de Paiement" + SEP_ 
                  + "Code de référence" + SEP_ 
                  + "Nom" + SEP_ 
                  + "Prénom" + SEP_
                  + "Type" + SEP_
                  + "Recette INFORMATIQUE ELECTRONIQUE" + SEP_ 
                  + "Recette GESTION" + SEP_ 
                  + "Recette COMMUNICATION" + SEP_ 
                  + "Recette DROIT" + SEP_ 
                  + "Recette SCIENCES DE LA SANTE" + SEP_ 
                  + "Recette MBS" + SEP_ 
                  + "Recette ECONOMIE" + SEP_ 
                  + "Recette RELATIONS INTERNATIONALES DIPLOMATIQUES" + SEP_ 
                  + "Recette DIVERS" + SEP_ 
                  + "Commentaire" + SEP_ + "\n";
csvContent += dataString;

let computeTotalINFOE = 0;
let computeTotalGESTI = 0;
let computeTotalCOMMU = 0;
let computeTotalDROIT = 0;
let computeTotalSIENS = 0;
let computeTotalMBSXX = 0;
let computeTotalECONO = 0;
let computeTotalRIDXX = 0;
let computeTotalDIVERS = 0;

for(let i=0; i<involvedArray.length; i++){

          dataString = involvedArray[i].UP_PAYMENT_REF + SEP_ 
              + isNullMvo(involvedArray[i].VSH_MATRICULE) + SEP_ 
              + isNullMvo(involvedArray[i].REF_DESCRIPTION) + SEP_ 
              + isNullMvo(involvedArray[i].REF_CODE) + SEP_ 
              + isNullMvo(involvedArray[i].VSH_LASTNAME) + SEP_ 
              + isNullMvo(involvedArray[i].VSH_FIRSTNAME) + SEP_ 
              + verboseTypeOfPayment(involvedArray[i].UP_TYPE_OF_PAYMENT) + SEP_ ;

          if((involvedArray[i].REF_CODE == 'CERTSCO') || (involvedArray[i].REF_CODE == 'CARTEET') || (involvedArray[i].REF_CODE == 'CERTIFC')){
            dataString = dataString + SEP_  + SEP_ + SEP_  + SEP_ + SEP_ + SEP_ + SEP_ + SEP_ + isNullMvo(involvedArray[i].UP_INPUT_AMOUNT) + SEP_ + isNullMvo(involvedArray[i].UP_COMMENT) + SEP_;
            computeTotalDIVERS = computeTotalDIVERS + parseInt(involvedArray[i].UP_INPUT_AMOUNT);
          }
          else{
            switch(involvedArray[i].VCC_MENTION_CODE) {
                  case 'INFOE':
                    // code block
                    dataString = dataString + isNullMvo(involvedArray[i].UP_INPUT_AMOUNT) + SEP_  + SEP_ + SEP_  + SEP_ + SEP_ + SEP_ + SEP_ + SEP_ + SEP_ + isNullMvo(involvedArray[i].UP_COMMENT) + SEP_;
                    computeTotalINFOE = computeTotalINFOE + parseInt(involvedArray[i].UP_INPUT_AMOUNT);
                    break;
                  case 'GESTI':
                    // code block
                    dataString = dataString + SEP_  + isNullMvo(involvedArray[i].UP_INPUT_AMOUNT) + SEP_ + SEP_  + SEP_ + SEP_ + SEP_ + SEP_ + SEP_ + SEP_ + isNullMvo(involvedArray[i].UP_COMMENT) + SEP_;
                    computeTotalGESTI = computeTotalGESTI + parseInt(involvedArray[i].UP_INPUT_AMOUNT);
                    break;
                  case 'COMMU':
                    // code block
                    dataString = dataString + SEP_  + SEP_ + isNullMvo(involvedArray[i].UP_INPUT_AMOUNT) + SEP_  + SEP_ + SEP_ + SEP_ + SEP_ + SEP_ + SEP_ + isNullMvo(involvedArray[i].UP_COMMENT) + SEP_;
                    computeTotalCOMMU = computeTotalCOMMU + parseInt(involvedArray[i].UP_INPUT_AMOUNT);
                    break;
                  case 'DROIT':
                    // code block
                    dataString = dataString + SEP_  + SEP_ + SEP_  + isNullMvo(involvedArray[i].UP_INPUT_AMOUNT) + SEP_ + SEP_ + SEP_ + SEP_ + SEP_ + SEP_ + isNullMvo(involvedArray[i].UP_COMMENT) + SEP_;
                    computeTotalDROIT = computeTotalDROIT + parseInt(involvedArray[i].UP_INPUT_AMOUNT);
                    break;
                  case 'SIENS':
                    // code block
                    dataString = dataString + SEP_  + SEP_ + SEP_  + SEP_ + isNullMvo(involvedArray[i].UP_INPUT_AMOUNT) + SEP_ + SEP_ + SEP_ + SEP_ + SEP_ + isNullMvo(involvedArray[i].UP_COMMENT) + SEP_;
                    computeTotalSIENS = computeTotalSIENS + parseInt(involvedArray[i].UP_INPUT_AMOUNT);
                    break;
                  case 'MBSXX':
                    // code block
                    dataString = dataString + SEP_  + SEP_ + SEP_  + SEP_ + SEP_ + isNullMvo(involvedArray[i].UP_INPUT_AMOUNT) + SEP_ + SEP_ + SEP_ + SEP_ + SEP_ + isNullMvo(involvedArray[i].UP_COMMENT) + SEP_;
                    computeTotalMBSXX = computeTotalMBSXX + parseInt(involvedArray[i].UP_INPUT_AMOUNT);
                    break;
                  case 'ECONO':
                    // code block
                    dataString = dataString + SEP_  + SEP_ + SEP_  + SEP_ + SEP_ + SEP_ + isNullMvo(involvedArray[i].UP_INPUT_AMOUNT) + SEP_ + SEP_ + SEP_ + isNullMvo(involvedArray[i].UP_COMMENT) + SEP_;
                    computeTotalECONO = computeTotalECONO + parseInt(involvedArray[i].UP_INPUT_AMOUNT);
                    break;
                  default:
                    // code block
                    // RIDXX
                    dataString = dataString + SEP_  + SEP_ + SEP_  + SEP_ + SEP_ + SEP_ + SEP_ + isNullMvo(involvedArray[i].UP_INPUT_AMOUNT) + SEP_ + SEP_ + isNullMvo(involvedArray[i].UP_COMMENT) + SEP_;
                    computeTotalRIDXX = computeTotalRIDXX + parseInt(involvedArray[i].UP_INPUT_AMOUNT);
                    break;
                };
          }

          // easy close here
          csvContent += i < involvedArray.length ? dataString+ "\n" : dataString;
}

dataString = SEP_  + SEP_ + SEP_ + SEP_ + SEP_ + SEP_ + 'Total par mention' + SEP_ ;
dataString = dataString + computeTotalINFOE + SEP_ + computeTotalGESTI + SEP_ + computeTotalCOMMU + SEP_ + computeTotalDROIT + SEP_ + computeTotalSIENS + SEP_ + computeTotalMBSXX + SEP_ + computeTotalECONO + SEP_ + computeTotalRIDXX + SEP_ + computeTotalDIVERS + SEP_+ SEP_;
csvContent += dataString + "\n" ;

dataString = SEP_  + SEP_ + SEP_ + SEP_ + SEP_ + SEP_ + SEP_ + SEP_ ;
dataString = dataString + SEP_ + SEP_ + SEP_ + SEP_ + SEP_ + SEP_ + 'Total journée' + SEP_ + (computeTotalRIDXX + computeTotalECONO + computeTotalMBSXX + computeTotalSIENS + computeTotalDROIT + computeTotalCOMMU + computeTotalGESTI + computeTotalDIVERS) + SEP_ + SEP_+ SEP_;
csvContent += dataString + "\n" ;

dataString = SEP_  + SEP_ + SEP_ + SEP_ + SEP_ + SEP_ + SEP_ + SEP_ ;
dataString = dataString + SEP_ + SEP_ + SEP_ + SEP_ + SEP_ + SEP_ + 'Total hier (à remplir)' + SEP_ + SEP_ + SEP_+ SEP_;
csvContent += dataString + "\n" ;

dataString = "Date de pointage" + SEP_ + dateTime + SEP_ + SEP_ + SEP_ + SEP_ + SEP_ + SEP_ ;
dataString = dataString + SEP_ + SEP_ + SEP_ + SEP_ + SEP_ + SEP_ + SEP_ + SEP_ + SEP_+ SEP_;
csvContent += dataString + "\n";

  //console.log('Click on csv');
  let encodedUri = encodeURI(csvContent);
  let csvData = new Blob([csvContent], { type: csvContentType });

      let link = document.createElement("a");
  let csvUrl = URL.createObjectURL(csvData);

  link.href =  csvUrl;
  link.style = "visibility:hidden";
  link.download = 'RapportRecetteJournee.csv';
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
}


function printCloseOfBusinessPDF(title, paramArray){

    // Document of 210mm wide and 297mm high > A4
    // new jsPDF('p', 'mm', [297, 210]);
    // Here format A7
    let doc = new jsPDF('p', 'mm', [(55 + (paramArray.length * 7)), 75]);
  
    doc.setFont("Courier");
    doc.setFontType("bold");
    doc.setTextColor(0, 0, 0);
  
  
    doc.addImage(document.getElementById('logo-carte'), //img src
                  'PNG', //format
                  11, //x oddOffsetX is to define if position 1 or 2
                  10, //y
                  50, //Width
                  16, null, 'FAST'); //Height // Fast is to get less big files


    let today = new Date();
    let tdate = today.getFullYear()+'-'+(today.getMonth()+1).toString().padStart(2, '0')+'-'+today.getDate().toString().padStart(2, '0');
    let date = today.getDate().toString().padStart(2, '0')+'/'+(today.getMonth()+1).toString().padStart(2, '0')+'/'+today.getFullYear();
    let time = today.getHours().toString().padStart(2, '0') + ":" + today.getMinutes().toString().padStart(2, '0') + ":" + today.getSeconds().toString().padStart(2, '0');
    let ttime = today.getHours().toString().padStart(2, '0') + today.getMinutes().toString().padStart(2, '0') + today.getSeconds().toString().padStart(2, '0');
    let dateTime = date+' à '+time;
  
    doc.setFontSize(10);
    doc.text(7, 35, title + ' ' + dateTime);
  
    doc.setFontSize(7);
    doc.setFontType("normal");
    //doc.text(18, 25, "REDUCTION 50%");
    let margTop = 59;
    let contentHeight = 0;
    doc.setFontSize(8);
    for(let i=0; i<paramArray.length; i++){
      contentHeight = margTop + (i*5);
      doc.text(maxPadLeft, contentHeight, paramArray[i]);
    }
  
    contentHeight = contentHeight + 40;
    doc.setFontSize(5);
    let filename = 'COB_' + title + '_' + tdate + ttime;
    doc.text(5, contentHeight, "REF_Fich_" + filename + "_FRAIS");
  
    doc.save(filename);
  
    $('#msg-alert').html('Le ticket ' + filename + '.pdf a bien été généré');
    $('#type-alert').addClass('alert-primary').removeClass('alert-danger');
    $('#ace-alert-msg').show(100);
}




function generateAllTrancheCSV(){
    const csvContentType = "data:text/csv;charset=utf-8,";
    let csvContent = "";
    let involvedArray = dataRepAllTrancheJsonArray;
    const SEP_ = ";"

	let dataString = "Username" + SEP_ 
                    + "Matricule" + SEP_ 
                    + "Prénom" + SEP_ 
                    + "Nom" + SEP_ 
                    + "Classe" + SEP_ 
                    + "Téléphone" + SEP_ 
                    + "Téléphone parent" + SEP_ 
                    + "Description" + SEP_ 
                    + "Code" + SEP_ 
                    + "Déjà payé" + SEP_ 
                    + "Reste à payer" + SEP_ 
                    + "Montant tranche" + SEP_ 
                    + "Date limite" + SEP_ 
                    + "Jours de retard" + SEP_ + "\n";
	csvContent += dataString;
	for(let i=0; i<involvedArray.length; i++){

            dataString = involvedArray[i].VSH_USERNAME + SEP_ 
                + involvedArray[i].VSH_MATRICULE + SEP_ 
                + involvedArray[i].VSH_FIRSTNAME + SEP_ 
                + involvedArray[i].VSH_LASTNAME + SEP_ 
                + involvedArray[i].VSH_SHORTCLASS + SEP_ 
                + involvedArray[i].VSH_PHONE + SEP_ 
                + involvedArray[i].VSH_PARENT_PHONE + SEP_ 
                + involvedArray[i].DESCRIPTION + SEP_ 
                + involvedArray[i].TRANCHE_CODE + SEP_ 
                + involvedArray[i].ALREADY_PAID + SEP_ 
                + involvedArray[i].REST_TO_PAY + SEP_ 
                + involvedArray[i].TRANCHE_AMOUNT + SEP_ 
                + involvedArray[i].TRANCHE_DDL + SEP_ 
                + involvedArray[i].NEGATIVE_IS_LATE + SEP_ ;
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
    link.download = 'RapportGlobalTrancheEtudiant.csv';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);

}

function generateAllReductionCSV(){
    const csvContentType = "data:text/csv;charset=utf-8,";
    let csvContent = "";
    let involvedArray = dataRepAllReductionJsonArray;
    const SEP_ = ";"

	let dataString = "Référence" + SEP_ 
                    + "Username" + SEP_ 
                    + "Montant" + SEP_ 
                    + "Date de paiement" + SEP_ 
                    + "Type de réduction" + SEP_ 
                    + "Matricule" + SEP_ 
                    + "Prénom" + SEP_ 
                    + "Nom" + SEP_ 
                    + "Classe" + SEP_ 
                    + "Ticket" + SEP_ 
                    + "Pourcentage réduction" + SEP_ + "\n";
	csvContent += dataString;
	for(let i=0; i<involvedArray.length; i++){

            dataString = involvedArray[i].UP_PAY_REF + SEP_ 
                + involvedArray[i].VSH_USERNAME + SEP_ 
                + involvedArray[i].UP_AMOUNT + SEP_ 
                + involvedArray[i].UP_PAY_DATE + SEP_ 
                + (involvedArray[i].UP_TYPE_OF_PAYMENT == 'L' ? "Lettre engagement" : "Reduction") + SEP_ 
                + involvedArray[i].VSH_MATRICULE + SEP_ 
                + involvedArray[i].VSH_FIRSTNAME + SEP_ 
                + involvedArray[i].VSH_LASTNAME + SEP_ 
                + involvedArray[i].VSH_SHORTCLASS + SEP_ 
                + involvedArray[i].UFP_TICKET + SEP_ 
                + involvedArray[i].REDUCTION_PC + SEP_ ;
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
    link.download = 'RapportGlobalReduction.csv';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
}



function loadConcatTranche(){

    let refConcatTrancheField = [
        { name: "myTranche",
          title: "#",
          type: "number",
          width: 40,
          align: "right",
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm-hd"
        },
        { name: "nbTotalStu",
          title: "Etu.",
          type: "number",
          width: 30,
          align: "right",
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm"
        },
        { name: "nbTotalNothing",
          title: "Rien payé",
          type: "number",
          width: 40,
          align: "right",
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm"
        },
        { name: "nbTotalPart",
          title: "Une partie",
          type: "number",
          width: 40,
          align: "right",
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm"
        },
        { name: "nbTotalAll",
          title: "Tout payé",
          type: "number",
          width: 40,
          align: "right",
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm"
        },
        { name: "amAlreadyRec",
          title: "Montant reçu",
          type: "number",
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm",
          itemTemplate: function(value, item) {
            if(parseInt(value) > 0){
                return '<i class="cell-warn">' + getAriaryValue(value) + '</i>';
            }
            else{
                return getAriaryValue(value);
            }
          }
        },
        { name: "amMissingToRec",
          title: "Montant en attente",
          type: "number",
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm",
          itemTemplate: function(value, item) {
            if(parseInt(value) > 0){
                return '<i class="cell-warn">' + getAriaryValue(value) + '</i>';
            }
            else{
                return getAriaryValue(value);
            }
          }
        },
        { name: "amTotal",
          title: "Montant total",
          type: "number",
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm",
          itemTemplate: function(value, item) {
            if(parseInt(value) > 0){
                return '<i class="cell-warn">' + getAriaryValue(value) + '</i>';
            }
            else{
                return getAriaryValue(value);
            }
          }
        }
    ];

    $("#jsGridTranche").jsGrid({
        height: "auto",
        width: "100%",
        noDataContent: "Aucun résultat disponible",
        pageIndex: 1,
        pageSize: 50,
        pagePrevText: "Prec",
        pageNextText: "Suiv",
        pageFirstText: "Prem",
        pageLastText: "Dern",

        sorting: true,
        paging: true,
        data: dataPrepCountTrancheGridJsonArray,
        fields: refConcatTrancheField
    });

}

function loadConcatMvola(){

    let refConcatMvolaField = [
        { name: "MVO_AMOUNT",
          title: "Montant",
          type: "number",
          width: 50,
          align: "right",
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm",
          itemTemplate: function(value, item) {
            if(parseInt(value) < 0){
                return '<i class="cell-warn">' + getAriaryValue(value) + '</i>';
            }
            else{
                return getAriaryValue(value);
            }
          }
        },
        { name: "TO_PHONE",
          title: "Bénéficiaire",
          type: "text",
          width: 40,
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm",
          itemTemplate: function(value, item) {
            if(value != 'TELMA'){
                //034 49 60 000
                return value.replace(/\D+/g, '').replace(/(\d{3})(\d{2})(\d{2})(\d{3})/, '$1 $2 $3 $4');
            }
            else{
                return value;
            }
          }
        },
        { name: "ORDER_DIRECTION",
          title: "Code",
          type: "text",
          width: 30,
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm",
          itemTemplate: function(value, item) {
            if(value == 'C'){
                return 'Crédit';
            }
            else{
                return 'Débit';
            }
          }
        }
    ];

    $("#jsGridMvola").jsGrid({
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
        data: dataConcatMvolaJsonArray,
        fields: refConcatMvolaField
    });
}

function runStatDashboardPay(){
    //Corlor
    let backgroundColorRef = [
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
    let borderColorRef = [
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

    //Corlor
    let backgroundColorRefAlt = [
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
        '#fffff2',
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
        '#9f9f9f',
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
    let listOfLabelCountOneTranche = new Array();
    let listOfDataCountOneTranche = new Array();
    for(let i=0; i<dataCountTrancheOneJsonArray.length; i++){
        listOfLabelCountOneTranche.push(dataCountTrancheOneJsonArray[i].CATEGORY);
        listOfDataCountOneTranche.push(dataCountTrancheOneJsonArray[i].COUNT_PART);
    }

    let ctxTrancheOne = document.getElementById('trancheOne');
    new Chart(ctxTrancheOne, {
        type: 'doughnut',
        data: {
          labels: listOfLabelCountOneTranche,
          datasets: [
            {
              label: "Proportion Tranche 1",
              backgroundColor: backgroundColorRef,
              borderColor: borderColorRef,
              data: listOfDataCountOneTranche,
              borderWidth: 0.3
            }
          ]
        },
        options: {
        }
    });

    // Stat of status population
    let listOfLabelCountTwoTranche = new Array();
    let listOfDataCountTwoTranche = new Array();
    for(let i=0; i<dataCountTrancheTwoJsonArray.length; i++){
        listOfLabelCountTwoTranche.push(dataCountTrancheTwoJsonArray[i].CATEGORY);
        listOfDataCountTwoTranche.push(dataCountTrancheTwoJsonArray[i].COUNT_PART);
    }

    let ctxTrancheTwo = document.getElementById('trancheTwo');
    new Chart(ctxTrancheTwo, {
        type: 'doughnut',
        data: {
          labels: listOfLabelCountTwoTranche,
          datasets: [
            {
              label: "Proportion Tranche 2",
              backgroundColor: backgroundColorRefAlt,
              borderColor: borderColorRefAlt,
              data: listOfDataCountTwoTranche,
              borderWidth: 0.3
            }
          ]
        },
        options: {
        }
    });

    // Stat of status population
    let listOfLabelCountThreeTranche = new Array();
    let listOfDataCountThreeTranche = new Array();
    for(let i=0; i<dataCountTrancheThreeJsonArray.length; i++){
        listOfLabelCountThreeTranche.push(dataCountTrancheThreeJsonArray[i].CATEGORY);
        listOfDataCountThreeTranche.push(dataCountTrancheThreeJsonArray[i].COUNT_PART);
    }

    let ctxTrancheThree = document.getElementById('trancheThree');
    new Chart(ctxTrancheThree, {
        type: 'doughnut',
        data: {
          labels: listOfLabelCountThreeTranche,
          datasets: [
            {
              label: "Proportion Tranche 3",
              backgroundColor: backgroundColorRefAlt2,
              borderColor: borderColorRefAlt2,
              data: listOfDataCountThreeTranche,
              borderWidth: 0.3
            }
          ]
        },
        options: {
        }
    });

}

function prepareJsonDataPayTranche(){
  //dataCountTrancheGridJsonArray
  //dataPrepCountTrancheGridJsonArray = "";

  //let dataCountTrancheOneJsonArray = "";
  //let dataCountTrancheTwoJsonArray = "";
  //let dataCountTrancheThreeJsonArray = "";

  // As it is a fixed array, code description is here : https://docs.google.com/spreadsheets/d/15Qf8CIZEBFmaNFs-WrLAhG9Tiziafya3VcXM1DByYho/edit?usp=drive_link
  // Be carefull there is no loop
  let myPrepCountTrancheGrid1 = {
    myTranche: 'Tranche 1',
    nbTotalStu: parseInt(dataCountTrancheGridJsonArray[0].COUNT_PART) + 
                parseInt(dataCountTrancheGridJsonArray[1].COUNT_PART) + 
                parseInt(dataCountTrancheGridJsonArray[2].COUNT_PART),
    nbTotalNothing: parseInt(dataCountTrancheGridJsonArray[0].COUNT_PART),
    nbTotalPart: parseInt(dataCountTrancheGridJsonArray[2].COUNT_PART),
    nbTotalAll: parseInt(dataCountTrancheGridJsonArray[1].COUNT_PART),

    amAlreadyRec: parseInt(dataCountTrancheGridJsonArray[0].SUM_ALREADY_PAID) + 
                  parseInt(dataCountTrancheGridJsonArray[1].SUM_ALREADY_PAID) + 
                  parseInt(dataCountTrancheGridJsonArray[2].SUM_ALREADY_PAID),
    amMissingToRec: parseInt(dataCountTrancheGridJsonArray[0].SUM_REST_TO_PAY) + 
                    parseInt(dataCountTrancheGridJsonArray[1].SUM_REST_TO_PAY) + 
                    parseInt(dataCountTrancheGridJsonArray[2].SUM_REST_TO_PAY),
    amTotal: parseInt(dataCountTrancheGridJsonArray[0].ALL_TRANCHE_AMOUNT) + 
              parseInt(dataCountTrancheGridJsonArray[1].ALL_TRANCHE_AMOUNT) + 
              parseInt(dataCountTrancheGridJsonArray[2].ALL_TRANCHE_AMOUNT)
    };
  dataPrepCountTrancheGridJsonArray.push(myPrepCountTrancheGrid1);

  let myPrepCountTrancheGrid2 = {
    myTranche: 'Tranche 2',
    nbTotalStu: parseInt(dataCountTrancheGridJsonArray[3].COUNT_PART) + 
                parseInt(dataCountTrancheGridJsonArray[4].COUNT_PART) + 
                parseInt(dataCountTrancheGridJsonArray[5].COUNT_PART),
    nbTotalNothing: parseInt(dataCountTrancheGridJsonArray[3].COUNT_PART),
    nbTotalPart: parseInt(dataCountTrancheGridJsonArray[5].COUNT_PART),
    nbTotalAll: parseInt(dataCountTrancheGridJsonArray[4].COUNT_PART),

    amAlreadyRec: parseInt(dataCountTrancheGridJsonArray[3].SUM_ALREADY_PAID) + 
                  parseInt(dataCountTrancheGridJsonArray[4].SUM_ALREADY_PAID) + 
                  parseInt(dataCountTrancheGridJsonArray[5].SUM_ALREADY_PAID),
    amMissingToRec: parseInt(dataCountTrancheGridJsonArray[3].SUM_REST_TO_PAY) + 
                    parseInt(dataCountTrancheGridJsonArray[4].SUM_REST_TO_PAY) + 
                    parseInt(dataCountTrancheGridJsonArray[5].SUM_REST_TO_PAY),
    amTotal: parseInt(dataCountTrancheGridJsonArray[3].ALL_TRANCHE_AMOUNT) + 
              parseInt(dataCountTrancheGridJsonArray[4].ALL_TRANCHE_AMOUNT) + 
              parseInt(dataCountTrancheGridJsonArray[5].ALL_TRANCHE_AMOUNT)
    };
  dataPrepCountTrancheGridJsonArray.push(myPrepCountTrancheGrid2);

  let myPrepCountTrancheGrid3 = {
    myTranche: 'Tranche 3',
    nbTotalStu: parseInt(dataCountTrancheGridJsonArray[6].COUNT_PART) + 
                parseInt(dataCountTrancheGridJsonArray[7].COUNT_PART) + 
                parseInt(dataCountTrancheGridJsonArray[8].COUNT_PART),
    nbTotalNothing: parseInt(dataCountTrancheGridJsonArray[6].COUNT_PART),
    nbTotalPart: parseInt(dataCountTrancheGridJsonArray[8].COUNT_PART),
    nbTotalAll: parseInt(dataCountTrancheGridJsonArray[7].COUNT_PART),

    amAlreadyRec: parseInt(dataCountTrancheGridJsonArray[6].SUM_ALREADY_PAID) + 
                  parseInt(dataCountTrancheGridJsonArray[7].SUM_ALREADY_PAID) + 
                  parseInt(dataCountTrancheGridJsonArray[8].SUM_ALREADY_PAID),
    amMissingToRec: parseInt(dataCountTrancheGridJsonArray[6].SUM_REST_TO_PAY) + 
                    parseInt(dataCountTrancheGridJsonArray[7].SUM_REST_TO_PAY) + 
                    parseInt(dataCountTrancheGridJsonArray[8].SUM_REST_TO_PAY),
    amTotal: parseInt(dataCountTrancheGridJsonArray[6].ALL_TRANCHE_AMOUNT) + 
              parseInt(dataCountTrancheGridJsonArray[7].ALL_TRANCHE_AMOUNT) + 
              parseInt(dataCountTrancheGridJsonArray[8].ALL_TRANCHE_AMOUNT)
    };
  dataPrepCountTrancheGridJsonArray.push(myPrepCountTrancheGrid3);


  for(let i=0; i<dataCountTrancheGridJsonArray.length; i++){
    // Get my line Prep Solo
    let myPrepSoloTranche = {
      CATEGORY: dataCountTrancheGridJsonArray[i].CATEGORY,
      COUNT_PART: dataCountTrancheGridJsonArray[i].COUNT_PART
    };

    switch (dataCountTrancheGridJsonArray[i].TRANCHE) {
      case 'Tranche_1':
        dataCountTrancheOneJsonArray.push(myPrepSoloTranche);
        break;
      case 'Tranche_2':
        dataCountTrancheTwoJsonArray.push(myPrepSoloTranche);
        break;
      default:
        dataCountTrancheThreeJsonArray.push(myPrepSoloTranche);
    }
  }
}
//***********************************************************************************************************
//***********************************************************************************************************
//***********************************************************************************************************
//***********************************************************************************************************
//***********************************************************************************************************

function generateResumePayWorksheet(){

    //************************ START HEADER ************************
    
    let rowHeader1 = [
      { v: 'A', t: 's', s: { ...DEF_HEADER_CARTOUCHE_LOGO } },
      { v: 'UNIVERSITÉ ACEEM', t: 's', s: { ...DEF_HEADER_CARTOUCHE } }
    ];
    
    let rowHeader2 = [
      { v: 'MANAKAMBAHINY', t: 's', s: { ...DEF_HEADER_CARTOUCHE } }
    ];
    let rowHeader3 = [
      { v: 'Service caisse', t: 's', s: { ...DEF_HEADER_CARTOUCHE } }
    ];
    let rowHeader4 = [
      { v: 'Version papier', t: 's', s: { ...DEF_HEADER_CARTOUCHE } },
      { v: '', t: 's', s: { ...DEF_HEADER_CARTOUCHE } },
      { v: 'AU: ' + CONST_PARAM_YEAR, t: 's', s: { ...DEF_HEADER_CARTOUCHE } }
    ];
    let rowHeader5 = [
      { v: '', t: 's', s: { ...DEF_HEADER_CARTOUCHE } }
    ];
    let rowHeader6 = [
      //{ v: 'État des frais de scolarité du mois ' + (getReportACEMonthYearStrFR(-1)).toUpperCase(), t: 's', s: { ...DEF_HEADER_CARTOUCHE } }
      { v: 'État des frais de scolarité en date du ' + getACEDateStr('F'), t: 's', s: { ...DEF_HEADER_CARTOUCHE } }
    ];
    let rowHeader7 = [
      { v: '', t: 's', s: { DEF_HEADER_CARTOUCHE } }
    ];
    let rowHeaderRecYear = [
      { v: '', t: 's', s: { DEF_HEADER_CARTOUCHE } },
      { v: 'Recette sur l\'année : ', t: 's', s: { ...DEF_RESUME_HDR_CELL } },
      { v: renderAmountExcel(cobBenefitOfTheYear), t: 's', s: { ...DEF_RESUME_VAL_CELL } }
    ];
    let rowHeaderRedYear = [
      { v: '', t: 's', s: { DEF_HEADER_CARTOUCHE } },
      { v: 'Réduction sur l\'année : ', t: 's', s: { ...DEF_RESUME_HDR_CELL } },
      { v: renderAmountExcel(cobReductionOfTheYear), t: 's', s: { ...DEF_RESUME_VAL_CELL } }
    ];
    let rowHeaderExemptionYear = [
      { v: '', t: 's', s: { DEF_HEADER_CARTOUCHE } },
      { v: 'Exemption sur l\'année : ', t: 's', s: { ...DEF_RESUME_HDR_CELL } },
      { v: renderAmountExcel(cobExemptionOfTheYear), t: 's', s: { ...DEF_RESUME_VAL_CELL } }
    ];
    let rowHeaderNUDYear = [
      { v: '', t: 's', s: { DEF_HEADER_CARTOUCHE } },
      { v: 'Non attribué Mvola : ', t: 's', s: { ...DEF_RESUME_HDR_CELL } },
      { v: renderAmountExcel(NON_ATTR_MVOLA), t: 's', s: { ...DEF_RESUME_VAL_CELL } }
    ];
    let rowHeader8 = [
      { v: '', t: 's', s: { ...DEF_HEADER_CARTOUCHE } }
    ];
    let rowHeader9 = [
      { v: 'État des paiements du mois ' + (getReportACEMonthYearStrFR(-1)).toUpperCase(), t: 's', s: { ...DEF_HEADER_CARTOUCHE } }
    ];
    let rowHeader10 = [
      { v: '', t: 's', s: { DEF_HEADER_CARTOUCHE } }
    ];
    
    let rowCollection = [rowHeader1, rowHeader2, rowHeader3, rowHeader4, rowHeader5, rowHeader6, rowHeader7, rowHeaderRecYear, rowHeaderRedYear, rowHeaderExemptionYear, rowHeaderNUDYear, rowHeader8, rowHeader9, rowHeader10];

    if(dataRepMonthMentionJsonArray.length == 0){
      let rowHeader10 = [
        { v: '', t: 's', s: { DEF_HEADER_CARTOUCHE } }
      ];
      rowCollection.push(rowHeader10);
      let rowHeader11 = [
        { v: 'Pas de paiement enregistré ', t: 's', s: { ...DEF_HEADER_CARTOUCHE } }
      ];
      rowCollection.push(rowHeader11);
    }
    else{
      for(let i=0; i<dataRepMonthMentionJsonArray.length; i++){
          let rowHeaderExemptionYear = [
            { v: '', t: 's', s: { DEF_HEADER_CARTOUCHE } },
            { v: getCapitalize(dataRepMonthMentionJsonArray[i].VCC_MENTION) + ' : ', t: 's', s: { ...DEF_RESUME_HDR_CELL } },
            { v: renderAmountExcel(dataRepMonthMentionJsonArray[i].UP_AMOUNT), t: 's', s: { ...DEF_RESUME_VAL_CELL } }
          ];
          rowCollection.push(rowHeaderExemptionYear);
      }
    }
       

    //************************ END HEADER ***********************

    const ws = XLSX.utils.aoa_to_sheet(rowCollection);
    ws['!cols'] = [
      { width: 10 }, //Details documents
      { width: 45 }, //Header resume
      { width: 25 }, //Val resume
      { width: 20 }, //na
      { width: 20 }, //na
      { width: 20 }, //na
      { width: 20 }, //na
      { width: 20 }]; //na
    //ws['!rows'] = [{ 'hpt': DEF_ROW_DFT }, { 'hpt': DEF_ROW_DFT }, { 'hpt': DEF_ROW_DFT }, { 'hpt': DEF_ROW_DFT }, { 'hpt': DEF_ROW_DFT }, { 'hpt': DEF_ROW_DFT }, { 'hpt': DEF_ROW_DFT }];
    const rowDefinition = [];
    for(let i=0; i<rowCollection.length; i++){
      rowDefinition.push(DEF_ROW_DFT_SETUP);
    }
    ws['!rows'] = rowDefinition;

    return ws;
}

function generateTranchePayWorksheet(paramLines){

  //************************ START HEADER ************************
  
  let rowHeader1 = [
    { v: 'A', t: 's', s: { ...DEF_HEADER_CARTOUCHE_LOGO } },
    { v: 'UNIVERSITÉ ACEEM', t: 's', s: { ...DEF_HEADER_CARTOUCHE } }
  ];
  
  let rowHeader2 = [
    { v: 'MANAKAMBAHINY', t: 's', s: { ...DEF_HEADER_CARTOUCHE } }
  ];
  let rowHeader3 = [
    { v: 'Service caisse', t: 's', s: { ...DEF_HEADER_CARTOUCHE } }
  ];
  let rowHeader4 = [
    { v: 'Version papier', t: 's', s: { ...DEF_HEADER_CARTOUCHE } },
    { v: '', t: 's', s: { ...DEF_HEADER_CARTOUCHE } },
    { v: 'AU: ' + CONST_PARAM_YEAR, t: 's', s: { ...DEF_HEADER_CARTOUCHE } }
  ];
  let rowHeader5 = [
    { v: '', t: 's', s: { ...DEF_HEADER_CARTOUCHE } }
  ];
  let rowHeader6 = [
    { v: 'État des tranches en date du ' + getACEDateStr('F'), t: 's', s: { ...DEF_HEADER_CARTOUCHE } }
  ];
  let rowHeader7 = [
    { v: '', t: 's', s: { ...DEF_HEADER_CARTOUCHE } }
  ];

  let rowHeaderTranche = [
    { v: '', t: 's', s: { ...DEF_EMPTY_CELL } },
    { v: '#', t: 's', s: { ...DEF_HEADER_CELL_HEAVY } },
    { v: 'Étudiant', t: 's', s: { ...DEF_HEADER_CELL_HEAVY } },
    { v: 'Rien payé', t: 's', s: { ...DEF_HEADER_CELL_HEAVY } },
    { v: 'Une partie', t: 's', s: { ...DEF_HEADER_CELL_HEAVY } },
    { v: 'Tout payé', t: 's', s: { ...DEF_HEADER_CELL_HEAVY } },
    { v: 'Montant reçu', t: 's', s: { ...DEF_HEADER_CELL_HEAVY } },
    { v: 'Montant en attente', t: 's', s: { ...DEF_HEADER_CELL_HEAVY } },
    { v: 'Montant total', t: 's', s: { ...DEF_HEADER_CELL_HEAVY } }
  ];
  
  let rowCollection = [rowHeader1, rowHeader2, rowHeader3, rowHeader4, rowHeader5, rowHeader6, rowHeader7, rowHeaderTranche];


  for(let i=0; i<paramLines.length; i++){
      //is DEF_CELL_ODD
      if(i % 2 === 0){
        let rowHeaderLine = [
          { v: '', t: 's', s: { ...DEF_EMPTY_CELL } },
          { v: paramLines[i].myTranche, t: 's', s: { ...DEF_HEADER_CELL_HEAVY } },
          { v: paramLines[i].nbTotalStu, t: 's', s: { ...DEF_CELL_ODD } },
          { v: paramLines[i].nbTotalNothing, t: 's', s: { ...DEF_CELL_ODD } },
          { v: paramLines[i].nbTotalPart, t: 's', s: { ...DEF_CELL_ODD } },
          { v: paramLines[i].nbTotalAll, t: 's', s: { ...DEF_CELL_ODD } },
          { v: renderAmountExcel(paramLines[i].amAlreadyRec), t: 's', s: { ...DEF_NBR_CELL_ODD } },
          { v: renderAmountExcel(paramLines[i].amMissingToRec), t: 's', s: { ...DEF_NBR_CELL_ODD } },
          { v: renderAmountExcel(paramLines[i].amTotal), t: 's', s: { ...DEF_NBR_CELL_ODD } }
        ];
        rowCollection.push(rowHeaderLine);
      }
      else{
          let rowHeaderLine = [
            { v: '', t: 's', s: { ...DEF_EMPTY_CELL } },
            { v: paramLines[i].myTranche, t: 's', s: { ...DEF_HEADER_CELL_HEAVY } },
            { v: paramLines[i].nbTotalStu, t: 's', s: { ...DEF_CELL } },
            { v: paramLines[i].nbTotalNothing, t: 's', s: { ...DEF_CELL } },
            { v: paramLines[i].nbTotalPart, t: 's', s: { ...DEF_CELL } },
            { v: paramLines[i].nbTotalAll, t: 's', s: { ...DEF_CELL } },
            { v: renderAmountExcel(paramLines[i].amAlreadyRec), t: 's', s: { ...DEF_NBR_CELL } },
            { v: renderAmountExcel(paramLines[i].amMissingToRec), t: 's', s: { ...DEF_NBR_CELL } },
            { v: renderAmountExcel(paramLines[i].amTotal), t: 's', s: { ...DEF_NBR_CELL } }
          ];
          rowCollection.push(rowHeaderLine);
      }
  }


  //************************ END HEADER ***********************

  const ws = XLSX.utils.aoa_to_sheet(rowCollection);
  ws['!cols'] = [
    { width: 10 }, //Details documents
    { width: 10 }, //Header resume
    { width: 10 }, //Val resume
    { width: 10 }, //na
    { width: 10 }, //na
    { width: 10 }, //na
    { width: 20 }, //na
    { width: 20 }, //na
    { width: 20 }]; //na
  //ws['!rows'] = [{ 'hpt': DEF_ROW_DFT }, { 'hpt': DEF_ROW_DFT }, { 'hpt': DEF_ROW_DFT }, { 'hpt': DEF_ROW_DFT }, { 'hpt': DEF_ROW_DFT }, { 'hpt': DEF_ROW_DFT }, { 'hpt': DEF_ROW_DFT }];
  const rowDefinition = [];
  for(let i=0; i<rowCollection.length; i++){
    rowDefinition.push(DEF_ROW_DFT_SETUP);
  }
  ws['!rows'] = rowDefinition;

  return ws;
}


function generateGlobalPaymentExcel(){
  const wb = XLSX.utils.book_new();

  // Create first the global worksheet
  // dataTagToJsonArrayExcelGblComputeReport
  XLSX.utils.book_append_sheet(wb, generateResumePayWorksheet(), 'AU' + CONST_PARAM_YEAR);

  XLSX.utils.book_append_sheet(wb, generateTranchePayWorksheet(dataPrepCountTrancheGridJsonArray), 'Tranche');

  // STEP 4: Write Excel file to browser
  XLSX.writeFile(wb, "RapportGlobalPaiement1m_" + getReportACEDateStrFR(0).replaceAll('/', '_') + ".xlsx");
}







/***********************************************************************************************************/

$(document).ready(function() {
    console.log('We are in ACE-DASHPAY');
  
    if($('#mg-graph-identifier').text() == 'dash-pay'){
      // Do something
      console.log('in dash-pay');
      //getAriaryValue(value)
      //$('#disp-pv-smv').html(formatterCurrency.format(SOLDE_MVOLA).replace("MGA", "AR"));
      $('#disp-pv-smv').html(getAriaryValue(SOLDE_MVOLA));
      prepareJsonDataPayTranche();
      loadConcatMvola();
      loadConcatTranche();
      runStatDashboardPay();

      let totalCashCheck = 0;

      // dataTodayNbrCheckPVJsonArray dataTodayPVJsonArray
      for(let i=0; i<dataTodayPVJsonArray.length ; i++){
        if(dataTodayPVJsonArray[i].TOD_TYPE_OF_PAYMENT == 'C'){
            //$('#disp-pv-csh').html(formatterCurrency.format(dataTodayPVJsonArray[i].TOD_AMOUNT).replace("MGA", "AR"));
            $('#disp-pv-csh').html(getAriaryValue(dataTodayPVJsonArray[i].TOD_AMOUNT));
            totalCashCheck = totalCashCheck + parseInt(dataTodayPVJsonArray[i].TOD_AMOUNT);
            cobCashOfTheDay = parseInt(dataTodayPVJsonArray[i].TOD_AMOUNT);
        }
        else if(dataTodayPVJsonArray[i].TOD_TYPE_OF_PAYMENT == 'H'){
            //$('#disp-pv-chq').html(formatterCurrency.format(dataTodayPVJsonArray[i].TOD_AMOUNT).replace("MGA", "AR"));
            $('#disp-pv-chq').html(getAriaryValue(dataTodayPVJsonArray[i].TOD_AMOUNT));
            totalCashCheck = totalCashCheck + parseInt(dataTodayPVJsonArray[i].TOD_AMOUNT);
            cobCheqOfTheDay = parseInt(dataTodayPVJsonArray[i].TOD_AMOUNT);
        }
        else if(dataTodayPVJsonArray[i].TOD_TYPE_OF_PAYMENT == 'R'){
            //$('#disp-pv-red').html(formatterCurrency.format(dataTodayPVJsonArray[i].TOD_AMOUNT).replace("MGA", "AR"));
            $('#disp-pv-red').html(getAriaryValue(dataTodayPVJsonArray[i].TOD_AMOUNT));
            cobReductionOfTheDay = parseInt(dataTodayPVJsonArray[i].TOD_AMOUNT);
        }
        else if(dataTodayPVJsonArray[i].TOD_TYPE_OF_PAYMENT == 'T'){
            // Else it must be T
            //$('#disp-pv-ttp').html(formatterCurrency.format(dataTodayPVJsonArray[i].TOD_AMOUNT).replace("MGA", "AR"));
            $('#disp-pv-ttp').html(getAriaryValue(dataTodayPVJsonArray[i].TOD_AMOUNT));
            totalCashCheck = totalCashCheck + parseInt(dataTodayPVJsonArray[i].TOD_AMOUNT);
            cobVirmTpeOfTheDay = parseInt(dataTodayPVJsonArray[i].TOD_AMOUNT);
        }
        else{
            //We do nothing yet as Exemptions i not displayed at all
        }
      }

      // ********************************************************************
      // ********************************************************************
      // ********************************************************************
      // ********************************************************************
      // Here we set the resume set up Excel 

      for(let i=0; i<dataYearRecapJsonArray.length; i++){
        if(dataYearRecapJsonArray[i].UP_TYPE_OF_PAYMENT == 'P'){
            //$('#disp-py-ben').html(formatterCurrency.format(dataYearRecapJsonArray[i].UP_AMOUNT).replace("MGA", "AR"));
            $('#disp-py-ben').html(getAriaryValue(dataYearRecapJsonArray[i].UP_AMOUNT));
            cobBenefitOfTheYear = parseInt(dataYearRecapJsonArray[i].UP_AMOUNT);
        }
        else if(dataYearRecapJsonArray[i].UP_TYPE_OF_PAYMENT == 'E'){
            //$('#disp-py-red').html(formatterCurrency.format(dataYearRecapJsonArray[i].UP_AMOUNT).replace("MGA", "AR"));
            $('#disp-py-exm').html(getAriaryValue(dataYearRecapJsonArray[i].UP_AMOUNT));
            cobExemptionOfTheYear = parseInt(dataYearRecapJsonArray[i].UP_AMOUNT);
        }
        else{
            //$('#disp-py-red').html(formatterCurrency.format(dataYearRecapJsonArray[i].UP_AMOUNT).replace("MGA", "AR"));
            $('#disp-py-red').html(getAriaryValue(dataYearRecapJsonArray[i].UP_AMOUNT));
            cobReductionOfTheYear = parseInt(dataYearRecapJsonArray[i].UP_AMOUNT);
        }
      }
      
      // ************* Specific case of the NUD Mvola
      $('#disp-pv-nud').html(renderAmount(NON_ATTR_MVOLA));


      if(totalCashCheck > 0){
        //$('#disp-pv-tot').html(formatterCurrency.format(totalCashCheck).replace("MGA", "AR"));
        $('#disp-pv-tot').html(getAriaryValue(totalCashCheck));
        cobTotalOfTheDay = parseInt(totalCashCheck);
      }


      if(dataTodayNbrCheckPVJsonArray.length == 1){
        $('#disp-pv-nbr-chq').html(dataTodayNbrCheckPVJsonArray[0].TOD_NBR_OF_CHECK);
        if(parseInt(dataTodayNbrCheckPVJsonArray[0].TOD_NBR_OF_CHECK) > 1){
            $('#orth-pv-nbr-chq').html('s');
        }
        cobNbrCheqOfTheDay = parseInt(dataTodayNbrCheckPVJsonArray[0].TOD_NBR_OF_CHECK);
      }

      cobArray.push('RECETTE.ANNEE....' + (renderAmount(cobBenefitOfTheYear.toString())).padStart(maxLgRecap, paddChar));
      cobArray.push('REDUCTION.ANNEE..' + (renderAmount(cobReductionOfTheYear.toString())).padStart(maxLgRecap, paddChar));
      cobArray.push('EXEMPTION.ANNEE..' + (renderAmount(cobExemptionOfTheYear.toString())).padStart(maxLgRecap, paddChar));
      cobArray.push('SOLDE.MVOLA......' + (renderAmount(SOLDE_MVOLA.toString())).padStart(maxLgRecap, paddChar));

      cobArray.push('REDUCTION.AUJ....' + (renderAmount(cobReductionOfTheDay.toString())).padStart(maxLgRecap, paddChar));
      cobArray.push('CASH.AUJ.........' + (renderAmount(cobCashOfTheDay.toString())).padStart(maxLgRecap, paddChar));
      cobArray.push('CHEQUE.AUJ.......' + (renderAmount(cobCheqOfTheDay.toString())).padStart(maxLgRecap, paddChar));
      cobArray.push('NBR.CHEQUE.AUJ...' + (renderAmount(cobNbrCheqOfTheDay.toString())).padStart(maxLgRecap, paddChar));
      cobArray.push('VIR/TPE.AUJ......' + (renderAmount(cobVirmTpeOfTheDay.toString())).padStart(maxLgRecap, paddChar));
      cobArray.push('TOTAL.AUJ........' + (renderAmount(totalCashCheck.toString())).padStart(maxLgRecap, paddChar));


      for(let i=0; i<dataConcatMvolaJsonArray.length; i++){
        mvolaArray.push(dataConcatMvolaJsonArray[i].ORDER_DIRECTION + '....' + dataConcatMvolaJsonArray[i].TO_PHONE.padStart(10, '.') + '...' + renderAmount(dataConcatMvolaJsonArray[i].MVO_AMOUNT).padStart(maxLgRecap, paddChar));
      }

    /*  
    for(let i=0; i<mvolaArray.length; i++){
    console.log('Show: ' + mvolaArray[i]);
    }
    */
      
      

    }
    else if($('#mg-graph-identifier').text() == 'xxx'){
      // Do something
    }
    else{
      //Do nothing
    }
  
  
  
});