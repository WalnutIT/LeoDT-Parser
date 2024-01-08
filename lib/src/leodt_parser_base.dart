// Project: leodt_parser
// Author: Daniel Krentzlin
// Dev Environment: Android Studio
// Platform: Windows 11
// Copyright:  2023
// ID: 20231123091647
// 23.11.2023 09:16

import 'package:leodt_parser/src/nodes/interfaces/node.dart';
import 'package:leodt_parser/src/nodes/internal_node.dart';
import 'package:leodt_parser/src/nodes/leaf_node.dart';
import 'package:leodt_parser/src/nodes/option.dart';
import 'package:leodt_parser/src/nodes/root_node.dart';

/// An abstract class representing a decision tree.
///
/// This class provides a framework for building decision trees. It defines
/// constants for key names used in decision tree data, allows you to store
/// a history of visited nodes, and provides methods for initializing the tree
/// and working with its nodes.
abstract class DecisionTree {
  /// Constant key for identifying root nodes in decision tree data.
  static const String isRootKey = 'isRoot';

  /// Constant key for identifying leaf nodes in decision tree data.
  static const String isLeafKey = 'isLeaf';

  /// Constant key for the unique identifier of a node.
  static const String idKey = 'id';

  /// Constant key for the decision text associated with a node.
  static const String decisionKey = 'decision';

  /// Constant key for the list of options associated with a node.
  static const String optionsKey = 'options';

  /// Constant key for the "when" condition in an option.
  static const String whenKey = 'when';

  /// Constant key for the "then" action in an option.
  static const String thenKey = 'then';

  /// Constant key for the result text associated with a leaf node.
  static const String resultKey = 'result';

  /// Constant key for providing hints or additional information about a node.
  static const String hintKey = 'hint';

  /// Constant key for providing detailed information about a node.
  static const String informationKey = 'information';

  /// A list to store the history of visited nodes.
  final List<Node> _history = <Node>[];

  /// Represents the root node of the decision tree.
  ///
  /// The `_rootNode` object is responsible for storing the initial state
  /// of the decision tree, including its unique identifier, the initial
  /// decision or condition, and available options for further branching.
  ///
  /// This variable may be null if the decision tree has not been initialized.
  RootNode? _rootNode;

  /// A map to store all nodes in the decision tree.
  final Map<String, Node> _nodes = <String, Node>{};

  /// Adds a node to the history of visited nodes.
  ///
  /// This method records the traversal history of the decision tree by adding
  /// the specified [node] to the history list.
  void addNodeToHistory({required Node node}) {
    _history.add(node);
  }

  /// Gets a node by its identifier.
  ///
  /// This method retrieves a node from the decision tree based on its unique
  /// [id]. If the node does not exist, a default [LeafNode] is returned with
  /// empty values.
  Node getNode({required String id}) =>
      _nodes[id] ??
      LeafNode(
        id: '',
        result: '',
      );

  /// Gets the last visited node in the history.
  ///
  /// Returns the last visited node stored in the history of visited nodes.
  Node getLastNode() => _history.last;

  /// Clears the history of visited nodes.
  ///
  /// Removes all nodes from the history of visited nodes, effectively
  /// resetting it.
  void clearHistory() {
    _history.clear();
  }

  /// Restarts the decision tree from the root node.
  ///
  /// Clears the history of visited nodes and returns the root node of the
  /// decision tree, effectively restarting the decision-making process.
  ///
  /// If the decision tree has not been initialized or there is no root node,
  /// a default root node with empty values is created and returned.
  Node restart() {
    clearHistory();
    final rootNode = _rootNode ?? RootNode(id: '', decision: '', options: {});

    _history.add(rootNode);

    return rootNode;
  }

  /// Clears the entire tree structure, including root nodes, nodes, and history.
  ///
  /// This method removes all nodes and root nodes from the tree structure,
  /// effectively resetting it to an empty state. Additionally, it clears the
  /// history of navigated nodes.
  void clearTree() {
    _rootNode = null;
    _nodes.clear();
    clearHistory();
  }

  /// Gets the root node in the decision tree.
  ///
  /// This method returns the root node present in the decision tree.
  ///
  /// If the decision tree has not been initialized, a default root node is
  /// created with empty values and returned.
  RootNode getRootNode() =>
      _rootNode ?? RootNode(id: '', decision: '', options: {});

  /// Removes the last visited node from the history.
  ///
  /// This method removes the most recently visited node from the traversal
  /// history, effectively stepping back in the decision tree.
  void removeLastNodeFromHistory() {
    _history.removeLast();
  }

  /// Initializes the decision tree with the provided data.
  ///
  /// This method initializes the decision tree using the provided [decisionTree]
  /// data. It parses the data to create nodes and options, building the tree's
  /// structure.
  void initialize({
    required List<Map<String, dynamic>> decisionTree,
  });

  /// Creates a map of options from a list of option data.
  ///
  /// This method takes a list of option data and converts it into a map of
  /// [Option] objects, where each option is associated with its unique identifier.
  Map<String, Option> createMapOfOptions({
    required List<Map<String, dynamic>> options,
  });

  /// Checks if the history of visited nodes is empty.
  ///
  /// Returns `true` if the history of visited nodes is empty, indicating that
  /// no nodes have been traversed in the decision tree. Otherwise, returns `false`.
  bool isHistoryEmpty() => _history.isEmpty;

  /// Returns the length of the history of visited nodes.
  ///
  /// Returns the number of nodes that have been traversed and stored in the
  /// history, indicating the depth of the decision tree exploration.
  int getHistoryLength() => _history.length;

