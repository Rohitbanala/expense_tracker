import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense(
      {super.key, required Function(Expense expense) this.newExpense});
  final void Function(Expense expense) newExpense;
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  var _selectDropDown = Category.food;
  DateTime? _selectDate;
  void showDate() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        firstDate: firstDate,
        initialDate: now,
        lastDate: now);
    setState(() {
      _selectDate = pickedDate;
    });
  }

  void _submitExpense() {
    final isValidAmount = double.tryParse(_priceController.text);
    final amount = isValidAmount == null;
    if (_titleController.text.trim().isEmpty || amount || _selectDate == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Invalid Input"),
          content: const Text(
              "Make sure that you added valid amount, date, title and category."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Okay"),
            )
          ],
        ),
      );
      return;
    }
    widget.newExpense(
      Expense(
          title: _titleController.text,
          amount: isValidAmount,
          category: _selectDropDown,
          date: _selectDate!),
    );
    Navigator.pop(context);
  }

  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 50,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              label: Text("title"),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  maxLength: 12,
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixText: "\$ ",
                    label: Text("expense"),
                  ),
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _selectDate == null
                          ? "No Date Selected"
                          : formatter.format(_selectDate!).toString(),
                    ),
                    IconButton(
                      onPressed: showDate,
                      icon: Icon(Icons.calendar_month),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              DropdownButton(
                value: _selectDropDown,
                items: Category.values
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(
                          category.name.toUpperCase(),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (e) {
                  if (e == null) {
                    return;
                  }
                  setState(
                    () {
                      _selectDropDown = e;
                    },
                  );
                },
              ),
              Spacer(),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              ElevatedButton(
                  onPressed: _submitExpense, child: const Text("Save Expense"))
            ],
          )
        ],
      ),
    );
  }
}
