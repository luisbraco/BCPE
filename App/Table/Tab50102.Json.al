table 50102 Json
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "KeyCode"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Value"; Text[1024])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "KeyCode")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

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