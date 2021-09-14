import 'package:flutter/material.dart';
import 'package:tmdb/src/model/movie_detail.dart';

class ReleaseRuntimeBudgetWidget extends StatelessWidget {
  const ReleaseRuntimeBudgetWidget({
    Key? key,
    required this.movieDetails,
  }) : super(key: key);

  final MovieDetails movieDetails;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Release date'.toUpperCase(),
              style: Theme.of(context).textTheme.caption!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'muli',
                  ),
            ),
            Text(
              movieDetails.releaseDate!,
              style: Theme.of(context).textTheme.subtitle2!.copyWith(
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
              style: Theme.of(context).textTheme.caption!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'muli',
                  ),
            ),
            Text(
              movieDetails.runtime! + " min",
              style: Theme.of(context).textTheme.subtitle2!.copyWith(
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
              style: Theme.of(context).textTheme.caption!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'muli',
                  ),
            ),
            Text(
              movieDetails.budget! + "\$",
              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'muli',
                    fontSize: 12,
                    color: Colors.yellow[800],
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
