// lib/models/event.dart
class Event {
  final String name;
  final String? image;
  final String address;
  final String description;
  final DateTime dateTime;
  final String contact;
  final String? link;

  Event({
    required this.name,
    this.image,
    required this.address,
    required this.description,
    required this.dateTime,
    required this.contact,
    this.link,
  });

  Map<String, String> toMap() {
    return {
      'name': name,
      'image': image ?? '',
      'address': address,
      'description': description,
      'dateTime': dateTime.millisecondsSinceEpoch.toString(),
      'contact': contact,
      'link': link ?? '',
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      name: json['name'] ?? '',
      image: json['image'],
      address: json['address'] ?? '',
      description: json['description'] ?? '',
      dateTime: json['dateTime'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(int.parse(json['dateTime']))
          : DateTime.now(),
      contact: json['contact'] ?? '',
      link: json['link'],
    );
  }

  // Added toString method for debugging
  @override
  String toString() {
    return 'Event{name: $name, image: $image, address: $address, description: $description, dateTime: $dateTime, contact: $contact, link: $link}';
  }
}