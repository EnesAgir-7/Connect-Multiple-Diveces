import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_datastore/amplify_datastore_stream_controller.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:new_app1/models/ModelProvider.dart';
import 'package:new_app1/pages/home.dart';

import 'amplifyconfiguration.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ModelProvider modelProvider;
  bool amplifyConfig = false;
  @override
  void initState() {
    super.initState();
    modelProvider = ModelProvider.instance;
    _configureAmplify();
  }

  void _configureAmplify() async {
    if (!Amplify.isConfigured) {
      final auth = AmplifyAuthCognito();
      final dataStore = AmplifyDataStore(modelProvider: ModelProvider.instance);
      final AmplifyAPI apiPlugin = AmplifyAPI(modelProvider: ModelProvider.instance);

      try {
        await Amplify.addPlugins([auth, dataStore, apiPlugin]);
        await Amplify.configure(amplifyconfig);
        print('------------------------');
        print('Successfully configured');
      } on Exception catch (e) {
        print('Error configuring Amplify: $e');
      }
    }
    setState(() {
      amplifyConfig = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        builder: Authenticator.builder(),
        home: amplifyConfig ? const HomePage() : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
