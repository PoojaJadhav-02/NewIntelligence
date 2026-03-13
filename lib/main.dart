
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:news_intelligence/repogitory/api_service.dart';
import 'package:news_intelligence/utils/route/route.dart';
import 'package:news_intelligence/utils/route/route_name.dart';
import 'package:news_intelligence/view_model/login_provider.dart';
import 'package:news_intelligence/view_model/news_provider.dart';
import 'package:news_intelligence/view_model/theme_provider.dart';
import 'package:provider/provider.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  DioClient.setupInterceptors();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key,});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NewsProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child:  Consumer<ThemeProvider>(
          builder: (context, themeChanger, _) {
            return  MaterialApp(
              themeMode: themeChanger.themeMode,
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              debugShowCheckedModeBanner: false,
              initialRoute: RouteName.splash,
              onGenerateRoute: AppRoute.generateRoute,
            );
          }
      ),
    );
  }
}






