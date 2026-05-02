import 'package:flutter/material.dart';
import 'package:psychora/core/network/api_service.dart';
import 'package:psychora/core/styles/form_styles.dart';
import 'package:psychora/features/profile_page/data/user_profile_model.dart';
import 'package:psychora/features/edit_profile/presentation/widget/labelfield.dart';
import 'package:psychora/features/edit_profile/presentation/widget/profile_hero_card.dart';
import 'package:psychora/features/edit_profile/presentation/widget/row_buttons.dart';
import 'package:psychora/features/edit_profile/presentation/widget/section_card.dart';
import 'package:psychora/features/edit_profile/presentation/widget/text_editprofile.dart';

class EditProfileForm extends StatefulWidget {
  const EditProfileForm({super.key});

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _specialityController = TextEditingController();
  final _hospitalController = TextEditingController();
  int _yearsOfExperience = 0;
  String _bio = '';
  late Future<void> _loadUserFuture;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadUserFuture = _loadUserData();
  }

  Future<void> _loadUserData() async {
    final Map<String, dynamic> payload = await _apiService.getCurrentUserData();
    final UserProfileModel profile = UserProfileModel.fromApi(payload);

    if (!mounted) {
      return;
    }

    _fullNameController.text = profile.fullName;
    _emailController.text = profile.email;
    _phoneController.text = profile.phone == 'N/A' ? '' : profile.phone;
    _locationController.text = profile.location == 'N/A' ? '' : profile.location;
    _specialityController.text =
        profile.specialization == 'N/A' ? '' : profile.specialization;
    _hospitalController.text = profile.hospital;
    _yearsOfExperience = profile.yearsOfExperience;
    _bio = profile.bio;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _specialityController.dispose();
    _hospitalController.dispose();
    super.dispose();
  }

  String? _requiredField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  Future<void> _handleSaveProfile() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await _apiService.updateCurrentUserProfile(
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        location: _locationController.text.trim(),
        specialty: _specialityController.text.trim(),
        hospital: _hospitalController.text.trim(),
        yearsOfExperience: _yearsOfExperience,
        bio: _bio,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: Color(0xFF2D7A5C),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.of(context).maybePop();
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update profile on server.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: FutureBuilder<void>(
        future: _loadUserFuture,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF3D9970),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 48,
                      color: Color(0xFFDC2626),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Unable to load your information.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _loadUserFuture = _loadUserData();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3D9970),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          return Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFF0F9F6),
                      Color(0xFFFBFDFC),
                      Color(0xFFF5F8FA),
                    ],
                    stops: [0.0, 0.5, 1.0],
                  ),
                ),
              ),
              Positioned(
                top: -80,
                left: -80,
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF3D9970).withValues(alpha: 0.09),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF3D9970).withValues(alpha: 0.05),
                        blurRadius: 70,
                        spreadRadius: 15,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: -120,
                right: -80,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF2D7A5C).withValues(alpha: 0.07),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2D7A5C).withValues(alpha: 0.04),
                        blurRadius: 80,
                        spreadRadius: 20,
                      ),
                    ],
                  ),
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(context).maybePop(),
                            icon: const Icon(Icons.arrow_back_ios_new_rounded),
                            color: const Color(0xFF1F2937),
                          ),
                          const Expanded(child: TextEditprofile()),
                          const SizedBox(width: 48),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                          20,
                          8,
                          20,
                          size.width < 380 ? 20 : 28,
                        ),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 680),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  ProfileHeroCard(
                                    fullName: _fullNameController.text,
                                    email: _emailController.text,
                                  ),
                                  const SizedBox(height: 20),
                                  SectionCard(
                                    title: 'Personal Information',
                                    subtitle:
                                        'Keep your profile details up to date.',
                                    child: Column(
                                      children: [
                                        LabeledField(
                                          label: 'Full Name',
                                          child: TextFormField(
                                            controller: _fullNameController,
                                            onChanged: (_) => setState(() {}),
                                            style: FormStyles.inputTextStyle,
                                            validator: _requiredField,
                                            decoration:
                                                FormStyles.baseDecoration(
                                              icon:
                                                  Icons.person_outline_rounded,
                                              hint: 'Enter your full name',
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 14),
                                        LabeledField(
                                          label: 'Email',
                                          child: TextFormField(
                                            controller: _emailController,
                                            onChanged: (_) => setState(() {}),
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            style: FormStyles.inputTextStyle,
                                            validator: _requiredField,
                                            decoration:
                                                FormStyles.baseDecoration(
                                              icon: Icons.email_outlined,
                                              hint: 'Enter your email',
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 14),
                                        LabeledField(
                                          label: 'Phone Number',
                                          child: TextFormField(
                                            controller: _phoneController,
                                            keyboardType: TextInputType.phone,
                                            style: FormStyles.inputTextStyle,
                                            validator: _requiredField,
                                            decoration:
                                                FormStyles.baseDecoration(
                                              icon: Icons.call_outlined,
                                              hint: 'Enter your phone number',
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 14),
                                        LabeledField(
                                          label: 'Location',
                                          child: TextFormField(
                                            controller: _locationController,
                                            style: FormStyles.inputTextStyle,
                                            validator: _requiredField,
                                            decoration:
                                                FormStyles.baseDecoration(
                                              icon:
                                                  Icons.location_on_outlined,
                                              hint: 'Enter your location',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  SectionCard(
                                    title: 'Professional Details',
                                    subtitle:
                                        'Show your role and expertise clearly.',
                                    child: Column(
                                      children: [
                                        LabeledField(
                                          label: 'Speciality',
                                          child: TextFormField(
                                            controller: _specialityController,
                                            style: FormStyles.inputTextStyle,
                                            validator: _requiredField,
                                            decoration:
                                                FormStyles.baseDecoration(
                                              icon: Icons
                                                  .workspace_premium_outlined,
                                              hint:
                                                  'Example: Clinical Psychology',
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 14),
                                        LabeledField(
                                          label: 'Hospital / Clinic',
                                          child: TextFormField(
                                            controller: _hospitalController,
                                            style: FormStyles.inputTextStyle,
                                            validator: _requiredField,
                                            decoration:
                                                FormStyles.baseDecoration(
                                              icon: Icons.local_hospital_outlined,
                                              hint: 'Enter your workplace',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  RowButtons(
                                    formKey: _formKey,
                                    onSave: _handleSaveProfile,
                                    isSaving: _isSaving,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
