/// =================
/// === TEST CODE ===
/// =================
import 'dart:math';

void main(List<String> args) {
  int wordCount, addTextCount;

  if (args.length != 2) {
    wordCount = 1024;
    addTextCount = 1024 ~/ 10;
  } else {
    wordCount = int.parse(args[0]);
    addTextCount = int.parse(args[1]);
  }

  var runTime = Duration(milliseconds: 0);
  var lastRunTime = runTime;
  var lastlastRunTime = runTime;

  List<String> wordList;

  var testText = _generateText(wordCount);
  var addText = testText.substring(testText.length - addTextCount);

  print("sep=,\nwords, split_time");

  while (runTime.inMicroseconds <= 25000 ||
      lastRunTime.inMicroseconds <= 25000 ||
      lastlastRunTime.inMicroseconds <= 25000) {
    lastlastRunTime = lastRunTime;
    lastRunTime = runTime;

    (runTime, wordList) = _timeMethod(getAtoms, testText);

    print("${wordList.length}, ${runTime.inMicroseconds}");

    testText = testText + addText;
  }

  print("$wordCount / $addTextCount");
}

// @todo: util-lib merge.
/// Wrapper Function, time the run-time of the given function.
///
/// ### Notes
/// 1. Use records in case of multi-input.
(Duration, R) _timeMethod<R, I>(R Function(I input) testFunction, I input) {
  var startTime = DateTime.now();

  var results = testFunction(input);

  var endTime = DateTime.now();

  return (endTime.difference(startTime), results);
}

const alphabet = "abcdefghijklmnopqrstuvwxyz";

/// Split all the text into "words."
List<String> getAtoms(String text) {
  return text.split(" ");
}

// @todo: util-lib merge.
/// Generate text.
String _generateText([int wordCount = 1024]) {
  Random rE = Random.secure();
  String text = '';

  for (var i = 0; i < wordCount; i++) {
    var wCount = rE.nextInt(12);

    for (var i = 0; i < wCount; i++) {
      var cIndex = rE.nextInt(26);
      text += alphabet.substring(cIndex, cIndex + 1);
    }
    text += ' ';
  }

  return text;
}
