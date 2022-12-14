function demo1(){
  var ctx = document.getElementById('myChart').getContext('2d');
    var chart = new Chart(ctx, {
        // The type of chart we want to create
        type: 'line',

        // The data for our dataset
        data: {
            labels: ['0', '10', '20', '30', '40', '50', '60', '70', '80', '90'],
            datasets: [{
                label: 'Position du candidat',
                backgroundColor: "#8e5ea2",
                borderColor: "#8e5ea2",
                data: [0, 0, 0, 0, 5, 15, 60, 10, 7, 3]
            }]
        },

        // Configuration options go here
        options: {}
    });
};

function demo2(){
  var ctx = document.getElementById('myChart2');
  var myChart = new Chart(ctx, {
      type: 'bar',
      data: {
          labels: ['Leadership', 'Décision', 'Analyse', 'Créativité', 'Empathie', 'Sociabilité'],
          datasets: [{
              label: 'Personnalité',
              data: [12, 19, 3, 5, 2, 3],
              backgroundColor: [
                  'rgba(255, 99, 132, 0.2)',
                  'rgba(54, 162, 235, 0.2)',
                  'rgba(255, 206, 86, 0.2)',
                  'rgba(75, 192, 192, 0.2)',
                  'rgba(153, 102, 255, 0.2)',
                  'rgba(255, 159, 64, 0.2)'
              ],
              borderColor: [
                  'rgba(255, 99, 132, 1)',
                  'rgba(54, 162, 235, 1)',
                  'rgba(255, 206, 86, 1)',
                  'rgba(75, 192, 192, 1)',
                  'rgba(153, 102, 255, 1)',
                  'rgba(255, 159, 64, 1)'
              ],
              borderWidth: 1
          }]
      },
      options: {
          scales: {
              yAxes: [{
                  ticks: {
                      beginAtZero: true
                  }
              }]
          }
      }
  });
};

function demo3(){
  var ctx = document.getElementById('myChart3');

  new Chart(ctx, {
      type: 'doughnut',
      data: {
        labels: ["Calcul", "Logique", "Anglais", "Culture"],
        datasets: [
          {
            label: "capacité",
            backgroundColor: ["#3e95cd", "#8e5ea2","#3cba9f", "#c45850"],
            data: [2478,5267,734,433]
          }
        ]
      },
      options: {
      }
  });
};

function goToResultGlobal(){
  var ctx = document.getElementById('myChartGR');
  new Chart(ctx, {
      type: 'doughnut',
      data: {
        labels: ["Bonne", "Mauvaise"],
        datasets: [
          {
            label: "Global",
            backgroundColor: ["#5C0073", "#DFDFDF"],
            data: [$('#mg-global-result').text(), (100 - $('#mg-global-result').text())]
          }
        ]
      },
      options: {
      }
  });
};
