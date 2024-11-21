Date.prototype.addDays = function(days) {
    var date = new Date(this.valueOf());
    date.setDate(date.getDate() + days);
    return date;
};

function initUsedRoom(){
  for(let i=0; i<dataUsedRoomToJsonArray.length; i++){
    let cell = dataUsedRoomToJsonArray[i].course_id.toString().split("-");
    dataUsedRoomToJsonArray[i].cell_1_shift = cell[0];
    dataUsedRoomToJsonArray[i].cell_2_day = cell[1];
    dataUsedRoomToJsonArray[i].cell_3_half = cell[2];
  }
}

/**************** Export Function ****************/

function removeWaitingCB(){
  $(".white-ajax-wait").hide(100);
}

function exportFile(){
  $(".start-h-emp").html('');
  launchExportFile();

}

function goToExistingEDT(){
  $("#read-master-id").val(edtExistAlreadyMasterId);
  $("#read-jq-type").val(edtExistAlreadyMasterIdJQType);

  $("#mg-master-id-form").submit();
}

function launchExportFile(){
  $('#title-edt-export').html(tempClasse);

  var wb = XLSX.utils.table_to_book(document.getElementById('my-main-table'));
  XLSX.writeFile(wb, 'EDT' + invMondayStr.replaceAll('-', '_') + tempClasse.replaceAll(' ', '_').replaceAll('/', '_') + '.xlsx');
  drawMainEDT(removeWaitingCB, 'launchExportFile');
}

// order can be D as Draft or V as Visible
function publishEDT(order){
  $(".white-ajax-wait").show(100);
  for(let i=0; i<myEDTArray.length; i++){
      myEDTArray[i].techDate = getInvTechDate(myEDTArray[i].courseId); // To be filled for publish
      myEDTArray[i].techDateMonday = invMondayStr;
  }
  // Then you go in AJAX !!!
  $.ajax('/jqPostEDTDB', {
      type: 'POST',  // http method
      data: {
        // Control
        currentUserId: currentUserId,
        token : getToken,
        // Real data
        invCohortId: tempClasseID,
        invTechMonday: invMondayStr,
        invTitle: removeAllQuotes(removeAccentuated($('#ttl-note-input').val().trim())).length == 0 ? 'NA' : removeAllQuotes(removeAccentuated($('#ttl-note-input').val().trim())),
        orderEDT: order,
        myEDTArray: JSON.stringify(myEDTArray)

      },  // data to submit
      success: function (data, status, xhr) {
          $('.edt-status').removeClass('bg-red-error');
          $(".white-ajax-wait").hide(100);
          $("#exist-msg-edt").hide(100);
          // Do something as success
          let lastOrder = (order == 'D' ? '&nbsp;Brouillon&nbsp;' : '&nbsp;Publication&nbsp;');
          let msg = "<i class='aj-succ'>" + lastOrder + " effectué le&nbsp;" + data['result_integration_EDT'][0]['last_update'] + "</i>";
          let addOrderMsg = "<br>Tant que cet EDT n'a pas été publié, les étudiants ne le verront pas.";
          if(order == 'V'){
            addOrderMsg = "<br>Nombre de jour(s) passé recalculé(s) :" + data['result_integration_EDT'][0]['day_recalc'];
          }
          let modalmsg = "<i class='aj-succ'><strong>" + lastOrder + " effectué(e) avec succès&nbsp;<i class='icon-check-square nav-text'></i></strong></i>." + addOrderMsg;
          $("#last-update").html(msg);
          startOnOffEdit();

          tempMisc = data['result_integration_EDT'];

          $("#ajax-feedback").html("EDT opération " + modalmsg);
          $('#aj-fback-modal').modal('show');


          //console.log('Everything is fine: ' + data['status'] + ' ' + data['message']);
      },
      error: function (jqXhr, textStatus, errorMessage) {
        
        $('.edt-status').addClass('bg-red-error');

        $(".white-ajax-wait").hide(100);
        let lastOrder = (order == 'D' ? '&nbsp;Brouillon&nbsp;' : '&nbsp;Publication&nbsp;');
        let msg = "<strong>" + lastOrder + "erreur serveur: " + jqXhr['status'] + "&nbsp;<i class='icon-exclamation-triangle nav-text'></i></strong>";
        $("#last-update").html(msg);

        msg = "<i class='err'>" + msg + "</i>";
        $("#ajax-feedback").html('Attention: ' + msg + '. Veuillez contacter le support.');
        $('#aj-fback-modal').modal('show');
        // Do something as error here
        //console.log('Something went wrong: ' + jqXhr['status'] + ' ' + textStatus);
      }
  });
}
/**************** CARTOUCHE ****************/
function displayDatePicker(){
  let listDate = '';
  for(let i=0; i<dispMondaysToJsonArray.length; i++){
      listDate = listDate + '<button id="wmon-' + i + '" type="button" value="' + techMondaysToJsonArray[i] + '" onclick="selectDatePicker(' + i + ')" class="btn btn-outline-' + ((i == 1) ? 'primary' : 'secondary') + ' wmon-group ' + ((i == 2) ? 'active' : '') + '">' + dispMondaysToJsonArray[i] + '</button>';
  }
  $('#crs-wmonday').html(listDate);
}

function selectDatePicker(i){
  $(".wmon-group").removeClass('active');
  $('#wmon-' + i).addClass('active');
  invMondayStr = techMondaysToJsonArray[i];
  dispMonday = dispMondaysToJsonArray[i];
  let invMonday = new Date(invMondayStr);
  let myCurrentDate = new Date();
  if(invMonday < myCurrentDate){
    // For current and past week
    $('#past-msg-edt').show(100);
  }
  else{
    $('#past-msg-edt').hide(100);
  }
  $("#publish-cls").html('&nbsp;' + dispMonday + '&nbsp;-&nbsp;[' + tempClasse + ']');
  handleEDTForMondayExists();
  // Now you draw the full EDT
  drawMainEDT(removeWaitingCB, 'selectDatePicker');
}

function fillCartoucheMention(){
  let listMention = '';
  for(let i=0; i<dataMentionToJsonArray.length; i++){
      listMention = listMention + '<a class="dropdown-item" onclick="selectMention(\'' + dataMentionToJsonArray[i].par_code + '\', \'' + dataMentionToJsonArray[i].title + '\')"  href="#">' + dataMentionToJsonArray[i].title + '</a>';
  }
  $('#dpmention-opt').html(listMention);
}


