import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tmdb/src/model/cast_list.dart';
import 'package:tmdb/src/model/movie_detail.dart';

class MovieCastsWidget extends StatelessWidget {
  const MovieCastsWidget({
    Key? key,
    required this.movieDetails,
  }) : super(key: key);

  final MovieDetails movieDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            if (movieDetails.castList == null) {
              return Platform.isAndroid
                  ? CircularProgressIndicator()
                  : CupertinoActivityIndicator();
            }
            Cast cast = movieDetails.castList![index];
            return Container(
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    elevation: 4,
                    child: ClipRRect(
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://image.tmdb.org/t/p/w200${cast.profilePath}',
                        imageBuilder: (context, imageBuilder) {
                          return Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(100),
                              ),
                              image: DecorationImage(
                                image: imageBuilder,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                        placeholder: (context, url) => Container(
                          height: 80,
                          width: 80,
                          child: Center(
                            child: Platform.isAndroid
                                ? CircularProgressIndicator()
                                : CupertinoActivityIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(100),
                            ),
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
          separatorBuilder: (context, index) => VerticalDivider(
                width: 5,
                color: Colors.transparent,
              ),
          itemCount: movieDetails.castList!.length),
    );
  }
}
