import 'package:flutter/material.dart';

class RowButtons extends StatelessWidget {
  const RowButtons({
    super.key,
    required this.formKey,
    required this.onSave,
    this.isSaving = false,
  });

  final GlobalKey<FormState> formKey;
  final Future<void> Function() onSave;
  final bool isSaving;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool useColumn = constraints.maxWidth < 420;

        if (useColumn) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CancelButton(onPressed: () => Navigator.of(context).maybePop()),
              const SizedBox(height: 10),
              _SaveButton(onPressed: isSaving ? null : onSave, isSaving: isSaving),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: _CancelButton(
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SaveButton(onPressed: isSaving ? null : onSave, isSaving: isSaving),
            ),
          ],
        );
      },
    );
  }
}

class _CancelButton extends StatelessWidget {
  const _CancelButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 52),
        side: const BorderSide(color: Color(0xFFBFDACC)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        backgroundColor: Colors.white.withValues(alpha: 0.75),
      ),
      child: const Text(
        'Cancel',
        style: TextStyle(color: Color(0xFF2D7A5C), fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.onPressed, required this.isSaving});

  final Future<void> Function()? onPressed;
  final bool isSaving;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(0, 52),
        backgroundColor: const Color(0xFF3D9970),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 0,
      ),
      child: isSaving
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_rounded, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Save Changes',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
