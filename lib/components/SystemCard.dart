import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class SystemCard extends StatelessWidget {
  // ...

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Updated here!
          Text('System 1',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: kIsWeb ? 20 : 18,
            ),
          ),
          // ... Add other content with responsiveness in mind
        ],
      ),
    );
  }
}