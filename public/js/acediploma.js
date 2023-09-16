function printDiplomaSheet(param){

  console.log('Click on printDiplomaSheet');


  // Here format A4
  let doc = new jsPDF('p','mm',[297, 210]);


  doc.setFont('Helvetica');
  doc.setFontStyle('normal');
  doc.setTextColor(0, 0, 0);
  doc.setFontSize(10);
  doc.text(
      20, //x oddOffsetX is to define if position 1 or 2
      30, //y
      'Test'
      );
  
  const img = new Image();
  img.src = document.getElementById('mbc-0').getElementsByTagName('img')[0];
  img.onload = () => {
    doc.addImage(img, //img src
      'PNG', //format
      30,//x oddOffsetX is to define if position 1 or 2
      40, //y
      300, //Width
      300, null, 'FAST'); //Height // Fast is to get less big files

      $("#waiting-blc").hide(500);
      doc.save('Diploma_' + param.UD_CODENAME);
  };

  /*
  doc.addImage(document.getElementById('mbc-0').getElementsByTagName('img')[0], //img src
      'PNG', //format
      30,//x oddOffsetX is to define if position 1 or 2
      40, //y
      300, //Width
      300, null, 'FAST'); //Height // Fast is to get less big files
  */
  // Release the screen
  // We don't go at the end of the loop to avoid
  

}


//*********************************************************************************************************
//*********************************************************************************************************
//*********************************************************************************************************
//*********************************************************************************************************
//*********************************************************************************************************
//*********************************************************************************************************
//*********************************************************************************************************
//*********************************************************************************************************
//*********************************************************************************************************
//*********************************************************************************************************




