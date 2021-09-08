import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb/src/bloc/moviebloc/movie_bloc.dart';
import 'package:tmdb/src/bloc/moviebloc/movie_bloc_event.dart';
import 'package:tmdb/src/bloc/moviebloc/movie_bloc_state.dart';
import 'package:tmdb/src/bloc/personbloc/person_bloc.dart';
import 'package:tmdb/src/bloc/personbloc/person_bloc_event.dart';
import 'package:tmdb/src/bloc/personbloc/person_bloc_state.dart';
import 'package:tmdb/src/model/movie.dart';
import 'package:tmdb/src/model/person.dart';
import 'package:tmdb/src/ui/category_screen.dart';

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
                            Container(
                              height: 50,
                              color: Colors.black26,
                              // decoration: BoxDecoration(
                              //   border: Border.all(color: Colors.black45),
                              //   borderRadius: BorderRadius.only(
                              //     bottomLeft: Radius.circular(
                              //       10,
                              //     ),
                              //     bottomRight: Radius.circular(10),
                              //   ),
                              // ),
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
                          Column(
                            children: [
                              BlocBuilder<PersonBloc, PersonState>(
                                  builder: (context, state) {
                                if (state is PersonLoading) {
                                  print("persons loading");
                                  return Platform.isAndroid
                                      ? CircularProgressIndicator()
                                      : CupertinoActivityIndicator();
                                } else if (state is PersonLoaded) {
                                  List<Person> personList = state.personList;
                                  print("persons PersonLoaded");
                                  print("persons length: ${personList.length}");
                                  return Container(
                                    height: 110,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        Person person = personList[index];
                                        return Container(
                                          child: Column(
                                            children: [
                                              Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                ),
                                                elevation: 2,
                                                child: ClipRRect(
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        'https://image.tmdb.org/t/p/w200${person.profilePath}',
                                                    imageBuilder: (context,
                                                        imageProvider) {
                                                      return Container(
                                                        width: 80,
                                                        height: 80,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(
                                                                100),
                                                          ),
                                                          image:
                                                              DecorationImage(
                                                            image:
                                                                imageProvider,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    placeholder:
                                                        (context, url) =>
                                                            Container(
                                                      width: 80,
                                                      height: 80,
                                                      child: Center(
                                                        child: Platform
                                                                .isAndroid
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
                                                child: Center(
                                                  child: Text(
                                                    (person.name as String)
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                      fontFamily: 'muli',
                                                      fontSize: 8,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black45,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                                 Container(
                                                child: Center(
                                                  child: Text(
                                                    (person.knownForDepartment as String)
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                      fontFamily: 'muli',
                                                      fontSize: 8,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black45,
                                                    ),
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
                                      itemCount: personList.length,
                                    ),
                                  );
                                } else {
                                  print("persons loaded with error ");
                                  return Center();
                                }
                              })
                            ],
                          )
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
