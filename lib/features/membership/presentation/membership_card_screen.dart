import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../shared/models/member_model.dart';
import '../services/membership_card_service.dart';

class MembershipCardScreen
    extends StatefulWidget {
  final MemberModel member;

  const MembershipCardScreen({
    super.key,
    required this.member,
  });

  @override
  State<MembershipCardScreen>
      createState() =>
          _MembershipCardScreenState();
}

class _MembershipCardScreenState
    extends State<
        MembershipCardScreen> {
  bool generatingPdf = false;

  Future<void> generatePdf() async {
    try {
      setState(() {
        generatingPdf = true;
      });

      await MembershipCardService()
          .printCard(
        widget.member,
      );
    } finally {
      if (mounted) {
        setState(() {
          generatingPdf = false;
        });
      }
    }
  }

  Color getStatusColor(
    String status,
  ) {
    switch (
        status.toLowerCase()) {
      case 'active':
        return Colors.green;

      case 'pending':
        return Colors.orange;

      case 'rejected':
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  Widget infoRow(
    String title,
    String value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 6,
      ),
      child: Row(
        children: [

          SizedBox(
            width: 140,
            child: Text(
              title,
              style:
                  const TextStyle(
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),

          const Text(': '),

          Expanded(
            child: Text(
              value,
              textAlign:
                  TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(
      BuildContext context) {
    final member =
        widget.member;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Membership Card',
        ),
      ),
      body: Center(
        child:
            SingleChildScrollView(
          padding:
              const EdgeInsets.all(
            20,
          ),
          child: Container(
            constraints:
                const BoxConstraints(
              maxWidth: 450,
            ),
            child: Card(
              elevation: 10,
              child: Padding(
                padding:
                    const EdgeInsets.all(
                  24,
                ),
                child: Column(
                  children: [

                    const Icon(
                      Icons.badge,
                      size: 70,
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    const Text(
                      'ILCKL',
                      style:
                          TextStyle(
                        fontSize:
                            26,
                        fontWeight:
                            FontWeight
                                .bold,
                      ),
                    ),

                    const Text(
                      'Membership Card',
                    ),

                    const Divider(),

                    CircleAvatar(
                      radius: 60,
                      backgroundImage:
                          member.profilePhoto !=
                                      null &&
                                  member
                                      .profilePhoto!
                                      .isNotEmpty
                              ? NetworkImage(
                                  member
                                      .profilePhoto!,
                                )
                              : null,
                      child:
                          member.profilePhoto ==
                                      null ||
                                  member
                                      .profilePhoto!
                                      .isEmpty
                              ? const Icon(
                                  Icons
                                      .person,
                                  size:
                                      60,
                                )
                              : null,
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    Text(
                      member.fullName,
                      style:
                          const TextStyle(
                        fontSize:
                            22,
                        fontWeight:
                            FontWeight
                                .bold,
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    infoRow(
                      'Membership No',
                      member.membershipNo ??
                          'Pending Approval',
                    ),

                    infoRow(
                      'IC Number',
                      member.icNumber ??
                          '-',
                    ),

                    infoRow(
                      'Membership Type',
                      member.membershipType ??
                          'Ahli Biasa',
                    ),

                    infoRow(
                      'Email',
                      member.email,
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal:
                            14,
                        vertical: 8,
                      ),
                      decoration:
                          BoxDecoration(
                        color:
                            getStatusColor(
                          member
                              .membershipStatus,
                        ),
                        borderRadius:
                            BorderRadius.circular(
                          20,
                        ),
                      ),
                      child: Text(
                        member
                            .membershipStatus,
                        style:
                            const TextStyle(
                          color:
                              Colors
                                  .white,
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    QrImageView(
                      data:
                          member.qrData,
                      version:
                          QrVersions
                              .auto,
                      size: 180,
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    SizedBox(
                      width:
                          double.infinity,
                      child:
                          ElevatedButton.icon(
                        onPressed:
                            generatingPdf
                                ? null
                                : generatePdf,
                        icon:
                            const Icon(
                          Icons
                              .picture_as_pdf,
                        ),
                        label:
                            Text(
                          generatingPdf
                              ? 'Generating PDF...'
                              : 'Download / Print PDF',
                        ),
                      ),
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