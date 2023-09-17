pageextension 50000 "CustomerList" extends "Customer List"
{
    actions
    {
        addlast(processing)
        {
            action(CustomerQuestions)
            {
                ToolTip = 'Customer Questions', Comment = 'ESP="Preguntas sobre los clientes"';
                Caption = 'Customer Questions', Comment = 'ESP="Preguntas sobre los clientes"';
                ApplicationArea = All;
                Image = Help;

                trigger OnAction()
                var
                    AskChatGPT: Page "Ask ChatGPT";
                begin
                    AskChatGPT.SetPrompt(CreatePromptCustomer());

                    AskChatGPT.Run()
                end;
            }
            action("Create Images")
            {
                ToolTip = 'Create Images', Comment = 'ESP="Crear imagenes"';
                Caption = 'Create Images', Comment = 'ESP="Crear imagenes"';
                ApplicationArea = All;
                Image = CreateBinContent;

                trigger OnAction()
                var
                    AskChatGPT: Page "Ask ChatGPT";
                begin
                    AskChatGPT.ActiveImage();
                    AskChatGPT.Run()

                    AskChatGPT.RunModal()

                end;
            }
        }

        addlast(Promoted)
        {
            actionref("AskCustomersInfo_Promoted"; CustomerQuestions)
            {
            }
        }
    }


    local procedure CreatePromptCustomer() ReturnValue: Text
    var
        JObject: JsonObject;
        JArray: JsonArray;
        JArrayText: Text;
        PromptTxt: Label 'Please answer the question based on the data set in JsonArray format attached below. For any information requested that is not present in the data set provided, please reply: I couldnt find an answer. Dataset: %1', Comment = 'ESP="Responda la pregunta según el conjunto de datos en formato JsonArray que adjunto a continuación. Para cualquier información solicitada que no esté presente en el conjunto de datos proporcionado, responda: No pudeo encontrar una respuesta. Conjunto de datos: %1"';
    begin
        if Rec.FindSet() then
            repeat
                Rec.CalcFields("Sales (LCY)");

                Clear(JObject);
                JObject.Add(Rec.FieldCaption("No."), Rec."No.");
                JObject.Add(Rec.FieldCaption(Name), Rec.Name);
                JObject.Add(Rec.FieldCaption("Sales (LCY)"), Rec."Sales (LCY)");

                JArray.Add(JObject);

            until Rec.Next() = 0;

        JArray.WriteTo(JArrayText);
        ReturnValue := StrSubstNo(PromptTxt, JArrayText);
    end;
}