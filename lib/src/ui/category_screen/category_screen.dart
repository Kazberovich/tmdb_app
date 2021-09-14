import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb/src/bloc/genrebloc/genre_bloc.dart';
import 'package:tmdb/src/bloc/genrebloc/genre_bloc_event.dart';
import 'package:tmdb/src/bloc/genrebloc/genre_bloc_state.dart';
import 'package:tmdb/src/bloc/moviebloc/movie_bloc.dart';
import 'package:tmdb/src/bloc/moviebloc/movie_bloc_event.dart';
import 'package:tmdb/src/bloc/moviebloc/movie_bloc_state.dart';
import 'package:tmdb/src/model/genre.dart';
import 'package:tmdb/src/model/movie.dart';
import 'package:tmdb/src/ui/movie_details_screen/movie_details_screen.dart';

class CategoryWidget extends StatefulWidget {
  final int selectedGenre;

  const CategoryWidget({this.selectedGenre = 28});

  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  late int selectedGenre;

  @override
  void initState() {
    selectedGenre = widget.selectedGenre;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GenreBloc>(
          create: (context) => GenreBloc()..add(GenreEventStarted()),
        ),
        BlocProvider<MovieBloc>(
          create: (context) =>
              MovieBloc()..add(MovieEventStarted(selectedGenre, '')),
        ),
      ],
      child: _buildGenreWidget(context),
    );
  }

  Widget _buildGenreWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocBuilder<GenreBloc, GenreState>(
          builder: (contxt, state) {
            if (state is GenreLoading) {
              print('genres GenreLoading');
              return Platform.isAndroid
                  ? CircularProgressIndicator()
                  : CupertinoActivityIndicator();
            } else if (state is GenreLoaded) {
              print('genres GenreLoaded');
              List<Genre> genres = state.genreList;

              return Container(
                height: 45,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      Genre genre = genres[index];
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                Genre genre = genres[index];
                                selectedGenre = genre.id;
                                context
                                    .read<MovieBloc>()
                                    .add(MovieEventStarted(selectedGenre, ''));
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black45),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                color: (genre.id == selectedGenre)
                                    ? Colors.black45
                                    : Colors.white,
                              ),
                              child: Text(
                                genre.name.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'muli',
                                  color: (genre.id == selectedGenre)
                                      ? Colors.white
                                      : Colors.black45,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        VerticalDivider(
                          color: Colors.transparent,
                          width: 5,
                        ),
                    itemCount: genres.length),
              );
            } else {
              print('genres failed');
              return Center();
            }
          },
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          child: Text(
            'new playing'.toUpperCase(),
            style: TextStyle(
              color: Colors.black45,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: 'muli',
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        BlocBuilder<MovieBloc, MovieState>(builder: (context, state) {
          if (state is MovieLoading) {
            return Platform.isAndroid
                ? CircularProgressIndicator()
                : CupertinoActivityIndicator();
          } else if (state is MovieLoaded) {
            List<Movie> movieList = state.movieList;
            print(movieList.length);
            return Container(
              height: 300,
              child: ListView.separated(
                itemBuilder: (contxt, index) {
                  Movie movie = movieList[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MovieDetailsScreen(
                                        movie: movie,
                                      )));
                        },
                        child: ClipRRect(
                          child: CachedNetworkImage(
                            imageBuilder: (ctx, imageProvider) {
                              return Container(
                                width: 190,
                                height: 250,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    )),
                              );
                            },
                            placeholder: (contex, url) => Container(
                              width: 190,
                              height: 250,
                              child: Center(
                                child: Platform.isAndroid
                                    ? CircularProgressIndicator()
                                    : CupertinoActivityIndicator(),
                              ),
                            ),
                            imageUrl:
                                'https://image.tmdb.org/t/p/original/${movie.backdropPath}',
                            errorWidget: (contxt, url, error) => Container(
                              width: 190,
                              height: 250,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    'assets/images/img_not_found.jpg',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 180,
                        child: Text(
                          movie.title.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'muli',
                            color: Colors.black45,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.yellow[700],
                              size: 14,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.yellow[700],
                              size: 14,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.yellow[700],
                              size: 14,
                            ),
                            Text(
                              movie.voteAverage,
                              style: TextStyle(
                                color: Colors.black45,
                                fontFamily: 'muli',
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => VerticalDivider(
                  color: Colors.transparent,
                  width: 15,
                ),
                itemCount: movieList.length,
              ),
            );
          } else {
            return Text('Something went wrong');
          }
        })
      ],
    );
  }
}
