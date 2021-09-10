import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tmdb/src/model/movie.dart';
import 'package:tmdb/src/ui/movie_details_screen/movie_details_screen.dart';

class TopRatedMovieCarouselWidget extends StatelessWidget {
  const TopRatedMovieCarouselWidget({
    Key? key,
    required this.movies,
  }) : super(key: key);

  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: movies.length,
      itemBuilder: (BuildContext context, int index, int i) {
        Movie movie = movies[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetailsScreen(
                  movie: movie,
                ),
              ),
            );
          },
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              ClipRRect(
                child: CachedNetworkImage(
                  imageUrl:
                      'https://image.tmdb.org/t/p/original/${movie.backdropPath}',
                  height: MediaQuery.of(context).size.height / 3,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Platform.isAndroid
                      ? CircularProgressIndicator()
                      : CupertinoActivityIndicator(),
                  errorWidget: (context, url, error) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/img_not_found.jpg'),
                      ),
                    ),
                  ),
                ),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              Container(
                height: 50,
                color: Colors.black26,
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: 15,
                  left: 15,
                ),
                child: Text(
                  movie.title.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'muli',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
      options: CarouselOptions(
        autoPlay: true,
        enableInfiniteScroll: true,
        autoPlayInterval: Duration(seconds: 3),
        pauseAutoPlayOnTouch: true,
        viewportFraction: 0.8,
        enlargeCenterPage: true,
      ),
    );
  }
}
