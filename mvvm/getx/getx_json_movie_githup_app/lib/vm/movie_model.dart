import 'dart:convert';
import 'package:get/state_manager.dart';
import 'package:getx_json_movie_githup_app/model/movie.dart';
import 'package:http/http.dart' as http;

class MovieModel extends GetxController {
  //watch->property째려봄//<<<<<<<<<프라퍼티어쩌구
  RxList<Movie> movies = <Movie>[].obs;
  RxBool isLoading = false.obs; //async
  RxString error = ''.obs; //optional-null

  @override
  void onInit() {
    super.onInit();
    fetchMovies();
    //클래스 생성시 실행함
  } //구동 아래 실행

  Future<void> fetchMovies() async {
    //함수
    isLoading.value = true;

    try {
      final url = Uri.parse(
        "https://zeushahn.github.io/Test/movies.json",
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(
          utf8.decode(response.bodyBytes),
        );
        final List results = data['results'];
        //Data존재파악
        movies.value = results
            .map(
              (data) => Movie(
                image: data['image'] ?? '',
                title: data['title'],
              ),
            )
            .toList();
      } else {
        error.value = "데이터로딩실패:${response.statusCode}";
      }
    } catch (e) {
      error.value = "예외발생 : $e"; //연결자체 안됌
    } finally {
      isLoading.value = false; //property바꿨다
    }
  }
}
