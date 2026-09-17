enum PrescriptionStatus { pending, approved, rejected }

class Prescription {
  final int id;
  final String? image;
  final String? file;
  final PrescriptionStatus status;
  final String? pharmacistNotes;
  final String? fileName;
  final DateTime? uploadedAt;

  Prescription({
    required this.id,
    this.image,
    this.file,
    required this.status,
    this.pharmacistNotes,
    this.fileName,
    this.uploadedAt,
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
      fileName: json['file_name'] ?? json['image']?.split('/').last,
      uploadedAt: json['uploaded_at'] != null ? DateTime.parse(json['uploaded_at']) : null,
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
    }
  }
}
