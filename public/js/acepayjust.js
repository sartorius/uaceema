function generateNewJustDB(){
    $('#pay-add-just-modal').modal('hide');
    tempCleanComment = removeAllQuotes(tempComment);
    fillLogInJust();
  
    $.ajax('/generateJustDB', {
        type: 'POST',  // http method
        data: {
          currentAgentIdStr: CURRENT_AGENT_ID_STR,
          paramCategoryCode: tempCategoryCode,
          paramAmountJust: tempAmountJust,
          paramTypeOfPayment: tempTypeOfPayment,
          paramComment: tempCleanComment,
          paramJustRef: tempJustRef,
          paramTechHd: tempInitTicket,
          token: GET_TOKEN
        },  // data to submit
        success: function (data, status, xhr) {
          $('#msg-alert').html(tempJustRef + " a été créé avec succés.");
          $('#type-alert').addClass('alert-primary').removeClass('alert-danger');
          $('#ace-alert-msg').show(100);
          $('#ace-alert-msg').hide(1000*7);
          console.log('Data retrieved: ' + data['justLastID']);

          // ADD THE ELEMENT IN THE GRID AFTER SAVE
  
            // Reset with the new value
            /*
            'justLastID'
            tempInitTicket = 'na'
            tempCategoryCode = 0;
            tempCategory = "na";
            tempAmountJust = 0;
            tempTypeOfPayment = 'C';
            tempComment = 'na';
            tempCleanComment = 'na';
            */

            let newJustItem = {
                UJ_ID: data['justLastID'],
                UJ_CAT_ID: tempCategoryCode,
                UJ_STATUS: 'P',
                UJ_PAY_DATE: getReportACEDateStrFR(0),
                UJ_JUST_REF: tempJustRef,
                UJ_AMT: tempAmountJust,
                UJ_TYPE: tempTypeOfPayment,
                UJ_AGENT_ID: CURRENT_AGENT_ID_STR,
                UJ_COMMENT: tempCleanComment,
                UJ_TECH_INIT_HD: tempInitTicket,
                MU_AGENT_USERNAME: 'ACTUEL',
                URJ_CODE: tempCategoryCode,
                URJ_TITLE: tempCategory,
                URJ_BOARD: 'N',
                URJ_COMMENT_MAND: 'Y',
                URJ_WR_LIMIT: 0,
                URJ_ORDER: 0,
                UJ_WARN: (tempAmountJust > tempAmountWarn ? 'Y' : 'N'),
                IS_DIRTY: 'Y',
                raw_data: (tempCategory + tempJustRef + tempCleanComment).toUpperCase()
            };
            dataAllJUSTToJsonArray.unshift(newJustItem);
            filtereddataAllJUSTToJsonArray.unshift(newJustItem);
            clearDataAllJUST();

            generateJustPrint(ticketRef + 'J');
        },
        error: function (jqXhr, textStatus, errorMessage) {
          $('#msg-alert').html("ERR697J: " + tempJustRef + " création justificatif impossible, contactez le support. ");
          $('#type-alert').removeClass('alert-primary').addClass('alert-danger');
          $('#ace-alert-msg').show(100);
        }
    });
}


function generateJustPrint(paramTicket){
    /**************** HISTORY *****************/
    let doc = new jsPDF('p', 'mm', [(55 + (myTicket.length * 7)), 75]);
    doc.setFont("Courier");
    doc.setFontType("bold");
  
    doc.setTextColor(0, 0, 0);
    doc.addImage(document.getElementById('logo-carte'), //img src
                  'PNG', //format
                  11, //x oddOffsetX is to define if position 1 or 2
                  0, //y
                  50, //Width
                  16, null, 'FAST'); //Height // Fast is to get less big files
  
  
    doc.setFontSize(7);
    doc.setFontType("normal");
    //doc.text(18, 25, "REDUCTION 50%");
    let margTop = 22;
    let contentHeight = 0;
    doc.setFontSize(8);
    // Print Ticket Identification Information but to 5 lines only
    // Test comment
    for(var i=0; i< myTicket.length; i++){
      contentHeight = margTop + (i*5);
      if(i>0){
        doc.text(maxPadLeft, contentHeight, myTicket[i].substring(0, (maxLgTicket - maxPrintTicket)));
      }
      else{
        doc.text(maxPadLeft, contentHeight, myTicket[i].substring(maxPrintTicket));
      }
    }
    // Footer
    doc.text(maxPadLeft, contentHeight + (myTicket.length*5), getLogInAddJust(msgFooterJUST).substring(0, (maxLgTicket - maxPrintTicket)));

    contentHeight = contentHeight + 20;
    doc.setFontSize(5);
    let filename = paramTicket;
    doc.text(5, contentHeight, "JUST_Fich_" + filename + "_TICKET");
  
    doc.save("JUST_Fich_" + filename + "_TICKET");
  
}
/*************************************************/
/*************************************************/
/*************************************************/
/*************************************************/
/*************************************************/
/*************************************************/
/*************************************************/

