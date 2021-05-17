import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:shapeyou/Screen/payment/existing_cards.dart';
import 'package:shapeyou/provider/order_provider.dart';
import 'package:shapeyou/services/payment/stripe_payment_service.dart';

class StripeHome extends StatefulWidget {
  static const String id = 'stripe-honme';

  StripeHome({Key key}) : super(key: key);

  @override
  StripeHomeState createState() => StripeHomeState();
}

class StripeHomeState extends State<StripeHome> {
  onItemPress(BuildContext context, int index, amount, orderProvider) async {
    switch (index) {
      case 1:
        payViaNewCard(context, amount, orderProvider);
        break;
      case 2:
        Navigator.pushNamed(context, ExistingCardsPage.id);
        break;
    }
  }

  payViaNewCard(
      BuildContext context, amount, OrderProvider orderProvider) async {
    await EasyLoading.show(status: 'Please wait...');
    var response = await StripeService.payWithNewCard(
        amount: '${amount}00', currency: 'INR');
    if (response.success == true) {
      orderProvider.success = true;
    }
    await EasyLoading.dismiss();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
          content: Text(response.message),
          duration: new Duration(
              milliseconds: response.success == true ? 1200 : 3000),
        ))
        .closed
        .then((_) {
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    super.initState();
    StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Material(
            elevation: 4,
            child: SizedBox(
                height: 56,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
                  child: Image.network(
                    'https://marketplace.cs-cart.com/images/thumbnails/700/280/detailed/4/logo_black.png',
                    fit: BoxFit.fitWidth,
                  ),
                )),
          ),
          //TODO:Razorpay
          Divider(
            color: Colors.grey,
          ),
          Material(
            elevation: 4,
            child: SizedBox(
                height: 56,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
                  child: Image.network(
                    'https://newsroom.mastercard.com/wp-content/uploads/2016/09/paypal-logo.png',
                    fit: BoxFit.fitHeight,
                  ),
                )),
          ),
          //TODO : Paypal
          Divider(
            color: Colors.grey,
          ),
          Material(
            elevation: 4,
            child: SizedBox(
                height: 56,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
                  child: Image.network(
                    'https://stripe.com/img/v3/newsroom/social.png',
                    fit: BoxFit.fitWidth,
                  ),
                )),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  Icon icon;
                  Text text;

                  switch (index) {
                    case 0:
                      icon = Icon(Icons.add_circle, color: theme.primaryColor);
                      text = Text('Add Cards');
                      //TODO : add new cards to firestore
                      break;
                    case 1:
                      icon = Icon(Icons.payment_outlined,
                          color: theme.primaryColor);
                      text = Text('Pay via new card');
                      break;
                    case 2:
                      icon = Icon(Icons.credit_card, color: theme.primaryColor);
                      text = Text('Pay via existing card');
                      break;
                  }

                  return InkWell(
                    onTap: () {
                      onItemPress(
                          context, index, orderProvider.amount, orderProvider);
                    },
                    child: ListTile(
                      title: text,
                      leading: icon,
                    ),
                  );
                },
                separatorBuilder: (context, index) => Divider(
                      color: theme.primaryColor,
                    ),
                itemCount: 3),
          ),
        ],
      ),
    );
  }
}

//now payment with stripe is working fine.
//next video will do adding new cards to firestore and retrieve card list from firestore.
