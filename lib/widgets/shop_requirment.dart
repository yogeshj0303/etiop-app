import 'package:flutter/material.dart';

class ShopRequirementsScreen extends StatelessWidget {
  final int shopId;
  final List<dynamic> requirements;

  const ShopRequirementsScreen({
    Key? key,
    required this.shopId,
    required this.requirements,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Requirements received in screen: $requirements'); // Debug print
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, ),
          onPressed: () {
            // Navigate back to the previous screen
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Shop Requirements',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: requirements.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 50,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No requirements available for this shop.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 20,
                  dataRowHeight: 60,
                  dataRowColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      return states.contains(MaterialState.selected)
                          ? Colors.grey.shade300
                          : (requirements.indexOf(requirements) % 2 == 0
                              ? Colors.grey.shade300
                              : Colors.white);
                    },
                  ),
                  columns: const [
                    DataColumn(
                      label: Center(
                        child: Text(
                          'Name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Center(
                        child: Text(
                          'Email',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Center(
                        child: Text(
                          'Phone',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Center(
                        child: Text(
                          'Message',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                  rows: requirements.map((requirement) {
                    // Make sure to safely access the requirement data
                    final userName = requirement['user_name'] ?? 'N/A';
                    final userEmail = requirement['user_email'] ?? 'N/A';
                    final userPhone = requirement['user_phone'] ?? 'N/A';
                    final message = requirement['message'] ?? 'N/A';

                    return DataRow(
                      cells: [
                        DataCell(Text(userName)),
                        DataCell(Text(userEmail)),
                        DataCell(Text(userPhone)),
                        DataCell(Text(message)),
                      ],
                    );
                  }).toList(),
                ),
              ),
      ),
    );
  }
}
