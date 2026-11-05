report 52772 clearDefaulter
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    //  DefaultRenderingLayout = LayoutName;

    dataset
    {
        dataitem("Loan Application"; "Loan Application")
        {
            trigger OnAfterGetRecord()
            begin
                "Loan Application".Reset();
                "Loan Application".CalcFields("Outstanding Balance");
                "Loan Application".SetRange("Loan Product Type", 'DL');
                if "Loan Application"."Outstanding Balance" = 0 then
                    "Loan Application".Delete();

            end;

        }
    }





    var
        myInt: Integer;
}