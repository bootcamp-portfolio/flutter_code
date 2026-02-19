import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_json_movie_github_app/model/movie.dart';
import 'package:provider_json_movie_github_app/vm/movie_model.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final movieProvider = context.watch<MovieModel>();
    return Scaffold(
      appBar: AppBar(title: Text('Provider JSON App')),
      body: Builder(
        builder: (context) {
          if (movieProvider.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (movieProvider.error != null) {
            return Center(
              child: Text('오류발생 : ${movieProvider.error}'),
            );
          }
          return ListView.builder(
            itemCount: movieProvider.movies.length, //공부필요
            itemBuilder: (context, index) {
              final Movie movie =
                  movieProvider.movies[index]; //인스턴스?
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
                //
              );
            },
          );
        },
      ),
      //futurebuilder함수
      //main에서 이미 실행중
    );
  }
} //분업화하기 쉬움 빠름
