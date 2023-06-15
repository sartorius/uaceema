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
    let borderColorRefAlt2 = [
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
      $('#solde-mvola').html(formatterCurrency.format(SOLDE_MVOLA).replace("MGA", "AR"));
      loadConcatMvola();
      loadConcatTranche();
      runStatDashboardPay();
    }
    else if($('#mg-graph-identifier').text() == 'xxx'){
      // Do something
    }
    else{
      //Do nothing
    }
  
  
  
});