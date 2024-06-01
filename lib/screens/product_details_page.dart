import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:prodigit_test/models/product.dart';
import 'package:prodigit_test/utils/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {


  int _currentIndex = 0;
  double averageRating = 0;
  final CarouselController _carouselController = CarouselController();

  @override
  void initState() {
    super.initState();
    if (widget.product.reviews.isNotEmpty) {
      averageRating = widget.product.reviews.map((review) => review.rating).reduce((a, b) => a + b) / widget.product.reviews.length;
    }
  }


  @override
  Widget build(BuildContext context) {



    return Scaffold(
      backgroundColor: secondaryBackgroundColor,
      appBar: AppBar(
        title: Text("Product Details",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        backgroundColor: secondaryBackgroundColor,
        surfaceTintColor: secondaryBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CarouselSlider(
              carouselController: _carouselController,
              options: CarouselOptions(
                  height: 400.0,
                autoPlay: true,
                onPageChanged: (index, reason){
                    setState(() {
                      _currentIndex = index;
                    });
                }
              ),
              items: widget.product.images.map((image) {
                return Builder(
                  builder: (BuildContext context) {
                    if(widget.product.images.isEmpty){
                      return Image.asset("assets/images/placeholder.png");
                    }
                    return Image.network(image,fit: BoxFit.contain,);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16.0),
            Center(
              child: AnimatedSmoothIndicator(
                  activeIndex: _currentIndex,
                  count: widget.product.images.length,
                axisDirection: Axis.horizontal,
                effect: const ScrollingDotsEffect(
                  dotColor: Colors.grey,
                  activeDotColor: brandColor,
                  dotHeight: 8.0,
                  dotWidth: 8.0,
                ),
                onDotClicked: (index){
                    _carouselController.animateToPage(index);
                },
              ),
            ),

            const SizedBox(height: 16.0),


            const SizedBox(height: 8.0),
            ListTile(
              title: Text(
                widget.product.title,
                textAlign: TextAlign.left,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineMedium
              ),
              trailing: Text(
                  'Rs. ${widget.product.price}',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: brandColor,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),


             Padding(
               padding: const EdgeInsets.only(left: 16.0,right: 16.0),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                   Text(
                       'Rating: ${averageRating.toStringAsFixed(1)}',
                       style: Theme.of(context).textTheme.labelLarge!.copyWith(
                           color: Colors.black54,
                       )
                   ),


                   RatingBarIndicator(
                     rating: averageRating,
                     direction: Axis.horizontal,
                     itemCount: 5,
                     itemSize: 18,
                     unratedColor: Colors.black54,
                     itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                     itemBuilder: (context, _) => const Icon(
                       Icons.star,
                       color: Colors.amber,
                     ),
                   ),
                 ],
               ),
             ),

            const SizedBox(height: 16.0),

            Padding(
              padding: const EdgeInsets.only(left: 16.0,right: 16.0),
              child: Text(
                widget.product.description,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



