import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider_json_movie_github_app/model/movie.dart';

class MovieModel extends ChangeNotifier {
  //watch->property째려봄
  List<Movie> movies = [];
  bool isLoading = false; //async
  String? error; //optional-null

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
        //Data존재파악
        movies = results
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
      notifyListeners(); //property바꿨다
    }
  }
}