function selectMention(str, strTitle){
  tempMentionCode = str;
  tempMention = strTitle;
  $('#drp-select').html(strTitle);
  //console.log('You have just click on: ' + str);
  // We reset the dropdown
  selectClasse(0, 'Classe', 0);
  fillCartoucheClasse();
  $('#teacher-blk').show(100);
  fillModalTeacher();
}

function fillCartoucheClasse(){
  let listClasse = '';
  for(let i=0; i<dataAllClassToJsonArray.length; i++){
    if(dataAllClassToJsonArray[i].mention_code == tempMentionCode){
      listClasse = listClasse + '<a class="dropdown-item" onclick="selectClasse(' + dataAllClassToJsonArray[i].id + ', \'' + dataAllClassToJsonArray[i].short_classe + '\', 1)"  href="#">' + dataAllClassToJsonArray[i].short_classe + '</a>';
    }
  }
  $('#dpclasse-opt').html(listClasse);
}


function fillModalTeacher(){
  let teacherList = "";
  filteredTeacherList = new Array();
  for(let i=0; i<dataTeacherToJsonArray.length; i++){
    if(dataTeacherToJsonArray[i].mention_code == tempMentionCode){
      //teacherList = teacherList + '<option value="' + dataTeacherToJsonArray[i].id + '" >' + dataTeacherToJsonArray[i].name + '</option>';
      teacherList = teacherList + '<option data-id="' + dataTeacherToJsonArray[i].id + '">' + dataTeacherToJsonArray[i].name + '</option>';
      // Input in the list
      filteredTeacherList.push(dataTeacherToJsonArray[i].name);
    }
    else{
      // do nothing
    }
  }
  $('#teach-list').html(teacherList);
}



function checkTeacher(){
  let selectedTeacherId = $('#teach-list option').filter(function() {
                              return this.value === $('#teach-sel').val();
                          }).data("id");
  if(selectedTeacherId == undefined){
    $("#teach-sel-msg").show(100);
    tempTeacherName = '';
    tempTeacherId = 0;
    //console.log('You lose focus on teacher: checkTeacher: ' + $('#teach-sel').val() + ' Not defined');
  }
  else{
    $("#teach-sel-msg").hide(100);
    //console.log('You lose focus on teacher: checkTeacher: ' + $('#teach-sel').val() + ' : ' + selectedTeacherId);
    tempTeacherName = $('#teach-sel').val();
    tempTeacherId = selectedTeacherId;
  }
  // Check now if it is in the list of not
  
}

function doesEDTForMondayExists(){
  let foundId = -1;
  for(let i=0; i<dataAllMasterToJsonArray.length; i++){
    if(
      (dataAllMasterToJsonArray[i].cohort_id == tempClasseID) &&
      (dataAllMasterToJsonArray[i].monday_ofthew == invMondayStr)
    ){
        foundId = i;
        return foundId;
    }
  }
  return foundId;
}

function handleEDTForMondayExists(){
    let edtForMondayExistIndex = -1;
    // The class is selected but we need to inform if an EDT exists !
    // Do we have an EDT
    edtForMondayExistIndex = doesEDTForMondayExists();
    if(edtForMondayExistIndex > 0){
      // An EDT exist we need to warn the user
      $("#exist-msg-edt").show(100);
      edtExistAlready = 'Y';
      edtExistAlreadyMasterId = dataAllMasterToJsonArray[edtForMondayExistIndex].id;
      edtExistAlreadyMasterIdJQType = dataAllMasterToJsonArray[edtForMondayExistIndex].jq_edt_type;
      $('#btn-load-jqedt').prop("disabled", false);
      $('#btn-load-jqedt').removeClass('btn-outline-dark').addClass('btn-danger');
    }
    else{
      //invalid charger
      $("#exist-msg-edt").hide(100);
      edtExistAlready = 'N';
      edtExistAlreadyMasterId = 0;
      edtExistAlreadyMasterIdJQType = 'Y';
      $('#btn-load-jqedt').prop("disabled", true);
      $('#btn-load-jqedt').removeClass('btn-danger').addClass('btn-outline-dark');
    }
}

function selectClasse(classeId, str, humanAction){
  tempClasseID = classeId;
  tempClasse = str;

  $("#selected-class").html(str);
  tempCountStu = getQtyStu(classeId);
  $("#sel-stu-qty").html(tempCountStu);

  if(humanAction == 1){
    $("#exist-msg-edt").html(msgExistEdtForMonday);
  }

  // We display the save block only when class is selected.
  if(classeId > 0){
      handleEDTForMondayExists();
      $("#publish-cls").html('&nbsp;' + dispMonday + '&nbsp;-&nbsp;[' + str + ']'); //tempClasse
      $(".bdt-save-pub").prop("disabled", false);
      $("#btn-edit-jqedt").prop("disabled", false);
      $("#edt-save-blk").show(100);
      if((mode == 'LOA') && (dataLoadToJsonArray.length > 0) && (tokenToBeBurnOnlyOnce == 'Y')){
        //Do this only once at first load in case we load the file to avoid graphic show/hide
        tokenToBeBurnOnlyOnce = 'N';
      }
      else{
        switchTitleEdit('Y');
      }
  }
  else{
      $("#publish-cls").html('');
      $("#edt-save-blk").hide(100);
      $("#btn-edit-jqedt").prop("disabled", true);
      switchTitleEdit('N');
  }
  //console.log('You have just classeId: ' + classeId);
  // Refresh necessary to identify overcapacity
  drawMainEDT(removeWaitingCB, 'selectClasse');
}

function getQtyStu(classeId){
  for(let i=0; i<dataCountStuToJsonArray.length; i++){
    if(dataCountStuToJsonArray[i].COHORT_ID == classeId){
      return dataCountStuToJsonArray[i].CPT_STU;
    }
  }
  return 0;
}
/**************** MODAL ****************/
function verifyTextAreaSaveBtn(){

  let readInputText = $("#crs-desc").val();
  //console.log('in verifyTextAreaSaveBtn: ' + readInputText);
  let textInputLength = readInputText.length;
  $("#crs-desc-length").html(maxRawCourseTitleLength-textInputLength);

  if(textInputLength > maxRawCourseTitleLength){
    $("#crs-desc").val(readInputText.substring(0, maxRawCourseTitleLength));
  }

  let checkOverlap = verifyOverlap();
  if(checkOverlap == 'na'){
    // We are good, there is no overlap
    $('#modal-crs-err').html('');
    if((textInputLength > 0) && (tempHalfHourTotalShiftDuration > 0)){
      $('#save-edt-line').prop("disabled", false);
    }
    else{
      $('#save-edt-line').prop("disabled", true);
    }
  }
  else{
    //There is overlap
    $('#modal-crs-err').html('<i class="err"><strong>Conflit avec : [' + checkOverlap + '...]. Réduisez sa durée ou supprimez le cours suivant.</strong></i>');

  }
}

