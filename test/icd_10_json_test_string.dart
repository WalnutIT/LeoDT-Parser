// Project: leodt_parser
// Author: Daniel Krentzlin
// Dev Environment: Android Studio
// Platform: Windows 11
// Copyright:  2024
// ID: 20240108093602
// 08.01.2024 09:36
const String icd10decisionTreeJson = '''
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
''';
