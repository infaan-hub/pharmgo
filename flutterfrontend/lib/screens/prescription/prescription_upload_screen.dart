import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/empty_state.dart';
import '../../providers/prescription_provider.dart';
import '../../models/prescription.dart';

class PrescriptionUploadScreen extends ConsumerStatefulWidget {
  const PrescriptionUploadScreen({super.key});

  @override
  ConsumerState<PrescriptionUploadScreen> createState() =>
      _PrescriptionUploadScreenState();
}

class _PrescriptionUploadScreenState
    extends ConsumerState<PrescriptionUploadScreen> {
  final _notesController = TextEditingController();
  final _picker = ImagePicker();
  final List<File> _selectedFiles = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(prescriptionListProvider.notifier).loadPrescriptions();
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() => _selectedFiles.add(File(pickedFile.path)));
    }
  }

  void _submitPrescriptions() async {
    if (_selectedFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one prescription'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    for (final file in _selectedFiles) {
      await ref.read(prescriptionListProvider.notifier).uploadPrescription(
            file,
            notes: _notesController.text.isNotEmpty ? _notesController.text : null,
          );
    }

    setState(() => _selectedFiles.clear());
    _notesController.clear();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Prescriptions uploaded successfully'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final prescriptionState = ref.watch(prescriptionListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(title: 'Upload Prescription'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUploadArea(),
            const SizedBox(height: 24),
            if (_selectedFiles.isNotEmpty) ...[
              Text('Selected Files', style: AppTextStyles.titleMedium),
              const SizedBox(height: 12),
              ...List.generate(_selectedFiles.length, (index) {
                return _buildSelectedFile(index);
              }),
              const SizedBox(height: 16),
            ],
            AppTextField(
              label: 'Notes (Optional)',
              hint: 'Add any notes for the pharmacist...',
              controller: _notesController,
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Submit Prescription',
              isLoading: prescriptionState.isLoading,
              onPressed: _submitPrescriptions,
            ),
            const SizedBox(height: 32),
            Text('Uploaded Prescriptions', style: AppTextStyles.titleMedium),
            const SizedBox(height: 12),
            _buildUploadedPrescriptions(prescriptionState),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadArea() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.divider,
          width: 1.5,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.cloud_upload_outlined,
            color: AppColors.primaryDark,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'Upload Your Prescription',
            style: AppTextStyles.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Take a photo or choose from gallery',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildUploadButton(
                Icons.camera_alt,
                'Camera',
                () => _pickImage(ImageSource.camera),
              ),
              const SizedBox(width: 16),
              _buildUploadButton(
                Icons.photo_library,
                'Gallery',
                () => _pickImage(ImageSource.gallery),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primaryDark,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              label.toUpperCase(),
              style: AppTextStyles.buttonText.copyWith(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedFile(int index) {
    final file = _selectedFiles[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          const Icon(Icons.description, color: AppColors.primaryDark, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.path.split('/').last,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  Formatters.formatFileSize(file.lengthSync()),
                  style: AppTextStyles.labelSmall,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _selectedFiles.removeAt(index)),
            child: const Icon(Icons.close, size: 18, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadedPrescriptions(PrescriptionListState state) {
    if (state.prescriptions.isEmpty) {
      return const EmptyState(
        icon: Icons.receipt_long,
        title: 'No prescriptions uploaded',
        subtitle: 'Upload your prescription to order medicines',
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.prescriptions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final prescription = state.prescriptions[index];
        return _buildPrescriptionItem(prescription);
      },
    );
  }

  Widget _buildPrescriptionItem(Prescription prescription) {
    Color statusColor;
    switch (prescription.status) {
      case PrescriptionStatus.approved:
        statusColor = AppColors.success;
        break;
      case PrescriptionStatus.rejected:
        statusColor = AppColors.error;
        break;
      default:
        statusColor = AppColors.accent;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              prescription.status == PrescriptionStatus.approved
                  ? Icons.check_circle
                  : prescription.status == PrescriptionStatus.rejected
                      ? Icons.cancel
                      : Icons.access_time,
              color: statusColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prescription.fileName ?? 'Prescription',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  prescription.statusLabel,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            Formatters.timeAgo(prescription.uploadedAt ?? DateTime.now()),
            style: AppTextStyles.labelSmall,
          ),
        ],
      ),
    );
  }
}
