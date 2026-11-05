page 50212 "Loan Product Type Card"
{
    // version TL2.0

    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Related Information,Approval Request,Comments,Category 7,Category 8';
    SourceTable = "Loan Product Type";
    DeleteAllowed = false;
    ModifyAllowed = true;
    InsertAllowed = true;
    Editable = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Interest Rate"; "Interest Rate")
                {
                    ApplicationArea = All;
                }
                field("Repayment Method"; "Repayment Method")
                {
                    ApplicationArea = All;
                }
                field("Repayment Period"; "Repayment Period")
                {
                    ApplicationArea = All;
                }
                field("Grace Period"; "Grace Period")
                {
                    ApplicationArea = All;
                }
                field(ChargeInterestUpfront; ChargeInterestUpfront)
                {
                    ApplicationArea = All;
                }
                field(Consolidation; Consolidation)
                {
                    ApplicationArea = All;
                }
                field("Rounding Precision"; "Rounding Precision")
                {
                    ApplicationArea = All;
                }
                field("Min. Loan Amount"; "Min. Loan Amount")
                {
                    ApplicationArea = All;
                }
                field("Max. Loan Amount"; "Max. Loan Amount")
                {
                    ApplicationArea = All;
                }
                field(Category; Category)
                {
                    ApplicationArea = All;
                }
                field("Min. Membership period"; "Min. Membership period")
                {
                    ApplicationArea = All;
                }
                field("Repayment Frequency"; "Repayment Frequency")
                {
                    ApplicationArea = All;
                }
                field("E-Loan"; "E-Loan")
                {
                    ApplicationArea = All;
                }
                field("Security Type"; "Security Type")
                {
                    ApplicationArea = All;
                }
                field("Apply Graduation Schedule"; "Apply Graduation Schedule")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        ValidateLoanProduct;
                    end;
                }
                field("Minimum Deposit Amount"; "Minimum Deposit Amount")
                {
                    ApplicationArea = All;
                }

                field("Based on Deposits"; "Based on Deposits")
                {
                    ApplicationArea = All;
                }
                group(Deposit)
                {
                    Caption = '';
                    Visible = "Based on Deposits" = TRUE;

                    field("Loan Deposit Ratio"; "Loan Deposit Ratio")
                    {
                        ApplicationArea = All;
                    }
                    field("Apply Special Ratio-Deposits"; "Apply Special Ratio-Deposits")
                    {
                        ApplicationArea = All;
                    }
                }
                field("Based on Shares"; "Based on Shares")
                {
                    ApplicationArea = All;
                }
                group(Shares)
                {
                    Caption = '';
                    Visible = "Based on Shares" = TRUE;

                    field("Loan Shares Ratio"; "Loan Shares Ratio")
                    {
                        ApplicationArea = All;
                    }
                    field("Apply Special Ratio-Shares"; "Apply Special Ratio-Shares")
                    {
                        ApplicationArea = All;
                    }
                }
                field("Based on Savings"; "Based on Savings")
                {
                    ApplicationArea = All;
                }
                group(Savings)
                {
                    Caption = '';
                    Visible = "Based on Savings" = TRUE;

                    field("Loan Savings Ratio"; "Loan Savings Ratio")
                    {
                        ApplicationArea = All;
                    }
                    field("Apply Special Ratio-Savings"; "Apply Special Ratio-Savings")
                    {
                        ApplicationArea = All;
                    }
                }


                field("Allow Multiple Loans"; "Allow Multiple Loans")
                {
                    ApplicationArea = All;
                }
                field("No. of Loans at a Time"; "No. of Loans at a Time")
                {
                    ApplicationArea = All;
                }
                field("Turn Around Time"; "Turn Around Time")
                {
                    ApplicationArea = All;
                }

                field("Paybill Short Code"; "Paybill Short Code")
                {
                    ApplicationArea = All;
                }
                group(EloanThreshHold)
                {
                    Caption = '';
                    Visible = "E-Loan" = true;
                    field("E-Loan Threshold"; "E-Loan Threshold")
                    {
                        ApplicationArea = All;
                    }
                }
                field("No. of Guarantors"; "No. of Guarantors")
                {
                    ApplicationArea = All;
                }

                field("Recovery Method"; "Recovery Method")
                {
                    ApplicationArea = All;
                }
                group(RecoverOnSpecificDay)
                {
                    Caption = '';
                    Visible = "Recovery Method" = 2;
                    field("Recovery Day"; "Recovery Day")
                    {
                        ApplicationArea = All;
                    }
                }
                field("Apply Special Recovery Method"; "Apply Special Recovery Method")
                {
                    ApplicationArea = All;
                }


                field("Allow Refinancing"; "Allow Refinancing")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        ValidateLoanProduct;
                    end;
                }
                group(Refinancing)
                {
                    Caption = '';
                    Visible = "Allow Refinancing" = TRUE;
                    field("Refinancing Mode"; "Refinancing Mode")
                    {
                        ApplicationArea = All;
                    }
                }
                field("Apply Special Repayment Rates"; "Apply Special Repayment Rates")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        ValidateLoanProduct;
                    end;
                }
                field("Boost on Recovery"; "Boost on Recovery")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        ValidateLoanProduct;
                    end;
                }
                field("Apply Induplum Rule"; "Apply Induplum Rule")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field("Graduation Based On"; "Graduation Based On")
                {
                    ApplicationArea = All;
                }
                field("Graduation Factor"; "Graduation Factor")
                {
                    ApplicationArea = all;
                }
                field("Graduation Qualifying Amount"; "Graduation Qualifying Amount")
                {
                    ApplicationArea = All;
                }
            }
            group(Posting)
            {
                field("Loan Posting Group"; "Loan Posting Group")
                {
                    ApplicationArea = All;
                }

                field("Interest Due Posting Group"; "Interest Due Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Interest Paid Posting Group"; "Interest Paid Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Ledger Fee Due Posting Group"; "Ledger Fee Due Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Ledger Fee Paid Posting Group"; "Ledger Fee Paid Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Interest Capitalization Method"; "Interest Capitalization Method")
                {
                    ApplicationArea = All;
                }
                group(CapitalizeSpecificDay)
                {
                    Caption = '';
                    Visible = "Interest Capitalization Method" = 1;
                    field("Interest Cap. Day"; "Interest Cap. Day")
                    {
                        ApplicationArea = All;
                    }
                }
                field("Apply Special Int. Cap Method"; "Apply Special Int. Cap Method")
                {
                    ApplicationArea = All;
                }

                field("Charge Penalty on Defaulters"; "Charge Penalty on Defaulters")
                {
                    ApplicationArea = All;
                }
                group(Penalty)
                {
                    Caption = '';
                    Visible = "Charge Penalty on Defaulters";

                    field("Penalty Due Posting Group"; "Penalty Due Posting Group")
                    {
                        ApplicationArea = All;
                    }
                    field("Penalty Paid Posting Group"; "Penalty Paid Posting Group")
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Loan Charges")
            {
                Image = CalculateCost;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    LoanCharge.FILTERGROUP(10);
                    LoanCharge.SETRANGE("Loan Product Type", Rec.Code);
                    LoanCharge.FILTERGROUP(0);
                    PAGE.RUN(50214, LoanCharge);
                end;
            }
            action("Special Repayment Rates")
            {
                Image = Price;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsMoreRatesVisible;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    LoanRates.FILTERGROUP(10);
                    LoanRates.SETRANGE("Loan Product Type", Rec.Code);
                    LoanRates.FILTERGROUP(0);
                    PAGE.RUN(50215, LoanRates);
                end;
            }
            action("Refinancing Charges")
            {
                Image = FinChargeMemo;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page 50225;
                RunPageLink = "Loan Product Code" = FIELD(Code);
                Visible = IsRefinancingChargeVisible;
                ApplicationArea = All;
            }
            action("Graduation Schedule")
            {
                Image = IssueFinanceCharge;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page 50218;
                RunPageLink = "Loan Product Code" = FIELD(Code);
                Visible = IsGraduationScheduleVisible;
                ApplicationArea = All;
            }
            action("Boost Account Types")
            {
                Image = GiroPlus;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page 50335;
                RunPageLink = "Loan Product Type" = FIELD(Code);
                Visible = IsBoostAccountTypeVisible;
                ApplicationArea = All;
            }
            action("SpecialDSSRatio")
            {
                Caption = 'Special DSS Ratio';
                Image = Allocate;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                Visible = "Apply Special Ratio-Deposits";
                RunObject = Page 51332;
                RunPageLink = "Loan Product Code" = FIELD(Code);
                trigger OnAction()
                begin

                end;
            }
            action("SpecialLoanRecovery")
            {
                Caption = 'Special Loan Recovery';
                Image = Allocate;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                RunObject = Page 51333;
                Visible = "Apply Special Recovery Method";
                RunPageLink = "Loan Product Code" = FIELD(Code);
                trigger OnAction()
                begin

                end;
            }
            action("SpecialInterestCapDay")
            {
                Caption = 'Special Interest Cap.';
                Image = Allocate;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                RunObject = Page 51334;
                Visible = "Apply Special Int. Cap Method";
                RunPageLink = "Loan Product Code" = FIELD(Code);
                trigger OnAction()
                begin

                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        ValidateLoanProduct;
    end;

    var
        LoanCharge: Record "Loan Product Charge";
        LoanRates: Record "LP Special Repayment Rate";
        IsMoreRatesVisible: Boolean;
        IsGraduationScheduleVisible: Boolean;
        IsRefinancingChargeVisible: Boolean;
        IsBoostAccountTypeVisible: Boolean;

    local procedure ValidateLoanProduct()
    begin
        IF "Apply Special Repayment Rates" THEN
            IsMoreRatesVisible := TRUE
        ELSE
            IsMoreRatesVisible := FALSE;

        IF "Apply Graduation Schedule" THEN
            IsGraduationScheduleVisible := TRUE
        ELSE
            IsGraduationScheduleVisible := FALSE;

        IF "Allow Refinancing" THEN
            IsRefinancingChargeVisible := TRUE
        ELSE
            IsRefinancingChargeVisible := FALSE;

        IF "Boost on Recovery" THEN
            IsBoostAccountTypeVisible := TRUE
        ELSE
            IsBoostAccountTypeVisible := FALSE;
    end;
}

