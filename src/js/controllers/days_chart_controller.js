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
    this.element.innerHTML = this.loader()
    const from = this.data.get("from")
    const to = this.data.get("to")
    var url = this.data.get("url") + "?from=" + from + "&to=" + to
    const goal = this.data.get("goal")
    const site_path = this.data.get("site-path")
    const source = this.data.get("source")
    const medium = this.data.get("medium")
    if(goal != null) {
      url = url + "&goal_id=" + goal
    }
    if(source != null) {
      url = url + "&source_name=" + source
    }
    if(medium != null) {
      url = url + "&medium_name=" + medium
    }
    if(site_path != null) {
      url = url + "&site_path=" + site_path
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

  loader() {
    return "<div class=\"w-1/6 mx-auto\"><div class=\"lds-ring\"><div></div><div></div><div></div><div></div></div></div>"
  }
}