// Common as right ticket
function updateTicketType(type){
    ticketType =  type;
    tempJustRef = ticketRef + type;
    $('#sh-ticketref').html(tempJustRef);
}
function getTicketTime(){
    let myNow = new Date();
    return myNow.getHours().toString().padStart(2, '0') + ":" + myNow.getMinutes().toString().padStart(2, '0') + ":" + myNow.getSeconds().toString().padStart(2, '0');
}
function initLogInAddJust(){
    let myNow = new Date();
    let date = myNow.getDate().toString().padStart(2, '0')+'/'+(myNow.getMonth()+1).toString().padStart(2, '0')+'/'+myNow.getFullYear();
    let time = getTicketTime();
  
    appendLog = ('GÉNÉRÉ LE ' + date + sepTime + time).toString().padStart(maxLgTicket, paddChar);
    lblDate = date;
    $('#pay-sc-log-tra').html('');

    myBreak = '';

    let ticketRefTime = myNow.getHours().toString().padStart(2, '4') + myNow.getMinutes().toString().padStart(2, '0') + myNow.getSeconds().toString().padStart(2, '0');
    // This will be HHMMss + Day of the year on 3 digit + Type
    ticketRef = ticketRefTime + (Math.floor((myNow - new Date(myNow.getFullYear(), 0, 0)) / 1000 / 60 / 60 / 24)).toString().padStart(3, '0');

    let tdate = myNow.getDate().toString().padStart(2, '0')+'_'+(myNow.getMonth()+1).toString().padStart(2, '0')+'_'+myNow.getFullYear();
    let ttime = myNow.getHours().toString().padStart(2, '0') + "h" + myNow.getMinutes().toString().padStart(2, '0') + "m" + myNow.getSeconds().toString().padStart(2, '0');

    ticketRefFile = tdate + "_" + ttime;
    updateTicketType('J');

    tempInitTicket = appendLog;
    /** Common part */
    /*
    let myLog = $('#pay-sc-log-tra').html();
    myTicket.push(appendLog);
    $('#pay-sc-log-tra').html(myLog + myBreak + appendLog);
    */
}
function getLogInAddJust(someMsg){
    let time = getTicketTime();
  
    let appendLog = '';

    // I am not on init here
    appendLog = (someMsg.substring(0, (maxLgTicket - sizeTime)) + sepTime + time).toString().padStart(maxLgTicket, paddChar);

    /** Common part */
    /*
    let myLog = $('#pay-sc-log-tra').html();
    myTicket.push(appendLog);
    $('#pay-sc-log-tra').html(myLog + myBreak + appendLog);
    */
    return appendLog;
};
function displayLogInJust(){
    let myBreak = '<br>';
    let appendLog = tempInitTicket + myBreak;

    if(tempCategory == "na"){
        appendLog = appendLog + getLogInAddJust('na') + myBreak;
    }
    else{
        appendLog = appendLog + getLogInAddJust('CTG: ' + tempCategory) + myBreak;
    }

    if(tempAmountJust == 0){
        appendLog = appendLog + getLogInAddJust('REF*MONTANT: na') + myBreak;
    }
    else{
        appendLog = appendLog + getLogInAddJust('REF*MONTANT:' + renderAmount(tempAmountJust)) + myBreak;
    }

    if(tempTypeOfPayment == 'C'){
        appendLog = appendLog + getLogInAddJust('TYPE: CASH') + myBreak;
    }
    else{
        appendLog = appendLog + getLogInAddJust('TYPE: CHEQUE') + myBreak;
    }

    appendLog = appendLog + getLogInAddJust('COMMENTAIRE') + myBreak;
    let comMaxLgTicket = (maxLgTicket - sizeTime);
    /*
    console.log('comMaxLgTicket: ' + comMaxLgTicket);
    console.log('maxLgTicket: ' + maxLgTicket);
    console.log('tempComment.length: ' + tempComment.length);
    */
    if(tempComment.length < comMaxLgTicket){
        appendLog = appendLog + getLogInAddJust(tempComment.replaceAll(' ', '.')) + myBreak;
    }
    else{
        let comArray = splitStringPerSize(tempComment, (comMaxLgTicket-1));
        for(let i=0; i<comArray.length; i++){
            appendLog = appendLog + getLogInAddJust(comArray[i].replaceAll(' ', '.')) + myBreak;
        }
    }
    
    $('#pay-sc-log-tra').html(appendLog);
}
function fillLogInJust(){
    myTicket = new Array();
    myTicket.push(tempInitTicket);
    myTicket.push(getLogInAddJust('REF: ' + ticketRef + 'J'));
    myTicket.push(getLogInAddJust('CTG: ' + tempCategory));
    myTicket.push(getLogInAddJust('REF*MONTANT:' + renderAmount(tempAmountJust)));

    if(tempTypeOfPayment == 'C'){
        myTicket.push(getLogInAddJust('TYPE: CASH'));
    }
    else{
        myTicket.push(getLogInAddJust('TYPE: CHEQUE'));
    }
    myTicket.push(getLogInAddJust('COMMENTAIRE'));
    let comMaxLgTicket = (maxLgTicket - sizeTime);
    if(tempComment.length < comMaxLgTicket){
        myTicket.push(getLogInAddJust(tempComment.replaceAll(' ', '.')));
    }
    else{
        let comArray = splitStringPerSize(tempComment, (comMaxLgTicket-1));
        for(let i=0; i<comArray.length; i++){
            myTicket.push(getLogInAddJust(comArray[i].replaceAll(' ', '.')));
        }
    }
}
function printJustDetail(paramID){
    let i = 0;
    let isFound = 'N';
    do {
        if(filtereddataAllJUSTToJsonArray[i].UJ_ID == paramID){
            isFound = 'Y';
        }
        else{
            i = i + 1;
        }
    }
    while ((i < filtereddataAllJUSTToJsonArray.length) && (isFound == 'N'));

    if(isFound == 'Y'){
        // Then perform the print
        myTicket = new Array();
        myTicket.push(filtereddataAllJUSTToJsonArray[i].UJ_TECH_INIT_HD);
        myTicket.push(getLogInAddJust('REF: ' + filtereddataAllJUSTToJsonArray[i].UJ_JUST_REF));
        myTicket.push(getLogInAddJust('CTG: ' + filtereddataAllJUSTToJsonArray[i].URJ_TITLE));
        myTicket.push(getLogInAddJust('REF*MONTANT:' + renderAmount(filtereddataAllJUSTToJsonArray[i].UJ_AMT)));

        if(filtereddataAllJUSTToJsonArray[i].UJ_TYPE == 'C'){
            myTicket.push(getLogInAddJust('TYPE: CASH'));
        }
        else{
            myTicket.push(getLogInAddJust('TYPE: CHEQUE'));
        }
        myTicket.push(getLogInAddJust('COMMENTAIRE'));
        let comMaxLgTicket = (maxLgTicket - sizeTime);
        if(filtereddataAllJUSTToJsonArray[i].UJ_COMMENT.length < comMaxLgTicket){
            myTicket.push(getLogInAddJust(filtereddataAllJUSTToJsonArray[i].UJ_COMMENT.replaceAll(' ', '.')));
        }
        else{
            let comArray = splitStringPerSize(filtereddataAllJUSTToJsonArray[i].UJ_COMMENT, (comMaxLgTicket-1));
            for(let i=0; i<comArray.length; i++){
                myTicket.push(getLogInAddJust(comArray[i].replaceAll(' ', '.')));
            }
        }

        generateJustPrint(filtereddataAllJUSTToJsonArray[i].UJ_JUST_REF);
    }
    else{
        console.log('ERROR printJustDetail Not found: ' + paramID);
    }
}
function showAddModal(){
    myTicket = new Array();
    tempInitTicket = 'na'
    tempCategoryCode = 0;
    tempCategory = "na";
    tempAmountJust = 0;
    tempAmountWarn = 0;
    tempTypeOfPayment = 'C';
    tempComment = 'na';
    tempCleanComment = 'na';
    tempJustRef = 'na'

    updateTypeJust('stt-c');
    $('#amt-just-input').val('');
    $("#just-cmt").val('');
    $('#drp-select').html('Catégorie');

    $('#cat-det').html('');
    initLogInAddJust();
    displayLogInJust();
    $('#pay-add-just-modal').modal('show');
}

