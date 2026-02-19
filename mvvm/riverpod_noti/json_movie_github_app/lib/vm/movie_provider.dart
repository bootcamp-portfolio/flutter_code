import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:json_movie_github_app/model/movie.dart';

//id 수정 삭제 위해 필요
class MovieNotifier extends AsyncNotifier<List<Movie>> {
  //property
  //bool isLoading = false;
  //String? error;
  //List<Movie> data = [];

  @override
  FutureOr<List<Movie>> build() {
    //throw UnimplementedError();
    //print('provider movie notifier build');
    return fetchData(); //await
  }

  Future<List<Movie>> fetchData() async {
    //isLoading = true;
    //print('provider movieNotifier fetchData');
    final uri = Uri.parse(
      "https://zeushahn.github.io/Test/movies.json",
    );
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('데이터 로딩 실패:${response.statusCode}');
    }
    final jsonData = json.decode(
      utf8.decode(response.bodyBytes),
    );
    final List results = jsonData['results'];

    //state=AsyncValue.data(jsonData['result']);
    //data존재 파악
    //state= 값 변경
    AsyncValue.data(
      //<<<<<<<<<<<<<<<<<<낙관적??
      results
          .map(
            (data) => Movie(
              id: data['id'],
              image: data['image'],
              title: data['title'],
            ),
          )
          .toList(),
    );

    return results
        .map(
          (data) => Movie(
            id: data['id'],
            image: data['image'] ?? '',
            title: data['title'],
          ),
        )
        .toList();
  }

  Future<void> addData(Movie movie) async {
    final currentMovies = state.value ?? [];

    state = AsyncValue.data([...currentMovies, movie]);

    try {
      //insert
    } catch (e) {
      state = AsyncValue.data(currentMovies);
      rethrow; //<<<<<<<<<<<<<<<<낙관적?
    } //에러를 다시 던짐
  }

  Future<void> updateData(Movie movie) async {
    final currentMovies = state.value ?? [];

    //update
    final updateList = currentMovies.map((m) {
      return m.id == movie.id ? movie : m;
    }).toList();
    state = AsyncValue.data(updateList);
    try {
      //update
    } catch (e) {
      state = AsyncValue.data(currentMovies);
      rethrow;
    }
  }

  Future<void> deleteData(int id) async {
    final currentMovies = state.value ?? [];
    //Optimistic
    final updatedList = currentMovies
        .where((m) => m.id != id)
        .toList();
    state = AsyncValue.data(updatedList);

    try {
      //delete
    } catch (e) {
      //실패시 원상복구
      state = AsyncValue.data(currentMovies);
    }
  }
}

/* Future<List<Movie>> build() async {
    return fetchMovies();
  }

  Future<List<Movie>> fetchMovies() async {
    final url = Uri.parse(
      "https://zeushahn.github.io/Test/movies.json",
    );
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("데이터 로딩 실패:${response.statusCode}");
    }

    final data = json.decode(
      utf8.decode(response.bodyBytes),
    );
    final List results = data['results'];

    return results
        .map(
          (data) => Movie(
            image: data['image'] ?? '',
            title: data['title'],
          ),
        )
        .toList();
  }



*/
//movienotifier//상태저장용
final movieProvider =
    AsyncNotifierProvider<MovieNotifier, List<Movie>>(
      MovieNotifier.new,
    );
