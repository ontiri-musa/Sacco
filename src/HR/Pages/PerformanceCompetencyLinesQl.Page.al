page 50406 "Performance Competency Line-Ql"
{
    // version TL2.0

    PageType = ListPart;
    SourceTable = "Performance Competency Line-Ql";

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
                }
                field(Indicators; Indicators)
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }

                field("Employee Comment"; "Employee Comment")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Employee Score"; "Employee Score")
                {
                    ApplicationArea = All;
                }
                field("Appraiser Remarks"; "Appraiser Remarks")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Appraiser Score"; "Appraiser Score")
                {
                    ApplicationArea = All;
                }
                field("Agreed Score"; "Agreed Score")
                {
                    ApplicationArea = All;
                }
                field(Notes; Notes)
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

