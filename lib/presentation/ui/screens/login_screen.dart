import 'package:diego_lopez_driving_school_client/core/validators/input_validators.dart';
import 'package:diego_lopez_driving_school_client/presentation/ui/widgets/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:diego_lopez_driving_school_client/presentation/blocs/user_bloc/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  static const String name = 'login_screen';
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  void _onLoginPressed(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        AuthLoginEvent(
          '${(_usernameController.text.trim()).toLowerCase()}@cdapanamericana.com',
          _passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.go('/');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 260,
                      child: Image.asset(
                        'assets/logo.png',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    Container(
                      width: 480,
                      margin: const EdgeInsets.symmetric(vertical: 18),
                      child: const Divider(thickness: 0.5),
                    ),
                    CustomInput(
                      width: 460,
                      hintText: "Nombre de usuario",
                      controller: _usernameController,
                      validator: (value) =>
                          InputValidator.usernameValidator(value),
                      textInputType: TextInputType.name,
                      icon: Icons.person_outline_rounded,
                      marginBottom: 8,
                    ),
                    CustomInput(
                      width: 460,
                      hintText: "Contraseña",
                      controller: _passwordController,
                      validator: (value) =>
                          InputValidator.emptyValidator(value: value),
                      icon: Icons.lock_outline_rounded,
                      obscureText: true,
                      passwordVisibility: true,
                      marginBottom: 22,
                    ),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        if (state is AuthLoading) {
                          return const CircularProgressIndicator.adaptive();
                        }

                        return FilledButton.icon(
                          onPressed: () => _onLoginPressed(context),
                          label: const Text('Ingresar'),
                          icon: const Icon(Icons.login_rounded),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
