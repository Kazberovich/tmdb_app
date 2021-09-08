import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb/src/bloc/moviebloc/movie_bloc.dart';
import 'package:tmdb/src/bloc/moviebloc/movie_bloc_event.dart';
import 'package:tmdb/src/bloc/moviebloc/movie_bloc_state.dart';
import 'package:tmdb/src/bloc/personbloc/person_bloc.dart';
import 'package:tmdb/src/bloc/personbloc/person_bloc_event.dart';
import 'package:tmdb/src/model/movie.dart';
import 'package:tmdb/src/ui/category_screen/category_screen.dart';

import 'components/top_rated_movies_carousel_widget.dart';
import 'components/trending_persons_widget.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieBloc>(
          create: (_) => MovieBloc()..add(MovieEventStarted(0, "")),
        ),
        BlocProvider<PersonBloc>(
          create: (_) => PersonBloc()..add(PersonEventStarted()),
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
            'Movies'.toUpperCase(),
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
                    TopRatedMovieCarouselWidget(movies: movies),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 12,
                          ),
                          CategoryWidget(),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            'Trending persons on this week'.toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black45,
                              fontFamily: 'muli',
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          TrendingPersonsWidget()
                        ],
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
