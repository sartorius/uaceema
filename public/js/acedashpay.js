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
        { name: "COUNT_PART",
          title: "Nombre étudiant",
          type: "number",
          width: 50,
          align: "right",
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm"
        },
        { name: "CATEGORY",
          title: "A déjà payé",
          type: "text",
          width: 30,
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm"
        },
        { name: "TRANCHE",
          title: "Tranche",
          type: "text",
          width: 65,
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm"
        },
        { name: "TOTAL_AMOUNT",
          title: "Montant en attente",
          type: "number",
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm",
          itemTemplate: function(value, item) {
            if(parseInt(value) > 0){
                return '<i class="cell-warn">' + formatterCurrency.format(value).replace("MGA", "AR") + '</i>';
            }
            else{
                return formatterCurrency.format(value).replace("MGA", "AR");
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
        data: dataCountTrancheGridJsonArray,
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
                return '<i class="cell-warn">' + formatterCurrency.format(value).replace("MGA", "AR") + '</i>';
            }
            else{
                return formatterCurrency.format(value).replace("MGA", "AR");
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
          width: 35,
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
        noDataContent: "Aucun paiement disponible",
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

/***********************************************************************************************************/

$(document).ready(function() {
    console.log('We are in ACE-DASHPAY');
  
    if($('#mg-graph-identifier').text() == 'dash-pay'){
      // Do something
      console.log('in dash-pay');
      $('#disp-pv-smv').html(formatterCurrency.format(SOLDE_MVOLA).replace("MGA", "AR"));
      loadConcatMvola();
      loadConcatTranche();
      runStatDashboardPay();

      let totalCashCheck = 0;

      // dataTodayNbrCheckPVJsonArray dataTodayPVJsonArray
      for(let i=0; i<dataTodayPVJsonArray.length ; i++){
        if(dataTodayPVJsonArray[i].TOD_TYPE_OF_PAYMENT == 'C'){
            $('#disp-pv-csh').html(formatterCurrency.format(dataTodayPVJsonArray[i].TOD_AMOUNT).replace("MGA", "AR"));
            totalCashCheck = totalCashCheck + parseInt(dataTodayPVJsonArray[i].TOD_AMOUNT);
        }
        else if(dataTodayPVJsonArray[i].TOD_TYPE_OF_PAYMENT == 'H'){
            $('#disp-pv-chq').html(formatterCurrency.format(dataTodayPVJsonArray[i].TOD_AMOUNT).replace("MGA", "AR"));
            totalCashCheck = totalCashCheck + parseInt(dataTodayPVJsonArray[i].TOD_AMOUNT);
        }
        else if(dataTodayPVJsonArray[i].TOD_TYPE_OF_PAYMENT == 'R'){
            $('#disp-pv-red').html(formatterCurrency.format(dataTodayPVJsonArray[i].TOD_AMOUNT).replace("MGA", "AR"));
        }
        else{
            // Else it must be T
            $('#disp-pv-ttp').html(formatterCurrency.format(dataTodayPVJsonArray[i].TOD_AMOUNT).replace("MGA", "AR"));
        }
      }

      for(let i=0; i<dataYearRecapJsonArray.length; i++){
        if(dataYearRecapJsonArray[i].UP_TYPE_OF_PAYMENT == 'P'){
            $('#disp-py-ben').html(formatterCurrency.format(dataYearRecapJsonArray[i].UP_AMOUNT).replace("MGA", "AR"));
        }
        else{
            $('#disp-py-red').html(formatterCurrency.format(dataYearRecapJsonArray[i].UP_AMOUNT).replace("MGA", "AR"));
        }
      }
      


      if(totalCashCheck > 0){
        $('#disp-pv-tot').html(formatterCurrency.format(totalCashCheck).replace("MGA", "AR"));
      }

      if(dataTodayNbrCheckPVJsonArray.length == 1){
        $('#disp-pv-nbr-chq').html(dataTodayNbrCheckPVJsonArray[0].TOD_NBR_OF_CHECK);
        if(parseInt(dataTodayNbrCheckPVJsonArray[0].TOD_NBR_OF_CHECK) > 1){
            $('#orth-pv-nbr-chq').html('s');
        }
      }
      

    }
    else if($('#mg-graph-identifier').text() == 'xxx'){
      // Do something
    }
    else{
      //Do nothing
    }
  
  
  
});