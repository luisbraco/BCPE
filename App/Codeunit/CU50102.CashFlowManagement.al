codeunit 50102 "CashFlowManagement"
{
    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;

    local procedure GetLastEntryNo(pCompany: Text[30]; pConcept: Text[30]): Integer;
    var
        GlobalCFEntry: Record "Global CashFlow Entry";
    begin
        WITH GlobalCFEntry DO BEGIN
            RESET;
            SETCURRENTKEY("Source Entry No.");
            ASCENDING(TRUE);
            IF pCompany <> '' THEN
                SETRANGE("Company Name", pCompany);

            SETRANGE("Concept Code", pConcept);
            IF FINDLAST THEN
                EXIT("Source Entry No.");
        END;
    end;

    PROCEDURE GenerateCashFlow(pCompany: Text[30]);
    VAR
        MasterSetup: Record 50008;
        GLEntry: Record 17;
        CustLedgEntry: Record 21;
        VendLedgEntry: Record 25;
        BankLedgEntry: Record 271;
        GLEntryBuffer: Record "Global CashFlow Entry" temporary;
        Concepts: Record 50008;
        CashFlowGLEntry: Record 50058;
        GLAccount: Record 15;
        BankAccount: Record 270;
        BankAccLedgerEntry: Record 271;
        xDim1Code: Code[20];
        xDim2Code: Code[20];
        xPostingDate: Date;
        LastEntryNo: Integer;
        Window: Dialog;
        Cont: Decimal;
        NoRegs: Decimal;
        Cont1: Decimal;
        NoRegs1: Decimal;
        Cont2: Decimal;
        NoRegs2: Decimal;
        SourceRegs: Decimal;
        CompressedRegs: Decimal;
        TextConfirm: TextConst ENU = 'Calculate the DrillDown with the filters applied?',
        ESM = 'Calcular flujo con los fitros aplicados?;ESN=Calcular flujo con los fitros aplicados?';
        TextReadCLEntry: TextConst ENU='1.1. Reading new Cust. Ledg. Entries;ESM=1.1 Leyendo Nuevos Mov. Clientes;ESN=1.1 Leyendo Nuevos Mov. Clientes';
        TextReadVLEntry: TextConst ENU='1.2. Reading new Vend. Ledg. Entries;ESM=1.2 Leyendo nuevos Mov. Proveedor;ESN=1.2 Leyendo nuevos Mov. Proveedor';
        TextReadGLEntryF: TextConst ENU='1.3. Reading new G/L Entry lines - Formula;ESM=1.3. Leyendo nuevos Mov. Contables - Formula;ESN=1.3. Leyendo nuevos Mov. Contables - Formula';
        TextReadGLEntryA: TextConst ENU='1.4. Reading G/L Entry lines - Account;ESM=1.4. Leyendo Lineas Mov. Contable - Cuenta;ESN=1.4. Leyendo Lineas Mov. Contable - Cuenta';
        TextReadBEntry: TextConst ENU='1.5. Leyendo Lineas Mov. Bancos;ESM=1.5. Leyendo Lineas Mov. Bancos;ESN=1.5. Leyendo Lineas Mov. Bancos';
        TextCFError: TextConst ENU='Cashflow concepts are not defined;ESM=Conceptos FC, no definidos;ESN=Conceptos FC, no definidos';
        TextErrorCF: TextConst ESM='No existe informaci¢n que procesar, revisar Concepto: [%1]';
        SourceLastEntryNo: Integer;
    BEGIN
        IF GUIALLOWED THEN
            IF NOT CONFIRM('Execute the routine?', FALSE) THEN
                ERROR('');

        CLEAR(MasterSetup);
        MasterSetup.SETRANGE("Gran Familia", 'CASHFLOW');
        MasterSetup.SETRANGE(Familia, 'COMPANY');
        MasterSetup.SETRANGE(Visualizar, TRUE);
        IF pCompany <> '' THEN
            MasterSetup.SETRANGE(Descripcion, pCompany);

        IF NOT MasterSetup.ISEMPTY THEN BEGIN
            IF GUIALLOWED THEN
                Window.OPEN(TextProcess);

            Cont := 1;
            NoRegs := MasterSetup.COUNT;

            MasterSetup.FINDFIRST;
            REPEAT
                IF GUIALLOWED THEN BEGIN
                    Window.UPDATE(3, MasterSetup.Descripcion);
                    Window.UPDATE(4, Cont);
                    Window.UPDATE(5, NoRegs);
                END;

                MasterSetup."CashFlow Last Start Datetime" := CREATEDATETIME(TODAY, TIME);

                CLEAR(Concepts);
                Concepts.SETRANGE("Gran Familia", 'CASHFLOW');
                Concepts.SETRANGE(Familia, 'CONCEPT');//|%2|%3|%4
                                                      //Concepts.SETFILTER(Codigo,'%1|%2','CCMEBBVA2','CCMNBBVA1');
                Concepts.SETRANGE(Status, TRUE);
                IF Concepts.ISEMPTY THEN
                    ERROR(TextCFError)
                ELSE BEGIN
                    Concepts.FINDFIRST;
                    REPEAT
                        CLEAR(GLEntryBuffer);
                        GLEntryBuffer.DELETEALL;

                        GLEntryBuffer.INIT;
                        GLEntryBuffer."Company Name" := MasterSetup.Descripcion;
                        GLEntryBuffer."Concept Code" := Concepts.Codigo;
                        GLEntryBuffer."Concept Type" := Concepts."CashFlow Type";

                        // Step 1 - Generate the temp buffer
                        CASE Concepts."CashFlow Type" OF
                            Concepts."CashFlow Type"::Receivables:
                                BEGIN
                                    CLEAR(CustLedgEntry);
                                    CLEAR(SourceLastEntryNo);

                                    SourceLastEntryNo := GetLastEntryNo(MasterSetup.Descripcion, Concepts.Codigo);

                                    CustLedgEntry.CHANGECOMPANY(MasterSetup.Descripcion);
                                    IF SourceLastEntryNo > 0 THEN
                                        CustLedgEntry.SETFILTER("Entry No.", '>%1', SourceLastEntryNo);//MasterSetup."CashFlow Last Rec. Entry No.") ;
                                    IF NOT CustLedgEntry.ISEMPTY THEN BEGIN
                                        IF GUIALLOWED THEN
                                            Window.UPDATE(6, TextReadCLEntry);

                                        Cont1 := 1;
                                        NoRegs1 := CustLedgEntry.COUNT;

                                        CustLedgEntry.FINDFIRST;
                                        REPEAT
                                            GLEntryBuffer."Entry No." := Cont1;
                                            GLEntryBuffer."Posting Date" := CustLedgEntry."Posting Date";
                                            GLEntryBuffer."Global Dimension 1 Code" := CustLedgEntry."Global Dimension 1 Code";
                                            GLEntryBuffer."Global Dimension 2 Code" := CustLedgEntry."Global Dimension 2 Code";

                                            CustLedgEntry.CALCFIELDS("Amount (LCY)", "Remaining Amt. (LCY)", "Debit Amount (LCY)", "Credit Amount (LCY)");

                                            GLEntryBuffer."Amount (LCY)" := CustLedgEntry."Amount (LCY)";
                                            GLEntryBuffer."Debit Amount (LCY)" := CustLedgEntry."Debit Amount (LCY)";
                                            GLEntryBuffer."Credit Amount (LCY)" := CustLedgEntry."Credit Amount (LCY)";
                                            GLEntryBuffer."Remaining Amount (LCY)" := CustLedgEntry."Remaining Amt. (LCY)";
                                            GLEntryBuffer."Document No." := CustLedgEntry."Document No.";
                                            GLEntryBuffer."Document Type" := CustLedgEntry."Document Type";
                                            GLEntryBuffer."Source Entry No." := CustLedgEntry."Entry No.";
                                            GLEntryBuffer.Description := CustLedgEntry.Description;
                                            GLEntryBuffer."Document Date" := CustLedgEntry."Document Date";
                                            GLEntryBuffer."External Document No." := CustLedgEntry."External Document No.";

                                            GLEntryBuffer.INSERT;

                                            IF GUIALLOWED THEN
                                                Window.UPDATE(1, ROUND(Cont1 * 10000 / NoRegs1, 1));

                                            Cont1 += 1;
                                        UNTIL CustLedgEntry.NEXT = 0;
                                    END;
                                END;
                            Concepts."CashFlow Type"::Payables:
                                BEGIN
                                    CLEAR(VendLedgEntry);
                                    CLEAR(SourceLastEntryNo);

                                    SourceLastEntryNo := GetLastEntryNo(MasterSetup.Descripcion, Concepts.Codigo);

                                    VendLedgEntry.CHANGECOMPANY(MasterSetup.Descripcion);
                                    IF SourceLastEntryNo > 0 THEN
                                        VendLedgEntry.SETFILTER("Entry No.", '>%1', SourceLastEntryNo);//MasterSetup."CashFlow Last Pay. Entry No.") ;

                                    IF NOT VendLedgEntry.ISEMPTY THEN BEGIN
                                        IF GUIALLOWED THEN
                                            Window.UPDATE(6, TextReadVLEntry);

                                        Cont1 := 1;
                                        NoRegs1 := VendLedgEntry.COUNT;

                                        VendLedgEntry.FINDFIRST;
                                        REPEAT
                                            GLEntryBuffer."Entry No." := Cont1;

                                            GLEntryBuffer."Posting Date" := VendLedgEntry."Posting Date";
                                            GLEntryBuffer."Global Dimension 1 Code" := VendLedgEntry."Global Dimension 1 Code";
                                            GLEntryBuffer."Global Dimension 2 Code" := VendLedgEntry."Global Dimension 2 Code";

                                            VendLedgEntry.CALCFIELDS("Amount (LCY)", "Remaining Amt. (LCY)", "Debit Amount (LCY)", "Credit Amount (LCY)");

                                            GLEntryBuffer."Amount (LCY)" := VendLedgEntry."Amount (LCY)";
                                            GLEntryBuffer."Debit Amount (LCY)" := VendLedgEntry."Debit Amount (LCY)";
                                            GLEntryBuffer."Credit Amount (LCY)" := VendLedgEntry."Credit Amount (LCY)";
                                            GLEntryBuffer."Remaining Amount (LCY)" := VendLedgEntry."Remaining Amt. (LCY)";
                                            GLEntryBuffer."Document No." := VendLedgEntry."Document No.";
                                            GLEntryBuffer."Document Type" := VendLedgEntry."Document Type";
                                            GLEntryBuffer."Source Entry No." := VendLedgEntry."Entry No.";
                                            GLEntryBuffer.Description := VendLedgEntry.Description;
                                            GLEntryBuffer."Document Date" := VendLedgEntry."Document Date";
                                            GLEntryBuffer."External Document No." := VendLedgEntry."External Document No.";
                                            GLEntryBuffer.INSERT;
                                            IF GUIALLOWED THEN
                                                Window.UPDATE(1, ROUND(Cont1 * 10000 / NoRegs1, 1));

                                            Cont1 += 1;
                                        UNTIL VendLedgEntry.NEXT = 0;
                                    END;
                                END;
                            Concepts."CashFlow Type"::Formula:
                                BEGIN
                                    CLEAR(GLEntry);
                                    CLEAR(SourceLastEntryNo);

                                    SourceLastEntryNo := GetLastEntryNo(MasterSetup.Descripcion, Concepts.Codigo);

                                    GLEntry.CHANGECOMPANY(MasterSetup.Descripcion);
                                    GLEntry.SETCURRENTKEY("G/L Account No.", "Posting Date");
                                    GLEntry.SETFILTER("G/L Account No.", Concepts.Formula);
                                    IF SourceLastEntryNo > 0 THEN
                                        GLEntry.SETFILTER("Entry No.", '>%1', SourceLastEntryNo);

                                    IF NOT GLEntry.ISEMPTY THEN BEGIN
                                        IF GUIALLOWED THEN
                                            Window.UPDATE(6, TextReadGLEntryF);

                                        Cont1 := 1;
                                        NoRegs1 := GLEntry.COUNT;

                                        IF GLEntry.FINDFIRST THEN
                                            REPEAT
                                                GLEntryBuffer."Entry No." := Cont1;

                                                GLEntryBuffer."Posting Date" := GLEntry."Posting Date";
                                                GLEntryBuffer."G/L Account No." := GLEntry."G/L Account No.";
                                                GLEntryBuffer."Global Dimension 1 Code" := GLEntry."Global Dimension 1 Code";
                                                GLEntryBuffer."Global Dimension 2 Code" := GLEntry."Global Dimension 2 Code";
                                                GLEntryBuffer."Amount (LCY)" := GLEntry.Amount;
                                                GLEntryBuffer."Debit Amount (LCY)" := GLEntry."Debit Amount";
                                                GLEntryBuffer."Credit Amount (LCY)" := GLEntry."Credit Amount";
                                                GLEntryBuffer."Document No." := GLEntry."Document No.";
                                                GLEntryBuffer."Document Type" := GLEntry."Document Type";
                                                GLEntryBuffer."Source Type" := GLEntry."Source Type";
                                                GLEntryBuffer."Source No." := GLEntry."Source No.";
                                                GLEntryBuffer."Source Entry No." := GLEntry."Entry No.";
                                                GLEntryBuffer.Description := GLEntry.Description;
                                                GLEntryBuffer."Document Date" := GLEntry."Document Date";
                                                GLEntryBuffer."External Document No." := GLEntry."External Document No.";
                                                GLEntryBuffer."Add.-Currency Debit Amount" := GLEntry."Add.-Currency Debit Amount";
                                                GLEntryBuffer."Add.-Currency Credit Amount" := GLEntry."Add.-Currency Credit Amount";

                                                GLEntryBuffer.INSERT;

                                                IF GUIALLOWED THEN
                                                    Window.UPDATE(1, ROUND(Cont1 * 10000 / NoRegs1, 1));

                                                Cont1 += 1;
                                            UNTIL GLEntry.NEXT = 0;
                                    END;
                                END;
                            Concepts."CashFlow Type"::Account:
                                BEGIN
                                    CLEAR(GLEntry);
                                    CLEAR(SourceLastEntryNo);

                                    GLAccount.CHANGECOMPANY(MasterSetup.Descripcion);
                                    IF GLAccount.GET(Concepts.Formula) THEN;

                                    SourceLastEntryNo := GetLastEntryNo(MasterSetup.Descripcion, Concepts.Codigo);

                                    GLEntry.CHANGECOMPANY(MasterSetup.Descripcion);
                                    GLEntry.SETCURRENTKEY("G/L Account No.", "Posting Date");
                                    GLEntry.SETRANGE("G/L Account No.", Concepts.Formula);

                                    CASE Concepts."Debit/Credit" OF
                                        Concepts."Debit/Credit"::Credit:
                                            GLEntry.SETFILTER("Credit Amount", '<>%1', 0);
                                        Concepts."Debit/Credit"::Debit:
                                            GLEntry.SETFILTER("Debit Amount", '<>%1', 0);
                                    END;

                                    IF SourceLastEntryNo > 0 THEN
                                        GLEntry.SETFILTER("Entry No.", '>%1', SourceLastEntryNo);

                                    IF NOT GLEntry.ISEMPTY THEN BEGIN
                                        IF GUIALLOWED THEN
                                            Window.UPDATE(6, TextReadGLEntryA);

                                        Cont1 := 1;
                                        NoRegs1 := GLEntry.COUNT;

                                        IF GLEntry.FINDSET THEN
                                            REPEAT
                                                GLEntryBuffer."Entry No." := Cont1;

                                                GLEntryBuffer."Posting Date" := GLEntry."Posting Date";
                                                GLEntryBuffer."G/L Account No." := GLEntry."G/L Account No.";
                                                GLEntryBuffer."Global Dimension 1 Code" := GLEntry."Global Dimension 1 Code";
                                                GLEntryBuffer."Global Dimension 2 Code" := GLEntry."Global Dimension 2 Code";
                                                GLEntryBuffer."Amount (LCY)" := GLEntry.Amount;
                                                GLEntryBuffer."Debit Amount (LCY)" := GLEntry."Debit Amount";
                                                GLEntryBuffer."Credit Amount (LCY)" := GLEntry."Credit Amount";
                                                GLEntryBuffer."Debit/Credit" := Concepts."Debit/Credit";
                                                GLEntryBuffer."Document Type" := GLEntry."Document Type";
                                                GLEntryBuffer."Source Type" := GLEntry."Source Type";
                                                GLEntryBuffer."Source No." := GLEntry."Source No.";
                                                GLEntryBuffer."Document No." := GLEntry."Document No.";
                                                GLEntryBuffer."Source Entry No." := GLEntry."Entry No.";
                                                GLEntryBuffer.Description := GLEntry.Description;
                                                GLEntryBuffer."Document Date" := GLEntry."Document Date";
                                                GLEntryBuffer."External Document No." := GLEntry."External Document No.";
                                                GLEntryBuffer."Add.-Currency Debit Amount" := GLEntry."Add.-Currency Debit Amount";
                                                GLEntryBuffer."Add.-Currency Credit Amount" := GLEntry."Add.-Currency Credit Amount";
                                                GLEntryBuffer.INSERT;

                                                IF GUIALLOWED THEN
                                                    Window.UPDATE(1, ROUND(Cont1 * 10000 / NoRegs1, 1));

                                                Cont1 += 1;
                                            UNTIL GLEntry.NEXT = 0;
                                    END;
                                END;
                            Concepts."CashFlow Type"::Bank:
                                BEGIN
                                    CLEAR(BankAccount);
                                    CLEAR(SourceLastEntryNo);

                                    BankAccount.CHANGECOMPANY(MasterSetup.Descripcion);
                                    IF BankAccount.GET(Concepts."Bank Account No.") THEN;

                                    SourceLastEntryNo := GetLastEntryNo(MasterSetup.Descripcion, Concepts.Codigo);

                                    BankAccLedgerEntry.CHANGECOMPANY(MasterSetup.Descripcion);
                                    BankAccLedgerEntry.SETCURRENTKEY("Bank Account No.", "Posting Date");
                                    BankAccLedgerEntry.SETRANGE("Bank Account No.", Concepts."Bank Account No.");

                                    IF SourceLastEntryNo > 0 THEN
                                        BankAccLedgerEntry.SETFILTER("Entry No.", '>%1', SourceLastEntryNo);

                                    IF NOT BankAccLedgerEntry.ISEMPTY THEN BEGIN
                                        IF GUIALLOWED THEN
                                            Window.UPDATE(6, TextReadBEntry);

                                        Cont1 := 1;
                                        NoRegs1 := GLEntry.COUNT;

                                        IF BankAccLedgerEntry.FINDSET THEN
                                            REPEAT
                                                GLEntryBuffer."Entry No." := Cont1;

                                                GLEntryBuffer."Posting Date" := BankAccLedgerEntry."Posting Date";
                                                GLEntryBuffer."Bank Account No." := BankAccLedgerEntry."Bank Account No.";
                                                GLEntryBuffer."Global Dimension 1 Code" := BankAccLedgerEntry."Global Dimension 1 Code";
                                                GLEntryBuffer."Global Dimension 2 Code" := BankAccLedgerEntry."Global Dimension 2 Code";
                                                GLEntryBuffer."Amount (LCY)" := BankAccLedgerEntry.Amount;
                                                GLEntryBuffer."Debit Amount (LCY)" := BankAccLedgerEntry."Debit Amount";
                                                GLEntryBuffer."Credit Amount (LCY)" := BankAccLedgerEntry."Credit Amount";
                                                //GLEntryBuffer."Debit/Credit"            := Concepts."Debit/Credit";
                                                GLEntryBuffer."Document Type" := BankAccLedgerEntry."Document Type";
                                                //GLEntryBuffer."Source Type"             := "Source Type";
                                                //GLEntryBuffer."Source No."              := GLEntry."Source No.";
                                                GLEntryBuffer."Document No." := BankAccLedgerEntry."Document No.";
                                                GLEntryBuffer.Description := BankAccLedgerEntry.Description;
                                                GLEntryBuffer."Source Entry No." := BankAccLedgerEntry."Entry No.";
                                                GLEntryBuffer."Document Date" := BankAccLedgerEntry."Document Date";
                                                GLEntryBuffer."External Document No." := BankAccLedgerEntry."External Document No.";
                                                GLEntryBuffer.INSERT;

                                                IF GUIALLOWED THEN
                                                    Window.UPDATE(1, ROUND(Cont1 * 10000 / NoRegs1, 1));

                                                Cont1 += 1;
                                            UNTIL BankAccLedgerEntry.NEXT = 0;

                                    END;
                                END;

                            Concepts."CashFlow Type"::Income:
                                BEGIN
                                    CLEAR(BankAccount);
                                    CLEAR(BankAccLedgerEntry);
                                    CLEAR(SourceLastEntryNo);
                                    // Cont1   := 1 ;
                                    BankAccount.CHANGECOMPANY(MasterSetup.Descripcion);
                                    BankAccount.SETRANGE("Currency Code", MasterSetup."Currency Code");
                                    IF BankAccount.FINDSET THEN BEGIN
                                        REPEAT

                                            BankAccLedgerEntry.CHANGECOMPANY(MasterSetup.Descripcion);
                                            BankAccLedgerEntry.SETCURRENTKEY("Bank Account No.", "Posting Date");
                                            BankAccLedgerEntry.SETRANGE("Bank Account No.", BankAccount."No.");
                                            BankAccLedgerEntry.SETFILTER(Amount, '>%1', 0);
                                            SourceLastEntryNo := GetLastEntryNo(MasterSetup.Descripcion, Concepts.Codigo);
                                            IF SourceLastEntryNo > 0 THEN
                                                BankAccLedgerEntry.SETFILTER("Entry No.", '>%1', SourceLastEntryNo);

                                            IF NOT BankAccLedgerEntry.ISEMPTY THEN BEGIN
                                                IF GUIALLOWED THEN
                                                    Window.UPDATE(6, TextReadBEntry);

                                                NoRegs1 := BankAccLedgerEntry.COUNT;

                                                IF BankAccLedgerEntry.FINDSET THEN
                                                    REPEAT
                                                        GLEntryBuffer."Entry No." := Cont1;

                                                        GLEntryBuffer."Posting Date" := BankAccLedgerEntry."Posting Date";
                                                        GLEntryBuffer."Bank Account No." := BankAccLedgerEntry."Bank Account No.";
                                                        GLEntryBuffer."Global Dimension 1 Code" := BankAccLedgerEntry."Global Dimension 1 Code";
                                                        GLEntryBuffer."Global Dimension 2 Code" := BankAccLedgerEntry."Global Dimension 2 Code";
                                                        GLEntryBuffer."Amount (LCY)" := BankAccLedgerEntry.Amount;
                                                        GLEntryBuffer."Debit Amount (LCY)" := BankAccLedgerEntry."Debit Amount";
                                                        GLEntryBuffer."Credit Amount (LCY)" := BankAccLedgerEntry."Credit Amount";
                                                        GLEntryBuffer."Currency Code" := BankAccLedgerEntry."Currency Code";
                                                        //GLEntryBuffer."Debit/Credit"            := Concepts."Debit/Credit";
                                                        GLEntryBuffer."Document Type" := BankAccLedgerEntry."Document Type";
                                                        //GLEntryBuffer."Source Type"             := "Source Type";
                                                        //GLEntryBuffer."Source No."              := GLEntry."Source No.";
                                                        GLEntryBuffer."Document No." := BankAccLedgerEntry."Document No.";
                                                        GLEntryBuffer.Description := BankAccLedgerEntry.Description;
                                                        GLEntryBuffer."Source Entry No." := BankAccLedgerEntry."Entry No.";
                                                        GLEntryBuffer."Document Date" := BankAccLedgerEntry."Document Date";
                                                        GLEntryBuffer."External Document No." := BankAccLedgerEntry."External Document No.";
                                                        GLEntryBuffer.INSERT;

                                                        IF GUIALLOWED THEN
                                                            Window.UPDATE(1, ROUND(Cont1 * 10000 / NoRegs1, 1));

                                                        Cont1 += 1;
                                                    UNTIL BankAccLedgerEntry.NEXT = 0;
                                            END;
                                            Cont1 += 1;
                                        UNTIL BankAccount.NEXT = 0;
                                    END;
                                END;
                        END;

                        // ========================================= PERF. TEST
                        SourceRegs += NoRegs1;
                        // ========================================= PERF. TEST

                        // Reorder the buffer
                        GLEntryBuffer.RESET;
                        GLEntryBuffer.SETCURRENTKEY("Company Name", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date");

                        IF GUIALLOWED THEN
                            Window.UPDATE(6, STRSUBSTNO('2. Compressing by Concept: %1', Concepts.Descripcion));

                        IF NOT GLEntryBuffer.ISEMPTY THEN BEGIN
                            CLEAR(xDim1Code);
                            CLEAR(xDim2Code);
                            CLEAR(xPostingDate);

                            LastEntryNo := 1;

                            CashFlowGLEntry.RESET;
                            CashFlowGLEntry.SETRANGE("Company Name", MasterSetup.Descripcion);
                            IF NOT CashFlowGLEntry.ISEMPTY THEN BEGIN
                                CashFlowGLEntry.FINDLAST;
                                LastEntryNo += CashFlowGLEntry."Entry No.";
                            END;

                            Cont2 := 0;
                            NoRegs2 := GLEntryBuffer.COUNT;

                            GLEntryBuffer.FINDFIRST;
                            REPEAT
                                IF (GLEntryBuffer."Global Dimension 1 Code" <> xDim1Code) OR
                                   (GLEntryBuffer."Global Dimension 2 Code" <> xDim2Code) OR
                                   (GLEntryBuffer."Posting Date" <> xPostingDate) THEN BEGIN

                                    CashFlowGLEntry.INIT;
                                    CashFlowGLEntry."Company Name" := MasterSetup.Descripcion;
                                    CashFlowGLEntry."Entry No." := LastEntryNo;
                                    LastEntryNo += 1;

                                    CashFlowGLEntry."Concept Code" := Concepts.Codigo;
                                    CashFlowGLEntry."Concept Type" := Concepts."CashFlow Type";
                                    CashFlowGLEntry."Global Dimension 1 Code" := GLEntryBuffer."Global Dimension 1 Code";
                                    CashFlowGLEntry."Global Dimension 2 Code" := GLEntryBuffer."Global Dimension 2 Code";
                                    CashFlowGLEntry."Posting Date" := GLEntryBuffer."Posting Date";
                                    CashFlowGLEntry."Debit/Credit" := GLEntryBuffer."Debit/Credit";
                                    CashFlowGLEntry."G/L Account No." := GLEntryBuffer."G/L Account No.";
                                    CashFlowGLEntry."Bank Account No." := GLEntryBuffer."Bank Account No.";
                                    CashFlowGLEntry."Currency Code" := GLEntryBuffer."Currency Code";
                                    CashFlowGLEntry."Source Entry No." := GLEntryBuffer."Source Entry No.";
                                    CashFlowGLEntry."Document No." := GLEntryBuffer."Document No.";
                                    CashFlowGLEntry.Description := GLEntryBuffer.Description;
                                    CashFlowGLEntry."Document Date" := GLEntryBuffer."Document Date";
                                    CashFlowGLEntry."External Document No." := GLEntryBuffer."External Document No.";

                                    CashFlowGLEntry.INSERT;

                                    // ========================================= PERF. TEST
                                    CompressedRegs += 1;
                                    // ========================================= PERF. TEST

                                END;

                                CashFlowGLEntry."Amount (LCY)" += GLEntryBuffer."Amount (LCY)";
                                CashFlowGLEntry."Debit Amount (LCY)" += GLEntryBuffer."Debit Amount (LCY)";
                                CashFlowGLEntry."Credit Amount (LCY)" += GLEntryBuffer."Credit Amount (LCY)";
                                CashFlowGLEntry."Add.-Currency Debit Amount" += GLEntryBuffer."Add.-Currency Debit Amount";
                                CashFlowGLEntry."Add.-Currency Credit Amount" += GLEntryBuffer."Add.-Currency Credit Amount";

                                CashFlowGLEntry."Remaining Amount (LCY)" += GLEntryBuffer."Remaining Amount (LCY)";
                                CashFlowGLEntry.MODIFY;

                                xDim1Code := GLEntryBuffer."Global Dimension 1 Code";
                                xDim2Code := GLEntryBuffer."Global Dimension 2 Code";
                                xPostingDate := GLEntryBuffer."Posting Date";

                                Cont2 += 1;
                                IF GUIALLOWED THEN
                                    Window.UPDATE(2, ROUND(Cont2 * 10000 / NoRegs2, 1));

                            UNTIL GLEntryBuffer.NEXT = 0;
                        END;

                        Cont1 += 1;
                        IF GUIALLOWED THEN
                            IF NoRegs1 > 0 THEN
                                Window.UPDATE(1, ROUND(Cont1 * 10000 / NoRegs1, 1));

                    UNTIL Concepts.NEXT = 0;
                END;

                MasterSetup."CashFlow Last Exec. Date" := TODAY;
                MasterSetup."CashFlow Last Exec. Time" := TIME;
                MasterSetup."CashFlow Last Exec. UserID" := USERID;
                MasterSetup.MODIFY;
                COMMIT;
            UNTIL MasterSetup.NEXT = 0;

            IF GUIALLOWED THEN
                IF SourceRegs > 0 THEN
                    MESSAGE('Summary:\' +
                            '  Source registers: %1\' +
                            '  Compressed registers: %2\' +
                            '\' +
                            'Compression Ratio: %3', SourceRegs, CompressedRegs, CompressedRegs / SourceRegs);
        END ELSE
            EXIT;
    END;
}