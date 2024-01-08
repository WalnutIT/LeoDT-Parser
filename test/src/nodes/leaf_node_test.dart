// Project: leodt_parser
// Author: Daniel Krentzlin
// Dev Environment: Android Studio
// Platform: Windows 11
// Copyright:  2024
// ID: 20240108085847
// 08.01.2024 08:58

import 'package:bdd_framework/bdd_framework.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leodt_parser/src/nodes/leaf_node.dart';

void main() {
  final feature = BddFeature('LeafNode Class Functionality');

  Bdd(feature)
      .scenario('Creating and Validating a LeafNode Object')
      .given('A unique identifier and a result for a leaf node are provided')
      .when('A LeafNode object is created with these attributes')
      .then(
          'The LeafNode object should have the correct identifier and associated result')
      .run((context) async {
    // given
    const expectedId = 'node1';
    const expectedResult = 'positive';

    // when
    final leafNode = LeafNode(
      id: expectedId,
      result: expectedResult,
    );

    // then
    expect(leafNode.id, equals(expectedId));
    expect(leafNode.result, equals(expectedResult));
  });
}
