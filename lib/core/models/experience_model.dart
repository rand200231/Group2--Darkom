import 'package:cloud_firestore/cloud_firestore.dart';

class ExperienceModel {
  String docId; // Identifier for the document in Firebase
  String name; // Required
  String description; // Required
  String category; // Required
  String city; // Required
  List<String> photos; // List of photos
  double price; // Required
  int availableSeats; // Required
  int bookingSeats; // Required
  String date; // Required (format: YYYY-MM-DD)
  String time; // Required (format: HH:MM)
  GeoPoint location; // Required
  String address;
  String userId;
  DateTime? createdAt; // Required (set automatically)

  ExperienceModel({
    required this.name,
    required this.description,
    required this.category,
    required this.city,
    required this.price,
    required this.availableSeats,
    required this.bookingSeats,
    required this.date,
    required this.time,
    required this.location,
    required this.address,
    required this.userId,
    this.photos = const [],
    this.docId = '',
    this.createdAt,
  });

  // Convert model to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'city': city,
      'photos': photos,
      'price': price,
      'availableSeats': availableSeats,
      'bookingSeats': bookingSeats,
      'date': date,
      'time': time,
      'location': location,
      'address': address,
      'userId': userId,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      if (docId.isNotEmpty) 'docId': docId,
    };
  }

  // Create a model instance from map
  factory ExperienceModel.fromMap(Map<String, dynamic> data, String id) {
    return ExperienceModel(
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      city: data['city'] ?? '',
      photos: List<String>.from(data['photos'] ?? []),
      price: data['price']?.toDouble() ?? 0.0,
      availableSeats: data['availableSeats']?.toInt() ?? 0,
      bookingSeats: data['bookingSeats']?.toInt() ?? 0,
      date: data['date'] ?? '',
      time: data['time'] ?? '',
      location:
          (data['location'] is GeoPoint) ? data['location'] : GeoPoint(0, 0),
      address: data['address'] ?? '',
      userId: data['userId'] ?? '',
      docId: id,
      createdAt: data['createdAt']?.toDate(),
    );
  }

  @override
  String toString() {
    return 'ExperienceModel(docId: $docId, userId: $userId, name: $name, description: $description, category: $category, city: $city, pric: $price, availableSeats: $availableSeats, bookingSeats: $bookingSeats, date: $date, time: $time, location: (lat ${location.latitude} - long ${location.longitude}), address: $address, createdAt: $createdAt, photos: $photos)';
  }
}

// Generate temporary sample data
List<ExperienceModel> temporaryExperiencesData = [
  ExperienceModel(
    name: "Sunset Boat Tour",
    description: "Enjoy a beautiful sunset on a private boat tour.",
    category: "Adventure",
    city: "Ryiad",
    price: 99.99,
    availableSeats: 10,
    bookingSeats: 0,
    date: "2025-01-30",
    time: "17:00",
    location: GeoPoint(0, 0),
    address: "Miami Beach",
    userId: "",
    photos: [
      "https://example.com/photo1.jpg",
      "https://example.com/photo2.jpg",
    ],
  ),
  ExperienceModel(
    name: "Wine Tasting Experience",
    description: "Taste the finest wines from local vineyards.",
    category: "Food & Drink",
    city: "Ryiad",
    price: 59.99,
    availableSeats: 20,
    bookingSeats: 0,
    date: "2025-02-10",
    time: "18:00",
    location: GeoPoint(0, 0),
    address: "Miami Beach",
    userId: "",
    photos: [
      "https://example.com/photo3.jpg",
      "https://example.com/photo4.jpg",
    ],
  ),
  ExperienceModel(
    name: "Mountain Hiking Adventure",
    description: "Explore breathtaking mountain trails with a guide.",
    category: "Outdoor",
    city: "Ryiad",
    price: 49.99,
    availableSeats: 15,
    bookingSeats: 0,
    date: "2025-03-05",
    time: "08:00",
    location: GeoPoint(0, 0),
    address: "Miami Beach",
    userId: "",
    photos: [
      "https://example.com/photo5.jpg",
      "https://example.com/photo6.jpg",
    ],
  ),
];
