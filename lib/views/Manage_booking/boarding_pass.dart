import 'package:AirTours/services/cloud/cloud_Ticket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../services/cloud/cloud_booking.dart';
import '../../services/cloud/cloud_flight.dart';
import '../../services/cloud/firestore_flight.dart';
import '../Global/global_var.dart';

class BoardingPass extends StatefulWidget {
  final CloudBooking booking;
  final CloudFlight flight;
  final CloudTicket ticket;
  const BoardingPass({
    Key? key,
    required this.booking,
    required this.flight,
    required this.ticket,
  }) : super(key: key);

  @override
  State<BoardingPass> createState() => _BoardingPassState();
}

class _BoardingPassState extends State<BoardingPass> {
  late final FlightFirestore _flightsService;

  void initState() {
    super.initState();
    _flightsService = FlightFirestore();
  }

  String date1(Timestamp date) {
    DateTime departureDate = date.toDate();
    DateFormat formatter = DateFormat('MM dd yyyy');
    String formattedDate = formatter.format(departureDate);
    List<String> parts = formattedDate.split(' ');
    int month = int.parse(parts[0]);
    String monthName = monthNames[month];
    String day = parts[1];
    String year = parts[2];
    return '$monthName $day $year';
  }

  String date2(Timestamp date) {
    DateTime departureDate = date.toDate();
    DateFormat formatter = DateFormat('MM dd yyyy');
    String formattedDate = formatter.format(departureDate);
    List<String> parts = formattedDate.split(' ');
    int month = int.parse(parts[0]);
    int monthName = month;
    String day = parts[1];
    String year = parts[2];
    return '$day/$monthName/$year';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            boxShadow: const [BoxShadow(blurRadius: 2, offset: Offset(0, 0))],
            borderRadius: BorderRadius.circular(20),
            color: Colors.white),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Ticket:",
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text("Booking Reference:",
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${widget.ticket.documentId}"),
                      Text("${widget.booking.documentId}")
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 1.0,
                    color: Colors.black,
                    width: double.infinity,
                    //child: SizedBox.expand(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Name:",
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text("Birth Date:",
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.ticket.firstName} ${widget.ticket.middleName} ${widget.ticket.lastName}',
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      Text("${date2(widget.ticket.birthDate)}")
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Boarding time:",
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        "Date:",
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          "${_flightsService.formatTime(widget.flight.depTime)}"),
                      Text("${date1(widget.flight.depDate)}")
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.flight.fromCity,
                        style: TextStyle(fontSize: 24),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        height: 30,
                        child: Image.asset('images/flight-Icon.png'),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        widget.flight.toCity,
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 1.0,
                    color: Colors.black,
                    width: double.infinity,
                    //child: SizedBox.expand(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Airport:",
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          )),
                      Text("Airport:",
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${widget.flight.fromAirport}"),
                      Text("${widget.flight.toAirport}")
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Flight:",
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          )),
                      Text("class:",
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${widget.flight.documentId}"),
                      Text("${widget.ticket.ticketClass}")
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Meal Type:",
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          )),
                      Row(
                        children: [
                          Text("Baggage quantity:",
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              )),
                          //Text("${ticket.bagQuantity}")
                        ],
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${widget.ticket.mealType}"),
                      Text("${widget.ticket.bagQuantity}")
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Ticket Price: ",
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          )),
                      Text(
                        "${widget.ticket.ticketPrice}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )
                    ],
                  ),
                  //if (asd == true)
                  Container(
                    width: double.infinity,
                    height: 100,
                    child: Image.asset('images/BarCode.jpeg'),
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