function testRegexAmountJust(param){
    const RE = /^[1-9]+[0-9]*[0][0]$/;
    if(param.length == 0){
      return true;
    }
    else if(RE.test(param)){
      if(parseInt(param) < MAX_AMT_JUST_VALUE){
        return true;
      }
      else{
          // We are not a or A or we are bigger than 10
          return false;
      }
    }
    else{
      return false;
    }
}
function validateAmountJust(){
    let invAmount = $('#amt-just-input').val();
    if(testRegexAmountJust(invAmount)){
        $('#amt-just-input').removeClass('err-txtar');
        if($('#amt-just-input').val() != ''){
            $('#amt-just-input').addClass('ok-txtar');
        }
        tempAmountJust = parseInt(invAmount);
    }
    else{
        $('#amt-just-input').removeClass('ok-txtar').addClass('err-txtar');
        tempAmountJust = 0;
    }
    displayLogInJust();
    verifyIfAllIsFilledNewJustificatif();
}

function verifyIfAllIsFilledNewJustificatif(){
    let isAllvalid = true;
  
    if((tempCategoryCode == 0) && (isAllvalid)){
      isAllvalid = false;
    }
  
    if((tempCategory == "na") && (isAllvalid)){
      isAllvalid = false;
    }
  
    if(tempCommentMandatory ==  'Y'){
        if((tempComment.length == 0) || (tempComment == 'na')){
            isAllvalid = false;
        }
    }
  
    if((!testRegexAmountJust($('#amt-just-input').val())) && (isAllvalid)){
      isAllvalid = false;
    }
    // Save we need to removeAllQuotes
  
    // TODO : Then I have to work on the list of parcours to validate.
    
    if(isAllvalid){
      //console.log('New subject can be saved');
      $('#just-save-btn').show(100);
    }
    else{
      //console.log('New subject CANNOT be saved');
      $('#just-save-btn').hide(100);
    }
    return 0;
}

