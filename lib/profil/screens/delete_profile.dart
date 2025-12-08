import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:playserve_mobile/main_navbar_admin.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class DeleteProfilePage extends StatefulWidget {
  const DeleteProfilePage({super.key});

  @override
  State<DeleteProfilePage> createState() => _DeleteProfilePageState();
}

class _DeleteProfilePageState extends State<DeleteProfilePage> {
  bool isLoading = true;
  
  List<Map<String, String>> users = [];
  List<Map<String, String>> filteredUsers = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  void safeSetState(VoidCallback fn) {
    if (mounted) setState(fn);
  }

  Future<void> fetchUsers() async {
    final request = context.read<CookieRequest>();
    safeSetState(() => isLoading = true);

    try {
      final response = await request.get(
        'https://jonathan-yitskhaq-playserve.pbp.cs.ui.ac.id/auth/get_all_users/',
      );

      debugPrint("📡 RAW RESPONSE: $response");

      if (response != null && response['status'] == true) {
        List<dynamic> rawList = response['users'] ?? [];
        List<Map<String, String>> cleanList = [];
        for (var item in rawList) {
          if (item == null) continue;
          
          cleanList.add({
            "username": item['username']?.toString() ?? "Unknown",
            "instagram": item['instagram']?.toString() ?? "",
            "avatar": item['avatar']?.toString() ?? "image/avatar1.png",
          });
        }

        safeSetState(() {
          users = cleanList;
          filteredUsers = cleanList;
          isLoading = false;
        });
      } else {
        safeSetState(() {
          users = [];
          filteredUsers = [];
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("❌ ERROR FETCH: $e");
      safeSetState(() => isLoading = false);
    }
  }

  void _searchUser(String query) {
    safeSetState(() {
      searchQuery = query.toLowerCase();
      if (searchQuery.isEmpty) {
        filteredUsers = List.from(users);
      } else {
        filteredUsers = users.where((u) {
          return u['username']!.toLowerCase().contains(searchQuery);
        }).toList();
      }
    });
  }

  Future<void> _deleteUser(String username) async {
    final request = context.read<CookieRequest>();
    safeSetState(() {
      users.removeWhere((u) => u['username'] == username);
      filteredUsers.removeWhere((u) => u['username'] == username);
    });

    try {
      final response = await request.post(
        'https://jonathan-yitskhaq-playserve.pbp.cs.ui.ac.id/auth/admin_delete_user/',
        {
          "username": username,
        },
      );
      if (response['status'] == true) {
         if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("User $username deleted successfully")),
            );
         }
      } else {
         fetchUsers();
         if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(response['message'] ?? "Failed to delete")),
            );
         }
      }

    } catch (e) {
      fetchUsers();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Delete failed: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF042A76),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Text(
                "USER MANAGEMENT",
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF102A7A),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  onChanged: _searchUser,
                  style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  decoration: const InputDecoration(
                    hintText: "Search users...",
                    hintStyle: TextStyle(color: Color.fromARGB(179, 0, 0, 0)),
                    border: InputBorder.none,
                    suffixIcon: Icon(Icons.search, color: Color.fromARGB(179, 0, 0, 0)),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.white))
                    : filteredUsers.isEmpty
                        ? const Center(child: Text("No users found", style: TextStyle(color: Colors.white)))
                        : ListView.builder(
                            itemCount: filteredUsers.length,
                            itemBuilder: (context, index) {
                              return _buildUserCard(filteredUsers[index]);
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MainNavbarAdmin(currentIndex: 1),
    );
  }

  Widget _buildUserCard(Map<String, String> user) {
    final username = user['username']!;
    final instagram = user['instagram']!;
    String avatarPath = user['avatar']!;
    if (avatarPath.startsWith('assets/')) {
      avatarPath = avatarPath.replaceFirst('assets/', '');
    }
    avatarPath = avatarPath.replaceAll(".svg", ".png");

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: const Color(0xFFB8D243),
            child: ClipOval(
               child: Image.asset(
                 'assets/$avatarPath',
                 fit: BoxFit.cover,
                 width: 56,
                 height: 56,
                 errorBuilder: (context, error, stackTrace) {
                   return const Icon(Icons.person, size: 30, color: Colors.white);
                 },
               ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF0A1F63),
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (instagram.isNotEmpty && instagram != 'null')
                  Text(
                    "@$instagram",
                    style: GoogleFonts.inter(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _deleteUser(username),
            icon: const Icon(Icons.delete, color: Colors.redAccent),
          ),
        ],
      ),
    );
  }
}