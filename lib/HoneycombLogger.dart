import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pedantic/pedantic.dart';
import 'Config.dart'; //TODO REMOVE in real implementation
class HoneycombLogger {
  String HONEYCOMB_URL;
  String HONEYCOMB_DATASET;
  String HONEYCOMB_APIKEY;
  String name;
  HoneycombLogger(name) {
    this.name = name;
    this.loadAPIKeys();
  }
  void loadAPIKeys() {
    /* TODO: Implementation. Probably should send events to a backend server to forward instead of loading on the frontend */
    this.HONEYCOMB_APIKEY = Config.HONEYCOMB_APIKEY;
    this.HONEYCOMB_DATASET = Config.HONEYCOMB_DATASET;
    this.HONEYCOMB_URL = Config.HONEYCOMB_URL;
  }
  void info(Map<String, dynamic> event) async {
    event['_loglevel'] = 'info';
    this.sendHoneycombEvent(event);
  }
  void error(Map<String, dynamic> event) async {
    event['_loglevel'] = 'error';
    this.sendHoneycombEvent(event);
  }
  void warning(Map<String, dynamic> event) async {
    event['_loglevel'] = 'warning';
    this.sendHoneycombEvent(event);
  }
  void debug(Map<String, dynamic> event) async {
    event['_loglevel'] = 'debug';
    this.sendHoneycombEvent(event);
  }
  Future fireAndForget(url, headers, body) async {
    return await http.post(url, headers: headers,  body: body);
  }
  void sendHoneycombEvent(Map<String, dynamic> event) async {
    var url = Uri.parse(HONEYCOMB_URL + HONEYCOMB_DATASET);
    var headers = {'X-Honeycomb-Team': HONEYCOMB_APIKEY, 'Content-Type': 'application/json' };
    event['_loggername'] = this.name;
    var body = json.encode(event);
    unawaited(this.fireAndForget(url, headers, body));
  }
}
