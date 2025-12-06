class Task {
  final int? id;
  final String title;        
  final String? description;
  final String date;       
  final String priority;  
  final int status;       

  Task({
    this.id,
    required this.title,   
    this.description,
    required this.date,
    required this.priority,
    required this.status,
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'] ?? '',
      description: map['description'],
      date: map['date'] ?? '',
      priority: map['priority'] ?? 'Low',
      status: map['status'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'priority': priority,
      'status': status,
    };
  }

  Task copyWith({
    int? id,
    String? title,
    String? description,
    String? date,
    String? priority,
    int? status,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      priority: priority ?? this.priority,
      status: status ?? this.status,
    );
  }
}