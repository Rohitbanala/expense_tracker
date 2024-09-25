import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final formatter = DateFormat.yMd();
final uuid = Uuid();

enum Category { food, travel, leisure, work }

const categoryIcon = {
  Category.food: Icons.lunch_dining,
  Category.work: Icons.work,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
};

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();
  final String title;
  final String id;
  final double amount;
  final DateTime date;
  final Category category;

  String get formateddate {
    return formatter.format(date);
  }
}

class ExpenseBucket {
  ExpenseBucket({required this.category, required this.expense});
  ExpenseBucket.category({
    required List<Expense> allExpense,
    required this.category,
  }) : expense = allExpense.where((element) => element.category == category).toList();
  final Category category;
  final List<Expense> expense;
  double get totalExpenses {
    double sum = 0;
    for (Expense e in expense) {
      sum = sum + e.amount;
    }
    return sum;
  }
}
