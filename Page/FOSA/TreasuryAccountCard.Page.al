page 50105 "Treasury Account Card"
{
    // version TL2.0

    Caption = 'Treasury Account Card';
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Bank Statement Service,Bank Account';
    SourceTable = "Bank Account";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of the bank account.';

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the name of the bank where you have the bank account.';
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                }
                field(Balance2; Balance)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the bank account''s current balance denominated in the applicable foreign currency.';
                }
                field("Balance (LCY)"; "Balance (LCY)")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the bank account''s current balance in LCY.';
                }
                field(Blocked; Blocked)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that transactions with the bank account cannot be posted.';
                }

                field("Last Date Modified"; "Last Date Modified")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the date when the Bank Account card was last modified.';
                }
            }
            group(Communication)
            {
                Caption = 'Communication';
                field(Address; Address)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the address of the bank where you have the bank account.';
                }
                field("Address 2"; "Address 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies additional address information.';
                }
                field("Post Code"; "Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the postal code.';
                }
                field(City; City)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the city of the bank where you have the bank account.';
                }
                field("Country/Region Code"; "Country/Region Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the country/region of the address.';
                }
                field("Phone No."; "Phone No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the telephone number of the bank where you have the bank account.';
                }
                field(Contact; Contact)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the bank employee regularly contacted in connection with this bank account.';
                }
                field("Phone No.2"; "Phone No.")
                {
                    ApplicationArea = All;
                    Caption = 'Phone No.';
                    Importance = Promoted;
                    ToolTip = 'Specifies the telephone number of the bank where you have the bank account.';
                    Visible = false;
                }

                field("E-Mail"; "E-Mail")
                {
                    ApplicationArea = All;
                    ExtendedDatatype = EMail;
                    Importance = Promoted;
                    ToolTip = 'Specifies the email address associated with the bank account.';
                }

            }
            group(Posting)
            {


                field("Bank Acc. Posting Group"; "Bank Acc. Posting Group")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies a code for the bank account posting group for the bank account.';
                }
            }

        }
    }

    actions
    {
        area(Processing)
        {
            group("&Bank Acc.")
            {
                Caption = '&Bank Acc.';
                Image = Bank;
                action(Statistics)
                {
                    ApplicationArea = All;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Bank Account Statistics";
                    RunPageLink = "No." = FIELD("No."),
                                  "Date Filter" = FIELD("Date Filter"),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                    ShortCutKey = 'F7';
                    ToolTip = 'View statistical information, such as the value of posted entries, for the record.';
                }
                action(Dimensions)
                {
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = CONST(270),
                                  "No." = FIELD("No.");
                    ShortCutKey = 'Alt+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';
                }
                action("Bank Account Balance")
                {
                    ApplicationArea = All;
                    Caption = 'Balance';
                    Image = Balance;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Bank Account Balance";
                    RunPageLink = "No." = FIELD("No."),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                    ToolTip = 'View a summary of the bank account balance in different periods.';
                }
                action("Ledger E&ntries")
                {
                    ApplicationArea = All;
                    Caption = 'Ledger E&ntries';
                    Image = BankAccountLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Bank Account Ledger Entries";
                    RunPageLink = "Bank Account No." = FIELD("No.");
                    RunPageView = SORTING("Bank Account No.")
                                  ORDER(Descending);
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View the history of transactions that have been posted for the selected record.';
                }
            }

        }
        area(reporting)
        {
            action("Treasury Report")
            {
                ApplicationArea = All;
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedOnly = true;
                trigger OnAction()
                begin
                    Report.Run(50007, true, false, Rec);
                end;
            }
            action(List)
            {
                ApplicationArea = All;
                Caption = 'List';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedOnly = true;
                ToolTip = 'View a list of general information about bank accounts, such as posting group, currency code, minimum balance, and balance.';

                trigger OnAction()
                begin
                    RunReport(REPORT::"Bank Account - List", "No.");
                end;
            }
            action("Detail Trial Balance")
            {
                ApplicationArea = All;
                Caption = 'Detail Trial Balance';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedOnly = true;
                ToolTip = 'View a detailed trial balance for selected checks.';

                trigger OnAction()
                begin
                    RunReport(REPORT::"Bank Acc. - Detail Trial Bal.", "No.");
                end;
            }
        }
    }
    local procedure RunReport(ReportNumber: Integer; BankActNumber: Code[20])
    var
        BankAccount: Record "Bank Account";
    begin
        BankAccount.SetRange("No.", BankActNumber);
        REPORT.RunModal(ReportNumber, true, true, BankAccount);
    end;
}