import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocketread/logic/blocs/auth/auth_bloc.dart';
import 'package:pocketread/core/constants/app_constants.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _urlController = TextEditingController();
  final _keyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connect to Server')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_sync, size: 80, color: Colors.blueGrey),
              const SizedBox(height: 32),
              TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'Server URL',
                  hintText: 'https://your-worker.workers.dev',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.link),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter server URL';
                  }
                  if (!Uri.parse(value).isAbsolute) {
                     return 'Please enter a valid URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _keyController,
                decoration: const InputDecoration(
                  labelText: 'API Key',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.vpn_key),
                ),
                obscureText: true,
                validator: (value) {
                   if (value == null || value.isEmpty) {
                    return 'Please enter API Key';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                   if (state is AuthFailure) {
                     ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(content: Text(state.message)),
                     );
                   }
                },
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return const CircularProgressIndicator();
                  }
                  return SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(
                            AuthLoginRequested(
                              _urlController.text.trim(),
                              _keyController.text.trim(),
                            ),
                          );
                        }
                      },
                      child: const Text('Connect'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
