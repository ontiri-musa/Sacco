report 50131 "Mobile Banking Transactions"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Report/FOSA/MobileTransactions2.rdl';
    dataset
    {
        dataitem(MobileBankingEntries; "Mobile Banking Ledger Entry")
        {
            RequestFilterFields = "Phone No.", "Transaction No.", "Transaction Date", "Service ID", "Transacted By";
            column(Transaction_No_; "Transaction No.")
            {

            }
            column(Phone_No_; "Phone No.")
            {

            }
            column(Amount; Amount)
            {

            }
            column(Account_No_; "Account No.")
            {

            }
            column(FKey; FKey)
            {

            }
            column(Transacted_By; "Transacted By")
            {

            }
            column(Transaction_Date; "Transaction Date")
            {

            }
            column(Transaction_Time; "Transaction Time")
            {

            }
            column(Description; Description)
            {

            }
            column(Service_ID; "Service ID")
            {

            }
            trigger OnAfterGetRecord()
            begin
                Description := '';
                IF MobileBankingEntries.Description = '' then
                    if MobileTypes.Get("Service ID") then begin
                    Description := MobileTypes.Description;
                end;
            end;
        }
    }

    trigger OnPreReport()
    var
        myInt: Integer;
    begin
        CompInfo.Get();
        CompInfo.CalcFields(Picture)
    end;

    var
        CompInfo: Record "Company Information";
        Descr: Text;
        MobileTypes: Record "Mobile Transaction Type";

}