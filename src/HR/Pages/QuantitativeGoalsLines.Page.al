page 50429 "Quantitative Goals Lines"
{
    // version TL2.0

    PageType = ListPart;
    SourceTable = "Quantitative Goals Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field(Objectives; Objectives)
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Action Plans"; "Action Plans")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field(Indicators; Indicators)
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }

                field("Agreed Weighting"; "Agreed Weighting")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

