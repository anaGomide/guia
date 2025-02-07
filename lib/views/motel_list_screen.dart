import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/motel_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/promo_card_widget.dart';

class MotelListScreen extends StatefulWidget {
  const MotelListScreen({Key? key}) : super(key: key);

  @override
  State<MotelListScreen> createState() => _MotelListScreenState();
}

class _MotelListScreenState extends State<MotelListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<MotelProvider>(context, listen: false).loadMoteis());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MotelProvider>(context);

    return Scaffold(
      appBar: const CustomAppBar(),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                // Card de Promoções
                if (provider.moteisComPromocoes.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: provider.moteisComPromocoes.map((motel) {
                            final suiteComDesconto = motel.suites.firstWhere((suite) {
                              return suite.periodos.any((periodo) => periodo.desconto != null);
                            });
                            return PromoCardWidget(motel: motel, suite: suiteComDesconto);
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                // Lista Geral de Motéis
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.moteis.length,
                  itemBuilder: (context, index) {
                    final motel = provider.moteis[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Image.network(motel.logo, width: 50, height: 50),
                            title: Text(motel.fantasia),
                            subtitle: Text(motel.bairro),
                          ),
                          // Lista horizontal de suítes com altura ajustável
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: motel.suites.map((suite) {
                                return Container(
                                  margin: const EdgeInsets.all(8.0),
                                  width: 150,
                                  child: Column(
                                    children: [
                                      AspectRatio(
                                        aspectRatio: 16 / 9,
                                        child: Image.network(
                                          suite.fotos[0],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Text(
                                        suite.nome,
                                        style: const TextStyle(fontSize: 14),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
