// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transaction_app/controller/transaction_controller.dart';

import '../model/transaction_model.dart';

class AddTransaction extends StatelessWidget {
  AddTransaction({super.key});
  final TransactionController controller = Get.put(TransactionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses App'),
      ),
      body: GetBuilder<TransactionController>(
        builder: (controller) => ListView.builder(
          itemCount: controller.list.length,
          itemBuilder: (context, index) {
            final TransactionModel items = controller.list[index];
            return Card(
              child: ExpansionTile(
                title: Text(items.name),
                subtitle: Text(
                  items.createdDate.toString().split(" ").first,
                  style: const TextStyle(color: Colors.grey),
                ),
                trailing: Text(
                  items.amount.toString(),
                  style: TextStyle(
                      color: items.isExpense ? Colors.red : Colors.green),
                ),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          label: const Text('Edit'),
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertBox(
                                      controller: controller,
                                      model: items,
                                      isEdit: true,
                                    ));
                          },
                        ),
                      ),
                      Expanded(
                        child: TextButton.icon(
                            label: const Text('Delete'),
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              controller
                                  .deleteTransaction(controller.list[index]);
                            }),
                      )
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertBox(
              controller: controller,
              isEdit: false,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AlertBox extends StatelessWidget {
  AlertBox({
    Key? key,
    required this.controller,
    this.model,
    required this.isEdit,
  }) : super(key: key);

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  RxBool isExpense = true.obs;
  bool isEdit;
  final TransactionController controller;
  final TransactionModel? model;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tittle'),
      content: Form(
          key: formKey,
          child: Obx(
            () => SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  _fields('Enter Name', nameController),
                  const SizedBox(height: 8),
                  _fields('Enter Amount', amountController),
                  RadioListTile<bool>(
                    title: const Text('Expense'),
                    value: true,
                    groupValue: isExpense.value,
                    onChanged: (value) => isExpense.value = value!,
                  ),
                  RadioListTile<bool>(
                    title: const Text('Income'),
                    value: false,
                    groupValue: isExpense.value,
                    onChanged: (value) => isExpense.value = value!,
                  ),
                ],
              ),
            ),
          )),
      actions: [
        TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop()),
        TextButton(
          child: const Text('Add'),
          onPressed: () async {
            final isValid = formKey.currentState!.validate();
            if (isValid) {
              final name = nameController.text;
              final amount = double.tryParse(amountController.text) ?? 0;
              !isEdit
                  ? await controller.addTransction(
                      name, amount, isExpense.value)
                  : await controller.editTransaction(
                      model!, name, amount, isExpense.value);
              Get.back();
            }
          },
        )
      ],
    );
  }

  TextFormField _fields(
    String hint,
    TextEditingController controller,
  ) {
    return TextFormField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: hint,
      ),
      validator: (value) => value!.isEmpty ? 'Enter a valid number' : null,
      controller: controller,
    );
  }
}
