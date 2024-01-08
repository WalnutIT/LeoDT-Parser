// Project: leodt_parser
// Author: Daniel Krentzlin
// Dev Environment: Android Studio
// Platform: Windows 11
// Copyright:  2024
// Id: 20240108084432
// 08.01.2024 08:44
import 'package:bdd_framework/bdd_framework.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leodt_parser/src/nodes/option.dart';

void main() {
  final feature = BddFeature('Option Class Functionality');

  Bdd(feature)
      .scenario('Creating and Validating an Option Object')
      .given('An Id, a decision condition, and a target node Id are provided')
      .when('An Option object is created with these parameters')
      .then(
          'The Option object should have the correct Id, decision condition, and target node Id')
      .run((context) async {
    // given
    const expectedId = 'option1';
    const expectedDecisionCondition = 'if sunny';
    const expectedTargetNodeId = 'node2';

    // when
    final option = Option(
      id: expectedId,
      when: expectedDecisionCondition,
      then: expectedTargetNodeId,
    );

    // then
    expect(option.id, equals(expectedId));
    expect(option.when, equals(expectedDecisionCondition));
    expect(option.then, equals(expectedTargetNodeId));
  });
}
