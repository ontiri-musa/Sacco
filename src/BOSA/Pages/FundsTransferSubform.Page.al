page 56009 "Funds Transfer Subform"
{
    // version TL2.0

    PageType = ListPart;
    SourceTable = "Funds Transfer Line";
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
                field("Transaction Type"; "Transaction Type")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    trigger OnValidate()
                    var
                        TType: Record "Transaction Type";
                    begin
                        If ("Account Type" = "Account Type"::Customer) and ("Member No." <> '') then begin
                            TestField("Account No.");

                            if TType.Get("Transaction Type") then begin
                                If TType."Is Loan Transaction Type" = false then
                                    Error('%1 is not a loan transaction type code', "Transaction Type");
                            end;
                        end;
                    end;
                }
                field("Account Balance"; "Account Balance")
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


            }
        }
    }

    actions
    {
        area(processing)
        {

        }
    }

    trigger OnAfterGetRecord();
    begin

    end;

    procedure SetTransactionType(var TransType: Integer)
    var

    begin
        TransactionType := TransType;
    end;

    var
        //PaymentRemittanceAdvise : Report "50441";
        CashManagement: Codeunit "Cash Management";
        TransactionType: Integer;
}

