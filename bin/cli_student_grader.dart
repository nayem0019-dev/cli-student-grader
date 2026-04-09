import 'dart:io';

const String appTitle = "Student Grader v1.0";

final Set<String> availableSubjects = {"Math", "English", "Science", "History"};

var students = <Map<String, dynamic>>[];

void main() {
  // [Concept 1] var - mutable, changes to false when user picks Exit
  var running = true;

  // [Concept 18] do-while - menu runs at least once before checking condition
  do {
    printMenu();

    // [Concept 1] var - stores user input each loop
    var input = stdin.readLineSync();

    // [Concept 14] switch - routes user choice to the correct function
    switch (input) {
      case "1":
        addStudent();
        break;
      case "2":
        recordScore();
        break;
      case "3":
        addBonusPoints();
        break;
      case "4":
        addComment();
        break;
      case "5":
        viewAllStudents();
        break;
      case "6":
        viewReportCard();
        break;
      case "7":
        classSummary();
        break;
      case "8":
        print("Goodbye!");
        running = false;
        break;
      default:
        print("Invalid option. Please choose 1 to 8.");
    }
  } while (running);
}

// -------------------------------------------------------
// PRINT MENU
// -------------------------------------------------------

void printMenu() {
  // [Concept 12] multi-line string using triple quotes
  // [Concept 11] string interpolation - $appTitle is replaced at runtime
  print("""
===== $appTitle =====
1. Add Student
2. Record Score
3. Add Bonus Points
4. Add Comment
5. View All Students
6. View Report Card
7. Class Summary
8. Exit
Choose an option: """);
}

// -------------------------------------------------------
// OPTION 1 - ADD STUDENT
// -------------------------------------------------------

void addStudent() {
  stdout.write("Enter student name: ");
  // [Concept 1] var for input
  var name = stdin.readLineSync();

  if (name == null || name.isEmpty) {
    print("Name cannot be empty.");
    return;
  }

  // [Concept 21] Map - student stored as key-value pairs
  // [Concept 19] List - empty scores list to fill later
  // [Concept 24] spread operator - copies availableSubjects into a new Set
  // [Concept 4]  int? and String? - bonus and comment are nullable (start null)
  Map<String, dynamic> newStudent = {
    "name": name,
    "scores": <int>[],
    "subjects": <String>{...availableSubjects},
    "bonus": null,
    "comment": null,
  };

  students.add(newStudent);

  // [Concept 11] string interpolation
  print("Student " + name + " added successfully.");
}

// -------------------------------------------------------
// OPTION 2 - RECORD SCORE
// -------------------------------------------------------

void recordScore() {
  if (students.isEmpty) {
    print("No students found. Please add a student first.");
    return;
  }

  print("Select a student:");

  // [Concept 15] for loop with index - prints numbered list of students
  for (int i = 0; i < students.length; i++) {
    // [Concept 11] string interpolation
    print((i + 1).toString() + ". " + students[i]["name"]);
  }

  stdout.write("Enter student number: ");
  var studentInput = stdin.readLineSync();
  var studentIndex = int.tryParse(studentInput ?? "") ?? 0;

  if (studentIndex < 1 || studentIndex > students.length) {
    print("Invalid choice.");
    return;
  }

  var student = students[studentIndex - 1];

  print("Available subjects:");
  var subjectList = (student["subjects"] as Set<String>).toList();
  for (int i = 0; i < subjectList.length; i++) {
    print((i + 1).toString() + ". " + subjectList[i]);
  }

  stdout.write("Select subject number: ");
  var subjectInput = stdin.readLineSync();
  var subjectIndex = int.tryParse(subjectInput ?? "") ?? 0;

  if (subjectIndex < 1 || subjectIndex > subjectList.length) {
    print("Invalid choice.");
    return;
  }

  var chosenSubject = subjectList[subjectIndex - 1];

  // [Concept 17] while loop - keeps asking until score is valid (0 to 100)
  int score = -1;
  while (score < 0 || score > 100) {
    stdout.write("Enter score for " + chosenSubject + " (0 to 100): ");
    var raw = stdin.readLineSync();
    score = int.tryParse(raw ?? "") ?? -1;
    if (score < 0 || score > 100) {
      print("Score must be between 0 and 100. Try again.");
    }
  }

  // [Concept 19] List .add() - appends score to the student scores list
  (student["scores"] as List<int>).add(score);

  print(
    "Score " +
        score.toString() +
        " recorded for " +
        student["name"] +
        " in " +
        chosenSubject +
        ".",
  );
}

