table 50103 "Global CashFlow Entry"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Company Name"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Entry No."; Integer)
        {
            CaptionML = ENU = 'Entry No.', ESP = 'N§ mov.';
        }

        field(3; "G/L Account No."; Code[20])
        {
            TableRelation = "G/L Account";
            CaptionML = ENU = 'G/L Account No.', ESP = 'N° cuenta';
        }
        field(4; "Bank Account No."; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(10; "Concept Code"; Code[20])
        {
            CaptionML = ENU = 'Concept Code';
        }

        field(11; "Concept Type"; Option)
        {
            CaptionML = ENU = 'Concept Type';
            OptionMembers = "Receivable","Payable","Formula","Account","Bank","Income";
            OptionCaptionML = ENU = 'Receivable, Payable, Formula, Account, Bank, Income',
            ESM = 'Cuentas por cobrar,Cuentas por pagar,Formula,Cuenta,Banco,Ingresos',
            ESN = 'Cuentas por cobrar,Cuentas por pagar,Formula,Cuenta,Banco,Ingresos';
        }
        field(20; "Posting Date"; Date)
        {
            CaptionML = ENU = 'Posting Date', ESP = 'Fecha registro';
            ClosingDates = true;
        }
        field(21; "Global Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            CaptionML = ENU = 'Global Dimension 1 Code', ESP = 'C¢d. dimensi¢n global 1';
            CaptionClass = '1,1,1';
        }
        field(22; "Global Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            CaptionML = ENU = 'Global Dimension 2 Code', ESP = 'C¢d. dimensi¢n global 2';
            CaptionClass = '1,1,2';
        }
        field(30; "Amount (LCY)"; Decimal)
        {
            CaptionML = ENU = 'Amount', ESP = 'Importe';
            AutoFormatType = 1;
        }
        field(31; "Debit Amount (LCY)"; Decimal)
        {
            CaptionML = ENU = 'Debit Amount', ESP = 'Importe debe';
            BlankZero = true;
            AutoFormatType = 1;
        }
        field(32; "Credit Amount (LCY)"; Decimal)
        {
            CaptionML = ENU = 'Credit Amount',
            ESP = 'Importe haber';
            BlankZero = true;
            AutoFormatType = 1;
        }
        field(35; "Remaining Amount (LCY)"; Decimal)
        {
            CaptionML = ENU = 'Remaining Amount', ESP = 'Importe divisa-adicional';
            AutoFormatType = 1;
        }
        field(100; "Source Entry No."; Integer)
        {
            Description = 'DRILLDOWN';
        }
        field(110; "Document Type"; Option)
        {
            CaptionML = ENU = 'Document Type', ESP = 'Tipo documento';
            OptionCaptionML = ENU = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund',
            ESP = ' ,Pago,Factura,Abono,Docs. inters,Recordatorio,Reembolso,,,,,,,,,,,,,,,Efecto';
            OptionMembers = "","Payment","Invoice","Credit Memo","Finance Charge Memo","Reminder","Refund";
            Description = 'DRILLDOWN';
        }
        field(111; "Document No."; Code[20])
        {
            CaptionML = ENU = 'Document No.',
            ESP = 'N§ documento';
            Description = 'DRILLDOWN';
        }
        field(112; "Source Type"; Option)
        {
            CaptionML = ENU = 'Source Type', ESP = 'Tipo procedencia mov.';
            OptionCaptionML = ENU = ',Customer,Vendor,Bank Account,Fixed Asset',
            ESP = ',Cliente,Proveedor,Banco,Activo,Cuenta',
            ESM = ',Cliente,Proveedor,Banco,Activo,Cuenta';
            OptionMembers = "","Customer","Vendor","Bank Account","Fixed Asset","Account";
            Description = 'DRILLDOWN';
        }
        field(113; "Source No."; Code[20])
        {
            TableRelation = IF ("Source Type" = CONST(Customer)) Customer
            ELSE
            IF ("Source Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Source Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Source Type" = CONST("Fixed Asset")) "Fixed Asset";

            CaptionML = ENU = 'Source No.', ESP = 'C¢d. procedencia mov.';
            Description = 'DRILLDOWN';
        }
        field(114; "Due Date"; Date)
        {
            Description = 'DRILLDOWN';
        }
        field(115; "Is Factoring"; Boolean)
        {
            Description = 'DRILLDOWN';
        }
        field(116; "Debit/Credit"; Option)
        {
            CaptionML = ENU = 'Debit/Credit', ESP = 'Debe/Haber', ESM = 'Debe/Haber';
            OptionCaptionML = ENU = 'Both,Debit,Credit', ESP = 'Ambos,Debe,Haber', ESM = 'Ambos,Debe,Haber';
            OptionMembers = "Both","Debit","Credit";
            Description = 'CashFlow';
        }
        field(117; "Description"; Text[100])
        {

        }
        field(118; "Document Date"; Date)
        {
            CaptionML = ENU = 'Document Date', ESP = 'Fecha emisi¢n documento';
            ClosingDates = true;
        }
        field(119; "External Document No."; Code[20])
        {
            CaptionML = ENU = 'External Document No.', ESP = 'N§ documento externo';
        }
        field(120; "Add.-Currency Debit Amount"; Decimal)
        {
            CaptionML = ENU = 'Add.-Currency Debit Amount', ESP = 'Debe div.-adic.';
            AutoFormatType = 1;
        }
        field(121; "Add.-Currency Credit Amount"; Decimal)
        {
            CaptionML = ENU = 'Add.-Currency Credit Amount', ESP = 'Haber div.-adic.';
            AutoFormatType = 1;
        }
        field(122; "Currency Code"; Code[10])
        {
            TableRelation = Currency;
            CaptionML = ENU = 'Currency Code', ESP = 'C¢d. divisa';
        }
    }

    keys
    {
        key(Key1; "Company Name", "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Company Name", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date", "Concept Code")
        {
            SumIndexFields = "Amount (LCY)", "Debit Amount (LCY)", "Credit Amount (LCY)", "Remaining Amount (LCY)";
        }

        key(key3; "Company Name", "Posting Date", "Global Dimension 1 Code", "Global Dimension 2 Code", "Concept Code")
        {
            SumIndexFields = "Amount (LCY)", "Debit Amount (LCY)", "Credit Amount (LCY)", "Remaining Amount (LCY)";
        }
        key(key4; "Company Name", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date", "Concept Code", "Debit/Credit")
        {
            SumIndexFields = "Amount (LCY)", "Debit Amount (LCY)", "Credit Amount (LCY)", "Remaining Amount (LCY)";
        }
        key(key5; "Source Entry No.")
        {
            SumIndexFields = "Amount (LCY)", "Debit Amount (LCY)", "Credit Amount (LCY)", "Remaining Amount (LCY)";
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