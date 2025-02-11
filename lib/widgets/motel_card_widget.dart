import 'package:flutter/material.dart';

import '../models/motel_model.dart';

class MotelCardWidget extends StatefulWidget {
  final Motel motel;
  final VoidCallback onFavoritePressed;

  const MotelCardWidget({
    super.key,
    required this.motel,
    required this.onFavoritePressed,
  });

  @override
  _MotelCardWidgetState createState() => _MotelCardWidgetState();
}

class _MotelCardWidgetState extends State<MotelCardWidget> {
  bool isFavorited = false;

  void toggleFavorite() {
    setState(() {
      isFavorited = !isFavorited;
    });
    widget.onFavoritePressed();
  }

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
            spacing: 16,
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down, size: 32),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Text(
                suite.nome,
                style: const TextStyle(
                  fontSize: 20,
                  color: Color(0xFF333333),
                ),
                textAlign: TextAlign.center,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Divider(
                      color: Colors.grey.shade400,
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "principais itens",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey.shade400,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              Wrap(
                spacing: 16.0,
                runSpacing: 16.0,
                alignment: WrapAlignment.start,
                children: suite.categoriaItens.map((categoria) {
                  return SizedBox(
                    width: 150,
                    child: Column(
                      children: [
                        Row(
                          spacing: 8,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.network(
                              categoria.icone,
                              width: 30,
                              height: 30,
                            ),
                            Flexible(
                              child: Text(
                                categoria.nome,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF666666),
                                ),
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Divider(
                      color: Colors.grey.shade400, // Cor da linha
                      thickness: 1, // Espessura da linha
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0), // Espaço entre a linha e o texto
                    child: Text(
                      "tem também",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey.shade400,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              Text(
                suite.itens.map((item) => item.nome).join(", "),
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF666666),
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const double cardWidth = 350;
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
                  widget.motel.logo,
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
                      widget.motel.fantasia,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Color(0xFF333333),
                      ),
                    ),
                    Text(
                      widget.motel.bairro,
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
                  isFavorited ? Icons.favorite : Icons.favorite_border,
                  color: isFavorited ? Colors.red : Colors.grey,
                ),
                onPressed: toggleFavorite,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 800,
          width: double.infinity,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.motel.suites.length,
            itemBuilder: (context, index) {
              final suite = widget.motel.suites[index];
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
                                    width: cardWidth,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  suite.nome,
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
