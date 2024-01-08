// Project: leodt_parser
// Author: Daniel Krentzlin
// Dev Environment: Android Studio
// Platform: Windows 11
// Copyright:  2023
// ID: 20231123091857
// 23.11.2023 09:18

import 'package:leodt_parser/src/nodes/interfaces/decision_node.dart';

/// A class representing the root node of a decision tree.
class RootNode extends DecisionNode {
  /// Creates a [RootNode] with the specified attributes.
  ///
  /// - [id]: A unique identifier for this node.
  /// - [decision]: The decision associated with this node.
  /// - [options]: A map of options leading to child nodes.
  RootNode({
    required super.id,
    required super.decision,
    required super.options,
  });
}
