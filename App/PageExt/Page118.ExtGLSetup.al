pageextension 50101 "WS GLSetup" extends "General Ledger Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("Payroll Transaction Import")
        {
            group("Credenciales HEINSOHN APP")
            {
                field("User HEINSOHN"; "User HEINSOHN")
                {
                    Caption = 'Usuario Aplicación';
                    Visible = true;
                }
                field("Password HEINSOHN"; "Password HEINSOHN")
                {
                    Caption = 'Contraseña Aplicación';
                    Visible = true;
                }
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}