// -------------------------------------------------------
// OPTION 3 - ADD BONUS POINTS
// -------------------------------------------------------

void addBonusPoints() {
  if (students.isEmpty) {
    print("No students found. Please add a student first.");
    return;
  }

  print("Select a student:");
  for (int i = 0; i < students.length; i++) {
    print((i + 1).toString() + ". " + students[i]["name"]);
  }

  stdout.write("Enter student number: ");
  var input = stdin.readLineSync();
  var index = int.tryParse(input ?? "") ?? 0;

  if (index < 1 || index > students.length) {
    print("Invalid choice.");
    return;
  }

  var student = students[index - 1];

  stdout.write("Enter bonus points (1 to 10): ");
  var raw = stdin.readLineSync();
  var bonusValue = int.tryParse(raw ?? "") ?? 0;

  if (bonusValue < 1 || bonusValue > 10) {
    print("Bonus must be between 1 and 10.");
    return;
  }

  // [Concept 6] ??= - only assigns if bonus is currently null
  // If bonus already has a value, this line does nothing
  student["bonus"] ??= bonusValue;

  // [Concept 13] if / else - check whether bonus was just set or was already set
  if (student["bonus"] == bonusValue) {
    print(
      "Bonus of " +
          bonusValue.toString() +
          " points added to " +
          student["name"] +
          ".",
    );
  } else {
    print(
      student["name"] +
          " already has a bonus of " +
          student["bonus"].toString() +
          " points. Bonus not changed.",
    );
  }
}

// -------------------------------------------------------
// OPTION 4 - ADD COMMENT
// -------------------------------------------------------

void addComment() {
  if (students.isEmpty) {
    print("No students found. Please add a student first.");
    return;
  }

  print("Select a student:");
  for (int i = 0; i < students.length; i++) {
    print((i + 1).toString() + ". " + students[i]["name"]);
  }

  stdout.write("Enter student number: ");
  var input = stdin.readLineSync();
  var index = int.tryParse(input ?? "") ?? 0;

  if (index < 1 || index > students.length) {
    print("Invalid choice.");
    return;
  }

  var student = students[index - 1];

  stdout.write("Enter comment for " + student["name"] + ": ");
  var comment = stdin.readLineSync();

  // [Concept 4] String? - comment stored as nullable string
  student["comment"] = (comment == null || comment.isEmpty) ? null : comment;

  // [Concept 7] ?. - calls toUpperCase only if comment is not null
  // [Concept 5] ?? - fallback text if comment is null
  String display =
      (student["comment"] as String?)?.toUpperCase() ?? "No comment provided";

  print("Comment saved: " + display);
}

// -------------------------------------------------------
// OPTION 5 - VIEW ALL STUDENTS
// -------------------------------------------------------

void viewAllStudents() {
  if (students.isEmpty) {
    print("No students found.");
    return;
  }

  print("--- All Students ---");

  // [Concept 16] for-in loop - iterates over every student in the list
  for (var student in students) {
    // [Concept 22] collection if - bonus tag only included when bonus is not null
    var tags = [
      student["name"] as String,
      (student["scores"] as List).length.toString() + " scores",
      if (student["bonus"] != null) "Has Bonus",
      if (student["comment"] != null) "Has Comment",
    ];

    print(tags.join(" | "));
  }
}

// -------------------------------------------------------
// OPTION 6 - VIEW REPORT CARD
// -------------------------------------------------------

