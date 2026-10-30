page 50822 "Requisitions List"
{

    Caption = 'Requisitions List';
    PageType = List;
    SourceTable = "Requisition Header";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field("Requested By"; "Requested By")
                {
                    ApplicationArea = All;
                }
                field("Requisition Date"; "Requisition Date")
                {
                    ApplicationArea = All;
                }
                field("Requisition Type"; "Requisition Type")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
