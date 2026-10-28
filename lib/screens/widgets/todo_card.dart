import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:session_23_itc_firebase/cubits/home_cubit/home_cubit.dart';
import 'package:session_23_itc_firebase/models/todo_model.dart';
import 'package:session_23_itc_firebase/screens/widgets/todo_creation_editing_widget.dart';

class TodoCard extends StatelessWidget {
  const TodoCard({super.key, required this.todo});

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 290,
      width: 500,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.pinkAccent,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  todo.id,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => BlocProvider(
                            create: (context) => HomeCubit(),
                            child: CustomTodoCreation(
                              isEditing: true,
                              todo: todo,
                            ),
                          ),
                          isScrollControlled: true,
                        ).then((value) {
                          context.read<HomeCubit>().fetchTodos();
                        });
                        ;
                      },
                      child: Icon(Icons.edit, size: 34, color: Colors.white),
                    ),
                    SizedBox(width: 4),
                    BlocConsumer<HomeCubit, HomeState>(
                      listener: (context, state) {
                        if (state is DeleteTodoFailure) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                "Error",
                                style: TextStyle(fontSize: 24),
                              ),
                              content: Text(state.message),
                              actions: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.pinkAccent,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Ok",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        print(state);
                        if (state is DeleteTodoLoading) {
                          return CircularProgressIndicator(color: Colors.white);
                        }

                        return GestureDetector(
                          onTap: () {
                            // cubit
                            context.read<HomeCubit>().deleteTodo(todo.id);
                          },
                          child: Icon(
                            Icons.delete,
                            size: 34,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          Text(
            todo.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            todo.body,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            "${todo.createdAt.year}-${todo.createdAt.month}-${todo.createdAt.day}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