function selectCategory(paramId){
    tempCategoryCode = dataCategoryToJsonArray[paramId].id;
    tempCategory = dataCategoryToJsonArray[paramId].title;
    tempCommentMandatory = dataCategoryToJsonArray[paramId].mandatory_comment;
    tempAmountWarn = parseInt(dataCategoryToJsonArray[paramId].warn_limit);

    
    $('#drp-select').html(tempCategory);
    $('#cat-det').html(dataCategoryToJsonArray[paramId].title +
         (dataCategoryToJsonArray[paramId].mandatory_comment == 'Y' ? ' - commentaire obligatoire' : '' ));
    displayLogInJust();
    verifyIfAllIsFilledNewJustificatif();
}

function updateTypeJust(activeId){
    tempTypeOfPayment = $('#' + activeId).val();
    $('.stt-group').removeClass('active');  // Remove any existing active classes
    $('#' + activeId).addClass('active'); // Add the class to the nth element
    displayLogInJust();
}

function manageJustComment(){
  let readInputText = $("#just-cmt").val();
  //console.log('in verifyTextAreaSaveBtn: ' + readInputText);
  let textInputLength = readInputText.length;
  $("#just-cmt-length").html((MAX_NOTE_LENGTH-textInputLength) < 0 ? 0 : (MAX_NOTE_LENGTH-textInputLength));

  if(textInputLength > MAX_NOTE_LENGTH){
    $("#just-cmt").val(readInputText.substring(0, MAX_NOTE_LENGTH));
  }
  if(textInputLength == 0){
    tempComment = 'na';
  }
  else{
    tempComment = $("#just-cmt").val();
  }
  displayLogInJust();
  verifyIfAllIsFilledNewJustificatif();
}