  /// Returns the number of nodes in the collection.
  ///
  /// Returns the count of nodes currently stored in the collection.
  int getNodesLength() => _nodes.length;

  /// Navigates to the previous node in the decision tree and returns the node
  /// that was navigated to.
  ///
  /// This method allows you to move backward within the decision tree,
  /// revisiting the previously navigated node. If there is no previous node,
  /// this method has no effect and returns `null`.
  ///
  /// Returns the node that was navigated to, or `null` if no previous node exists.
  Node? goBack();

  /// Navigates to the next node in the decision tree based on the provided [id]
  /// and returns the node that was navigated to.
  ///
  /// This method allows you to move forward within the decision tree to a
  /// specific node identified by its [id]. If the node with the given [id]
  /// exists and is a valid next step from the current node, the navigation
  /// will proceed to that node. If the [id] is not valid or there is no
  /// connection to the specified node, this method has no effect and returns `null`.
  ///
  /// To determine the available next nodes and their IDs, you can refer to
  /// the current node's attributes or configuration.
  ///
  /// Example usage:
  /// ```dart
  /// Node? nextNode = decisionTree.goForward(id: 'next_step');
  /// if (nextNode != null) {
  ///   // Handle the next node.
  /// }
  /// ```
  ///
  /// Returns the node that was navigated to, or `null` if the navigation fails.
  Node? goForward({required String id});
}

/// A concrete implementation of the [DecisionTree] class.
///
/// This class extends the [DecisionTree] class to provide a specific
/// implementation of decision tree initialization and option creation.
class DecisionTreeImpl extends DecisionTree {
  @override
  void initialize({
    required List<Map<String, dynamic>> decisionTree,
  }) {
    for (Map<String, dynamic> node in decisionTree) {
      if (node.containsKey(DecisionTree.isRootKey)) {
        _createRootNode(node);
        continue;
      }
      if (node.containsKey(DecisionTree.isLeafKey)) {
        _createLeafNode(node);
        continue;
      }

      _createInternalNode(node);
    }
  }

  @override
  Node? goBack() {
    removeLastNodeFromHistory();
    try {
      return getLastNode();
    } catch (e) {
      return null;
    }
  }

  @override
  Node? goForward({required String id}) {
    try {
      final newNode = getNode(id: id);
      addNodeToHistory(node: newNode);

      return newNode;
    } catch (e) {
      return null;
    }
  }

  /// Creates and adds an internal node to the decision tree based on the provided [node] data.
  ///
  /// This method is used during decision tree initialization to parse and create
  /// internal nodes with their associated properties.
  ///
  /// [node]: A map representing the internal node data.
  void _createInternalNode(Map<String, dynamic> node) {
    final nodeValues = _getNodeValues(node);

    final hint = node[DecisionTree.hintKey] as String?;
    final information = node[DecisionTree.informationKey] as String?;

    _nodes.putIfAbsent(
      nodeValues.$1,
      () => InternalNode(
        id: nodeValues.$1,
        decision: nodeValues.$2,
        options: nodeValues.$3,
        hint: hint,
        information: information,
      ),
    );
  }

  /// Extracts the node values from a given node map.
  ///
  /// This method takes a map representation of a node and extracts its key
  /// attributes, including the unique identifier, decision text, and options.
  /// The method utilizes the [DecisionTree] class's constants to access the
  /// respective values in the map.
  ///
  /// [node]: The map containing the node data. It should include keys for
  ///         the node's ID, decision text, and a list of options.
  ///
  /// Returns a tuple containing the node's ID, decision text, and a map
  /// of its options.
  ///
  /// Throws an exception if the required keys are not present in the [node] map.
  ///
  /// Example usage:
  /// ```
  /// final (id, decision, options) = _getNodeValues(nodeMap);
  /// ```
  (String, String, Map<String, Option>) _getNodeValues(
      Map<String, dynamic> node) {
    final id = node[DecisionTree.idKey] as String;
    final decision = node[DecisionTree.decisionKey] as String;
    final options = createMapOfOptions(
      options: (node[DecisionTree.optionsKey] as List).cast(),
    );

    return (id, decision, options);
  }

  /// Creates and adds a leaf node to the decision tree based on the provided [node] data.
  ///
  /// This method is used during decision tree initialization to parse and create
  /// leaf nodes with their associated properties.
  ///
  /// [node]: A map representing the leaf node data.
  void _createLeafNode(Map<String, dynamic> node) {
    final id = node[DecisionTree.idKey] as String;
    final result = node[DecisionTree.resultKey] as String;
    _nodes.putIfAbsent(id, () => LeafNode(id: id, result: result));
  }

  /// Creates and adds a root node to the decision tree based on the provided [node] data.
  ///
  /// This method is used during decision tree initialization to parse and create
  /// root nodes with their associated properties.
  ///
  /// [node]: A map representing the root node data.
  void _createRootNode(Map<String, dynamic> node) {
    final nodeValues = _getNodeValues(node);

    _rootNode = RootNode(
      id: nodeValues.$1,
      decision: nodeValues.$2,
      options: nodeValues.$3,
    );
  }

  @override
  Map<String, Option> createMapOfOptions({
    required List<Map<String, dynamic>> options,
  }) {
    final output = <String, Option>{};

    for (Map<String, dynamic> option in options) {
      final id = option[DecisionTree.idKey];
      final when = option[DecisionTree.whenKey];
      final then = option[DecisionTree.thenKey];
      final optionObject = Option(
        id: id is String ? id : '',
        when: when is String ? when : '',
        then: then is String ? then : '',
      );

      output.putIfAbsent(
        id is String ? id : '',
        () => optionObject,
      );
    }

    return output;
  }
}
