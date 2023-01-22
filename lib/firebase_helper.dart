import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_list_with_firebase/todo_list_response.dart';
import 'package:to_do_list_with_firebase/todo_task.dart';

class FirebaseHelper {
  static Future<String?> createAccount(
      {required String email, required String password}) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(credential.user?.uid)
            .set(<String, dynamic>{
          'email': email,
        });
        return null;
      }
      throw FirebaseAuthException(code: 'code');
    } on FirebaseAuthException catch (e) {
      return e.message ?? '';
    } catch (e) {
      return e.toString();
    }
  }

  static Future<String?> login(
      {required String email, required String password}) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        return null;
      }
      throw FirebaseAuthException(code: 'code');
    } on FirebaseAuthException catch (e) {
      return e.message ?? '';
    } catch (e) {
      return e.toString();
    }
  }

  static Future<String> addTask(TodoTask task) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      final todoCollection = FirebaseFirestore.instance.collection('todo');

      final userdocument =
          await todoCollection.where('user_id', isEqualTo: user?.uid).get();

      if (userdocument.docs.isEmpty) {
        await todoCollection.doc().set(<String, dynamic>{
          'user_id': user?.uid,
          'todos': [task.toJson()]
        });
        return 'success';
      }

      if (userdocument.docs.isNotEmpty) {
        final docmentId = userdocument.docs.first.id;

        final oldTodotasks =
            TodoListResonse.fromJson(userdocument.docs.first.data())
                .todoList
                .map((e) => e.toJson())
                .toList();

        oldTodotasks.add(task.toJson());
        await todoCollection.doc(docmentId).update(<String, dynamic>{
          'todos': oldTodotasks,
        });
        return 'success';
      }
      throw FirebaseException(plugin: 'error');
    } on FirebaseException catch (e) {
      log('ERRRRRRR ${e.message}');
      return e.message ?? '';
    } catch (e) {
      log('ERRRRRRR $e');
      return e.toString();
    }
  }

  static Future<String> updateTodo(TodoTask task) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      final todoCollection = FirebaseFirestore.instance.collection('todo');

      final userdocument =
          await todoCollection.where('user_id', isEqualTo: user?.uid).get();

      if (userdocument.docs.isNotEmpty) {
        final docmentId = userdocument.docs.first.id;

        final oldTodotasks =
            TodoListResonse.fromJson(userdocument.docs.first.data())
                .todoList
                .map((element) {
          log('ELEMENT ${element.id == task.id}');
          if (element.id == task.id) {
            return task.toJson();
          }
          return element.toJson();
        }).toList();

        await todoCollection.doc(docmentId).update(<String, dynamic>{
          'todos': oldTodotasks,
        });
        return 'success';
      }
      throw FirebaseException(plugin: 'error');
    } on FirebaseException catch (e) {
      log('ERRRRRRR ${e.message}');
      return e.message ?? '';
    } catch (e) {
      log('ERRRRRRR $e');
      return e.toString();
    }
  }

  static Future<String> deleteTodo(int id) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      final todoCollection = FirebaseFirestore.instance.collection('todo');

      final userdocument =
          await todoCollection.where('user_id', isEqualTo: user?.uid).get();

      if (userdocument.docs.isNotEmpty) {
        final docmentId = userdocument.docs.first.id;

        final oldTodotasks =
            TodoListResonse.fromJson(userdocument.docs.first.data())
                .todoList
                .where((element) {
                  return element.id != id;
                })
                .map((e) => e.toJson())
                .toList();

        await todoCollection.doc(docmentId).update(<String, dynamic>{
          'todos': oldTodotasks,
        });
        return 'success';
      }
      throw FirebaseException(plugin: 'error');
    } on FirebaseException catch (e) {
      log('ERRRRRRR ${e.message}');
      return e.message ?? '';
    } catch (e) {
      log('ERRRRRRR $e');
      return e.toString();
    }
  }

  static Future<TodoListResonse> get getUserTodo async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      final todoCollection = FirebaseFirestore.instance.collection('todo');

      final userdocument =
          await todoCollection.where('user_id', isEqualTo: user?.uid).get();

      if (userdocument.docs.isEmpty) {
        return TodoListResonse();
      }

      return TodoListResonse.fromJson(userdocument.docs.first.data());
    } on FirebaseException catch (e) {
      log('FIREBASE ERRROR ${e.message}');
      return TodoListResonse();
    } catch (e) {
      log('ERRORRRRR $e');
      return TodoListResonse();
    }
  }
}
