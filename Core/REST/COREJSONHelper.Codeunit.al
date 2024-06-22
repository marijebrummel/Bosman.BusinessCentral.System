namespace Own.Core.Helpers;

codeunit 50003 "CORE JSON Helper"
{
    procedure AddGenericValue(var Object: JsonObject; KeyName: Text; Value: Variant)
    var
        BigIntValue: BigInteger;
        BoolValue: Boolean;
        CodeValue: Code[250];
        DateValue: Date;
        DateTimeValue: DateTime;
        DecimalValue: Decimal;
        GuidValue: Guid;
        IntValue: Integer;
        TextValue: Text;
    begin
        case true of
            Value.IsBigInteger:
                begin
                    BigIntValue := Value;
                    AddValue(Object, KeyName, BigIntValue)
                end;
            Value.IsBoolean:
                begin
                    BoolValue := Value;
                    AddValue(Object, KeyName, BoolValue)
                end;
            Value.IsCode:
                begin
                    CodeValue := Value;
                    AddValue(Object, KeyName, CodeValue)
                end;
            Value.IsDate:
                begin
                    DateValue := Value;
                    AddValue(Object, KeyName, DateValue)
                end;
            Value.IsDateTime:
                begin
                    DateTimeValue := Value;
                    AddValue(Object, KeyName, DateTimeValue)
                end;
            Value.IsDecimal:
                begin
                    DecimalValue := Value;
                    AddValue(Object, KeyName, DecimalValue)
                end;
            Value.IsGuid:
                begin
                    GuidValue := Value;
                    AddValue(Object, KeyName, GuidValue)
                end;
            Value.IsInteger:
                begin
                    IntValue := Value;
                    AddValue(Object, KeyName, IntValue)
                end;
            Value.IsText:
                begin
                    TextValue := Value;
                    AddValue(Object, KeyName, TextValue)
                end;
            Value.IsOption:
                begin
                    IntValue := Value;
                    AddValue(Object, KeyName, IntValue)
                end;
        end;
    end;

    procedure AddNullValue(var Object: JsonObject; KeyName: Text)
    var
        NullValue: JsonValue;
    begin
        Object.Add(KeyName, NullValue);
    end;

    procedure AddValue(var Object: JsonObject; KeyName: Text; Value: Text)
    begin
        AddValue(Object, KeyName, Value, false);
    end;

    procedure AddValue(var Object: JsonObject; KeyName: Text; Value: Text; AddEmptyValues: Boolean)
    var
        ValueToAdd: JsonValue;
    begin
        if (not AddEmptyValues) and (Value = '') then
            exit;

        ValueToAdd.SetValue(value);
        Object.Add(KeyName, ValueToAdd);
    end;

    procedure AddValue(var Object: JsonObject; KeyName: Text; Value: Integer)
    var
        ValueToAdd: JsonValue;
    begin
        ValueToAdd.SetValue(value);
        Object.Add(KeyName, ValueToAdd);
    end;

    procedure AddValue(var Object: JsonObject; KeyName: Text; Value: Boolean)
    var
        ValueToAdd: JsonValue;
    begin
        ValueToAdd.SetValue(value);
        Object.Add(KeyName, ValueToAdd);
    end;

    procedure AddValue(var Object: JsonObject; KeyName: Text; Value: Decimal)
    var
        ValueToAdd: JsonValue;
    begin
        ValueToAdd.SetValue(value);
        Object.Add(KeyName, ValueToAdd);
    end;

    procedure AddValue(var Object: JsonObject; KeyName: Text; Value: DateTime)
    var
        ValueToAdd: JsonValue;
    begin
        ValueToAdd.SetValue(value);
        Object.Add(KeyName, ValueToAdd);
    end;

    procedure AddValue(var Object: JsonObject; KeyName: Text; Value: Date)
    var
        ValueToAdd: JsonValue;
    begin
        ValueToAdd.SetValue(value);
        Object.Add(KeyName, ValueToAdd);
    end;

    procedure Add(var Object: JsonObject; KeyName: Text; ObjectToAdd: JsonObject)
    begin
        Object.Add(KeyName, ObjectToAdd);
    end;

    procedure Add(var Object: JsonObject; KeyName: Text; ArrayToAdd: JsonArray)
    begin
        Object.Add(KeyName, ArrayToAdd);
    end;

    procedure Add(var Objects: JsonArray; ObjectToAdd: JsonObject)
    begin
        Objects.Add(ObjectToAdd);
    end;

    procedure GetCodeValue(Token: JsonToken; KeyName: Text): Code[250]
    begin
        if Token.IsObject() then
            exit(GetCodeValue(Token.AsObject(), KeyName, '', 250));
    end;

    procedure GetCodeValue(Token: JsonToken; KeyName: Text; MaxLenght: Integer): Code[250]
    begin
        if Token.IsObject() then
            exit(GetCodeValue(Token.AsObject(), KeyName, '', MaxLenght));
    end;

    procedure GetCodeValue(Token: JsonToken; KeyName: Text; DefaultValue: Code[250]; MaxLenght: Integer): Code[250]
    begin
        if Token.IsObject() then
            exit(GetCodeValue(Token.AsObject(), KeyName, DefaultValue, MaxLenght));
    end;

    procedure GetCodeValue(Object: JsonObject; KeyName: Text): Code[250]
    begin
        exit(GetCodeValue(Object, KeyName, '', 250));
    end;

    procedure GetCodeValue(Object: JsonObject; KeyName: Text; DefaultValue: Code[250]): Code[250]
    begin
        exit(GetCodeValue(Object, KeyName, DefaultValue, 250));
    end;

    procedure GetCodeValue(Object: JsonObject; KeyName: Text; DefaultValue: Code[250]; MaxLenght: Integer): Code[250]
    var
        Token: JsonToken;
        JsonVal: JsonValue;
    begin
        if not Object.Contains(KeyName) then
            exit(DefaultValue);

        Object.Get(KeyName, Token);
        if not Token.IsValue() then
            exit(DefaultValue);

        JsonVal := Token.AsValue();
        if JsonVal.IsNull() or JsonVal.IsUndefined() then
            exit(DefaultValue);

        exit(CopyStr(JsonVal.AsCode(), 1, 250));
    end;

    procedure GetTextValue(Token: JsonToken; KeyName: Text): Text
    begin
        if Token.IsObject() then
            exit(GetTextValue(Token.AsObject(), KeyName, '', 250));
    end;

    procedure GetTextValue(Token: JsonToken; KeyName: Text; MaxLenght: Integer): Text
    begin
        if Token.IsObject() then
            exit(GetTextValue(Token.AsObject(), KeyName, '', MaxLenght));
    end;

    procedure GetTextValue(Token: JsonToken; KeyName: Text; DefaultValue: Text; MaxLenght: Integer): Text
    begin
        if Token.IsObject() then
            exit(GetTextValue(Token.AsObject(), KeyName, DefaultValue, MaxLenght));
    end;

    procedure GetTextValue(Object: JsonObject; KeyName: Text): Text
    begin
        exit(GetTextValue(Object, KeyName, '', 250));
    end;

    procedure GetTextValue(Object: JsonObject; KeyName: Text; MaxLenght: Integer): Text
    begin
        exit(GetTextValue(Object, KeyName, '', MaxLenght));
    end;

    procedure GetTextValue(Object: JsonObject; KeyName: Text; DefaultValue: Text; MaxLenght: Integer): Text
    var
        Token: JsonToken;
        JsonVal: JsonValue;
    begin
        if not Object.Contains(KeyName) then
            exit(DefaultValue);

        Object.Get(KeyName, Token);
        if not Token.IsValue() then
            exit(DefaultValue);

        JsonVal := Token.AsValue();
        if JsonVal.IsNull() or JsonVal.IsUndefined() then
            exit(DefaultValue);

        if MaxLenght = 0 then
            exit(JsonVal.AsText())
        else
            exit(CopyStr(JsonVal.AsText(), 1, MaxLenght))
    end;

    procedure GetIntegerValue(Token: JsonToken; KeyName: Text): Integer
    begin
        if Token.IsObject() then
            exit(GetIntegerValue(Token.AsObject(), KeyName));
    end;

    procedure GetIntegerValue(Token: JsonToken; KeyName: Text; DefaultValue: Integer): Integer
    begin
        if Token.IsObject() then
            exit(GetIntegerValue(Token.AsObject(), KeyName, DefaultValue));
    end;

    procedure GetIntegerValue(Object: JsonObject; KeyName: Text): Integer
    begin
        exit(GetIntegerValue(Object, KeyName, 0));
    end;

    procedure GetIntegerValue(Object: JsonObject; KeyName: Text; DefaultValue: Integer): Integer
    var
        Token: JsonToken;
        JsonVal: JsonValue;
    begin
        if not Object.Contains(KeyName) then
            exit(DefaultValue);

        Object.Get(KeyName, Token);
        if not Token.IsValue() then
            exit(DefaultValue);

        JsonVal := Token.AsValue();
        if JsonVal.IsNull() or JsonVal.IsUndefined() then
            exit(DefaultValue);

        exit(JsonVal.AsInteger());
    end;

    procedure GetDecimalValue(Token: JsonToken; KeyName: Text): Decimal
    begin
        if Token.IsObject() then
            exit(GetDecimalValue(Token.AsObject(), KeyName, 0));
    end;

    procedure GetDecimalValue(Object: JsonObject; KeyName: Text): Decimal
    begin
        exit(GetDecimalValue(Object, KeyName, 0));
    end;

    procedure GetDecimalValue(Object: JsonObject; KeyName: Text; DefaultValue: Decimal): Decimal
    var
        Token: JsonToken;
        JsonVal: JsonValue;
    begin
        if not Object.Contains(KeyName) then
            exit(DefaultValue);

        Object.Get(KeyName, Token);
        if not Token.IsValue() then
            exit(DefaultValue);

        JsonVal := Token.AsValue();
        if JsonVal.IsNull() or JsonVal.IsUndefined() then
            exit(DefaultValue);

        exit(JsonVal.AsDecimal());
    end;

    procedure GetBooleanValue(Token: JsonToken; KeyName: Text): Boolean
    begin
        if Token.IsObject() then
            exit(GetBooleanValue(Token.AsObject(), KeyName, false));
    end;

    procedure GetBooleanValue(Token: JsonToken; KeyName: Text; DefaultValue: Boolean): Boolean
    begin
        if Token.IsObject() then
            exit(GetBooleanValue(Token.AsObject(), KeyName, DefaultValue));
    end;

    procedure GetBooleanValue(Object: JsonObject; KeyName: Text): Boolean
    begin
        exit(GetBooleanValue(Object, KeyName, false));
    end;

    procedure GetBooleanValue(Object: JsonObject; KeyName: Text; DefaultValue: Boolean): Boolean
    var
        Token: JsonToken;
        JsonVal: JsonValue;
    begin
        if not Object.Contains(KeyName) then
            exit(DefaultValue);

        Object.Get(KeyName, Token);
        if not Token.IsValue() then
            exit(DefaultValue);

        JsonVal := Token.AsValue();
        if JsonVal.IsNull() or JsonVal.IsUndefined() then
            exit(DefaultValue);

        exit(JsonVal.AsBoolean());
    end;

    procedure GetGuidValue(Token: JsonToken; KeyName: Text): Guid
    begin
        if Token.IsObject() then
            exit(GetGuidValue(Token.AsObject(), KeyName));
    end;

    procedure GetGuidValue(Object: JsonObject; KeyName: Text): Guid
    var
        Val: Guid;
        Token: JsonToken;
        JsonVal: JsonValue;
        TxtValue: Text;
    begin
        if not Object.Contains(KeyName) then
            exit;

        Object.Get(KeyName, Token);
        if not Token.IsValue() then
            exit;

        JsonVal := Token.AsValue();
        if JsonVal.IsNull() or JsonVal.IsUndefined() then
            exit;

        TxtValue := JsonVal.AsText();

        if not Evaluate(Val, TxtValue) then
            Error(CouldNotCastErr, JsonVal.AsText(), 'guid');

        exit(Val);
    end;

    procedure GetDateValue(Token: JsonToken; KeyName: Text): Date
    begin
        if Token.IsObject() then
            exit(GetDateValue(Token.AsObject(), KeyName));
    end;

    procedure GetDateValue(Object: JsonObject; KeyName: Text): Date
    begin
        exit(GetDateValue(Object, KeyName, 0D));
    end;

    procedure GetDateValue(Object: JsonObject; KeyName: Text; DefaultValue: Date): Date
    var
        Val: Date;
        Token: JsonToken;
        JsonVal: JsonValue;
        TxtValue: Text;
    begin
        if not Object.Contains(KeyName) then
            exit(DefaultValue);

        Object.Get(KeyName, Token);
        if not Token.IsValue() then
            exit(DefaultValue);

        JsonVal := Token.AsValue();
        if JsonVal.IsNull() or JsonVal.IsUndefined() then
            exit(DefaultValue);

        TxtValue := JsonVal.AsText();

        if TxtValue.Contains(' ') then
            TxtValue := TxtValue.Split(' ').Get(1);

        if TxtValue.Contains('T') then
            TxtValue := TxtValue.Split('T').Get(1);

        if not Evaluate(Val, TxtValue) then
            Error(CouldNotCastErr, JsonVal.AsText(), 'date');

        exit(Val);
    end;

    procedure GetDateTimeValue(Token: JsonToken; KeyName: Text): DateTime
    begin
        if Token.IsObject() then
            exit(GetDateTimeValue(Token.AsObject(), KeyName));
    end;

    procedure GetDateTimeValue(Token: JsonToken; KeyName: Text; DefaultValue: DateTime): DateTime
    begin
        if Token.IsObject() then
            exit(GetDateTimeValue(Token.AsObject(), KeyName, DefaultValue));
    end;

    procedure GetDateTimeValue(Object: JsonObject; KeyName: Text): DateTime
    begin
        exit(GetDateTimeValue(Object, KeyName, 0DT));
    end;

    procedure GetDateTimeValue(Object: JsonObject; KeyName: Text; DefaultValue: DateTime): DateTime
    var
        DT: DateTime;
        Token: JsonToken;
        JsonVal: JsonValue;
    begin
        if not Object.Contains(KeyName) then
            exit(DefaultValue);

        Object.Get(KeyName, Token);
        if not Token.IsValue() then
            exit(DefaultValue);

        JsonVal := Token.AsValue();
        if JsonVal.IsNull() or JsonVal.IsUndefined() then
            exit(DefaultValue);

        if not Evaluate(DT, JsonVal.AsText()) then
            if not Evaluate(DT, JsonVal.AsText().Replace('T', ' ')) then
                if not Evaluate(DT, CopyStr(JsonVal.AsText(), 1, 10)) then
                    Error(CouldNotCastErr, JsonVal.AsText(), 'datetime');

        exit(DT);
    end;

    procedure IsNullValue(Object: JsonObject; KeyName: Text): boolean
    var
        Token: JsonToken;
        JsonVal: JsonValue;
    begin
        if not Object.Get(KeyName, Token) then
            exit(false);
        if not Token.IsValue() then
            exit(false);
        JsonVal := Token.AsValue();
        if JsonVal.IsNull() or JsonVal.IsUndefined() then
            exit(true);
        exit(false);
    end;

    procedure Get(Token: JsonToken; KeyName: Text): JsonToken
    var
        ResultToken: JsonToken;
    begin
        if not Token.IsObject() then
            exit;

        Token.AsObject().Get(KeyName, ResultToken);
        exit(ResultToken);
    end;

    procedure Get(Object: JsonObject; KeyName: Text): JsonToken
    var
        Token: JsonToken;
    begin
        Object.get(KeyName, Token);
        exit(Token);
    end;

    procedure GetArray(Token: JsonToken; KeyName: Text): JsonArray
    var
        ArrayToken: JsonToken;
    begin
        if not Contains(Token, KeyName) then
            exit;

        if not Token.AsObject().Get(KeyName, ArrayToken) then
            exit;

        if not ArrayToken.IsArray() then
            exit;

        exit(ArrayToken.AsArray());
    end;

    procedure GetArray(Object: JsonObject; KeyName: Text): JsonArray
    var
        DefaultValue: JsonArray;
        Token: JsonToken;
    begin
        Object.Get(KeyName, Token);

        if not Token.IsArray() then
            exit(DefaultValue);

        exit(Token.AsArray());
    end;

    procedure Contains(Token: JsonToken; "Key": Text): Boolean
    begin
        if not Token.IsObject() then
            exit(false);

        exit(Token.AsObject().Contains("Key"));
    end;

    procedure GetIdFromResponse(ResponseObject: JsonToken): Text
    begin
        if ResponseObject.IsObject() then
            exit(GetTextValue(ResponseObject.AsObject(), 'id'));
    end;

    var
        CouldNotCastErr: Label 'Could not cast value %1 to %2.', Comment = '%1=The source type,%2=The destination type';


}
