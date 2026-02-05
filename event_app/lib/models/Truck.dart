class Truck {
  final int? id;
  final String matricula;
  final String marca;
  final String modelo;
  final int ano;
  final String motorista;
  final String status; // 'Ativo', 'Manutenção', 'Inativo'
  final double quilometragem;
  final String? observacoes;
  final String? fotoPath; // Caminho da foto do camião

  Truck({
    this.id,
    required this.matricula,
    required this.marca,
    required this.modelo,
    required this.ano,
    required this.motorista,
    required this.status,
    required this.quilometragem,
    this.observacoes,
    this.fotoPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'matricula': matricula,
      'marca': marca,
      'modelo': modelo,
      'ano': ano,
      'motorista': motorista,
      'status': status,
      'quilometragem': quilometragem,
      'observacoes': observacoes,
      'fotoPath': fotoPath,
    };
  }

  static Truck fromMap(Map<String, dynamic> map) {
    return Truck(
      id: map['id'],
      matricula: map['matricula'],
      marca: map['marca'],
      modelo: map['modelo'],
      ano: map['ano'],
      motorista: map['motorista'],
      status: map['status'],
      quilometragem: map['quilometragem'],
      observacoes: map['observacoes'],
      fotoPath: map['fotoPath'],
    );
  }
}
