enum PrescriptionStatus { pending, approved, rejected, verified }

extension PrescriptionStatusExtension on PrescriptionStatus {
  bool get isVerified => this == PrescriptionStatus.verified || this == PrescriptionStatus.approved;
}

class Prescription {
  final int id;
  final String? image;
  final String? file;
  final PrescriptionStatus status;
  final String? pharmacistNotes;
  final DateTime? createdAt;

  Prescription({
    required this.id,
    this.image,
    this.file,
    required this.status,
    this.pharmacistNotes,
    this.createdAt,
  });

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      id: json['id'] ?? 0,
      image: json['image'],
      file: json['file'],
      status: PrescriptionStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => PrescriptionStatus.pending,
      ),
      pharmacistNotes: json['pharmacist_notes'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    );
  }

  String get statusLabel {
    switch (status) {
      case PrescriptionStatus.pending:
        return 'Pending Review';
      case PrescriptionStatus.approved:
        return 'Approved';
      case PrescriptionStatus.rejected:
        return 'Rejected';
      case PrescriptionStatus.verified:
        return 'Verified';
    }
  }

  String get fileName => 'prescription.jpg';
  DateTime get uploadedAt => createdAt ?? DateTime.now();
}
