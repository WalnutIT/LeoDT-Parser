<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

# LeoDT Parser

The LeoDT Parser is a Dart package designed for parsing and interpreting decision tree structures
specified in the LeoDT format. It provides a robust solution for applications requiring
decision-making capabilities, particularly useful in domains like medical diagnosis, troubleshooting
systems, or any scenario where a series of decisions leads to a conclusive result.

## Features

- Parses LeoDT (Leo Decision Tree) formatted data into usable decision tree structures.
- Supports navigation through the decision tree, including forward and backward steps.
- Manages a history of visited nodes for tracking decision paths.
- Offers utilities for retrieving node information and tree statistics.

## LeoDT document

A LeoDT document is a structured representation of a decision tree, designed to guide users through
a series of decisions and outcomes. Each node in the tree represents a decision point, with options
leading to different paths based on the user's choice. The format is highly versatile and can be
applied across various domains, from healthcare to customer service, facilitating complex
decision-making processes. The document typically includes root nodes, decision criteria, options
with conditions (when), and potential results (then), making it an intuitive and systematic approach
to navigating through multiple decision scenarios.

**id**: A unique identifier for each node in the tree. It helps in differentiating and navigating to
different nodes.

**isRoot**: A boolean flag indicating if the node is the starting point (root) of the decision tree.

**decision**: This is a question or statement that prompts a decision. It's the criteria on which the
branching of options is based.

**options**: An array of possible choices or paths stemming from a decision node. Each option dictates
the flow of the decision tree based on conditions.

Within each option:
    **id**: The unique identifier of the option, helping to distinguish different choices.
    **when**: A condition or description for the option. It specifies the scenario in which this option
                should be selected.
    **then**: Indicates the next step or node's id to navigate to if this option is selected. If leading to
                a conclusion, it might include a result or outcome instead of a node id.
**isLeaf**: This flag indicates if the node is a leaf node, i.e., an endpoint without further branching.

**result**: Provided in leaf nodes, it indicates the final outcome or conclusion of that decision path.

### Example LeoDT document

```json
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
```

## Getting started

To start using the LeoDT Parser, add it as a dependency to your Dart or Flutter project:

```yaml
dependencies:
  leodt_parser: ^current version
```

## Usage

```dart

import 'package:leodt_parser/leodt_parser.dart';

Future<void> main() async {
  var decisionTree = await loadLeoDtDocument();
  var decisionTreeImpl = DecisionTreeImpl()
    ..initialize(decisionTree: decisionTree);

  // Navigate through the tree forward and backward
  var currentNode = decisionTreeImpl.goForward('nodeId');
  var currentNode = decisionTreeImpl.goBackward();

  // Restart the tree
  final rootNode = decisionTree.restart();
}
```

## Additional information

For more information, updates, and how to contribute, please visit our GitHub repository.

To report issues or suggestions, please use the GitHub issues page. Contributions to the package are
always welcome!
