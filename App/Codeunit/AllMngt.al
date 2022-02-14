codeunit 50101 MngtBC
{
    trigger OnRun()
    begin

    end;

    var
        TempBlob: Record TempBlob;
        Response: Text;
        InStr: InStream;
        HttpWebRequest: DotNet HttpWebRequest;
        HttpWebResponse: DotNet HttpWebResponse;
        StreamWriter: DotNet StreamWriter;
        ServicePointManager: DotNet ServicePointManager;
        SecurityProtocolType: DotNet SecurityProtocolType;
        Encoding: DotNet Encoding;

    procedure ReplaceString(String: Text; FindWhat: Text; ReplaceWith: Text) NewString: Text
    begin
        WHILE STRPOS(String, FindWhat) > 0 DO
            String := DELSTR(String, STRPOS(String, FindWhat)) + ReplaceWith + COPYSTR(String, STRPOS(String, FindWhat) + STRLEN(FindWhat));
        NewString := String;
    end;

    procedure InsertJson()
    var
        Json: Record Json;
        i: Integer;
        lcCount: Integer;
        lcText: Text;
        lcPosition: Integer;
        StrValue: Text;
        xValue: Text;
        xValue2: Text;
        LenValue: Integer;
    begin
        lcCount := STRLEN(DELCHR(Response, '=', DELCHR(Response, '=', ','))) + 1;
        Json.RESET;
        Json.DELETEALL;
        FOR i := 1 TO lcCount DO BEGIN
            lcText := SELECTSTR(i, Response);
            lcPosition := STRPOS(lcText, ':');
            IF lcPosition > 0 THEN BEGIN
                Json.INIT;
                Json.KeyCode := COPYSTR(lcText, 1, lcPosition - 1);

                CLEAR(xValue);
                CLEAR(xValue2);

                StrValue := DELSTR(lcText, 1, lcPosition);
                LenValue := STRLEN(StrValue);
                IF LenValue > 250 THEN BEGIN
                    xValue := StrValue;//COPYSTR(StrValue, 1, 250);
                                       //  xValue2 := COPYSTR(StrValue, 251, LenValue);
                END ELSE
                    xValue := StrValue;

                Json.Value := xValue;//DELSTR(lcText, 1, lcPosition);
                //Json.Value2 := xValue2;
                Json.INSERT;
            END;
        END;
    end;

    procedure ConsumeWSHEISOHN(pQuery: Text; pnombre: Text; pcodigo: Text; pcentroCosto: Text;
            ptipoConceptoContable: Text; pestructuraOrganizacional: Text; pcodigoProyectoSap: Text;
            ptipoUnidad: Text; psubtipoUnidad: Text; pcategoria: Text; ppais: Text; pdepartamento: Text;
            pciudad: Text; pcodigoCentroBeneficio: Text; pcodigoSubCentroCosto: Text; pcodigoSucursalSap: Text;
            pToken: Text): Text
    var
        Json: Record Json;
        ContentLine: Text;
        i: Integer;
        SetEndPoint: Text;
        SetRequest: Text;
        GLSetup: Record "General Ledger Setup";
        xToken: Text;

        EndPointTxt: TextConst ENU = 'https://nominapruebas.cobra.com.co:28080/NominaWEB/services/authentication';
        MediaTypeText: TextConst ENU = '{"username": "%1","password": "%2"}';
        EndPointAreaFuncionalTxt: TextConst ENU = 'https://nominapruebas.cobra.com.co:28080/NominaWEB/services/tramiteservice/areaFuncional';
        MediaTypeINText: TextConst ENU = '{"estado": "%1", "codigo": "%2"}';
        MediaTypeAFText: TextConst ENU = '{"nombre": "%1","estado":1,"codigo": "%2","ubicacionDiferente":false,"centroCosto": "%3","tipoConceptoContable": %4, "estructuraOrganizacional": "%5", "codigoProyectoSap": "%6", "adicional1": "","adicional2": "", "adicional3": "", "adicional4": "", "adicional5": "", "adicional6": "", "tipoUnidad": "%7","subtipoUnidad": "%8", "categoria": "%9", "pais": "%10", "departamento": "%11", "ciudad": "%12","entidadGestionHumana":false, "codigoCentroBeneficio": "%13", "codigoSubCentroCosto": "%14", "codigoSucursalSap": "%15"}';
        MessageInsert: TextConst ENU = 'Creacion: Creacion area funcional registrada con exito';
        MessageInactive: TextConst ENU = 'Creacion: Se inactivo el area funcional satisfactoriamente registrada con exito';
        MessageInsertFind: TextConst ENU = 'Creacion area funcional , registrada con exito';
        MessageInactiveFind: TextConst ENU = 'Se inactivo el area funcional satisfactoriamente , registrada con exito';
        MessageInsertReplace: TextConst ENU = 'Creacion area funcional registrada con exito';
        MessageInactiveReplace: TextConst ENU = 'Se inactivo el area funcional satisfactoriamente registrada con exito';
    begin
        CASE pQuery OF
            'AUTHENTICATE':
                BEGIN
                    GLSetup.GET;
                    GLSetup.TESTFIELD("User HEINSOHN");
                    GLSetup.TESTFIELD("Password HEINSOHN");

                    SetEndPoint := EndPointTxt;
                    SetRequest := STRSUBSTNO(MediaTypeText, GLSetup."User HEINSOHN", GLSetup."Password HEINSOHN");
                END;
            'INSERT':
                BEGIN
                    SetEndPoint := EndPointAreaFuncionalTxt;
                    SetRequest := STRSUBSTNO(MediaTypeAFText, pnombre, pcodigo, pcentroCosto, ptipoConceptoContable, pestructuraOrganizacional, pcodigoProyectoSap, ptipoUnidad, psubtipoUnidad, pcategoria, ppais, pdepartamento, pciudad, pcodigoCentroBeneficio, pcodigoSubCentroCosto, pcodigoSucursalSap);
                END;
            'INACTIVATE':
                BEGIN
                    SetEndPoint := EndPointAreaFuncionalTxt;
                    SetRequest := STRSUBSTNO(MediaTypeINText, '2', pcodigo);
                END;
        END;

        ServicePointManager.SecurityProtocol(SecurityProtocolType.Tls12);
        HttpWebRequest := HttpWebRequest.Create(SetEndPoint);

        IF pQuery IN ['INSERT', 'INACTIVATE'] THEN BEGIN
            IF Json.GET('T') THEN
                xToken := FORMAT(Json.Value);// + Json.Value2);

            HttpWebRequest.Headers.Add('token', xToken);
        END;

        HttpWebRequest.Method := 'POST';
        HttpWebRequest.ContentType := 'application/json;charset=utf-8';
        HttpWebRequest.MediaType := 'application/json';

        StreamWriter := StreamWriter.StreamWriter(HttpWebRequest.GetRequestStream, Encoding.GetEncoding('iso8859-1'));
        StreamWriter.Write(SetRequest);
        StreamWriter.Flush;
        StreamWriter.Close;
        StreamWriter.Dispose;

        TempBlob.Blob.CREATEINSTREAM(InStr);

        CLEAR(HttpWebResponse);
        HttpWebResponse := HttpWebRequest.GetResponse;
        HttpWebResponse.GetResponseStream.CopyTo(InStr);

        CLEAR(Response);
        WHILE NOT InStr.EOS DO BEGIN
            InStr.READTEXT(ContentLine);
            Response += '' + ContentLine;
        END;

        IF pQuery <> 'AUTHENTICATE' THEN
            Response := COPYSTR(Response, STRPOS(Response, '"v"'), STRLEN(Response));

        Response := COPYSTR(Response, 1, STRPOS(Response, ']'));
        Response := DELCHR(Response, '=', '{}[]"');

        IF pQuery = 'INSERT' THEN
            Response := ReplaceString(Response, MessageInsertFind, MessageInsertReplace);

        IF pQuery = 'INACTIVATE' THEN
            Response := ReplaceString(Response, MessageInactiveFind, MessageInactiveReplace);

        InsertJson;
        CLEAR(Json);

        IF pQuery = 'AUTHENTICATE' THEN BEGIN
            IF Json.GET('T') THEN
                EXIT(Json.Value);//+ Json.Value2);

            IF Json.GET('CODIGOERROR') THEN
                IF Json.Value <> 'null' THEN
                    MESSAGE(Json.Value);

        END ELSE BEGIN
            IF Json.GET('V') THEN
                IF Json.Value <> 'null' THEN
                    IF Json.Value IN [MessageInsert, MessageInactive] THEN
                        MESSAGE(Json.Value);

            IF Json.GET('CODIGOERROR') THEN
                IF Json.Value <> 'null' THEN
                    EXIT(Json.Value + ', Codigo: ' + pcodigo);
        END;

        CLEAR(ServicePointManager);
        CLEAR(HttpWebRequest);
        CLEAR(StreamWriter);
        CLEAR(HttpWebResponse);
    end;

    procedure ConsumeWSSUNATDownFile(pRuc: Text[30]): Boolean
    var
    //Automation  'Microsoft XML, v6.0'.XMLHTTP60;

    begin
    end;
}
