import 'package:flutter/material.dart';
import '../models/safety_tip.dart';
import '../models/preventive_measure.dart';
import '../services/safety_tip_service.dart';
import '../services/preventive_measure_service.dart';

class SafetyTipsAndMeasuresPanel extends StatefulWidget {
  final List<Map<String, String>> categories;
  const SafetyTipsAndMeasuresPanel({required this.categories, Key? key})
    : super(key: key);

  @override
  State<SafetyTipsAndMeasuresPanel> createState() =>
      _SafetyTipsAndMeasuresPanelState();
}

class _SafetyTipsAndMeasuresPanelState
    extends State<SafetyTipsAndMeasuresPanel> {
  late String selectedCategoryId;

  @override
  void initState() {
    super.initState();
    selectedCategoryId = widget.categories.first['id']!;
  }

  // Helper function to get color based on tip level/title
  Color _getTipColor(String title) {
    final lowerTitle = title.toLowerCase();
    
    // Air Quality colors
    if (lowerTitle.contains('good') && lowerTitle.contains('green')) {
      return Colors.green;
    } else if (lowerTitle.contains('moderate') && lowerTitle.contains('yellow')) {
      return Colors.amber;
    } else if (lowerTitle.contains('unhealthy for sensitive') && lowerTitle.contains('orange')) {
      return Colors.orange;
    } else if (lowerTitle.contains('unhealthy') && lowerTitle.contains('red')) {
      return Colors.red;
    } else if (lowerTitle.contains('very unhealthy') && lowerTitle.contains('purple')) {
      return Colors.purple;
    } else if (lowerTitle.contains('hazardous') && lowerTitle.contains('maroon')) {
      return const Color(0xFF800000); // Maroon
    }
    
    // Heat Index colors
    else if (lowerTitle.contains('safe') && lowerTitle.contains('green')) {
      return Colors.green;
    } else if (lowerTitle.contains('caution') && lowerTitle.contains('yellow')) {
      return Colors.amber;
    } else if (lowerTitle.contains('extreme caution') && lowerTitle.contains('orange')) {
      return Colors.orange;
    } else if (lowerTitle.contains('danger') && lowerTitle.contains('red')) {
      return Colors.red;
    } else if (lowerTitle.contains('extreme danger') && lowerTitle.contains('purple')) {
      return Colors.purple;
    }
    
    // Flood Alert colors
    else if (lowerTitle.contains('alert level 1') && lowerTitle.contains('yellow')) {
      return Colors.amber;
    } else if (lowerTitle.contains('alert level 2') && lowerTitle.contains('orange')) {
      return Colors.orange;
    } else if (lowerTitle.contains('critical level 3') && lowerTitle.contains('red')) {
      return Colors.red;
    }
    
    // Typhoon colors
    else if (lowerTitle.contains('tropical depression') && lowerTitle.contains('blue')) {
      return Colors.blue;
    } else if (lowerTitle.contains('tropical storm') && lowerTitle.contains('yellow')) {
      return Colors.amber;
    } else if (lowerTitle.contains('severe tropical storm') && lowerTitle.contains('orange')) {
      return Colors.orange;
    } else if (lowerTitle.contains('typhoon') && lowerTitle.contains('red')) {
      return Colors.red;
    } else if (lowerTitle.contains('super typhoon') && lowerTitle.contains('purple')) {
      return Colors.purple;
    }
    
    // Default color for other tips
    return Colors.grey[600] ?? Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tips & Preventive Measures',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: widget.categories.map((cat) {
            final isSelected = selectedCategoryId == cat['id'];
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(cat['name']!),
                selected: isSelected,
                onSelected: (_) =>
                    setState(() => selectedCategoryId = cat['id']!),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),

        // SAFETY TIPS SECTION
        const Text(
          'Tips',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Expanded(
          child: StreamBuilder<List<SafetyTip>>(
            stream: SafetyTipService.getTipsForCategory(selectedCategoryId),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return const Center(child: CircularProgressIndicator());
              final tips = snapshot.data!;
              return ListView.builder(
                itemCount: tips.length,
                itemBuilder: (context, index) {
                  final tip = tips[index];
                  final title = (tip.level ?? tip.title).isNotEmpty
                      ? (tip.level ?? tip.title)
                      : tip.title; // fallback for older records
                  final tipColor = _getTipColor(title);
                  
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: tipColor.withOpacity(0.3), width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: tipColor.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 6,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: tipColor,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: tipColor,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit, color: tipColor),
                                onPressed: () => _showTipDialog(context, tip, title),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 6),
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: tipColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  tip.description,
                                  style: TextStyle(
                                    fontSize: 14,
                                    height: 1.4,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 24),

        // PREVENTIVE MEASURES SECTION
        const Text(
          'Preventive Measures',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Expanded(
          child: StreamBuilder<List<PreventiveMeasure>>(
            stream: PreventiveMeasureService.getMeasuresForCategory(
              selectedCategoryId,
            ),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return const Center(child: CircularProgressIndicator());
              final measures = snapshot.data!;
              return ListView.builder(
                itemCount: measures.length,
                itemBuilder: (context, index) {
                  final measure = measures[index];
                  // Inside ListView.builder for measures
                  return Card(
                    color: Colors.blue[50],
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.green[600],
                        child: Text(
                          measure.number, // e.g. "01", "02"
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        measure.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(measure.description),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () =>
                                _showMeasureDialog(context, measure),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => PreventiveMeasureService.deleteMeasure(
                              measure.id,
                              measure
                                  .categoryId, // pass categoryId for renumbering
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add Measure'),
            onPressed: () => _showMeasureDialog(context, null),
          ),
        ),
      ],
    );
  }

  void _showTipDialog(BuildContext context, SafetyTip tip, String title) {
    // Only description is editable, title is immutable
    final descriptionController = TextEditingController(text: tip.description);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Tip Description'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Immutable title, shown as plain text
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (descriptionController.text.trim().isEmpty) return;
              final updated = tip.copyWith(
                description: descriptionController.text.trim(),
              );
              await SafetyTipService.updateTip(updated);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showMeasureDialog(BuildContext context, PreventiveMeasure? measure) {
    final titleController = TextEditingController(text: measure?.title ?? '');
    final descriptionController = TextEditingController(
      text: measure?.description ?? '',
    );
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          measure == null
              ? 'Add Preventive Measure'
              : 'Edit Preventive Measure',
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.trim().isEmpty ||
                  descriptionController.text.trim().isEmpty)
                return;
              final model = PreventiveMeasure(
                id: measure?.id ?? '',
                categoryId: selectedCategoryId,
                title: titleController.text.trim(),
                description: descriptionController.text.trim(),
                isActive: true,
                order: measure?.order ?? 0,
                number: measure?.number ?? '',
              );
              if (measure == null) {
                await PreventiveMeasureService.addMeasure(model);
              } else {
                await PreventiveMeasureService.updateMeasure(model);
              }
              Navigator.pop(context);
            },
            child: Text(measure == null ? 'Add' : 'Save'),
          ),
        ],
      ),
    );
  }
}
