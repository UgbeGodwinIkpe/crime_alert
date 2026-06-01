import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF5F8FC),

      appBar: AppBar(
        title: const Text(
          "Help & Support",
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            // HEADER CARD
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius:
                    BorderRadius.circular(20),
              ),

              child: const Column(
                children: [

                  Icon(
                    Icons.support_agent,
                    size: 60,
                    color: Colors.white,
                  ),

                  SizedBox(height: 12),

                  Text(
                    "How can we help you?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    "Get support and assistance for using the Crime Alert application.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // FAQ TITLE
            const Text(
              "Frequently Asked Questions",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            _faqTile(
              question:
                  "How do I report a crime?",
              answer:
                  "Navigate to the Report Crime screen, fill in the required information, upload evidence if available, and submit your report.",
            ),

            _faqTile(
              question:
                  "Can I report anonymously?",
              answer:
                  "Yes. Enable the anonymous report option while submitting your report.",
            ),

            _faqTile(
              question:
                  "Can I withdraw a report?",
              answer:
                  "Yes. Open the My Reports section and click the Withdraw button.",
            ),

            _faqTile(
              question:
                  "How is my location detected?",
              answer:
                  "The application uses your device GPS and location services to automatically detect your current location.",
            ),

            const SizedBox(height: 25),

            // CONTACT SECTION
            const Text(
              "Contact Support",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            _contactTile(
              icon: Icons.email,
              title: "Email Support",
              subtitle:
                  "support@crimealert.com",
            ),

            _contactTile(
              icon: Icons.phone,
              title: "Emergency Hotline",
              subtitle: "+234 800 000 0000",
            ),

            _contactTile(
              icon: Icons.location_on,
              title: "Office Address",
              subtitle:
                  "Abuja, Nigeria",
            ),

            const SizedBox(height: 30),

            // APP VERSION
            const Center(
              child: Column(
                children: [

                  Text(
                    "Crime Alert App",
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 5),

                  Text(
                    "Version 1.0.0",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // FAQ TILE
  Widget _faqTile({
    required String question,
    required String answer,
  }) {

    return Card(

      elevation: 0,

      margin: const EdgeInsets.only(
        bottom: 12,
      ),

      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(15),
      ),

      child: ExpansionTile(

        title: Text(
          question,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),

        children: [

          Padding(
            padding:
                const EdgeInsets.all(16),

            child: Text(answer),
          ),
        ],
      ),
    );
  }

  // CONTACT TILE
  Widget _contactTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {

    return Container(

      margin: const EdgeInsets.only(
        bottom: 12,
      ),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(15),
      ),

      child: ListTile(

        leading: CircleAvatar(
          backgroundColor:
              Colors.blue.withOpacity(0.1),

          child: Icon(
            icon,
            color: Colors.blue,
          ),
        ),

        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),

        subtitle: Text(subtitle),
      ),
    );
  }
}