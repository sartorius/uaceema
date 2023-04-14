Date.prototype.addDays = function(days) {
    var date = new Date(this.valueOf());
    date.setDate(date.getDate() + days);
    return date;
};
/**************** CARTOUCHE ****************/
function fillCartouche(){
  let listMention = '';
  for(let i=0; i<dataMentionToJsonArray.length; i++){
      listMention = listMention + '<a class="dropdown-item" href="#">' + dataMentionToJsonArray[i].title + '</a>';
  }
  $('#dpmention-opt').html(listMention);
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
      if((cell[1] == myEDTArray[i].techDay) && (parseInt(cell[0]) + parseInt(tempHalfHourTotalShiftDuration) > myEDTArray[i].techHour)){
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
  return refEnglishDay[cell[1] - 1];
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

function drawMainEDT(){
  let tableText = '<table style="width: 100%" class="' + classBackground + '"><tbody>';
  let refInvMonday = new Date(Date.parse(invMondayStr));

  dateArray = new Array();

  // Manage DAYS TR Line 0
  tableText = tableText + '<tr style="height: 35px">'
  for(let i=0; i<refDays.length; i++){
    tableText = tableText + '<th class="myedt-day">'
    tableText = tableText + refDays[i];
    tableText = tableText + '</th>'

    dateArray.push(refInvMonday.addDays(i).getDate().toString().padStart(2, '0')+'/'+(refInvMonday.addDays(i).getMonth()+1).toString().padStart(2, '0'));
    techDateArray.push(refInvMonday.addDays(i).getFullYear() + '-' + (refInvMonday.addDays(i).getMonth()+1).toString().padStart(2, '0') + '-' + refInvMonday.addDays(i).getDate().toString().padStart(2, '0'));
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

  for(let i=0; i<(refHours.length*2); i++){
    tableText = tableText + '<tr style="border:1px solid black; height : 60px">';
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
        // Get the course status here
        courseTitleTemp = myEDTArray[cellIndex].rawCourseTitle;
        switch (myEDTArray[cellIndex].courseStatus) {
          case 'A':
            crsStatus = '';
            break;
          case 'C':
            crsStatus = '-can';
            courseTitleTemp = 'ANNULÉ : <i class="ua-line">' + myEDTArray[cellIndex].rawCourseTitle + '</i>';
            break;
          case 'H':
            crsStatus = '-hos';
            courseTitleTemp = '<strong>Hors site</strong> : ' + myEDTArray[cellIndex].rawCourseTitle;
            break;
          default:
            // Last case
            crsStatus = '-opt';
            courseTitleTemp = '<strong>Option</strong> : ' + myEDTArray[cellIndex].rawCourseTitle;
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

  refreshCellClick();
}

function saveCourse(){
  //let myEDTLine = [tempCourseId, tempStartTime, tempEndTime, tempHourDuration, tempMinDuration, tempHalfHourTotalShiftDuration];
  let cell = tempCourseId.toString().split("-");
  let myEDTLine = {courseId: tempCourseId,
                    startTime: tempStartTime,
                    endTime: tempEndTime,
                    techHour: cell[0],
                    techDay: cell[1],
                    hourDuration: tempHourDuration,
                    minuteDuration: tempMinDuration,
                    shiftDuration: tempHalfHourTotalShiftDuration,
                    displayDate: getInvDay(tempCourseId),
                    techDate: getInvTechDate(tempCourseId),
                    rawCourseTitle: $("#crs-desc").val(),
                    refDayCode: getRefDayCode(tempCourseId),
                    courseStatus: tempCourseStatus,
                    refEnglishDay: getRefEnglishDay(tempCourseId)
                    };
   myEDTArray.push(myEDTLine);
   //input debt here now
   for(let i = 1; i<tempHalfHourTotalShiftDuration; i++){
     myEDTRowSpanDebtArray.push( (parseInt(cell[0])+i).toString() + '-' + cell[1]);
   }

   $('#exampleModal').modal('toggle');
   drawMainEDT();
}

function refreshCellClick(){
  // Click on the editing this is not available for not editor
  $( ".jqedt-crs" ).click(function() {
    let cell = this.id.toString().split("-");
    console.log("You click on .jqedt-crs :" + this.id + ": " + getStartHour(this.id) + " le " + getInvDay(this.id) + ' ' + getInvDate(this.id)+ ' ' + getInvTechDate(this.id));
    //$("#exampleModal").show(100);
    tempHourDuration = 0;
    tempMinDuration = 0;
    tempHalfHourShiftDuration = 0;
    tempHalfHourTotalShiftDuration = 0;

    tempCourseId = this.id;
    tempStartTime = '';
    tempEndTime = '';
    tempCourseStatus = 'A';
    $("#crs-desc").val('');

    $("#crs-desc-length").html(maxRawCourseTitleLength);

    let infosCours = '';
    infosCours = infosCours + '<i class="icon-calendar nav-text"></i>&nbsp;<strong>' + getInvDay(this.id) + '</strong>&nbsp;';
    infosCours = infosCours + getInvDate(this.id) + '&nbsp;';
    infosCours = infosCours + '<i class="icon-flag-1 nav-text"></i>&nbsp;' + 'Début du cours: <strong><i class="crs-imp">' + getStartHour(this.id) + '</i></strong><br>';
    $('#modal-crs-infos').html(infosCours);
    $('#' + this.id).removeClass(classBackground).addClass('focusClassBackground');

    let shift = (this.id).toString().split("-");
    fillModalHourDuration(shift[0]);
    fillModalMinDuration(shift[0], true, true);
    $('#save-edt-line').prop("disabled", true);

    $('#exampleModal').modal('show');
  });

  // Refresh status
  updateCrsStatus('stt-a');
  $( ".stt-group" ).click(function() {
    updateCrsStatus(this.id);
  });


}

/***********************************************************************************************************/

$(document).ready(function() {
  console.log('We are in ACE-EDT');

  if($('#mg-graph-identifier').text() == 'jqc-edt'){
    fillCartouche();
    drawMainEDT();
  }
  else if($('#mg-graph-identifier').text() == 'xxx'){
    // Do something
  }
  else{
    //Do nothing
  }



});
