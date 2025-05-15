import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:currencyconverter/CurModel.dart';
import 'package:currencyconverter/CurrConv.dart';

class ShowData extends StatefulWidget {
  const ShowData({super.key});

  @override
  State<ShowData> createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  String baseCurrency = 'USD';
  String targetCurrency = 'INR';
  List types = model().map.keys.toList();
  TextEditingController B = TextEditingController();
  String Tvalue = "0";

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchConversionRate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Currency Converter",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/CurrConverter.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      currencyRow(
                        currencyValue: baseCurrency,
                        onChanged: (val) {
                          setState(() => baseCurrency = val!);
                          fetchConversionRate();
                        },
                        child: TextField(
                          controller: B,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: "Enter amount",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      currencyRow(
                        currencyValue: targetCurrency,
                        onChanged: (val) {
                          setState(() => targetCurrency = val!);
                          fetchConversionRate();
                        },
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            Tvalue,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      if (isLoading)
                        const CircularProgressIndicator()
                      else
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  double n =
                                      double.tryParse(B.text.trim()) ?? 0;
                                  Tvalue = (n * (cc?.exchangeRate ?? 1))
                                      .toStringAsFixed(2);
                                });
                              },
                              icon: const Icon(Icons.sync_alt),
                              label: const Text("Convert"),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                backgroundColor: Colors.teal,
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: () {
                                setState(() {
                                  B.clear();
                                  Tvalue = "0";
                                });
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text("Reset"),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                foregroundColor: Colors.teal,
                                side: const BorderSide(color: Colors.teal),
                              ),
                            ),
                          ],
                        )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget currencyRow({
    required String currencyValue,
    required ValueChanged<String?> onChanged,
    required Widget child,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: DropdownButtonFormField<String>(

 menuMaxHeight: 300,
            value: currencyValue,
            items: types.map<DropdownMenuItem<String>>((cur) {
              return DropdownMenuItem<String>(
                value: cur,
                child: Center(child: Text(cur,style: TextStyle(fontWeight: FontWeight.w900),),),
              );
            }).toList(),
            onChanged: onChanged,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(flex: 4, child: child),
      ],
    );
  }

  Future<void> fetchConversionRate() async {
    var url = Uri.parse(
        'https://currency-converter-api3.p.rapidapi.com/api/exchange-rates/convert?baseCurrency=$baseCurrency&targetCurrency=$targetCurrency');
    var response = await http.get(
      url,
      headers: {
        'x-rapidapi-key': '0c230d77f0msh3cc9c579e974ea4p19a8c1jsn16b5b82c7dcc',
        'x-rapidapi-host': 'currency-converter-api3.p.rapidapi.com'
      },
    );
    var map = jsonDecode(response.body);
    cc = CurrConv.fromJson(map);
    setState(() {});
  }
  CurrConv? cc;
}

