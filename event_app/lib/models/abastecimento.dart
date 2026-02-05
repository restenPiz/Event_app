class Abastecimento {
  final int? id;
  final int truckId;
  final double litros;
  final double precoLitro;
  final double custoTotal;
  final String data; // formato: YYYY-MM-DD
  final int? quilometragem;
  final String? posto;
  final String? tipoCombustivel; // 'Diesel', 'Gasolina', etc.

  Abastecimento({
    this.id,
    required this.truckId,
    required this.litros,
    required this.precoLitro,
    required this.custoTotal,
    required this.data,
    this.quilometragem,
    this.posto,
    this.tipoCombustivel,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'truckId': truckId,
      'litros': litros,
      'precoLitro': precoLitro,
      'custoTotal': custoTotal,
      'data': data,
      'quilometragem': quilometragem,
      'posto': posto,
      'tipoCombustivel': tipoCombustivel,
    };
  }

  static Abastecimento fromMap(Map<String, dynamic> map) {
    return Abastecimento(
      id: map['id'],
      truckId: map['truckId'],
      litros: map['litros'],
      precoLitro: map['precoLitro'],
      custoTotal: map['custoTotal'],
      data: map['data'],
      quilometragem: map['quilometragem'],
      posto: map['posto'],
      tipoCombustivel: map['tipoCombustivel'],
    );
  }

  // Calcular consumo médio (km/litro)
  double? calcularConsumo(int? kmAnterior) {
    if (kmAnterior != null && quilometragem != null) {
      final kmPercorridos = quilometragem! - kmAnterior;
      return kmPercorridos / litros;
    }
    return null;
  }
}
