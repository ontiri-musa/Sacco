report 50025 "Loan Ledger Entries"
{
    ApplicationArea = All;
    Caption = 'Loan Ledger Entries';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    //RDLCLayout = 'Report/BOSA/Loan Ledger Entries.rdl';
    dataset
    {
        dataitem(Member; Member)
        {
            dataitem(LoanApplication; "Loan Application")
            {
                DataItemLink = "Member No." = FIELD("No.");
                DataItemTableView = where(Posted = filter(true));
                dataitem(CustLedgerEntry; "Cust. Ledger Entry")
                {
                    DataItemLink = "Customer No." = FIELD("No.");
                    DataItemTableView = SORTING("Posting Date") order(ascending) where(Reversed = filter(false));
                    column(PostingDate; "Posting Date")
                    {
                    }
                    column(DocumentNo; "Document No.")
                    {
                    }
                    column(CustomerNo; "Customer No.")
                    {
                    }
                    column(Description; Description)
                    {
                    }
                    trigger OnAfterGetRecord()
                    begin
                        if (CustLedgerEntry."Posting Date" < StartDate) then
                            CurrReport.Skip();

                        DCustL.Reset();
                        DCustL.SETCURRENTKEY("Posting Date", "Entry No.");
                        DCustL.ASCENDING();
                        DCustL.SetRange("Customer No.", CustLedgerEntry."Customer No.");
                        DCustL.SetRange("Cust. Ledger Entry No.", CustLedgerEntry."Entry No.");
                        //DCustL.SetFilter("Posting Date", '%1..%2', StartDate, 20180531D);
                        If DCustL.FindSet() then begin
                            repeat
                                If (DCustL."Transaction Type Code" = 'NEWLOAN') or (DCustL."Transaction Type Code" = 'PPAID') then begin
                                    Principal := Principal + ABS(DCustL.Amount);
                                    GLEnt.Reset();
                                    GLEnt.SetRange("Transaction No.", DCustL."Transaction No.");
                                    GLEnt.SetRange(Description, CustLedgerEntry.Description);
                                    GLEnt.SetRange(Reversed, false);
                                    GLEnt.SetRange(Amount, DCustL.Amount);
                                    if GLEnt.FindFirst() then begin
                                        DCustL."GL Transaction Found" := true;
                                        DCustL."GL Account" := GLEnt."G/L Account No.";
                                        DCustL.Modify();
                                    end;
                                end;
                            until DCustL.Next = 0;
                        end;
                    end;
                }
                trigger OnAfterGetRecord()
                begin
                    // if LoanApplication."Disbursal Date" > 20201231D then
                    //CurrReport.Skip();
                end;
            }
            trigger OnPreDataItem()
            begin
                StartDate := 20200101D;
                TotalMemb := Member.Count;
                IF GUIALLOWED THEN
                    ProgressWindow.OPEN(Text000 + Text001 + Text002 + Text003);
            end;

            trigger OnAfterGetRecord()
            begin
                i += 1;
                IF GUIALLOWED THEN BEGIN
                    ProgressWindow.UPDATE(1, Member."No.");
                    ProgressWindow.UPDATE(2, Member."Full Name");
                    ProgressWindow.UPDATE(3, (i / TotalMemb * 10000) DIV 1);
                    SLEEP(50);
                END;
            end;

            trigger OnPostDataItem()
            begin
                ProgressWindow.CLOSE;
                Message('Update complete. Total Principal =%1', Principal)
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    var
        Vend: Record Vendor;
        DVend: Record "Detailed Vendor Ledg. Entry";
        DCustL: Record "Detailed Cust. Ledg. Entry";
        CustL: Record "Cust. Ledger Entry";
        Principal: Decimal;
        StartDate: Date;
        GLEnt: Record "G/L Entry";
        ProgressWindow: Dialog;
        TotalMemb: Integer;
        i: Integer;
        Text000: Label 'Updating Member Transactions GL Accounts\';
        Text001: Label 'Member No.      #1#############################\';
        Text002: Label 'Member Name      #2#############################\';
        Text003: Label 'Progress          @3@@@@@@@@@@@@@@@@@@@@@@@\';
}
