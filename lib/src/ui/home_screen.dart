import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb/src/bloc/moviebloc/movie_bloc.dart';
import 'package:tmdb/src/bloc/moviebloc/movie_bloc_event.dart';
import 'package:tmdb/src/bloc/moviebloc/movie_bloc_state.dart';
import 'package:tmdb/src/model/movie.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieBloc>(
          create: (_) => MovieBloc()
            ..add(
              MovieEventStarted(0, ""),
            ),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Icon(
            Icons.menu,
            color: Colors.black45,
          ),
          title: Text(
            'Movies-db'.toUpperCase(),
            style: Theme.of(context).textTheme.caption!.copyWith(
                  color: Colors.black45,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'muli',
                ),
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(
                right: 15,
              ),
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/logo.jpg'),
              ),
            )
          ],
        ),
        body: _buildBody(context),
      ),
    );
  }
}

Widget _buildBody(BuildContext context) {
  return LayoutBuilder(builder: (BuildContext ctx, BoxConstraints constraints) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<MovieBloc, MovieState>(builder: (context, state) {
              if (state is MovieLoading) {
                return Center(
                  child: Platform.isAndroid
                      ? CircularProgressIndicator()
                      : CupertinoActivityIndicator(),
                );
              } else if (state is MovieLoaded) {
                List<Movie> movies = state.movieList;
                print(movies.length);

                return Column(
                  children: [
                    CarouselSlider.builder(
                      itemCount: movies.length,
                      itemBuilder: (BuildContext context, int index, int i) {
                        Movie movie = movies[index];
                        return Stack(
                          alignment: Alignment.bottomLeft,
                          children: [
                            ClipRRect(
                              child: CachedNetworkImage(
                                imageUrl:
                                    'https://image.tmdb.org/t/p/original/${movie.backdropPath}',
                                height: MediaQuery.of(context).size.height / 3,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    Platform.isAndroid
                                        ? CircularProgressIndicator()
                                        : CupertinoActivityIndicator(),
                                errorWidget: (context, url, error) => Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/img_not_found.jpg'),
                                    ),
                                  ),
                                ),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
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
                    ),
                  ],
                );
              } else {
                return Container(
                  child: Text('somethin went wrong'),
                );
              }
            })
          ],
        ),
      ),
    );
  });
}
