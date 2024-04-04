import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class ClockEntity extends HiveObject {


  @HiveField(0)
  int? time;


}
