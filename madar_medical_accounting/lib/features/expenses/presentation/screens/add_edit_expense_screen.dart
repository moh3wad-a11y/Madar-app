import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/validators.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';
import '../../../payment_accounts/presentation/providers/payment_account_providers.dart';
import '../../../suppliers/data/models/supplier_model.dart';
import '../../../suppliers/presentation/widgets/supplier_picker_sheet.dart';
import '../../data/models/expense_transaction_model.dart';
import '../providers/expense_category_providers.dart';
import '../providers/expense_providers.dart';

class AddEditExpenseScreen extends ConsumerStatefulWidget {
  final ExpenseTransactionModel? existing;

  const AddEditExpenseScreen({super.key, this.existing});

  @override
  ConsumerState<AddEditExpenseScreen> createState() => _AddEditExpenseScreenState();
}

class _AddEditExpenseScreenState extends ConsumerState<AddEditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _invoiceController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _date = DateTime.now();
  int? _categoryId;
  int? _paymentMethodId;
  int? _selectedSupplierId;
  String? _selectedSupplierName;
  bool _submitting = false;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    if (existing != null) {
      _amountController.text = CurrencyFormatter.formatNumber(existing.amount);
      _descriptionController.text = existing.description ?? '';
      _invoiceController.text = existing.invoiceNumber ?? '';
      _notesController.text = existing.notes ?? '';
      _date = existing.date;
      _categoryId = existing.categoryId;
      _paymentMethodId = existing.paymentMethodId;
      _selectedSupplierId = existing.supplierId;
      _selectedSupplierName = existing.supplierName;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _invoiceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  double get _amount => CurrencyFormatter.parse(_amountController.text) ?? 0;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickSupplier() async {
    final picked = await showModalBottomSheet<SupplierModel>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const SupplierPickerSheet(),
    );
    if (picked != null) {
      setState(() {
        _selectedSupplierId = picked.id;
        _selectedSupplierName = picked.name;
      });
    }
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    if (_categoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.expenseCategory)));
      return;
    }
    if (_paymentMethodId == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.paymentMethod)));
      return;
    }

    final user = ref.read(authProvider).currentUser;
    if (user == null || user.id == null) return;

    setState(() => _submitting = true);
    try {
      final repo = ref.read(expenseRepositoryProvider);

      if (_isEditing) {
        final updated = widget.existing!.copyWith(
          date: _date,
          categoryId: _categoryId,
          supplierId: _selectedSupplierId,
          clearSupplier: _selectedSupplierId == null,
          description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
          amount: _amount,
          paymentMethodId: _paymentMethodId,
          invoiceNumber: _invoiceController.text.trim().isEmpty ? null : _invoiceController.text.trim(),
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
          modifiedBy: user.id,
        );
        await repo.update(updated);
      } else {
        final newExpense = ExpenseTransactionModel(
          expenseNo: '', // assigned inside the repository transaction
          date: _date,
          categoryId: _categoryId!,
          supplierId: _selectedSupplierId,
          description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
          amount: _amount,
          paymentMethodId: _paymentMethodId!,
          invoiceNumber: _invoiceController.text.trim().isEmpty ? null : _invoiceController.text.trim(),
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
          createdBy: user.id!,
          createdAt: DateTime.now(),
        );
        await repo.create(newExpense);
      }

      ref.invalidate(expenseListProvider);
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
    final categoriesAsync = ref.watch(activeExpenseCategoriesProvider);
    final methodsAsync = ref.watch(activePaymentMethodsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? l10n.editExpense : l10n.addExpense)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _pickDate,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: l10n.date,
                  prefixIcon: const Icon(Icons.calendar_today_outlined),
                  suffixIcon: const Icon(Icons.chevron_right),
                ),
                child: Text(DateFormatter.toDisplay(_date)),
              ),
            ),
            const SizedBox(height: 16),
            categoriesAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('${l10n.errorGeneric} ($e)'),
              data: (categories) => DropdownButtonFormField<int>(
                value: categories.any((c) => c.id == _categoryId) ? _categoryId : null,
                decoration: InputDecoration(
                  labelText: l10n.expenseCategory,
                  prefixIcon: const Icon(Icons.category_outlined),
                ),
                items: categories
                    .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name, overflow: TextOverflow.ellipsis)))
                    .toList(),
                onChanged: (value) => setState(() => _categoryId = value),
                validator: (value) => value == null ? l10n.requiredField : null,
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _pickSupplier,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: l10n.supplierOptional,
                  prefixIcon: const Icon(Icons.local_shipping_outlined),
                  suffixIcon: _selectedSupplierId != null
                      ? IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () => setState(() {
                            _selectedSupplierId = null;
                            _selectedSupplierName = null;
                          }),
                        )
                      : const Icon(Icons.chevron_right),
                ),
                child: Text(_selectedSupplierName ?? l10n.noSupplier, overflow: TextOverflow.ellipsis),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: l10n.description, prefixIcon: const Icon(Icons.description_outlined)),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              decoration:
                  InputDecoration(labelText: l10n.grossAmount, prefixIcon: const Icon(Icons.payments_outlined)),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) => Validators.positiveAmount(v, fieldName: l10n.amount),
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
              controller: _invoiceController,
              decoration: InputDecoration(labelText: l10n.invoiceNumberOptional, prefixIcon: const Icon(Icons.receipt_outlined)),
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
                  : Text(_isEditing ? l10n.saveChanges : l10n.saveExpense),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
