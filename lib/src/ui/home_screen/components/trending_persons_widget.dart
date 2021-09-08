import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb/src/bloc/personbloc/person_bloc.dart';
import 'package:tmdb/src/bloc/personbloc/person_bloc_state.dart';
import 'package:tmdb/src/model/person.dart';


class TrendingPersonsWidget extends StatelessWidget {
  const TrendingPersonsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<PersonBloc, PersonState>(builder: (context, state) {
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
                            borderRadius: BorderRadius.circular(100),
                          ),
                          elevation: 2,
                          child: ClipRRect(
                            child: CachedNetworkImage(
                              imageUrl:
                                  'https://image.tmdb.org/t/p/w200${person.profilePath}',
                              imageBuilder: (context, imageProvider) {
                                return Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(100),
                                    ),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                              placeholder: (context, url) => Container(
                                width: 80,
                                height: 80,
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
                              (person.name as String).toUpperCase(),
                              style: TextStyle(
                                fontFamily: 'muli',
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
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
                                fontWeight: FontWeight.bold,
                                color: Colors.black45,
                              ),
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
                itemCount: personList.length,
              ),
            );
          } else {
            print("persons loaded with error ");
            return Center();
          }
        })
      ],
    );
  }
}
