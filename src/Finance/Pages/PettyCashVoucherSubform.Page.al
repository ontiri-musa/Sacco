page 50635 "PettyCash Voucher Subform"
{
    // version TL2.0

    PageType = ListPart;
    SourceTable = "PettyCash Line";
    AutoSplitKey = true;
    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field("Account Type"; "Account Type")
                {
                    ApplicationArea = All;
                }
                field("Account No."; "Account No.")
                {
                    ApplicationArea = All;
                }
                field("Account Name"; "Account Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }


                field("Line Amount"; "Line Amount")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                    begin
                        CurrPage.Update()
                    end;

                }
                field("Charge Withholding Tax"; "Charge Withholding Tax")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                    begin
                        Validate("W/Tax Amount");

                    end;
                }
                field("W/Tax Amount"; "W/Tax Amount")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                    begin
                        CurrPage.Update()
                    end;
                }
                field("VAT Business Posting Group"; "VAT Business Posting Group")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                    begin
                        Validate("VAT Amount");

                    end;
                }
                field("VAT Product Posting Group"; "VAT Product Posting Group")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                    begin
                        Validate("VAT Amount");

                    end;
                }

                field("VAT Amount"; "VAT Amount")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                    begin
                        CurrPage.Update()
                    end;
                }
                field("Applies to Doc Type"; "Applies to Doc Type")
                {
                    ApplicationArea = All;
                }
                field("Applies to Doc. No"; "Applies to Doc. No")
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Suggest Lines")
            {
                Image = SuggestLines;

                trigger OnAction();
                begin
                    CashManagement.SuggestPettyCashLines(Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord();
    begin

    end;

    var
        CashManagement: Codeunit "Cash Management";

}

