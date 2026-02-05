class Manutencao {
  final int? id;
  final int truckId;
  final String tipo; // 'Preventiva', 'Corretiva', 'Revisão'
  final String descricao;
  final double custo;
  final String data; // formato: YYYY-MM-DD
  final String? oficina;
  final int? quilometragem;
  final String? proximaManutencao; // Data da próxima manutenção

  Manutencao({
    this.id,
    required this.truckId,
    required this.tipo,
    required this.descricao,
    required this.custo,
    required this.data,
    this.oficina,
    this.quilometragem,
    this.proximaManutencao,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'truckId': truckId,
      'tipo': tipo,
      'descricao': descricao,
      'custo': custo,
      'data': data,
      'oficina': oficina,
      'quilometragem': quilometragem,
      'proximaManutencao': proximaManutencao,
    };
  }

  static Manutencao fromMap(Map<String, dynamic> map) {
    return Manutencao(
      id: map['id'],
      truckId: map['truckId'],
      tipo: map['tipo'],
      descricao: map['descricao'],
      custo: map['custo'],
      data: map['data'],
      oficina: map['oficina'],
      quilometragem: map['quilometragem'],
      proximaManutencao: map['proximaManutencao'],
    );
  }
}
