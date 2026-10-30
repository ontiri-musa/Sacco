table 50307 SasraReportsMappingSetup
{
    Caption = 'Sasra Reports Mapping Setup';
    DataClassification = ToBeClassified;
    // version TL2.0
    fields
    {
        field(1; Code; Code[20])
        {
            NotBlank = true;
        }
        field(2; "Local Notes & Coins"; Code[250])
        { }

        field(3; "Foreign Notes & Coins"; Code[250])
        { }
        field(4; "Bal Commercial Banks"; Code[250])
        {
            Caption = 'Balances With Commercial Banks';
        }
        field(5; "Time Deposits"; Code[250])
        {
            Caption = 'Time Deposits with Banks more Than 90 Days';
        }
        field(6; "Overdratfs & Matured"; Code[250])
        {
            Caption = 'Overdrafts and Matured loans & advances from domestic banks';
        }
        field(7; "Sacco Balances"; Code[250])
        {
            Caption = 'Balances with other saccos';
        }
        field(8; "Other Balances"; Code[250])
        {
            Caption = 'Other institutions balances';
        }
        field(9; "Balances Due Saccos"; Code[250])
        {
            Caption = 'Balances due to other saccos';
        }
        field(10; "Balances Due Others"; Code[250])
        {
            Caption = 'Balances due to other Institutions';
        }
        field(11; "Matured Loans & Advances"; Code[250])
        {
            Caption = 'Matured Loans & Advances received from other intitutions not banks';
        }
        field(12; "Treasury Bills"; Code[250])
        {
            Caption = 'Treasury Bills';
        }
        field(13; "Treasury Bonds"; Code[250])
        {
            Caption = 'Treasury Bonds';
        }
        field(14; "Member Deposits"; Code[250])
        {
            Caption = 'Member Deposits';
        }
        field(15; "Other Deposits"; Code[250])
        {
            Caption = 'Other Deposits from other sources';
        }
        field(16; "Interest on Portfolio"; Code[250])
        {
            Caption = 'Interest On Loan Portfolio';
        }
        field(17; "Fees & Comm"; Code[250])
        {
            Caption = 'Fees & Commision on Loan Portfolio';
        }
        field(18; "Government Securities"; Code[250])
        {
            Caption = 'Government Securities';
        }
        field(19; "Placement"; Code[250])
        {
            Caption = 'Placement in Banks, Saccos';
        }
        field(20; "Commercial Papers"; Code[250])
        {
            Caption = 'Commercial Papers, notes and bonds';
        }
        field(21; "Collective Investment"; Code[250])
        {
            Caption = 'Collective Investment Schemes';
        }
        field(22; "Derivatives"; Code[250])
        {
            Caption = 'Derivatives';
        }
        field(23; "Equity Investments"; Code[250])
        {
            Caption = 'Equity Investments in subsidiaries and related entities';
        }
        field(24; "Investment in Company Shares"; Code[250])
        {
            Caption = 'Investment in Company Shares';
        }
        field(25; "Interest Expense on Deposits"; Code[250])
        {
            Caption = 'Interest Expense on Deposits';
        }
        field(26; "Cost of External Borrowings"; Code[250])
        {
            Caption = 'Cost of External Borrowings';
        }
        field(27; "Dividend Expenses"; Code[250])
        {
            Caption = 'Dividend Expenses on  Member Shares';
        }
        field(28; "Other Financial Expense"; Code[250])
        {
            Caption = 'Other Financial Expense';
        }
        field(29; "Fees & Comm Expense"; Code[250])
        {
            Caption = 'Fees & Comm Expense';
        }
        field(30; "Other Expense"; Code[250])
        {
            Caption = 'Other Expense';
        }
        field(31; "Provision for loan Losses"; Code[250])
        {
            Caption = 'Provision for loan Losses';
        }
        field(32; "Value of Loans Recovered"; Code[250])
        {
            Caption = 'Value of Loans Recovered';
        }
        field(33; "Personnel Expense"; Code[250])
        {
            Caption = 'Personnel Expense';
        }
        field(34; "Governance Expense"; Code[250])
        {
            Caption = 'Governance Expense';
        }
        field(35; "Marketing Expense"; Code[250])
        {
            Caption = 'Marketing Expense';
        }
        field(36; "Depreciation & Amortization"; Code[250])
        {
            Caption = 'Depreciation & Amortization Charges';
        }
        field(37; "Administrative Expense"; Code[250])
        {
            Caption = 'Administrative Expense';
        }
        field(38; "Non-Operating Income"; Code[250])
        {
            Caption = 'Non-Operating Income';
        }
        field(39; "Non-Operating Expense"; Code[250])
        {
            Caption = 'Non-Operating Expense';
        }
        field(40; "Taxes"; Code[250])
        {

        }
        field(41; "Donations"; Code[250])
        {

        }
        field(42; "Share Capital"; Code[250])
        {
            Caption = 'Share Capital';
            TableRelation = "G/L Account";
        }
        field(43; "Capital Grants"; Code[250])
        {
            Caption = 'Capital Grants';
        }
        field(44; "Retained Earnings"; Code[250])
        {
            Caption = 'Retained Earnings';
        }
        field(45; "Net Surplus after tax"; Code[250])
        {
            Caption = 'Net Surplus after tax';
        }
        field(46; "Statutory Reserves"; Code[250])
        {
            Caption = 'Statutory Reserves';
        }
        field(47; "Other Reserves"; Code[250])
        {
            Caption = 'Other Reserves';
        }
        field(48; "Investments in Subsidiary"; Code[250])
        {
            Caption = 'Investments in Subsidiary and equity';
        }
        field(49; "Other Deductions"; Code[250])
        {
            Caption = 'Other Deductions';
        }
        field(50; "Property & Equipment"; Code[250])
        {
            Caption = 'Property & Equipment net of depreciation';
        }
        field(51; "Other Assets"; Code[250])
        {
            Caption = 'Other Assets';
        }
        field(52; "Total Assets"; Code[250])
        {
            Caption = 'Total Assets';
        }
        field(53; "Non-Earning Assets"; Code[250])
        {
            Caption = 'Non-Earning Assets';
        }
        field(54; "Financial Investments"; Code[250])
        {
            Caption = 'Financial Investments';
        }
        field(55; "Land & Buildings"; Code[250])
        {
            Caption = 'Land & Buildings';
        }
        field(56; "Tax Recoverable"; Code[250])
        {
        }
        field(57; "Deferred Tax Assets"; Code[250])
        {
            Caption = 'Deferred Tax Assets';
        }
        field(58; "Retirement Benefit Assets"; Code[250])
        {
            Caption = 'Retirement Benefit Assets';
        }
        field(59; "Prepaid Lease Rentals"; Code[250])
        {
            Caption = 'Prepaid Lease Rentals';
        }
        field(60; "Intangible Assets"; Code[250])
        {
            Caption = 'Intangible Assets';
        }
        field(61; "Short Term Deposits"; Code[250])
        {
            Caption = 'Short Term Deposits';
        }
        field(62; "Dividends Payable"; Code[250])
        {
            Caption = 'Dividends Payable';
        }
        field(63; "Deferred Tax Liabilty"; Code[250])
        {
            Caption = 'Deferred Tax Liabilty';
        }
        field(64; "Retirement Benefits Liabilty"; Code[250])
        {
            Caption = 'Retirement Benefits Liabilty';
        }
        field(65; "Other Liabilties"; Code[250])
        {
            Caption = 'Other Liabilties';
        }
        field(66; "External Borrowings"; Code[250])
        {
            Caption = 'External Borrowings';
        }
        field(67; "Revaluation Reserves"; Code[250])
        {
            Caption = 'Revaluation Reserves';
        }
        field(68; "Cash in Hand"; Code[250])
        {
            Caption = 'Cash in Hand';
            TableRelation = "G/L Account";
        }
        field(69; "Cash at Bank"; Code[250])
        {
            Caption = 'Cash at Bank';
            TableRelation = "G/L Account";
        }
        field(70; "Gross Loan Portfolio"; Code[250])
        {
            Caption = 'Gross Loan Portfolio';
        }
        field(71; "Investment Properties"; Code[250])
        {
            Caption = 'Investment Properties';
        }
        field(72; "Core Capital"; Code[250])
        {
            Caption = 'Core Capital';
        }
        field(73; "Total Deposits"; Code[250])
        {
            Caption = 'Total Deposits';
        }
        field(74; "Balances Due Banks"; Code[250])
        {
            Caption = 'Balances Due Banks';
        }
        field(75; "Proposed Diviend"; Code[250])
        {
            Caption = 'Proposed Diviend';
        }
        field(76; "Prepaymen & Sundry"; Code[250])
        {
            Caption = 'Prepaymen & Sundry';
        }
        field(77; "Prior Year Retained Ern"; Code[250])
        {
            Caption = 'Prior Year Retained Ern';
        }
        field(78; "Curr Year Retained Ern"; Code[250])
        {
            Caption = 'Curr Year Retained Ern';
        }
    }


    keys
    {
        key(Key1; Code)
        {
        }
    }

    fieldgroups
    {
    }

}
