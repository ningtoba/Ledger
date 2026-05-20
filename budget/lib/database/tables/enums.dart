enum BudgetReoccurence { custom, daily, weekly, monthly, yearly }

enum TransactionSpecialType {
  upcoming,
  subscription,
  repetitive,
  credit, //lent, withdraw, owed
  debt, //borrowed, deposit, owe
}

enum ObjectiveType {
  goal,
  loan, //income==true ? lent (loan) : borrowed
}

enum SharedOwnerMember {
  owner,
  member,
}

enum ExpenseIncome {
  income,
  expense,
}

enum PaidStatus {
  paid,
  notPaid,
  skipped,
}

// You should explain what each one does to the user in ViewBudgetTransactionFilterInfo
// Implement the default and behavior here: onlyShowIfFollowsFilters
// Also add the default to the onboarding page budget creation: OnBoardingPageBodyState
enum BudgetTransactionFilters {
  addedToOtherBudget,
  sharedToOtherBudget,
  includeIncome, //disabled by default (as set by the function below: isFilterSelectedWithDefaults -> offByDefault)
  includeDebtAndCredit, //disabled by default (as set by the function below:isFilterSelectedWithDefaults ->  offByDefault)
  addedToObjective,
  defaultBudgetTransactionFilters, //if default is in the list, use the default behavior
  includeBalanceCorrection, //disabled by default
}

enum HomePageWidgetDisplay {
  WalletSwitcher,
  WalletList,
  NetWorth,
  AllSpendingSummary, //Income/Expense homescreen
  PieChart,
}

enum ThemeSetting { dark, light }

enum MethodAdded {
  email,
  shared,
  csv,
  preview,
  appLink,
}

enum SharedStatus { waiting, shared, error }

enum DeleteLogType {
  TransactionWallet,
  TransactionCategory,
  Budget,
  CategoryBudgetLimit,
  Transaction,
  TransactionAssociatedTitle,
  ScannerTemplate,
  Objective,
  Unused, // Was for the scanner template, but is now unused
}

enum UpdateLogType {
  TransactionWallet,
  TransactionCategory,
  Budget,
  CategoryBudgetLimit,
  Transaction,
  TransactionAssociatedTitle,
  ScannerTemplate,
  Objective,
  Unused, // Was for the scanner template, but is now unused
}
