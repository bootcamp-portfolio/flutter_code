import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import 'package:json_movie_github_app/model/movie.dart';

class MovieNotifier extends StateNotifier<List<Movie>> {
  //상태
  MovieNotifier() : super([]);

  bool isLoading = false;
  String? error;

  Future<void> fetchMovies() async {
    //함수
    isLoading = true;
    error = null;
    try {
      //
      final url = Uri.parse(
        "https://zeushahn.github.io/Test/movies.json",
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(
          utf8.decode(response.bodyBytes),
        );
        final List results = data['results'];
        //여기서 변경<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        state = results
            .map(
              (data) => Movie(
                image: data['image'] ?? '',
                title: data['title'],
              ),
            )
            .toList();
      } else {
        error = "데이터로딩실패:${response.statusCode}";
      }
    } catch (e) {
      error = "예외발생 : $e"; //연결자체 안됌
    } finally {
      isLoading = false;
    }
  }
} //class

//movienotifier//상태저장용
final movieProvider =
    StateNotifierProvider<MovieNotifier, List<Movie>>(
      (ref) => MovieNotifier(),
    );

//비동기데이터 fetch용 -async
final movieFutureProvider = FutureProvider<List<Movie>>((
  ref,
) async {
  final notifier = ref.read(movieProvider.notifier); //함수실행
  await notifier.fetchMovies();
  return ref.read(movieProvider);
}); //한번에 불러옴 copywith 필요없음
