report 50201 "Group Allocation Sheet"
{

    DefaultLayout = RDLC;
    RDLCLayout = 'Report/BOSA/Group Allocation Sheet.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem(DataItem1; "Group Allocation Header")
        {
            RequestFilterFields = "No.";
            column(No_GroupAllocationHeader; "No.")
            {
            }
            column(Description_GroupAllocationHeader; Description)
            {
            }
            column(GroupNo_GroupAllocationHeader; "Group No.")
            {
            }
            column(GroupName_GroupAllocationHeader; "Group Name")
            {
            }
            column(LoanOfficerID_GroupAllocationHeader; "Loan Officer ID")
            {
            }
            column(AllocationDate_GroupAllocationHeader; "Created Date")
            {
            }
            column(AllocationTime_GroupAllocationHeader; "Created Time")
            {
            }
            column(Picture; CompanyInfo.Picture)
            {
            }
            column(CompData1; CompData[1])
            {
            }
            column(CompData2; CompData[1])
            {
            }
            column(ReportCode; MicroCreditSetup."Group Allocation Report Code")
            {
            }
            dataitem(DataItem23; "Group Allocation Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Transaction No.");
                column(DocumentNo_GroupAllocationLine; "Document No.")
                {
                }
                column(TransactionNo_GroupAllocationLine; "Transaction No.")
                {
                }
                column(Description_GroupAllocationLine; Description)
                {
                }
                column(TransactionDate_GroupAllocationLine; FORMAT("Transaction Date", 0, '<Day,2>-<Month,2>-<Year4>'))
                {
                }
                column(TransactionTime_GroupAllocationLine; FORMAT("Transaction Time", 0, '<Hours24,2><Filler Character,0>:<Minutes,2>:<Seconds,2>'))
                {
                }
                column(SenderName_GroupAllocationLine; "Sender Name")
                {
                }
                column(PhoneNo_GroupAllocationLine; "Phone No.")
                {
                }
                column(MemberNo_GroupAllocationLine; "Group No.")
                {
                }
                column(DepositedAmount_GroupAllocationLine; FORMAT("Deposited Amount", 0, '<Sign><Integer Thousand><1000Character,,>'))
                {
                }
                column(AllocatedAmount_GroupAllocationLine; "Allocated Amount")
                {
                }
                column(RemainingAmount_GroupAllocationLine; "Remaining Amount")
                {
                }
                dataitem(DataItem10; "Group Member Allocation")
                {
                    DataItemLink = "Document No." = FIELD("Document No."), "Transaction No." = FIELD("Transaction No.");
                    DataItemTableView = SORTING("Document No.", "Transaction No.", "Line No.");
                    column(TransactionNo_GroupMemberAllocation; "Transaction No.")
                    {
                    }
                    column(MemberNo_GroupMemberAllocation; "Member No.")
                    {
                    }
                    column(MemberName_GroupMemberAllocation; "Member Name")
                    {
                    }
                    column(AmountDue_GroupMemberAllocation; "Amount Due")
                    {
                    }
                    column(AccountNo_GroupMemberAllocation; "Account No.")
                    {
                    }
                    column(AccountName_GroupMemberAllocation; "Account Name")
                    {
                    }
                    column(AllocationAmount_GroupMemberAllocation; FORMAT("Allocation Amount", 0, '<Sign><Integer Thousand><1000Character,,>'))
                    {
                    }
                }
            }

            trigger OnPreDataItem();
            begin
                CompData[1] := CompanyInfo.Name;
                CompData[2] := CompanyInfo.Address;
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
        ReportTitle = 'Group Allocation Sheet';
    }

    trigger OnPreReport();
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
        MicroCreditSetup.GET;
    end;

    var
        CompanyInfo: Record "Company Information";
        CompData: array[4] of Code[30];
        MicroCreditSetup: Record "Microcredit Setup";
}

