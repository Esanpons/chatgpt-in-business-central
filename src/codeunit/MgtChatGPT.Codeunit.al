codeunit 50000 "Mgt. ChatGPT"
{
    procedure SetParams(NewPrompt: Text; NewRequest: Text; NewRequestImage: Boolean)
    begin
        Prompt := NewPrompt;
        Request := NewRequest;
        RequestImage := NewRequestImage;
    end;

    procedure GetResponse() ReturnValue: text;
    var
        ResponseText: Text;
        HttpRequestMessage: HttpRequestMessage;
        HttpContent: HttpContent;
    begin
        ChatGPTSetup.Get();

        SetBody(HttpContent);
        SetHeaders(HttpContent, HttpRequestMessage);
        Post(HttpContent, HttpRequestMessage, ResponseText);
        ReturnValue := ReadResponse(ResponseText);
    end;

    local procedure SetHeaders(var HttpContent: HttpContent; var HttpRequestMessage: HttpRequestMessage)
    var
        Headers: HttpHeaders;
        AuthorizationValue: Text;
    begin
        HttpContent.GetHeaders(Headers);
        Headers.Clear();
        Headers.Add('Content-Type', 'application/json');
        HttpRequestMessage.GetHeaders(Headers);
        AuthorizationValue := 'Bearer ' + ChatGPTSetup."API Key";
        Headers.Add('Authorization', AuthorizationValue);
    end;

    local procedure SetBody(var HttpContent: HttpContent)
    var
        bodyJson: JsonObject;
        JsonData: Text;
    begin
        if RequestImage then begin
            bodyJson.Add('prompt', Request);
            bodyJson.Add('n', 1);
            bodyJson.Add('size', '1024x1024');
            bodyJson.Add('response_format', 'b64_json');
        end else begin
            bodyJson.Add('messages', GetMessages());
            bodyJson.Add('model', ModelTxt);
            bodyJson.Add('max_tokens', ChatGPTSetup."Max Token");
            bodyJson.Add('temperature', ChatGPTSetup."Temperature");
        end;

        bodyJson.WriteTo(JsonData);
        HttpContent.WriteFrom(JsonData);
    end;

    local procedure GetMessages() Jarray: JsonArray
    var
        JObject: JsonObject;
    begin
        Clear(Jarray);
        if Prompt <> '' then begin
            Clear(JObject);
            JObject.Add('role', 'system');
            JObject.Add('content', Prompt);
            Jarray.Add(JObject);
        end;

        if Request <> '' then begin
            Clear(JObject);
            JObject.Add('role', 'user');
            JObject.Add('content', Request);
            Jarray.Add(JObject);
        end;
    end;

    local procedure Post(var HttpContent: HttpContent; var HttpRequestMessage: HttpRequestMessage; var ResponseText: Text)
    var
        HttpClient: HttpClient;
        ErrorTextLbl: Label 'Something Wrong. Please retry.', Comment = 'ESP="Ocurre algo. Por favor, intenta de nuevo."';
        ErrorResponseTextLbl: Label 'Something Wrong. Error:\ %1', Comment = 'ESP="Ocurre algo. Error:\ %1"';
        HttpResponseMessage: HttpResponseMessage;
        URL: Text;
    begin
        URL := URLTxt;
        if RequestImage then
            URL := URLImageTxt;

        HttpRequestMessage.Content := HttpContent;
        HttpRequestMessage.SetRequestUri(URL);
        HttpRequestMessage.Method := 'POST';

        if not HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then
            Error(ErrorTextLbl);

        HttpResponseMessage.Content.ReadAs(ResponseText);
        if not HttpResponseMessage.IsSuccessStatusCode then
            Error(ErrorResponseTextLbl, ResponseText);

    end;

    local procedure ReadResponse(Response: Text) ReturnValue: Text
    var
        JsonObjResponse: JsonObject;
        JsonTokResponse: JsonToken;
        JsonTokChoices: JsonToken;
        JsonObjChoices: JsonObject;
        JsonObjMessage: JsonObject;
        JsonTokMessage: JsonToken;
        JsonTokTextValue: JsonToken;
        JsonArr: JsonArray;
    begin
        ReturnValue := '';
        JsonObjResponse.ReadFrom(Response);

        if RequestImage then begin
            JsonObjResponse.Get('data', JsonTokResponse);
            JsonArr := JsonTokResponse.AsArray();
            JsonArr.Get(0, JsonTokChoices);
            JsonObjChoices := JsonTokChoices.AsObject();
            JsonObjChoices.Get('b64_json', JsonTokTextValue);
            ReturnValue := JsonTokTextValue.AsValue().AsText();
        end else begin
            JsonObjResponse.Get('choices', JsonTokResponse);
            JsonArr := JsonTokResponse.AsArray();
            JsonArr.Get(0, JsonTokChoices);
            JsonObjChoices := JsonTokChoices.AsObject();
            JsonObjChoices.Get('message', JsonTokMessage);
            JsonObjMessage := JsonTokMessage.AsObject();
            JsonObjMessage.Get('content', JsonTokTextValue);
            ReturnValue := JsonTokTextValue.AsValue().AsText();
        end;
    end;

    var
        ChatGPTSetup: Record "ChatGPT Setup";
        Prompt: Text;
        Request: Text;
        RequestImage: Boolean;
        URLTxt: Label 'https://api.openai.com/v1/chat/completions', Locked = true;
        URLImageTxt: Label 'https://api.openai.com/v1/images/generations', Locked = true;
        ModelTxt: Label 'gpt-3.5-turbo', Locked = true;

}