function generateAllDiplomaCSV(){
  const csvContentType = "data:text/csv;charset=utf-8,";
  let csvContent = "";
  let involvedArray = filtereddataAllDiplomaToJsonArray;
  const SEP_ = ";"

let dataString = "Référence" + SEP_ 
                  + "Année" + SEP_ 
                  + "Nom" + SEP_ 
                  + "Prénoms" + SEP_ 
                  + "Diplôme" + SEP_ 
                  + "Intitulé" + SEP_ 
                  + "Mention" + SEP_
                  + "Promotion" + SEP_ 
                  + "Code" + SEP_ 
                  + "Secret" + SEP_ 
                  + "URL" + SEP_ + "\n";
csvContent += dataString;
for(let i=0; i<involvedArray.length; i++){

          dataString = involvedArray[i].UD_ID + SEP_ 
              + isNullMvo(involvedArray[i].CORE_YEAR) + SEP_ 
              + isNullMvo(involvedArray[i].UD_LASTNAME) + SEP_ 
              + isNullMvo(involvedArray[i].UD_FIRSTNAME) + SEP_ 
              + isNullMvo(involvedArray[i].UD_LEVEL) + SEP_ 
              + isNullMvo(involvedArray[i].URDT_TYPE) + SEP_ 
              + isNullMvo(involvedArray[i].URM_TITLE) + SEP_ 
              + isNullMvo(involvedArray[i].TITLE_YEAR) + SEP_ 
              + isNullMvo(involvedArray[i].UD_CODENAME) + SEP_ 
              + isNullMvo(involvedArray[i].UD_SECRET) + SEP_ 
              + CONST_CURRENT_URL + "/diploma/" + isNullMvo(involvedArray[i].UD_SECRET) + isNullMvo(involvedArray[i].UD_CODENAME) + SEP_ ;
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
  link.download = 'RapportGlobalDiploma.csv';
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
}


function initAllDiplomaGrid(){
  $('#filter-all-dip').keyup(function() {
      filterDataAllDiploma();
  });
  $('#re-init-dash-dip').click(function() {
    $('#filter-all-dip').val('');
    clearDataAllDiploma();
  });
}

function filterDataAllDiploma(){
  if(($('#filter-all-dip').val().length > 1) && ($('#filter-all-dip').val().length < 35)){
    //console.log('We need to filter !' + $('#filter-all').val());
    filtereddataAllDiplomaToJsonArray = dataAllDiplomaToJsonArray.filter(function (el) {
                                      return el.raw_data.includes($('#filter-all-dip').val().toUpperCase())
                                  });
      loadAllDiplomaGrid();
  }
  else if(($('#filter-all-dip').val().length < 2)) {
    // We clear data
    clearDataAllDiploma();
  }
  else{
    // DO nothing
  }
}

function clearDataAllDiploma(){
  filtereddataAllDiplomaToJsonArray = Array.from(dataAllDiplomaToJsonArray);
  
  loadAllDiplomaGrid();
};

function loadAllDiplomaGrid(){

  refDiplomaField = [
      { name: "UD_ID",
        title: "#",
        type: "number",
        width: 20,
        align: "right",
        headercss: "cell-ref-uac-sm-hd",
        css: "cell-ref-uac-sm"
      },
      { name: "CORE_YEAR",
        title: "Année",
        type: "number",
        width: 18,
        align: "right",
        headercss: "cell-ref-uac-sm-hd",
        css: "cell-ref-uac-sm"
      },
      { name: "UD_LASTNAME",
        title: "Nom",
        type: "text",
        width: 75,
        headercss: "cell-ref-uac-sm-hd",
        css: "cell-ref-uac-sm"
      },
      { name: "UD_FIRSTNAME",
        title: "Prénoms",
        type: "text",
        headercss: "cell-ref-uac-sm-hd",
        css: "cell-ref-uac-sm"
      },
      { name: "UD_CODENAME",
        title: "Code",
        type: "text",
        width: 30,
        align: "left",
        headercss: "cell-ref-uac-sm-hd",
        css: "cell-ref-uac-sm"
      },
      { name: "UD_SECRET",
        title: "Secret",
        type: "text",
        width: 35,
        align: "right",
        headercss: "cell-ref-uac-sm-hd",
        css: "cell-ref-uac-sm"
      },
      { name: "URDT_MENTION_CODE",
        title: "Mention",
        type: "text",
        width: 25,
        headercss: "cell-ref-uac-sm-hd",
        css: "cell-ref-uac-sm"
      },
      { name: "UD_LEVEL",
        title: "Diplôme",
        type: "text",
        width: 25,
        headercss: "cell-ref-uac-sm-hd",
        css: "cell-ref-uac-sm",
        itemTemplate: function(value, item) {
          if(value == 'M'){
            return 'Master';
          }
          else if(value == 'L'){
            return 'Licence'
          }
          else{
            return 'Certification'
          }
        }
      },
      { name: "URDT_TYPE",
        title: "Intitulé",
        type: "text",
        width: 95,
        headercss: "cell-ref-uac-sm-hd",
        css: "cell-ref-uac-sm"
      },
      { name: "TITLE_YEAR",
        title: "Promotion",
        type: "text",
        width: 65,
        headercss: "cell-ref-uac-sm-hd",
        css: "cell-ref-uac-sm"
      },
      { name: "UD_ID",
        title: "Voir",
        width: 20,
        type: "text",
        headercss: "cell-ref-sm-hd",
        css: "cell-ref-sm-center",
        itemTemplate: function(value, item) {
          return '<a href="' + CONST_CURRENT_URL + '/dematdiploma/' + item.UD_SECRET + item.UD_CODENAME + '" class="btn btn-outline-dark" role="button" target="_blank"><i class="icon-eye"></i></a>';
        }
      }
  ];

  $("#jsGridAllDiploma").jsGrid({
      height: "auto",
      width: "100%",
      noDataContent: "Aucun diplôme disponible",
      pageIndex: 1,
      pageSize: 50,
      pagePrevText: "Prec",
      pageNextText: "Suiv",
      pageFirstText: "Prem",
      pageLastText: "Dern",

      sorting: true,
      paging: true,
      data: filtereddataAllDiplomaToJsonArray,
      fields: refDiplomaField,
      rowClick: function(args){
        /*
        $("#waiting-blc").show(100);
        // Update the QR Code
        new QRCode(document.getElementById("mbc-0"), { 
          text: CONST_CURRENT_URL + "/diploma/" + args.item.UD_SECRET + args.item.UD_CODENAME,
          width: 300,
          height: 300
        }
        );

        printDiplomaSheet(args.item);
        */
      }
  });

  // Update the count
  $('#count-dipl').html(filtereddataAllDiplomaToJsonArray.length);
}


/***********************************************************************************************************/

$(document).ready(function() {
    console.log('We are in ACE-DIP');
  
    if(($('#mg-graph-identifier').text() == 'man-dip')){
      initAllDiplomaGrid();
      loadAllDiplomaGrid();
  
    }
    else if(($('#mg-graph-identifier').text() == 'dip-demat')){
      new QRCode(document.getElementById("mbc-0"), { 
        text: $('#dipl-url').html(),
        width: 250,
        height: 250
      }
      );
    }
    else{
      //Do nothing
    }
});