class Event{

  //*Declarando as variaveis
  int id;
  String nome;
  String descricao;

  //*Inicio do metodo construtor
  Event({this.id, this.nome, this.descricao});

  Map<String, dynamic> toMap(){
    return{
      'id':id,
      'nome':nome,
      'descricao':descricao,
    };
  }

  factory Event.fromMap(Map<String, dynamic>map){
    return Event(
      id:map['id'],
      nome:map['nome'],
      descricao:map['descricao'],
    );
  }

}