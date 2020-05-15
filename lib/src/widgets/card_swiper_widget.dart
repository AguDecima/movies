import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class CardSwiper extends StatelessWidget {
  final List<Pelicula> peliculas;

  CardSwiper({@required this.peliculas});

  @override
  Widget build(BuildContext context) {
    // sirve para obtener datos de la pantalla del dispositivo que esta ejecutando la app
    final _screenSize = MediaQuery.of(context).size;

    return Container(
        padding: EdgeInsets.only(top: 10.0),
        child: new Swiper(
          itemHeight: _screenSize.height * 0.5,
          itemWidth: _screenSize.width * 0.7,
          itemBuilder: (BuildContext context, int index) {

            peliculas[index].uniqueId = '${peliculas[index].id}--tarjeta';

            // sirve para dar borde redondeado a imagenes
            return Hero(
              tag: peliculas[index].uniqueId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, 'detalle',
                        arguments: peliculas[index]);
                  },
                  child: FadeInImage(
                    image: NetworkImage(peliculas[index].getPosterImg()),
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
          itemCount: 10,
          layout: SwiperLayout.STACK,
        ));
  }
}
