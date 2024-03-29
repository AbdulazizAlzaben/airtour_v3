import 'package:AirTours/views/Manage_booking/one_way_details.dart';
import 'package:AirTours/views/Manage_booking/round_trip_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/cloud/cloud_booking.dart';
import '../../services/cloud/cloud_flight.dart';
import '../../services/cloud/firestore_booking.dart';
import '../../services/cloud/firestore_flight.dart';
import '../Global/global_var.dart';

class ViewBookings extends StatefulWidget {
  const ViewBookings({super.key});

  @override
  State<ViewBookings> createState() => _ViewBookingsState();
}

class _ViewBookingsState extends State<ViewBookings> {
  late final BookingFirestore _bookingService;
  late final FlightFirestore _flightsService;
  FirebaseAuth auth = FirebaseAuth.instance;
  late final List<CloudFlight> allFlights;
  CloudFlight? returnFlight;
  CloudFlight? departureFlight;
  @override
  void initState() {
    super.initState();
    _bookingService = BookingFirestore();
    _flightsService = FlightFirestore();
  }

  Future<List<CloudBooking>> filterCurrentBookings(
      Iterable<CloudBooking> bookings) async {
    final List<CloudBooking> currentBookings = [];

    for (final booking in bookings) {
      final isCurrent = await _flightsService.isCurrentFlight(
        booking.departureFlight,
        booking.returnFlight,
      );

      if (isCurrent) {
        currentBookings.add(booking);
      }
    }

    return currentBookings;
  }

  void toNext(
      CloudFlight retFlight, CloudFlight depFlight, CloudBooking booking) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RoundTripDetails(
                booking: booking, depFlight: depFlight, retFlight: retFlight)));
  }

  // String date1(Timestamp date) {
  //   DateTime departureDate = date.toDate();
  //   DateFormat formatter = DateFormat('${monthNames["MM"]} dd yyyy');
  //   return formatter.format(departureDate);
  // }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Current Bookings'),
      ),
      body: StreamBuilder<Iterable<CloudBooking>>(
        stream:
            _bookingService.allBookings(bookingUserId: auth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              final allBookings = snapshot.data as Iterable<CloudBooking>;

              return FutureBuilder<List<CloudBooking>>(
                future: filterCurrentBookings(allBookings),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    final currentBookings = snapshot.data!;

                    return ListView.builder(
                      itemCount: currentBookings.length,
                      itemBuilder: (context, index) {
                        final booking = currentBookings[index];

                        return FutureBuilder<List<CloudFlight>>(
                          future: _flightsService.getFlights(
                              booking.departureFlight, booking.returnFlight),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasData) {
                              final flights = snapshot.data!;

                              final departureFlight = flights[0];
                              if (flights.length > 1) {
                                returnFlight = flights[1];
                              }

                              return GestureDetector(
                                onTap: () {
                                  if (booking.returnFlight == 'none') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OneWayDetails(
                                            booking: booking,
                                            depFlight: departureFlight),
                                      ),
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RoundTripDetails(
                                            booking: booking,
                                            depFlight: departureFlight,
                                            retFlight: returnFlight!),
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  //width: double.infinity,
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                            blurRadius: 2, offset: Offset(0, 0))
                                      ],
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              date1(departureFlight.depDate),
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            if (booking.returnFlight != 'none')
                                              Text(
                                                date1(returnFlight!.depDate),
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                          ],
                                        ),
                                        Text(
                                          "Referance:",
                                          style: TextStyle(fontSize: 24),
                                        ),
                                        Text(booking.documentId),
                                        SizedBox(
                                          child: Divider(
                                            color: Colors.black,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    departureFlight.fromCity,
                                                    style:
                                                        TextStyle(fontSize: 19),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Container(
                                                    height: 20,
                                                    child: Image.asset(
                                                        'images/flight-Icon.png'),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    departureFlight.toCity,
                                                    style:
                                                        TextStyle(fontSize: 19),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    _flightsService.formatTime(
                                                        departureFlight
                                                            .depTime),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                    child: Text("-"),
                                                  ),
                                                  Text(
                                                    _flightsService.formatTime(
                                                        departureFlight
                                                            .arrTime),
                                                  ),
                                                ],
                                              )
                                            ]),
                                            if (booking.returnFlight != 'none')
                                              Column(children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      returnFlight!.fromCity,
                                                      style: TextStyle(
                                                          fontSize: 19),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Container(
                                                      height: 20,
                                                      child: Image.asset(
                                                          'images/flight-Icon.png'),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      returnFlight!.toCity,
                                                      style: TextStyle(
                                                          fontSize: 19),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      _flightsService
                                                          .formatTime(
                                                              returnFlight!
                                                                  .depTime),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                      child: Text("-"),
                                                    ),
                                                    Text(
                                                      _flightsService
                                                          .formatTime(
                                                              returnFlight!
                                                                  .arrTime),
                                                    ),
                                                  ],
                                                )
                                              ]),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return const Text('No data');
                            }
                          },
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const Text('No data');
                  }
                },
              );
            } else {
              return const Text('Not Available');
            }
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
