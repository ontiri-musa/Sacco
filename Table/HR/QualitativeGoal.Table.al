table 50250 "Qualitative Goal"
{
    
    fields
    {
        field(1;Code ; Code[20])
        {                      
        }
         field(2;Description ; Text[100])
        {                      
        }
         field(3;Score ; Decimal)
        {                      
        }
    }
    
    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
    
      
    trigger OnInsert()
    begin
        
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