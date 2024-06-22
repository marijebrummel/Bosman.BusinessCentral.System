namespace Own.Core.SOAP;

using System.Security.Authentication;
using System.Utilities;

codeunit 50014 "CORE SOAP Mgt."
{
    procedure SendRequest(RequestMethod: Enum "Http Request Type"; requestUri: Text): Text
    var
        DictionaryDefaultHeaders: Codeunit "Dictionary Wrapper";
        DictionaryContentHeaders: Codeunit "Dictionary Wrapper";
        ContentType: Text;
        Password: SecretText;
    begin
        exit(SendRequest('', RequestMethod, requestUri, ContentType, 0, DictionaryContentHeaders, DictionaryDefaultHeaders, '', Password));
    end;

    procedure SendRequest(contentToSend: Variant; RequestMethod: Enum "Http Request Type"; requestUri: Text; ContentType: Text): Text
    var
        DictionaryDefaultHeaders: Codeunit "Dictionary Wrapper";
        DictionaryContentHeaders: Codeunit "Dictionary Wrapper";
        Password: SecretText;
    begin
        exit(SendRequest(contentToSend, RequestMethod, requestUri, ContentType, 0, DictionaryContentHeaders, DictionaryDefaultHeaders, '', Password));
    end;

    procedure SendRequest(contentToSend: Variant; RequestMethod: Enum "Http Request Type"; requestUri: Text; ContentType: Text; DictionaryDefaultHeaders: Codeunit "Dictionary Wrapper"): Text
    var
        DictionaryContentHeaders: Codeunit "Dictionary Wrapper";
        Password: SecretText;
    begin
        exit(SendRequest(contentToSend, RequestMethod, requestUri, ContentType, 0, DictionaryContentHeaders, DictionaryDefaultHeaders, '', Password));
    end;

    procedure SendRequest(contentToSend: Variant; RequestMethod: Enum "Http Request Type"; requestUri: Text; ContentType: Text; HttpTimeout: Integer; DictionaryContentHeaders: Codeunit "Dictionary Wrapper"; DictionaryDefaultHeaders: Codeunit "Dictionary Wrapper"): Text
    var
        Password: SecretText;
    begin
        exit(SendRequest(contentToSend, RequestMethod, requestUri, ContentType, HttpTimeout, DictionaryContentHeaders, DictionaryDefaultHeaders, '', Password));
    end;

    procedure SendRequest(contentToSend: Variant; RequestMethod: Enum "Http Request Type"; requestUri: Text; ContentType: Text; HttpTimeout: Integer; DictionaryContentHeaders: Codeunit "Dictionary Wrapper"; DictionaryDefaultHeaders: Codeunit "Dictionary Wrapper"; Certificate: Text; Password: SecretText): Text
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        ContentHeaders: HttpHeaders;
        Content: HttpContent;
        ResponseText: Text;
        ErrorBodyContent: Text;
        TextContent: Text;
        InStreamContent: InStream;
        i: Integer;
        KeyVariant: Variant;
        ValueVariant: Variant;
        HasContent: Boolean;
    begin
        case true of
            contentToSend.IsText():
                begin
                    TextContent := contentToSend;
                    if TextContent <> '' then begin
                        Content.WriteFrom(TextContent);
                        HasContent := true;
                    end;
                end;
            contentToSend.IsInStream():
                begin
                    InStreamContent := contentToSend;
                    Content.WriteFrom(InStreamContent);
                    HasContent := true;
                end;
            else
                Error(UnsupportedContentToSendErr);
        end;

        if HasContent then
            Request.Content := Content;

        if ContentType <> '' then begin
            ContentHeaders.Clear();
            Request.Content.GetHeaders(ContentHeaders);
            if ContentHeaders.Contains(ContentTypeKeyLbl) then
                ContentHeaders.Remove(ContentTypeKeyLbl);

            ContentHeaders.Add(ContentTypeKeyLbl, ContentType);
        end;

        for i := 0 to DictionaryContentHeaders.Count() do
            if DictionaryContentHeaders.TryGetKeyValue(i, KeyVariant, ValueVariant) then
                ContentHeaders.Add(Format(KeyVariant), Format(ValueVariant));

        Request.SetRequestUri(requestUri);
        Request.Method := Format(RequestMethod);

        for i := 0 to DictionaryDefaultHeaders.Count() do
            if DictionaryDefaultHeaders.TryGetKeyValue(i, KeyVariant, ValueVariant) then
                Client.DefaultRequestHeaders.Add(Format(KeyVariant), Format(ValueVariant));

        if HttpTimeout <> 0 then
            Client.Timeout(HttpTimeout);

        if Certificate <> '' then
            if Password.IsEmpty() then
                Client.AddCertificate(Certificate)
            else
                Client.AddCertificate(Certificate, Password);

        Client.Send(Request, Response);

        Response.Content().ReadAs(ResponseText);
        if not Response.IsSuccessStatusCode() then begin
            Response.Content().ReadAs(ErrorBodyContent);
            Error(RequestErr, Response.HttpStatusCode(), ErrorBodyContent);
        end;

        exit(ResponseText);
    end;


    procedure CreateBaseXMLDoc(NamespacePrefix: Text; NamespaceUri: Text; AddHeader: Boolean): XmlDocument
    var
        XMLDoc: XmlDocument;
        XMLDec: XmlDeclaration;
        XMLElem: XmlElement;
        XMLElem2: XmlElement;
        XMLAtr: XmlAttribute;
    begin
        XMLDoc := XmlDocument.Create();

        XMLDec := XmlDeclaration.Create('1.0', 'UTF-8', 'yes');
        XMLDoc.SetDeclaration(XMLDec);

        XMLElem := xmlElement.Create('Envelope', NamespaceUri);

        XMLAtr := XmlAttribute.CreateNamespaceDeclaration('xsi', 'http://www.w3.org/2001/XMLSchema-instance');
        XMLElem.Add(XMLAtr);
        XMLAtr := XmlAttribute.CreateNamespaceDeclaration('xsd', 'http://www.w3.org/2001/XMLSchema');
        XMLElem.Add(XMLAtr);
        XMLAtr := XmlAttribute.CreateNamespaceDeclaration(NamespacePrefix, NamespaceUri);
        XMLElem.Add(XMLAtr);

        if AddHeader then begin
            XMLElem2 := XmlElement.Create('Header', NamespaceUri);
            XMLElem.Add(XMLElem2);
        end;

        Clear(XMLElem2);
        XMLElem2 := XmlElement.Create('Body', NamespaceUri);
        XMLElem2.Add(xmlText.Create(''));

        XMLElem.Add(XMLElem2);
        XMLDoc.Add(XMLElem);

        exit(XMLDoc);
    end;

    procedure AddChildElementWithTxtValue(var inXMLElem: XmlElement; LocalName: Text; NamespaceUri: Text; inValue: Text);
    var
        CData: XmlCData;
    begin
        CData := XmlCData.Create('');
        AddChildElementWithCdataTxtValue(inXMLElem, LocalName, NamespaceUri, inValue, CData)
    end;

    procedure AddChildElementWithCdataTxtValue(var inXMLElem: XmlElement; LocalName: Text; NamespaceUri: Text; inValue: Text; CData: XmlCData)
    var
        XMLEelem: XmlElement;
    begin
        if NamespaceUri <> '' then
            XMLEelem := XmlElement.Create(LocalName, NamespaceUri)
        else
            XMLEelem := XmlElement.Create(LocalName);
        XMLEelem.Add(xmlText.Create(inValue));
        if CData.Value() <> '' then
            XMLEelem.Add(CData);
        inXMLElem.Add(XMLEelem);
    end;

    procedure GetValueFromXML(Content: Text; pNodePath: Text): Text
    var
        XMLRootNode: XmlNode;
        XMLChildNode: XmlNode;
        XMLElem: XmlElement;
    begin
        GetRootNode(ConvertTextToXmlDocument(Content), XMLRootNode);

        XMLRootNode.SelectSingleNode(pNodePath, XMLChildNode);
        XMLElem := XMLChildNode.AsXmlElement();
        exit(XMLElem.InnerText());
    end;

    procedure ConvertTextToXmlDocument(Content: Text): XmlDocument
    var
        XmlDoc: XmlDocument;
    begin
        if XmlDocument.ReadFrom(Content, XmlDoc) then
            exit(XmlDoc);
    end;

    procedure GetRootNode(pXMLDocument: XmlDocument; var pFoundXMLNode: XmlNode)
    var
        lXmlElement: XmlElement;
    begin
        pXMLDocument.GetRoot(lXmlElement);
        pFoundXMLNode := lXmlElement.AsXmlNode();
    end;

    var
        RequestErr: Label 'Request failed with HTTP Code: %1 Request Body: %2', Comment = '%1 = HttpCode, %2 = RequestBody';
        UnsupportedContentToSendErr: Label 'Unsuportted content to send.';
        ContentTypeKeyLbl: Label 'Content-Type', Locked = true;
}
