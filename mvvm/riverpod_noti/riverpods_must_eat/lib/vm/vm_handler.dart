import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpods_must_eat/model/address.dart';
import 'package:riverpods_must_eat/vm/database_handler.dart';

class VMNotifier extends AsyncNotifier<List<Address>> {
  // VMNotifier() : super([]){
  //   loadAddress();
  // }

  final _dbHandler = DatabaseHandler();

  @override
  Future<List<Address>> build() async =>
      _dbHandler.queryAddress();

  Future<void> loadAddress() async {
    // final result = await _dbHandler.queryAddress();
    state = AsyncLoading(); //대기
    state = await AsyncValue.guard(
      () async => _dbHandler.queryAddress(),
    ); //guard async?
  }

  Future<void> insertAddress(Address address) async {
    await _dbHandler.insertAddress(address);
    await loadAddress();
  }

  Future<void> updateAddress(Address address) async {
    await _dbHandler.updateAddress(address);
    await loadAddress();
  }

  Future<void> updateAddressAll(Address address) async {
    await _dbHandler.updateAddressAll(address);
    await loadAddress();
  }

  Future<void> deleteAddress(int id) async {
    await _dbHandler.deleteAddress(id);
    await loadAddress();
  }
} // VMNotifier

final vmNotifierProvider =
    AsyncNotifierProvider<VMNotifier, List<Address>>(
      VMNotifier.new,
    );
