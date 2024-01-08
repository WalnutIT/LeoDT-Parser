// Project: leodt_parser
// Author: Daniel Krentzlin
// Dev Environment: Android Studio
// Platform: Windows 11
// Copyright:  2023
// ID: 20231123091937
// 23.11.2023 09:19
import 'package:leodt_parser/src/nodes/interfaces/node.dart';
import 'package:leodt_parser/src/nodes/option.dart';

/// An abstract class representing a decision node in a decision tree.
abstract class DecisionNode extends Node {
  /// Creates a [DecisionNode] with the specified parameters.
  ///
  /// - [id]: The unique identifier for this node.
  /// - [decision]: A description of the decision point at this node.
  /// - [options]: A map of possible options, where the keys are option IDs
  ///   and the values are [Option] objects representing the available choices.
  DecisionNode({
    required super.id,
    required this.decision,
    required this.options,
  });

  /// A description of the decision point at this node.
  final String decision;

  /// A map of possible options, where the keys are option IDs and the values
  /// are [Option] objects representing the available choices.
  final Map<String, Option> options;
}
