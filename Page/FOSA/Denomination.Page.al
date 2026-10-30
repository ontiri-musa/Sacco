page 50119 Denomination
{
    // version TL2.0

    PageType = List;
    SourceTable = Denomination;

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
                field(Type; Type)
                {
                    ApplicationArea = All;
                }
                field(Value; Value)
                {
                    ApplicationArea = All;
                }
                field(Priority; Priority)
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

