import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'Call.dart';
import 'Chat.dart';
import 'Status.dart';

// ------------------------- BLoC SECTION -------------------------

abstract class ChatEvent {}

class FetchUsers extends ChatEvent {}

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<dynamic> users;
  final bool isChatReady;

  ChatLoaded(this.users, {this.isChatReady = false});
}

class ChatError extends ChatState {}

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<FetchUsers>((event, emit) async {
      emit(ChatLoading());
      try {
        final response = await http.get(
          Uri.parse("https://reqres.in/api/users?page=2"),
          headers: {
            "x-api-key": "reqres-free-v1",
            "reqres-free-v1": "true",
          },
        );

        if (response.statusCode == 200) {
          final parsed = json.decode(response.body);
          final users = parsed['data'];

          await Future.delayed(Duration(seconds: 2)); // Optional delay

          emit(ChatLoaded(users, isChatReady: true));
        } else {
          emit(ChatError());
        }
      } catch (_) {
        emit(ChatError());
      }
    });
  }
}

// ------------------------- MAIN HOME APP -------------------------

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatBloc()..add(FetchUsers()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "WhatsApp Clone",
        theme: ThemeData(
          primaryColor: Color(0xFF075E54),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: Color(0xFF25D366),
          ),
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text("WhatsApp", style: TextStyle(color: Colors.white)),
            backgroundColor: Color(0xFF075E54),
            iconTheme: IconThemeData(color: Colors.white),
            bottom: TabBar(
              controller: tabController,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              tabs: [
                Tab(text: "CHATS"),
                Tab(text: "CALLS"),
                Tab(text: "STATUS"),
              ],
            ),
          ),
          body: BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              if (state is ChatLoading || state is ChatInitial) {
                return ListView.builder(
                  padding: EdgeInsets.all(12),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 12),
                      height: 70,
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey.shade300,
                            radius: 18,
                          ),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 100,
                                height: 10,
                                color: Colors.grey.shade300,
                              ),
                              SizedBox(height: 6),
                              Container(
                                width: 60,
                                height: 8,
                                color: Colors.grey.shade300,
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                );
              } else if (state is ChatLoaded) {
                return TabBarView(
                  controller: tabController,
                  children: [
                    state.isChatReady
                        ? Chat(state.users)
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(color: Colors.green),
                                SizedBox(height: 16),
                                Text("Loading Chats..."),
                              ],
                            ),
                          ),
                    Call(state.users),
                    Status(state.users),
                  ],
                );
              } else {
                return Center(child: Text("Error retrieving data"));
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            backgroundColor: Color(0xFF25D366),
            child: Icon(Icons.message, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
