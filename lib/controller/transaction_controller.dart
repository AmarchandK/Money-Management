import 'package:get/state_manager.dart';
import 'package:hive/hive.dart';
import 'package:transaction_app/model/transaction_model.dart';

class TransactionController extends GetxController {
  List<TransactionModel> list = [];
  @override
  void onInit() {
    _getTransaction();
    super.onInit();
  }

  @override
  void onClose() {
    Hive.close();
    super.onClose();
  }

  Future<void> addTransction(String name, double amount, bool isExpense) async {
    final TransactionModel transactionModel = TransactionModel()
      ..name = name
      ..amount = amount
      ..createdDate = DateTime.now()
      ..isExpense = isExpense;
    final box = Hive.box<TransactionModel>('wallet');
    await box.add(transactionModel);
    await _getTransaction();
  }

  Future<void> editTransaction(TransactionModel model, String name,
      double amount, bool isExpense) async {
    model.name = name;
    model.amount = amount;
    model.isExpense = isExpense;
    await model.save();
    await _getTransaction();
  }

  Future<void> deleteTransaction(TransactionModel model) async {
    await model.delete();
    await _getTransaction();
  }

  Future<void> _getTransaction() async {
    list.clear();
    list = Hive.box<TransactionModel>('wallet').values.toList();
    update();
  }
}
