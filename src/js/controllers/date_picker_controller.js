import { Controller } from "stimulus"
import Litepicker from 'litepicker';
export default class extends Controller {

  _renderDate() {
    var picker = new Litepicker({
      format: 'YYYY-MM-DD',
      numberOfMonths: 1,
      numberOfColumns: 1,
      minDate: this.data.get("mindate"),
      maxDate: this.data.get("maxdate"),
      autoApply: true,
      singleMode: false,
      element: this.element,
      inlineMode: true,
      onSelect: this._sendToDatePeriod,
    })
  }

  _sendToDatePeriod(start_date, end_date) {
    var url = new URL(window.location)
    var queryParams = new URLSearchParams(window.location.search);
    queryParams.set("to", end_date.yyyymmdd());
    queryParams.set("from", start_date.yyyymmdd());
    url.search = queryParams.toString()
    window.location = url.toString();
  }

  connect() {
    this._renderDate()
    this.awayHandler = (event) => {
      event.stopPropagation()
    }
    this.element.addEventListener('click', this.awayHandler)
  }

  disconnect() {
    this.element.removeEventListener(this.awayHandler)
  }
}
