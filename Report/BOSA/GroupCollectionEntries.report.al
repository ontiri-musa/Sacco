report 55004 "Group Collection Entries"
{


    DefaultLayout = RDLC;
    RDLCLayout = 'Report/BOSA/Group Collection Entries.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(DataItem1; "Group Collection Entry")
        {
            RequestFilterFields = "Group No.", "Loan Officer ID", "Transaction Date", "Phone No.";
            column(TransactionNo_GroupCollectionEntry; "Transaction No.")
            {
            }
            column(TransactionDate_GroupCollectionEntry; FORMAT("Transaction Date", 0, '<Day,2>-<Month,2>-<Year4>'))
            {
            }
            column(TransactionTime_GroupCollectionEntry; FORMAT("Transaction Time", 0, '<Hours24,2><Filler Character,0>:<Minutes,2>:<Seconds,2>'))
            {
            }
            column(ExternalDocumentNo_GroupCollectionEntry; "External Document No.")
            {
            }
            column(Description_GroupCollectionEntry; Description)
            {
            }
            column(SenderName_GroupCollectionEntry; "Sender Name")
            {
            }
            column(PhoneNo_GroupCollectionEntry; "Phone No.")
            {
            }
            column(MemberNo_GroupCollectionEntry; "Group No.")
            {
            }
            column(DepositedAmount_GroupCollectionEntry; "Deposited Amount")
            {
            }
            column(LoanOfficerID_GroupCollectionEntry; "Loan Officer ID")
            {
            }
            column(AllocatedAmount_GroupCollectionEntry; "Allocated Amount")
            {
            }
            column(RemainingAmount_GroupCollectionEntry; "Remaining Amount")
            {
            }
            column(CompData1; CompData[1])
            {
            }
            column(Picture; CompanyInfo.Picture)
            {
            }
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
        ReportTitle = 'Group Collection Entries';
    }

    trigger OnPreReport();
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
        CompData[1] := CompanyInfo.Name;
    end;

    var
        CompanyInfo: Record 79;
        CompData: array[4] of Code[30];
}

