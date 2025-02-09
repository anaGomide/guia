import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/motel_model.dart';

class PromoCardWidget extends StatelessWidget {
  final Motel motel;
  final Suite suite;

  const PromoCardWidget({
    Key? key,
    required this.motel,
    required this.suite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final desconto = suite.periodos.firstWhere((periodo) => periodo.desconto != null).desconto?.desconto;

    final preco = suite.periodos.firstWhere((periodo) => periodo.desconto != null).valor;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      color: Colors.white,
      child: IntrinsicWidth(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem da suíte
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
                child: Image.network(
                  suite.fotos.first,
                  width: 170,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  spacing: 2,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.local_fire_department,
                          color: Colors.orange,
                          size: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              motel.fantasia,
                              style: const TextStyle(
                                color: Color(0xFF515151),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              utf8.decode(motel.bairro.runes.toList()),
                              style: const TextStyle(
                                color: Color(0xFF626365),
                                fontSize: 12,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (desconto != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F9FB), // Fundo levemente mais escuro
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "${desconto.toStringAsFixed(0)}% de desconto",
                                  style: const TextStyle(
                                    color: Color(0xFF5D5E60),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    decoration: TextDecoration.underline, // Adiciona sublinhado
                                  ),
                                ),
                                Divider(color: Colors.white),
                                Text(
                                  "a partir de R\$ ${preco.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    color: Color(0xFF515151),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Botão de reservar (cor verde #1ABA8E)
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1ABA8E),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              minimumSize: const Size.fromHeight(36),
                            ),
                            child: const Text(
                              "reservar",
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
