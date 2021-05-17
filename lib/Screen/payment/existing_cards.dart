import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:shapeyou/provider/order_provider.dart';
import 'package:shapeyou/services/payment/stripe_payment_service.dart';
import 'package:stripe_payment/stripe_payment.dart';

class ExistingCardsPage extends StatefulWidget {
  static const String id = 'existing-cards';

  ExistingCardsPage({Key key}) : super(key: key);

  @override
  ExistingCardsPageState createState() => ExistingCardsPageState();
}

class ExistingCardsPageState extends State<ExistingCardsPage> {
  //TODO: list from firestore
  List cards = [
    {
      'cardNumber': '4242424242424242',
      'expiryDate': '04/24',
      'cardHolderName': 'Jam Dev',
      'cvvCode': '424',
      'showBackView': false,
    },
    {
      'cardNumber': '5200828282828210',
      'expiryDate': '04/24',
      'cardHolderName': 'Jam Dev1',
      'cvvCode': '424',
      'showBackView': false,
    },
    {
      'cardNumber': '5200828282828210',
      'expiryDate': '04/24',
      'cardHolderName': 'Jam Dev 2',
      'cvvCode': '424',
      'showBackView': false,
    },
  ];

  Future<StripeTransactionResponse> payViaExistingCard(
      BuildContext context, card, amount) async {
    await EasyLoading.show(status: 'Please wait...');
    var expiryArr = card['expiryDate'].split('/');
    CreditCard stripeCard = CreditCard(
      number: card['cardNumber'],
      expMonth: int.parse(expiryArr[0]),
      expYear: int.parse(expiryArr[1]),
    );
    var response = await StripeService.payViaExistingCard(
        amount: '${amount}00',
        //we need to bring amount from cart total
        currency: 'INR',
        //will change this to INR as I am not allowed to use USD
        card: stripeCard);
    await EasyLoading.dismiss();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
          content: Text(response.message),
          duration: new Duration(milliseconds: 1200),
        ))
        .closed
        .then((_) {
      Navigator.pop(context);
      Navigator.pop(context);
    });

    return response;
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose existing card'),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 10),
        child: ListView.builder(
          itemCount: cards.length,
          itemBuilder: (BuildContext context, int index) {
            var card = cards[index];
            return InkWell(
              onTap: () {
                payViaExistingCard(context, card, orderProvider.amount)
                    .then((response) {
                  if (response.success == true) {
                    orderProvider.paymentStatus(response.success);
                  }
                });
              },
              child: CreditCardWidget(
                cardNumber: card['cardNumber'],
                expiryDate: card['expiryDate'],
                cardHolderName: card['cardHolderName'],
                cvvCode: card['cvvCode'],
                showBackView: false,
              ),
            );
          },
        ),
      ),
    );
  }
}

//its success now
