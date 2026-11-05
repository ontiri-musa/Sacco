table 50425 "Procurement Cue"
{
    Caption = 'Procurement Cue';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; PrimaryKey; Code[250])
        {

            DataClassification = ToBeClassified;
        }
        field(2; "PurchaseRequisition-New"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Requisition Header" WHERE("Requisition Type" = filter("Purchase Requisition"),
                            Status = filter(New)));
        }

        field(3; "PurchaseRequisition-Pending"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Requisition Header" WHERE("Requisition Type" = filter("Purchase Requisition"),
                            Status = filter("Pending Approval")));

        }
        field(4; "PurchaseRequisition-Approved"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Requisition Header" WHERE("Requisition Type" = filter("Purchase Requisition"),
                            Status = filter(Released)));

        }
        field(5; "StoreRequisiton-New"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Requisition Header" WHERE("Requisition Type" = FILTER("Store Requisition"),
                            Status = FILTER(New)));

        }
        field(6; "StoreRequisiton-Pending"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Requisition Header" WHERE("Requisition Type" = FILTER("Store Requisition"),
                            Status = FILTER("Pending Approval")));

        }
        field(7; "StoreRequisiton-Approved"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Requisition Header" WHERE("Requisition Type" = FILTER("Store Requisition"),
                            Status = FILTER(Released | Issued | "Pending Return" | Returned)));

        }
        field(8; "Approved Purchase-Req Amount"; Decimal)
        {
            FieldClass = FlowField;
            TableRelation = "Requisition Header".Amount WHERE("Requisition Type" = FILTER("Purchase Requisition"),
                            Status = FILTER(Released));
        }
        field(9; "Approved Proc_Plan Amount"; Decimal)
        {
            FieldClass = Normal;
            TableRelation = "Procurement Plan Header".Amount WHERE(Status = filter(Approved));
        }
        field(10; "StoreReturn-New"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Requisition Header" WHERE("Requisition Type" = FILTER("Store Return"),
                            Status = FILTER(New)));

        }
        field(11; "StoreReturn-Pending"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Requisition Header" WHERE("Requisition Type" = FILTER("Store Return"),
                            Status = FILTER("Pending Approval")));

        }
        field(12; "StoreReturn-Approved"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Requisition Header" WHERE("Requisition Type" = FILTER("Store Return"),
                            Status = FILTER(Released | Issued | "Pending Return" | Returned)));

        }
        field(13; "StoreRequisiton-Issued"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Requisition Header" WHERE("Requisition Type" = FILTER("Store Requisition"),
                            Status = FILTER(Issued | "Pending Return")));

        }
        field(14; "TotalPlanAmount"; Decimal)
        {

        }
        field(15; "TotalReqAmount"; Decimal)
        {

        }
        field(16; "TotalOrderAmount"; Decimal)
        {

        }

    }

    keys
    {
        key(PK; PrimaryKey)
        {
            Clustered = true;
        }
    }

}
