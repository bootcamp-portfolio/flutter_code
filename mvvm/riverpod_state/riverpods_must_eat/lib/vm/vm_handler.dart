import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpods_must_eat/model/address.dart';
import 'package:riverpods_must_eat/vm/database_handler.dart';

class VMNotifier extends StateNotifier<List<Address>> {
  //<<<<<<<<<<<<<<<<<<<<<<<<<<검색시 리스트를 보여줌
  VMNotifier() : super([]) {
    loadAddress(); //다트문법
  }

  final _dbHandler = DatabaseHandler();

  Future loadAddress() async {
    final result = await _dbHandler.queryAddress();
    state = result;
  }

  Future insertAddress(Address address) async {
    await _dbHandler.insertAddress(address);
    await loadAddress();
  }

  Future updateAddress(Address address) async {
    await _dbHandler.updateAddress(address);
    await loadAddress();
  }

  Future updateAddressAll(Address address) async {
    await _dbHandler.updateAddressAll(address);
    await loadAddress();
  }

  Future deleteAddress(int id) async {
    await _dbHandler.deleteAddress(id);
    await loadAddress();
  }
} //VMNotifier

final vmNotifierProvider =
    StateNotifierProvider<VMNotifier, List<Address>>(
      (ref) => VMNotifier(), //클래스 이름가지고 생성//위젯
    ); //<<<<<<<<<<<<<<중요
