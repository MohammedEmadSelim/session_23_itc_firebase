import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:session_23_itc_firebase/cubits/home_cubit/home_cubit.dart';
import 'package:session_23_itc_firebase/models/todo_model.dart';
import 'package:session_23_itc_firebase/screens/login_screen.dart';
import 'package:session_23_itc_firebase/screens/widgets/todo_card.dart';
import 'package:session_23_itc_firebase/screens/widgets/todo_creation_editing_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  @override
  void initState() {
    context.read<HomeCubit>().fetchTodos();

    super.initState();
  }

  @override
  void dispose() {
    _bodyController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 100),
              Expanded(
                child: BlocBuilder<HomeCubit, HomeState>(
                  buildWhen: (previous, current) =>  current is GetTodosLoading||
                      current is GetTodosError||
                      current is GetTodosSuccess

                  ,
                  builder: (context, state) {
                    print(state);
                    if (state is GetTodosLoading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (state is GetTodosError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    }

                    if (state is GetTodosSuccess) {
                      var todos = state.todos;
                      return ListView.separated(
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 10),
                        itemCount: todos.length,
                        itemBuilder: (context, index) {
                          var todo = todos[index];
                          return TodoCard(todo: todo);
                        },
                      );
                    }
                    if( state is DeleteTodoLoading || state is DeleteTodoSuccess){
                      return Center(child: Text("DeleteTodoLoading"));
                    }
                    return SizedBox();
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut().then(
                    (value) => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (route) {
                        return false;
                      },
                    ),
                  );
                },
                child: Text("Sign Out "),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {



          showModalBottomSheet(
            context: context,
            builder: (_) {
              return BlocProvider(
                create: (_) => HomeCubit(),
                child: CustomTodoCreation(),
              );
            },
            isScrollControlled: true,
          );
        },
        child: Icon(Icons.add, size: 31, color: Colors.pinkAccent),
      ),
    );
  }
}


