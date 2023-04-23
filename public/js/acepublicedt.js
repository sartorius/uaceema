Date.prototype.addDays = function(days) {
  var date = new Date(this.valueOf());
  date.setDate(date.getDate() + days);
  return date;
};

/******************************************* START: Function COPY PAST ADMIN ********************************************/


function myEDTRowSpanDebtArrayContains(str){
  for(let i=0; i<myEDTRowSpanDebtArray.length; i++){
    if(myEDTRowSpanDebtArray[i] == str){
      return true;
    }
  }
  return false;
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

function loadEDTPublic(){
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
                      courseRoomCapacity: dataLoadToJsonArray[i].room_capacity,
                      teacherId: dataLoadToJsonArray[i].teacher_id,
                      teacherName: dataLoadToJsonArray[i].teacher_name,
                      refEnglishDay: dataLoadToJsonArray[i].uel_label_day
                      };
      myEDTArray.push(myEDTLine);

      for(let j = 1; j<dataLoadToJsonArray[i].uel_shift_duration; j++){
        myEDTRowSpanDebtArray.push( (parseInt(cell[0])+j).toString() + '-' + cell[1]);
      }
  }
}

function reinitDateArraysPublic(){
    let refInvMonday = new Date(Date.parse(invMondayStr));
    dateArray = new Array();
    techDateArray = new Array();
  
    for(let i=0; i<refDays.length; i++){
      dateArray.push(refInvMonday.addDays(i).getDate().toString().padStart(2, '0')+'/'+(refInvMonday.addDays(i).getMonth()+1).toString().padStart(2, '0'));
      techDateArray.push(refInvMonday.addDays(i).getFullYear() + '-' + (refInvMonday.addDays(i).getMonth()+1).toString().padStart(2, '0') + '-' + refInvMonday.addDays(i).getDate().toString().padStart(2, '0'));
    };
}

/******************************************* END: Function COPY PAST ADMIN ********************************************/


function publicDrawEDT(){
    let tableText = '<table id="my-main-table" style="width: 100%" class="' + classBackground + ' edit-sel-off"><tbody>';
  
    reinitDateArraysPublic();
  
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

}


/***********************************************************************************************************/

$(document).ready(function() {
    console.log('We are in ACE-PublicEDT');
    // Some part of the dashboard are handled somewhere else
  
    if($('#mg-graph-identifier').text() == 'ua-profile'){
      // We need to make sure we are JQ
      if(modeIsJQ == 'Y'){
        loadEDTPublic();
        publicDrawEDT();
      }
      else{
        // We are not JQ so we do nothing
      }
    }
    else if($('#mg-graph-identifier').text() == 'xxx'){
      // Do something
    }
    else{
      //Do nothing
    }
  
  
  
  });