enum TaskPriority { high, medium, low }
enum TaskStatus { pending, inProgress, completed, cancelled }
enum TaskType { pick, pack, receive, count, ship }

class TaskModel {
  final String id;
  final String title;
  final String description;
  final TaskType type;
  final TaskPriority priority;
  final TaskStatus status;
  final DateTime createdAt;
  final String location;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.priority,
    required this.status,
    required this.createdAt,
    required this.location,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: TaskType.values.firstWhere((e) => e.toString() == 'TaskType.${json['type']}'),
      priority: TaskPriority.values.firstWhere((e) => e.toString() == 'TaskPriority.${json['priority']}'),
      status: TaskStatus.values.firstWhere((e) => e.toString() == 'TaskStatus.${json['status']}'),
      createdAt: DateTime.parse(json['createdAt']),
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.toString().split('.').last,
      'priority': priority.toString().split('.').last,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'location': location,
    };
  }
}
