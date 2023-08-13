page 50001 "Ask ChatGPT"
{
    Caption = 'Ask ChatGPT', Comment = 'ESP="Pregunta a ChatGPT"';
    ApplicationArea = All;
    PageType = Card;
    UsageCategory = Tasks;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group(PromptGroup)
            {
                ShowCaption = true;
                Caption = 'Prompt', Comment = 'ESP="Prompt"';
                field(Prompt; Prompt)
                {
                    ShowCaption = false;
                    ApplicationArea = All;
                    MultiLine = true;
                    Width = 100;
                }
            }
            group(RequestGroup)
            {
                ShowCaption = true;
                Caption = 'Request', Comment = 'ESP="Pregunta"';
                field(Request; Request)
                {
                    ShowCaption = false;
                    ApplicationArea = All;
                    MultiLine = true;
                    Width = 100;
                }
            }
            group(ResponseGroup)
            {
                ShowCaption = true;
                Caption = 'Response', Comment = 'ESP="Respuesta"';
                field(Response; Response)
                {
                    ShowCaption = false;
                    ApplicationArea = All;
                    MultiLine = true;
                    Width = 100;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Send)
            {
                ToolTip = 'Send request', comment = 'ESP="Enviar petición"';
                Caption = 'Send', Comment = 'ESP="Enviar"';
                Image = SendTo;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    MgtChatGPT: Codeunit "Mgt. ChatGPT";
                begin
                    Clear(MgtChatGPT);
                    MgtChatGPT.SetParams(Prompt, Request);
                    Response := MgtChatGPT.GetResponse();
                end;
            }
        }
    }

    var
        Request: Text[250];
        Prompt: Text[250];
        Response: Text;

}
