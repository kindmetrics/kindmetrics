import { Controller } from "stimulus"
import ApexCharts from 'apexcharts'
export default class extends Controller {

  createChart(ctx, response) {
    const { labels, data, pageviews } = response

    var options = {
      chart: {
        type: 'line',
        height: 300,
        zoom: {
          enabled: false
        },
        animations: {
          enabled: true,
          easing: 'easeinout',
          speed: 400,
          animateGradually: {
            enabled: false
          },
          dynamicAnimation: {
            enabled: false
          }
        },
        toolbar: {
          show: false
        }
      },
      grid: {
        show: false
      },
      markers: {
        size: 0,
        hover: {
          size: 0
        }
      },
      series: [
        {
          name: "Visitors",
          data: data
        },
        {
          name: "Pageviews",
          data: pageviews
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
        dashArray: [0, 0]
      },
      colors: ['#30475e', '#3182ce'],
      xaxis: {
        type: 'category',
        categories: labels,
        tooltip: {
          enabled: false
        },
        labels: {
          show: false
        },
        showForNullSeries: false
      },
      yaxis: {
        labels: {
          show: false
        }
      }
    }
    var chart = new ApexCharts(ctx, options);
    this.element.innerHTML =""
    chart.render();
  }

  getData() {
    const from = this.data.get("from")
    const to = this.data.get("to")
    var url = this.data.get("url") + "?from=" + from + "&to=" + to
    const goal = this.data.get("goal")
    const site_path = this.data.get("site-path")
    const source = this.data.get("source")
    const medium = this.data.get("medium")
    const country = this.data.get("country")
    const browser = this.data.get("browser")
    if(goal != null) {
      url = url + "&goal_id=" + goal
    }
    if(source != null) {
      url = url + "&source=" + source
    }
    if(medium != null) {
      url = url + "&medium=" + medium
    }
    if(site_path != null) {
      url = url + "&site_path=" + site_path
    }
    if(country != null) {
      url = url + "&country=" + country
    }
    if(browser != null) {
      url = url + "&browser=" + browser
    }
    fetch(url).then(response => {
      return response.json()
    }).then(response => {
      return this.createChart(this.element, response)
    })
  }

  connect() {
    this.getData();
  }
}
