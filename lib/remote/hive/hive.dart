import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

var box = Hive.box('hive');

abstract class HiveHelper
{

  //===============> put data in hive
  static Future<void> putHiveData({
    required String key,
    required dynamic value,
  }) async
  {
    box.put(key, value);
  }

  //===============> get data from hive
  static dynamic getHiveData({
    required String key,
  })
  {
    return box.get(key);
  }

  //===============> delete data from hive
  static dynamic deleteHiveData({
    required String key,
  })
  {
    return box.delete(key);
  }


}