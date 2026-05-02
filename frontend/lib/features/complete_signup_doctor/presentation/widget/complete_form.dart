import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:psychora/core/constants/route_name.dart';
import 'package:psychora/core/network/api_service.dart';
import 'package:psychora/features/complete_signup_doctor/presentation/widget/action_button.dart';
import 'package:psychora/features/complete_signup_doctor/presentation/widget/backtosignup.dart';
import 'package:psychora/features/complete_signup_doctor/presentation/widget/professional_input_field.dart';
import 'package:psychora/features/complete_signup_doctor/presentation/widget/profile_header.dart';
import 'package:psychora/features/complete_signup_doctor/presentation/widget/progress_bar.dart';
import 'package:psychora/core/validators/eight_digit_validator.dart';
import 'package:psychora/core/validators/validation_patterns.dart';
import 'package:psychora/features/chatbot_interface/data/chat_conversation_store.dart';
import 'package:psychora/features/patient_dashboard/data/patient_notes_store.dart';
import 'package:psychora/features/patient_dashboard/data/patient_store.dart';

class CompleteProfiledoctor extends StatefulWidget {
  const CompleteProfiledoctor({super.key, this.signupData});

  final Map<String, dynamic>? signupData;

  @override
  State<CompleteProfiledoctor> createState() => _CompleteProfiledoctorState();
}