function verifyOverlap(){
  let cell = tempCourseId.toString().split("-");
  for(let i=0; i<myEDTArray.length; i++){
      //We look for overlaping here for conflict hour and day
      if((parseInt(cell[1]) == parseInt(myEDTArray[i].techDay)) &&
            // End time is > than Start over Time which is not good
            (parseInt(cell[0]) + parseInt(tempHalfHourTotalShiftDuration) > parseInt(myEDTArray[i].techHour)) &&
            // Additionnally if our Start Time is also before then we are not good definitively
            (parseInt(cell[0]) < parseInt(myEDTArray[i].techHour))
          ){
        return myEDTArray[i].startTime + '/' + myEDTArray[i].rawCourseTitle.substring(0, 10);
      }
  }
  return 'na';
}

function calculateEndDate(){
  //console.log("We in calculateEndDate");
  let myNow = new Date("June 26 1960 " + tempStartTime);

  let newNow = new Date(myNow.getTime() + tempHalfHourTotalShiftDuration*30*60000);
  let newTime = newNow.getHours().toString().padStart(2, '0') + ":" + newNow.getMinutes().toString().padStart(2, '0');

  //console.log('myNow: '+ myNow + ' - newNow: ' + newNow + ' - newTime:' + newTime);
  tempEndTime = newTime;
  $("#disp-t-end").html('<i class="icon-android-alarm-clock nav-text"></i>&nbsp;Shift(s): ' + tempHalfHourTotalShiftDuration + '<i class="icon-hourglass-half nav-text"></i>&nbsp;Fin du cours:&nbsp;<strong><i class="crs-imp">'+ newTime +'</i></strong>');
  // Allow the room selection
  fillModalRoom();

  // Allow Button Save or not
  verifyTextAreaSaveBtn();
}

function selectHourDur(i, shiftStart){
  $('.btn-sel-hour').removeClass('active');  // Remove any existing active classes
  $('#sel-hour-' + i).addClass('active'); // Add the class to the nth element

  tempHourDuration = i;
  $("#disp-h-duration").html(tempHourDuration);

  tempHalfHourShiftDuration = tempHourDuration*2;
  tempHalfHourTotalShiftDuration = tempHalfHourShiftDuration;
  calculateEndDate();

  //console.log(i + '/' + shiftStart);

  // I overpass the available time for the day
  if(i == 0){
    // We block the minute choice because we have taken zero hour so automatically 30min
    fillModalMinDuration(shiftStart, false, false);
  }
  else if(((i*2) + shiftStart) < (refHoursStart.length*2)){
    fillModalMinDuration(shiftStart, true, false);
  }
  else{
    // We reach the limit and not half is permitted
    //console.log('We have reach the hour limit');
    selectMinDur(0);
    fillModalMinDuration(shiftStart, true, true);
  }
}

function selectMinDur(i){
  tempMinDuration = i;
  $(".btn-sel-min").removeClass('active');
  $("#disp-m-duration").html(i == 0 ? '00' : tempMinDuration);

  if(i == 30){
    tempHalfHourTotalShiftDuration = tempHalfHourShiftDuration + 1;
  }
  else{
    tempHalfHourTotalShiftDuration = tempHalfHourShiftDuration;
  }
  calculateEndDate();

  //console.log('Valeur sel min: ' + '#sel-min-' + i);
  $('#sel-min-' + i).addClass('active');
}

function getRoomIndexFromId(myId){
  for(let i=0; i<dataAllRoomToJsonArray.length; i++){
    if(dataAllRoomToJsonArray[i].id == myId){
      return i;
    }
  }
  return -1;
}

function selectRoom(i){
  //Warning the user may not select any room to keep the default. In that case we keep it zero but we need to adapt tempCourseRoomCapacity
  let index = getRoomIndexFromId(i);
  tempCourseRoomId = dataAllRoomToJsonArray[index].id;
  tempCourseRoom = dataAllRoomToJsonArray[index].name;
  tempCourseRoomCapacity = dataAllRoomToJsonArray[index].capacity;
  verifyTextAreaSaveBtn();
}

function isRoomAlreadyUsedMsg(roomId){
  let warnMsg = "";
  //dataUsedRoomToJsonArray
  if(roomId > 0){
      for(let i=0; i<dataUsedRoomToJsonArray.length; i++){
          //filter first on the week
          if(dataUsedRoomToJsonArray[i].uem_monday_ofthew == invMondayStr){
            //filter on the room
            if(dataUsedRoomToJsonArray[i].room_id == roomId){
              // Now we need to check the day !
              let cell = tempCourseId.toString().split("-");
              // hour shift is 0 and day is 1
              if(dataUsedRoomToJsonArray[i].cell_2_day == cell[1]){
                  // Now it is getting serious we work on overlap
                  // Case one : New is starting before the end of Ancient
                  let usedEndOld = parseInt(dataUsedRoomToJsonArray[i].cell_1_shift) + parseInt(dataUsedRoomToJsonArray[i].shift_duration);
                  let tempEndNew = parseInt(cell[0]) + parseInt(tempHalfHourTotalShiftDuration);
                  if((usedEndOld > parseInt(cell[0])) &&
                      // We check here that the new is starting after
                      (parseInt(cell[0]) >= parseInt(dataUsedRoomToJsonArray[i].cell_1_shift))
                    ){
                    // The used course is not finished
                    // Get out here
                    return 'Indisponible: ' + dataUsedRoomToJsonArray[i].short_classe + ' - Fin: ' + dataUsedRoomToJsonArray[i].end_time;
                  }
                  else if((tempEndNew > parseInt(dataUsedRoomToJsonArray[i].cell_1_shift)) &&
                          // We check here that the new is starting before
                          (parseInt(cell[0]) <= parseInt(dataUsedRoomToJsonArray[i].cell_1_shift))
                          ){
                    // The used course is starting
                    // Get out here
                    return 'Indisponible: ' + dataUsedRoomToJsonArray[i].short_classe + ' - Début: ' + dataUsedRoomToJsonArray[i].start_time;
                  }
                  else{
                    // Do nothing as no 
                  }
                  // Case two : New is finishing after the start of Ancient

              }
              else{
                // Not the good day, we do nothing
              }
            }
            else{
              // Not the good room, we do nothing
            }
          }
          else{
            //Not the good Monday, we do nothing
          }
      }
  }
  else{
    // Do nothing
  }
  return warnMsg;
}

