import 'package:intl/intl.dart';

String statement(invoice, plays) {
  int totalAmount = 0;
  int volumeCredits = 0;

  String result = '\nStatement for ${invoice['customers'].toString()}\n';
  final NumberFormat format = NumberFormat.simpleCurrency();

  Map<String, dynamic> playFor(aPerfomance) {
    return plays[aPerfomance['playID']];
  }

  int amountFor(aPerformance) {
    int result = 0;

    switch (playFor(aPerformance)['type']) {
      case 'tragedy':
        result = 40000;
        if (aPerformance['audience'] > 30) {
          result += 1000 * (aPerformance['audience'] - 30) as int;
        }
        break;
      case 'comedy':
        result = 30000;
        if (aPerformance['audience']! > 20) {
          result += 10000 + 500 * (aPerformance['audience'] - 20) as int;
        }
        result += 300 * aPerformance['audience'] as int;
        break;
      default:
        throw 'unknown type: ${playFor(aPerformance)['type']}';
    }
    return result;
  }

  for (final perf in invoice['performances']) {
    int thisAmount = amountFor(perf);

    // add volume credits
    volumeCredits += perf['audience'] - 30 as int;

    // var play = playFor(perf);

    if (playFor(perf)['type'] == 'comedy') {
      volumeCredits += (perf['audience'] / 5).floor() as int;
    }

    // print line for this order
    result +=
        '  ${playFor(perf)['name']}: ${format.format(thisAmount / 100)} (${perf['audience']} seats)\n';
    totalAmount += thisAmount;
  }

  result += 'Amount owed is ${format.format(totalAmount / 100)}\n';
  result += 'You earned ${volumeCredits} credits\n';
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
