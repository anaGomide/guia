import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class _CustomAppBarState extends State<CustomAppBar> {
  // Variável para controlar a opção selecionada
  bool isIrAgoraSelected = true;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFD11521), // Vermelho #d11521
      elevation: 0,
      title: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  // Botão "ir agora"
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isIrAgoraSelected = true;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isIrAgoraSelected ? Colors.white : const Color(0xFFB9000C), // Vermelho escuro
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(20),
                            bottomLeft: const Radius.circular(20),
                            topRight: isIrAgoraSelected ? const Radius.circular(20) : Radius.zero,
                            bottomRight: isIrAgoraSelected ? const Radius.circular(20) : Radius.zero,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.flash_on, color: isIrAgoraSelected ? Colors.red : Colors.white, size: 20),
                            const SizedBox(width: 5),
                            Text(
                              "ir agora",
                              style: TextStyle(
                                color: isIrAgoraSelected ? Colors.black : Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Botão "ir outro dia"
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isIrAgoraSelected = false;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isIrAgoraSelected
                              ? const Color(0xFFB9000C) // Vermelho escuro
                              : Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: const Radius.circular(20),
                            bottomRight: const Radius.circular(20),
                            topLeft: !isIrAgoraSelected ? const Radius.circular(20) : Radius.zero,
                            bottomLeft: !isIrAgoraSelected ? const Radius.circular(20) : Radius.zero,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.calendar_today, color: isIrAgoraSelected ? Colors.white : Colors.red, size: 18),
                            const SizedBox(width: 5),
                            Text(
                              "ir outro dia",
                              style: TextStyle(
                                color: isIrAgoraSelected ? Colors.white : Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "brasília",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const Icon(Icons.arrow_drop_down, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
