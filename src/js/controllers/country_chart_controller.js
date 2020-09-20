import { Controller } from "stimulus"
import Datamap from 'datamaps'
import { useResize } from 'stimulus-use'
export default class extends Controller {

  createChart(ctx, response) {
    const { data } = response

    var dataset = {}

    var onlyValues = data.map(function(obj){ return obj.count; });
    var minValue = Math.min.apply(null, onlyValues),
            maxValue = Math.max.apply(null, onlyValues);

    var paletteScale = d3.scale.linear()
            .domain([minValue,maxValue])
            .range(["#EFEFFF","#02386F"]);

    data.forEach(function(item){ //
        // item example value ["USA", 70]
        var iso = item.country,
                value = item.count;
        dataset[iso] = { numberOfThings: value, fillColor: paletteScale(value) };
    });

    this.map = new Datamap({
        element: this.element,
        scope: 'world',
        responsive: true,
        fills: { defaultFill: '#e2e8f0' },
        data: dataset,
        geographyConfig: {
          highlightFillColor: function(geo) {
                  return geo['fillColor'] || '#e2e8f0';
              },
            highlightBorderColor: '#B7B7B7',
            popupTemplate: function(geo, data) {
                if (!data) { return ; }
                return ['<div class="hoverinfo">',
                    '<strong>', geo.properties.name, '</strong>',
                    '<br>Visitors: <strong>', data.numberOfThings, '</strong>',
                    '</div>'].join('');
            }
        }
    });
  }

  getData() {
    const from = this.data.get("from")
    const to = this.data.get("to")
    var url = this.data.get("url") + "?from=" + from + "&to=" + to
    fetch(url).then(response => {
      return response.json()
    }).then(response => {
      this.element.innerHTML = ""
      return this.createChart(this.element, response)
    })
  }

  resize({ height, width }) {
    if(this.map) {
      this.map.resize();
    }
  }

  connect() {
    useResize(this)
    this.element.innerHTML = this.loader()
    this.getData();
  }

  loader() {
    return "<div class=\"w-1/6 mx-auto\"><div class=\"lds-ring\"><div></div><div></div><div></div><div></div></div></div>"
  }
}
