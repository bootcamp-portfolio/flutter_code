import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_movie_github_app/model/movie.dart';
import 'package:json_movie_github_app/vm/movie_provider.dart';

class Home extends ConsumerWidget {
  //<<<<<<<<<<
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieAsyncValue = ref.watch(
      movieFutureProvider,
    ); //<<<<<<<<<<<<<<<<중요 future바라봄
    return Scaffold(
      appBar: AppBar(title: Text('JSON App')),
      body: movieAsyncValue.when(
        //<<<<<<<
        data: (data) => ListView.builder(
          itemCount: data.length, //<<<<<<<<<<<<<
          itemBuilder: (context, index) {
            final Movie movie = data[index];
            return Card(
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadiusGeometry.circular(7),
                    child: Image.network(
                      movie.image,
                      width: 70,
                    ),
                  ),
                  Text('       ${movie.title}'),
                ],
              ),
            );
          },
        ), //<<<<<<정상부분
        error: (error, stackTrace) =>
            Center(child: Text('오류발생:$error')),
        loading: () =>
            Center(child: CircularProgressIndicator()),
      ), //<<<<<<<<<<<<<<<<<<<<<<<
    );
  }
} //분업화하기 쉬움 빠름
