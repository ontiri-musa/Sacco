page 59315 "BoreshaSavingsInterest Subform"
{
    // version TL2.0

    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    UsageCategory = Lists;
    SourceTable = "Dividend Line";
    ApplicationArea = All;

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
                field("National ID"; "National ID")
                {
                    ApplicationArea = All;
                }
                field("Phone No"; "Phone No")
                {
                    ApplicationArea = All;
                }
                field("District"; "District ")
                {
                    ApplicationArea = All;
                }
                field(Section; Section)
                {
                    ApplicationArea = All;
                }
                field("Boresha Savings Amount"; "Boresha Savings Amount")
                {
                    ApplicationArea = All;
                }
                field("Gross Earning Amount"; "Gross Earning Amount")
                {
                    ApplicationArea = All;
                }
                field("Withholding Tax Amount"; "Withholding Tax Amount")
                {
                    ApplicationArea = All;
                }
                field("Net Earning Amount"; "Net Earning Amount")
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
            action("Calculate Interest")
            {
                Image = CalculateCost;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    DividendHeader.GET("Document No.");
                    DividendHeader.TESTFIELD(Status, DividendHeader.Status::New);
                    CalculateDividends.SetDocumentNo("Document No.", DividendHeader."Calculation End Date");
                    CalculateDividends.RUN;
                end;
            }
        }
    }



    var
        CalculateDividends: Report "Calculate Boresha Int";
        DividendHeader: Record "Dividend Header";
}

