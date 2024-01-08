// Project: leodt_parser
// Author: Daniel Krentzlin
// Dev Environment: Android Studio
// Platform: Windows 11
// Copyright:  2024
// ID: 20240108091352
// 08.01.2024 09:13
import 'package:bdd_framework/bdd_framework.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leodt_parser/src/nodes/option.dart';
import 'package:leodt_parser/src/nodes/root_node.dart';

void main() {
  final feature = BddFeature('RootNode Class Functionality');

  Bdd(feature)
      .scenario('Creating and Validating a RootNode Object')
      .given(
          'A unique identifier, a decision, and options for a root node are provided')
      .when('A RootNode object is created with these attributes')
      .then(
          'The RootNode object should have the correct identifier, decision, and options')
      .run((context) async {
    // given
    const expectedId = 'rootNode1';
    const expectedDecision = 'Choose Option';
    final expectedOptions = {
      'option1': Option(id: 'option1', when: 'condition1', then: 'result1')
    };

    // when
    final rootNode = RootNode(
      id: expectedId,
      decision: expectedDecision,
      options: expectedOptions,
    );

    // then
    expect(rootNode.id, equals(expectedId));
    expect(rootNode.decision, equals(expectedDecision));
    expect(rootNode.options, equals(expectedOptions));
  });
}
