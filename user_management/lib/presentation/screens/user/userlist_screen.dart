import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_management/presentation/screens/user/useradd_screen.dart';
import 'package:user_management/presentation/screens/user/useredit_screen.dart';
import '../../../logic/cubit/user_cubit.dart';
import '../../../logic/cubit/user_state.dart';
import '../../../core/utils/snackbar.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final searchCtrl = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    searchCtrl.addListener(() {
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 400), () {
        context.read<UserCubit>().loadUsers(searchCtrl.text);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async {
        bool exitApp = false;

        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Exit App"),
            content: const Text("Are you sure you want to exit the app?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  exitApp = true;
                  Navigator.pop(context);
                },
                child: const Text("Exit"),
              ),
            ],
          ),
        );

        if (exitApp) {
          Future.delayed(const Duration(milliseconds: 100), () {
            SystemNavigator.pop();
          });
        }

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("User Management"),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => context.read<UserCubit>().loadUsers(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddUserScreen()),
          ),
          label: const Text("Add User"),
          icon: const Icon(Icons.person_add),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: searchCtrl,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search user...",
                  filled: true,
                  fillColor: theme.colorScheme.surfaceVariant,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            Expanded(
              child: BlocConsumer<UserCubit, UserState>(
                listener: (context, state) {
                  if (state is UserStateError) {
                    AppSnackBar.show(context, state.message, isError: true);
                  }
                },
                builder: (context, state) {
                  return switch (state) {
                    UserStateLoading() => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    UserStateError(:final message) => Center(
                      child: Text(message),
                    ),
                    UserStateLoaded(:final users) => ListView.separated(
                      padding: const EdgeInsets.all(12),
                      itemCount: users.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) {
                        final user = users[i];
                        return Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            leading: CircleAvatar(child: Text(user.name[0])),
                            title: Text(
                              user.name,
                              style: theme.textTheme.titleMedium,
                            ),
                            subtitle: Text(user.email),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text("Confirm Delete"),
                                    content: Text(
                                      "Are you sure you want to delete ${user.name}?",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("Cancel"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          context.read<UserCubit>().deleteUser(
                                            user.id,
                                          );
                                          AppSnackBar.show(
                                            context,
                                            "User deleted",
                                          );
                                        },
                                        child: const Text("Delete"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditUserScreen(user: user),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    _ => const SizedBox.shrink(),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
