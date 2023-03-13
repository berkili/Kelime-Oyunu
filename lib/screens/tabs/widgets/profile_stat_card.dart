import 'package:flutter/material.dart';

class StatCard extends StatefulWidget {
  final String winRate;
  final String loseRate;
  const StatCard({super.key, required this.winRate, required this.loseRate});

  @override
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard> {
  //TODO: Kazanılan ve kaybedilen yazıları büyütülecek.
  //TODO: Renkler ayarlanabilir.
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        boxShadow: null,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Expanded(
                          child: Text('Performans',
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text.rich(
                            softWrap: false,
                            overflow: TextOverflow.fade,
                            TextSpan(
                                text: 'Kazanılan: ',
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: widget.winRate,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black),
                                  ),
                                ]),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Text.rich(
                              softWrap: false,
                              overflow: TextOverflow.fade,
                              TextSpan(
                                  text: 'Kaybedilen: ',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey),
                                  children: <InlineSpan>[
                                    TextSpan(
                                      text: widget.loseRate,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black),
                                    )
                                  ])),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
