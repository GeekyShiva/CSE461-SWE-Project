import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_app/bloc/taxi_booking_bloc.dart';
import 'package:taxi_app/bloc/taxi_booking_event.dart';
import 'package:taxi_app/controllers/location_controller.dart';
// import 'package:taxi_app/controllers/taxi_booking_controller.dart';
import 'package:taxi_app/widgets/rounded_button.dart';

class TaxiBookingDetailsWidget extends StatefulWidget {
  @override
  _TaxiBookingDetailsWidgetState createState() =>
      _TaxiBookingDetailsWidgetState();
}

class _TaxiBookingDetailsWidgetState extends State<TaxiBookingDetailsWidget> {
  // GoogleLocation source, destination;
  final sourceController = TextEditingController();
  final destinationController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Address",
                    style: Theme.of(context).textTheme.headline,
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                   TextField(
                    controller: sourceController,
                    decoration: InputDecoration(
                      labelText: "your location", 
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    controller: destinationController,
                    decoration: InputDecoration(
                      labelText: "destination location", 
                    ),
                  ),
                  
                ],
              ),
            ),
          ),
          Row(
            children: <Widget>[
              RoundedButton(
                onTap: () {
                  BlocProvider.of<TaxiBookingBloc>(context)
                      .add(BackPressedEvent());
                },
                iconData: Icons.keyboard_backspace,
              ),
              SizedBox(
                width: 18.0,
              ),
              Expanded(
                flex: 2,
                child: RoundedButton(
                  text: "See Next",
                  onTap: () {
                    if(destinationController.text != sourceController.text &&
        LocationController.getZoneSeverity(destinationController.text) == LocationController.getZoneSeverity(sourceController.text))
                    {
                    BlocProvider.of<TaxiBookingBloc>(context).add(
                     DestinationDetailsEnteredEvent(
                       destination: destinationController.text,
                      source: sourceController.text));
                    }
                  }
                  
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildContainer(String val, bool enabled) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 6.0),
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
            color: enabled ? Colors.black : Color(0xffeeeeee),
            borderRadius: BorderRadius.circular(12.0)),
        child: Text(
          "$val",
          style: Theme.of(context).textTheme.headline.copyWith(
              color: enabled ? Colors.white : Colors.black, fontSize: 15.0),
        ));
  }
  
  Widget buildInputWidget(String text, String hint, Function() onTap) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Color(0xffeeeeee).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        text ?? hint,
        style: Theme.of(context)
            .textTheme
            .title
            .copyWith(color: text == null ? Colors.black45 : Colors.black),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}