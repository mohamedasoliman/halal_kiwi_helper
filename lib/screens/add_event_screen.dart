import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/event.dart';
import '../providers/event_provider.dart';

class AddEventScreen extends ConsumerStatefulWidget {
  const AddEventScreen({super.key});

  @override
  ConsumerState<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends ConsumerState<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _imageController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contactController = TextEditingController();
  final _linkController = TextEditingController();
  DateTime _selectedDateTime = DateTime.now();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _imageController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    _contactController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _resetForm() {
    _nameController.clear();
    _imageController.clear();
    _addressController.clear();
    _descriptionController.clear();
    _contactController.clear();
    _linkController.clear();
    setState(() {
      _selectedDateTime = DateTime.now();
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final event = Event(
          name: _nameController.text,
          image: _imageController.text.isEmpty ? null : _imageController.text,
          address: _addressController.text,
          description: _descriptionController.text,
          dateTime: _selectedDateTime,
          contact: _contactController.text,
          link: _linkController.text.isEmpty ? null : _linkController.text,
        );

        final result = await ref.read(addEventProvider(event).future);

        if (result && mounted) {
          _showSuccessDialog();
          _resetForm();
        }
      } catch (e) {
        if (mounted) {
          _showErrorDialog(e.toString());
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: const Text('Event added successfully!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Event'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Required fields
              _buildTextField(
                controller: _nameController,
                label: 'Event Name',
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter event name' : null,
                isRequired: true,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _addressController,
                label: 'Address',
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter address' : null,
                isRequired: true,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                maxLines: 3,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter description' : null,
                isRequired: true,
              ),
              const SizedBox(height: 16),
              _buildDateTimePicker(),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _contactController,
                label: 'Contact',
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter contact' : null,
                isRequired: true,
              ),
              const SizedBox(height: 16),
              
              // Optional fields
              _buildTextField(
                controller: _imageController,
                label: 'Image URL',
                isRequired: false,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _linkController,
                label: 'Link',
                isRequired: false,
              ),
              const SizedBox(height: 24),
              
              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _isLoading ? null : _resetForm,
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Submit Event'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    int maxLines = 1,
    bool isRequired = true,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: isRequired ? '$label *' : label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      maxLines: maxLines,
      validator: isRequired ? validator : null,
      style: const TextStyle(fontSize: 16),
    );
  }

  Widget _buildDateTimePicker() {
    return InkWell(
      onTap: _selectDateTime,
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Date & Time *',
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          suffixIcon: Icon(Icons.calendar_today),
        ),
        child: Text(
          DateFormat('dd/MM/yyyy HH:mm').format(_selectedDateTime),
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}