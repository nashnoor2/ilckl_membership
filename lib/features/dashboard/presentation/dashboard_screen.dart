import 'package:flutter/material.dart';

import '../../../core/services/auth_service.dart';
import '../../../core/services/member_service.dart';
import '../../../shared/models/member_model.dart';
import '../../membership/presentation/membership_card_screen.dart';
import '../../profile/presentation/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {
  late Future<MemberModel?> memberFuture;

  @override
  void initState() {
    super.initState();

    memberFuture =
        MemberService().getCurrentMember();
  }

  Future<void> refreshData() async {
    setState(() {
      memberFuture =
          MemberService().getCurrentMember();
    });
  }

  Future<void> logout() async {
    await AuthService().signOut();
  }

  Color getStatusColor(
    String status,
  ) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;

      case 'pending':
        return Colors.orange;

      case 'rejected':
        return Colors.red;

      case 'expired':
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
        ),
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),

      body: FutureBuilder<MemberModel?>(
        future: memberFuture,

        builder: (
          context,
          snapshot,
        ) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          final member =
              snapshot.data;

          if (member == null) {
            return const Center(
              child: Text(
                'Member record not found',
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: refreshData,

            child: ListView(
              padding:
                  const EdgeInsets.all(20),

              children: [

                /// HEADER
                Card(
                  child: Padding(
                    padding:
                        const EdgeInsets.all(
                      20,
                    ),

                    child: Column(
                      children: [

                        CircleAvatar(
                          radius: 50,

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
                                      Icons.person,
                                      size: 50,
                                    )
                                  : null,
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        Text(
                          member.fullName,
                          style:
                              const TextStyle(
                            fontSize: 22,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        Text(
                          member.membershipType ??
                              'Ahli Biasa',
                        ),

                        const SizedBox(
                          height: 12,
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
                      ],
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                /// MEMBERSHIP SUMMARY
                Card(
                  child: Padding(
                    padding:
                        const EdgeInsets.all(
                      16,
                    ),

                    child: Column(
                      children: [

                        const Text(
                          'Membership Information',
                          style:
                              TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),

                        const SizedBox(
                          height: 15,
                        ),

                        infoRow(
                          'Membership No',
                          member.membershipNo ??
                              'Pending Approval',
                        ),

                        infoRow(
                          'Registration Date',
                          member.registrationDate
                                  ?.toString()
                                  .split(' ')
                                  .first ??
                              '-',
                        ),

                        infoRow(
                          'Expiry Date',
                          member.expiryDate
                                  ?.toString()
                                  .split(' ')
                                  .first ??
                              '-',
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                /// QUICK ACTIONS
                Card(
                  child: ListTile(
                    leading:
                        const Icon(
                      Icons.badge,
                    ),

                    title:
                        const Text(
                      'Membership Card',
                    ),

                    subtitle:
                        const Text(
                      'View digital membership card',
                    ),

                    trailing:
                        const Icon(
                      Icons
                          .arrow_forward_ios,
                    ),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              MembershipCardScreen(
                            member:
                                member,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Card(
                  child: ListTile(
                    leading:
                        const Icon(
                      Icons.person,
                    ),

                    title:
                        const Text(
                      'My Profile',
                    ),

                    subtitle:
                        const Text(
                      'Update your information',
                    ),

                    trailing:
                        const Icon(
                      Icons
                          .arrow_forward_ios,
                    ),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ProfileScreen(
                            member:
                                member,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                /// MEMBER DETAILS
                Card(
                  child: Padding(
                    padding:
                        const EdgeInsets.all(
                      16,
                    ),

                    child: Column(
                      children: [

                        const Text(
                          'Member Details',
                          style:
                              TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),

                        const SizedBox(
                          height: 15,
                        ),

                        infoRow(
                          'IC Number',
                          member.icNumber ??
                              '-',
                        ),

                        infoRow(
                          'Email',
                          member.email,
                        ),

                        infoRow(
                          'Phone Number',
                          member.phoneNumber ??
                              '-',
                        ),

                        infoRow(
                          'Address',
                          member.address ??
                              '-',
                        ),

                        infoRow(
                          'OKU Category',
                          member.okuCategory ??
                              '-',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
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
}