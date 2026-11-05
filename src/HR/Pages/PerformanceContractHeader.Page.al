page 50928 "Performance Contract Header"
{
    Caption = 'Performance Contract';
    PageType = Card;
    SourceTable = "Performance Contract";


    layout
    {
        area(content)
        {
            group(General)
            {
                field("Appraisal Year"; "Appraisal Year")
                {
                    ApplicationArea = All;
                }
                field("Employee No."; "Employee No.")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; "Employee Name")
                {
                    ApplicationArea = All;
                }
                field("Job Title"; "Job Title")
                {
                    ApplicationArea = All;
                }
                field(Branch; "Branch Name")
                {
                    ApplicationArea = All;
                }
                field(Department; "Department Name")
                {
                    ApplicationArea = All;
                }
                field("Employment Date"; "Employment Date")
                {
                    ApplicationArea = All;
                }
                field("Apprasier No."; "Apprasier No.")
                {
                    ApplicationArea = All;
                }
                field("Appraiser Name"; "Appraiser Name")
                {
                    ApplicationArea = All;
                }
                field("Appraiser Job Title"; "Appraiser Job Title")
                {
                    ApplicationArea = All;
                }
            }
            part("Quantitative Goals"; "Quantitative Goals Lines")
            {
                SubPageLink = "No." = FIELD("No.");
                ApplicationArea = all;
            }
            part("Qualitative Goals"; "Qualitative Goals Lines")
            {
                SubPageLink = "No." = FIELD("No.");
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Submit Contract")
            {
                Image = SendConfirmation;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = Submitted = false;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    IF CONFIRM(StrSubstNo(Text000, "Appraisal Year")) THEN BEGIN
                        Submitted := true;
                        MODIFY;
                        MESSAGE(Text001);
                        CurrPage.CLOSE;
                    END;
                end;
            }
        }
    }
    var
        Text000: Label 'Are you sure you want to submit your performance contract for period %1?';
        Text001: Label 'Submitted successfully!';

    trigger OnOpenPage()
    begin
        if Submitted then
            CurrPage.Editable(false);
    end;
}

