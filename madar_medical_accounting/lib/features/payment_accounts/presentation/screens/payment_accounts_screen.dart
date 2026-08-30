import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../data/models/payment_account_model.dart';
import '../providers/payment_account_providers.dart';

class PaymentAccountsScreen extends ConsumerWidget {
  const PaymentAccountsScreen({super.key});

  IconData _iconFor(String accountType) {
    switch (accountType) {
      case 'cash':
        return Icons.payments_outlined;
      case 'bank':
        return Icons.account_balance_outlined;
      case 'visa':
      case 'mastercard':
        return Icons.credit_card_outlined;
      case 'instapay':
        return Icons.qr_code_2_outlined;
      default:
        return Icons.account_balance_wallet_outlined;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final accountsAsync = ref.watch(allPaymentAccountsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.paymentAccountsTitle)),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(allPaymentAccountsProvider),
        child: accountsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => ListView(
            children: [const SizedBox(height: 60), Center(child: Text('${l10n.errorGeneric} ($e)'))],
          ),
          data: (accounts) {
            final total = accounts.fold<double>(0, (sum, a) => sum + a.currentBalance);
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.profitColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        l10n.totalAcrossAccounts,
                        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        CurrencyFormatter.format(total),
                        style: theme.textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w700, color: AppTheme.profitColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(l10n.byAccount, style: theme.textTheme.titleSmall),
                const SizedBox(height: 10),
                ...accounts.map((account) => _AccountTile(
                      account: account,
                      icon: _iconFor(account.accountType),
                      openingBalanceLabel: l10n.openingBalance,
                    )),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    l10n.accountsAutoUpdateNote,
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _AccountTile extends StatelessWidget {
  final PaymentAccountModel account;
  final IconData icon;
  final String openingBalanceLabel;

  const _AccountTile({required this.account, required this.icon, required this.openingBalanceLabel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNegative = account.currentBalance < 0;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(icon, color: theme.colorScheme.onPrimaryContainer),
        ),
        title: Text(account.name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('$openingBalanceLabel: ${CurrencyFormatter.format(account.openingBalance)}'),
        trailing: Text(
          CurrencyFormatter.format(account.currentBalance),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: isNegative ? theme.colorScheme.error : AppTheme.revenueColor,
          ),
        ),
      ),
    );
  }
}
