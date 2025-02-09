import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../providers/motel_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/motel_card_widget.dart';
import '../widgets/promo_card_widget.dart';

class MotelListScreen extends StatefulWidget {
  const MotelListScreen({Key? key}) : super(key: key);

  @override
  State<MotelListScreen> createState() => _MotelListScreenState();
}

class _MotelListScreenState extends State<MotelListScreen> {
  bool _isLoading = true;
  RangeValues priceRange = const RangeValues(30, 2030);
  List<String> selectedPeriods = [];
  List<String> selectedItems = [];
  bool onlyDiscounted = false;
  bool onlyAvailable = false;
  final PageController _promoPageController = PageController();
  List suitesComDesconto = [];
  List moteisFiltrados = [];
  List moteisComPromocoes = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadRequiredData());
  }

  @override
  void dispose() {
    _promoPageController.dispose();
    super.dispose();
  }

  Future<void> _loadRequiredData() async {
    setState(() => _isLoading = true); // Mostra o loading antes de carregar

    try {
      final provider = Provider.of<MotelProvider>(context, listen: false);
      await provider.loadMoteis(); // Carrega os dados do provider

      setState(() {
        suitesComDesconto = provider.getTodasSuitesComDesconto();
        moteisFiltrados = provider.moteis;
        moteisComPromocoes = provider.moteisComPromocoes;
        _isLoading = false; // Concluiu o carregamento, remove o loading
      });
    } catch (e) {
      setState(() => _isLoading = false); // Se falhar, também remove o loading
      print("Erro ao carregar motéis: $e"); // Debugging
    }
  }

  void openFiltersModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Filtros', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    // Faixa de preço
                    const Text('Faixa de preço', style: TextStyle(fontSize: 16)),
                    RangeSlider(
                      values: priceRange,
                      min: 30,
                      max: 2030,
                      divisions: 200,
                      labels: RangeLabels(
                        'R\$ ${priceRange.start.round()}',
                        'R\$ ${priceRange.end.round()}',
                      ),
                      onChanged: (values) {
                        setModalState(() => priceRange = values);
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('R\$ ${priceRange.start.round()}'),
                        Text('R\$ ${priceRange.end.round()}'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Períodos
                    const Text('Períodos', style: TextStyle(fontSize: 16)),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: [
                        for (var period in [
                          "1 hora",
                          "2 horas",
                          "3 horas",
                          "4 horas",
                          "5 horas",
                          "6 horas",
                          "7 horas",
                          "8 horas",
                          "9 horas",
                          "10 horas",
                          "11 horas",
                          "12 horas",
                          "perdia",
                          "pernoite"
                        ])
                          FilterChip(
                            label: Text(period),
                            selected: selectedPeriods.contains(period),
                            onSelected: (bool selected) {
                              setModalState(() {
                                if (selected) {
                                  selectedPeriods.add(period);
                                } else {
                                  selectedPeriods.remove(period);
                                }
                              });
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Opções de desconto e disponibilidade
                    SwitchListTile(
                      title: const Text('Somente suítes com desconto'),
                      value: onlyDiscounted,
                      onChanged: (value) {
                        setModalState(() => onlyDiscounted = value);
                      },
                    ),
                    SwitchListTile(
                      title: const Text('Somente suítes disponíveis'),
                      value: onlyAvailable,
                      onChanged: (value) {
                        setModalState(() => onlyAvailable = value);
                      },
                    ),
                    const SizedBox(height: 16),
                    // Itens da suíte
                    const Text('Itens da suíte', style: TextStyle(fontSize: 16)),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: [
                        for (var item in [
                          "hidro",
                          "piscina",
                          "sauna",
                          "ofurô",
                          "decoração erótica",
                          "decoração temática",
                          "cadeira erótica",
                          "pista de dança",
                          "garagem privativa",
                          "frigobar",
                          "internet wi-fi",
                          "suíte para festas",
                          "suíte com acessibilidade"
                        ])
                          FilterChip(
                            label: Text(item),
                            selected: selectedItems.contains(item),
                            onSelected: (bool selected) {
                              setModalState(() {
                                if (selected) {
                                  selectedItems.add(item);
                                } else {
                                  selectedItems.remove(item);
                                }
                              });
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        applyFilters();
                      },
                      child: const Text('Aplicar Filtros'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void applyFilters() {
    final provider = Provider.of<MotelProvider>(context, listen: false);

    print("Chamando applyFilters...");
    provider.filterMoteis(
      priceRange: priceRange,
      periods: selectedPeriods,
      items: selectedItems,
      onlyDiscounted: onlyDiscounted,
      onlyAvailable: onlyAvailable,
    );

    setState(() {
      moteisFiltrados = provider.moteis;
    });
  }

  int getTotalFiltersCount() {
    int count = 0;

    // Verifica os períodos selecionados
    if (selectedPeriods.isNotEmpty) count += selectedPeriods.length;

    // Verifica os itens selecionados
    if (selectedItems.isNotEmpty) count += selectedItems.length;

    // Verifica as opções de "Com desconto" e "Disponíveis"
    if (onlyDiscounted) count++;
    if (onlyAvailable) count++;

    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  // Promoções
                  if (suitesComDesconto.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 200, // Altura do carrossel
                              child: PageView.builder(
                                controller: _promoPageController,
                                itemCount: suitesComDesconto.length,
                                itemBuilder: (context, index) {
                                  final suite = suitesComDesconto[index];
                                  final motel = moteisComPromocoes.firstWhere((m) => m.suites.any((s) => s == suite));
                                  return PromoCardWidget(motel: motel, suite: suite);
                                },
                              ),
                            ),
                            const SizedBox(height: 8),
                            SmoothPageIndicator(
                              controller: _promoPageController,
                              count: suitesComDesconto.length,
                              effect: ExpandingDotsEffect(
                                expansionFactor: 2,
                                dotHeight: 8,
                                dotWidth: 8,
                                activeDotColor: const Color.fromARGB(255, 109, 109, 109),
                                dotColor: const Color.fromARGB(255, 185, 185, 185),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Barra de Filtros fixa no topo
                  SliverAppBar(
                    pinned: true,
                    backgroundColor: Colors.white,
                    elevation: 1,
                    toolbarHeight: 50,
                    flexibleSpace: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          spacing: 6,
                          children: [
                            // Botão Filtros com ícone
                            GestureDetector(
                              onTap: () => openFiltersModal(context),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: const Color(0xFFCCCCCC)), // Borda cinza
                                    ),
                                    child: Row(
                                      spacing: 4,
                                      children: [
                                        const Icon(Icons.filter_alt_outlined, size: 16, color: Color(0xFF515151)),
                                        const Text(
                                          'Filtros',
                                          style: TextStyle(fontSize: 14, color: Color(0xFF515151)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Bolinha de notificação com o contador
                                  if (getTotalFiltersCount() > 0)
                                    Positioned(
                                      left: 0,
                                      top: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(4.0),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          '${getTotalFiltersCount()}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            // Filtro "Com desconto"
                            FilterChip(
                              label: const Text('Com desconto'),
                              labelStyle: TextStyle(
                                fontSize: 14,
                                color: onlyDiscounted ? Colors.white : const Color(0xFF515151),
                              ),
                              backgroundColor: Colors.white,
                              selectedColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: const Color(0xFFCCCCCC)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              selected: onlyDiscounted,
                              onSelected: (selected) {
                                setState(() {
                                  onlyDiscounted = selected;
                                  applyFilters();
                                });
                              },
                            ),
                            // Filtro "Disponíveis"
                            FilterChip(
                              label: const Text('Disponíveis'),
                              labelStyle: TextStyle(
                                fontSize: 14,
                                color: onlyAvailable ? Colors.white : const Color(0xFF515151),
                              ),
                              backgroundColor: Colors.white,
                              selectedColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: const Color(0xFFCCCCCC)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              selected: onlyAvailable,
                              onSelected: (selected) {
                                setState(() {
                                  onlyAvailable = selected;
                                  applyFilters();
                                });
                              },
                            ),
                            // Filtros adicionais
                            ...["hidro", "piscina", "sauna", "ofurô", "decoração temática"].map(
                              (item) => Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: FilterChip(
                                  label: Text(item),
                                  labelStyle: TextStyle(
                                    fontSize: 14,
                                    color: selectedItems.contains(item) ? Colors.white : const Color(0xFF515151),
                                  ),
                                  backgroundColor: Colors.white,
                                  selectedColor: Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: const Color(0xFFCCCCCC)),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  selected: selectedItems.contains(item),
                                  onSelected: (selected) {
                                    setState(() {
                                      if (selected) {
                                        selectedItems.add(item);
                                      } else {
                                        selectedItems.remove(item);
                                      }
                                      applyFilters();
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ];
              },
              body: Container(
                color: const Color(0xFFF8F9FB),
                child: moteisFiltrados.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Column(
                            spacing: 8,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'poxa 😢',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'Infelizmente não encontramos nenhum motel com reservas disponíveis na sua região.\n'
                                'Você pode buscar em outras regiões próximas no menu acima',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF626365),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final provider = Provider.of<MotelProvider>(context, listen: false);
                                  setState(() {
                                    selectedPeriods.clear();
                                    selectedItems.clear();
                                    onlyDiscounted = false;
                                    onlyAvailable = false;
                                  });
                                  await provider.loadMoteis();
                                  setState(() {
                                    moteisFiltrados = provider.moteis;
                                  });
                                },
                                child: const Text(
                                  'tentar novamente',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: moteisFiltrados.length,
                        itemBuilder: (context, index) {
                          final motel = moteisFiltrados[index];
                          return MotelCardWidget(
                            motel: motel,
                            //suite: motel.suites.isNotEmpty ? motel.suites[0] : null,
                            onFavoritePressed: () {
                              print('Favoritou ${motel.fantasia}');
                            },
                          );
                        },
                      ),
              ),
            ),
    );
  }
}
