import 'package:flutter/material.dart';
import 'package:taxi_app/bloc/taxi_booking_bloc.dart'; 
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_app/bloc/taxi_booking_event.dart';

class TaxiRideCompleteWidget extends StatefulWidget {
  @override
  _TaxiRideCompleteWidgetState createState() =>
      _TaxiRideCompleteWidgetState();
}

class _TaxiRideCompleteWidgetState extends State<TaxiRideCompleteWidget>
 with TickerProviderStateMixin<TaxiRideCompleteWidget> {
  AnimationController animationController;
  Animation animation;
@override
void initState(){
  super.initState();
  animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    animation = CurvedAnimation(
      curve: Curves.easeIn,
      parent: animationController,
      );
      WidgetsBinding.instance.addPostFrameCallback((duration) {
      animationController.forward();
    });
}

    @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animation,
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0)),
                    child: Container(
                      color: Colors.black,
                      padding: EdgeInsets.symmetric(
                          vertical: 28.0, horizontal: 28.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              "Ride Info",
                              style: Theme.of(context)
                                  .textTheme
                                  .title
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    )),
                Container(
                  color: Colors.black,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0)),
                    child: Container(
                      padding: EdgeInsets.all(24.0),
                      color: Colors.white,
                      child: buildDialog(),
                    ),
                  ),
                )
              ]),
        ),
        builder: (context, child) {
          return Container(
            height: 250.0 * animation.value,
            child: child,
          );
        });
  }

  Widget buildDialog() {
    return Row(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
        ),
        SizedBox(
          width: 16.0,
        ),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              "Ride Complete",
              style: Theme.of(context).textTheme.title,
            ),
            SizedBox(
              height: 4.0,
            ),
            IconButton(
              icon: Icon(Icons.done),
              iconSize: 50,
              color: Colors.green,
              hoverColor: Colors.black,
              onPressed: () {
                    BlocProvider.of<TaxiBookingBloc>(context).add(
                        TaxiBookingStartEvent());
                  }
            ),
          ],
        )),
        SizedBox(
          width: 8.0,
        ),
      ],
    );
  }
}

