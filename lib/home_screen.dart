// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:async';
import 'dart:convert';

import 'package:api_example/Model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShowAllProduct extends StatefulWidget {
  const ShowAllProduct({super.key});

  @override
  State<ShowAllProduct> createState() => _ShowAllProductState();
}


class _ShowAllProductState extends State<ShowAllProduct> {
  Future<ProductModel> getProductUsingApi() async {
    final response =
        await http.get(Uri.parse('https://dummyjson.com/products'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      return ProductModel.fromJson(data);
    } else {
      return ProductModel.fromJson(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          title: const Text(
            "Products",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder<ProductModel>(
                  future: getProductUsingApi(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                       return ListView.builder(
                      itemCount: snapshot.data!.products.length,
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                  backgroundImage: NetworkImage(snapshot
                                      .data!.products[index].thumbnail
                                      .toString())),
                              title: Text(
                                snapshot.data!.products[index].title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // ignore: prefer_interpolation_to_compose_strings
                              subtitle: Text(
                                snapshot.data!.products[index].brand
                                        .toString() +
                                    "\nPrice: \$" +
                                    snapshot.data!.products[index].price
                                        .toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              trailing: Text(
                                "Discount: " +
                                    snapshot.data!.products[index]
                                        .discountPercentage
                                        .toString() +
                                    " %",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .4,
                              width: MediaQuery.of(context).size.width * 1,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot
                                    .data!.products[index].images.length,
                                itemBuilder: (context, position) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .35,
                                      width: MediaQuery.of(context).size.width *
                                          .5,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            snapshot.data!.products[index]
                                                .images[position]
                                                .toString(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.favorite_border_outlined,
                                size: 30,
                              ),
                            )
                          ],
                        );
                      },
                    );
                  
                    } else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Center(child: CircularProgressIndicator()),
                        ],
                      );
                    }
                   },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
