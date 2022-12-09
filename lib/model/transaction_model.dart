import 'package:hive/hive.dart';
part 'transaction_model.g.dart';

@HiveType(typeId: 0)
class TransactionModel extends HiveObject {
  @HiveField(0)
  late String name;
  @HiveField(1)
  late DateTime createdDate;
  @HiveField(2)
  late bool isExpense = true;
  @HiveField(3)
  late double amount;
}
