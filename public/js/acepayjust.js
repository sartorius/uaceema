// Common as right ticket
function updateTicketType(type){
    ticketType =  type;
    $('#sh-ticketref').html(ticketRef + type);
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
    let myBreak = '<br>';

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
function showAddModal(){
    tempInitTicket = 'na'
    tempCategoryCode = 0;
    tempCategory = "na";
    tempAmountJust = 0;
    tempTypeOfPayment = 'na';
    tempComment = 'na';

    $('#cat-det').html('');
    initLogInAddJust();
    $('#pay-add-just-modal').modal('show');
}

function verifyIfAllIsFilledNewJustificatif(){

}

function selectCategory(paramId){
    tempCategoryCode = dataCategoryToJsonArray[paramId].id;
    tempCategory = dataCategoryToJsonArray[paramId].title;

    
    $('#drp-select').html(tempCategory);
    $('#cat-det').html(dataCategoryToJsonArray[paramId].title +
         (dataCategoryToJsonArray[paramId].mandatory_comment == 'Y' ? ' - commentaire obligatoire' : '' ));
  
    getLogInAddJust(tempCategory);
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


$(document).ready(function() {
    console.log('We are in ACE-JUST');
    if($('#mg-graph-identifier').text() == 'man-just'){
      // Do something
      fillCartoucheCategory();
    }
    else{
      //Do nothing
    }
  
});