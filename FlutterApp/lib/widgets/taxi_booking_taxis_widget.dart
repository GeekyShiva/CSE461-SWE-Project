import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_app/bloc/taxi_booking_bloc.dart';
import 'package:taxi_app/bloc/taxi_booking_event.dart';
import 'package:taxi_app/bloc/taxi_booking_state.dart';
import 'package:taxi_app/controllers/location_controller.dart';
// import 'package:taxi_app/controllers/taxi_booking_controller.dart';
import 'package:taxi_app/models/taxi_booking.dart';
import 'package:taxi_app/widgets/rounded_button.dart';

class TaxiBookingTaxisWidget extends StatefulWidget {
  @override
  _TaxiBookingTaxisWidgetState createState() => _TaxiBookingTaxisWidgetState();
}

class _TaxiBookingTaxisWidgetState extends State<TaxiBookingTaxisWidget> {
  TaxiBooking taxiBooking;
  @override
  void initState() {
    super.initState();
    taxiBooking = (BlocProvider.of<TaxiBookingBloc>(context).state
            as TaxiNotSelectedState)
        .booking;
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
                  SizedBox(
                    height: 16.0,
                  ),
                  // raghav: removed buildtaxi feature
                  // buildTaxis(),
                  buildPriceDetails(),
                  SizedBox(
                    height: 16.0,
                  ),
                  buildLocation(taxiBooking.source.areaDetails, "From"),
                  SizedBox(
                    height: 12.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Divider(),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  buildLocation(taxiBooking.destination.areaDetails, "To"),
                  SizedBox(
                    height: 28.0,
                  ),
                  buildPaymentMethod()
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
                  text: "Request Trip",
                  onTap: () {
                    BlocProvider.of<TaxiBookingBloc>(context)
                        .add(TaxiSelectedEvent());
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildPriceDetails() {
    return Column(
      children: <Widget>[
        Divider(),
        SizedBox(
          height: 14.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // raghav: we need to calculate real distance and prices here
            // we need to use an existing function from taxi_nooking_controller` to calculate price
            // buildIconText("21 km", Icons.directions),
            // buildIconText("1-3", Icons.person_outline),
            // buildIconText("\$150", Icons.monetization_on),
            buildIconText("from zone: "+ LocationController.getZoneSeverity(taxiBooking.source.areaDetails), Icons.my_location),
            buildIconText("to zone: "+LocationController.getZoneSeverity(taxiBooking.destination.areaDetails), Icons.location_on)
          ],
        ),
        SizedBox(
          height: 14.0,
        ),
        Divider()
      ],
    );
  }

  Widget buildIconText(String text, IconData iconData) {
    return Row(
      children: <Widget>[
        Icon(
          iconData,
          size: 22.0,
          color: Colors.black,
        ),
        Text(
          " $text",
          style: Theme.of(context).textTheme.title,
        )
      ],
    );
  }

  Widget buildLocation(String area, String label) {
    return Row(
      children: <Widget>[
        Text(
          "•",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32.0),
        ),
        SizedBox(
          width: 12.0,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "$label",
                style: TextStyle(fontSize: 14.0, color: Colors.black38),
              ),
              Text(
                "$area",
                style: Theme.of(context).textTheme.title,
              )
            ],
          ),
        )
      ],
    );
  }

  Widget buildPaymentMethod() {
    return Container(
      child: Container(
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
            color: Color(0xffeeeeee).withOpacity(0.5),
            borderRadius: BorderRadius.circular(12.0)),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Icon(
                Icons.attach_money,
                size: 56.0,
              ),
            ),
            SizedBox(
              width: 16.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    "Payment in cash",
                    style: Theme.of(context).textTheme.title,
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

