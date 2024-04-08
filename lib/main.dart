import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:grocery_project/module/Customer_Side/provider/auth_provider.dart';
import 'package:grocery_project/module/Customer_Side/provider/cart_provide.dart';
import 'package:grocery_project/module/Customer_Side/provider/location_provider.dart';
import 'package:grocery_project/module/Customer_Side/provider/order_provider.dart';
import 'package:grocery_project/module/Customer_Side/provider/store_provide.dart';
import 'package:grocery_project/module/Customer_Side/screens/cart_screen.dart';
import 'package:grocery_project/module/Customer_Side/screens/generate_recipe.dart';
import 'package:grocery_project/module/Customer_Side/screens/home.dart';
import 'package:grocery_project/module/Customer_Side/screens/landing_screen.dart';
import 'package:grocery_project/module/Customer_Side/screens/loginScreen.dart';
import 'package:grocery_project/module/Customer_Side/screens/main_screen.dart';
import 'package:grocery_project/module/Customer_Side/screens/map_screen.dart';
import 'package:grocery_project/module/Customer_Side/screens/payment_home.dart';
import 'package:grocery_project/module/Customer_Side/screens/productDetail_screen.dart';
import 'package:grocery_project/module/Customer_Side/screens/product_list_screen.dart';
import 'package:grocery_project/module/Customer_Side/screens/profile_screen.dart';
import 'package:grocery_project/module/Customer_Side/screens/profile_update_screen.dart';
import 'package:grocery_project/module/Customer_Side/screens/splash.dart';
import 'package:grocery_project/module/Customer_Side/screens/vendor_home_screen.dart';
import 'package:grocery_project/module/Customer_Side/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AP()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => StoreProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(useMaterial3: true, fontFamily: 'Poppins'),
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        GenerateRecipe.id: (context) => GenerateRecipe(),

        HomeScreen.id: (context) => HomeScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        MapScreen.id: (context) => MapScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        LandingScreen.id: (context) => LandingScreen(),
        MainScreen.id: (context) => MainScreen(),
        VendorHomeScreen.id: (context) => VendorHomeScreen(),
        ProductListScreen.id: (context) => ProductListScreen(),
        ProductDetailScreen.id: (context) => ProductDetailScreen(),
        CartScreen.id: (context) => CartScreen(),
        ProfileScreen.id: (context) => ProfileScreen(),
        ProfileUpdate.id:(context) => ProfileUpdate(),
        PaymentHome.id:(context)=> PaymentHome(),
      },
      builder: EasyLoading.init(),

    );
  }
}
