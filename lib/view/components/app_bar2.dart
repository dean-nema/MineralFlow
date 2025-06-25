import 'package:flutter/material.dart';
import 'package:mineralflow/view/Constants/utils.dart';
import 'package:mineralflow/view/pages/complete_batches.dart';
import 'package:mineralflow/view/pages/complete_run.dart';
import 'package:mineralflow/view/pages/final_run.dart';
import 'package:mineralflow/view/pages/finalized_batch.dart';
import 'package:mineralflow/view/pages/inprog_run.dart';
import 'package:mineralflow/view/pages/inprogress_batch.dart';
import 'package:mineralflow/view/pages/pending_batche.dart';
import 'package:mineralflow/view/pages/pending_runs.dart';
import 'package:mineralflow/view/pages/request_page.dart';
import 'package:mineralflow/view/pages/create_run.dart';
import 'package:mineralflow/view/pages/batch_list.dart'; // All Batches
import 'package:mineralflow/view/pages/run_list.dart'; // All Runs

class SideBar extends StatelessWidget {
  final String userName;
  final ActivePage activePage;

  const SideBar({super.key, required this.userName, required this.activePage});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Colors.blueGrey;
    const Color accentColor = Color(0xFF99F3BD);

    return Drawer(
      child: Material(
        color: primaryColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: primaryColor.withOpacity(0.1)),
              child: const Center(
                child: Text(
                  "Mineral Flow",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            _buildNavItem(
              context: context,
              icon: Icons.add_circle_outline,
              title: 'New Batch',
              page: ActivePage.newBatch,
              destination: RequestPage(),
            ),
            _buildNavItem(
              context: context,
              icon: Icons.add_chart_sharp,
              title: 'New Run',
              page: ActivePage.newRun,
              destination: const CreateRunPage(),
            ),
            const Divider(color: Colors.white24),
            _buildExpansionTile(
              context: context,
              icon: Icons.inventory_2_outlined,
              title: 'Batches',
              page: ActivePage.batches,
              items: [
                'All Batches',
                'Pending Batches',
                'In-Progress Batches',
                'Complete Batches',
                'Finalized Batches',
              ],
              destinations: [
                const BatchListPage(),
                const PendingBatchesPage(),
                const InProgressBatchesPage(),
                const CompleteBatchesPage(),
                const FinalizedBatchesPage(),
              ],
            ),
            _buildExpansionTile(
              context: context,
              icon: Icons.science_outlined,
              title: 'Runs',
              page: ActivePage.runs,
              items: [
                'All Runs',
                'Pending Runs',
                'In-Progress Runs',
                'Complete Runs',
                'Finalized Runs',
              ],
              destinations: [
                const AllRunsPage(),
                const PendingRunsPage(),
                const InProgressRunsPage(),
                const CompleteRunsPage(),
                const FinalizedRunsPage(),
              ],
            ),
            const Divider(color: Colors.white24),
            _buildNavItem(
              context: context,
              icon: Icons.settings_outlined,
              title: 'Advanced Options',
              page: ActivePage.advanced,
              destination: const Scaffold(
                body: Center(child: Text("Advanced Options")),
              ),
            ),
            const SizedBox(height: 100), // Spacer
            _buildUserMenu(context),
          ],
        ),
      ),
    );
  }

  // Helper for a standard, non-expandable navigation item
  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required ActivePage page,
    required Widget destination,
  }) {
    final bool isActive = activePage == page;
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      selected: isActive,
      selectedTileColor: Colors.white.withOpacity(0.2),
      onTap: () {
        // Close the drawer first
        Navigator.pop(context);
        // Then navigate if it's not the active page
        if (!isActive) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        }
      },
    );
  }

  // Helper for an expandable navigation tile (like a dropdown)
  Widget _buildExpansionTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required ActivePage page,
    required List<String> items,
    required List<Widget> destinations,
  }) {
    // Determine if the currently active page is one of the children of this tile
    bool isParentActive = items.asMap().entries.any((entry) {
      // This is a simplification; a more robust check might be needed if pages are reused.
      // For now, we check if the parent's `page` enum matches the `activePage`.
      return activePage == page;
    });

    return ExpansionTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      initiallyExpanded: isParentActive,
      iconColor: Colors.white,
      collapsedIconColor: Colors.white70,
      children:
          items.asMap().entries.map((entry) {
            int index = entry.key;
            String text = entry.value;
            return ListTile(
              contentPadding: const EdgeInsets.only(
                left: 40.0,
              ), // Indent sub-items
              title: Text(text, style: const TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => destinations[index]),
                );
              },
            );
          }).toList(),
    );
  }

  // User menu at the bottom of the sidebar
  Widget _buildUserMenu(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'logout')
          print("Logout selected");
        else if (value == 'profile')
          print("View Profile selected");
      },
      itemBuilder:
          (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'profile',
              child: Text('View Profile'),
            ),
            const PopupMenuItem<String>(value: 'logout', child: Text('Logout')),
          ],
      child: ListTile(
        leading: const Icon(
          Icons.account_circle,
          color: Colors.white,
          size: 28,
        ),
        title: Text(
          userName,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        trailing: const Icon(Icons.arrow_drop_up, color: Colors.white),
      ),
    );
  }
}
