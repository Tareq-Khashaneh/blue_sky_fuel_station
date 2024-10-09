import 'package:flutter/material.dart';

import 'custom_card.dart';

class ErrorMessageCard extends StatelessWidget {
  const ErrorMessageCard({super.key, required this.message});
  final String message;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: CustomCard(
            child: Center(
                child: Text(
      message,
      style: Theme.of(context).textTheme.headlineSmall,
    ))));
  }
}
