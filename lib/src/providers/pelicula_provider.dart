import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'dart:convert';

class PeliculasProvider {

  String  _apiKey         = 'c2d17f55bc6c68c9eec8b347bad78a6b';
  String  _url            = 'api.themoviedb.org';
  String  _language       = 'es-ES';
  int     _popularesPage  = 0;
  bool    _cargando       = false;

  // lugar donde se almacenaran los datos que van fluyendo por el Stream
  List<Pelicula> _populares = new List();

  // especifico a mi Stream de que tipo sera el flujo
  // se agrega el broadcast para que mas de un clienta puedan escuchar al flujo
  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;

  void disposeStreams() {
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> getEnCines() async {
    // creo la url
    final url = Uri.http(_url, '3/movie/now_playing',
        {'api_key': _apiKey, 'language': _language});

    var response = await http.get(url);
    final resp = response;
    // decodifico la data JSON en un MAP
    final decodedData = json.decode(resp.body);

    // convierto el map en tipo Peliculas
    final peliculas = new Peliculas.fromJsonList(decodedData['results']);

    return peliculas.items;
  }

  Future<List<Pelicula>> getPopulares() async {

    if (_cargando) return [];

    print('Cargando los siguientes...');

    _cargando = true;
    _popularesPage++;

    final url = Uri.http(_url, '3/movie/popular', {
      'api_key': _apiKey,
      'language': _language,
      'page': _popularesPage.toString()
    });

    var response = await http.get(url);
    final res = response;

    final decodedData = json.decode(res.body);

    final peliculas = new Peliculas.fromJsonList(decodedData['results']);

    _populares.addAll(peliculas.items);
    popularesSink(_populares);

    _cargando = false;
    return peliculas.items;
  }

  Future<List<Actor>> getCast(String peliId) async {

    final url = Uri.https(_url, '3/movie/$peliId/credits',{
      'api_key': _apiKey,
      'language': _language
    });


    var response = await http.get(url);
    final res = response;

    // mapeo un json a un Map
    final decodedData = json.decode(res.body);

    final cast = new Cast.fromJsonList(decodedData['cast']);
    return cast.actores;

  }

  Future<List<Pelicula>> searchPelicula(String query) async {

    final url = Uri.https(_url, '3/search/movie',{
      'api_key' : _apiKey,
      'language': _language,
      'query'   : query
    });


    var response = await http.get(url);
    final res = response;

    // mapeo un json a un Map
    final decodedData = json.decode(res.body);

    final peliculas = new Peliculas.fromJsonList(decodedData['results']);
    return peliculas.items;

  }
}
