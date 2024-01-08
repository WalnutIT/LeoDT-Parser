import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:leodt_parser/leodt_parser.dart';

void main() {
  runApp(const MyApp());
}

/// The root widget for your application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LeoDT parser demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ICD10Classification(),
    );
  }
}

/// A widget representing the ICD-10 classification.
class ICD10Classification extends StatefulWidget {
  const ICD10Classification({super.key});

  @override
  State<ICD10Classification> createState() => _ICD10ClassificationState();
}

/// The state for the ICD-10 classification widget.
class _ICD10ClassificationState extends State<ICD10Classification> {
  DecisionTreeImpl? decisionTreeImpl;
  Node? currentNode;

  @override
  void initState() {
    super.initState();

    final decisionTreeRead = jsonDecode(icd10DecisionTreeJson);
    decisionTreeImpl = DecisionTreeImpl()
      ..initialize(
        decisionTree: List<Map<String, dynamic>>.from(decisionTreeRead),
      );

    currentNode = decisionTreeImpl?.getRootNode();
    decisionTreeImpl?.addNodeToHistory(
      node: currentNode ?? RootNode(id: '', decision: '', options: {}),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('LeoDT Parser Demo')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 1920 / 2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: _buildNodeWidgets(currentNode, context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds a list of widgets representing a node and its details.
  ///
  /// This function takes a [node] and a [BuildContext] as parameters
  /// and returns a list of widgets that represent the given node and its details.
  ///
  /// - [node]: The node for which widgets are to be built.
  /// - [context]: The build context for accessing Flutter's framework.
  ///
  /// Returns a list of widgets representing the node and its details.
  List<Widget> _buildNodeWidgets(Node? node, BuildContext context) {
    if (node == null) return [];

    return [
      if (node is LeafNode) _buildLeafNode(node, context),
      if (node is DecisionNode) ..._buildDecisionNode(node, context),
      if (node is RootNode || node is InternalNode)
        ..._buildOptionsNode(node as DecisionNode, context),
      if (node is! RootNode) ..._buildNavigationButtons(node),
    ];
  }

  /// Builds a widget for a leaf node.
  ///
  /// This function takes a [LeafNode] and a [BuildContext] as parameters
  /// and returns a widget that represents the content of the leaf node.
  ///
  /// - [node]: The leaf node for which a widget is to be built.
  /// - [context]: The build context for accessing Flutter's framework.
  ///
  /// Returns a widget representing the leaf node.
  Widget _buildLeafNode(LeafNode node, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(node.result, style: Theme.of(context).textTheme.titleLarge),
    );
  }

  /// Builds widgets for a decision node.
  ///
  /// This function takes a [DecisionNode] and a [BuildContext] as parameters
  /// and returns a list of widgets that represent the content of the decision node.
  ///
  /// - [node]: The decision node for which widgets are to be built.
  /// - [context]: The build context for accessing Flutter's framework.
  ///
  /// Returns a list of widgets representing the decision node.
  List<Widget> _buildDecisionNode(DecisionNode node, BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 6.0,
        ),
        child:
            Text(node.decision, style: Theme.of(context).textTheme.titleLarge),
      ),
    ];
  }

  /// Builds widgets for a decision node's options.
  ///
  /// This function takes a [DecisionNode] and a [BuildContext] as parameters
  /// and returns a list of widgets that represent the options for the decision node.
  ///
  /// - [node]: The decision node for which options are to be displayed.
  /// - [context]: The build context for accessing Flutter's framework.
  ///
  /// Returns a list of widgets representing the decision node's options.
  List<Widget> _buildOptionsNode(DecisionNode node, BuildContext context) {
    List<Widget> widgets = [];
    if (node is InternalNode) {
      widgets.addAll(_buildInternalNodeDetails(node, context));
    }
    widgets.addAll(node.options.values.map((option) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: ListTileButton(
            title: Text(option.when),
            onTap: () => setState(() =>
                currentNode = decisionTreeImpl?.goForward(id: option.then)),
          ),
        )));
    return widgets;
  }

  /// Builds a list of widgets representing details for an internal node.
  ///
  /// This function takes an [InternalNode] and a [BuildContext] as parameters
  /// and creates a list of widgets that represent details for the given internal node.
  ///
  /// - [node]: The internal node for which details are to be displayed.
  /// - [context]: The build context for accessing Flutter's framework.
  ///
  /// Returns a list of widgets representing node details (e.g., information and hint).
  List<Widget> _buildInternalNodeDetails(
      InternalNode node, BuildContext context) {
    List<Widget> widgets = [];

    // Add an 'Information' tile if the node has information.
    if (node.information != null) {
      widgets.add(_buildInfoTile(node.information!, 'Information',
          Icons.info_outline, Colors.lightBlueAccent));
    }

    // Add a 'Hint' tile if the node has a hint.
    if (node.hint != null) {
      widgets.add(_buildInfoTile(
          node.hint!, 'Hint', Icons.warning_outlined, Colors.amber));
    }

    return widgets;
  }

  /// Builds an information tile widget.
  ///
  /// This function creates an expansion tile with a title, icon, and text content.
  ///
  /// - [text]: The text content to be displayed within the tile.
  /// - [title]: The title of the tile.
  /// - [icon]: The icon to be displayed beside the title.
  /// - [iconColor]: The color of the icon.
  ///
  /// Returns a widget representing the information tile.
  Widget _buildInfoTile(
      String text, String title, IconData icon, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 12.0),
            Text(title),
          ],
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  text,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  /// Builds a list of navigation buttons as a list of widgets.
  ///
  /// The function takes a [node] parameter, typically representing a node in a decision tree,
  /// and returns a list of buttons for navigation purposes.
  ///
  /// The returned list includes 'Back' and 'Restart' buttons.
  List<Widget> _buildNavigationButtons(Node node) {
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 32.0,
          ),
          ElevatedButton(
            onPressed: () =>
                setState(() => currentNode = decisionTreeImpl?.goBack()),
            child: const Text('Back'),
          ),
          const SizedBox(height: 12.0),
          ElevatedButton(
            onPressed: () =>
                setState(() => currentNode = decisionTreeImpl?.restart()),
            child: const Text('Restart'),
          ),
          const SizedBox(height: 12.0),
        ],
      ),
    ];
  }
}

