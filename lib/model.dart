class Task {
  String title;
  bool isCompleted;

  Task({required this.title, this.isCompleted = false});

  // Convert a Task into a JSON format
  Map<String, dynamic> toJson() => {
        'title': title,
        'isCompleted': isCompleted,
      };

  // Create a Task from JSON data
  factory Task.fromJson(Map<String, dynamic> json) => Task(
        title: json['title'],
        isCompleted: json['isCompleted'],
      );
}
