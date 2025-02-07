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
    final periodoComDesconto = suite.periodos.firstWhere((p) => p.desconto != null);
    final desconto = periodoComDesconto.desconto;

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
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start, // Alinhamento à esquerda
                  children: [
                    // Nome do motel com ícone de foguinho
                    Row(
                      children: [
                        const Icon(
                          Icons.local_fire_department,
                          color: Colors.orange,
                          size: 20,
                        ),
                        Text(
                          motel.fantasia,
                          style: const TextStyle(
                            color: Color(0xFF515151),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),

                    Text(
                      utf8.decode(motel.bairro.runes.toList()),
                      style: const TextStyle(
                        color: Color(0xFF626365),
                        fontSize: 14,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
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
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "${desconto.desconto.toStringAsFixed(0)}% de desconto",
                                  style: const TextStyle(
                                    color: Color(0xFF5D5E60),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    decoration: TextDecoration.underline, // Adiciona sublinhado
                                  ),
                                ),
                                Divider(color: Colors.white),
                                Text(
                                  "a partir de R\$ ${periodoComDesconto.valor.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    color: Color(0xFF515151),
                                    fontSize: 14,
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
