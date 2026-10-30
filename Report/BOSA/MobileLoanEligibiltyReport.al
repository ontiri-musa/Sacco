report 50027 "Mobile Loan Eligibilty Report"
{
    ApplicationArea = All;
    Caption = 'Mobile Loan Eligibilty Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'Report/BOSA/Mobile Loan Eligibility.rdl';

    dataset
    {
        dataitem(Member; Member)
        {
            RequestFilterFields = "No.", Status, "Dormancy Status", Gender, Category, "Registration Date";
            DataItemTableView = WHERE(Status = filter(Active), "Mobile Banking Member" = filter(true));

            column(No_; "No.")
            {
            }
            column(Full_Name; "Full Name")
            {
            }

            column(National_ID; "National ID")
            {
            }

            column(Phone_No_; "Phone No.")
            {

            }
            column(Name; CompanyInformation.Name)
            {
            }
            column(Address; CompanyInformation.Address)
            {
            }
            column(City; CompanyInformation.City)
            {
            }
            column(Post_Code; CompanyInformation."Post Code")
            {
            }
            column(Picture; CompanyInformation.Picture)
            {
            }
            column(NWDBalance; AccountBalance[4])
            {

            }
            column(NWDBalance2; GraduationAmount[3])
            {

            }
            column(MinEligible; EligibleAmount[1])
            {
            }
            column(MaxEligible; EligibleAmount[2])
            {
            }
            column(LoanDepositRatio; LoanDepositRatio)
            {
            }
            column(NetBalance; AccountBalance[3])
            {
            }
            column(ActiveMember; ActiveMember)
            {
            }
            column(Status; Status)
            {
            }
            column(isActive; isActive)
            {
            }
            column(DefaultedSaccoLoan; DefaultedSaccoLoan)
            {
            }
            column(NoOfEloan; NoOfEloan)
            {
            }
            column(PersonalSavings; SavingsAmount)
            {
            }
            column(DeductableAmt; DeductableAmt)
            {
            }
            column(GradFactor1; GraduationFactor[1])
            {
            }
            column(GradFactor2; GraduationFactor[2])
            {
            }
            column(DefaultedLoan; DefaultedLoan)
            {
            }
            column(MbrGuaranteedAmount; MbrGuaranteedAmount)
            {

            }
            column(availableDeposits; availableDeposits)
            {

            }
            column(secondGraduationFactor; secondGraduationFactor)
            {

            }
            column(serriesRange; serriesRange)
            {

            }
            column(serriesPercentage; serriesPercentage)
            {

            }
            trigger OnAfterGetRecord()
            begin

                if ChurchSection.Get("Church Section Code") then
                    SectionName := ChurchSection.Name;
                if (Member."Registration Date" = 0D) And (Member."Created Date" <> 0D) then begin
                    Member."Registration Date" := Member."Created Date";
                    Member.Modify();
                end;
                MobileMember.Reset();
                MobileMember.SetRange("Member No.", "No.");
                MobileMember.SetRange(Status, MobileMember.Status::Active);
                if not MobileMember.FindFirst() then begin
                    CurrReport.Skip();
                end;
                EligibleAmount[1] := 0;
                EligibleAmount[2] := 0;
                NoOfEloan := 0;
                DefaultedLoan := '';
                availableDeposits := 0;

                AccountBalance[1] := 0;
                AccountBalance[2] := 0;
                AccountBalance[3] := 0;
                AccountBalance[4] := 0;
                AccountBalance[5] := 0;
                AccountBalance[6] := 0;

                GraduationAmount[1] := 0;
                GraduationAmount[2] := 0;
                GraduationAmount[3] := 0;

                CLEAR(LoanDepositRatio);
                CLEAR(GraduationFactor[1]);
                CLEAR(GraduationFactor[2]);
                CLEAR(GraduationFactor[3]);

                SavingsAmount := 0;
                LoanDepositRatio := 0;
                DateJoined := 0D;
                DeductableAmt := 0;
                DefaultedSaccoLoan := FALSE;
                LoanApplication.RESET;
                LoanApplication.SETRANGE("Member No.", Member."No.");
                LoanApplication.SETRANGE(Posted, TRUE);
                IF LoanApplication.FINDSET THEN BEGIN
                    REPEAT
                        IF LoanProductType.GET(LoanApplication."Loan Product Type") THEN BEGIN
                            IF LoanProductType."E-Loan" = TRUE THEN begin
                                NoOfEloan += 1;
                            end else begin
                                LoanApplication.CALCFIELDS("Outstanding Balance");
                                IF (LoanApplication."Outstanding Balance" > 0) THEN BEGIN
                                    GlobalManagement.CalculateLoanArrearsAndOverpaymentFactbox(LoanApplication."No.", 0D, Today, PArrears, IArrears, LedgerFeeArr, PenaltyFeeArr, POverpayment, IOverpayment, LOverpayment, PenOverpayment);
                                    TotalArrears := PArrears + IArrears + LedgerFeeArr + PenaltyFeeArr;
                                    IF PArrears > 0 THEN BEGIN
                                        DefaultedSaccoLoan := TRUE;
                                        DefaultedLoan := LoanApplication.Description;
                                    END;
                                    IF IArrears > 0 THEN BEGIN
                                        DefaultedSaccoLoan := TRUE;
                                        DefaultedLoan := LoanApplication.Description;
                                    END;
                                END;
                            end;
                        END;
                    UNTIL LoanApplication.NEXT = 0;
                END ELSE BEGIN
                    LoanProductType.RESET;
                    LoanProductType.SETRANGE("E-Loan", TRUE);
                    IF LoanProductType.FINDFIRST THEN BEGIN
                        EligibleAmount[1] := LoanProductType."Min. Loan Amount";
                        EligibleAmount[2] := LoanProductType."Max. Loan Amount";
                    END;
                END;
                LoanProductType.RESET;
                LoanProductType.SETRANGE("E-Loan", TRUE);
                IF LoanProductType.FINDFIRST THEN BEGIN
                    EligibleAmount[1] := LoanProductType."Min. Loan Amount";
                    EligibleAmount[2] := LoanProductType."Max. Loan Amount";
                END;


                Vendor.RESET;
                Vendor.SETRANGE("Member No.", Member."No.");
                IF Vendor.FINDSET THEN BEGIN
                    REPEAT
                        IF AccountType.GET(Vendor."Account Type") THEN BEGIN
                            Vendor.CALCFIELDS(Balance);
                            IF AccountType.Type = AccountType.Type::"Share Capital" THEN BEGIN
                                AccountBalance[1] += Vendor.Balance;
                            END;
                            IF AccountType.Type = AccountType.Type::Savings THEN BEGIN
                                SavingsAmount += Vendor.Balance;
                            END;
                            IF AccountType.Type = AccountType.Type::"Member Deposit" THEN BEGIN
                                AccountBalance[4] += Vendor.Balance;
                            END;
                        END;
                    UNTIL Vendor.NEXT = 0;
                END;

                CalculateGuaranteedAmount(Member."No.", MbrGuaranteedAmount);
                AccountBalance[5] := AccountBalance[4];

                IF MbrGuaranteedAmount = 0 THEN BEGIN
                    AccountBalance[3] := AccountBalance[5];
                END;
                availableDeposits := LoanProductType."Loan Deposit Ratio" * AccountBalance[4];
                /*  IF MbrGuaranteedAmount > 0 THEN BEGIN
                      AccountBalance[7] := AccountBalance[5] - MbrGuaranteedAmount;
                      LoanProductType.RESET;
                      LoanProductType.SETRANGE("E-Loan", TRUE);
                      IF LoanProductType.FINDFIRST THEN BEGIN
                          IF AccountBalance[7] < LoanProductType."Max. Loan Amount" THEN BEGIN
                              AccountBalance[5] := AccountBalance[5] * LoanProductType."Loan Deposit Ratio";
                              AccountBalance[7] := AccountBalance[5] - MbrGuaranteedAmount;
                              AccountBalance[3] := AccountBalance[7];
                          END ELSE
                              AccountBalance[3] := AccountBalance[7];
                           end else begin
                                AccountBalance[3] := AccountBalance[7];
                            end;
                      END ELSE BEGIN
                          AccountBalance[3] := AccountBalance[5];
                      END;
                      //Error('act %1...net %2...guar %3', AccountBalance[4], AccountBalance[3], MbrGuaranteedAmount);
                      //AccountBalance[6] := AccountBalance[4] - MbrGuaranteedAmount;

                        if MbrGuaranteedAmount > AccountBalance[4] then
                            AccountBalance[3] := 80 / 100 * AccountBalance[4]
                        else
                            AccountBalance[3] := AccountBalance[3];
                  end;*/

                //  Message('%1,%2', LoanProductType."Loan Deposit Ratio", MbrGuaranteedAmount);
                if availableDeposits < MbrGuaranteedAmount then
                    AccountBalance[3] := availableDeposits
                else
                    AccountBalance[3] := availableDeposits - MbrGuaranteedAmount;


                AccountBalance[6] := AccountBalance[3];
                LoanProductType.RESET;
                LoanProductType.SETRANGE("E-Loan", TRUE);
                IF LoanProductType.FINDFIRST THEN BEGIN
                    EligibleAmount[1] := LoanProductType."Min. Loan Amount";
                    EligibleAmount[2] := LoanProductType."Max. Loan Amount";
                    IF AccountBalance[3] > 0 THEN
                        AccountBalance[2] := AccountBalance[3]
                    ELSE
                        AccountBalance[2] := 0;


                    /*   IF AccountBalance[2] <= 0 THEN BEGIN
                           EligibleAmount[1] := 0;
                           EligibleAmount[2] := 0;
                       END ELSE BEGIN
                           IF AccountBalance[2] < EligibleAmount[1] THEN BEGIN
                               EligibleAmount[1] := 0;
                               EligibleAmount[2] := 0;
                           END ELSE BEGIN
                               IF AccountBalance[2] <= EligibleAmount[2] THEN BEGIN
                                   EligibleAmount[2] := AccountBalance[2];
                               END;
                           END;
                       END;*/
                    IF LoanProductType."Graduation Based On" = LoanProductType."Graduation Based On"::Deposits THEN BEGIN
                        GraduationFactor[1] := LoanProductType."Graduation Factor";
                        GraduationFactor[2] := LoanProductType."Graduation Qualifying Amount";
                        LoanDepositRatio := AccountBalance[3] * (LoanProductType."Graduation Factor" / 100);
                        secondGraduationFactor := LoanDepositRatio * (LoanProductType."Graduation Qualifying Amount" / 100);
                        case true of
                            (NoOfEloan >= 0) and (NoOfEloan <= 10):
                                begin
                                    GraduationAmount[3] := 0.75 * secondGraduationFactor;
                                    serriesRange := '0-10';
                                    serriesPercentage := '0.75%';
                                end;
                            (NoOfEloan > 10) and (NoOfEloan <= 20):
                                begin

                                    GraduationAmount[3] := 0.80 * secondGraduationFactor;
                                    serriesRange := '10-20';
                                    serriesPercentage := '0.80%';
                                end;
                            (NoOfEloan > 20) and (NoOfEloan <= 30):
                                begin
                                    GraduationAmount[3] := 0.90 * secondGraduationFactor;
                                    serriesRange := '20-30';
                                    serriesPercentage := '0.90%';
                                end;
                            (NoOfEloan > 30) and (NoOfEloan <= 40):
                                begin
                                    GraduationAmount[3] := 0.95 * secondGraduationFactor;
                                    serriesRange := '30-40';
                                    serriesPercentage := '0.95%';
                                end;
                            (NoOfEloan > 40):
                                begin
                                    GraduationAmount[3] := 100 * secondGraduationFactor;
                                    serriesRange := '>40';
                                    serriesPercentage := '100%';
                                end;
                            else begin
                                GraduationAmount[3] := 0;
                                serriesRange := '..';
                                serriesPercentage := '0%';
                            end;

                        end;
                        IF GraduationAmount[3] < EligibleAmount[1] THEN BEGIN
                            EligibleAmount[1] := 0;
                            EligibleAmount[2] := 0;
                        END ELSE BEGIN
                            IF GraduationAmount[3] <= EligibleAmount[2] THEN BEGIN
                                EligibleAmount[2] := GraduationAmount[3];
                            END;
                        end;

                    END;

                    /* IF LoanProductType."Graduation Based On" = LoanProductType."Graduation Based On"::Deposits THEN BEGIN
                         GraduationFactor[1] := LoanProductType."Graduation Factor";
                         GraduationFactor[2] := LoanProductType."Graduation Qualifying Amount";
                         // Message('%1', AccountBalance[6]);
                         IF AccountBalance[6] <= 0 THEN BEGIN
                             EligibleAmount[1] := 0;
                             EligibleAmount[2] := 0;
                             LoanDepositRatio := 0;
                         end else begin
                             if AccountBalance[6] < LoanProductType."Minimum Deposit Amount" then begin
                                 EligibleAmount[1] := 0;
                                 EligibleAmount[2] := 0;
                                 LoanDepositRatio := 0;
                             END ELSE BEGIN
                                 GraduationAmount[1] := AccountBalance[6];
                                 LoanDepositRatio := AccountBalance[6] * (LoanProductType."Graduation Factor" / 100);
                                 IF GraduationAmount[1] > 0 THEN BEGIN
                                     GraduationAmount[2] := GraduationAmount[1] * (LoanProductType."Graduation Factor" / 100);

                                     GraduationAmount[3] := GraduationAmount[2];

                                     GraduationAmount[3] := GraduationAmount[2] * (LoanProductType."Graduation Qualifying Amount" / 100);
                                     GraduationAmount[3] := GraduationAmount[3];
                                     IF GraduationAmount[3] < EligibleAmount[1] THEN BEGIN
                                         EligibleAmount[1] := 0;
                                         EligibleAmount[2] := 0;
                                     END ELSE BEGIN
                                         IF GraduationAmount[3] <= EligibleAmount[2] THEN BEGIN
                                             EligibleAmount[2] := GraduationAmount[3];
                                         END;

                                     END;

                                 END
                             END;
                         end;
                     END;*/
                END;
                IF DefaultedSaccoLoan = TRUE THEN BEGIN
                    EligibleAmount[1] := 0;
                    EligibleAmount[2] := 0;
                END;


                k := 0;
                j := 0;
                ActiveMember := FALSE;
                IF Member."Date of Registration" <> 0D THEN
                    DateJoined := Member."Date of Registration";

                IF DateJoined <> 0D THEN BEGIN
                    NextDate := CALCDATE('1M', DateJoined);
                    WHILE NextDate <= TODAY DO BEGIN
                        j += 1;
                        NextDate := CALCDATE('1M', NextDate);
                    END;
                    k := TODAY - DateJoined;
                END;
                IF j > 3 THEN
                    ActiveMember := TRUE;

                if Member.Status = "Dormancy Status"::Active then
                    isActive := true
                else
                    isActive := false;

                /*  IF isActive = false THEN BEGIN
                      EligibleAmount[1] := 0;
                      EligibleAmount[2] := 0;
                      GraduationAmount[3] := 0;
                  END;*/

                // end;
            end;

            trigger OnPreDataItem()
            begin
                CompanyInformation.Get();
                if AsAtDate = 0D then
                    AsAtDate := Today;
            end;
        }
    }

    requestpage
    {


        layout
        {
            area(content)
            {

            }
        }


        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        AccountBal: array[7] of Decimal;
        AccountType: Record "Account Type";
        Vendor: Record Vendor;
        CompanyInformation: Record "Company Information";
        AsAtDate: date;
        SectionName: text[150];
        ChurchSection: Record "Church Section";
        DormancyStatus: Text;
        LoanProductType: Record "Loan Product Type";
        i: Integer;
        LoanApplication: Record "Loan Application";
        EligibleAmount: ARRAY[4] OF Decimal;
        AccountBalance: ARRAY[10] OF Decimal;
        StartDate2: Date;
        EndDate2: Date;
        PArrears2: Decimal;
        IArrears2: Decimal;
        POverpayment2: Decimal;
        IOverpayment2: Decimal;
        LoanDepositRatio: Decimal;
        DateJoined: Date;
        j: Integer;
        k: Integer;
        NextDate: Date;
        ActiveMember: Boolean;
        DefaultedSaccoLoan: Boolean;
        LoanGuarantor: Record 50105;
        MbrGuaranteedAmount: Decimal;
        NoOfEloan: Integer;
        DeductableAmt: Decimal;
        GraduationAmount: ARRAY[4] OF Decimal;
        GraduationFactor: ARRAY[3] OF Decimal;
        SavingsAmount: Decimal;
        DefaultedLoan: Text;
        MobileMember: Record "Mobile Banking Member";
        isActive: Boolean;
        availableDeposits: Decimal;
        secondGraduationFactor: Decimal;
        serriesRange: code[25];
        serriesPercentage: code[12];

    local procedure CalculateGuaranteedAmount(MemberNo: Code[20]; VAR GuaranteedAmount: Decimal)
    var
        LoanGuarantor: Record "Loan Guarantor";
        OtherAmountRatio: Decimal;
        Cust: Record Customer;
        LoanApplication: Record "Loan Application";
    begin
        GuaranteedAmount := 0;
        LoanGuarantor.RESET;
        LoanGuarantor.SETRANGE("Member No.", MemberNo);
        IF LoanGuarantor.FINDSET THEN BEGIN
            REPEAT
                OtherAmountRatio := 0;
                IF Cust.GET(LoanGuarantor."Loan No.") THEN BEGIN
                    Cust.CALCFIELDS(Cust.Balance);
                    LoanApplication.GET(LoanGuarantor."Loan No.");
                    IF (LoanApplication."Approved Amount" > 0) AND (LoanApplication.Posted = TRUE) THEN
                        OtherAmountRatio := LoanGuarantor."Amount To Guarantee" / LoanApplication."Approved Amount";
                    IF Cust.Balance > 0 THEN
                        GuaranteedAmount += (OtherAmountRatio * Cust.Balance);
                END;
            UNTIL LoanGuarantor.NEXT = 0;
        END;
    end;

    PROCEDURE CalculateLoanArrears(LoanNo: Code[20]; StartDate: Date; EndDate: Date; VAR PArrears: Decimal; VAR IArrears: Decimal; VAR POverpayment: Decimal; VAR IOverpayment: Decimal);
    VAR
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        InstallmentDue: ARRAY[4] OF Decimal;
        InstallmentPaid: ARRAY[4] OF Decimal;
        PPaidPreMigration: Decimal;
        LoanApp: Record 50101;
        RemainingBalance: Decimal;
        TransactionTypeCodeSetup: Record "Transaction Type Code Setup";
        HasSchedule: Boolean;
    BEGIN
        InstallmentDue[1] := 0;
        InstallmentDue[2] := 0;
        InstallmentPaid[1] := 0;
        InstallmentPaid[2] := 0;
        PArrears := 0;
        IArrears := 0;
        POverpayment := 0;
        IOverpayment := 0;
        RemainingBalance := 0;
        HasSchedule := false;
        TransactionTypeCodeSetup.Get();
        LoanRepaymentSchedule.RESET;
        LoanRepaymentSchedule.SETRANGE("Loan No.", LoanNo);
        LoanRepaymentSchedule.SETFILTER("Repayment Date", '..%1', EndDate);
        IF LoanRepaymentSchedule.FINDLAST THEN BEGIN
            //LoanRepaymentSchedule.CALCSUMS(LoanRepaymentSchedule."Principal Installment");
            InstallmentDue[1] := LoanRepaymentSchedule."Loan Amount";
            //InstallmentDue[2]+=LoanRepaymentSchedule."Interest Installment";
            RemainingBalance := InstallmentDue[1] - LoanRepaymentSchedule."Principal Installment";
            InstallmentDue[1] := RemainingBalance;
            HasSchedule := true;
        END;

        PPaidPreMigration := 0;

        CustLedgerEntry.RESET;
        CustLedgerEntry.SETRANGE("Customer No.", LoanNo);
        CustLedgerEntry.SETRANGE(CustLedgerEntry."Transaction Type Code", TransactionTypeCodeSetup."New Loan");
        IF CustLedgerEntry.FINDFIRST THEN BEGIN
            CustLedgerEntry.CALCFIELDS("Amount (LCY)");

            LoanApp.RESET;
            LoanApp.SETRANGE(LoanApp."No.", LoanNo);
            IF LoanApp.FINDFIRST THEN BEGIN
                IF LoanApp."Approved Amount" > CustLedgerEntry."Amount (LCY)" THEN
                    PPaidPreMigration := LoanApp."Approved Amount" - CustLedgerEntry."Amount (LCY)";
            END;
        END;


        CustLedgerEntry.RESET;
        CustLedgerEntry.SETRANGE("Customer No.", LoanNo);
        CustLedgerEntry.SETRANGE("Posting Date", StartDate, EndDate);
        IF CustLedgerEntry.FINDSET THEN BEGIN
            REPEAT
                CustLedgerEntry.CALCFIELDS("Amount (LCY)");
                IF (CustLedgerEntry."Transaction Type Code" = TransactionTypeCodeSetup."New Loan") OR
                  (CustLedgerEntry."Transaction Type Code" = TransactionTypeCodeSetup."Loan Prepayment") THEN
                    InstallmentPaid[1] += CustLedgerEntry."Amount (LCY)";
                IF CustLedgerEntry."Transaction Type Code" = TransactionTypeCodeSetup."Interest Paid" THEN
                    InstallmentPaid[2] += CustLedgerEntry."Amount (LCY)";
                IF CustLedgerEntry."Transaction Type Code" = TransactionTypeCodeSetup."Interest Due" THEN
                    InstallmentDue[2] += CustLedgerEntry."Amount (LCY)";
            UNTIL CustLedgerEntry.NEXT = 0;
        END;
        IF PPaidPreMigration > 0 THEN
            InstallmentPaid[1] := InstallmentPaid[1] + PPaidPreMigration;

        //MESSAGE('Principal Paid Total %1 Interest Paid Total %2',InstallmentPaid[1],InstallmentDue[1]);

        IF (InstallmentDue[1] < ABS(InstallmentPaid[1])) and (HasSchedule = true) THEN BEGIN
            PArrears := ABS(InstallmentPaid[1]) - InstallmentDue[1];
            POverpayment := 0;
        END ELSE BEGIN
            POverpayment := InstallmentDue[1] - ABS(InstallmentPaid[1]);
            PArrears := 0;
        END;
        IF InstallmentDue[2] > ABS(InstallmentPaid[2]) THEN BEGIN
            IArrears := InstallmentDue[2] - ABS(InstallmentPaid[2]);
            IOverpayment := 0;
        END ELSE BEGIN
            IOverpayment := ABS(InstallmentPaid[2]) - InstallmentDue[2];
            IArrears := 0;
        END;
    END;

    var
        GlobalManagement: Codeunit "Global Management";
        POverpayment: Decimal;
        IOverpayment: decimal;
        LedgerFeeArr: Decimal;
        PenaltyFeeArr: Decimal;
        TotalArrears: Decimal;
        PArrears: Decimal;
        IArrears: Decimal;
        LOverpayment: Decimal;
        PenOverpayment: decimal;
}
