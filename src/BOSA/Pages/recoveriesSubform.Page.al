page 59665 "Recovery Subform"
{
    // version TL2.0

    PageType = ListPart;
    SourceTable = "Recovery Line";
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
                field("Account  No."; "Account  No.")
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
                    Visible = false;
                }
                field("Deposits Balance"; "Deposits Balance")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
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
            action("Import  Recovery File")
            {
                Image = ImportCodes;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    CLEAR(RecovFile);
                    RecovHeader.Get("Document No.");
                    RecovHeader.TESTFIELD(Status, RecovHeader.Status::New);
                    RecovFile.SetDocumentNo(RecovHeader."No.");
                    RecovFile.RUN;
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
        RecovFile: XmlPort "Import  Recovery File";
        RecovHeader: Record "Recovery Header";
}

