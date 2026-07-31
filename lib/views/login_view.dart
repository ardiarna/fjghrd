import 'package:fjghrd/controllers/login_control.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final LoginControl controller = Get.put(LoginControl());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: Container(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF8FAFC), Color(0xFFE2E8F0)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 40),
                    constraints: const BoxConstraints(
                      maxWidth: 250,
                    ),
                    child: Image.asset('assets/images/logo.png'),
                  ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0, curve: Curves.easeOutQuad),
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 400,
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Selamat Datang',
                          style: TextStyle(
                            fontSize: 24, 
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF334155),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Silakan masuk ke akun Anda',
                          style: TextStyle(
                            fontSize: 14, 
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 32),
                        AFwidget.textField(
                          controller: controller.txtEmail,
                          label: 'Email',
                          prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF94A3B8)),
                        ),
                        const SizedBox(height: 16),
                        GetX<LoginControl>(
                          builder: (_) {
                            return AFwidget.textField(
                              controller: controller.txtPassword,
                              label: 'Password',
                              obscureText: !controller.isTampilPassword.value,
                              prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF94A3B8)),
                              suffixIcon: GestureDetector(
                                child: Icon(
                                  controller.isTampilPassword.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  size: 20,
                                  color: const Color(0xFF94A3B8),
                                ),
                                onTap: () {
                                  controller.isTampilPassword.toggle();
                                },
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 32),
                        AFwidget.tombol(
                          label: 'MASUK',
                          minimumSize: const Size(double.infinity, 50),
                          onPressed: controller.signIn,
                        ),
                      ],
                    ),
                  ).animate(delay: 200.ms).fadeIn(duration: 600.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
