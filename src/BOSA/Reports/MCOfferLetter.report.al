report 55035 "MC Offer Letter"
{
    // version MC2.0

    DefaultLayout = RDLC;
    RDLCLayout = './Report/MicroCredit/MC Offer Letter.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(DataItem1; "Loan Application")
        {
            RequestFilterFields = "No.";
            column(HeaderLn1; "Header Ln1")
            {
            }
            column(HeaderLn2; "Header Ln2")
            {
            }
            column(HeaderLn3; "Header Ln3")
            {
            }
            column(HeaderLn4; "Header Ln4")
            {
            }
            column(ReferenceNo; "ReferenceNo:")
            {
            }
            column(Date; Date)
            {
            }
            column(Name; Name)
            {
            }
            column(PostalAddress; PostalAddress)
            {
            }
            column(PhysicalAddress; PhysicalAddress)
            {
            }
            column(Salutation; Salutation)
            {
            }
            column(AmountInWords; AmountInWords[1])
            {
            }
            column(ApprovedAmount_LoanApplications; "Approved Amount")
            {
            }
            column(ApplicationDate_LoanApplications; "Created Date")
            {
            }
            column(Interest_LoanApplications; "Interest Rate")
            {
            }
            /*      column(LoanPurpose_LoanApplications; "Loan Purpose")
                  {
                  }*/
            column(ReportName; ReportName)
            {
            }
            column(LoanDescription; LoanTypeDesc)
            {
            }
            column(NoofInstallments; NoofInstallments)
            {
            }
            column(InstallmentAmount; InstallmentAmount)
            {
            }
            column(AppraisalFee; AppraisalFee)
            {
            }
            column(RefinanceFee; RefinanceFee)
            {
            }
            column(InsuranceFee; InsuranceFee)
            {
            }
            column(FooterLn1; "Footer Ln1")
            {
            }
            column(FooterLn2; "Footer Ln2")
            {
            }
            column(Paragraph1Ln1; "Paragraph 1 Ln1")
            {
            }
            column(Paragraph1Ln2; "Paragraph 1 Ln2")
            {
            }
            column(Paragraph1Ln3; "Paragraph 1 Ln3")
            {
            }
            column(Title1; Title1)
            {
            }
            column(Title2; Title2)
            {
            }
            column(Title3; Title3)
            {
            }
            column(Title4; Title4)
            {
            }
            column(Title5; Title5)
            {
            }
            column(Title6; Title6)
            {
            }
            column(Title7; Title7)
            {
            }
            column(Title8; Title8)
            {
            }
            column(Title9; Title9)
            {
            }
            column(Title10; Title10)
            {
            }
            column(Title11; Title11)
            {
            }
            column(Title12; Title12)
            {
            }
            column(Title13; Title13)
            {
            }
            column(Title14; Title14)
            {
            }
            column(Title15; Title15)
            {
            }
            column(Text1; Text1)
            {
            }
            column(Text3; Text3)
            {
            }
            /*         column(Text2; "Loan Term")
                    {
                    } */
            column(Text3_1; "Text3.1")
            {
            }
            column(Text4; Text4)
            {
            }
            column(Text4_1; "Text4.1")
            {
            }
            column(Text5; Text5)
            {
            }
            column(Text6; Text6)
            {
            }
            column(Text7; Text7)
            {
            }
            column(Text7_1; "Text7.1")
            {
            }
            column(Text7_2; "Text7.2")
            {
            }
            column(Text8; Text8)
            {
            }
            column(Text9; Text9)
            {
            }
            column(Text9_1; "Text9.1")
            {
            }
            column(Text10; Text10)
            {
            }
            column(Text11; Text11)
            {
            }
            column(Text11_1; "Text11.1")
            {
            }
            column(Text12; Text12)
            {
            }
            column(Text12_1; "Text12.1")
            {
            }
            column(Text13; Text13)
            {
            }
            column(Text14; Text14)
            {
            }
            column(Text15; Text15)
            {
            }
            column(Text16; Text16)
            {
            }
            column(Text17; Text17)
            {
            }
            column(Text18; Text18)
            {
            }
            column(Text19; Text19)
            {
            }
            column(Text20; Text20)
            {
            }
            column(Text21; Text21)
            {
            }
            column(Text22; Text22)
            {
            }
            column(Text23; Text23)
            {
            }
            column(Text24; Text24)
            {
            }
            column(Text25; Text25)
            {
            }
            column(Text26; Text26)
            {
            }
            column(Text27; Text27)
            {
            }
            column(Text28; Text28)
            {
            }
            column(Text29; Text29)
            {
            }
            column(Text30; Text30)
            {
            }
            column(Text31; Text31)
            {
            }
            column(Text32; Text32)
            {
            }
            column(Text33; Text33)
            {
            }
            column(Text34; Text34)
            {
            }
            column(Text35; Text35)
            {
            }
            column(Text36; Text36)
            {
            }
            column(Text37; Text37)
            {
            }
            column(Text38; Text38)
            {
            }
            column(Text39; Text39)
            {
            }
            column(Text40; Text40)
            {
            }
            column(Text40_1; "Text40.1")
            {
            }
            column(Text41; Text41)
            {
            }
            column(Text42; Text42)
            {
            }
            column(Text43; Text43)
            {
            }
            column(Text44; Text44)
            {
            }
            column(PurposeDescription; PurposeDescription)
            {
            }
            column(Text45; LoanCollateralText)
            {
            }
            column(Title16; Title16)
            {
            }
            column(LoanGuarantorText; LoanGuarantorText)
            {
            }

            trigger OnAfterGetRecord();
            begin
                "ReferenceNo:" := "No.";
                Date := TODAY;
                PurposeDescription := '';
                MicroCreditMember.GET("Member No.");
                Name := MicroCreditMember."Full Name";

                PostalAddress := MicroCreditMember."Postal Address";
                PhysicalAddress := MicroCreditMember."Physical Address";

                Check.InitTextVariable();
                Check.FormatNoText(AmountInWords, "Approved Amount", '');
                AmountInWords[1] := DELCHR(AmountInWords[1], '>', '0123456789/');
                AmountInWords[1] := DELCHR(AmountInWords[1], '>', ' ');
                AmountInWords[1] := DELCHR(AmountInWords[1], '>', 'AND');
                AmountInWords[1] := DELCHR(AmountInWords[1], '=', '*');
                AmountInWords[1] := AmountInWords[1] + 'SHILLINGS ONLY';

                MemberLoanRepaymentSchedule.RESET;
                MemberLoanRepaymentSchedule.SETRANGE("Loan No.", "No.");
                IF MemberLoanRepaymentSchedule.FINDSET THEN BEGIN
                    NoofInstallments := MemberLoanRepaymentSchedule.COUNT;
                    InstallmentAmount := ROUND(MemberLoanRepaymentSchedule."Total Installment", 0.01, '>');
                END;

                LoanTypeDesc := '';
                LoanProductType.RESET;
                LoanProductType.SETRANGE(Code, "Loan Product Type");
                IF LoanProductType.FINDFIRST THEN BEGIN
                    LoanTypeDesc := LoanProductType.Description;
                END;

                LoanCollateralText := '';
                RegName := '';
                i := 1;
                LoanCollateral.RESET;
                LoanCollateral.SETRANGE("Loan No.", "No.");
                IF LoanCollateral.FINDSET THEN BEGIN
                    REPEAT
                        RegName := LoanCollateral.Description;
                        IF RegName = '' THEN
                            RegName := 'N/A';
                        LoanCollateralText += STRSUBSTNO(Text45, LoanCollateral."Security Type Code", LoanCollateral.Description, LoanCollateral."Security Value", LoanCollateral."Guaranteed Amount", i, RegName);
                        i += 1;
                    UNTIL LoanCollateral.NEXT = 0;
                END;

                LoanGuarantorText := '';
                j := 1;
                LoanGuarantors.RESET;
                LoanGuarantors.SETRANGE("Loan No.", "No.");
                IF LoanGuarantors.FINDSET THEN BEGIN
                    REPEAT
                        LoanGuarantorText += STRSUBSTNO(Text46, LoanGuarantors."Member No.", LoanGuarantors."Member Name", LoanGuarantors."Amount To Guarantee", j);
                        j += 1;
                    UNTIL LoanGuarantors.NEXT = 0;
                END;

                LoanProcessingCharges.RESET;
                LoanProcessingCharges.SETRANGE(Code, 'APPRAISAL');
                LoanProcessingCharges.SETRANGE("Loan Product Type", "Loan Product Type");
                IF LoanProcessingCharges.FINDFIRST THEN BEGIN
                    AppraisalFee := ABS(LoanProcessingCharges.Value);
                END;

                LoanProcessingCharges.RESET;
                LoanProcessingCharges.SETRANGE(Code, 'FINANCING');
                LoanProcessingCharges.SETRANGE("Loan Product Type", "Loan Product Type");
                IF LoanProcessingCharges.FINDFIRST THEN BEGIN
                    RefinanceFee := ABS(LoanProcessingCharges.Value);
                END;

                LoanProcessingCharges.RESET;
                LoanProcessingCharges.SETRANGE(Code, 'INS');
                LoanProcessingCharges.SETRANGE("Loan Product Type", "Loan Product Type");
                IF LoanProcessingCharges.FINDFIRST THEN BEGIN
                    InsuranceFee := ABS(LoanProcessingCharges.Value);
                END;

                //PurposeDescription := "Loan Purpose";
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        "Header Ln1": Label '"Our Ref: "';
        "ReferenceNo:": Code[20];
        "Header Ln2": Label '"Date: "';
        Date: Date;
        "Header Ln3": Label '"To: "';
        Name: Text;
        PostalAddress: Text;
        PhysicalAddress: Text;
        ReportName: Label 'OFFER LETTER';
        Salutation: Label '"Dear "';
        Check: Report 1401;
        AmountInWords: array[1] of Text;
        "Header Ln4": Label '"RE: LOAN FACILITY KES. "';
        "Footer Ln1": Label 'Read and Accepted';
        "Footer Ln2": Label 'Sign _________________';
        "Paragraph 1 Ln1": Label '"We refer to your application dated "';
        "Paragraph 1 Ln2": Label '"for "';
        "Paragraph 1 Ln3": Label 'and are pleased to advise that Tai Sacco Society Ltd has<b> APPROVED</b> the same subject to the following terms and conditions:';
        Title1: Label 'NAME OF BORROWER';
        Title2: Label 'FACILITY AMOUNT';
        Title3: Label 'LIMIT TYPE';
        Title4: Label 'PURPOSE';
        Title5: Label 'LENDING RATE';
        Title6: Label 'DEFAULT INTEREST';
        Title7: Label 'INSTALLMENT DATE';
        Title8: Label 'REPAYMENT PERIOD';
        Title9: Label 'MODE OF PAYMENT';
        Title10: Label 'TERMS AND CONDITIONS';
        Title11: Label 'DISBURSEMENT';
        Title12: Label 'SECURITY';
        Title13: Label 'VALIDITY OF OFFER';
        Title14: Label 'OTHER CONDITIONS';
        Title15: Label 'CREDIT REFERENCE BUREAU';
        Title16: Label 'GUARANTORS';
        Text1: Label 'Kshs.';
        Text2: Label '"Long Term Loan "';
        Text3: Label '"The proposed facility will be utilized for "';
        "Text3.1": Label 'The whole amount of the loan shall be used only for the purpose set out here in. The Sacco shall have the right to demand immediate payment of any amount of loan outstanding, together with interest, if it shall come to the notice of the Sacco that the whole or any part of the loan has been or is being expended for any other purpose.';
        Text4: Label 'The loan will be charged a rate of';
        "Text4.1": Label '"% per Annum. Review of interest chargeable shall be subject to prevailing economic environment.  However the Sacco reserves the right to vary the rate of interest at its sole discretion subject to compliance with any regulatory requirement at any time without reference to you.  "';
        Text5: Label 'In the event of any default, all facilities outstanding will become due and payable immediately. The amount in arrears will attract default interest at <b>3% </b>above the prevailing lending rate.';
        Text6: Label 'The first installment shall fall due <b>30 days</b> upon disbursement of the loan amount and the monthly repayment falls due.';
        Text7: Label '"The total loan will be paid in "';
        "Text7.1": Label '" monthly installments of Kshs. "';
        "Text7.2": Label '" per month."';
        Text8: Label 'You will be required to pay using any of the accepted mode within the Sacco services Platform for the said installment amount.';
        NoofInstallments: Integer;
        InstallmentAmount: Decimal;
        MemberLoanRepaymentSchedule: Record "Loan Repayment Schedule";
        Text9: Label '(a) Payment of <b>';
        "Text9.1": Label '%  </b>Appraisal fee on the loan amount subject to a minimum of <b>Kshs. 2,500.00</b> on execution of the letter of offer<b> ( Kshs.';
        AppraisalFee: Decimal;
        LoanProcessingCharges: Record "Loan Product Charge";
        Text10: Label '(b) The Sacco reserves the right to amend the facility amount approved.';
        Text11: Label '(c) Payment of <b>';
        "Text11.1": Label '%</b> risk management fee/Refinance fee of<b> 2%</b> (one off)<b> (Kshs.';
        Text12: Label '(d) Payment of Life Insurance Cover Premium of <b>';
        "Text12.1": Label '"%</b> per annum as per the duration of the loan<b> (Kshs. "';
        Text13: Label '(e) Payment of <b>3% loan negotiation and evaluation fees </b>of the loan amount subject to a minimum of <b>Kshs, 3,000.00</b> on execution of the letter of offer <b>(Kshs.';
        RefinanceFee: Decimal;
        Text14: Label 'The loan will only be disbursed in full upon completion of all lending requirements herein. Disbursement shall be subject to the Sacco meeting Regulatory Requirements';
        Text15: Label 'The security for the loan facility will be:<b> fill the applicable collateral </b>';
        InsuranceFee: Decimal;
        Text16: Label '(a) Signed transfer form on motor vehicle (Make/Model:_______________________________, Y.O.M:____________, Valued at Kshs.______________________)';
        Text17: Label '(b) Fully Charged Title LR No:______________________, Size:____________acres, located in:___________________________________________________, valued at Kshs._____________________';
        Text18: Label '(c) NWDs of Kshs._______________________ and a standing order of Kshs.___________________________pm/pa';
        Text19: Label '(d) Lien over cash deposit of Kshs._______________________ In favor of Tai Sacco Society Ltd.';
        Text20: Label '"(e) Professional Valuation of the said land/motor vehicle/Asset to be undertaken by a valuer within the Sacco''s panel. "';
        Text21: Label '(f) Satisfactory execution of the Sacco''s standard security forms and any other security as may be required in the Sacco from time to time.';
        Text22: Label '(g) The Vehicle provided as security to be comprehensively insured with an insurance company acceptable us and with our interest noted in the policies as first loss payee. We will have the right and option to pay the premium of the insurance policy covering the Vehicle provided as security by debiting your account if the insurance cover would not have been renewed by the time of expiry.';
        Text23: Label 'In case disbursement of the facility offered is not made within <b>30 days</b> from the date of execution of the letter of offer, the Sacco shall be at liberty to reassess the material circumstances of the client including but not limited to the legal and financial position of the customer. Where the circumstances are deemed to have fundamentally and adversely changed the Sacco may revoke the letter of offer or impose any other conditions in the letter of offer."';
        Text24: Label '"(a) The Sacco reserves the right to cancel this commitment, or to require the borrower to provide additional securities in the event that upon professional valuation of the securities as stated in the letter of offer, the value of the securities is not adequate to cover the total borrowing. "';
        Text25: Label '(b) You will be required to provide a valuation report(s) over the assets pledged as security under the security clause for as long as the assets pledged continue to be part of our security. A Sacco approved valuer will be mutually agreed upon beforehand and instructed by the Sacco. All valuation reports which must be addressed to Tai Sacco Society Ltd Sacco Ltd will be at your cost. The Sacco reserves the right to revalue the securities pledged at any time during the tenure of the facilities at your cost.';
        Text26: Label '(c) Additional security if at any time the value of the security provided is not commensurate with the facility amount or in the alternate the Sacco to reduce the facility amount';
        Text27: Label '(d) As with all Sacco facilities the loan remains payable on demand at the sole discretion of the Sacco. Tai Sacco Society Ltd Sacco Ltd also reserves the right to terminate the loan facility and call for its repayment in full in case of non-payment as per the agreed terms.';
        Text28: Label '(e) The Borrower hereby expressly consents and authorizes the Sacco to disclose, respond, advise, exchange and communicate the details or information pertaining to the Borrower''s account(s) to other Sacco''s, financial institutions, credit card companies, or credit reference bureaus, including authorized agents, representatives, lawyers or debt collection agents for the purposes of any bona fide enquiry or collection of any data or towards recovery of any Sums due and outstanding to the Sacco. The Borrower acknowledges that any information released by the Sacco under this clause may be used by the recipient to assess applications for credit by the Borrower or any related parties for debt tracing and for fraud prevention purposes.';
        Text29: Label '(f) No disbursement will be allowed before the security outlined above is perfected. You agree that any other cost that Tai Sacco Society Ltd Sacco Ltd may be required to incur in respect of preserving its rights under this agreement or over securities or recovering the loan herein i.e. costs for lawyers auctioneers and Insurances etc will be on your account and the Sacco is authorized by you to debit your account or to recover from you in any other manner.';
        Text30: Label '(g) Tai Sacco Society Ltd Sacco Ltd shall have the right to inspect the books of accounts, premises and assets or to appoint a representative to do so on its behalf.';
        Text31: Label '(h) It is a term of the facilities that we are authorized by you to apply, at our absolute discretion, all credit balances you may from time to time have with us in any account(s) in reduction of any sum then due to us in any other accounts(s) without reference or notice to you. The Sacco reserves the right to consolidate all securities held in any account for any or all liabilities held at its sole discretion.';
        Text32: Label 'The Borrower expressly consents and allows the Sacco to forward personal data and full file credit information to licensed credit reference bureaus in accordance with the Banking Act (Credit Reference Bureaus) Regulations, 2013';
        Text33: Label '"This letter of offer is sent to you in duplicate.  If you find the terms and conditions specified herein acceptable, <b>please initial on each page and sign on the last page to signify your acceptance </b>and return one copy to Tai Sacco Society Ltd .This letter of offer is valid for 15 days from the date herein stated.  If the acceptance is not received within 15 days from the date herein the offer will lapse unless the Sacco in its sole discretion agrees to extend the said period or to accept the executed letter.  "';
        Text34: Label 'We thank you and look forward to a mutually beneficial relationship.';
        Text35: Label '"Yours faithfully, "';
        Text36: Label 'Tai Sacco Society Ltd';
        Text37: Label 'Name Mr/Ms. ________________________                               Name Mr/Ms. __________________________';
        Text38: Label '"BRANCH MANAGER                                                             CREDIT SUPERVISOR "';
        Text39: Label 'ACCEPTANCE';
        Text40: Label 'I ____________________________________________________ hereby accept the Sacco arrangements in accordance with terms and conditions stated herein';
        "Text40.1": Label 'hereby accept the Sacco arrangements in accordance with terms and conditions stated herein ';
        Text41: Label 'Signature: ______________________________                      Date: __________________________________';
        Text42: Label 'ID No: _________________________________                      Tel: ___________________________________';
        Text43: TextConst;
        Text44: TextConst;
        /*     LoanPurpose : Record "loan pu"; */
        PurposeDescription: Text;
        LoanProductType: Record "Loan Product Type";
        LoanTypeDesc: Text;
        LoanCollateralText: Text;
        LoanCollateral: Record "Loan Collateral";
        Text45: Label '"<b>%5:</b>    <b>Security:</b> %1;  <b>Details:</b> %2;    <b>Registration Name:</b> %6;    <b>Value:</b> %3;    <b>Amount Guaranteed:</b> %4.<br>"';
        LoanGuarantors: Record "Loan Guarantor";
        LoanGuarantorText: Text;
        Text46: Label '"<b>%4:</b>    <b>Member Code:</b> %1;  <b>Member Name:</b> %2;    <b>Amount Guaranteed:</b> %3.<br>"';
        i: Integer;
        j: Integer;
        RegName: Text;
        MicroCreditMember: Record Member;
}

