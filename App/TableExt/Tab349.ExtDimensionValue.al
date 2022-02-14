tableextension 50102 "WS Dimension Value" extends "Dimension Value"
{

    var
        myInt: Integer;
        MngtHEINSOHN: Codeunit MngtBC;
        TokenHEINSOHN: Text;
        MessageHEINSOHN: Text;

    trigger OnInsert()
    var

    begin

        //LBC 100222 - Consume WS HEINSOHN - Areafuncional - CC
        IF "Dimension Code" = 'AREA' THEN BEGIN
            CLEAR(MngtHEINSOHN);
            CLEAR(MessageHEINSOHN);
            TokenHEINSOHN := MngtHEINSOHN."ConsumeWSHEISOHN"('AUTHENTICATE', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

            MessageHEINSOHN := MngtHEINSOHN."ConsumeWSHEISOHN"('INSERT', Name, Code,
                               '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', TokenHEINSOHN);
            IF MessageHEINSOHN <> '' THEN
                ERROR('Interfaz HEINSOHN: ' + MessageHEINSOHN);
        END;
        //LBC 100222 - Consume WS HEINSOHN - Areafuncional - CC
    end;

    trigger OnDelete()
    var

    begin

        //LBC 100222 - Consume WS HEINSOHN - Areafuncional - CC
        IF "Dimension Code" = 'AREA' THEN BEGIN
            CLEAR(MngtHEINSOHN);
            CLEAR(MessageHEINSOHN);
            TokenHEINSOHN := MngtHEINSOHN."ConsumeWSHEISOHN"('AUTHENTICATE', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

            //CLEAR(MngtHEINSOHN);
            MessageHEINSOHN := MngtHEINSOHN."ConsumeWSHEISOHN"('INACTIVATE', '', Code, '', '', '', '', '', '', '', '', '', '', '', '', '', TokenHEINSOHN);
            IF MessageHEINSOHN <> '' THEN
                ERROR('Interfaz HEINSOHN: ' + MessageHEINSOHN);
        END;
        //LBC 100222 - Consume WS HEINSOHN - Areafuncional - CC  
    end;

}