import 'package:fjghrd/controllers/login_control.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
            image: DecorationImage(
              image: AssetImage('assets/images/hrd_bg.png'),
              alignment: Alignment.bottomRight,
              repeat: ImageRepeat.noRepeat,
              fit: BoxFit.cover,
              opacity: 0.5,
            ),
          ),
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 35),
                  constraints: const BoxConstraints(
                    maxWidth: 450,
                  ),
                  child: Image.asset('assets/images/logo.png'),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 17),
                  constraints: const BoxConstraints(
                    maxWidth: 500,
                  ),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40),
                    ),
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.blue, Colors.blue, Colors.green, Colors.green],
                      begin: Alignment.topLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(25, 35, 25, 35),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Masuk',
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 25),
                        AFwidget.textField(
                          controller: controller.txtEmail,
                          label: 'Email',
                        ),
                        const SizedBox(height: 10),
                        GetX<LoginControl>(
                          builder: (_) {
                            return AFwidget.textField(
                              controller: controller.txtPassword,
                              label: 'Password',
                              obscureText: !controller.isTampilPassword.value,
                              suffixIcon: GestureDetector(
                                child: Icon(
                                  controller.isTampilPassword.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  size: 20,
                                ),
                                onTap: () {
                                  controller.isTampilPassword.toggle();
                                },
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 36),
                        AFwidget.tombol(
                          label: 'MASUK',
                          minimumSize: const Size(double.infinity, 40),
                          onPressed: controller.signIn,
                        ),
                        const SizedBox(height: 11),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
