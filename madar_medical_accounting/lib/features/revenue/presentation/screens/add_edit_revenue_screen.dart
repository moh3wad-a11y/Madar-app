import 'package:flutter/material.dart';
import 'package:madar_medical_accounting/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/validators.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';
import '../../../doctors/presentation/providers/doctor_providers.dart';
import '../../../patients/data/models/patient_model.dart';
import '../../../patients/presentation/widgets/patient_picker_sheet.dart';
import '../../../payment_accounts/presentation/providers/payment_account_providers.dart';
import '../../../services/presentation/providers/service_providers.dart';
import '../../data/models/revenue_transaction_model.dart';
import '../providers/revenue_providers.dart';

class AddEditRevenueScreen extends ConsumerStatefulWidget {
  final RevenueTransactionModel? existing;

  const AddEditRevenueScreen({super.key, this.existing});

  @override
  ConsumerState<AddEditRevenueScreen> createState() => _AddEditRevenueScreenState();
}

class _AddEditRevenueScreenState extends ConsumerState<AddEditRevenueScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _discountController = TextEditingController(text: '0');
  final _notesController = TextEditingController();

  DateTime _date = DateTime.now();
  String _time = DateFormatter.currentTime();
  int? _doctorId;
  int? _serviceId;
  int? _paymentMethodId;
  int? _selectedPatientId;
  String? _selectedPatientName;
  bool _submitting = false;
  bool _doctorTouchedByUser = false;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    if (existing != null) {
      _amountController.text = CurrencyFormatter.formatNumber(existing.grossAmount);
      _discountController.text = CurrencyFormatter.formatNumber(existing.discount);
      _notesController.text = existing.notes ?? '';
      _date = existing.date;
      _time = existing.time;
      _doctorId = existing.doctorId;
      _serviceId = existing.serviceId;
      _paymentMethodId = existing.paymentMethodId;
      _doctorTouchedByUser = true;
      _selectedPatientId = existing.patientId;
      _selectedPatientName = existing.patientName;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _discountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  double get _grossAmount => CurrencyFormatter.parse(_amountController.text) ?? 0;
  double get _discount => CurrencyFormatter.parse(_discountController.text) ?? 0;
  double get _netAmount => (_grossAmount - _discount) < 0 ? 0 : (_grossAmount - _discount);

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final parts = _time.split(':');
    final initial = TimeOfDay(
      hour: int.tryParse(parts[0]) ?? TimeOfDay.now().hour,
      minute: int.tryParse(parts.length > 1 ? parts[1] : '0') ?? TimeOfDay.now().minute,
    );
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked != null) {
      setState(() {
        _time = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> _pickPatient() async {
    final picked = await showModalBottomSheet<PatientModel>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const PatientPickerSheet(),
    );
    if (picked != null) {
      setState(() {
        _selectedPatientId = picked.id;
        _selectedPatientName = picked.name;
      });
    }
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    if (_doctorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.doctor)));
      return;
    }
    if (_serviceId == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.service)));
      return;
    }
    if (_paymentMethodId == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.paymentMethod)));
      return;
    }

    final user = ref.read(authProvider).currentUser;
    if (user == null || user.id == null) return;

    final repo = ref.read(revenueRepositoryProvider);

    if (!_isEditing) {
      final duplicate = await repo.hasLikelyDuplicate(
        patientId: _selectedPatientId,
        doctorId: _doctorId!,
        grossAmount: _grossAmount,
        date: _date,
      );
      if (duplicate && mounted) {
        final proceed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.possibleDuplicateTitle),
            content: Text(l10n.possibleDuplicateMessage),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.cancel)),
              FilledButton(
                  onPressed: () => Navigator.pop(context, true), child: Text(l10n.saveAnyway)),
            ],
          ),
        );
        if (proceed != true) return;
      }
    }

    setState(() => _submitting = true);
    try {
      if (_isEditing) {
        final updated = widget.existing!.copyWith(
          date: _date,
          time: _time,
          doctorId: _doctorId,
          serviceId: _serviceId,
          grossAmount: _grossAmount,
          discount: _discount,
          paymentMethodId: _paymentMethodId,
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
          modifiedBy: user.id,
          patientId: _selectedPatientId,
          clearPatient: _selectedPatientId == null,
        );
        await repo.update(updated);
      } else {
        final newTransaction = RevenueTransactionModel(
          transactionNo: '', // assigned inside the repository transaction
          date: _date,
          time: _time,
          patientId: _selectedPatientId,
          doctorId: _doctorId!,
          serviceId: _serviceId!,
          grossAmount: _grossAmount,
          discount: _discount,
          netAmount: _netAmount,
          paymentMethodId: _paymentMethodId!,
          doctorCommissionAmount: 0, // computed inside the repository transaction
          centerShareAmount: 0, // computed inside the repository transaction
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
          createdBy: user.id!,
          createdAt: DateTime.now(),
        );
        await repo.create(newTransaction);
      }

      ref.invalidate(revenueListProvider);
      ref.invalidate(dashboardSummaryProvider);

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
    final doctorsAsync = ref.watch(activeDoctorsProvider);
    final servicesAsync = ref.watch(activeServicesProvider);
    final methodsAsync = ref.watch(activePaymentMethodsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? l10n.editRevenue : l10n.addRevenue)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Expanded(
                  child: _PickerField(
                    label: l10n.date,
                    value: DateFormatter.toDisplay(_date),
                    icon: Icons.calendar_today_outlined,
                    onTap: _pickDate,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PickerField(
                    label: l10n.time,
                    value: _time,
                    icon: Icons.access_time,
                    onTap: _pickTime,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _PickerField(
              label: l10n.patientCustomer,
              value: _selectedPatientName ?? l10n.walkInPatient,
              icon: Icons.person_outline,
              onTap: _pickPatient,
              onClear: _selectedPatientId != null
                  ? () => setState(() {
                        _selectedPatientId = null;
                        _selectedPatientName = null;
                      })
                  : null,
            ),
            const SizedBox(height: 16),
            doctorsAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('${l10n.errorGeneric} ($e)'),
              data: (doctors) => DropdownButtonFormField<int>(
                value: doctors.any((d) => d.id == _doctorId) ? _doctorId : null,
                decoration: InputDecoration(
                  labelText: l10n.doctor,
                  prefixIcon: const Icon(Icons.medical_services_outlined),
                ),
                items: doctors
                    .map((d) => DropdownMenuItem(value: d.id, child: Text(d.name, overflow: TextOverflow.ellipsis)))
                    .toList(),
                onChanged: (value) => setState(() {
                  _doctorId = value;
                  _doctorTouchedByUser = true;
                }),
                validator: (value) => value == null ? l10n.requiredField : null,
              ),
            ),
            const SizedBox(height: 16),
            servicesAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('${l10n.errorGeneric} ($e)'),
              data: (services) => DropdownButtonFormField<int>(
                value: services.any((s) => s.id == _serviceId) ? _serviceId : null,
                decoration: InputDecoration(
                  labelText: l10n.service,
                  prefixIcon: const Icon(Icons.medical_information_outlined),
                ),
                items: services
                    .map((s) => DropdownMenuItem(value: s.id, child: Text(s.name, overflow: TextOverflow.ellipsis)))
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  final service = services.firstWhere((s) => s.id == value);
                  setState(() {
                    _serviceId = value;
                    _amountController.text = CurrencyFormatter.formatNumber(service.price);
                    if (!_doctorTouchedByUser && service.doctorId != null) {
                      _doctorId = service.doctorId;
                    }
                  });
                },
                validator: (value) => value == null ? l10n.requiredField : null,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              decoration:
                  InputDecoration(labelText: l10n.grossAmount, prefixIcon: const Icon(Icons.payments_outlined)),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) => Validators.nonNegativeAmount(v, fieldName: l10n.amount),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _discountController,
              decoration: InputDecoration(labelText: l10n.discount, prefixIcon: const Icon(Icons.percent)),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) => Validators.discountNotExceedingGross(v, _grossAmount),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.netRevenue),
                  Text(CurrencyFormatter.format(_netAmount), style: const TextStyle(fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            methodsAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('${l10n.errorGeneric} ($e)'),
              data: (methods) => DropdownButtonFormField<int>(
                value: methods.any((m) => m.id == _paymentMethodId) ? _paymentMethodId : null,
                decoration: InputDecoration(
                  labelText: l10n.paymentMethod,
                  prefixIcon: const Icon(Icons.credit_card_outlined),
                ),
                items: methods.map((m) => DropdownMenuItem(value: m.id, child: Text(m.name))).toList(),
                onChanged: (value) => setState(() => _paymentMethodId = value),
                validator: (value) => value == null ? l10n.requiredField : null,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(labelText: l10n.notesOptional, prefixIcon: const Icon(Icons.notes_outlined)),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(_isEditing ? l10n.saveChanges : l10n.saveRevenue),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _PickerField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const _PickerField({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          suffixIcon: onClear != null
              ? IconButton(icon: const Icon(Icons.close, size: 18), onPressed: onClear)
              : const Icon(Icons.chevron_right),
        ),
        child: Text(value, overflow: TextOverflow.ellipsis, maxLines: 1),
      ),
    );
  }
}
