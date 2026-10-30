page 51612 "Bank Acc. Reconciliation New 2"
{
    Caption = 'Bank Acc. Reconciliation';
    PageType = ListPlus;
    PromotedActionCategories = 'New,Process,Report,Bank,Matching,Posting';
    SaveValues = false;
    SourceTable = "Bank Acc. Reconciliation";
    SourceTableView = WHERE("Statement Type" = CONST("Bank Reconciliation"));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(BankAccountNo; "Bank Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Bank Account No.';
                    ToolTip = 'Specifies the number of the bank account that you want to reconcile with the bank''s statement.';
                    trigger OnValidate()
                    var
                        BankAccReconciliationLine: record "Bank Acc. Reconciliation Line";
                    begin
                        if BankAccReconciliationLine.BankStatementLinesListIsEmpty("Statement No.", "Statement Type", "Bank Account No.") then
                            CreateEmptyListNotification();
                    end;
                }
                field(StatementNo; "Statement No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Statement No.';
                    ToolTip = 'Specifies the number of the bank account statement.';
                }
                field(StatementDate; "Statement Date")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Statement Date';
                    ToolTip = 'Specifies the date on the bank account statement.';
                    trigger OnValidate()
                    begin
                        CalcBalance();
                        CurrPage.Update();
                    end;
                }
                field(BalanceLastStatement; "Balance Last Statement")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Balance Last Statement';
                    ToolTip = 'Specifies the ending balance shown on the last bank statement, which was used in the last posted bank reconciliation for this bank account.';
                }
                field(StatementEndingBalance; "Statement Ending Balance")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Statement Ending Balance';
                    ToolTip = 'Specifies the ending balance shown on the bank''s statement that you want to reconcile with the bank account.';
                }
                field(Balance; Balance)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Total Account Balance';
                    Editable = false;
                    ToolTip = 'Specifies the balance of the bank account since the last posting, including any amount in the Total on Outstanding Checks field.';
                }
                field(CheckBalance; CheckBalance)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Total on Outstanding Checks';
                    Editable = false;
                    ToolTip = 'Specifies the part of the bank account balance that consists of posted check ledger entries. The amount in this field is a subset of the amount in the Balance field under the right pane in the Bank Acc. Reconciliation window.';
                }
                field(BalanceToReconcile; BalanceToReconcile)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Balance To Reconcile';
                    Editable = false;
                    ToolTip = 'Specifies the balance of the bank account since the last posting, excluding any amount in the Total on Outstanding Checks field.';
                }
            }
            group(Control8)
            {
                ShowCaption = false;

                part(StmtLine; "Bank Acc. Reconciliation Lines")
                {
                    ApplicationArea = Basic, Suite;
                    //Visible = false;
                    Caption = 'Bank Statement Lines';
                    SubPageLink = "Bank Account No." = FIELD("Bank Account No."),
                                                  "Statement No." = FIELD("Statement No.");
                }
            }
            group(Control9)
            {
                ShowCaption = false;

                part(ApplyBankLedgerEntries; "Apply Bank Ledger Entries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Bank Account Ledger Entries';
                    SubPageLink = "Bank Account No." = FIELD("Bank Account No."),
                                        Open = CONST(true),
                                        "Statement Status" = FILTER(Open | "Bank Acc. Entry Applied" | "Check Entry Applied"),
                                        Reversed = FILTER(false);
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Recon.")
            {
                Caption = '&Recon.';
                Image = BankAccountRec;
                action("&Card")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Card';
                    Image = EditLines;
                    RunObject = Page "Bank Account Card";
                    RunPageLink = "No." = FIELD("Bank Account No.");
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View or change detailed information about the record that is being processed on the journal line.';
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(SuggestLines)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Suggest Lines';
                    Ellipsis = true;
                    Image = SuggestLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Create bank account ledger entries suggestions and enter them automatically.';

                    trigger OnAction()
                    begin
                        SuggestBankAccStatement.SetStmt(Rec);
                        SuggestBankAccStatement.RunModal;
                        Clear(SuggestBankAccStatement);
                    end;
                }
                action("Transfer to General Journal")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Transfer to General Journal';
                    Ellipsis = true;
                    Image = TransferToGeneralJournal;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Transfer the lines from the current window to the general journal.';

                    trigger OnAction()
                    begin
                        TransferToGLJnl.SetBankAccRecon(Rec);
                        TransferToGLJnl.Run;
                    end;
                }
            }
            group("Ba&nk")
            {
                Caption = 'Ba&nk';
                action(ImportBankStatement)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Import Bank Statement';
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Import electronic bank statements from your bank to populate with data about actual bank transactions.';

                    trigger OnAction()
                    var
                        Notification: Notification;
                    begin
                        CurrPage.Update;
                        ImportBankStatement;

                        Notification.Id := NotificationID;
                        if Notification.Recall then;
                    end;
                }
            }
            group("M&atching")
            {
                Caption = 'M&atching';
                action(MatchAutomatically)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Match Automatically';
                    Image = MapAccounts;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    ToolTip = 'Automatically search for and match bank statement lines.';

                    trigger OnAction()
                    begin
                        SetRange("Statement Type", "Statement Type");
                        SetRange("Bank Account No.", "Bank Account No.");
                        SetRange("Statement No.", "Statement No.");
                        REPORT.Run(REPORT::"Match Bank Entries", true, true, Rec);
                    end;
                }
                action(MatchManually)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Match Manually';
                    Image = CheckRulesSyntax;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    ToolTip = 'Manually match selected lines in both panes to link each bank statement line to one or more related bank account ledger entries.';

                    trigger OnAction()
                    var
                        TempBankAccReconciliationLine: Record "Bank Acc. Reconciliation Line" temporary;
                        TempBankAccountLedgerEntry: Record "Bank Account Ledger Entry" temporary;
                        MatchBankRecLines: Codeunit "Match Bank Rec. Lines";
                    begin
                        CurrPage.StmtLine.PAGE.GetSelectedRecords(TempBankAccReconciliationLine);
                        CurrPage.ApplyBankLedgerEntries.PAGE.GetSelectedRecords(TempBankAccountLedgerEntry);
                        MatchBankRecLines.MatchManually(TempBankAccReconciliationLine, TempBankAccountLedgerEntry);
                    end;
                }
                action(RemoveMatch)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Remove Match';
                    Image = RemoveContacts;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    ToolTip = 'Remove selection of matched bank statement lines.';

                    trigger OnAction()
                    var
                        TempBankAccReconciliationLine: Record "Bank Acc. Reconciliation Line" temporary;
                        TempBankAccountLedgerEntry: Record "Bank Account Ledger Entry" temporary;
                        MatchBankRecLines: Codeunit "Match Bank Rec. Lines";
                    begin
                        CurrPage.StmtLine.PAGE.GetSelectedRecords(TempBankAccReconciliationLine);
                        CurrPage.ApplyBankLedgerEntries.PAGE.GetSelectedRecords(TempBankAccountLedgerEntry);
                        MatchBankRecLines.RemoveMatch(TempBankAccReconciliationLine, TempBankAccountLedgerEntry);
                    end;
                }
                action(All)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Show All';
                    Image = AddWatch;
                    ToolTip = 'Show all bank statement lines.';

                    trigger OnAction()
                    begin
                        CurrPage.StmtLine.PAGE.ToggleMatchedFilter(false);
                        CurrPage.ApplyBankLedgerEntries.PAGE.ToggleMatchedFilter(false);
                    end;
                }
                action(NotMatched)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Show Nonmatched';
                    Image = AddWatch;
                    ToolTip = 'Show all bank statement lines that have not yet been matched.';

                    trigger OnAction()
                    begin
                        CurrPage.StmtLine.PAGE.ToggleMatchedFilter(true);
                        CurrPage.ApplyBankLedgerEntries.PAGE.ToggleMatchedFilter(true);
                    end;
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action("&Test Report")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Test Report';
                    Ellipsis = true;
                    Image = TestReport;
                    ToolTip = 'Preview the resulting bank account reconciliations to see the consequences before you perform the actual posting.';

                    trigger OnAction()
                    begin
                        ReportPrint.PrintBankAccRecon(Rec);
                    end;
                }
                action(Post)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'P&ost';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    RunObject = Codeunit "Bank Acc. Recon. Post (Yes/No)";
                    ShortCutKey = 'F9';
                    ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';
                }
                action(PostAndPrint)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    RunObject = Codeunit "Bank Acc. Recon. Post+Print";
                    ShortCutKey = 'Shift+F9';
                    ToolTip = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        BankAccReconciliationLine: record "Bank Acc. Reconciliation Line";
    begin
        NotificationID := CreateGuid();

        if BankAccReconciliationLine.BankStatementLinesListIsEmpty("Statement No.", "Statement Type", "Bank Account No.") then
            CreateEmptyListNotification();

    end;

    trigger OnAfterGetCurrRecord()
    begin
        CalcBalance;
    end;

    local procedure CreateEmptyListNotification()
    var
        Notification: Notification;
    begin
        Notification.Id := NotificationID;
        if Notification.Recall then;

        Notification.Message := ListEmptyMsg;
        Notification.Scope := NotificationScope::LocalScope;
        Notification.Send;
    end;

    local procedure CalcBalance()
    var
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
    begin
        if BankAccount.Get("Bank Account No.") then begin
            BankAccount.CalcFields(Balance, "Total on Checks");
            Balance := BankAccount.Balance;
            CheckBalance := BankAccount."Total on Checks";
            Dfilter := '..' + Format("Statement Date");

            BankAccountLedgerEntry.RESET;
            BankAccountLedgerEntry.SETRANGE("Bank Account No.", "Bank Account No.");
            BankAccountLedgerEntry.SETRANGE(Open, TRUE);
            BankAccountLedgerEntry.SETRANGE(Reversed, FALSE);
            BankAccountLedgerEntry.SETFILTER("Posting Date", '%1..%2', 0D, "Statement Date");
            BankAccountLedgerEntry.SETFILTER("Statement Status", '%1|%2|%3', BankAccountLedgerEntry."Statement Status"::"Bank Acc. Entry Applied",
                                                BankAccountLedgerEntry."Statement Status"::"Check Entry Applied", BankAccountLedgerEntry."Statement Status"::Open);
            BankAccountLedgerEntry.CALCSUMS(Amount);
            BalanceToReconcile := BankAccountLedgerEntry.Amount;

            //BalanceToReconcile := CalcBalanceToReconcile;
        end;
    end;

    var
        SuggestBankAccStatement: Report "Suggest Bank Acc. Recon. Lines";
        PostingDate1: date;
        PostingDate2: date;
        PostingDateText: text;
        TransferToGLJnl: Report "Trans. Bank Rec. to Gen. Jnl.";
        ReportPrint: Codeunit "Test Report-Print";
        NotificationID: Guid;
        ListEmptyMsg: Label 'No bank statement lines exist. Choose the Import Bank Statement action to fill in the lines from a file, or enter lines manually.';
        BankAccount: Record "Bank Account";
        StyleTxt: Text;
        LineApplied: Boolean;
        Balance: Decimal;
        CheckBalance: Decimal;
        BalanceToReconcile: Decimal;
        Dfilter: Text;
}