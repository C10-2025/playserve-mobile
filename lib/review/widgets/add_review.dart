import 'package:flutter/material.dart';

typedef OnSubmitReview = Future<void> Function(int rating, String comment);

class AddReviewModal extends StatefulWidget {
  final String courtName;
  final OnSubmitReview onSubmit;

  const AddReviewModal({super.key, required this.courtName, required this.onSubmit});

  @override
  State<AddReviewModal> createState() => _AddReviewModalState();
}

class _AddReviewModalState extends State<AddReviewModal> {
  final _formKey = GlobalKey<FormState>();
  int _rating = 5;
  final TextEditingController _commentController = TextEditingController();
  bool _submitting = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);
    try {
      await widget.onSubmit(_rating, _commentController.text.trim());
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final modalW = screenW < 520 ? screenW * 0.96 : 520.0;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: SizedBox(
        width: modalW,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add review for ${widget.courtName}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A2B4C),
                ),
              ),
              const SizedBox(height: 12),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Rating:',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A2B4C),
                          ),
                        ),
                        const SizedBox(width: 12),

                        DropdownButton<int>(
                          value: _rating,
                          dropdownColor: Colors.white,
                          style: const TextStyle(
                            color: Color(0xFF1A2B4C),  
                            fontWeight: FontWeight.w600,
                          ),
                          items: List.generate(
                            5,
                            (i) => DropdownMenuItem(
                              value: i + 1,
                              child: Text(
                                '${i + 1}',
                                style: const TextStyle(
                                  color: Color(0xFF1A2B4C), 
                                ),
                              ),
                            ),
                          ),
                          onChanged: (v) => setState(() => _rating = v ?? 5),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Now can add commentless reviews
                    TextFormField(
                      controller: _commentController,
                      minLines: 3,
                      maxLines: 6,
                      decoration: const InputDecoration(
                        hintText: 'Write your comments here... (Optional)',
                        hintStyle: TextStyle(color: Color(0xFF1A2B4C)),   
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(
                        color: Color(0xFF1A2B4C),  
                      ),
                    ),

                    const SizedBox(height: 12),

                    _submitting
                        ? const CircularProgressIndicator()
                        : Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _submit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFB0D235),
                                    foregroundColor: const Color(0xFF1A2B4C),
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold, // BUTTON TEXT
                                    ),
                                  ),
                                  child: const Text('Submit'),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
