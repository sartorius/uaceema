
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

$(document).ready(function() {
  console.log('We are in ACE-STU');

  if($('#mg-graph-identifier').text() == 'das-stu'){
    // Do something on das-stu
    // Do nothing
    initAllSTUGrid();
    loadAllSTUGrid();
  }
  else if($('#mg-graph-identifier').text() == 'xxx'){
    // Do something
  }
  else{
    //Do nothing
  }



});
