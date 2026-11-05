page 51610 "Bank Acc. Reconciliation New"
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
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }

                field(StatementEndingBalance; "Statement Ending Balance")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Statement Ending Balance';
                    ToolTip = 'Specifies the ending balance shown on the bank''s statement that you want to reconcile with the bank account.';
                }
                field("Difference Btw Statements"; "Difference Btw Statements")
                {
                    Caption = 'Difference between statements';
                    Editable = false;
                }
                field("Cash Book Balance"; Rec."Cash Book Balance")
                {
                    Caption = 'Cash Book Balance';
                    Editable = false;
                }
                field("Total Unreconciled"; "Total Unreconciled")
                {
                    Caption = 'Total Unreconciled';
                    ToolTip = 'Specifies the total unreconciled amount on the bank''s statement that you want to reconcile.';
                }
                field("Total Reconciled"; "Total Reconciled")
                {
                    Caption = 'Total Reconciled';
                    ToolTip = 'Specifies the total reconciled amount on the bank''s statement that you want to reconcile.';
                }

            }
            group(Control8)
            {
                ShowCaption = false;

                part(StmtLine; "Bank Acc. Recon Lines")
                {
                    ApplicationArea = Basic, Suite;
                    //Visible = false;
                    Caption = 'Bank Statement Lines';
                    SubPageLink = "Bank Account No." = FIELD("Bank Account No."),
                                                  "Statement No." = FIELD("Statement No.");
                }
                part(ApplyBankLedgerEntries; "Apply Bank Ledger Entries")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    Caption = 'Bank Account Ledger Entries';
                    SubPageLink = "Bank Account No." = FIELD("Bank Account No."),
                                        Open = CONST(true),
                                        "Statement Status" = FILTER(Open | "Bank Acc. Entry Applied" | "Check Entry Applied");
                }
            }
            group(Control19)
            {
                Caption = '';
                field("Reconciliation Difference"; "Reconciliation Difference")
                {
                    Caption = 'Reconciliation Difference';
                    Editable = false;
                    ToolTip = 'Specifies the total difference between reconciled amount and difference between balance last statement and statement ending balance on the banks statement that you want to reconcile.';
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
                        Commit();
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
                    Visible = false;
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
                        MatchBankRecLines: Codeunit "Match Bank Rec. Lines New";
                        BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
                        bankAccStatementLine: Record "Bank Account Statement Line";
                        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
                    begin
                        //CurrPage.StmtLine.PAGE.GetSelectedRecords(TempBankAccReconciliationLine);
                        //CurrPage.ApplyBankLedgerEntries.PAGE.GetSelectedRecords(TempBankAccountLedgerEntry);
                        //if TempBankAccReconciliationLine."Statement Amount" <> TempBankAccountLedgerEntry.Amount then
                        //   Error('The Amounts do not match');
                        //MatchBankRecLines.MatchManually(TempBankAccReconciliationLine, TempBankAccountLedgerEntry);


                        bankAccStatementLine.RESET;
                        bankAccStatementLine.SETRANGE("Bank Account No.", Rec."Bank Account No.");
                        bankAccStatementLine.SETRANGE("Statement No.", Rec."Statement No.");
                        IF NOT bankAccStatementLine.FINDSET THEN BEGIN

                            CurrPage.StmtLine.PAGE.GetSelectedRecords(TempBankAccReconciliationLine);
                            BankAccountLedgerEntry.RESET;
                            BankAccountLedgerEntry.SETRANGE(BankAccountLedgerEntry."Posting Date", TempBankAccReconciliationLine."Transaction Date");
                            BankAccountLedgerEntry.SetRange(BankAccountLedgerEntry."Document No.", TempBankAccReconciliationLine."Document No.");
                            BankAccountLedgerEntry.SetRange(BankAccountLedgerEntry."External Document No.", TempBankAccReconciliationLine."External Doc No");
                            BankAccountLedgerEntry.SetRange(BankAccountLedgerEntry.Amount, TempBankAccReconciliationLine."Statement Amount");
                            BankAccountLedgerEntry.SetRange(BankAccountLedgerEntry.Description, TempBankAccReconciliationLine.Description);
                            BankAccountLedgerEntry.SetRange(BankAccountLedgerEntry."Entry No.", TempBankAccReconciliationLine."Ledger Entry No");
                            IF BankAccountLedgerEntry.FINDSET THEN begin
                                //Message('found');
                                MatchBankRecLines.MatchManually(TempBankAccReconciliationLine, BankAccountLedgerEntry);
                            end;
                            Rec.CalcFields(Rec."Total Reconciled");
                            Rec."Reconciliation Difference" := Rec."Difference Btw Statements" - Rec."Total Reconciled";
                            CurrPage.Update();

                        END;

                        //CurrPage.StmtLine.PAGE.SetSelectionFilter(BankAccReconciliationLine);
                        //if BankAccReconciliationLine.FindSet then begin
                        //  repeat
                        // BankAccReconciliationLine.Difference := 0;
                        // BankAccReconciliationLine."Applied Amount" := BankAccReconciliationLine."Statement Amount";
                        // BankAccReconciliationLine.Modify();
                        //until BankAccReconciliationLine.Next = 0;
                        //end;
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
                        MatchBankRecLines: Codeunit "Match Bank Rec. Lines New";
                        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
                    begin
                        CurrPage.StmtLine.PAGE.GetSelectedRecords(TempBankAccReconciliationLine);
                        //CurrPage.ApplyBankLedgerEntries.PAGE.GetSelectedRecords(TempBankAccountLedgerEntry);
                        BankAccountLedgerEntry.RESET;
                        BankAccountLedgerEntry.SETRANGE(BankAccountLedgerEntry."Posting Date", TempBankAccReconciliationLine."Transaction Date");
                        BankAccountLedgerEntry.SetRange(BankAccountLedgerEntry."Document No.", TempBankAccReconciliationLine."Document No.");
                        BankAccountLedgerEntry.SetRange(BankAccountLedgerEntry."External Document No.", TempBankAccReconciliationLine."External Doc No");
                        BankAccountLedgerEntry.SetRange(BankAccountLedgerEntry.Amount, TempBankAccReconciliationLine."Statement Amount");
                        BankAccountLedgerEntry.SetRange(BankAccountLedgerEntry.Description, TempBankAccReconciliationLine.Description);
                        BankAccountLedgerEntry.SetRange(BankAccountLedgerEntry."Entry No.", TempBankAccReconciliationLine."Ledger Entry No");
                        IF BankAccountLedgerEntry.FINDSET THEN BEGIN
                            MatchBankRecLines.RemoveMatch(TempBankAccReconciliationLine, BankAccountLedgerEntry);
                        END;
                        Rec.CalcFields(Rec."Total Reconciled");
                        Rec."Reconciliation Difference" := Rec."Difference Btw Statements" - Rec."Total Reconciled";
                        CurrPage.Update();
                    end;
                }
                action(MatchALL)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Match All';
                    Image = RemoveContacts;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    ToolTip = 'Match All selection of unmatched bank statement lines.';

                    trigger OnAction()
                    var
                        TempBankAccReconciliationLine: Record "Bank Acc. Reconciliation Line" temporary;
                        TempBankAccountLedgerEntry: Record "Bank Account Ledger Entry" temporary;
                        MatchBankRecLines: Codeunit "Match Bank Rec. Lines New";
                        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
                        BankcReconLines: Record "Bank Acc. Reconciliation Line";
                        Text000: Label 'Are you sure you want to reconcile all entries?';
                        Text002: Label 'Lines Reconciled Successfully';
                        BankAccSetStmtNo: Codeunit "Bank Acc Ent Set Recon No New";
                    begin
                        IF CONFIRM(Text000) = TRUE THEN BEGIN
                            BankcReconLines.RESET;
                            BankcReconLines.SETRANGE("Bank Account No.", "Bank Account No.");
                            BankcReconLines.SETRANGE("Statement No.", "Statement No.");
                            BankcReconLines.SETRANGE(Reconciled, FALSE);
                            IF BankcReconLines.FINDSET THEN BEGIN
                                REPEAT
                                    BankAccountLedgerEntry.RESET;
                                    BankAccountLedgerEntry.SETRANGE("Bank Account No.", "Bank Account No.");
                                    BankAccountLedgerEntry.SETRANGE("Entry No.", BankcReconLines."Ledger Entry No");
                                    BankAccountLedgerEntry.SETRANGE(Amount, BankcReconLines."Statement Amount");
                                    IF BankAccountLedgerEntry.FINDFIRST THEN BEGIN
                                        MatchBankRecLines.MatchManually(BankcReconLines, BankAccountLedgerEntry);
                                    END;
                                UNTIL BankcReconLines.NEXT = 0;
                            END;
                            Rec.CalcFields(Rec."Total Reconciled");
                            Rec."Reconciliation Difference" := Rec."Difference Btw Statements" - Rec."Total Reconciled";
                            Rec.Modify();
                            CurrPage.Update();
                            MESSAGE(Text002);
                        END ELSE
                            EXIT;
                    end;
                }
                action(RemoveMatchALL)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Remove Match All';
                    Image = RemoveContacts;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    ToolTip = 'Remove Match All selection of matched bank statement lines.';

                    trigger OnAction()
                    var
                        TempBankAccReconciliationLine: Record "Bank Acc. Reconciliation Line" temporary;
                        TempBankAccountLedgerEntry: Record "Bank Account Ledger Entry" temporary;
                        MatchBankRecLines: Codeunit "Match Bank Rec. Lines New";
                        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
                        BankcReconLines: Record "Bank Acc. Reconciliation Line";
                        Text001: Label 'Are you sure you want to unreconcile all entries?';
                        Text003: Label 'Lines Unreconciled Sucessfully';
                        BankAccSetStmtNo: Codeunit "Bank Acc Ent Set Recon No New";
                    begin
                        IF CONFIRM(Text001) = TRUE THEN BEGIN
                            BankcReconLines.RESET;
                            BankcReconLines.SETRANGE("Bank Account No.", "Bank Account No.");
                            BankcReconLines.SETRANGE("Statement No.", "Statement No.");
                            BankcReconLines.SETRANGE(Reconciled, TRUE);
                            IF BankcReconLines.FINDSET THEN BEGIN
                                REPEAT
                                    BankAccountLedgerEntry.RESET;
                                    BankAccountLedgerEntry.SETRANGE("Bank Account No.", "Bank Account No.");
                                    BankAccountLedgerEntry.SETRANGE("Entry No.", BankcReconLines."Ledger Entry No");
                                    BankAccountLedgerEntry.SETRANGE(Amount, BankcReconLines."Statement Amount");
                                    IF BankAccountLedgerEntry.FINDFIRST THEN BEGIN
                                        MatchBankRecLines.RemoveMatch(BankcReconLines, BankAccountLedgerEntry);
                                    END;
                                UNTIL BankcReconLines.NEXT = 0;
                            END;
                            Rec.CalcFields(Rec."Total Reconciled");
                            Rec."Reconciliation Difference" := Rec."Difference Btw Statements" - Rec."Total Reconciled";
                            Rec.Modify();
                            CurrPage.Update();
                            MESSAGE(Text003);
                        END ELSE
                            EXIT;
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
                action(UpdateEntryNo)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Update Entry No';
                    Image = Reuse;
                    Visible = false;
                    RunObject = codeunit UpdateRecBankEntryNo;
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
                    RunObject = Codeunit "Bank Acc Recon Post (Yes/No)";
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
                    RunObject = Codeunit "Bank Acc Recon Post+Print";
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
        BankRecLines: Record "Bank Acc. Reconciliation Line";
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
            /*
                        BankRecLines.Reset();
                        BankRecLines.SetRange(BankRecLines."Bank Account No.", "Bank Account No.");
                        BankRecLines.SetRange(BankRecLines."Statement No.", "Statement No.");
                        if BankRecLines.FindSet() then begin
                            repeat
                                BankRecLines."External Doc No" := BankAccountLedgerEntry."External Document No.";
                                BankRecLines."Document No." := BankAccountLedgerEntry."Document No.";
                                BankRecLines.Modify();
                            until BankRecLines.Next = 0;
                        end;*/
            //BalanceToReconcile := CalcBalanceToReconcile;
        end;
    end;

    var
        SuggestBankAccStatement: Report "Suggest Bank Recon. Lines";
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