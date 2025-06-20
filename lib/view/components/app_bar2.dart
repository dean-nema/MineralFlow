import 'package:flutter/material.dart';
import 'package:mineralflow/view/Constants/utils.dart';
import 'package:mineralflow/view/pages/batch_list.dart';
// Import the pages you want to navigate to
import 'package:mineralflow/view/pages/request_page.dart';
import 'package:mineralflow/view/pages/create_run.dart';
import 'package:mineralflow/view/pages/run_list.dart';

class ReusableAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final ActivePage
  activePage; // Required: Tells the AppBar which page is currently displayed

  // Callbacks are still needed for filtering, as this affects the parent's state
  final Function(String) onBatchesFilterSelected;
  final Function(String) onRunsFilterSelected;

  // Callback for the user profile menu remains
  final Function(String) onProfileMenuItemSelected;

  const ReusableAppBar({
    super.key,
    required this.userName,
    required this.activePage,
    required this.onBatchesFilterSelected,
    required this.onRunsFilterSelected,
    required this.onProfileMenuItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.blue[900],
      foregroundColor: Colors.white,
      title: const Text(
        "Mineral Flow",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [_buildUserMenu(context)],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: Container(
          height: 50.0,
          color: Colors.blue[800],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavButton(
                context,
                'New Batch',
                ActivePage.newBatch,
                RequestPage(),
              ),
              _buildNavButton(
                context,
                'New Run',
                ActivePage.newRun,
                const CreateRunPage(),
              ),
              _buildDropdownTab(
                context,
                title: "Batches",
                items: [
                  'All',
                  'Pending',
                  'In-Progress',
                  'Complete',
                ], // Added 'All'
                onSelected: (filter) {
                  // If we are not on the Batches page, navigate there first.
                  if (activePage != ActivePage.batches) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => BatchListPage()),
                    );
                  }
                  // Then, call the filter function.
                  onBatchesFilterSelected(filter);
                },
              ),
              _buildDropdownTab(
                context,
                title: "Runs",
                items: [
                  'All',
                  'Pending',
                  'In-Progress',
                  'Complete',
                ], // Added 'All'
                onSelected: (filter) {
                  // If we are not on the Runs page, navigate there first.
                  if (activePage != ActivePage.runs) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => AllRunsPage()),
                    );
                  }
                  // Then, call the filter function.
                  onRunsFilterSelected(filter);
                },
              ),
              _buildNavButton(
                context,
                'Advanced Options',
                ActivePage.advanced,
                const Scaffold(body: Center(child: Text("Advanced Options"))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper to build a navigation button that won't navigate if the page is already active.
  Widget _buildNavButton(
    BuildContext context,
    String title,
    ActivePage page,
    Widget destination,
  ) {
    bool isActive = activePage == page;
    return TextButton(
      onPressed:
          isActive
              ? null
              : () {
                // Use pushReplacement to avoid building up a huge back stack of main pages
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => destination),
                );
              },
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor:
            isActive ? Colors.black.withOpacity(0.2) : Colors.transparent,
      ),
      child: Text(title),
    );
  }

  /// Builds the user profile menu (unchanged)
  Widget _buildUserMenu(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onProfileMenuItemSelected,
      itemBuilder:
          (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'profile',
              child: Text('View Profile'),
            ),
            const PopupMenuItem<String>(value: 'logout', child: Text('Logout')),
          ],
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Row(
          children: [
            const Icon(Icons.person_outline),
            const SizedBox(width: 8),
            Text(userName),
          ],
        ),
      ),
    );
  }

  /// Builds a dropdown tab (unchanged)
  Widget _buildDropdownTab(
    BuildContext context, {
    required String title,
    required List<String> items,
    required Function(String) onSelected,
  }) {
    bool isActive =
        (title == "Batches" && activePage == ActivePage.batches) ||
        (title == "Runs" && activePage == ActivePage.runs);
    return PopupMenuButton<String>(
      onSelected: onSelected,
      itemBuilder:
          (BuildContext context) =>
              items
                  .map(
                    (String choice) => PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    ),
                  )
                  .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: isActive ? Colors.black.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Text(title, style: const TextStyle(color: Colors.white)),
            const Icon(Icons.arrow_drop_down, color: Colors.white),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 50.0);
}
