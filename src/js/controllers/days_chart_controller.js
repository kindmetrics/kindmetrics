import { Controller } from "stimulus"
import Chart from 'chart.js'
export default class extends Controller {

  createChart(ctx, response) {
    console.log("inside create")
    console.log(response)

    const { labels, today, data, pageviews, pageviews_today } = response

    var gradientFill = ctx.getContext("2d").createLinearGradient(0, 260, 0, 0);
    gradientFill.addColorStop(0, "rgba(255,255,255,0.1)");
    gradientFill.addColorStop(1, "rgba(48, 71, 94, 0.3)");

    var pageviewGradientFill = ctx.getContext("2d").createLinearGradient(0, 260, 0, 0);
    pageviewGradientFill.addColorStop(0, "rgba(255,255,255,0.1)");
    pageviewGradientFill.addColorStop(1, "rgba(49, 130, 206, 0.3)");

    var chart = new Chart(ctx, {
        // The type of chart we want to create
        type: 'line',

        // The data for our dataset
        data: {
            labels: labels,
            datasets: [{
              backgroundColor: gradientFill,
              borderColor: 'rgba(48, 71, 94, 1)',
              lineTension: 0,
              pointBackgroundColor: 'rgba(48, 71, 94, 1)',
              label: 'Visitors',
              data: data
            }, {
              backgroundColor: gradientFill,
              borderColor: 'rgba(48, 71, 94, 1)',
              borderDash: [3, 12],
              lineTension: 0,
              pointBackgroundColor: 'rgba(48, 71, 94, 1)',
              label: 'Visitors',
              data: today
            }, {
              backgroundColor: pageviewGradientFill,
              borderColor: 'rgba(49,130,206, 1)',
              lineTension: 0,
              pointBackgroundColor: 'rgba(49,130,206, 1)',
              label: 'Pageviews',
              data: pageviews
            }, {
              backgroundColor: pageviewGradientFill,
              borderColor: 'rgba(49,130,206, 1)',
              borderDash: [3, 12],
              lineTension: 0,
              pointBackgroundColor: 'rgba(49,130,206, 1)',
              label: 'Pageviews',
              data: pageviews_today
            }]
        },

        // Configuration options go here
        options: {
          legend: {
              display: false
          },
          scales: {
              xAxes: [{
                  gridLines: {
                      display:false
                  }
              }],
              yAxes: [{
                  gridLines: {
                      display:false
                  }
              }]
          },
          maintainAspectRatio: false
        }
    });
  }

  getData() {
    this.element.innerHTML = this.loader()
    const period = this.data.get("period") ? this.data.get("period") : "7d"
    fetch(this.data.get("url") + "?period=" + period).then(response => {
      return response.json()
    }).then(response => {
      return this.createChart(this.element, response)
    })
  }

  connect() {
    this.getData();
  }

  loader() {
    return "<div class=\"w-1/6 mx-auto\"><div class=\"lds-ring\"><div></div><div></div><div></div><div></div></div></div>"
  }
}
