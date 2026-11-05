page 50061 "Teller Transaction Subform"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Teller Transaction Line";
    RefreshOnActivate = true;
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(Teller)
            {
                field("Account Type"; "Account Type")
                {
                    ApplicationArea = All;

                }
                field("Member No."; "Member No.")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin

                    end;

                }
                field("Member Name"; "Member Name")
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

                }

                field("Line Amount"; "Line Amount")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        CurrPage.Update()
                    end;

                }
            }
        }

    }

    /*  actions
     {
         area(Processing)
         {
             action(Post)
             {
                 ApplicationArea = All;

                 trigger OnAction();
                 begin

                 end;
             }
         }
     } */

    var



}