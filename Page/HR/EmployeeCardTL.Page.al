page 50400 "Employee Card TL"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Employee;
    Caption = 'Employee Card';

    layout
    {
        area(Content)
        {
            group("Personal Information")
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
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
                field(Gender; Gender)
                {
                    ApplicationArea = All;
                }
                field("Birth Date"; "Birth Date")
                {
                    ApplicationArea = All;
                }
                field(Age; Age)
                {
                    ApplicationArea = All;
                }
                field("Marital Status"; "Marital Status")
                {
                    ApplicationArea = All;
                }
                field(Disability; Disability)
                {
                    ApplicationArea = All;
                }
                field("Blood Type"; "Blood Type")
                {
                    ApplicationArea = All;
                }
                field(Religion; Religion)
                {
                    ApplicationArea = All;
                }
                field(Tribe; Tribe)
                {
                    ApplicationArea = All;
                }
            }
            group("Job Information")
            {
                field("Employment Date"; "Employment Date")
                {
                    ApplicationArea = All;
                }
                field("Employee Type"; "Employee Type")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        TestField("Employment Date");
                    end;
                }
                field("Employee Status"; "Employee Status")
                {
                    Caption = 'Status';
                    ApplicationArea = All;
                }
                field("Probation Period"; "Probation Period")
                {
                    ApplicationArea = All;
                }

                field("Confirmation/Dismissal Date"; "Confirmation/Dismissal Date")
                {
                    Caption = 'Confirmation Date';
                    ApplicationArea = All;
                }
                field("Job Title"; "Job Title")
                {
                    ApplicationArea = All;
                }
                field(Grade; Grade)
                {
                    ApplicationArea = All;
                }
                field("Staff Category"; "Staff Category")
                {
                    ApplicationArea = All;
                }
                field("Supervisor ID"; "Supervisor ID")
                {
                    ApplicationArea = All;
                }
                field("Supervisor Name"; "Supervisor Name")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Phone No."; "Phone No.")
                {
                    Caption = 'Work Phone';
                    ApplicationArea = All;
                }
                field("Company E-Mail"; "Company E-Mail")
                {
                    ApplicationArea = All;
                }
            }
            group("Statutory Information")
            {
                field("National ID"; "National ID")
                {
                    ApplicationArea = All;
                }
                field("KRA PIN"; "PIN Number")
                {
                    ApplicationArea = All;
                }
                field(NSSF; NSSF)
                {
                    ApplicationArea = All;
                }
                field(NHIF; NHIF)
                {
                    ApplicationArea = All;
                }
                field("HELB No."; "HELB No.")
                {
                    ApplicationArea = All;
                }
                field("Bank Branch No."; "Bank Branch No.")
                {
                    ApplicationArea = All;
                }
                field("Bank Account No."; "Bank Account No.")
                {
                    ApplicationArea = All;
                }
                field("Basic Pay"; "Basic Pay")
                {
                    ApplicationArea = All;
                }
            }
            group("Contact Information")
            {
                field(Address; Address)
                {
                    ApplicationArea = All;
                }
                field("Post Code"; "Post Code")
                {
                    ApplicationArea = All;
                }
                field(City; City)
                {
                    Caption = 'Town';
                    ApplicationArea = All;
                }
                field("Mobile Phone No."; "Mobile Phone No.")
                {
                    ApplicationArea = All;
                }
                field("E-Mail"; "E-Mail")
                {
                    ApplicationArea = All;
                }
                field("Resident(Estate)"; "Resident(Estate)")
                {
                    ApplicationArea = All;
                }
                field("Street Address/Court"; "Street Address/Court")
                {
                    ApplicationArea = All;
                }
                field("House No."; "House No.")
                {
                    ApplicationArea = All;
                }

            }
            group("Professional Membership")
            {
                field("Union Code"; "Union Code")
                {
                    ApplicationArea = All;
                }
                field("Union Membership No."; "Union Membership No.")
                {
                    ApplicationArea = All;
                }
            }
            group("Probation Information")
            {

                field("Probation Start Date"; "Employment Date")
                {
                    ApplicationArea = All;
                }
                field("Probation Duration"; "Probation Period")
                {
                    ApplicationArea = All;
                }
                field("Probation End Date"; "Probation End Date")
                {
                    ApplicationArea = All;
                }
            }
            group("Clearance Details")
            {
                field("Certificate No."; "Certificate No.")
                {
                    ApplicationArea = All;
                }
                field("Date of Certificate"; "Date of Certificate")
                {
                    ApplicationArea = All;
                }
                field("Reference No."; "Reference No.")
                {
                    ApplicationArea = All;
                }
            }
            group(Confirmation)
            {
                field("Confirmation Status"; "Confirmation Status")
                {
                    ApplicationArea = All;
                }
                field("Confirmation_Dismissal Date"; "Confirmation/Dismissal Date")
                {
                    ApplicationArea = All;
                }
                field("Defer Confirmation"; "Defer Confirmation")
                {
                    ApplicationArea = All;
                }
                field("Extension Duration"; "Extension Duration")
                {
                    ApplicationArea = All;
                }
                field("Defer Start Date"; "Defer Start Date")
                {
                    ApplicationArea = All;
                }
                field("Defer End Date"; "Defer End Date")
                {
                    ApplicationArea = All;
                }
            }
        }

        area(factboxes)
        {
            part(Control3; "Employee Picture")
            {
                ApplicationArea = BasicHR;
                SubPageLink = "No." = FIELD("No.");
            }
            part(Control4; "Employee Front ID")
            {
                ApplicationArea = BasicHR;
                SubPageLink = "No." = field("No.");
            }
            part(Control5; "Employee Back ID")
            {
                ApplicationArea = BasicHR;
                SubPageLink = "No." = FIELD("No.");
            }
            part(Control6; "Employee Signature")
            {
                ApplicationArea = BasicHR;
                SubPageLink = "No." = FIELD("No.");
            }
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(5200), "No." = FIELD("No.");
            }
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = true;
            }
        }
    }



    actions
    {
        area(Processing)
        {


            action("&Relatives")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Relatives';
                Image = Relatives;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "Employee Relatives";
                RunPageLink = "Employee No." = FIELD("No.");
                ToolTip = 'Open the list of relatives that are registered for the employee.';
            }
            action("Mi&sc. Article Information")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Mi&sc. Article Information';
                Image = Filed;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "Misc. Article Information";
                RunPageLink = "Employee No." = FIELD("No.");
                ToolTip = 'Open the list of miscellaneous articles that are registered for the employee.';
            }
            action("&Confidential Information")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Confidential Information';
                Image = Lock;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "Confidential Information";
                RunPageLink = "Employee No." = FIELD("No.");
                ToolTip = 'Open the list of any confidential information that is registered for the employee.';
            }
            action("Q&ualifications")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Q&ualifications';
                Image = Certificate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "Employee Qualifications";
                RunPageLink = "Employee No." = FIELD("No.");
                ToolTip = 'Open the list of qualifications that are registered for the employee.';
            }

            action(Attachments)
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                Image = Attach;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                trigger OnAction()
                var
                    DocumentAttachmentDetails: Page "Document Attachment Details";
                    RecRef: RecordRef;
                begin
                    RecRef.GetTable(Rec);
                    DocumentAttachmentDetails.OpenForRecRef(RecRef);
                    DocumentAttachmentDetails.RunModal;
                end;
            }


        }
    }
    var
        SeeProbation: Boolean;

}