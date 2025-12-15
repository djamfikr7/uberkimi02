import 'user.dart';

/// Ride model representing a ride request in the Uber Clone application.
/// This model is shared across all three applications (Rider, Driver, Admin).
class Ride {
  final String id;
  final String riderId;
  final String? driverId;
  final String pickupAddress;
  final String dropoffAddress;
  final double pickupLatitude;
  final double pickupLongitude;
  final double dropoffLatitude;
  final double dropoffLongitude;
  final double? estimatedFare;
  final double? actualFare;
  final String status; // 'requested', 'accepted', 'arrived', 'in_progress', 'completed', 'cancelled'
  final DateTime requestedAt;
  final DateTime? acceptedAt;
  final DateTime? arrivedAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;

  Ride({
    required this.id,
    required this.riderId,
    this.driverId,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.dropoffLatitude,
    required this.dropoffLongitude,
    this.estimatedFare,
    this.actualFare,
    required this.status,
    required this.requestedAt,
    this.acceptedAt,
    this.arrivedAt,
    this.startedAt,
    this.completedAt,
    this.cancelledAt,
  });

  /// Creates a Ride instance from a JSON object
  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      id: json['id'] as String,
      riderId: json['rider_id'] as String,
      driverId: json['driver_id'] as String?,
      pickupAddress: json['pickup_address'] as String,
      dropoffAddress: json['dropoff_address'] as String,
      pickupLatitude: (json['pickup_latitude'] as num).toDouble(),
      pickupLongitude: (json['pickup_longitude'] as num).toDouble(),
      dropoffLatitude: (json['dropoff_latitude'] as num).toDouble(),
      dropoffLongitude: (json['dropoff_longitude'] as num).toDouble(),
      estimatedFare: (json['estimated_fare'] as num?)?.toDouble(),
      actualFare: (json['actual_fare'] as num?)?.toDouble(),
      status: json['status'] as String,
      requestedAt: DateTime.parse(json['requested_at'] as String),
      acceptedAt: json['accepted_at'] != null
          ? DateTime.parse(json['accepted_at'] as String)
          : null,
      arrivedAt: json['arrived_at'] != null
          ? DateTime.parse(json['arrived_at'] as String)
          : null,
      startedAt: json['started_at'] != null
          ? DateTime.parse(json['started_at'] as String)
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      cancelledAt: json['cancelled_at'] != null
          ? DateTime.parse(json['cancelled_at'] as String)
          : null,
    );
  }

  /// Converts a Ride instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rider_id': riderId,
      'driver_id': driverId,
      'pickup_address': pickupAddress,
      'dropoff_address': dropoffAddress,
      'pickup_latitude': pickupLatitude,
      'pickup_longitude': pickupLongitude,
      'dropoff_latitude': dropoffLatitude,
      'dropoff_longitude': dropoffLongitude,
      'estimated_fare': estimatedFare,
      'actual_fare': actualFare,
      'status': status,
      'requested_at': requestedAt.toIso8601String(),
      'accepted_at': acceptedAt?.toIso8601String(),
      'arrived_at': arrivedAt?.toIso8601String(),
      'started_at': startedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'cancelled_at': cancelledAt?.toIso8601String(),
    };
  }

  /// Returns whether the ride is in progress
  bool get isInProgress =>
      status == 'accepted' ||
      status == 'arrived' ||
      status == 'in_progress';

  /// Returns whether the ride is completed
  bool get isCompleted => status == 'completed';

  /// Returns whether the ride is cancelled
  bool get isCancelled => status == 'cancelled';

  @override
  String toString() {
    return 'Ride(id: $id, riderId: $riderId, driverId: $driverId, status: $status)';
  }
}