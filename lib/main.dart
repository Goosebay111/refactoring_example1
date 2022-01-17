import 'package:intl/intl.dart';

String statement(invoice, plays) {
  int totalAmount = 0;
  int volumeCredits = 0;

  String result = '\nStatement for ${invoice['customers'].toString()}\n';

  usd(aNumber) => NumberFormat.simpleCurrency().format(aNumber / 100);

  Map<String, dynamic> playFor(aPerfomance) => plays[aPerfomance['playID']];

  int amountFor(aPerformance) {
    int _result = 0;

    switch (playFor(aPerformance)['type']) {
      case 'tragedy':
        _result = 40000;
        if (aPerformance['audience'] > 30) {
          _result += 1000 * (aPerformance['audience'] - 30) as int;
        }
        break;
      case 'comedy':
        _result = 30000;
        if (aPerformance['audience']! > 20) {
          _result += 10000 + 500 * (aPerformance['audience'] - 20) as int;
        }
        _result += 300 * aPerformance['audience'] as int;
        break;
      default:
        throw 'unknown type: ${playFor(aPerformance)['type']}';
    }
    return _result;
  }

  volumeCreditsFor(aPerformance) {
    int _result = 0;
    _result += aPerformance['audience'] - 30 as int;
    if (playFor(aPerformance)['type'] == 'comedy') {
      _result += (aPerformance['audience'] / 5).floor() as int;
    }
    return _result;
  }

  for (final perf in invoice['performances']) {
    volumeCredits += volumeCreditsFor(perf);

    // print line for this order
    result +=
        '  ${playFor(perf)['name']}: ${usd(amountFor(perf))} (${perf['audience']} seats)\n';
    totalAmount += amountFor(perf);
  }

  result += 'Amount owed is ${usd(totalAmount)}\n';
  result += 'You earned $volumeCredits credits\n';
  return result;
}

void main() {
  Map<String, Map<String, String>> plays = {
    'hamlet': {'name': 'Hamlet', 'type': 'tragedy'},
    'as-like': {'name': 'As You Like It', 'type': 'comedy'},
    'othello': {'name': 'Othello', 'type': 'tragedy'},
  };

  var invoices = {
    'customers': 'BigCo',
    'performances': [
      {'playID': 'hamlet', 'audience': 55},
      {'playID': 'as-like', 'audience': 35},
      {'playID': 'othello', 'audience': 40}
    ],
  };
  String info = statement(invoices, plays);
  print(info);
}