function fillCartoucheCategory(){
    let listCategory = '';
    for(let i=0; i<dataCategoryToJsonArray.length; i++){
        listCategory = listCategory + '<a class="dropdown-item" onclick="selectCategory('+ i +')"  href="#">' + dataCategoryToJsonArray[i].title + '</a>';
    }
    $('#dpcategory-opt').html(listCategory);
    $('#drp-select').html('Category');
  
    // Re-init semestre
    $('#drp-semestre').html('Semestre');
    $('#dpsemestre-opt').html('<a class="dropdown-item" href="#">Sélectionnez une category</a>');
  
}


function loadAllJUSTGrid(){

    refJustField = [
        { name: "UJ_JUST_REF",
          title: "Référence",
          type: "text",
          width: 27,
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm-mono",
          itemTemplate: function(value, item) {
            if(item.IS_DIRTY == 'N'){
                return value;
            }
            else{
                return '<span class="recap-blue">' + value + '</span>';
            }
          }
        },
        { name: "URJ_TITLE",
          title: "Catégorie",
          type: "text",
          width: 40,
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm"
        },
        { name: "UJ_AMT",
          title: "Montant",
          type: "number",
          width: 40,
          align: "right",
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm",
          itemTemplate: function(value, item) {
            if(item.UJ_WARN == 'Y'){
                return '<span class="line-ju-res">' + renderAmount(value) + '</span>';
            }
            else{
                return renderAmount(value);
            }
          }
        },
        { name: "UJ_PAY_DATE",
          title: "Date",
          type: "text",
          width: 25,
          align: "right",
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm"
        },
        { name: "UJ_STATUS",
          title: "Status",
          type: "text",
          width: 25,
          align: "right",
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm",
          itemTemplate: function(value, item) {
            if(value == 'P'){
              return 'Payé';
            }
            else{
              return 'Annulé';
            }
          }
        },
        { name: "UJ_TYPE",
          title: "Type",
          type: "text",
          width: 20,
          align: "right",
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm",
          itemTemplate: function(value, item) {
            return verboseTypeOfPayment(value);
          }
        },
        //Default width is auto
        { name: "UJ_COMMENT",
          title: "Commentaire",
          type: "text",
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm",
          itemTemplate: function(value, item) {
            return '<span class="desc-sm">' + value + '</span>';
          }
        },
        { name: "UJ_ID",
          title: "",
          width: 12,
          type: "text",
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm-center",
          itemTemplate: function(value, item) {
            //return value + '%';
            return '<button onclick="printJustDetail(' + value +  ')" class="btn btn-outline-dark"><i class="icon-invoice"></i></button>';
          }
        },
        { name: "UJ_ID",
          title: "",
          width: 12,
          type: "text",
          headercss: "cell-ref-sm-hd",
          css: "cell-ref-sm-center",
          itemTemplate: function(value, item) {
            if((WRITE_ACCESS == 'Y') 
                && (item.UJ_PAY_DATE == tempCurrentDate)){
                    if(item.UJ_STATUS == 'P'){
                        return '<button onclick="goToCanJUST(' + value +  ')" class="btn btn-dark"><span class="icon-trash-o"></span></button>';
                    }
                    else{
                        return '<span class="icon-trash"></span>';
                    }
            }
            else{
              return '<span class="recap-deactivate icon-trash-o"></span>';
            }
          }
        }
    ];

    $("#jsGridAllJUST").jsGrid({
        height: "auto",
        width: "100%",
        noDataContent: "Aucun justificatif disponible",
        pageIndex: 1,
        pageSize: 50,
        pagePrevText: "Prec",
        pageNextText: "Suiv",
        pageFirstText: "Prem",
        pageLastText: "Dern",

        sorting: true,
        paging: true,
        data: filtereddataAllJUSTToJsonArray,
        fields: refJustField
    });
}

function initAllJUSTGrid(){
    $('#filter-all-just').keyup(function() {
        filterDataAllJUST();
    });
    $('#re-init-dash-just').click(function() {
      $('#filter-all-just').val('');
      clearDataAllJUST();
    });
  }
  
  function filterDataAllJUST(){
    if(($('#filter-all-just').val().length > 1) && ($('#filter-all-just').val().length < 35)){
      //console.log('We need to filter !' + $('#filter-all').val());
      filtereddataAllJUSTToJsonArray = dataAllJUSTToJsonArray.filter(function (el) {
                                        return el.raw_data.includes($('#filter-all-just').val().toUpperCase())
                                    });
        $("#mst-filcnt").html(filtereddataAllJUSTToJsonArray.length);
        loadAllJUSTGrid();
    }
    else if(($('#filter-all-just').val().length < 2)) {
      // We clear data
      clearDataAllJUST();
    }
    else{
      // DO nothing
    }
  }
  
  function clearDataAllJUST(){
    filtereddataAllJUSTToJsonArray = Array.from(dataAllJUSTToJsonArray);
    $("#mst-filcnt").html(filtereddataAllJUSTToJsonArray.length);
    loadAllJUSTGrid();
  };


