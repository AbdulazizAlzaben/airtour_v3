import 'package:AirTours/services/cloud/cloud_flight.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../services/cloud/firestore_flight.dart';
import '../Global/final_pasenger_info.dart';

class RoundTripSearch2 extends StatefulWidget {
  final String id1;
  final String from;
  final String to;
  final String flightClass;
  final int numOfPas;
  final DateTime depDate;
  final DateTime retDate;
  final double flightPrice1;

  const RoundTripSearch2({
    super.key,
    required this.depDate,
    required this.id1,
    required this.flightPrice1,
    required this.from,
    required this.to,
    required this.flightClass,
    required this.numOfPas,
    required this.retDate,
  });

  @override
  State<RoundTripSearch2> createState() => _RoundTripSearch2State();
}

class _RoundTripSearch2State extends State<RoundTripSearch2> {
  late final FlightFirestore _flightsService;
  void toNext(String id, double flightPrice, String flightClass) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Enterinfo(
                id1: widget.id1,
                id2: id,
                flightPrice1: widget.flightPrice1,
                flightPrice2: flightPrice,
                flightClass: flightClass)));
  }

  @override
  void initState() {
    super.initState();
    _flightsService = FlightFirestore();
  }

  String calculateTravelTime(Timestamp departureTime, Timestamp arrivalTime) {
    DateTime departureDateTime = departureTime.toDate();
    DateTime arrivalDateTime = arrivalTime.toDate();

    Duration travelDuration = arrivalDateTime.difference(departureDateTime);

    int totalMinutes = travelDuration.inMinutes;
    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;

    // String formattedTravelTime = hours.toString() + 'h';
    if (hours < 0) {
      hours = hours * -1;
    }
    String formattedTravelTime = hours.toString() + 'h';

    if (minutes != 0) {
      formattedTravelTime += ' ${minutes}m';
    }

    return formattedTravelTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.blue,
            centerTitle: true,
            title: Text('${widget.from} to ${widget.to} ',
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ))),
        body: SafeArea(
            child: StreamBuilder(
          stream: _flightsService.allFlights(
              from: widget.from,
              to: widget.to,
              flightClass: widget.flightClass,
              numOfPas: widget.numOfPas,
              date: widget.retDate),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allFlights = snapshot.data as Iterable<CloudFlight>;
                  return ListView.builder(
                    itemCount: allFlights.length,
                    itemBuilder: (context, index) {
                      final flight = allFlights.elementAt(index);
                      double flightText = widget.flightClass == 'business'
                          ? flight.busPrice
                          : flight.guestPrice;
                      return GestureDetector(
                        onTap: () {
                          toNext(flight.documentId, flightText,
                              widget.flightClass);
                        },
                        child: Container(
                            //width: double.infinity,
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(blurRadius: 2, offset: Offset(0, 0))
                                ],
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(flight.fromCity),
                                      Container(
                                        height: 40,
                                        child: Image.asset(
                                            'images/flightFromTo.jpg'),
                                      ),
                                      Text(flight.toCity),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        //MainAxisAlignment.spaceEvenly,
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _flightsService
                                            .formatTime(flight.depTime),
                                      ),
                                      Text(calculateTravelTime(
                                          flight.depTime, flight.arrTime)),
                                      Text(
                                        _flightsService
                                            .formatTime(flight.arrTime),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    height: 1.0,
                                    color: Colors.black,
                                    width: double.infinity,
                                    //child: SizedBox.expand(),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Price"),
                                      Text("$flightText")
                                    ],
                                  )
                                ],
                              ),
                            )),
                      );
                    },
                  );
                } else {
                  return const CircularProgressIndicator();
                }

              default:
                return const CircularProgressIndicator();
            }
          },
        )));
  }
}
