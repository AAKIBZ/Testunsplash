import 'package:flutter/material.dart';

/// A Widget wrapping a [CircularProgressIndicator] in [Center].
class ProgressIndicatorData extends StatelessWidget {
  final Color color;

  const ProgressIndicatorData(this.color);

  @override
  Widget build(BuildContext context) => Stack(
      children:[
        Center(
          child: Padding(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
          padding: const EdgeInsets.all(16.0),
      ),
        ),
        Center(child: Text("Loading...")),
      ]);

}
