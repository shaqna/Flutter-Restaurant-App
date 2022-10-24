import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_restaurant_app/data/model/restaurant_detail.dart';
import 'package:flutter_restaurant_app/utils/const_object.dart';

class RestaurantDetailPage extends StatefulWidget {
  static const routeName = '/restaurant-detail';
  final RestaurantDetail restaurant;

  const RestaurantDetailPage({required this.restaurant, Key? key})
      : super(key: key);

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage>
    with TickerProviderStateMixin {
  Widget _buildContent(BuildContext context) {
    return SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 200,
              leading: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 8, top: 14),
                  child: Icon(Icons.arrow_back),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.deepOrange,
                  ),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: widget.restaurant.restaurant.id,
                  child: Image.network(
                    largeResolutionPictureUrl +
                        widget.restaurant.restaurant.pictureId,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      return loadingProgress == null
                          ? child
                          : const Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.grey,
                              ),
                            );
                    },
                  ),
                ),
              ),
            )
          ];
        },
        body: ListView(
          children: [
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 18),
                        Text(
                          widget.restaurant.restaurant.name,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        const SizedBox(height: 3),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.place, color: Colors.red),
                            const SizedBox(width: 3),
                            Text(
                              widget.restaurant.restaurant.city,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.yellow),
                        const SizedBox(width: 4),
                        Text(widget.restaurant.restaurant.rating.toString(),
                            style: Theme.of(context).textTheme.subtitle1),
                      ],
                    ),
                  ],
                )),
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Deskripsi",
                      style: Theme.of(context).textTheme.subtitle2),
                  Text(
                    widget.restaurant.restaurant.description,
                    style: Theme.of(context).textTheme.bodyText2,
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Menu Makanan",
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        const SizedBox(height: 2),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                              widget.restaurant.foods.length,
                              (index) => Text(
                                  "${index + 1}.  ${widget.restaurant.foods[index]}")),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Menu Minuman",
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      const SizedBox(height: 2),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                            widget.restaurant.drinks.length,
                            (index) => Text(
                                "${index + 1}.  ${widget.restaurant.drinks[index]}")),
                      ),
                    ],
                  )),
                ],
              ),
            ),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(body: _buildContent(context));
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(child: _buildContent(context));
  }

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _buildAndroid(context);
      case TargetPlatform.iOS:
        return _buildIos(context);
      default:
        return _buildAndroid(context);
    }
  }
}
