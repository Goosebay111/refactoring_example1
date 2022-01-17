import 'package:intl/intl.dart';

String statement(invoice, plays) {
  int amountFor(aPerformance) {
    int _result = 0;
    switch (aPerformance['play']['type']) {
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
        throw 'unknown type: ${aPerformance['play']['type']}';
    }
    return _result;
  }

  final statementData = {};
  statementData['customer'] = invoice['customer'];
  statementData['performances'] = invoice['performances'].map((aPerformance) {
    var result = {};
    result.addAll(aPerformance);
    result['play'] = plays[aPerformance['playID']];
    result['amount'] = amountFor(result);
    return result;
  }).toList();

  return renderPlainText(statementData, plays);
}

renderPlainText(data, plays) {
  String result = '\nStatement for ${data['customers'].toString()}\n';

  usd(aNumber) {
    return NumberFormat.simpleCurrency().format(aNumber / 100);
  }

  volumeCreditsFor(aPerformance) {
    int _result = 0;
    _result += aPerformance['audience'] - 30 as int;
    if (aPerformance['play']['type'] == 'comedy') {
      _result += (aPerformance['audience'] / 5).floor() as int;
    }
    return _result;
  }

  totalAmount() {
    int _result = 0;
    for (final perf in data['performances']) {
      _result += perf['amount'] as int;
    }
    return _result;
  }

  totalVolumeCredits() {
    int volumeCredits = 0;
    for (final perf in data['performances']) {
      volumeCredits += volumeCreditsFor(perf);
    }
    return volumeCredits;
  }

  for (final perf in data['performances']) {
    result +=
        '  ${perf['play']['name']}: ${usd(perf['amount'] as int)} (${perf['audience']} seats)\n';
  }

  result += 'Amount owed is ${usd(totalAmount())}\n';
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
