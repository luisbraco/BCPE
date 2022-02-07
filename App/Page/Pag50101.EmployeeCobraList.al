page 50101 "Employee List - Cobra"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Employee Cobra";
    Caption = 'Listado - Empleados Cobra';
    CardPageId = "Employee Cobra Card";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; rec."No.")
                {
                    ApplicationArea = All;

                }
                field(" Name"; rec."Name")
                {
                    ApplicationArea = ToBeClassified;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}