import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tmdb/src/model/movie_detail.dart';
import 'package:tmdb/src/model/screenshot.dart';

class ScreenshotsWidget extends StatelessWidget {
  const ScreenshotsWidget({
    Key? key,
    required this.movieDetails,
  }) : super(key: key);

  final MovieDetails movieDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 155,
      child: ListView.separated(
          itemBuilder: (context, index) {
            Screenshot screenshot = movieDetails.movieImage!.backdrops![index];
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
                    placeholder: (context, url) => Platform.isAndroid
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
          separatorBuilder: (context, index) => VerticalDivider(
                color: Colors.transparent,
                width: 5,
              ),
          itemCount: movieDetails.movieImage!.backdrops!.length),
    );
  }
}
