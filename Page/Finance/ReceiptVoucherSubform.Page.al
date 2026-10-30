page 50626 "Receipt Voucher Subform"
{
    // version TL2.0

    PageType = ListPart;
    SourceTable = "Receipt Line";
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
                field("Account Balance"; "Account Balance")
                {
                    ApplicationArea = All;
                }
                field("Line Amount"; "Line Amount")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        RecHeader: Record "Receipt Header";
                        RecLine: Record "Receipt Line";
                        TLineAmount: Decimal;
                    begin
                        CurrPage.Update();
                        if RecHeader.Get("Document No.") then begin
                            RecLine.Reset();
                            RecLine.SetRange("Document No.", RecHeader."No.");
                            if RecLine.FindSet() then begin
                                RecLine.CalcSums(RecLine."Line Amount");
                                TLineAmount := RecLine."Line Amount";
                            end;
                            //Message('Doc No %1 TLineAmount %2', RecHeader."No.", TLineAmount);
                            RecHeader.Variance := RecHeader.Amount - TLineAmount;
                            RecHeader.Modify();
                        end;
                        CurrPage.Update();
                    end;

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
                ApplicationArea = all;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                var
                begin
                    CashManagement.SuggestReceiptLines(Rec);
                end;
            }

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

