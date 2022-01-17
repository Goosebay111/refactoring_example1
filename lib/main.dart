import 'package:intl/intl.dart';

String statement(invoice, plays) {
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
    result +=
        '  ${playFor(perf)['name']}: ${usd(amountFor(perf))} (${perf['audience']} seats)\n';
  }

  appleSauce() {
    int totalAmount = 0;
    for (final perf in invoice['performances']) {
      totalAmount += amountFor(perf);
    }
    return totalAmount;
  }

  totalVolumeCredits() {
    int volumeCredits = 0;
    for (final perf in invoice['performances']) {
      volumeCredits += volumeCreditsFor(perf);
    }
    return volumeCredits;
  }

  result += 'Amount owed is ${usd(appleSauce())}\n';
  result += 'You earned ${totalVolumeCredits()} credits\n';
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
