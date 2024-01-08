// Project: leodt_parser
// Author: Daniel Krentzlin
// Dev Environment: Android Studio
// Platform: Windows 11
// Copyright:  2024
// ID: 20240108091634
// 08.01.2024 09:16
import 'package:bdd_framework/bdd_framework.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leodt_parser/src/nodes/internal_node.dart';
import 'package:leodt_parser/src/nodes/option.dart';

void main() {
  final feature = BddFeature('InternalNode Class Functionality');

  Bdd(feature)
      .scenario('Creating and Validating an InternalNode Object')
      .given(
          'Unique identifier, decision, options, hint, and information for an internal node are provided')
      .when('An InternalNode object is created with these attributes')
      .then(
          'The InternalNode object should have the correct identifier, decision, options, hint, and information')
      .run((context) async {
    // given
    const expectedId = 'internalNode1';
    const expectedDecision = 'Decision Description';
    final expectedOptions = {
      'option1': Option(id: 'option1', when: 'condition1', then: 'result1')
    };
    const expectedHint = 'Decision Hint';
    const expectedInformation = 'Detailed Decision Information';

    // when
    final internalNode = InternalNode(
      id: expectedId,
      decision: expectedDecision,
      options: expectedOptions,
      hint: expectedHint,
      information: expectedInformation,
    );

    // then
    expect(internalNode.id, equals(expectedId));
    expect(internalNode.decision, equals(expectedDecision));
    expect(internalNode.options, equals(expectedOptions));
    expect(internalNode.hint, equals(expectedHint));
    expect(internalNode.information, equals(expectedInformation));
  });
}
