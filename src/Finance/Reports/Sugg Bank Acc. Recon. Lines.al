report 51122 "Sugg Bank Acc. Recon. Lines"
{
    // version NAVW18.00

    Caption = 'Suggest Bank Acc. Recon. Lines';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Bank Account"; "Bank Account")
        {
            DataItemTableView = SORTING("No.");

            trigger OnAfterGetRecord();
            begin
                BankAccLedgEntry.RESET;
                BankAccLedgEntry.SETCURRENTKEY("Bank Account No.", "Posting Date");
                BankAccLedgEntry.SETRANGE("Bank Account No.", "No.");
                BankAccLedgEntry.SETRANGE("Posting Date", StartDate, EndDate);
                BankAccLedgEntry.SETRANGE(Open, true);
                BankAccLedgEntry.SETRANGE("Statement Status", BankAccLedgEntry."Statement Status"::Open);
                EOFBankAccLedgEntries := not BankAccLedgEntry.FIND('-');

                if IncludeChecks then begin
                    CheckLedgEntry.RESET;
                    CheckLedgEntry.SETCURRENTKEY("Bank Account No.", "Check Date");
                    CheckLedgEntry.SETRANGE("Bank Account No.", "No.");
                    CheckLedgEntry.SETRANGE("Check Date", StartDate, EndDate);
                    CheckLedgEntry.SETFILTER(
                      "Entry Status", '%1|%2', CheckLedgEntry."Entry Status"::Posted,
                      CheckLedgEntry."Entry Status"::"Financially Voided");
                    CheckLedgEntry.SETRANGE(Open, true);
                    CheckLedgEntry.SETRANGE("Statement Status", BankAccLedgEntry."Statement Status"::Open);
                    EOFCheckLedgEntries := not CheckLedgEntry.FIND('-');
                end;

                while (not EOFBankAccLedgEntries) or (IncludeChecks and (not EOFCheckLedgEntries)) do
                    case true of
                        not IncludeChecks:
                            begin
                                EnterBankAccLine(BankAccLedgEntry);
                                EOFBankAccLedgEntries := BankAccLedgEntry.NEXT = 0;
                            end;
                        (not EOFBankAccLedgEntries) and (not EOFCheckLedgEntries) and
                        (BankAccLedgEntry."Posting Date" <= CheckLedgEntry."Check Date"):
                            begin
                                CheckLedgEntry2.RESET;
                                CheckLedgEntry2.SETCURRENTKEY("Bank Account Ledger Entry No.");
                                CheckLedgEntry2.SETRANGE("Bank Account Ledger Entry No.", BankAccLedgEntry."Entry No.");
                                CheckLedgEntry2.SETRANGE(Open, true);
                                if not CheckLedgEntry2.FINDFIRST then
                                    EnterBankAccLine(BankAccLedgEntry);
                                EOFBankAccLedgEntries := BankAccLedgEntry.NEXT = 0;
                            end;
                        (not EOFBankAccLedgEntries) and (not EOFCheckLedgEntries) and
                        (BankAccLedgEntry."Posting Date" > CheckLedgEntry."Check Date"):
                            begin
                                EnterCheckLine(CheckLedgEntry);
                                EOFCheckLedgEntries := CheckLedgEntry.NEXT = 0;
                            end;
                        (not EOFBankAccLedgEntries) and EOFCheckLedgEntries:
                            begin
                                CheckLedgEntry2.RESET;
                                CheckLedgEntry2.SETCURRENTKEY("Bank Account Ledger Entry No.");
                                CheckLedgEntry2.SETRANGE("Bank Account Ledger Entry No.", BankAccLedgEntry."Entry No.");
                                CheckLedgEntry2.SETRANGE(Open, true);
                                if not CheckLedgEntry2.FINDFIRST then
                                    EnterBankAccLine(BankAccLedgEntry);
                                EOFBankAccLedgEntries := BankAccLedgEntry.NEXT = 0;
                            end;
                        EOFBankAccLedgEntries and (not EOFCheckLedgEntries):
                            begin
                                EnterCheckLine(CheckLedgEntry);
                                EOFCheckLedgEntries := CheckLedgEntry.NEXT = 0;
                            end;
                    end;
            end;

            trigger OnPreDataItem();
            begin
                if EndDate = 0D then
                    ERROR(Text000);

                BankAccReconLine.FilterBankRecLines(BankAccRecon);
                if not BankAccReconLine.FINDLAST then begin
                    BankAccReconLine."Statement Type" := BankAccRecon."Statement Type";
                    BankAccReconLine."Bank Account No." := BankAccRecon."Bank Account No.";
                    BankAccReconLine."Statement No." := BankAccRecon."Statement No.";
                    BankAccReconLine."Statement Line No." := 0;
                end;

                SETRANGE("No.", BankAccRecon."Bank Account No.");
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
                            Caption = 'Starting Date';
                        }
                        field(EndingDate; EndDate)
                        {
                            Caption = 'Ending Date';
                        }
                    }
                    field(IncludeChecks; IncludeChecks)
                    {
                        Caption = 'Include Checks';
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
        BankAccSetStmtNo: Codeunit "Bank Acc. Entry Set Recon.-No.";
        CheckSetStmtNo: Codeunit "Check Entry Set Recon.-No.";
        StartDate: Date;
        EndDate: Date;
        IncludeChecks: Boolean;
        EOFBankAccLedgEntries: Boolean;
        EOFCheckLedgEntries: Boolean;

    procedure SetStmt(var BankAccRecon2: Record "Bank Acc. Reconciliation");
    begin
        BankAccRecon := BankAccRecon2;
        EndDate := BankAccRecon."Statement Date";
    end;

    local procedure EnterBankAccLine(var BankAccLedgEntry2: Record "Bank Account Ledger Entry");
    begin
        BankAccReconLine.INIT;
        BankAccReconLine."Statement Line No." := BankAccReconLine."Statement Line No." + 10000;
        BankAccReconLine."Transaction Date" := BankAccLedgEntry2."Posting Date";
        BankAccReconLine.Description := BankAccLedgEntry2.Description;
        BankAccReconLine."Document No." := BankAccLedgEntry2."Document No.";
        BankAccReconLine."Statement Amount" := BankAccLedgEntry2.Amount;
        BankAccReconLine."Applied Amount" := BankAccReconLine."Statement Amount";
        BankAccReconLine.Type := BankAccReconLine.Type::"Bank Account Ledger Entry";
        // added to add the Cheque No.
        BankAccReconLine."Check No." := BankAccLedgEntry2."External Document No.";
        //BankAccReconLine.Reconciled:=TRUE;
        // end of addition
        BankAccReconLine."Applied Entries" := 1;
        BankAccSetStmtNo.SetReconNo(BankAccLedgEntry2, BankAccReconLine);
        BankAccReconLine.INSERT;
    end;

    local procedure EnterCheckLine(var CheckLedgEntry3: Record "Check Ledger Entry");
    begin
        BankAccReconLine.INIT;
        BankAccReconLine."Statement Line No." := BankAccReconLine."Statement Line No." + 10000;
        BankAccReconLine."Transaction Date" := CheckLedgEntry3."Check Date";
        BankAccReconLine.Description := CheckLedgEntry3.Description;
        BankAccReconLine."Statement Amount" := -CheckLedgEntry3.Amount;
        BankAccReconLine."Applied Amount" := BankAccReconLine."Statement Amount";
        BankAccReconLine.Type := BankAccReconLine.Type::"Check Ledger Entry";
        BankAccReconLine."Check No." := CheckLedgEntry3."Check No.";
        // added to add the Cheque No.
        //BankAccReconLine.Reconciled:=TRUE;
        // end of addition

        BankAccReconLine."Applied Entries" := 1;
        CheckSetStmtNo.SetReconNo(CheckLedgEntry3, BankAccReconLine);
        BankAccReconLine.INSERT;
    end;

    procedure InitializeRequest(NewStartDate: Date; NewEndDate: Date; NewIncludeChecks: Boolean);
    begin
        StartDate := NewStartDate;
        EndDate := NewEndDate;
        IncludeChecks := NewIncludeChecks;
    end;
}