function fillModalRoom(){
  //console.log("in fillModalRoom");
  let listRoom = '';
  let optionDisplay = '';
  if((tempClasseID == 0) || (tempHalfHourTotalShiftDuration == 0)){
    let msgDurMiss = ((tempHalfHourTotalShiftDuration == 0) ? '&nbsp;[Durée manquante]' : '');
    listRoom = listRoom + '<option value="' + dataAllRoomToJsonArray[0].id + '">' + dataAllRoomToJsonArray[0].name + msgDurMiss + '</option>';
    tempCourseRoomId = 0;
    tempCourseRoomCapacity = 0;
  }
  else{
    for(let i=0; i<dataAllRoomToJsonArray.length; i++){
      //console.log("value i: " + i + " id: " + dataAllRoomToJsonArray[i].id + " capacity: " + dataAllRoomToJsonArray[i].capacity + " name: " + dataAllRoomToJsonArray[i].name + " tempCountStu: " + tempCountStu);
      if(parseInt(dataAllRoomToJsonArray[i].capacity) >= parseInt(tempCountStu)){
        //console.log("fillModalRoom: " + dataAllRoomToJsonArray[i]);
        // Once we are here we need to compare with existing occupied room
        //console.log("in capacity ----- > value i: " + i + " id: " + dataAllRoomToJsonArray[i].id + " capacity: " + dataAllRoomToJsonArray[i].capacity + " name: " + dataAllRoomToJsonArray[i].name + " tempCountStu: " + tempCountStu);
        let usedMsg = isRoomAlreadyUsedMsg(dataAllRoomToJsonArray[i].id);
        if(i == 0){
          optionDisplay = dataAllRoomToJsonArray[i].name;
        }
        else if(usedMsg == ''){
          optionDisplay = dataAllRoomToJsonArray[i].category + ': ' + dataAllRoomToJsonArray[i].name + '&nbsp;[' + dataAllRoomToJsonArray[i].capacity + ']' + (dataAllRoomToJsonArray[i].is_video == 'Y' ? ' avec vidéo' : '');
        }
        else{
          optionDisplay = dataAllRoomToJsonArray[i].category + ': ' + dataAllRoomToJsonArray[i].name + '&nbsp;(' + usedMsg + ')';
        }
        

        listRoom = listRoom + '<option value="' + dataAllRoomToJsonArray[i].id + '">' + optionDisplay + '</option>';
        //console.log("Here is listRoom: " + listRoom + " tempCountStu: " + tempCountStu);
      }
      else{
        //do nothing we do not display
      }
    }
  }
  $("#my-room-select").html(listRoom);
}

function fillModalHourDuration(shiftStart){

  let modalHourDuration ='';
  let limitHour = refHoursStart.length + 1;
  let leftTime = limitHour - parseInt(Math.round(shiftStart/2));
  //console.log(shiftStart + '/' + refHoursStart.length + '/' + limitHour + '/' + leftTime);
  for(let i=0; i< limitHour; i++){
    //console.log(i + '/' + leftTime + '/' + shiftStart + '/' + limitHour);
    if(i<leftTime){
      modalHourDuration = modalHourDuration + '<button id="sel-hour-' + i + '" type="button" class="btn btn-outline-primary btn-sel-hour" onclick="selectHourDur(' + i + ', ' + shiftStart + ')">' + i + 'h</button>';
    }
    else{
      modalHourDuration = modalHourDuration + '<button type="button" class="btn btn-outline-secondary" disabled>' + i + 'h</button>';
    }

  }
  //We are on the last line
  let cell = tempCourseId.toString().split("-");
  //console.log('cell[0]: ' + cell[0]);
  if(cell[0] == 21){
    selectHourDur(0, shiftStart);
  }
  $('#hour-duration').html(modalHourDuration);
}

function fillModalMinDuration(shiftStart, displayZero, closeBoth){
  //console.log(shiftStart + '/' + displayZero + '/' + closeBoth);
  let modalMinDuration ='';
  if((shiftStart< 22) && (!closeBoth)){
    if(displayZero){
      modalMinDuration = modalMinDuration + '<button id="sel-min-0" type="button" class="btn btn-outline-primary btn-sel-min" onclick="selectMinDur(0)">00min</button>';
      modalMinDuration = modalMinDuration + '<button id="sel-min-30" type="button" class="btn btn-outline-primary btn-sel-min" onclick="selectMinDur(30)">30min</button>';
    }
    else{
      modalMinDuration = modalMinDuration + '<button type="button" class="btn btn-outline-secondary" disabled>00min</button>';
      modalMinDuration = modalMinDuration + '<button id="sel-min-30" type="button" class="btn btn-outline-primary btn-sel-min active">30min</button>';
      selectMinDur(30);
    }
  }
  else{
    modalMinDuration = modalMinDuration + '<button type="button" class="btn btn-outline-secondary" disabled>00min</button>';
    modalMinDuration = modalMinDuration + '<button type="button" class="btn btn-outline-secondary" disabled>30min</button>';
  }
  $('#min-duration').html(modalMinDuration);
}

function updateCrsStatus(activeId){
  tempCourseStatus = $('#' + activeId).val();
  $('.stt-group').removeClass('active');  // Remove any existing active classes
  $('#' + activeId).addClass('active'); // Add the class to the nth element
  //console.log('updateCrsStatus: ' + $('#' + activeId).val());
  // Allow Button Save or not
  $('#crs-desc').removeClass('modal-edt-n1');
  $('#crs-desc').removeClass('modal-edt-n2');
  if(activeId == 'stt-1'){
    $('#crs-desc').addClass('modal-edt-n1');
  }
  else if(activeId == 'stt-2'){
    $('#crs-desc').addClass('modal-edt-n2');
  }
  else{
    // Do nothing
  };
  verifyTextAreaSaveBtn();
}

