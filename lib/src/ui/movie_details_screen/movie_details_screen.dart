import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb/src/bloc/moviedetailsbloc/movie_details_bloc.dart';
import 'package:tmdb/src/bloc/moviedetailsbloc/movie_details_bloc_event.dart';
import 'package:tmdb/src/bloc/moviedetailsbloc/movie_details_bloc_state.dart';
import 'package:tmdb/src/model/cast_list.dart';
import 'package:tmdb/src/model/movie.dart';
import 'package:tmdb/src/model/movie_detail.dart';
import 'package:tmdb/src/model/screenshot.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetailsScreen extends StatelessWidget {
  final Movie? movie;

  const MovieDetailsScreen({Key? key, this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MovieDetailsBloc()..add(MovieDetailsEventStarted(movie!.id)),
      child: WillPopScope(
        child: Scaffold(
          body: _buildDetailBody(context),
        ),
        onWillPop: () async => true,
      ),
    );
  }

  Widget _buildDetailBody(BuildContext context) {
    return BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
      builder: (context, state) {
        if (state is MovieDetailsLoading) {
          return Platform.isAndroid
              ? CircularProgressIndicator()
              : CupertinoActivityIndicator();
        } else if (state is MovieDetailsLoaded) {
          MovieDetails movieDetails = state.details;
          print('MovieDetailsLoaded');
          return Stack(
            children: [
              ClipPath(
                child: ClipRRect(
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://image.tmdb.org/t/p/original/${movieDetails.backdropPath}',
                    height: MediaQuery.of(context).size.height / 2,
                    width: double.infinity,
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
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(35),
                    bottomLeft: Radius.circular(35),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 120),
                    child: GestureDetector(
                      onTap: () async {
                        final youtubeUrl =
                            'https://www.youtube.com/embed/${movieDetails.trailerId}';
                        print(youtubeUrl);
                        if (await canLaunch(youtubeUrl)) {
                          await launch(youtubeUrl);
                        }
                      },
                      child: Center(
                          child: Column(
                        children: [
                          Icon(
                            Icons.play_circle_outline,
                            color: Colors.yellow,
                            size: 65,
                          ),
                          Text(
                            movie!.title.toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'muli',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      )),
                    ),
                  ),
                  SizedBox(
                    height: 160,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Overview'.toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 35,
                          child: Text(
                            movieDetails.overview as String,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'muli',
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Release date'.toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'muli',
                                      ),
                                ),
                                Text(
                                  movieDetails.releaseDate!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'muli',
                                        fontSize: 12,
                                        color: Colors.yellow[800],
                                      ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'run time'.toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'muli',
                                      ),
                                ),
                                Text(
                                  movieDetails.runtime! + " min",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'muli',
                                        fontSize: 12,
                                        color: Colors.yellow[800],
                                      ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'budget'.toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'muli',
                                      ),
                                ),
                                Text(
                                  movieDetails.budget! + "\$",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'muli',
                                        fontSize: 12,
                                        color: Colors.yellow[800],
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Screenshots'.toUpperCase(),
                          style: Theme.of(context).textTheme.caption!.copyWith(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'muli',
                              ),
                        ),
                        Container(
                          height: 155,
                          child: ListView.separated(
                              itemBuilder: (context, index) {
                                Screenshot screenshot =
                                    movieDetails.movieImage!.backdrops![index];
                                return Container(
                                  child: Card(
                                    elevation: 3,
                                    borderOnForeground: true,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CachedNetworkImage(
                                        placeholder: (context, url) =>
                                            Platform.isAndroid
                                                ? CircularProgressIndicator()
                                                : CupertinoActivityIndicator(),
                                        imageUrl:
                                            'https://image.tmdb.org/t/p/w500${screenshot.imagePath}',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (context, index) =>
                                  VerticalDivider(
                                    color: Colors.transparent,
                                    width: 5,
                                  ),
                              itemCount:
                                  movieDetails.movieImage!.backdrops!.length),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Casts'.toUpperCase(),
                          style: Theme.of(context).textTheme.caption!.copyWith(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'muli',
                              ),
                        ),
                        Container(
                          height: 110,
                          child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                Cast cast = movieDetails.castList![index];
                                return Container(
                                  child: Column(
                                    children: [
                                      Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        elevation: 4,
                                        child: ClipRRect(
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                'https://image.tmdb.org/t/p/w200${cast.profilePath!}',
                                            imageBuilder:
                                                (context, imageBuilder) {
                                              return Container(
                                                width: 80,
                                                height: 80,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(100),
                                                  ),
                                                  image: DecorationImage(
                                                    image: imageBuilder,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              );
                                            },
                                            placeholder: (context, url) =>
                                                Container(
                                              height: 80,
                                              width: 80,
                                              child: Center(
                                                child: Platform.isAndroid
                                                    ? CircularProgressIndicator()
                                                    : CupertinoActivityIndicator(),
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                              width: 80,
                                              height: 80,
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
                                      Container(
                                        child: Text(
                                          cast.name!,
                                          style: TextStyle(
                                            fontFamily: 'muli',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black45,
                                            fontSize: 8,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          cast.character!,
                                          style: TextStyle(
                                            fontFamily: 'muli',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black45,
                                            fontSize: 8,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  VerticalDivider(
                                    width: 5,
                                    color: Colors.transparent,
                                  ),
                              itemCount: movieDetails.castList!.length),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        } else {
          print('Movie Details Screen: something went wrong');
          Navigator.of(context).pop();
          return Center();
        }
      },
    );
  }
}
