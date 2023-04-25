import 'package:pcti_feedback/data/evaluation_criteria.dart';
import 'package:flutter/material.dart';

import '../data.dart';

class EvaluationCriteriaDetailsScreen extends StatelessWidget {
  final EvaluationCriteria? evaluation_criteria;

  const EvaluationCriteriaDetailsScreen({
    super.key,
    this.evaluation_criteria,
  });

  @override
  Widget build(BuildContext context) {
    if (evaluation_criteria == null) {
      return const Scaffold(
          body: Center(
        child: Text('No Evaluation Criteria found'),
      ));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(evaluation_criteria!.evaluation_type!.toString()),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              evaluation_criteria!.evaluation_type.toString(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              evaluation_criteria!.id!.toString(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text("eee")
            // Text(
            //   evaluation!.evaluation_criteria_id!.toString(),
            //   style: Theme.of(context).textTheme.headlineMedium,
            // ),
            // Text(
            //   evaluation!.activity_instance_id!.toString(),
            //   style: Theme.of(context).textTheme.headlineMedium,
            // ),
            // Text(
            //   evaluation!.grade!.toString(),
            //   style: Theme.of(context).textTheme.headlineMedium,
            // ),
            // Text(
            //   evaluation!.response!.toString(),
            //   style: Theme.of(context).textTheme.headlineMedium,
            // ),
            // Text(
            //   evaluation!.notes!.toString(),
            //   style: Theme.of(context).textTheme.headlineMedium,
            // ),
            // Text(
            //   evaluation!.updated!.toString(),
            //   style: Theme.of(context).textTheme.headlineMedium,
            // ),
          ],
        ),
      ),
    );
  }
}
