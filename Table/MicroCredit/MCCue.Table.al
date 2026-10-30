table 52026 "MicroCredit Cue"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; PK; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Loan Officer"; Code[50])
        {
            TableRelation = "Loan Recovery Officer Setup";
        }
        field(3; "No. of Groups"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count(Member where(Category = filter('Group')));
        }
        field(4; "No. of Loans"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Loan Application" where(Posted = filter('Yes')));
        }
        field(5; "New Member Applications"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Member Application" where(Status = filter('New'), "Loan Officer ID" = field("Loan Officer")));
        }
        field(6; "Member App. Pending Approval"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Member Application" where(Status = filter('Pending Approval'), "Loan Officer ID" = field("Loan Officer")));
        }
        field(7; "Approved Member Applications"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Member Application" where(Status = filter('Approved'), "Loan Officer ID" = field("Loan Officer")));
        }
        field(8; "New Loan Applications"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Loan Application" where(Status = filter('New')));
        }
        field(9; "Loan App. Pending Appraisal"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Loan Application" where(Status = filter('Pending Approval')));
        }
        field(10; "Loan App. Pending Disbursal"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Loan Application" where(Status = filter('Approved')));
        }
        field(11; "Outstanding Loan Balance"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Loan Application"."Approved Amount" where(Status = filter('Approved')));
        }
        field(12; "Unallocated Group Collections"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Group Collection Entry"."Remaining Amount");
        }
        field(13; "Total Deposits"; Decimal)
        {
            trigger OnValidate()
            var
                AccountType: Record "Account Type";
                Vendor: Record Vendor;
                Deposits: Decimal;
            begin
                AccountType.Reset();
                AccountType.SetRange(Type, AccountType.Type::"Member Deposit");
                if AccountType.FindFirst() then begin
                    Vendor.Reset();
                    Vendor.SetRange("Account Type", AccountType.Code);
                    if Vendor.FindSet() then begin
                        repeat
                            Vendor.CalcFields(Balance);
                            Deposits += Vendor.Balance;
                        until Vendor.Next() = 0;
                    end;
                end;
                "Total Deposits" := Deposits;
            end;
        }
        field(14; "Total Share Capital"; Decimal)
        {
            trigger OnValidate()
            var
                AccountType: Record "Account Type";
                Vendor: Record Vendor;
                Shares: Decimal;
            begin
                AccountType.Reset();
                AccountType.SetRange(Type, AccountType.Type::"Share Capital");
                if AccountType.FindFirst() then begin
                    Vendor.Reset();
                    Vendor.SetRange("Account Type", AccountType.Code);
                    if Vendor.FindSet() then begin
                        repeat
                            Vendor.CalcFields(Balance);
                            Shares += Vendor.Balance;
                        until Vendor.Next() = 0;
                    end;
                end;
                "Total Share Capital" := Shares;
            end;
        }
    }

    keys
    {
        key(PK; PK)
        {
            Clustered = true;
        }
    }

    var

    trigger OnInsert()
    begin
        Validate("Total Deposits");
        Validate("Total Share Capital");
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}