/**************** FUNCTION ****************/
function getInvDate(str){
  let cell = str.toString().split("-");
  return dateArray[cell[1] - 1];
}

function getInvTechDate(str){
  let cell = str.toString().split("-");
  return techDateArray[cell[1] - 1];
}

function getRefDayCode(str){
  let cell = str.toString().split("-");
  return refDayCode[cell[1] - 1];
}

function getRefEnglishDay(str){
  let cell = str.toString().split("-");
  return refEnglishDay[cell[1]];
}

function getInvDay(str){
  let cell = str.toString().split("-");
  return refDays[cell[1]];
}

function getStartHour(str){
  let cell = str.toString().split("-");
  tempStartTime = (refHoursStart[parseInt(cell[0]/2)]).toString().replaceAll('h', ':');
  if(cell[2] == 1){
    // We are on the first half
    tempStartTime = tempStartTime + "00";
  }
  else{
    // We are on the secund half
    tempStartTime = tempStartTime + "30";
  }
  return tempStartTime;
}

function findCourse(courseId){
  let foundIndex = -1;
  for(let i=0; i<myEDTArray.length; i++){
    if(myEDTArray[i].courseId == courseId){
      return i;
    }
  }
  return foundIndex;
}

function myEDTRowSpanDebtArrayContains(str){
  for(let i=0; i<myEDTRowSpanDebtArray.length; i++){
    if(myEDTRowSpanDebtArray[i] == str){
      return true;
    }
  }
  return false;
}

function startOnOffEdit(){
  if(editMode == 'N'){
    // We start edit here
    editMode = 'Y';
    editModeOn();
    $("#btn-edit-name").html("Figer EDT");
    $("#last-update").html('en cours de modification.');
    switchTitleEdit(editMode);
    refreshCellClick('startOnOffEdit');
  }
  else{
    // If we are here then the button has change and we must edit
    // We block Edit here
    editMode = 'N';
    editModeOff();
    $("#btn-edit-name").html("Modifier EDT");
    switchTitleEdit(editMode);
  }

}

function clearEDT(){
  myEDTArray = new Array();
  // Need to remove debt
  myEDTRowSpanDebtArray = new Array();
  drawMainEDT(removeWaitingCB, 'clearEDT');
}

function reinitDateArrays(){
  let refInvMonday = new Date(Date.parse(invMondayStr));
  dateArray = new Array();
  techDateArray = new Array();

  for(let i=0; i<refDays.length; i++){
    dateArray.push("<i class='nosee'>[</i>" + refInvMonday.addDays(i).getDate().toString().padStart(2, '0')+'.'+(refInvMonday.addDays(i).getMonth()+1).toString().padStart(2, '0') + "<i class='nosee'>]</i>");
    techDateArray.push(refInvMonday.addDays(i).getFullYear() + '-' + (refInvMonday.addDays(i).getMonth()+1).toString().padStart(2, '0') + '-' + refInvMonday.addDays(i).getDate().toString().padStart(2, '0'));
  };
}

function drawMainEDT(callBack, caller){
  if(myEDTArray.length > 1){
    //$(".white-ajax-wait").show(100);
  }
  //console.log("call DrawMainEDT called by: " + caller);
  let tableText = '<table id="my-main-table" style="width: 100%" class="' + classBackground + '"><tbody>';

  reinitDateArrays();

  // This will not be visible and will be necessary only for export EXCEL
  tableText =  tableText + '<tr id="table-header-export" style="height: 0px"><td colspan="7">' + '<i id="title-edt-export"></i>' + '</td></tr>';

  // Manage DAYS TR Line 0
  tableText = tableText + '<tr style="height: 35px">'
  for(let i=0; i<refDays.length; i++){
    tableText = tableText + '<th class="myedt-day">';
    tableText = tableText + refDays[i];
    tableText = tableText + '</th>';
  };
  tableText = tableText + '</tr>'

  // Manage DATE TR Line 0
  tableText = tableText + '<tr style="height: 25px"><td class="myedt-hour-hd">Heure</td>'

  for(let i=0; i<(refDays.length - 1); i++){
    tableText = tableText + '<th class="myedt-date">'

    // Display the date
    tableText = tableText + dateArray[i];
    tableText = tableText + '</th>'

  };
  tableText = tableText + '</tr>'

  // Manage REAL GAME HERE HALF HOUR TIME HERE
  let halfHourLine = 1;
  let labelHour = 0;
  let cellId = '';
  let shortCellId = '';
  let crsStatus = '';
  let courseTitleTemp = '';
  let myCourseRoom = '';
  let myTeacher = '';

  for(let i=0; i<(refHours.length*2); i++){
    tableText = tableText + '<tr style="border:1px solid black; height : ' + constRowHalfSize + 'px">';
    if(halfHourLine == 1){
      tableText = tableText + '<td rowspan="2" class="myedt-hour">' + refHours[labelHour] + '</td>';
      labelHour++;
    }
    // FIRST HALF
    for(let j=1; j<refDays.length; j++){

      //cell is HourLine-Day-Half
      shortCellId = i + '-' + j;
      cellId = shortCellId + '-' + halfHourLine;
      let cellIndex = findCourse(cellId);
      //console.log('cellId: ' + cellId + ' cellIndex: ' + cellIndex);
      if(cellIndex>-1){
        // Reinitialise the room
        myCourseRoom = '';
        if(myEDTArray[cellIndex].courseRoomId > 0){
            myCourseRoom = '<br><strong>Salle:&nbsp;' + myEDTArray[cellIndex].courseRoom + '</strong>';
        }
        myTeacher = '';
        if(myEDTArray[cellIndex].teacherId > 0){
          myTeacher = myEDTArray[cellIndex].teacherName + '<br>';
        }
        courseTitleTemp = myEDTArray[cellIndex].rawCourseTitle + myCourseRoom + '<br>' + myTeacher + myEDTArray[cellIndex].startTime + ' à ' + myEDTArray[cellIndex].endTime;

        let overCapacity = "";
        if((parseInt(tempCountStu) > 0) && (parseInt(tempCountStu) > parseInt(myEDTArray[cellIndex].courseRoomCapacity))){
          overCapacity = "<i class='err'>[Capacité salle dépassée]</i><br>";
          courseTitleTemp = overCapacity + courseTitleTemp;
        }
        // Get the course status here
        switch (myEDTArray[cellIndex].courseStatus) {
          case 'A':
            crsStatus = '';
            break;
          case 'C':
            crsStatus = '-can';
            courseTitleTemp = 'ANNULÉ : <i class="ua-line">' + courseTitleTemp + '</i>';
            break;
          case 'H':
            crsStatus = '-hos';
            courseTitleTemp = '<strong>Hors site</strong> : ' + courseTitleTemp;
            break;
          case 'M':
            crsStatus = '-mis';
            courseTitleTemp = 'ANNULÉ PROF ABS : <i class="ua-line">' + courseTitleTemp + '</i>';
            break;
          case '1':
            crsStatus = '-n1';
            courseTitleTemp = '<strong>Note 1</strong> : ' + courseTitleTemp;
            break;
          case '2':
            crsStatus = '-n2';
            courseTitleTemp = '<strong>Note 2</strong> : ' + courseTitleTemp;
            break;
          default:
            // Last case
            crsStatus = '-opt';
            courseTitleTemp = '<strong>Option</strong> : ' + courseTitleTemp;
        }

        tableText = tableText + '<td id="' + cellId + '" rowspan="' + myEDTArray[cellIndex].shiftDuration + '" class="myedt-course' + crsStatus + ' jqedt-crs">' + courseTitleTemp + '</td>';
      }
      else{
        if(myEDTRowSpanDebtArrayContains(shortCellId)){
          //We do nothing;
        }
        else{
          //tableText = tableText + '<td id="' + cellId + '" class="myedt-course-empty jqedt-crs">' + cellId + '</td>';
          tableText = tableText + '<td id="' + cellId + '" class="myedt-course-empty jqedt-crs"><i class="start-h-emp">' + refHalfHoursStart[i] + '</i></td>';
        }
      }
    }
    tableText = tableText + '</tr>';

    if(halfHourLine == 1){
      halfHourLine++;
    }
    else{
      halfHourLine = 1;
    }
  }

  tableText = tableText  + '</tbody></table>';
  $('#main-edt').html(tableText);

  // Previously refreshCellClick here
  refreshCellClick('drawMainEDT');
  if(editMode == 'N'){
    editModeOff();
  }

  if (typeof callBack == "function"){
    callBack();
  }
}

