class Medication {
  final String id;
  final String patientId;
  final String name;
  final String dose;
  final String? instructions;
  final DateTime createdAt;

  const Medication({
    required this.id,
    required this.patientId,
    required this.name,
    required this.dose,
    this.instructions,
    required this.createdAt,
  });

  factory Medication.fromJson(Map<String, dynamic> json) => Medication(
        id: json['id'] as String,
        patientId: json['patient_id'] as String,
        name: json['name'] as String,
        dose: json['dose'] as String,
        instructions: json['instructions'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'patient_id': patientId,
        'name': name,
        'dose': dose,
        if (instructions != null) 'instructions': instructions,
        'created_at': createdAt.toIso8601String(),
      };

  Medication copyWith({
    String? name,
    String? dose,
    String? instructions,
  }) =>
      Medication(
        id: id,
        patientId: patientId,
        name: name ?? this.name,
        dose: dose ?? this.dose,
        instructions: instructions ?? this.instructions,
        createdAt: createdAt,
      );
}
