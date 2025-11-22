import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_management/core/utils/snackbar.dart';
import 'package:user_management/logic/cubit/user_cubit.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add User")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _field(nameCtrl, "Name", (v) => v!.isEmpty ? "Required" : null),
              _field(emailCtrl, "Email", (v) {
                if (v == null || v.isEmpty) return "Required";
                if (!RegExp(r".+@.+\..+").hasMatch(v)) return "Invalid email";
                return null;
              }),
              _field(phoneCtrl, "Phone"),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<UserCubit>().addUser({
                      "name": nameCtrl.text.trim(),
                      "email": emailCtrl.text.trim(),
                      "phone": phoneCtrl.text.trim(),
                    });
                    AppSnackBar.show(context, "User added");
                    Navigator.pop(context);
                  }
                },
                child: const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController ctrl,
    String label, [
    String? Function(String?)? validator,
  ]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: ctrl,
        validator: validator,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