// Load all EDT from the DB
function loadEDT(){
  myEDTArray = new Array();
  for(let i=0; i<dataLoadToJsonArray.length; i++){
    let cell = dataLoadToJsonArray[i].course_id.toString().split("-");
    let myEDTLine = {
                      courseId: dataLoadToJsonArray[i].course_id,
                      startTime: dataLoadToJsonArray[i].uel_start_time,
                      endTime: dataLoadToJsonArray[i].uel_end_time,
                      // Need the int only for DB
                      startTimeHour: dataLoadToJsonArray[i].uel_hour_starts_at,
                      startTimeMin: dataLoadToJsonArray[i].uel_min_starts_at,
                      // Need the int only for DB
                      endTimeHour: parseInt(dataLoadToJsonArray[i].uel_end_time.toString().split(":")[0]),
                      endTimeMin: parseInt(dataLoadToJsonArray[i].uel_end_time.toString().split(":")[1]),
                      techHour: cell[0],
                      techDay: cell[1],
                      hourDuration: dataLoadToJsonArray[i].uel_duration_hour,
                      minuteDuration: dataLoadToJsonArray[i].uel_duration_min,
                      shiftDuration: dataLoadToJsonArray[i].uel_shift_duration,
                      displayDate: dataLoadToJsonArray[i].nday,
                      techDate: null,
                      techDateMonday: null,
                      rawCourseTitle: dataLoadToJsonArray[i].raw_course_title,
                      refDayCode: dataLoadToJsonArray[i].day_code,
                      courseStatus: dataLoadToJsonArray[i].course_status,
                      courseRoomId: dataLoadToJsonArray[i].urr_id,
                      courseRoom: dataLoadToJsonArray[i].urr_name,
                      teacherId: dataLoadToJsonArray[i].teacher_id,
                      teacherName: dataLoadToJsonArray[i].teacher_name,
                      courseRoomCapacity: dataLoadToJsonArray[i].room_capacity,
                      refEnglishDay: dataLoadToJsonArray[i].uel_label_day
                      };
      myEDTArray.push(myEDTLine);

      for(let j = 1; j<dataLoadToJsonArray[i].uel_shift_duration; j++){
        myEDTRowSpanDebtArray.push( (parseInt(cell[0])+j).toString() + '-' + cell[1]);
      }
  }
}

function editModeOff(){
  $('#dropdownMention').addClass('disabled');
  $('#dropdownClasse').addClass('disabled');
  $("#dropdownMention").addClass('edit-sel-off');
  $("#dropdownClasse").addClass('edit-sel-off');
  $(".wmon-group").addClass('disabled');
  $(".wmon-group").addClass('edit-sel-off');
  $('#btn-clear-jqedt').prop("disabled", true);
  //$("#edt-save-blk").hide(100); We don't hide because we want to still export
  $(".bdt-save-pub").prop("disabled", true);
  // Special case for the load as it does not depend of the On OFF
  $('#btn-load-jqedt').prop("disabled", true);
  $("#my-main-table").addClass('edit-sel-off');
}

function editModeOn(){
  $('#dropdownMention').removeClass('disabled');
  $('#dropdownClasse').removeClass('disabled');
  $("#dropdownMention").removeClass('edit-sel-off');
  $("#dropdownClasse").removeClass('edit-sel-off');
  $(".wmon-group").removeClass('disabled');
  $(".wmon-group").removeClass('edit-sel-off');
  $('#btn-clear-jqedt').prop("disabled", false);
  //$("#edt-save-blk").show(100); We don't hide because we want to still export
  $(".bdt-save-pub").prop("disabled", false);
  if(edtExistAlready == 'Y'){
    $('#btn-load-jqedt').prop("disabled", false);
    $('#btn-load-jqedt').removeClass('btn-outline-dark').addClass('btn-danger');
    
  }
  else{
    $('#btn-load-jqedt').prop("disabled", true);
    $('#btn-load-jqedt').removeClass('btn-danger').addClass('btn-outline-dark');
  }
  $("#my-main-table").removeClass('edit-sel-off');
}

