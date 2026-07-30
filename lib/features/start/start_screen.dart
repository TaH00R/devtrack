import 'package:devtrack/features/start/widgets/card.dart';
import 'package:devtrack/features/start/widgets/note.dart';
import 'package:devtrack/features/start/widgets/task.dart';
import 'package:devtrack/shared/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff121214),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Image.asset("assets/images/cat_watching_rain.png"),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Good evening,",
                      style: GoogleFonts.jersey10(
                        color: Colors.white70,
                        fontSize: 22,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "TAHOOR",
                          style: GoogleFonts.pressStart2p(
                            fontSize: 25,
                            color: const Color(0xffB388FF),
                          ),
                        ),
                        Image.asset(
                          "assets/images/smile_pixel.png",
                          width: 40,
                          height: 40,
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          ">",
                          style: GoogleFonts.jetBrainsMono(
                            color: Color(0xff6EE7A2),
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          " One commit at a time.",
                          style: GoogleFonts.jetBrainsMono(
                            color: Colors.white38,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    AppCard(
                      title: "TODAY'S PLAN",
                      color: const Color(0xffFF8BA7),
                      trailing: "2 / 3 completed",
                      child: Column(
                        children: [
                          Task(text: "Solve 2 LeetCode Problems", done: true, tag: "Daily"),
                          Divider(color: Colors.white10),
                          Task(text: "Push Code to GitHub", done: true, tag: "Daily"),
                          Divider(color: Colors.white10),
                          Task(
                            text: "Study Spring Boot Security",
                            done: false,
                            tag: "Learning",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    AppCard(
                      title: "ACTIVE PROJECT",
                      color: Color(0xff6EE7A2),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Icons.folder,
                                  color: Color(0xff6EE7A2),
                                  size: 42,
                                ),
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "DevTrack",
                                      style: GoogleFonts.jetBrainsMono(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Personal Developer Dashboard",
                                      style: GoogleFonts.jetBrainsMono(
                                        color: Colors.white54,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: List.generate(
                                        10,
                                        (i) => Container(
                                          margin: const EdgeInsets.only(
                                            right: 4,
                                          ),
                                          width: 12,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              3,
                                            ),
                                            color: i < 7
                                                ? const Color(0xff6EE7A2)
                                                : Colors.white12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                "75%",
                                style: GoogleFonts.jetBrainsMono(
                                  color: const Color(0xff6EE7A2),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Updated 2h ago",
                              style: GoogleFonts.jetBrainsMono(
                                color: Colors.white38,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    AppCard(
                      title: "RECENT NOTES",
                      color: Color(0xffF3C86A),
                      trailing: "View all >",
                      child: const Column(
                        children: [
                          Note(
                            "JWT Authentication Flow",
                            "27 July 2025 • 8:45 PM",
                          ),
                          Divider(color: Colors.white10),
                          Note(
                            "Spring Boot Security Notes",
                            "27 July 2025 • 11:10 AM",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: DevTrackNavBar(
          currentIndex: 0,
          onTap: (index) {
            // Handle navigation
          },
        )
      ),
    );
  }}

  



