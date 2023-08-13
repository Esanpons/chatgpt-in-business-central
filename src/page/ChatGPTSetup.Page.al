page 50000 "ChatGPT Setup"
{
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'ChatGPT Setup';
    PageType = Card;
    SourceTable = "ChatGPT Setup";
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("API Key"; Rec."API Key")
                {
                    ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                    ApplicationArea = All;
                    ExtendedDatatype = Masked;
                }
                field("Default Max Token"; Rec."Max Token")
                {
                    ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                    ApplicationArea = All;
                }
                field("Default Temperature"; Rec."Temperature")
                {
                    ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert(true);
        end;
    end;
}
