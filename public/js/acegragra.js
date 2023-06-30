function fillStudent(){
    let strTable = '<table>';
    for(let i=0; i<dataAllUSRToJsonArray.length; i++){
        strTable = strTable + '<tr>'
                    + '<td><textarea id="gr' + i + '" name="gr' + i + '" rows="1" cols="3" placeholder="0"></textarea></td>'
                    + '<td>' + dataAllUSRToJsonArray[i].VSH_FIRSTNAME + '</td>'
                    + '<td>' + dataAllUSRToJsonArray[i].VSH_LASTNAME + '</td>'
                    + '<td>' + dataAllUSRToJsonArray[i].VSH_USERNAME + '</td>'
                    + '<td>' + (parseInt(i) + 1) + '</td>'
                    + '</tr>';
    }
    strTable = strTable + '</table>'
    $("#gra-gr").html(strTable);
}

function grow(){
    let currentW = parseInt($('#ex-1').width())*1.1;
    $('#ex-1').width(currentW);
}

function left(param){
    let direction = 1;
    if (param == 'A'){
        direction = -1;
    }
    let currentLeft = $("#ex-1").css("left");
    currentLeft = currentLeft.substring(0, currentLeft.length-2);
    document.getElementById("ex-1").style.left = parseInt(currentLeft) + (5 * direction) + "px";
}

function itop(param){
    let direction = 1;
    if (param == 'A'){
        direction = -1;
    }
    let currentTop = $("#ex-1").css("top");
    currentTop = currentTop.substring(0, currentTop.length-2);
    document.getElementById("ex-1").style.top = parseInt(currentTop) + (5 * direction) + "px";
}


function getRotationAngle(target) {
  const obj = window.getComputedStyle(target, null);
  const matrix = obj.getPropertyValue('-webkit-transform') || 
    obj.getPropertyValue('-moz-transform') ||
    obj.getPropertyValue('-ms-transform') ||
    obj.getPropertyValue('-o-transform') ||
    obj.getPropertyValue('transform');

  let angle = 0; 

  if (matrix !== 'none') 
  {
    const values = matrix.split('(')[1].split(')')[0].split(',');
    const a = values[0];
    const b = values[1];
    angle = Math.round(Math.atan2(b, a) * (180/Math.PI));
  } 
  return (angle < 0) ? angle +=360 : angle;
}


function clockW(param){
    // Access DOM element object
    let direction = 1;
    if (param == 'A'){
        direction = -1;
    }
    let rotated = document.getElementById('ex-1');
    let currentR = parseInt(getRotationAngle(rotated)) + (2*direction);
    // Rotate element by 90 degrees clockwise
    rotated.style.transform = 'rotate(' + currentR + 'deg)';
}


$(document).ready(function() {
    console.log('We are in gra gra');
    if($('#mg-graph-identifier').text() == 'gra-aex'){
      // Do something
      fillStudent();
    }
    else{
      //Do nothing
    }
  
});