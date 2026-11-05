page 50527 "Quantitative Goals"
{
    PageType = List;
    SourceTable = "Quantitative Goal";
    UsageCategory = Lists;
    ApplicationArea = all;

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
                field(Score; Score)
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

