import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_json_movie_githup_app/vm/movie_model.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final movieModel = Get.find<MovieModel>(); //창고

    return Scaffold(
      appBar: AppBar(title: Text('Provider JSON App')),
      body: Obx(
        //함수 여기 공부 필요
        () {
          if (movieModel.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (movieModel.error.value != '') {
            return Center(
              child: Text(
                '오류발생 : ${movieModel.error.value}',
              ),
            );
          }
          return ListView.builder(
            itemCount: movieModel.movies.length, //공부필요
            itemBuilder: (context, index) {
              final movie =
                  movieModel.movies[index]; //인스턴스!!
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
