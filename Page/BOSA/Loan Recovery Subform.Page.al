page 59661 "Loan Recovery Subform"
{
    // version TL2.0

    PageType = ListPart;
    SourceTable = "Loan Recovery Line";
    AutoSplitKey = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Member No."; "Member No.")
                {
                    ApplicationArea = All;
                }

                field("Member Name"; "Member Name")
                {
                    ApplicationArea = All;
                }
                field("Loan No."; "Loan No.")
                {
                    ApplicationArea = All;
                }
                field("Account Name"; "Account Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Account Balance"; "Account Balance")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Deposits Account No."; "Deposits Account No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Deposits Balance"; "Deposits Balance")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Recovery Amount"; "Recovery Amount")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                    begin
                        CurrPage.Update()
                    end;
                }

            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Import Loan Recovery File")
            {
                Image = ImportCodes;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    CLEAR(LoanRecovFile);
                    LoanRecovHeader.Get("Document No.");
                    LoanRecovHeader.TESTFIELD(Status, LoanRecovHeader.Status::New);
                    LoanRecovFile.SetDocumentNo(LoanRecovHeader."No.");
                    LoanRecovFile.RUN;
                end;
            }
        }
    }

    trigger OnAfterGetRecord();
    begin

    end;

    var
        //PaymentRemittanceAdvise : Report "50441";
        CashManagement: Codeunit "Cash Management";
        LoanRecovFile: XmlPort "Import Loan Recovery File";
        LoanRecovHeader: Record "Loan Recovery Header";
}

