import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/constants/colors.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final _firstNameController = TextEditingController(text: 'John');
  final _lastNameController = TextEditingController(text: 'Doe');
  final _emailController = TextEditingController(text: 'john.doe@example.com');
  final _phoneController = TextEditingController(text: '+1 (555) 123-4567');
  final _addressController =
      TextEditingController(text: '123 Main St, City, State');

  // User preferences
  String _selectedGender = 'Male';
  DateTime _selectedBirthDate = DateTime(1990, 1, 1);
  String _selectedCountry = 'India';

  final List<String> _genders = [
    'Male',
    'Female',
    'Other',
    'Prefer not to say'
  ];
  final List<String> _countries = [
    'India',
    'United States',
    'Canada',
    'United Kingdom',
    'Germany',
    'France',
    'Japan',
    'Australia',
    'Other'
  ];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Information'),
        backgroundColor: TColors.primary,
        foregroundColor: TColors.textWhite,
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.floppyDisk),
            onPressed: _saveUserInfo,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture Section
              _buildProfilePictureSection(),
              const SizedBox(height: 24),

              // Basic Information
              _buildSectionHeader('Basic Information'),
              _buildTextFormField(
                controller: _firstNameController,
                label: 'First Name',
                icon: FontAwesomeIcons.user,
                validator: (value) =>
                    value?.isEmpty == true ? 'Required' : null,
              ),
              _buildTextFormField(
                controller: _lastNameController,
                label: 'Last Name',
                icon: FontAwesomeIcons.user,
                validator: (value) =>
                    value?.isEmpty == true ? 'Required' : null,
              ),
              _buildTextFormField(
                controller: _emailController,
                label: 'Email',
                icon: FontAwesomeIcons.envelope,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value?.isEmpty == true) return 'Required';
                  if (!value!.contains('@')) return 'Invalid email';
                  return null;
                },
              ),
              _buildTextFormField(
                controller: _phoneController,
                label: 'Phone Number',
                icon: FontAwesomeIcons.phone,
                keyboardType: TextInputType.phone,
              ),
              _buildDropdownField(
                label: 'Gender',
                value: _selectedGender,
                items: _genders,
                icon: FontAwesomeIcons.venusMars,
                onChanged: (value) => setState(() => _selectedGender = value!),
              ),
              _buildDateField(),
              const SizedBox(height: 24),

              // Contact Information
              _buildSectionHeader('Contact Information'),
              _buildTextFormField(
                controller: _addressController,
                label: 'Address',
                icon: FontAwesomeIcons.locationDot,
                maxLines: 2,
              ),
              _buildDropdownField(
                label: 'Country',
                value: _selectedCountry,
                items: _countries,
                icon: FontAwesomeIcons.globe,
                onChanged: (value) => setState(() => _selectedCountry = value!),
              ),
              const SizedBox(height: 24),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveUserInfo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.primary,
                    foregroundColor: TColors.textWhite,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: TColors.primary,
            ),
      ),
    );
  }

  Widget _buildProfilePictureSection() {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: TColors.containerPrimary,
                child: FaIcon(
                  FontAwesomeIcons.user,
                  size: 60,
                  color: TColors.primary,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _changeProfilePicture,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: TColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.camera,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '${_firstNameController.text} ${_lastNameController.text}',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            _emailController.text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: TColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: FaIcon(icon, size: 20, color: TColors.primary),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: TColors.containerPrimary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: TColors.containerPrimary),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: TColors.primary, width: 2),
          ),
          filled: true,
          fillColor: TColors.containerPrimary.withValues(alpha: 0.3),
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: TColors.containerPrimary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TColors.containerPrimary),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          children: [
            FaIcon(icon, size: 20, color: TColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: value,
                decoration: InputDecoration(
                  labelText: label,
                  border: InputBorder.none,
                ),
                items: items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: TColors.containerPrimary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TColors.containerPrimary),
      ),
      child: ListTile(
        leading: FaIcon(
          FontAwesomeIcons.calendar,
          size: 20,
          color: TColors.primary,
        ),
        title: const Text('Birth Date'),
        subtitle: Text(
          '${_selectedBirthDate.day}/${_selectedBirthDate.month}/${_selectedBirthDate.year}',
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: _selectBirthDate,
      ),
    );
  }

  // Action handlers
  void _changeProfilePicture() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Change Profile Picture',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageOption(
                  'Camera',
                  FontAwesomeIcons.camera,
                  () {
                    Navigator.pop(context);
                    _takePicture();
                  },
                ),
                _buildImageOption(
                  'Gallery',
                  FontAwesomeIcons.image,
                  () {
                    Navigator.pop(context);
                    _pickFromGallery();
                  },
                ),
                _buildImageOption(
                  'Remove',
                  FontAwesomeIcons.trash,
                  () {
                    Navigator.pop(context);
                    _removeProfilePicture();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageOption(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: TColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: TColors.primary.withValues(alpha: 0.3)),
            ),
            child: FaIcon(
              icon,
              size: 24,
              color: TColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  void _takePicture() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Camera functionality would be implemented here')),
    );
  }

  void _pickFromGallery() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Gallery picker would be implemented here')),
    );
  }

  void _removeProfilePicture() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile picture removed')),
    );
  }

  void _selectBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: TColors.primary,
              onPrimary: TColors.textWhite,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = picked;
      });
    }
  }

  void _saveUserInfo() {
    if (_formKey.currentState?.validate() ?? false) {
      // Here you would typically save to your backend or local storage
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('User information saved successfully!'),
          backgroundColor: TColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }
}
