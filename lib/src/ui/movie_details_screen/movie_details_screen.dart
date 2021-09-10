import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb/src/bloc/moviedetailsbloc/movie_details_bloc.dart';
import 'package:tmdb/src/bloc/moviedetailsbloc/movie_details_bloc_event.dart';
import 'package:tmdb/src/bloc/moviedetailsbloc/movie_details_bloc_state.dart';
import 'package:tmdb/src/model/movie.dart';
import 'package:tmdb/src/model/movie_detail.dart';
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
                  )
                ],
              ),
            ],
          );
        } else {
          print('Movie Details Screen: something went wrong');
          return Center();
        }
      },
    );
  }
}
