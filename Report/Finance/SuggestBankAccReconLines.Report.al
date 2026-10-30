report 51111 "Suggest Bank Recon. Lines"
{
    Caption = 'Suggest Bank Acc. Recon. Lines';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Bank Account"; "Bank Account")
        {
            DataItemTableView = SORTING("No.");

            trigger OnAfterGetRecord()
            begin
                BankAccLedgEntry.RESET;
                BankAccLedgEntry.SETCURRENTKEY("Bank Account No.", "Posting Date");
                BankAccLedgEntry.SETRANGE("Bank Account No.", "No.");
                BankAccLedgEntry.SETRANGE("Posting Date", StartDate, EndDate);
                BankAccLedgEntry.SETRANGE(Open, TRUE);
                BankAccLedgEntry.SetFilter("Statement No.", '%1', '');
                BankAccLedgEntry.SETRANGE("Statement Status", BankAccLedgEntry."Statement Status"::Open);
                EOFBankAccLedgEntries := NOT BankAccLedgEntry.FIND('-');

                IF IncludeChecks THEN BEGIN
                    CheckLedgEntry.RESET;
                    CheckLedgEntry.SETCURRENTKEY("Bank Account No.", "Check Date");
                    CheckLedgEntry.SETRANGE("Bank Account No.", "No.");
                    CheckLedgEntry.SETRANGE("Check Date", StartDate, EndDate);
                    CheckLedgEntry.SETFILTER(
                      "Entry Status", '%1|%2', CheckLedgEntry."Entry Status"::Posted,
                      CheckLedgEntry."Entry Status"::"Financially Voided");
                    CheckLedgEntry.SETRANGE(Open, TRUE);
                    CheckLedgEntry.SETRANGE("Statement Status", BankAccLedgEntry."Statement Status"::Open);
                    EOFCheckLedgEntries := NOT CheckLedgEntry.FIND('-');
                END;

                WHILE (NOT EOFBankAccLedgEntries) OR (IncludeChecks AND (NOT EOFCheckLedgEntries)) DO
                    CASE TRUE OF
                        NOT IncludeChecks:
                            BEGIN
                                EnterBankAccLine(BankAccLedgEntry);
                                EOFBankAccLedgEntries := BankAccLedgEntry.NEXT = 0;
                            END;
                        (NOT EOFBankAccLedgEntries) AND (NOT EOFCheckLedgEntries) AND
                        (BankAccLedgEntry."Posting Date" <= CheckLedgEntry."Check Date"):
                            BEGIN
                                CheckLedgEntry2.RESET;
                                CheckLedgEntry2.SETCURRENTKEY("Bank Account Ledger Entry No.");
                                CheckLedgEntry2.SETRANGE("Bank Account Ledger Entry No.", BankAccLedgEntry."Entry No.");
                                CheckLedgEntry2.SETRANGE(Open, TRUE);
                                IF NOT CheckLedgEntry2.FINDFIRST THEN
                                    EnterBankAccLine(BankAccLedgEntry);
                                EOFBankAccLedgEntries := BankAccLedgEntry.NEXT = 0;
                            END;
                        (NOT EOFBankAccLedgEntries) AND (NOT EOFCheckLedgEntries) AND
                        (BankAccLedgEntry."Posting Date" > CheckLedgEntry."Check Date"):
                            BEGIN
                                EnterCheckLine(CheckLedgEntry);
                                EOFCheckLedgEntries := CheckLedgEntry.NEXT = 0;
                            END;
                        (NOT EOFBankAccLedgEntries) AND EOFCheckLedgEntries:
                            BEGIN
                                CheckLedgEntry2.RESET;
                                CheckLedgEntry2.SETCURRENTKEY("Bank Account Ledger Entry No.");
                                CheckLedgEntry2.SETRANGE("Bank Account Ledger Entry No.", BankAccLedgEntry."Entry No.");
                                CheckLedgEntry2.SETRANGE(Open, TRUE);
                                IF NOT CheckLedgEntry2.FINDFIRST THEN
                                    EnterBankAccLine(BankAccLedgEntry);
                                EOFBankAccLedgEntries := BankAccLedgEntry.NEXT = 0;
                            END;
                        EOFBankAccLedgEntries AND (NOT EOFCheckLedgEntries):
                            BEGIN
                                EnterCheckLine(CheckLedgEntry);
                                EOFCheckLedgEntries := CheckLedgEntry.NEXT = 0;
                            END;
                    END;

            end;

            trigger OnPreDataItem()
            begin
                OnPreDataItemBankAccount(ExcludeReversedEntries);

                if EndDate = 0D then
                    Error(Text000);

                BankAccReconLine.FilterBankRecLines(BankAccRecon);
                if not BankAccReconLine.FindLast then begin
                    BankAccReconLine."Statement Type" := BankAccRecon."Statement Type";
                    BankAccReconLine."Bank Account No." := BankAccRecon."Bank Account No.";
                    BankAccReconLine."Statement No." := BankAccRecon."Statement No.";
                    BankAccReconLine."Statement Line No." := 0;
                end;

                SetRange("No.", BankAccRecon."Bank Account No.");
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    group("Statement Period")
                    {
                        Caption = 'Statement Period';
                        field(StartingDate; StartDate)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Starting Date';
                            ToolTip = 'Specifies the date from which the report or batch job processes information.';
                        }
                        field(EndingDate; EndDate)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Ending Date';
                            ToolTip = 'Specifies the date to which the report or batch job processes information.';
                        }
                    }
                    field(IncludeChecks; IncludeChecks)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Include Checks';
                        ToolTip = 'Specifies if you want the report to include check ledger entries. If you choose this option, check ledger entries are suggested instead of the corresponding bank account ledger entries.';
                    }
                    field(ExcludeReversedEntries; ExcludeReversedEntries)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Exclude Reversed Entries';
                        ToolTip = 'Specifies if you want to exclude reversed entries from the report.';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Text000: Label 'Enter the Ending Date.';
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        CheckLedgEntry: Record "Check Ledger Entry";
        CheckLedgEntry2: Record "Check Ledger Entry";
        BankAccRecon: Record "Bank Acc. Reconciliation";
        BankAccReconLine: Record "Bank Acc. Reconciliation Line";
        BankAccReconLine2: Record "Bank Acc. Reconciliation Line";
        BankAccSetStmtNo: Codeunit "Bank Acc. Entry Set Recon.-No.";
        CheckSetStmtNo: Codeunit "Check Entry Set Recon.-No.";
        StartDate: Date;
        EndDate: Date;
        IncludeChecks: Boolean;
        EOFBankAccLedgEntries: Boolean;
        EOFCheckLedgEntries: Boolean;
        ExcludeReversedEntries: Boolean;

    procedure SetStmt(var BankAccRecon2: Record "Bank Acc. Reconciliation")
    begin
        BankAccRecon := BankAccRecon2;
        EndDate := BankAccRecon."Statement Date";
    end;

    local procedure EnterBankAccLine(var BankAccLedgEntry2: Record "Bank Account Ledger Entry")
    begin
        BankAccReconLine.Init();
        BankAccReconLine."Statement Line No." := BankAccReconLine."Statement Line No." + 10000;
        BankAccReconLine."Transaction Date" := BankAccLedgEntry2."Posting Date";
        BankAccReconLine.Description := BankAccLedgEntry2.Description;
        BankAccReconLine."Document No." := BankAccLedgEntry2."Document No.";
        BankAccReconLine."Statement Amount" := BankAccLedgEntry2."Remaining Amount";
        BankAccReconLine."Applied Amount" := BankAccReconLine."Statement Amount";
        BankAccReconLine.Type := BankAccReconLine.Type::"Bank Account Ledger Entry";
        BankAccReconLine."External Doc No" := BankAccLedgEntry2."External Document No.";
        BankAccReconLine."Debit Amount" := BankAccLedgEntry2."Debit Amount";
        BankAccReconLine."Credit Amount" := BankAccLedgEntry2."Credit Amount";
        BankAccReconLine."Ledger Entry No" := BankAccLedgEntry2."Entry No.";
        //BankAccReconLine."Applied Entries" := 1;
        //BankAccSetStmtNo.SetReconNo(BankAccLedgEntry2, BankAccReconLine);
        BankAccReconLine2.Reset();
        BankAccReconLine2.SetRange("Transaction Date", BankAccLedgEntry2."Posting Date");
        BankAccReconLine2.SetRange("Document No.", BankAccLedgEntry2."Document No.");
        BankAccReconLine2.SetRange("External Doc No", BankAccLedgEntry2."External Document No.");
        BankAccReconLine2.SetRange(Description, BankAccLedgEntry2.Description);
        BankAccReconLine2.SetRange("Statement Amount", BankAccLedgEntry2.Amount);
        BankAccReconLine2.SetRange("Ledger Entry No", BankAccLedgEntry2."Entry No.");
        if not BankAccReconLine2.FindFirst() then begin
            BankAccReconLine.Insert();
        end;

    end;

    local procedure EnterCheckLine(var CheckLedgEntry3: Record "Check Ledger Entry")
    var
        BankAccLedg: record "Bank Account Ledger Entry";
    begin
        BankAccReconLine.Init();
        BankAccReconLine."Statement Line No." := BankAccReconLine."Statement Line No." + 10000;
        BankAccReconLine."Transaction Date" := CheckLedgEntry3."Check Date";
        BankAccReconLine.Description := CheckLedgEntry3.Description;
        BankAccReconLine."Statement Amount" := -CheckLedgEntry3.Amount;
        BankAccReconLine."Applied Amount" := BankAccReconLine."Statement Amount";
        BankAccReconLine.Type := BankAccReconLine.Type::"Check Ledger Entry";
        BankAccReconLine."Check No." := CheckLedgEntry3."Check No.";
        //BankAccReconLine."Applied Entries" := 1;
        if BankAccLedg.Get(CheckLedgEntry3."Bank Account Ledger Entry No.") then
            BankAccReconLine."Document No." := BankAccLedg."Document No.";
        //CheckSetStmtNo.SetReconNo(CheckLedgEntry3, BankAccReconLine);
        BankAccReconLine.Insert();
    end;

    procedure InitializeRequest(NewStartDate: Date; NewEndDate: Date; NewIncludeChecks: Boolean)
    begin
        StartDate := NewStartDate;
        EndDate := NewEndDate;
        IncludeChecks := NewIncludeChecks;
        ExcludeReversedEntries := false;
    end;

    [IntegrationEvent(false, false)]
    [Scope('OnPrem')]
    procedure OnPreDataItemBankAccount(var ExcludeReversedEntries: Boolean)
    begin
        // ExcludeReversedEntries = FALSE by default
    end;
}

