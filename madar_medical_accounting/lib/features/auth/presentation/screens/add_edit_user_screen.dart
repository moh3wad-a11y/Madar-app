import 'package:flutter/material.dart';
import 'package:madar_medical_accounting/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/utils/validators.dart';
import '../../data/models/user_model.dart';
import '../providers/auth_provider.dart';
import '../providers/role_providers.dart';

class AddEditUserScreen extends ConsumerStatefulWidget {
  final UserModel? existing;

  const AddEditUserScreen({super.key, this.existing});

  @override
  ConsumerState<AddEditUserScreen> createState() => _AddEditUserScreenState();
}

class _AddEditUserScreenState extends ConsumerState<AddEditUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  int? _roleId;
  bool _isActive = true;
  bool _submitting = false;
  bool _showResetPassword = false;
  bool _obscurePassword = true;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    if (existing != null) {
      _usernameController.text = existing.username;
      _fullNameController.text = existing.fullName;
      _roleId = existing.roleId;
      _isActive = existing.isActive;
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _fullNameController.dispose();
    _passwordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    if (_roleId == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.role)));
      return;
    }

    setState(() => _submitting = true);
    try {
      final repo = ref.read(authRepositoryProvider);

      if (_isEditing) {
        await repo.updateUser(
          widget.existing!.copyWith(fullName: _fullNameController.text.trim(), roleId: _roleId),
        );
        if (widget.existing!.isActive != _isActive) {
          await repo.setUserActive(widget.existing!.id!, _isActive);
        }
        if (_showResetPassword && _newPasswordController.text.isNotEmpty) {
          await repo.resetPassword(widget.existing!.id!, _newPasswordController.text);
        }
      } else {
        await repo.createUser(
          UserModel(
            username: _usernameController.text.trim(),
            passwordHash: '',
            salt: '',
            fullName: _fullNameController.text.trim(),
            roleId: _roleId!,
            roleName: '',
            isActive: _isActive,
            createdAt: DateTime.now(),
          ),
          _passwordController.text,
        );
      }

      if (mounted) Navigator.of(context).pop(true);
    } on AppException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${l10n.errorGeneric} ($e)')));
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final rolesAsync = ref.watch(rolesProvider);
    final currentUserId = ref.watch(authProvider).currentUser?.id;
    final isEditingSelf = _isEditing && widget.existing!.id == currentUserId;

    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? l10n.editUser : l10n.addUser)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _usernameController,
              enabled: !_isEditing,
              decoration: InputDecoration(labelText: l10n.username, prefixIcon: const Icon(Icons.person_outline)),
              validator: Validators.username,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _fullNameController,
              decoration: InputDecoration(labelText: l10n.fullName, prefixIcon: const Icon(Icons.badge_outlined)),
              validator: (v) => Validators.required(v, fieldName: l10n.fullName),
            ),
            if (!_isEditing) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: l10n.passwordLabel,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                validator: Validators.password,
              ),
            ],
            const SizedBox(height: 16),
            rolesAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('${l10n.errorGeneric} ($e)'),
              data: (roles) => DropdownButtonFormField<int>(
                value: roles.any((r) => r.id == _roleId) ? _roleId : null,
                decoration: InputDecoration(labelText: l10n.role, prefixIcon: const Icon(Icons.security_outlined)),
                items: roles.map((r) => DropdownMenuItem(value: r.id, child: Text(r.name))).toList(),
                onChanged: isEditingSelf ? null : (value) => setState(() => _roleId = value),
                validator: (value) => value == null ? l10n.requiredField : null,
              ),
            ),
            if (isEditingSelf) ...[
              const SizedBox(height: 4),
              Text(
                l10n.cannotChangeOwnRole,
                style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.outline),
              ),
            ],
            const SizedBox(height: 16),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.active),
              subtitle: Text(l10n.inactiveUsersCannotSignIn),
              value: _isActive,
              onChanged: isEditingSelf ? null : (value) => setState(() => _isActive = value),
            ),
            if (_isEditing) ...[
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () => setState(() => _showResetPassword = !_showResetPassword),
                icon: Icon(_showResetPassword ? Icons.close : Icons.lock_reset_outlined),
                label: Text(_showResetPassword ? l10n.cancelPasswordReset : l10n.resetPassword),
              ),
              if (_showResetPassword) ...[
                const SizedBox(height: 8),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(labelText: l10n.newPassword, prefixIcon: const Icon(Icons.lock_outline)),
                  validator: (v) => _showResetPassword ? Validators.password(v) : null,
                ),
              ],
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(_isEditing ? l10n.saveChanges : l10n.addUser),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