function saveCourse(){
  //let myEDTLine = [tempCourseId, tempStartTime, tempEndTime, tempHourDuration, tempMinDuration, tempHalfHourTotalShiftDuration];
  //console.log("saveCourse");
  let cell = tempCourseId.toString().split("-");
  let myEDTLine = {
                    courseId: tempCourseId,
                    startTime: tempStartTime,
                    endTime: tempEndTime,
                    // Need the int only for DB
                    startTimeHour: parseInt(tempStartTime.split(":")[0]),
                    startTimeMin: parseInt(tempStartTime.split(":")[1]),
                    // Need the int only for DB
                    endTimeHour: parseInt(tempEndTime.split(":")[0]),
                    endTimeMin: parseInt(tempEndTime.split(":")[1]),
                    techHour: cell[0],
                    techDay: cell[1],
                    hourDuration: tempHourDuration,
                    minuteDuration: tempMinDuration,
                    shiftDuration: tempHalfHourTotalShiftDuration,
                    displayDate: getInvDay(tempCourseId),
                    techDate: null,  // To be filled for publish
                    techDateMonday: null,
                    rawCourseTitle: $("#crs-desc").val(),
                    refDayCode: getRefDayCode(tempCourseId),
                    courseStatus: tempCourseStatus,
                    courseRoomId: tempCourseRoomId,
                    courseRoom: tempCourseRoom,
                    teacherName: tempTeacherName,
                    teacherId: tempTeacherId,
                    // dataAllRoomToJsonArray[0].capacity should be 10000
                    courseRoomCapacity: (tempCourseRoomId == 0 ? parseInt(dataAllRoomToJsonArray[0].capacity) : tempCourseRoomCapacity),
                    refEnglishDay: getRefEnglishDay(tempCourseId)
                    /*
                    courseId: tempCourseId,
                    startTime: tempStartTime,
                    endTime: tempEndTime,
                    techHour: cell[0],
                    techDay: cell[1],
                    hourDuration: tempHourDuration,
                    minuteDuration: tempMinDuration,
                    shiftDuration: tempHalfHourTotalShiftDuration,
                    displayDate: getInvDay(tempCourseId),
                    techDate: getInvTechDate(tempCourseId), // To be filled for publish
                    rawCourseTitle: $("#crs-desc").val(),
                    refDayCode: getRefDayCode(tempCourseId),
                    courseStatus: tempCourseStatus,
                    courseRoomId: tempCourseRoomId,
                    courseRoom: tempCourseRoom,
                    refEnglishDay: getRefEnglishDay(tempCourseId)

                    */
                    };

   // Here we are in case of update
   // We need to remove the previous item and save the new one
   // And manage the debt
   deleteCourse();

   myEDTArray.push(myEDTLine);
   //input debt here now
   for(let i = 1; i<tempHalfHourTotalShiftDuration; i++){
     myEDTRowSpanDebtArray.push( (parseInt(cell[0])+i).toString() + '-' + cell[1]);
   }

   $('#exampleModal').modal('toggle');
   drawMainEDT(removeWaitingCB, 'saveCourse');
}

function deleteCourse(){
  let cell = tempCourseId.toString().split("-");
  let index = findCourse(tempCourseId);
  let tempCell = '';
  if(index > -1){
    let debtShiftDuration = myEDTArray[index].shiftDuration;
    // for(let i = 0; i<tempHalfHourTotalShiftDuration; i++){
    // We need to remove the full debt 
    for(let i = 0; i<debtShiftDuration; i++){
      
      for(let j=0; j<myEDTRowSpanDebtArray.length; j++){
        tempCell = myEDTRowSpanDebtArray[j].split("-");
        if((tempCell[1] == cell[1]) && (tempCell[0] == (parseInt(cell[0])+i).toString())){
          myEDTRowSpanDebtArray.splice(j, 1);
          //console.log("Here is my: " + j + " length: " + myEDTRowSpanDebtArray.length);
        }
      } // end of j loop
    } // end of i loop
    myEDTArray.splice(index, 1);
  }
}

function deleteCourseAndDisplay(){
  deleteCourse();
  $('#exampleModal').modal('toggle');
  drawMainEDT(removeWaitingCB, 'deleteCourseAndDisplay');
}

// Load the data to the modal
// Load the course data to the modal
function loadExistingIfExist(courseId){
  let index = findCourse(courseId);
  //console.log('loadExistingIfExist: ' + index);

  if(index > -1){
    //console.log('loadExistingIfExist > 0 ' + index);
    tempHourDuration = myEDTArray[index].hourDuration;

    let shift = (courseId).toString().split("-");
    selectHourDur(tempHourDuration, shift[0]);

    /*
    $('#sel-hour-' + tempHourDuration).addClass('active');
    tempHalfHourShiftDuration = parseInt(myEDTArray[index].hourDuration)*2;
    */

    tempMinDuration =  myEDTArray[index].minuteDuration;
    selectMinDur(tempMinDuration);
    /*
    tempHalfHourTotalShiftDuration = tempHalfHourShiftDuration;
    if(tempMinDuration == 30){
      tempHalfHourTotalShiftDuration = tempHalfHourShiftDuration + 1;
      $('#sel-min-30').addClass('active');
    }
    */

    tempStartTime = myEDTArray[index].startTime;
    tempEndTime = myEDTArray[index].endTime;
    tempCourseStatus = myEDTArray[index].courseStatus;
    $('.stt-group').removeClass('active');
    $('#stt-' + tempCourseStatus.toLowerCase()).addClass('active');

    // Check if we are in note 1 or 2
    $('#crs-desc').removeClass('modal-edt-n1');
    $('#crs-desc').removeClass('modal-edt-n2');
    if(tempCourseStatus === '1'){
      $('#crs-desc').addClass('modal-edt-n1');
    }
    else if(tempCourseStatus === '2'){
      $('#crs-desc').addClass('modal-edt-n2');
    }
    else{
      // Do nothing because it is not 
    };

    // This must work only if the capacity is working
    // Else we have the issue A
    //in case of overcapacity we need to force in non specifié
    if(tempCountStu > tempCourseRoomCapacity){
      $("#my-room-select").val(0);
      tempCourseRoom = dataAllRoomToJsonArray[0].name;
      tempCourseRoomId = 0;
      tempCourseRoomCapacity = parseInt(dataAllRoomToJsonArray[0].capacity);
    }
    else{
      $("#my-room-select").val(tempCourseRoomId);
      tempCourseRoom = myEDTArray[index].courseRoom;
      tempCourseRoomId = myEDTArray[index].courseRoomId;
      tempCourseRoomCapacity = myEDTArray[index].courseRoomCapacity;
    }

    if(myEDTArray[index].teacherId > 0){
      $('#teach-sel').val(myEDTArray[index].teacherName);
      tempTeacherName = myEDTArray[index].teacherName;
      tempTeacherId = myEDTArray[index].teacherId;
    }

    $('#crs-desc').val(myEDTArray[index].rawCourseTitle);

    // Then we allow delete
    $('#delete-edt-line').prop("disabled", false);
  }
  else{
    // Block delete
    $('#delete-edt-line').prop("disabled", true);
  }
}