class _CompleteProfiledoctorState extends State<CompleteProfiledoctor> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _specialtyController;
  late final TextEditingController _idCardController;
  late final TextEditingController _hospitalController;
  late final TextEditingController _locationController;
  late final TextEditingController _phoneController;
  late final TextEditingController _experienceController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _specialtyController = TextEditingController();
    _idCardController = TextEditingController();
    _hospitalController = TextEditingController();
    _locationController = TextEditingController();
    _phoneController = TextEditingController();
    _experienceController = TextEditingController(text: '0');

    // Listen to all controllers to trigger form state updates
    _specialtyController.addListener(() => setState(() {}));
    _idCardController.addListener(() => setState(() {}));
    _hospitalController.addListener(() => setState(() {}));
    _locationController.addListener(() => setState(() {}));
    _phoneController.addListener(() => setState(() {}));
    _experienceController.addListener(() => setState(() {}));
  }

  String? _validateHospital(String? value) {
    if (value == null || value.isEmpty) {
      return 'Hospital is required';
    }
    return null;
  }

  String? _validateLocation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Location is required';
    }
    return null;
  }

  @override
  void dispose() {
    _specialtyController.dispose();
    _idCardController.dispose();
    _hospitalController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  Future<void> _handleCompleteProfile() async {
    if (!_formKey.currentState!.validate() || _isSubmitting) {
      return;
    }

    final fullName = widget.signupData?['fullName'] as String?;
    final email = widget.signupData?['email'] as String?;
    final password = widget.signupData?['password'] as String?;

    if (fullName == null || email == null || password == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Signup data is missing. Please sign up again.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final yearsOfExperience = int.tryParse(_experienceController.text) ?? 0;

      // Vider toutes les données de l'ancien compte avant de créer le nouveau
      PatientStore().clearAll();
      PatientNotesStore().clearAll();
      ChatConversationStore().clearAll();
      await ApiService().clearAuthToken();

      await ApiService().signupPsychologist(
        fullName: fullName,
        email: email,
        password: password,
        specialty: _specialtyController.text.trim(),
        idCard: _idCardController.text.trim(),
        hospital: _hospitalController.text.trim(),
        location: _locationController.text.trim(),
        phone: _phoneController.text.trim(),
        yearsOfExperience: yearsOfExperience,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Psychologist account created successfully.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.goNamed(RouteName.loginName);
    } on DioException catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_resolveApiErrorMessage(error)),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unexpected error during profile completion.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  String _resolveApiErrorMessage(DioException error) {
    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.trim().isNotEmpty) {
        return message;
      }
    }

    return 'Unable to create psychologist account. Please try again.';
  }

  bool _isFormValid() {
    final experienceValue = int.tryParse(_experienceController.text) ?? 0;
    return _specialtyController.text.isNotEmpty &&
        ValidationPatterns.isValidIdCard(_idCardController.text) &&
        _hospitalController.text.isNotEmpty &&
        _locationController.text.isNotEmpty &&
        ValidationPatterns.isValidPhone(_phoneController.text) &&
        experienceValue > 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),

              /// Profile Header
              const ProfileHeader(
                title: "Complete Your Profile",
                subtitle: "Professional information for doctors",
              ),

              const SizedBox(height: 24),

              /// Progress Bar
              const ProgressBar(currentStep: 2, totalSteps: 2, percentage: 1.0),

              const SizedBox(height: 32),

              /// Form Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Specialty dropdown attached to the field (menu opens under the field)
                      const Text(
                        'SPECIALTY',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Builder(
                        builder: (ctx) {
                          final hasValue = _specialtyController.text.isNotEmpty;
                          return DropdownButtonFormField<String>(
                            value: hasValue ? _specialtyController.text : null,
                            isExpanded: true,
                            hint: const Text(
                              'Select your specialty',
                              style: TextStyle(
                                color: Color(0xFFD1D5DB),
                                fontSize: 15,
                              ),
                            ),
                            style: const TextStyle(
                              color: Color(0xFF1F2937),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.badge_outlined,
                                color: Color(0xFF9CA3AF),
                                size: 20,
                              ),
                              filled: true,
                              fillColor: const Color(0xFFFAFAFA),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 14,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: hasValue
                                    ? const BorderSide(
                                        color: Color(0xFF3D9970),
                                        width: 1.5,
                                      )
                                    : const BorderSide(
                                        color: Color(0xFFE5E7EB),
                                        width: 1.2,
                                      ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(0xFF3D9970),
                                  width: 1.5,
                                ),
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'Psychiatry',
                                child: Text('Psychiatry'),
                              ),
                              DropdownMenuItem(
                                value: 'Clinical Psychology',
                                child: Text('Clinical Psychology'),
                              ),
                              DropdownMenuItem(
                                value: 'Neuropsychology',
                                child: Text('Neuropsychology'),
                              ),
                              DropdownMenuItem(
                                value: 'Child Psychology',
                                child: Text('Child Psychology'),
                              ),
                            ],
                            onChanged: (v) => setState(
                              () => _specialtyController.text = v ?? '',
                            ),
                            validator: (v) => (v == null || v.isEmpty)
                                ? 'Please select a specialty'
                                : null,
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      ProfessionalInputField(
                        label: "ID CARD NUMBER",
                        hint: "your national ID",
                        icon: Icons.credit_card_outlined,
                        controller: _idCardController,
                        keyboardType: TextInputType.number,
                        validator: EightDigitValidator.validate,
                      ),
                      ProfessionalInputField(
                        label: "HOSPITAL/CLINIC",
                        hint: "Your workplace",
                        icon: Icons.local_hospital_outlined,
                        controller: _hospitalController,
                        validator: _validateHospital,
                      ),
                      ProfessionalInputField(
                        label: "LOCATION",
                        hint: "City, Country",
                        icon: Icons.location_on_outlined,
                        controller: _locationController,
                        validator: _validateLocation,
                      ),
                      ProfessionalInputField(
                        label: "PHONE NUMBER",
                        hint: "00 000 000",
                        icon: Icons.phone_outlined,
                        controller: _phoneController,
                        hintStyle: TextStyle(
                          // ignore: deprecated_member_use
                          color: Colors.grey.withOpacity(0.7),
                        ),
                        keyboardType: TextInputType.number,
                        validator: EightDigitValidator.validate,
                      ),

                      // Years of experience counter
                      const Text(
                        'YEARS OF EXPERIENCE',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAFAFA),
                          border: Border.all(
                            color: const Color(0xFFE5E7EB),
                            width: 1.2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () => setState(() {
                                    final v =
                                        int.tryParse(
                                          _experienceController.text,
                                        ) ??
                                        0;
                                    final next = (v - 1).clamp(0, 100);
                                    _experienceController.text = next
                                        .toString();
                                  }),
                                  icon: const Icon(
                                    Icons.remove_circle_outline,
                                    color: Color(0xFF9CA3AF),
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _experienceController.text.isEmpty
                                      ? '0'
                                      : _experienceController.text,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF1F2937),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  onPressed: () => setState(() {
                                    final v =
                                        int.tryParse(
                                          _experienceController.text,
                                        ) ??
                                        0;
                                    final next = (v + 1).clamp(0, 100);
                                    _experienceController.text = next
                                        .toString();
                                  }),
                                  icon: const Icon(
                                    Icons.add_circle_outline,
                                    color: Color(0xFF3D9970),
                                    size: 22,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'years',

                              style: TextStyle(
                                // ignore: deprecated_member_use
                                color: Colors.grey.withOpacity(0.7),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      ActionButton(
                        label: _isSubmitting
                            ? 'Creating account...'
                            : "Complete Profile",
                        onPressed: _handleCompleteProfile,
                        isEnabled: _isFormValid() && !_isSubmitting,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Backtosignup(),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
