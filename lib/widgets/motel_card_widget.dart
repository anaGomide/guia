import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/motel_model.dart';

class MotelCardWidget extends StatelessWidget {
  final Motel motel;
  final VoidCallback onFavoritePressed;

  const MotelCardWidget({
    Key? key,
    required this.motel,
    required this.onFavoritePressed,
  }) : super(key: key);

  void _showDetailsModal(BuildContext context, Suite suite) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down, size: 32),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                suite.nome,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Principais itens
              const Divider(),
              const Text(
                "principais itens",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16.0,
                runSpacing: 16.0,
                alignment: WrapAlignment.center,
                children: suite.categoriaItens.map((categoria) {
                  return Column(
                    spacing: 4,
                    children: [
                      Image.network(
                        categoria.icone,
                        width: 30,
                        height: 30,
                      ),
                      Text(
                        categoria.nome,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const Text(
                "tem também",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                suite.itens.map((item) => item.nome).join(", "),
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const double cardWidth = 300;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            spacing: 8,
            children: [
              ClipOval(
                child: Image.network(
                  motel.logo,
                  width: 25,
                  height: 25,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Column(
                  spacing: 0,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      motel.fantasia,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Color(0xFF333333),
                      ),
                    ),
                    Text(
                      utf8.decode(motel.bairro.runes.toList()),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  motel.qtdFavoritos > 0 ? Icons.favorite : Icons.favorite_border,
                  color: motel.qtdFavoritos > 0 ? Colors.red : Colors.grey,
                ),
                onPressed: onFavoritePressed,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 800,
          width: double.infinity,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: motel.suites.length,
            itemBuilder: (context, index) {
              final suite = motel.suites[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  width: cardWidth,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          color: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  child: Image.network(
                                    suite.fotos[0],
                                    height: 200,
                                    width: 300,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  utf8.decode(suite.nome.runes.toList()),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFF333333),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Card(
                          color: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ...suite.categoriaItens.take(4).map((categoria) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF8F9FB),
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: Center(
                                        child: Image.network(
                                          categoria.icone,
                                          width: 30,
                                          height: 30,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                if (suite.categoriaItens.length > 4)
                                  GestureDetector(
                                    onTap: () => _showDetailsModal(context, suite),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(
                                        " ver \n todos",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF666666),
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          children: suite.periodos.map((periodo) {
                            return PeriodCardWidget(periodo: periodo);
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class PeriodCardWidget extends StatelessWidget {
  final Periodo periodo;

  const PeriodCardWidget({Key? key, required this.periodo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final desconto = periodo.desconto != null ? periodo.desconto!.desconto : 0.0;
    final valorComDesconto = periodo.valorTotal - desconto;
    final percentualDesconto = desconto > 0 ? (desconto / periodo.valorTotal * 100).toStringAsFixed(0) : null;

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      periodo.tempoFormatado,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFF333333),
                      ),
                    ),
                    if (percentualDesconto != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F8F5),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF1ABC9C),
                          ),
                        ),
                        child: Text(
                          "$percentualDesconto% off",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF1ABC9C),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                if (percentualDesconto != null) ...[
                  Row(
                    children: [
                      // Preço riscado
                      Text(
                        "R\$ ${periodo.valorTotal.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Novo preço
                      Text(
                        "R\$ ${valorComDesconto.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  // Preço normal
                  Text(
                    "R\$ ${periodo.valorTotal.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFF333333),
                    ),
                  ),
                ],
              ],
            ),

            // Ícone de seta
            const Icon(
              Icons.chevron_right,
              color: Color(0xFFCCCCCC),
            ),
          ],
        ),
      ),
    );
  }
}
