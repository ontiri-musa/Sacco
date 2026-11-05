page 50008 "Account Signatory Application"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Account Signatory Application";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("First Name"; "First Name")
                {
                    ApplicationArea = All;
                }
                field("Middle Name"; "Middle Name")
                {
                    ApplicationArea = All;
                }
                field("Last Name"; "Last Name")
                {
                    ApplicationArea = All;
                }
                field("Date of Birth"; "Date of Birth")
                {
                    ApplicationArea = All;
                }
                field("Identification No."; "Identification No.")
                {
                    ApplicationArea = All;
                }
                field(Signatory; Signatory)
                {
                    ApplicationArea = All;
                }
                field(Picture; Picture)
                {
                    ApplicationArea = All;
                }
                field("Front ID"; "Front ID")
                {
                    ApplicationArea = All;
                }
                field("Back ID"; "Back ID")
                {
                    ApplicationArea = All;
                }
                field(Signature; Signature)
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            part(SP; "Signatory Picture Application")
            {
                ApplicationArea = All;
                Caption = 'Picture';
                SubPageLink = "Account No." = field("Account No."), "Entry No." = field("Entry No.");
            }
            part(FID; "Signatory Front ID Application")
            {
                ApplicationArea = All;
                Caption = 'Front ID';
                SubPageLink = "Account No." = field("Account No."), "Entry No." = field("Entry No.");
            }
            part(BID; "Signatory Back ID Application")
            {
                ApplicationArea = All;
                Caption = 'Back ID';
                SubPageLink = "Account No." = field("Account No."), "Entry No." = field("Entry No.");
            }
            part(SIG; "Signatory Signature Appl.")
            {
                ApplicationArea = All;
                Caption = 'Signature';
                SubPageLink = "Account No." = field("Account No."), "Entry No." = field("Entry No.");
            }
        }
    }
}