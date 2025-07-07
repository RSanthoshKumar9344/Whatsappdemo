import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'phonenumber.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required
  await Firebase.initializeApp();            // Initialize Firebase
  runApp(const MyApp());
}

abstract class LogoEvent {}

class NavigateToWhatsappLogo extends LogoEvent {}

abstract class LogoState {}

class LogoInitial extends LogoState {}

class ShowWhatsappLogo extends LogoState {}

class LogoBloc extends Bloc<LogoEvent, LogoState> {
  LogoBloc() : super(LogoInitial()) {
    on<NavigateToWhatsappLogo>((event, emit) {
      emit(ShowWhatsappLogo());
    });
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = LogoBloc();
        Future.delayed(const Duration(seconds: 3), () {
          bloc.add(NavigateToWhatsappLogo());
        });
        return bloc;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<LogoBloc, LogoState>(
          builder: (context, state) {
            if (state is ShowWhatsappLogo) {
              return const Phonenumber();
            }
            return const WhatsappLogoScreen();
          },
        ),
      ),
    );
  }
}

class WhatsappLogoScreen extends StatelessWidget {
  const WhatsappLogoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: Center(
        child: Image.network(
          'https://upload.wikimedia.org/wikipedia/commons/6/6b/WhatsApp.svg',
          height: 120,
        ),
      ),
    );
  }
}
