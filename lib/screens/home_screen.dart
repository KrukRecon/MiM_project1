import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project1/models/models.dart';
import 'package:project1/screens/signin_screen.dart';
import 'package:project1/services/services.dart';
import '../utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'List of series',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.mainColor,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: FutureBuilder(
        future: ApiServices().getSeries(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: ElevatedButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut().then((value) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignInScreen()));
                      });
                    },
                    child: const Text("Oops! Something went wrong."),
                  ),
                );
              } else {
                final series = snapshot.data as List<Series>;

                return ListView(
                    children:
                        series.map((x) => toTileView(context, x)).toList());
              }
          }
        },
      ),
    );
  }

  Container toTileView(BuildContext context, Series series) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 150,
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(width: 3.0, color: AppColors.primaryColor),
      ),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            height: 130,
            margin: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  series.image!.original.toString(),
                ),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                child: Text(
                  series.name.toString(),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: 30,
                    margin: const EdgeInsets.only(top: 6),
                    child: Text(
                      'Rating: ${series.averageRrating}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 30,
                    child: const Icon(
                      Icons.star_border_rounded,
                      color: AppColors.secondaryColor,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.15,
            height: 30,
            child: IconButton(
              icon: Icon(
                series.isFavourite ? Icons.favorite : Icons.favorite_outline,
                color: AppColors.secondaryColor,
                size: 30,
              ),
              onPressed: () async {
                setState(() {
                  series.isFavourite = true;
                });

                final favouriteSeries = FirebaseFirestore.instance
                    .collection('favourite-series')
                    .doc(series.id.toString());
                Map<String, dynamic> jsonData = {
                  'id': series.id.toString(),
                  'name': series.name.toString(),
                  'averageRating': series.averageRrating.toString(),
                  'userRating': series.userRating.toString(),
                  'summary': series.summary.toString(),
                  'image': series.image.toString(),
                };
                await favouriteSeries.set(jsonData);
              },
            ),
          ),
        ],
      ),
    );
  }
}
