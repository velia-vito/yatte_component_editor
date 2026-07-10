/// =================
/// === TEST CODE ===
/// =================

import 'dart:math';
import 'dart:ui';
import 'dart:io'; // Required for File IO

Future<void> main() async {
  var wordCount = 1024;
  var addTextCount = 2;

  // 1. Initialize File and Sink
  final file = File('measurement_test.csv');
  final sink = file.openWrite();

  var runTime = Duration(milliseconds: 0);
  var lastRunTime = runTime;
  var lastlastRunTime = runTime;

  var testAtoms = getAtoms(_generateText(wordCount));
  // Convert to List immediately to avoid Concurrent Modification errors during the loop
  var addText = testAtoms.getRange(0, addTextCount).toList();

  // 2. Write CSV Headers
  sink.writeln("sep=,");
  sink.writeln("words, split_time");

  // Also print to console so you can see progress
  print("Benchmarking... writing to ${file.path}");

  while (runTime.inMicroseconds <= 25000 ||
      lastRunTime.inMicroseconds <= 25000 ||
      lastlastRunTime.inMicroseconds <= 25000) {
    lastlastRunTime = lastRunTime;
    lastRunTime = runTime;

    (runTime, _) = _timeMethod(measureAllAtomWidth, testAtoms);

    // 3. Write data row to file
    sink.writeln("${testAtoms.length}, ${runTime.inMicroseconds}");

    testAtoms.addAll(addText);
  }

  // 4. Close the sink to save the file
  await sink.flush();
  await sink.close();
  print("Done. Results saved to measurement_test.csv");
}

/// Wrapper Function, time the run-time of the given function.
(Duration, R) _timeMethod<R, I>(R Function(I input) testFunction, I input) {
  var startTime = DateTime.now();
  var results = testFunction(input);
  var endTime = DateTime.now();
  return (endTime.difference(startTime), results);
}

const alphabet = "abcdefghijklmnopqrstuvwxyz";

List<String> getAtoms(String text) {
  return text.split(" ");
}

Paragraph measureAtom(String text) {
  var atomBuilder = ParagraphBuilder(ParagraphStyle())..addText(text);
  var paragraph = atomBuilder.build();

  // IMPORTANT: You must call layout() for the engine to actually calculate widths.
  paragraph.layout(const ParagraphConstraints(width: double.infinity));

  return paragraph;
}

void measureAllAtomWidth(List<String> atoms) {
  for (var a in atoms) {
    measureAtom(a);
  }
}

String _generateText([int wordCount = 1024]) {
  Random rE = Random.secure();
  StringBuffer buffer =
      StringBuffer(); // Using StringBuffer is faster for generation

  for (var i = 0; i < wordCount; i++) {
    var wCount = rE.nextInt(12);
    for (var j = 0; j < wCount; j++) {
      var cIndex = rE.nextInt(26);
      buffer.write(alphabet[cIndex]);
    }
    buffer.write(' ');
  }

  return buffer.toString();
}
