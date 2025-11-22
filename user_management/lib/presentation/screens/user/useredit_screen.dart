import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_management/data/models/user/user.dart';
import '../../../core/utils/snackbar.dart';
import '../../../logic/cubit/user_cubit.dart';

class EditUserScreen extends StatefulWidget {
  final User user;
  const EditUserScreen({super.key, required this.user});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController phoneCtrl;

  @override
  void initState() {
    nameCtrl = TextEditingController(text: widget.user.name);
    emailCtrl = TextEditingController(text: widget.user.email);
    phoneCtrl = TextEditingController(text: widget.user.phone ?? "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit User")),
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
                    context.read<UserCubit>().updateUser(widget.user.id, {
                      "name": nameCtrl.text.trim(),
                      "email": emailCtrl.text.trim(),
                      "phone": phoneCtrl.text.trim(),
                    });
                    AppSnackBar.show(context, "Updated successfully");
                    Navigator.pop(context);
                  }
                },
                child: const Text("Update"),
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
    String? Function(String?)? val,
  ]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: ctrl,
        validator: val,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
