// Project: leodt_parser
// Author: Daniel Krentzlin
// Dev Environment: Android Studio
// Platform: Windows 11
// Copyright:  2023
// ID: 20231123092018
// 23.11.2023 09:20
import 'package:leodt_parser/src/nodes/interfaces/decision_node.dart';

/// A class representing an internal node in a decision tree.
class InternalNode extends DecisionNode {
  /// Creates an [InternalNode] with the specified attributes.
  ///
  /// - [id]: A unique identifier for this node.
  /// - [decision]: A description of the decision point associated with this node.
  /// - [options]: A map of options representing possible outcomes of the decision.
  /// - [hint]: A hint or additional information related to the decision.
  /// - [information]: Detailed information about the decision.
  InternalNode({
    required super.id,
    required super.decision,
    required super.options,
    this.hint,
    this.information,
  });

  /// A hint or additional information related to the decision.
  final String? hint;

  /// Detailed information about the decision.
  final String? information;
}
