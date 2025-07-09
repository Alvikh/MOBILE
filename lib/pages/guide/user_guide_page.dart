import 'package:flutter/material.dart';
import 'package:ta_mobile/l10n/app_localizations.dart';
import 'package:ta_mobile/widgets/custom_floating_navbar.dart';

class UserGuidePage extends StatelessWidget {
  const UserGuidePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF0A5099),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/LOGO.png',
                          width: 100,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 40.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle(s.userGuideTitle),
                              const SizedBox(height: 10),
                              _buildSectionTitle(s.introTitle),
                              _buildSectionContent(s.introContent),
                              
                              _buildSectionTitle(s.installTitle),
                              _buildSubSectionTitle(s.downloadTitle),
                              _buildSectionContent(s.downloadContent),
                              
                              _buildSubSectionTitle(s.internetTitle),
                              _buildSectionContent(s.internetContent),
                              
                              _buildSectionTitle(s.monitoringTitle),
                              _buildSubSectionTitle(s.openMonitoringTitle),
                              _buildSectionContent(s.openMonitoringContent),
                              
                              _buildSubSectionTitle(s.addMonitoringDeviceTitle),
                              _buildSectionContent(s.addMonitoringDeviceContent),
                              
                              _buildSectionTitle(s.controllingTitle),
                              _buildSubSectionTitle(s.openControllingTitle),
                              _buildSectionContent(s.openControllingContent),
                              
                              _buildSubSectionTitle(s.addControllingDeviceContent),
                              _buildSectionContent(s.addControllingDeviceContent),
                              
                              _buildSectionTitle(s.tipsTitle),
                              _buildSubSectionTitle(s.cannotConnectTitle),
                              _buildSectionContent(s.cannotConnectContent),
                              
                              _buildSubSectionTitle(s.supportTitle),
                              _buildSectionContent(s.supportContent),
                              
                              const SizedBox(height: 20),
                              Center(
                                child: Text(
                                  s.closingMessage,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              SizedBox(height: 100,),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // const Positioned(
          //   left: 20,
          //   right: 20,
          //   bottom: 20,
          //   child: CustomFloatingNavbar(selectedIndex: 4),
          // ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 5),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF085085),
        ),
      ),
    );
  }

  Widget _buildSubSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 3),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF085085),
        ),
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        content,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF085085),
        ),
      ),
    );
  }
}