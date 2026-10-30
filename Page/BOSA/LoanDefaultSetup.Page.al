page 50303 "Loan Defaulter Setup"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Loan Defaulter Setup";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Notification Channel"; "Notification Channel")
                {
                    ApplicationArea = All;
                }
                field("Notify Member"; "Notify Member")
                {
                    ApplicationArea = All;
                }

                field("First Notice Template"; "First Notice Template")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Second Notice Template-Member"; "Second Notice Template-Member")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }

                field("Third Notice-Member"; "Third Notice-Member")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Notify Guarantor"; "Notify Guarantor")
                {
                    ApplicationArea = All;
                }
                field("Second Notice-Guarantor"; "Second Notice-Guarantor")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Third Notice-Guarantor"; "Third Notice-Guarantor")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Grace Period"; "Grace Period")
                {
                    ApplicationArea = All;
                }
                field("Attach on"; "Attach on")
                {
                    ApplicationArea = All;
                }
                group(PostingDef)
                {
                    Caption = 'Posting';
                    field("Defaulter Template Name"; "Defaulter Template Name")
                    {
                        ApplicationArea = All;
                    }
                    field("Defaulter Batch Name"; "Defaulter Batch Name")
                    {
                        ApplicationArea = All;
                    }
                }
            }

            group("Demand Letter")
            {
                Caption = 'Demand Letter';
                grid(DemandLetter)
                {
                    group(DemandLetterTemp)
                    {
                        Caption = '';
                        field(DemandLetterTemplate; DemandLetterTemplate)
                        {
                            MultiLine = true;
                            ApplicationArea = All;
                            Caption = '';
                            trigger OnValidate()
                            begin
                                SetDemandLetterTemplate(DemandLetterTemplate);
                            end;
                        }
                    }
                }
            }
            group(Posting)
            {
                field("Loan Defaulter Template Name"; "Loan Defaulter Template Name")
                {
                    ApplicationArea = All;
                }
                field("Loan Defaulter Batch Name"; "Loan Defaulter Batch Name")
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        DemandLetterTemplate := GetDemandLetterTemplate;
    end;

    var
        DemandLetterTemplate: Text;
}

