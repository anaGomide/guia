class Motel {
  final String fantasia;
  final String logo;
  final String bairro;
  final double distancia;
  final int qtdFavoritos;
  final List<Suite> suites;

  Motel({
    required this.fantasia,
    required this.logo,
    required this.bairro,
    required this.distancia,
    required this.qtdFavoritos,
    required this.suites,
  });

  factory Motel.fromJson(Map<String, dynamic> json) {
    return Motel(
      fantasia: json['fantasia'],
      logo: json['logo'],
      bairro: json['bairro'],
      distancia: json['distancia'].toDouble(),
      qtdFavoritos: json['qtdFavoritos'],
      suites: (json['suites'] as List).map((suite) => Suite.fromJson(suite)).toList(),
    );
  }
}

class Suite {
  final String nome;
  final int quantidade;
  final bool exibirQtdDisponiveis;
  final List<String> fotos;
  final List<Item> itens;
  final List<CategoriaItem> categoriaItens;
  final List<Periodo> periodos;

  Suite({
    required this.nome,
    required this.quantidade,
    required this.exibirQtdDisponiveis,
    required this.fotos,
    required this.itens,
    required this.categoriaItens,
    required this.periodos,
  });

  factory Suite.fromJson(Map<String, dynamic> json) {
    return Suite(
      nome: json['nome'],
      quantidade: json['qtd'],
      exibirQtdDisponiveis: json['exibirQtdDisponiveis'],
      fotos: List<String>.from(json['fotos']),
      itens: (json['itens'] as List).map((item) => Item.fromJson(item)).toList(),
      categoriaItens: (json['categoriaItens'] as List).map((categoria) => CategoriaItem.fromJson(categoria)).toList(),
      periodos: (json['periodos'] as List).map((periodo) => Periodo.fromJson(periodo)).toList(),
    );
  }
}

class Item {
  final String nome;
  Item({required this.nome});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      nome: json['nome'],
    );
  }
}

class CategoriaItem {
  final String nome;
  final String icone;

  CategoriaItem({
    required this.nome,
    required this.icone,
  });

  factory CategoriaItem.fromJson(Map<String, dynamic> json) {
    return CategoriaItem(
      nome: json['nome'],
      icone: json['icone'],
    );
  }
}

class Periodo {
  final String tempoFormatado;
  final String tempo;
  final double valor;
  final double valorTotal;
  final bool temCortesia;
  final Desconto? desconto;

  Periodo({
    required this.tempoFormatado,
    required this.tempo,
    required this.valor,
    required this.valorTotal,
    required this.temCortesia,
    this.desconto,
  });

  factory Periodo.fromJson(Map<String, dynamic> json) {
    return Periodo(
      tempoFormatado: json['tempoFormatado'],
      tempo: json['tempo'],
      valor: json['valor'].toDouble(),
      valorTotal: json['valorTotal'].toDouble(),
      temCortesia: json['temCortesia'],
      desconto: json['desconto'] != null ? Desconto.fromJson(json['desconto']) : null,
    );
  }
}

class Desconto {
  final double desconto;

  Desconto({required this.desconto});

  factory Desconto.fromJson(Map<String, dynamic> json) {
    return Desconto(
      desconto: json['desconto'].toDouble(),
    );
  }
}
