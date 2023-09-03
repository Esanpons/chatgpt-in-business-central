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
                Visible = VisibleFieldsRequest;
                ShowCaption = true;
                Caption = 'Prompt', Comment = 'ESP="Prompt"';
                field(PromptField; Prompt)
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
                field(RequestField; Request)
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
                field(ResponseField; Response)
                {
                    Visible = VisibleFieldsRequest;
                    ShowCaption = false;
                    ApplicationArea = All;
                    MultiLine = true;
                }
                usercontrol(AddImage; "Imagen")
                {
                    ApplicationArea = All;
                    Visible = RequestImage;
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
                    MgtChatGPT.SetParams(Prompt, Request, RequestImage);
                    Response := MgtChatGPT.GetResponse();

                    if RequestImage then
                        CurrPage.AddImage.CargarImagenBase64(Response);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        VisibleFieldsRequest := true;
        if Prompt = '' then
            Prompt := Text001Txt;

        if RequestImage then begin
            VisibleFieldsRequest := false;
            Prompt := '';
        end;
    end;


    procedure SetPrompt(NewPrompt: Text)
    begin
        Prompt := NewPrompt;
    end;

    procedure ActiveImage()
    begin
        RequestImage := true;
    end;

    var
        Request: Text;
        Prompt: Text;
        Response: Text;
        RequestImage: Boolean;
        VisibleFieldsRequest: Boolean;
        Text001Txt: Label 'You are an assistant for users using Dynamics 365 Business Central. Answer the questions asked by the user in a simple and precise way.', Comment = 'ESP="Eres un asistente para los usuarios que usan Dynamics 365 Business Central. Responder a las preguntas realizadas por el usuario de forma sencilla y precisa."';

}
