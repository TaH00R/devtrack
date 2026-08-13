import 'package:devtrack/features/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  bool obscurePassword = true;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final displayNameController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    displayNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff121214),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),

                // Logo
                Center(
                  child: Image.asset("assets/images/appbar.png", width: 70),
                ),

                const SizedBox(height: 28),

                // Heading
                Text(
                  isLogin ? "WELCOME BACK," : "NEW DEVELOPER,",
                  style: GoogleFonts.pressStart2p(
                    color: const Color(0xffB388FF),
                    fontSize: 21,
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Text(
                      ">",
                      style: GoogleFonts.jetBrainsMono(
                        color: const Color(0xff6EE7A2),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isLogin
                          ? "continue where you left off."
                          : "start tracking your progress.",
                      style: GoogleFonts.jetBrainsMono(
                        color: Colors.white38,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Auth card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xff19191d),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isLogin ? "LOGIN" : "REGISTER",
                        style: GoogleFonts.jetBrainsMono(
                          color: isLogin
                              ? const Color(0xffFF8BA7)
                              : const Color(0xff6EE7A2),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      if (!isLogin) ...[
                        _buildField(
                          controller: usernameController,
                          label: "USERNAME",
                          hint: "your_username",
                        ),

                        const SizedBox(height: 14),

                        _buildField(
                          controller: displayNameController,
                          label: "DISPLAY NAME",
                          hint: "Your Name",
                        ),

                        const SizedBox(height: 14),
                      ],

                      _buildField(
                        controller: emailController,
                        label: "EMAIL",
                        hint: "you@example.com",
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 14),

                      _buildField(
                        controller: passwordController,
                        label: "PASSWORD",
                        hint: "••••••••",
                        obscureText: obscurePassword,
                        suffix: IconButton(
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white30,
                            size: 19,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            await context.read<AuthProvider>().login(
                              email: emailController.text.trim(),
                              password: passwordController.text,
                            );

                            if (!context.mounted) return;

                            final authProvider = context.read<AuthProvider>();

                            if (authProvider.isAuthenticated) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Login successful!'),
                                ),
                              );
                            } else if (authProvider.errorMessage != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(authProvider.errorMessage!),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isLogin
                                ? const Color(0xffB388FF)
                                : const Color(0xff6EE7A2),
                            foregroundColor: const Color(0xff121214),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            isLogin ? "LOGIN >" : "CREATE ACCOUNT >",
                            style: GoogleFonts.jetBrainsMono(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Toggle
                Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isLogin = !isLogin;
                        obscurePassword = true;
                      });
                    },
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.jetBrainsMono(
                          color: Colors.white38,
                          fontSize: 12,
                        ),
                        children: [
                          TextSpan(
                            text: isLogin
                                ? "Don't have an account? "
                                : "Already have an account? ",
                          ),
                          TextSpan(
                            text: isLogin ? "REGISTER" : "LOGIN",
                            style: GoogleFonts.jetBrainsMono(
                              color: const Color(0xffFF8BA7),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Footer
                Center(
                  child: Text(
                    "> one commit at a time.",
                    style: GoogleFonts.jetBrainsMono(
                      color: Colors.white12,
                      fontSize: 11,
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.jetBrainsMono(
            color: Colors.white38,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 7),

        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          style: GoogleFonts.jetBrainsMono(color: Colors.white, fontSize: 13),
          cursorColor: const Color(0xffB388FF),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.jetBrainsMono(
              color: Colors.white12,
              fontSize: 13,
            ),
            filled: true,
            fillColor: const Color(0xff121214),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            suffixIcon: suffix,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: Colors.white10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: Color(0xffB388FF)),
            ),
          ),
        ),
      ],
    );
  }
}
