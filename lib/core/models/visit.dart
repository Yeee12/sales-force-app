class Visit {
  final int? id;
  final int customerId;
  final DateTime visitDate;
  final String status;
  final String location;
  final String notes;
  final List<String> activitiesDone;
  final DateTime? createdAt;
  final bool isLocal;

  Visit({
    this.id,
    required this.customerId,
    required this.visitDate,
    required this.status,
    required this.location,
    required this.notes,
    required this.activitiesDone,
    this.createdAt,
    this.isLocal = false,
  });

  factory Visit.fromJson(Map<String, dynamic> json) {
    List<String> parseActivities(dynamic activities) {
      if (activities == null) return [];
      if (activities is String) {
        String cleaned = activities.toString().replaceAll(RegExp(r'[{}]'), '');
        return cleaned.isEmpty ? [] : cleaned.split(',').map((e) => e.trim()).toList();
      }
      if (activities is List) {
        return List<String>.from(activities);
      }
      return [];
    }

    return Visit(
      id: json['id'],
      customerId: json['customer_id'],
      visitDate: DateTime.parse(json['visit_date']),
      status: json['status'],
      location: json['location'],
      notes: json['notes'],
      activitiesDone: parseActivities(json['activities_done']),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      isLocal: json['is_local'] == 1 || json['is_local'] == true,
    );
  }

  Map<String, dynamic> toApiJson() {
    String activitiesFormatted;
    if (activitiesDone.isEmpty) {
      activitiesFormatted = '{}';
    } else {
      List<String> activities;
      if (activitiesDone is List<String>) {
        activities = activitiesDone;
      } else {
        activities = activitiesDone.map((e) => e.toString()).toList();
      }
      activitiesFormatted = '{${activities.join(',')}}';
    }

    return {
      if (id != null) 'id': id,
      'customer_id': customerId,
      'visit_date': visitDate.toIso8601String(),
      'status': status,
      'location': location,
      'notes': notes,
      'activities_done': activitiesFormatted,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }

  Map<String, dynamic> toLocalJson() {
    return {
      if (id != null) 'id': id,
      'customer_id': customerId,
      'visit_date': visitDate.toIso8601String(),
      'status': status,
      'location': location,
      'notes': notes,
      'activities_done': activitiesDone.join(','),
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      'is_local': isLocal ? 1 : 0,
    };
  }

  Visit copyWith({
    int? id,
    int? customerId,
    DateTime? visitDate,
    String? status,
    String? location,
    String? notes,
    List<String>? activitiesDone,
    DateTime? createdAt,
    bool? isLocal,
  }) {
    return Visit(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      visitDate: visitDate ?? this.visitDate,
      status: status ?? this.status,
      location: location ?? this.location,
      notes: notes ?? this.notes,
      activitiesDone: activitiesDone ?? this.activitiesDone,
      createdAt: createdAt ?? this.createdAt,
      isLocal: isLocal ?? this.isLocal,
    );
  }
}