import 'package:intl/intl.dart';

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

String statement(invoice, plays) {
  int totalAmount = 0;
  int volumeCredits = 0;
  //int modifier = 0;
  String result = '\nStatement for ${invoice['customers'].toString()}\n';
  NumberFormat format = NumberFormat.simpleCurrency();

  playFor(aPerfomance) {
    return plays[aPerfomance['playID']];
  }

  for (final perf in invoice['performances']) {
    //final play = playFor(perf);
    final int thisAmount = amountFor(perf, playFor(perf));

    // add volume credits
    volumeCredits += perf['audience'] - 30 as int;

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

int amountFor(aPerformance, play) {
  int result = 0;

  switch (play['type']) {
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
      throw 'unknown type: ${play['type']}';
  }
  return result;
}
