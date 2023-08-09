class Event {

  //*Declarando as variaveis do applicativo  
  final int id;
  final String nome;
  final String descricao;

  //*Inicio do metodo construtor
  Event({
    required this.id,
    required this.nome,
    required this.descricao,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
    };
  }

  static Event fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      nome: map['nome'],
      descricao: map['descricao'],
    );
  }
}