function refreshCellClick(caller){
  // Click on the editing this is not available for not editor
  // console.log('refreshCellClick called by: ' + caller);
  $( ".jqedt-crs" ).click(function() {
    let cell = this.id.toString().split("-");
    //console.log("You click on .jqedt-crs :" + this.id + ": " + getStartHour(this.id) + " le " + getInvDay(this.id) + ' ' + getInvDate(this.id)+ ' ' + getInvTechDate(this.id));
    //$("#exampleModal").show(100);
    tempHourDuration = 0;
    tempMinDuration = 0;
    tempHalfHourShiftDuration = 0;
    tempHalfHourTotalShiftDuration = 0;

    tempCourseId = this.id;
    tempStartTime = '';
    tempEndTime = '';
    tempCourseStatus = 'A';
    tempCourseRoom = '';
    tempCourseRoomId = 0;
    tempCourseRoomCapacity = 0;
    $("#crs-desc").val('');

    $("#crs-desc-length").html(maxRawCourseTitleLength);
    // Remove color for description
    $('#crs-desc').removeClass('modal-edt-n1');
    $('#crs-desc').removeClass('modal-edt-n2');

    let infosCours = '';
    infosCours = infosCours + '<i class="icon-calendar nav-text"></i>&nbsp;<strong>' + getInvDay(this.id) + '</strong>&nbsp;';
    infosCours = infosCours + getInvDate(this.id) + '&nbsp;';
    infosCours = infosCours + '<i class="icon-flag-1 nav-text"></i>&nbsp;' + 'Début du cours: <strong><i class="crs-imp">' + getStartHour(this.id) + '</i></strong>&nbsp;<i class="icon-group-full nav-text"></i>&nbsp;<i id="sel-stu-qty">' + tempCountStu + '</i><br>';
    $('#modal-crs-infos').html(infosCours);
    $('#' + this.id).removeClass(classBackground).addClass('focusClassBackground');

    let shift = (this.id).toString().split("-");
    fillModalHourDuration(shift[0]);
    fillModalMinDuration(shift[0], true, true);
    $('#save-edt-line').prop("disabled", true);
    $('#modal-crs-err').html('');
    // Get the teacher list empty
    $('#teach-sel').val('');
    tempTeacherName = '';
    tempTeacherId = 0;
    $("#teach-sel-msg").hide(100);

    $('#teach-sel').focusout(checkTeacher)
    fillModalRoom();


    loadExistingIfExist(tempCourseId);

    $('#exampleModal').modal('show');
  });

  // Refresh status
  updateCrsStatus('stt-a');
  $( ".stt-group" ).click(function() {
    updateCrsStatus(this.id);
  });

  $('#exampleModal').on('hidden.bs.modal', function () {
    // When close redo the full Main EDT
    //console.log("$('#exampleModal').on('hidden.bs.modal', function ()");
    //drawMainEDT(removeWaitingCB, 'refreshCellClick');
  })

}

function switchTitleEdit(paramEdit){
  if(paramEdit == 'Y'){
    $("#disp-ttl-note").hide(100);
    $("#ttl-note-input").show(100);
  }
  else{
    $("#disp-ttl-note").show(100);
    $("#ttl-note-input").hide(100);
    if($('#ttl-note-input').val().trim().length > 0){
      $("#ttl-note").html($('#ttl-note-input').val().trim());
    }
    else{
      $("#ttl-note").html('NA');
    }
  }
}

/***********************************************************************************************************/

$(document).ready(function() {
  //console.log('We are in ACE-EDT');

  if($('#mg-graph-identifier').text() == 'jqc-edt'){
    initUsedRoom();
    // We need to wait for the ready we hide them else mismatch in design
    $("#edt-save-blk").hide(100);
    displayDatePicker();
    fillCartoucheMention();

    if((mode == 'LOA') && (dataLoadToJsonArray.length > 0)){
      invMondayStr = techMondaysToJsonArray[1];
      dispMonday = dispMondaysToJsonArray[1];
      selectDatePicker(1);
      // Then we are in load mode we need to hydrate the JSON
      selectMention(dataLoadToJsonArray[0].mention_code, dataLoadToJsonArray[0].mention);
      // We get it empty because select Class will flash it
      $("#exist-msg-edt").html('');
      selectClasse(dataLoadToJsonArray[0].cohort_id, dataLoadToJsonArray[0].short_classe, 0);
      $("#exist-msg-edt").hide(100);
      // Update the status
      let statusMsgLoad = '';
      if(dataLoadToJsonArray[0].visibility == 'V'){
        statusMsgLoad = ' Publication le : ';
      }
      else{
        statusMsgLoad = ' Brouillon enregistré le : ';
      }
      $("#last-update").html(statusMsgLoad + dataLoadToJsonArray[0].last_update);
      // We need to refresh room here because they re defined here
      if(dataLoadToJsonArray[0].course_id != null){
        loadEDT();
      }
      else{
        // We do nothing as the EDT is empty
      }
      editMode = 'N';
      //Set Title
      $('#ttl-note-input').val(removeNonASCII(dataLoadToJsonArray[0].master_title));
      switchTitleEdit(editMode);
      
    }
    else{
      editMode = 'Y';
      $("#exist-msg-edt").html(msgExistEdtForMonday);
    }


    /***** WORK ON EDT *****/
    drawMainEDT(removeWaitingCB, 'Ready');
  }
  else if($('#mg-graph-identifier').text() == 'xxx'){
    // Do something
  }
  else{
    //Do nothing
  }



});
