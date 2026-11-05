table 50999 "debtors"
{
    // version TL2.0

    DrillDownPageID = 51099;
    LookupPageID = 51099;

    fields
    {
        field(1; "Loan No."; Code[20])
        {
        }
        field(5; "Line No."; Integer)
        {
        }
        field(10; "User Input"; text[250])
        {
            trigger OnValidate()
            begin
                objCustLedg.Reset();
                objCustLedg.SetCurrentKey("Posting Date");
                objCustLedg.SetFilter(Reversed, '%1', false);
                objCustLedg.SetFilter("Transaction Type Code", '%1|%2|%3', 'PPAID', 'INTPAID', 'PENPAID');
                objCustLedg.SetRange("Customer No.", Rec."Loan No.");
                if objCustLedg.Find('+') then
                    Rec."Last Payment Date" := objCustLedg."Posting Date";

                Commit();

                objCustLedg.SetRange("Posting Date", Rec."Last Payment Date");
                if objCustLedg.FindSet() then begin
                    repeat
                        objCustLedg.CalcFields(Amount);
                        if objCustLedg."Transaction Type Code" in ['PPAID', 'INTPAID', 'PENPAID'] then
                            lastPaymentAmt += objCustLedg.Amount;
                    until objCustLedg.Next() = 0;
                end;
                Rec."Last Amount Paid" := lastPaymentAmt * -1;
            end;

        }
        field(15; "Next Action Date"; Date)
        {
        }
        field(20; "Amount Promised To Pay"; Decimal)
        {
        }
        field(25; "Last Amount Paid"; Decimal)
        {
        }
        field(30; "Last Payment Date"; Date)
        {
        }
        field(35; "USER ID"; Code[100])
        {
        }






    }

    keys
    {
        key(Key1; "Loan No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }
    trigger OnInsert()
    begin

        "USER ID" := UserId;
    end;

    trigger OnModify()
    begin


    end;

    trigger OnDelete()
    begin

    end;




    var
        objCustLedg: Record "Cust. Ledger Entry";
        lastPaymentAmt: Decimal;


}

