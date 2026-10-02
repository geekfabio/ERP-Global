import '../../../../core/network/mock/mock_reference_data.dart';

/// Seed da instituição, no formato JSON do futuro backend.
Map<String, dynamic> institutionSeed() => {
  'id': MockRef.institutionId,
  'name': 'Colégio Global',
  'nif': '5001234567',
  'address': 'Luanda, Angola',
  'phone': '+244 923 456 789',
  'email': 'geral@colegio-global.ao',
  'brandColor': '#0B3D91',
  'logoUrl': null,
};

List<Map<String, dynamic>> campusSeed() => [
  {
    'id': MockRef.campusId,
    'institutionId': MockRef.institutionId,
    'name': 'Sede',
    'address': 'Luanda, Angola',
    'phone': '+244 923 456 789',
  },
];
