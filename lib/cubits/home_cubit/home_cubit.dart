import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:session_23_itc_firebase/models/todo_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  void fetchTodos() async {
    var firestore = FirebaseFirestore.instance;
    emit(GetTodosLoading());

    try {
      var collection = await firestore.collection("todos").get();

      var docs = collection.docs.map((e) {
        return Todo.fromJson(e.data());
      }).toList();
      emit(GetTodosSuccess(docs));
    } catch (e) {
      if (e is TypeError) {
        print(e.stackTrace);
      }
      emit(GetTodosError(e.toString()));
    }
  }

  bool createTodo({required final String title, required final String body}) {
    var firestore = FirebaseFirestore.instance;

    try{

      var doc = firestore.collection("todos").doc();

      doc.set({
        "id": doc.id,
        "title": title,
        "body": body,
        "createdAt": DateTime.now(),
      });
      return true;
    } catch (e){
      return false;
    }
  }

  bool editTodo({
    required Todo todo,
    required String title,
    required String body,
  }) {
    var firestore = FirebaseFirestore.instance;
    var doc = firestore.collection("todos").doc(todo!.id);

    try {
      doc.update({"title": title, "body": body, "createdAt": DateTime.now()});
      return true;
    } catch (e) {
      return false;
    }
  }

  void deleteTodo(String id){
    emit(DeleteTodoLoading());
    try{
      var firestore = FirebaseFirestore.instance;
      var doc = firestore.collection('todos').doc(id).delete();
      emit(DeleteTodoSuccess());
    }catch(e){
      emit(DeleteTodoFailure(e.toString()));
    }
  }
}
