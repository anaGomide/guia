import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../providers/motel_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/motel_card_widget.dart';
import '../widgets/promo_card_widget.dart';

class MotelListScreen extends StatefulWidget {
  const MotelListScreen({super.key});

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
    setState(() => _isLoading = true);

    try {
      final provider = Provider.of<MotelProvider>(context, listen: false);
      await provider.loadMoteis();

      setState(() {
        suitesComDesconto = provider.getTodasSuitesComDesconto();
        moteisFiltrados = provider.moteis;
        moteisComPromocoes = provider.moteisComPromocoes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void openFiltersModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            bool isAnyFilterSelected = selectedPeriods.isNotEmpty || selectedItems.isNotEmpty || onlyDiscounted || onlyAvailable;

            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 60.0), // Espaço para o botão fixo
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        spacing: 16, // Define espaçamento entre os elementos
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Cabeçalho do modal
                          Row(
                            spacing: 100,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.keyboard_arrow_down, size: 32),
                                onPressed: () => Navigator.pop(context),
                              ),
                              const Text(
                                'Filtros',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),

                          // Faixa de Preço
                          buildFilterContainer(
                            title: "Faixa de preço",
                            child: Column(
                              spacing: 8,
                              children: [
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
                                    setModalState(() {
                                      priceRange = values;
                                    });
                                  },
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('R\$ ${priceRange.start.round()}'),
                                    Text('R\$ ${priceRange.end.round()}'),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Períodos
                          buildFilterContainer(
                            title: "Períodos",
                            child: Wrap(
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
                                  GestureDetector(
                                    onTap: () {
                                      setModalState(() {
                                        if (selectedPeriods.contains(period)) {
                                          selectedPeriods.remove(period);
                                        } else {
                                          selectedPeriods.add(period);
                                        }
                                      });
                                    },
                                    child: buildSelectableItem(
                                      text: period,
                                      isSelected: selectedPeriods.contains(period),
                                      context: context,
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          // Opções de Desconto e Disponibilidade
                          buildFilterContainer(
                            title: "Opções",
                            child: Column(
                              spacing: 8,
                              children: [
                                SwitchListTile(
                                  title: const Text('Somente suítes com desconto', style: TextStyle(color: Color(0xFF515151))),
                                  value: onlyDiscounted,
                                  onChanged: (value) {
                                    setModalState(() => onlyDiscounted = value);
                                  },
                                ),
                                SwitchListTile(
                                  title: const Text('Somente suítes disponíveis', style: TextStyle(color: Color(0xFF515151))),
                                  value: onlyAvailable,
                                  onChanged: (value) {
                                    setModalState(() => onlyAvailable = value);
                                  },
                                ),
                              ],
                            ),
                          ),

                          // Itens da Suíte
                          buildFilterContainer(
                            title: "Itens da suíte",
                            child: Wrap(
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
                                  GestureDetector(
                                    onTap: () {
                                      setModalState(() {
                                        if (selectedItems.contains(item)) {
                                          selectedItems.remove(item);
                                        } else {
                                          selectedItems.add(item);
                                        }
                                      });
                                    },
                                    child: buildSelectableItem(
                                      text: item,
                                      isSelected: selectedItems.contains(item),
                                      context: context,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Botão fixo no rodapé
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: isAnyFilterSelected
                        ? () {
                            Navigator.pop(context);
                            applyFilters();
                          }
                        : null,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      color: isAnyFilterSelected ? Theme.of(context).primaryColor : Colors.grey.shade500,
                      alignment: Alignment.center,
                      child: const Text(
                        'VERIFICAR DISPONIBILIDADE',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

// Widget para criar containers brancos com título
  Widget buildFilterContainer({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          child,
        ],
      ),
    );
  }

// Widget para botões de seleção personalizados
  Widget buildSelectableItem({required String text, required bool isSelected, required BuildContext context}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Theme.of(context).primaryColor : Colors.white,
        border: Border.all(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade400,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: isSelected ? Colors.white : const Color(0xFF515151),
        ),
      ),
    );
  }

  void applyFilters() {
    final provider = Provider.of<MotelProvider>(context, listen: false);

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
                              height: 200,
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
                                      border: Border.all(color: const Color(0xFFCCCCCC)),
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
                                child: Text(
                                  'tentar novamente',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
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
                            onFavoritePressed: () {
                              // print('Favoritou ${motel.fantasia}');
                            },
                          );
                        },
                      ),
              ),
            ),
    );
  }
}
