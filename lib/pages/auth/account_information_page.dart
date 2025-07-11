import 'package:flutter/material.dart';
import 'package:ta_mobile/pages/home/home_page.dart';
import 'package:ta_mobile/services/account_service.dart';
import 'package:ta_mobile/widgets/custom_elevated_button.dart';
import 'package:ta_mobile/widgets/custom_text_field.dart';

class AccountInformationPage extends StatelessWidget {
  AccountInformationPage({Key? key}) : super(key: key);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  Future<void> handleSignUp(BuildContext context) async {
    final result = await AccountService.updateProfile(
      name: nameController.text,
      phone: phoneController.text,
      address: addressController.text,
    );

    print("DEBUG: Save result = $result");

    if (result['success']) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Unknown error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF084A83),
      body: Stack(
        children: [
          Positioned(
            top: -50,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: Color(0xFF1AB9BF),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 50),
                child: Center(
                  child: Text(
                    "Complete\naccount information",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 200, 20, 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(label: "Name *", controller: nameController),
                  SizedBox(height: 20),
                  CustomTextField(
                    label: "No. Hp *",
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 20),
                  // CustomTextField(
                  //   label: "Email *",
                  //   controller: emailController,
                  //   keyboardType: TextInputType.emailAddress,
                  // ),
                  SizedBox(height: 20),
                  CustomTextField(
                    label: "Address *",
                    controller: addressController,
                    maxLines: 4,
                  ),
                  SizedBox(height: 40),
                  Center(
                    child: CustomElevatedButton(
                      text: "Sign up",
                      onPressed: () {
                        print("DEBUG: Sign up clicked");
                        handleSignUp(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
