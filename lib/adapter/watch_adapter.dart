import 'package:clock_app/adapter/watch_entity.dart';
import 'package:hive/hive.dart';

class WatchAdapter extends TypeAdapter<ClockEntity> {
  @override
  final int typeId = 2;

  @override
  ClockEntity read(BinaryReader reader) {
    return ClockEntity()
      ..time = reader.readInt();
  }

  @override
  void write(BinaryWriter writer, ClockEntity clockEntity) {
    writer.writeInt(clockEntity.time ?? 0);

  }
}
