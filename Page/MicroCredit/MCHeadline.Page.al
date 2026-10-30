page 55102 "Headline RC MicroCredit"
{
    Caption = 'Headline';
    PageType = HeadlinePart;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                field(GreetingText; StrSubstNo(Text000, GetUser.GetUser()))
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            group(Control2)
            {
                field(ActiveGroupsText; StrSubstNo(Text001, GroupCount))
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    Editable = false;
                    trigger OnDrillDown();
                    begin
                        Members.Reset();
                        Members.SetRange(Status, Members.Status::Active);
                        Members.SetRange("Loan Officer ID", GetUser.GetUser());
                        if Members.FindSet() then
                            page.Run(50012, Members);
                    end;

                }
            }
            group(Control3)
            {
                field(GroupCollections; StrSubstNo(Text002, GroupCollections))
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    Editable = false;

                    trigger OnDrillDown();
                    begin
                        CollectionEntries.Reset();
                        CollectionEntries.SetRange("Loan Officer ID", GetUser.GetUser());
                        CollectionEntries.SetFilter("Remaining Amount", '<>%1', 0);
                        if CollectionEntries.FindSet() then
                            page.Run(55033, CollectionEntries);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        NoofGroups();
        UnallocatedAmounts();
    end;

    var
        [InDataSet]
        DefaultFieldsVisible: Boolean;
        [InDataSet]
        UserGreetingVisible: Boolean;
        GroupCount: Integer;
        GroupCollections: Decimal;
        CollectionEntries: Record "Group Collection Entry";
        GetUser: Codeunit "Get User";
        Members: Record Member;
        Text000: Label 'Welcome %1 ';
        Text001: Label 'There are %1 active Groups';
        Text002: Label '%1 unallocated group collections';

    local procedure NoofGroups()
    begin
        Members.Reset();
        Members.SetRange(Status, Members.Status::Active);
        Members.SetRange(Category, Members.Category::Group);
        //  Members.SetRange("Loan Officer ID", UserId);
        if Members.FindSet() then
            GroupCount := Members.Count;
    end;

    local procedure UnallocatedAmounts()
    begin
        CollectionEntries.Reset();
        // CollectionEntries.SetRange("Loan Officer ID", UserId);
        CollectionEntries.SetFilter("Remaining Amount", '<>%1', 0);
        if CollectionEntries.FindSet() then begin
            repeat
                GroupCollections += CollectionEntries."Remaining Amount";
            until CollectionEntries.Next() = 0;
        end;
    end;

}
