// Project: leodt_parser
// Author: Daniel Krentzlin
// Dev Environment: Android Studio
// Platform: Windows 11
// Copyright:  2023
// ID: 20231123092038
// 23.11.2023 09:20

import 'package:leodt_parser/src/nodes/interfaces/node.dart';

/// A class representing a leaf node in a decision tree.
class LeafNode extends Node {
  /// Creates a [LeafNode] with the specified attributes.
  ///
  /// - [id]: A unique identifier for this node.
  /// - [result]: The result or classification associated with this leaf node.
  LeafNode({
    required super.id,
    required this.result,
  });

  /// The result or classification associated with this leaf node.
  final String result;
}
