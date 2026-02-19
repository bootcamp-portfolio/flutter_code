import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_crude_app/model/student.dart';

class StudentNotifier extends AsyncNotifier<List<Student>> {
  final String baseUrl = "http://172.16.251.221:8000";

  @override //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  Future<List<Student>> build() async {
    return await fetchStudents();
  }

  Future<List<Student>> fetchStudents() async {
    final res = await http.get(
      Uri.parse("$baseUrl/select"),
    );
    if (res.statusCode != 200) {
      throw Exception("불러오기 실패:${res.statusCode}");
    }

    final data = json.decode(utf8.decode(res.bodyBytes));

    return (data['results'] as List)
        .map((d) => Student.fromJson(d))
        .toList();
  } //student async

  Future<String> insertStudent(Student s) async {
    //post
    final url = Uri.parse("$baseUrl/insert");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(s.toJson()),
    );
    final data = json.decode(
      utf8.decode(response.bodyBytes),
    );
    //await fetchStudents();
    await refreshStudents(); //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    return data['result'];
  }

  Future<String> updateStudent(Student s) async {
    final url = Uri.parse('$baseUrl/update');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(s.toJson()),
    );
    final data = json.decode(
      utf8.decode(response.bodyBytes),
    );
    await refreshStudents();
    return data['result'];
  }

  Future<String> deleteStudent(String code) async {
    final url = Uri.parse('$baseUrl/delete');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'code': code}),
    );
    final data = json.decode(
      utf8.decode(response.bodyBytes),
    );
    await refreshStudents();
    return data['result'];
  }

  //<<<<<<<<<<<<<<<<<<<<중요 널체크 함수
  Future<void> refreshStudents() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () async => await fetchStudents(),
    );
  }
} //studentNotifier

final studentNotifierProvider =
    AsyncNotifierProvider<StudentNotifier, List<Student>>(
      StudentNotifier.new,
    );
