import { Controller } from "stimulus"
import ApexCharts from 'apexcharts'
export default class extends Controller {

  createChart(ctx, response) {
    console.log("inside create")
    console.log(response)

    const { labels, today, data, pageviews, pageviews_today } = response

    var options = {
      chart: {
        type: 'line',
        height: 300,
        zoom: {
          enabled: false
        },
        animations: {
          speed: 400,
          animateGradually: {
            enabled: false
          },
          dynamicAnimation: {
            enabled: false
          }
        }
      },
      series: [
        {
          name: "Visitors",
          data: data
        },
        {
          name: "Visitors",
          data: today
        },
        {
          name: "Pageviews",
          data: pageviews
        },
        {
          name: "Pageviews",
          data: pageviews_today
        }
      ],
      dataLabels: {
        enabled: false
      },
      toolbar: {
        show: false
      },
      legend: {
        show:false
      },
      stroke: {
        width: [5, 5, 5, 5],
        curve: 'straight',
        dashArray: [0, 5, 0, 5]
      },
      colors: ['#30475e', '#30475e', '#3182ce', '#3182ce'],
      xaxis: {
        type: 'category',
        categories: labels,
        tooltip: {
          enabled: false
        }
      }
    }
    var chart = new ApexCharts(ctx, options);
    this.element.innerHTML =""
    chart.render();
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
