// Project: leodt_parser
// Author: Daniel Krentzlin
// Dev Environment: Android Studio
// Platform: Windows 11
// Copyright:  2023
// ID: 20231123091925
// 23.11.2023 09:19
/// An abstract class representing a node in a decision tree.
abstract class Node {
  /// Creates a [Node] with the specified unique identifier.
  ///
  /// - [id]: A unique identifier for this node.
  Node({
    required this.id,
  });

  /// A unique identifier for this node.
  final String id;
}