function generateAllJustCSV(){
    const csvContentType = "data:text/csv;charset=utf-8,";
    let csvContent = "";
    let involvedArray = filtereddataAllJUSTToJsonArray;
    const SEP_ = ";"

	let dataString = "Référence" + SEP_ 
                    + "Catégorie" + SEP_ 
                    + "Montant" + SEP_
                    + "Date de paiement" + SEP_ 
                    + "Status" + SEP_ 
                    + "Type" + SEP_ 
                    + "Commentaire" + SEP_ 
                    + "Warning" + SEP_ 
                    + "Agent" + SEP_ + "\n";
	csvContent += dataString;
	for(let i=0; i<involvedArray.length; i++){

            dataString = involvedArray[i].UJ_JUST_REF + SEP_ 
                + involvedArray[i].URJ_TITLE + SEP_ 
                + isNullMvo(involvedArray[i].UP_INPUT_AMOUNT) + SEP_ 
                + isNullMvo(involvedArray[i].UJ_PAY_DATE) + SEP_ 
                + isNullMvo(involvedArray[i].UJ_STATUS) + SEP_ 
                + isNullMvo(involvedArray[i].UJ_TYPE) + SEP_ 
                + '"' + isNullMvo(involvedArray[i].UJ_COMMENT) + '"' + SEP_ 
                + (involvedArray[i].UJ_WARN == 'Y' ? 'Oui' : 'Non') + SEP_ 
                + isNullMvo(involvedArray[i].MU_AGENT_USERNAME) + SEP_ ;
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
    link.download = 'RapportGlobalJustificatif.csv';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
}

function goToCanJUST(paramID){
    let i = 0;
    let isFound = 'N';
    do {
        if(filtereddataAllJUSTToJsonArray[i].UJ_ID == paramID){
            isFound = 'Y';
        }
        else{
            i = i + 1;
        }
    }
    while ((i < filtereddataAllJUSTToJsonArray.length) && (isFound == 'N'));

    if(isFound == 'Y'){
            // Then perform the print
            $("#fId").val(paramID);
            $("#fJustRef").val(filtereddataAllJUSTToJsonArray[i].UJ_JUST_REF);
            $("#fJustDate").val(tempCurrentDate);
            $("#fCategory").val(filtereddataAllJUSTToJsonArray[i].URJ_TITLE);
            $("#fAmount").val(renderAmount(filtereddataAllJUSTToJsonArray[i].UJ_AMT));
            $("#fComment").val(filtereddataAllJUSTToJsonArray[i].UJ_COMMENT);

            $("#mg-cancel-form").submit();
    }
    else{
        console.log('ERR8273 goToCanJUST Not found: ' + paramID);
    }
}


function goToConfirmJust(param){
    $("#confirm-cancel-id").val(param);
    $("#mg-confirm-cancel-id-form").submit();
}

/**********************************************************************/
/**********************************************************************/
/**********************************************************************/
/**********************************************************************/
/**********************************************************************/
/**********************************************************************/
/**********************************************************************/
/**********************************************************************/
/**********************************************************************/

$(document).ready(function() {
    console.log('We are in ACE-JUST');
    if($('#mg-graph-identifier').text() == 'man-just'){
        tempCurrentDate = getReportACEDateStrFR(0);
        // Case of cancellation
        if(confirmCancelId > 0){
          showHeaderAlertMsg("L'annulation du justificatif #" + confirmCancelId + " a été terminée avec succès.", 'Y');
          setTimeout(closeAlertMsg, 4000);
        }

        loadAllJUSTGrid();
        initAllJUSTGrid();
        // Do something
        fillCartoucheCategory();
        // Refresh status
        $( ".stt-group" ).click(function() {
            updateTypeJust(this.id);
        });
    }
    else{
      //Do nothing
    }
  
});