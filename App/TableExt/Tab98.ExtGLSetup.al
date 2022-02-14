tableextension 50101 "WS General Setup" extends "General Ledger Setup"
{
    fields
    {
        // Add changes to table fields here
        field(5000; "User HEINSOHN"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Password HEINSOHN"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}