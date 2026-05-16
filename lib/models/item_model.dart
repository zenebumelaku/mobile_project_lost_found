class LostFoundItem {
  final String? id;
  final String title;
  final String description;
  final String location;
  final String contactInfo;
  final String type;
  final String status;

  LostFoundItem({
    this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.contactInfo,
    required this.type,
    required this.status,
  });

  factory LostFoundItem.fromJson(Map<String, dynamic> json) {
    return LostFoundItem(
      id: json['id']?.toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      contactInfo: json['contactInfo'] ?? json['contactinfo'] ?? '',
      type: json['type'] ?? 'Lost',
      status: json['status'] ?? 'Active',
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'title': title,
        'description': description,
        'location': location,
        'contactInfo': contactInfo,
        'type': type,
        'status': status,
      };

  LostFoundItem copyWith({
    String? id,
    String? title,
    String? description,
    String? location,
    String? contactInfo,
    String? type,
    String? status,
  }) {
    return LostFoundItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      contactInfo: contactInfo ?? this.contactInfo,
      type: type ?? this.type,
      status: status ?? this.status,
    );
  }
}
