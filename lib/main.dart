import 'package:flutter/material.dart';
import 'package:weather_app/locale_provider.dart';
import 'package:weather_app/models.dart';
import 'package:weather_app/service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return  ChangeNotifierProvider<LocaleProvider>(

      create: (_) => LocaleProvider(),
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeData(
            scaffoldBackgroundColor: const Color(0xFFBBE5ED),
          ),
              title: 'Weather App',
              supportedLocales: AllLocales.all,
              locale: Provider.of<LocaleProvider>(context).locale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              home: const MyHomePage(title: 'Weather App'),
            );   
          },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final cityTextController = TextEditingController();
  final dataService = DataService();

  WeatherResponse? _response;


  void search() async {
    final response = await dataService.getWeather(cityTextController.text, context);

    setState(() => _response = response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_response != null)
              Column(
                children: [
                  Text(
                    cityTextController.text,
                    style: const TextStyle(fontSize: 50),
                  ),
                  Text(
                    '${_response!.tempInfo.temperature}°',
                    style: const TextStyle(fontSize: 40),
                  ),
                  Text(_response!.weatherInfo.description),
                  Image.network(_response!.iconUrl),
                ],
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: SizedBox(
                width: 150,
                child: TextField(
                  controller: cityTextController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.city.toString(),
                    labelStyle: TextStyle(
                      color: Color(0xFF52454A),
                      fontWeight: FontWeight.w700
                    ),


                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: search,
              child: Text(AppLocalizations.of(context)!.search.toString()),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF783F41),
              ),
            ),
            IconButton(
              icon: Icon(Icons.language),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      child: Wrap(
                        children: [
                          ListTile(
                            leading: Icon(Icons.language),
                            title: Text('English'),
                            onTap: () {
                              Provider.of<LocaleProvider>(context, listen: false)
                                  .setLocale(AllLocales.all[0]);
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.language),
                            title: Text('Russian'),
                            onTap: () {
                              Provider.of<LocaleProvider>(context, listen: false)
                                  .setLocale(AllLocales.all[1]);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
