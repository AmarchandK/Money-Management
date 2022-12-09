// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:transaction_app/model/transaction_model.dart';

class TransactionDialog extends StatelessWidget {
  TransactionDialog({
    Key? key,
    this.transaction,
    required this.onClickedDone
  }) : super(key: key);

  final TransactionModel? transaction;
  final Function(String name, double amount, bool isExpense) onClickedDone;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final  TextEditingController amountController = TextEditingController();

 bool isExpense = true;



  @override
  Widget build(BuildContext context) {
    final isEditing = transaction != null;
    final title = isEditing ? 'Edit Transaction' : 'Add Transaction';

    return AlertDialog(
      title: Text(title),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 8),
              buildName(),
              const SizedBox(height: 8),
              buildAmount(),
              const SizedBox(height: 8),
              buildRadioButtons(),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        buildCancelButton(context),
        buildAddButton(context, isEditing: isEditing),
      ],
    );
  }

  Widget buildName() => TextFormField(
        controller: nameController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Name',
        ),
        validator: (name) =>
            name != null && name.isEmpty ? 'Enter a name' : null,
      );

  Widget buildAmount() => TextFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Amount',
        ),
        keyboardType: TextInputType.number,
        validator: (amount) => amount != null && double.tryParse(amount) == null
            ? 'Enter a valid number'
            : null,
        controller: amountController,
      );

  Widget buildRadioButtons() => Column(
        children: [
          RadioListTile<bool>(
            title: const Text('Expense'),
            value: true,
            groupValue: isExpense,
            onChanged: (value) =>isExpense = value!,
          ),
          RadioListTile<bool>(
            title: const Text('Income'),
            value: false,
            groupValue: isExpense,
            onChanged: (value) =>   isExpense = value!,
          ),
        ],
      );

  Widget buildCancelButton(BuildContext context) => TextButton(
        child: const Text('Cancel'),
        onPressed: () => Navigator.of(context).pop(),
      );

  Widget buildAddButton(BuildContext context, {required bool isEditing}) {
    final text =  isEditing? 'Save' : 'Add';

    return TextButton(
      child: Text(text),  
      onPressed: () async {
        final isValid = formKey.currentState!.validate();

        if (isValid) {
          final name = nameController.text;
          final amount = double.tryParse(amountController.text) ?? 0;

          onClickedDone(name, amount, isExpense);

          Navigator.of(context).pop();
        }
      },
    );
  }
}