/// A custom Flutter widget that creates a styled ListTile with additional customization options.
class ListTileButton extends StatelessWidget {
  /// Constructs a [ListTileButton].
  ///
  /// The [title] and [onTap] parameters are required, while [subtitle] and [leading]
  /// are optional.
  const ListTileButton({
    Key? key,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.leading,
  }) : super(key: key);

  /// The main title widget of the ListTile.
  final Widget title;

  /// An optional subtitle widget for the ListTile.
  final Widget? subtitle;

  /// An optional leading widget for the ListTile.
  final Widget? leading;

  /// A callback function that is executed when the ListTileButton is tapped.
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 350.0,
        minHeight: 150.0,
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(
            width: 2.0, // Corrected to set the stroke width
          ),
        ),
        leading: leading,
        title: Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: title,
        ),
        subtitle: subtitle,
        onTap: onTap,
      ),
    );
  }
}

const String icd10DecisionTreeJson = '''
[
  {
    "id": "1",
    "isRoot": true,
    "decision": "Does the patient have respiratory symptoms?",
    "options": [
      {
        "id": "1.1",
        "when": "Yes",
        "then": "2"
      },
      {
        "id": "1.2",
        "when": "No",
        "then": "3"
      }
    ]
  },
  {
    "id": "2",
    "isLeaf": true,
    "result": "J00-J99 (Respiratory Diseases)"
  },
  {
    "id": "3",
    "decision": "Does the patient have symptoms related to the digestive system?",
    "information": "Abdominal pain or discomfort, Nausea and vomiting and more are possible symptoms.",
    "options": [
      {
        "id": "3.1",
        "when": "Yes",
        "then": "4"
      },
      {
        "id": "3.2",
        "when": "No",
        "then": "5"
      }
    ]
  },
  {
    "id": "4",
    "isLeaf": true,
    "result": "K00-K95 (Digestive Diseases)"
  },
  {
    "id": "5",
    "decision": "Does the patient have symptoms related to the nervous system?",
    "hint": "Care about: Patient History, Medical History and more if necessary.",
    "options": [
      {
        "id": "5.1",
        "when": "Yes",
        "then": "6"
      },
      {
        "id": "5.2",
        "when": "No",
        "then": "7"
      }
    ]
  },
  {
    "id": "6",
    "isLeaf": true,
    "result": "G00-G99 (Nervous System Diseases)"
  },
  {
    "id": "7",
    "isLeaf": true,
    "result": "Further Assessment Needed"
  }
]
''';
