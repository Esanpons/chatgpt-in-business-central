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

    trigger OnOpenPage()
    begin
        if Prompt = '' then
            Prompt := Text001Txt;
    end;


    procedure SetPrompt(NewPrompt: Text)
    begin
        Prompt := NewPrompt;
    end;

    var
        Request: Text;
        Prompt: Text;
        Response: Text;
        Text001Txt: Label 'You are an assistant for users using Dynamics 365 Business Central. Answer the questions asked by the user in a simple and precise way.', Comment = 'ESP="Eres un asistente para los usuarios que usan Dynamics 365 Business Central. Responder a las preguntas realizadas por el usuario de forma sencilla y precisa."';
}
