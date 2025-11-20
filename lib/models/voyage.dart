import 'dart:convert';

class Voyage {
  final String id;
  final String title;
  final String departurePort;
  final String arrivalPort;
  final String etdLocal;
  final String etaLocal;
  final String etbLocal;
  final bool fixedEta;
  final Map<String, String> upperLimits;

  Voyage({
    required this.id,
    required this.title,
    required this.departurePort,
    required this.arrivalPort,
    required this.etdLocal,
    required this.etaLocal,
    required this.etbLocal,
    required this.fixedEta,
    required this.upperLimits,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'departurePort': departurePort,
        'arrivalPort': arrivalPort,
        'etdLocal': etdLocal,
        'etaLocal': etaLocal,
        'etbLocal': etbLocal,
        'fixedEta': fixedEta,
        'upperLimits': upperLimits,
      };

  factory Voyage.fromJson(Map<String, dynamic> map) {
    final ul = <String, String>{};
    if (map['upperLimits'] is Map) {
      (map['upperLimits'] as Map).forEach((k, v) => ul[k.toString()] = v.toString());
    }
    return Voyage(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      departurePort: map['departurePort']?.toString() ?? '',
      arrivalPort: map['arrivalPort']?.toString() ?? '',
      etdLocal: map['etdLocal']?.toString() ?? '',
      etaLocal: map['etaLocal']?.toString() ?? '',
      etbLocal: map['etbLocal']?.toString() ?? '',
      fixedEta: map['fixedEta'] == true,
      upperLimits: ul,
    );
  }

  String toJsonString() => json.encode(toJson());

  factory Voyage.fromJsonString(String src) => Voyage.fromJson(json.decode(src) as Map<String, dynamic>);
}
