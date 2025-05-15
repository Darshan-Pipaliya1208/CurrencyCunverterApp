    class CurrConv {
    CurrConv({
        required this.baseCurrencyName,
        required this.baseCurrencyCode,
        required this.targetCurrencyCode,
        required this.targetCurrencyName,
        required this.exchangeRate,
    });

    final dynamic baseCurrencyName;
    final dynamic baseCurrencyCode;
    final dynamic targetCurrencyCode;
    final dynamic targetCurrencyName;
    final dynamic exchangeRate;

    factory CurrConv.fromJson(Map<String, dynamic> json){ 
        return CurrConv(
            baseCurrencyName: json["baseCurrencyName"],
            baseCurrencyCode: json["baseCurrencyCode"],
            targetCurrencyCode: json["targetCurrencyCode"],
            targetCurrencyName: json["targetCurrencyName"],
            exchangeRate: json["exchangeRate"],
        );
    }

}
