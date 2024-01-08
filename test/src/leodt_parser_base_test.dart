// Project: leodt_parser
// Author: Daniel Krentzlin
// Dev Environment: Android Studio
// Platform: Windows 11
// Copyright:  2024
// ID: 20240108091829
// 08.01.2024 09:18
import 'dart:convert';

import 'package:bdd_framework/bdd_framework.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leodt_parser/src/leodt_parser_base.dart';
import 'package:leodt_parser/src/nodes/internal_node.dart';
import 'package:leodt_parser/src/nodes/leaf_node.dart';
import 'package:leodt_parser/src/nodes/option.dart';
import 'package:leodt_parser/src/nodes/root_node.dart';

import '../icd_10_json_test_string.dart';

void main() {
  final feature1 = BddFeature('DecisionTree Initialization');

  Bdd(feature1)
      .scenario('Initializing Decision Tree with Data')
      .given('Properly formatted decision tree data is provided')
      .when('initialize method is called with this data')
      .then(
          'The decision tree should be correctly initialized with nodes and options')
      .run((context) async {
    // given
    final decisionTreeRead = jsonDecode(icd10decisionTreeJson);

    final decisionTree = <Map<String, dynamic>>[];

    for (final element in decisionTreeRead) {
      decisionTree.add(element as Map<String, dynamic>);
    }

    final decisionTreeImpl = DecisionTreeImpl();

    // when

    decisionTreeImpl.initialize(decisionTree: decisionTree);

    // then

    // Extract the first root node for easier testing
    final rootNode = decisionTreeImpl.getRootNode();
    final options = rootNode.options.values.cast<Option>().toList();
    final node2 = decisionTreeImpl.getNode(id: "2") as LeafNode;
    final node3 = decisionTreeImpl.getNode(id: "3") as InternalNode;
    final optionsNode3 = node3.options.values.cast<Option>().toList();
    final node4 = decisionTreeImpl.getNode(id: "4") as LeafNode;
    final node5 = decisionTreeImpl.getNode(id: "5") as InternalNode;
    final optionsNode5 = node5.options.values.cast<Option>().toList();
    final node6 = decisionTreeImpl.getNode(id: "6") as LeafNode;
    final node7 = decisionTreeImpl.getNode(id: "7") as LeafNode;

    // Test root node
    expect(rootNode.id, equals("1"));
    expect(rootNode.decision,
        equals("Does the patient have respiratory symptoms?"));
    expect(options.length, equals(2));

    // Test first option
    expect(options[0].id, equals("1.1"));
    expect(options[0].when, equals("Yes"));
    expect(options[0].then, equals("2"));

    // Test second option
    expect(options[1].id, equals("1.2"));
    expect(options[1].when, equals("No"));
    expect(options[1].then, equals("3"));

    // Test Node 2
    expect(node2.id, equals("2"));
    expect(node2.result, equals("J00-J99 (Respiratory Diseases)"));

    // Test Node 3
    expect(node3.id, equals("3"));
    expect(
        node3.decision,
        equals(
            "Does the patient have symptoms related to the digestive system?"));
    expect(optionsNode3.length, equals(2));
    expect(optionsNode3[0].id, equals("3.1"));
    expect(optionsNode3[0].when, equals("Yes"));
    expect(optionsNode3[0].then, equals("4"));
    expect(optionsNode3[1].id, equals("3.2"));
    expect(optionsNode3[1].when, equals("No"));
    expect(optionsNode3[1].then, equals("5"));

    // Test Node 4
    expect(node4.id, equals("4"));
    expect(node4.result, equals("K00-K95 (Digestive Diseases)"));

    // Test Node 5
    expect(node5.id, equals("5"));
    expect(
        node5.decision,
        equals(
            "Does the patient have symptoms related to the nervous system?"));
    expect(optionsNode5.length, equals(2));
    expect(optionsNode5[0].id, equals("5.1"));
    expect(optionsNode5[0].when, equals("Yes"));
    expect(optionsNode5[0].then, equals("6"));
    expect(optionsNode5[1].id, equals("5.2"));
    expect(optionsNode5[1].when, equals("No"));
    expect(optionsNode5[1].then, equals("7"));

    // Test Node 6
    expect(node6.id, equals("6"));
    expect(node6.result, equals("G00-G99 (Nervous System Diseases)"));

    // Test Node 7
    expect(node7.id, equals("7"));
    expect(node7.result, equals("Further Assessment Needed"));
  });

  final feature2 = BddFeature('Node History Management');

  Bdd(feature2)
      .scenario('Adding Node to History')
      .given('A decision tree is initialized')
      .when('A node is added to the tree\'s history')
      .then('The tree\'s history should include the added node')
      .run((context) async {
    // given
    final decisionTree =
        DecisionTreeImpl(); // Replace with actual implementation
    final node = InternalNode(
        id: 'testNode',
        decision: "testDecision",
        options: {}); // Replace with actual node creation logic

    // when
    decisionTree.addNodeToHistory(node: node);

    // then
    expect(decisionTree.getLastNode(), equals(node));
  });

  Bdd(feature2)
      .scenario('Clearing Node History')
      .given('A decision tree with a history of visited nodes')
      .when('clearHistory method is called')
      .then('The history of visited nodes should be empty')
      .run((context) async {
    // given
    final decisionTreeImpl =
        DecisionTreeImpl(); // Replace with actual implementation
    final node = LeafNode(
        id: 'testNode', result: ''); // Replace with actual node creation logic
    decisionTreeImpl.addNodeToHistory(node: node);

    // when
    decisionTreeImpl.clearHistory();

    // then
    expect(
      decisionTreeImpl.getHistoryLength() == 0,
      isTrue,
    );
  });

  final feature3 = BddFeature('Node Retrieval Functionality');

  Bdd(feature3)
      .scenario('Retrieving a Node by ID')
      .given('A decision tree with nodes is initialized')
      .when('getNode method is called with a specific node ID')
      .then(
          'The corresponding node should be returned, or a default LeafNode if not found')
      .run((context) async {
    // given
    final expectedNode =
        LeafNode(id: '2', result: 'J00-J99 (Respiratory Diseases)');

    final decisionTreeRead = jsonDecode(icd10decisionTreeJson);

    final decisionTree = <Map<String, dynamic>>[];

    for (final element in decisionTreeRead) {
      decisionTree.add(element as Map<String, dynamic>);
    }

    final decisionTreeImpl = DecisionTreeImpl()
      ..initialize(decisionTree: decisionTree);

    // when

    final resultNode = decisionTreeImpl.getNode(id: '2') as LeafNode;

    // then
    expect(resultNode.id, equals(expectedNode.id));
    expect(resultNode.result, equals(expectedNode.result));
    // Additional check for a non-existing node
    expect(decisionTreeImpl.getNode(id: '8'), isA<LeafNode>());
  });

  final feature4 = BddFeature('Decision Tree Functionality');

  Bdd(feature4)
      .scenario('Restarting the Decision Tree')
      .given('A decision tree with a history of visited nodes')
      .when('restart method is called')
      .then(
          'The tree should be restarted from the root node, and history also contains only the root node')
      .run((context) async {
    // given

    final decisionTreeRead = jsonDecode(icd10decisionTreeJson);

    final decisionTree = <Map<String, dynamic>>[];

    for (final element in decisionTreeRead) {
      decisionTree.add(element as Map<String, dynamic>);
    }
    final decisionTreeImpl = DecisionTreeImpl()
      ..initialize(decisionTree: decisionTree);

    // when
    final restartedNode = decisionTreeImpl.restart();

    // then
    // Ensure it's the root node
    expect(restartedNode.id, equals("1"));
    // Check if the history is cleared
    expect(
        decisionTreeImpl.getLastNode() is RootNode &&
            decisionTreeImpl.getHistoryLength() == 1,
        isTrue);
  });

  final feature5 = BddFeature('Tree Structure Management');

  Bdd(feature5)
      .scenario('Clearing Entire Tree Structure')
      .given('A decision tree with nodes and history')
      .when('clearTree method is called')
      .then(
          'All nodes, root nodes, and history should be cleared, resetting the tree')
      .run((context) async {
    // given
    final decisionTreeRead = jsonDecode(icd10decisionTreeJson);

    final decisionTree = <Map<String, dynamic>>[];

    for (final element in decisionTreeRead) {
      decisionTree.add(element as Map<String, dynamic>);
    }

    final decisionTreeImpl = DecisionTreeImpl()
      ..initialize(decisionTree: decisionTree);

    // when
    decisionTreeImpl.clearTree();

    // then
    expect(decisionTreeImpl.getNodesLength() == 0,
        isTrue); // Check if the tree is empty
    expect(decisionTreeImpl.getHistoryLength() == 0,
        isTrue); // Check if the history is empty
    expect(
        decisionTreeImpl.getRootNode().id.isEmpty &&
            decisionTreeImpl.getRootNode().decision.isEmpty &&
            decisionTreeImpl.getRootNode().options.isEmpty,
        isTrue);
  });

  final feature6 = BddFeature('Node History Status Check');

  Bdd(feature6)
      .scenario('Checking if Node History is Empty')
      .given('A decision tree is initialized')
      .when('isHistoryEmpty method is called')
      .then(
          'It should return true if no nodes have been visited, false otherwise')
      .run((context) async {
    // given
    final decisionTreeImpl = DecisionTreeImpl();

    // when & then for empty history
    expect(decisionTreeImpl.isHistoryEmpty(), isTrue);

    // Adding a node to history for further check
    decisionTreeImpl.addNodeToHistory(
        node: LeafNode(id: '', result: '')); // Add a node to the history

    // when & then for non-empty history
    expect(decisionTreeImpl.isHistoryEmpty(), isFalse);
  });

  final feature7 = BddFeature('Node History Length Check');

  Bdd(feature7)
      .scenario('Getting the Length of Node History')
      .given('A decision tree with a history of visited nodes')
      .when('getHistoryLength method is called')
      .then(
          'It should return the number of nodes traversed in the decision tree')
      .run((context) async {
    // given
    final decisionTreeImpl = DecisionTreeImpl();
    decisionTreeImpl.addNodeToHistory(
        node: LeafNode(id: 'testNode1', result: 'result1'));
    decisionTreeImpl.addNodeToHistory(
        node: LeafNode(id: 'testNode2', result: 'result2'));

    // when
    final historyLength = decisionTreeImpl.getHistoryLength();

    // then
    expect(historyLength, equals(2)); // Assuming two nodes were added
  });

  final feature8 = BddFeature('Node Count Check');

  Bdd(feature8)
      .scenario('Getting the Total Number of Nodes in the Tree')
      .given('A decision tree with a collection of nodes')
      .when('getNodesLength method is called')
      .then(
          'It should return the total count of nodes stored in the collection')
      .run((context) async {
    // given

    final decisionTreeRead = jsonDecode(icd10decisionTreeJson);

    final decisionTree = <Map<String, dynamic>>[];

    for (final element in decisionTreeRead) {
      decisionTree.add(element as Map<String, dynamic>);
    }

    final decisionTreeImpl = DecisionTreeImpl()
      ..initialize(decisionTree: decisionTree);

    // when
    final nodesCount = decisionTreeImpl.getNodesLength();

    // then
    expect(nodesCount, equals(6)); // Or the total number of nodes you added
  });

  final feature9 = BddFeature('Node History Management');

  Bdd(feature9)
      .scenario('Removing Last Node from History')
      .given('A decision tree with a history of visited nodes')
      .when('removeLastNodeFromHistory method is called')
      .then('The most recent node should be removed from the history')
      .run((context) async {
    // given
    final decisionTreeImpl = DecisionTreeImpl();
    final firstNode = LeafNode(id: 'node1', result: 'r1');
    final lastNode = LeafNode(id: 'node2', result: 'r2');
    decisionTreeImpl.addNodeToHistory(
      node: firstNode,
    );
    decisionTreeImpl.addNodeToHistory(
      node: lastNode,
    );

    // when
    decisionTreeImpl.removeLastNodeFromHistory();

    // then
    expect(decisionTreeImpl.getLastNode(), equals(firstNode));
    expect(decisionTreeImpl.getHistoryLength(), equals(1));
  });

  final feature10 = BddFeature('Tree Navigation');

  Bdd(feature10)
      .scenario('Navigating Backward in the Decision Tree')
      .given('A decision tree with a history of visited nodes')
      .when('goBack method is called')
      .then(
          'The tree should navigate to the previous node and return it, or return null if there is no previous node')
      .run((context) async {
    // given
    final decisionTreeImpl = DecisionTreeImpl();
    final firstNode = LeafNode(id: 'node1', result: 'r1');
    final secondNode = LeafNode(id: 'node2', result: 'r2');
    decisionTreeImpl.addNodeToHistory(node: firstNode);
    decisionTreeImpl.addNodeToHistory(node: secondNode);

    // Positive test
    // when
    final previousNode = decisionTreeImpl.goBack();

    // then
    expect(previousNode, equals(firstNode));

    // Negative test
    // when
    final nullNode = decisionTreeImpl.goBack();

    // then
    expect(nullNode, isNull);
  });

  Bdd(feature10)
      .scenario('Navigating Forward to a Specific Node')
      .given('A decision tree with interconnected nodes')
      .when('goForward method is called with a specific node ID')
      .then('The tree should navigate to the specified node and return it')
      .run((context) async {
    // given

    final decisionTreeRead = jsonDecode(icd10decisionTreeJson);

    final decisionTree = <Map<String, dynamic>>[];

    for (final element in decisionTreeRead) {
      decisionTree.add(element as Map<String, dynamic>);
    }

    final decisionTreeImpl = DecisionTreeImpl()
      ..initialize(decisionTree: decisionTree);

    // when
    final resultNode = decisionTreeImpl.goForward(id: '2');

    // then
    expect(resultNode?.id ?? '-1', equals('2'));

    // Negative test
    // when
    final negativeResultNode =
        decisionTreeImpl.goForward(id: '100') as LeafNode;

    // then
    expect(negativeResultNode.id.isEmpty && negativeResultNode.result.isEmpty,
        isTrue);
  });
}
