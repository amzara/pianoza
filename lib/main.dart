import 'package:flutter/material.dart';
import 'package:pianoza/bloc/viewer_cubit.dart';
import '../view/home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ViewerCubit(),
      child: MaterialApp(
        home: Home(),
      ),
    );
  }
}

