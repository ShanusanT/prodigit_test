import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prodigit_test/models/product.dart';
import 'package:prodigit_test/screens/login_page.dart';
import 'package:prodigit_test/screens/product_details_page.dart';
import 'package:prodigit_test/services/api_service.dart';
import 'package:prodigit_test/services/authentication_service.dart';
import 'package:prodigit_test/utils/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Product>> futureProductList;

  final AuthenticationService _authService = AuthenticationService();

  final user = FirebaseAuth.instance.currentUser!;

  void _signOut({required Function onSingOut}) async {
    await _authService.signOut();
    onSingOut();
  }

  @override
  void initState() {
    super.initState();
    futureProductList = ApiService.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        surfaceTintColor: backgroundColor,
        title:  Text(
            "Product List",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: InkWell(
              onTap: (){
                showMenu(
                  color: secondaryBackgroundColor,
                    context: context,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    position: RelativeRect.fromLTRB(MediaQuery.sizeOf(context).width - 50, 0, 0, 0),
                    items: <PopupMenuEntry>[
                      const PopupMenuItem(
                          value: 'logout',
                          child: Text("Logout"),
                      ),
                    ]
                ).then((value){
                  if(value == 'logout'){
                    _signOut(
                      onSingOut: (){
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      }
                    );
                  }
                });
              },
              child: CircleAvatar(
                radius: 21,
                backgroundImage: user.photoURL != null ? NetworkImage(user.photoURL!)
                : const AssetImage('assets/images/user.png',),

              ),
            ),
          ),

          
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: futureProductList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  mainAxisExtent: 275

                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final product = snapshot.data![index];
                  return InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>ProductDetailsPage(product: product)));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: secondaryBackgroundColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: SingleChildScrollView(
                    
                        child: Column(
                          children: [
                            Image.network(product.thumbnail,fit: BoxFit.contain,height: 150,),
                    
                            ListTile(
                              title: Text(product.title,maxLines: 2,overflow: TextOverflow.ellipsis,),
                              subtitle: Text(product.brand, maxLines: 1, overflow: TextOverflow.ellipsis,),
                            ),
                    
                            const SizedBox(height: 8,),
                    
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Rs. ${product.price}',
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: brandColor,
                                    fontWeight: FontWeight.bold
                                  )
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text(
                'Error: ${snapshot.error}',
                    style: Theme.of(context).textTheme.bodyLarge,
            ),);
          }
          return const Center(child: CircularProgressIndicator(color: brandColor,));
        },
      ),
    );
  }
}

