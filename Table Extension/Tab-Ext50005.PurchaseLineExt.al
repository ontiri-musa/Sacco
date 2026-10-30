tableextension 50005 "Purchase Line Ext" extends "Purchase Line"
{
    fields
    {
        modify("VAT Bus. Posting Group")
        {
            trigger OnBeforeValidate()
            begin
                Clear("VAT Prod. Posting Group");
            end;

            trigger OnAfterValidate()
            var
                VATSetup: Record "VAT Posting Setup";
            begin
                VATSetup.Reset();
                VATSetup.SetRange("VAT Bus. Posting Group", Rec."VAT Bus. Posting Group");
                if VATSetup.FindFirst() then begin
                    "VAT Prod. Posting Group" := VATSetup."VAT Prod. Posting Group";
                end;
            end;
        }
        modify("No.")
        {
            trigger OnBeforeValidate()
            begin
                "Gen. Bus. Posting Group" := 'GENERAL';
                "Gen. Prod. Posting Group" := 'GENERAL';
            end;
        }
        field(5010; "W/Tax Amount"; Decimal)
        {
            Editable = false;
        }

        field(14; "Charge Withholding Tax"; Boolean)
        {
            trigger OnValidate()
            var
                GlobalSetup: Record "Global Setup";
            begin
                GlobalSetup.Get();
                if "Charge Withholding Tax" then begin
                    GlobalSetup.TestField("Withholding Tax %");
                    "W/Tax Amount" := GlobalSetup."Withholding Tax %" / 100 * "Line Amount"
                end else
                    "W/Tax Amount" := 0;
            end;
        }

    }
}
