import 'package:hive/hive.dart';

part 'cart_hive.g.dart';

@HiveType(typeId: 1)
class CartHive {
  @HiveField(0)
  late int serviceId;

  @HiveField(1)
  late int quantity;

  @HiveField(2)
  late String description;
}