void viewReportCard() {
  if (students.isEmpty) {
    print("No students found. Please add a student first.");
    return;
  }

  print("Select a student:");
  for (int i = 0; i < students.length; i++) {
    print((i + 1).toString() + ". " + students[i]["name"]);
  }

  stdout.write("Enter student number: ");
  var input = stdin.readLineSync();
  var index = int.tryParse(input ?? "") ?? 0;

  if (index < 1 || index > students.length) {
    print("Invalid choice.");
    return;
  }

  var student = students[index - 1];
  var scores = student["scores"] as List<int>;

  if (scores.isEmpty) {
    print("No scores recorded for " + student["name"] + " yet.");
    return;
  }

  // [Concept 8] arithmetic operators - sum then divide to get average
  int sum = 0;
  for (int s in scores) {
    sum = sum + s;
  }
  double rawAvg = sum / scores.length;

  // [Concept 5] ?? - if bonus is null, use 0
  double finalAvg = rawAvg + (student["bonus"] ?? 0);

  // cap at 100
  if (finalAvg > 100) {
    finalAvg = 100;
  }

  // [Concept 9]  relational operators - >= and <
  // [Concept 13] if / else if / else - grade thresholds
  String grade;
  if (finalAvg >= 90) {
    grade = "A";
  } else if (finalAvg >= 80) {
    grade = "B";
  } else if (finalAvg >= 70) {
    grade = "C";
  } else if (finalAvg >= 60) {
    grade = "D";
  } else {
    grade = "F";
  }

  // [Concept 14] switch expression with pattern matching on grade letter
  String feedback = switch (grade) {
    "A" => "Outstanding performance!",
    "B" => "Good work, keep it up!",
    "C" => "Satisfactory. Room to improve.",
    "D" => "Needs improvement.",
    "F" => "Failing. Please seek help.",
    _ => "Unknown grade.",
  };

  String bonusDisplay = student["bonus"] != null
      ? "+" + student["bonus"].toString()
      : "None";

  // [Concept 7] ?. and [Concept 5] ??
  String commentDisplay =
      (student["comment"] as String?)?.toUpperCase() ?? "No comment provided";

  // [Concept 12] multi-line string
  // [Concept 11] string interpolation inside the box
  print("""
╔══════════════════════════════╗
║         REPORT CARD          ║
╠══════════════════════════════╣
║ Name    : ${padRight(student["name"] as String, 19)}║
║ Scores  : ${padRight(scores.toString(), 19)}║
║ Bonus   : ${padRight(bonusDisplay, 19)}║
║ Average : ${padRight(finalAvg.toStringAsFixed(1), 19)}║
║ Grade   : ${padRight(grade, 19)}║
║ Comment : ${padRight(commentDisplay, 19)}║
╚══════════════════════════════╝
Feedback: $feedback
""");
}

// -------------------------------------------------------
// OPTION 7 - CLASS SUMMARY
// -------------------------------------------------------

void classSummary() {
  if (students.isEmpty) {
    print("No students found.");
    return;
  }

  // [Concept 23] collection for - builds summary lines from each student
  var summaryLines = [
    for (var s in students)
      s["name"] + ": avg " + getFinalAverage(s).toStringAsFixed(1),
  ];

  int total = students.length;
  double classTotal = 0;
  double highest = -1;
  double lowest = 101;
  int passCount = 0;

  // [Concept 20] Set - stores unique grade letters, no duplicates
  Set<String> uniqueGrades = {};

  for (var s in students) {
    var scores = s["scores"] as List<int>;

    // [Concept 10] logical operators && - both conditions must be true
    if (scores.isNotEmpty && getFinalAverage(s) >= 0) {
      double avg = getFinalAverage(s);
      classTotal = classTotal + avg;

      // [Concept 9] relational operators
      if (avg > highest) highest = avg;
      if (avg < lowest) lowest = avg;

      // [Concept 10] logical operator && again - scores exist AND student passes
      if (scores.isNotEmpty && avg >= 60) {
        passCount = passCount + 1;
      }

      uniqueGrades.add(getGrade(avg));
    }
  }

  double classAvg = classTotal / total;
  var sortedGrades = uniqueGrades.toList()..sort();

  // [Concept 12] multi-line string  [Concept 11] string interpolation
  print("""
--- Class Summary ---
Total students : $total
Class average  : ${classAvg.toStringAsFixed(1)}
Highest average: ${highest == -1 ? "N/A" : highest.toStringAsFixed(1)}
Lowest average : ${lowest == 101 ? "N/A" : lowest.toStringAsFixed(1)}
Passing (60+)  : $passCount
Unique grades  : ${sortedGrades.join(", ")}

Individual averages:""");

  // print the collection for result
  for (var line in summaryLines) {
    print("  " + line);
  }

  print("");
}

// -------------------------------------------------------
// HELPER FUNCTIONS
// -------------------------------------------------------

// Calculates the bonus-adjusted final average for a student
double getFinalAverage(Map<String, dynamic> student) {
  var scores = student["scores"] as List<int>;
  if (scores.isEmpty) return 0;

  // [Concept 8] arithmetic
  int sum = 0;
  for (int s in scores) {
    sum = sum + s;
  }
  double avg = sum / scores.length;

  // [Concept 5] ?? - treat null bonus as 0
  avg = avg + (student["bonus"] ?? 0);

  return avg > 100 ? 100 : avg;
}

// Returns letter grade for a given average
String getGrade(double avg) {
  if (avg >= 90) return "A";
  if (avg >= 80) return "B";
  if (avg >= 70) return "C";
  if (avg >= 60) return "D";
  return "F";
}

// Pads a string to exactly width characters for report card alignment
String padRight(String text, int width) {
  if (text.length >= width) return text.substring(0, width);
  return text.padRight(width);
}
