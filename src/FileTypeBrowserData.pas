unit FileTypeBrowserData;

interface

uses
  Classes, Rtti, SysUtils,
  FileTypeBrowserTypes;

type
  TFileKeyBrowserData = class
  protected
    fBaseFileName: String;
    fCaptions: TStringList;
    fFile: TFileStream;
    fFileBuffer: pByteArray;
    fFileType: TFileKey;
    fRttiContext: TRttiContext;
    fValid: Boolean;
    fValues: TStringList;
    fValueIndex: Integer;

    procedure InitializeCaptions;
    function ValueToString(const Value: TValue): String;
  public
    constructor Create(aBaseFileName: String; aFileType: TFileKey); reintroduce;
    destructor Destroy; override;

    function GetNextValues: TStringList;

    property Captions: TStringList read fCaptions;
    property Valid: Boolean read fValid;
  end;

implementation

uses
  TypInfo;

constructor TFileKeyBrowserData.Create(aBaseFileName: String; aFileType: TFileKey);
begin
  inherited Create;

  fBaseFileName:= aBaseFileName;
  fFileType:= aFileType;
  fCaptions:= nil;
  fFile:= nil;
  fValues:= TStringList.Create;

  { If the TFileType is not set, or the RTTI Type cannot be found, something is
    wrong and this data is not Valid }
  fValid:= (fFileType <> ftNone) and (Assigned(fRttiContext.FindType(FileRttiTypes[fFileType])));

  New(fFileBuffer);
  InitializeCaptions;
end;

destructor TFileKeyBrowserData.Destroy;
begin
  fCaptions.Free;
  fFile.Free;
  Dispose(fFileBuffer);
  inherited Destroy;
end;

procedure TFileKeyBrowserData.InitializeCaptions;
{ Populates the fCaptions StringList. If the TypeKind is not recognized, the
  StringList will be blank. Otherwise:
  - The first Caption will always be 'Index'.
  - For ordinal types, the second Caption will be 'Value'.
  - For record types, there will be one Caption per field starting on the second
    Caption, with each Caption corresponding to the record field name. }
var
  Field: TRttiField;
  RttiType: TRttiType;
  RttiRecord: TRttiRecordType;
begin
  if Valid then
  begin
    if not Assigned(fCaptions) then
      fCaptions:= TStringList.Create;
    RttiType:= fRttiContext.FindType(FileRttiTypes[fFileType]);
    case RttiType.TypeKind of
      tkInteger,
      tkChar,
      tkEnumeration:
      begin
        fCaptions.Clear;
        fCaptions.Add('Index');
        fCaptions.Add('Value');
      end;
      tkRecord:
      begin
        RttiRecord:= RttiType.AsRecord;
        fCaptions.Clear;
        fCaptions.Add('Index');
        for Field in RttiRecord.GetFields do
          fCaptions.Add(Field.Name);
      end;
      { These types are not yet supported
      tkUnknown:
      tkFloat:
      tkString:
      tkSet:
      tkClass:
      tkMethod:
      tkWChar:
      tkLString:
      tkWString:
      tkVariant:
      tkArray:
      tkInterface:
      tkInt64:
      tkDynArray:
      tkUString:
      tkClassRef:
      tkPointer:
      tkProcedure:
      }
    end;
  end
  else
  begin
    fCaptions.Free;
    fCaptions:= nil;
  end;
end;

function TFileKeyBrowserData.ValueToString(const Value: TValue): String;
{ Converts a TValue to a String. }
begin
  case Value.Kind of
    tkInteger,
    tkInt64:
      Result:= IntToStr(Value.AsInteger);
    tkEnumeration:
      Result:= GetEnumName(Value.TypeInfo, Value.AsOrdinal);
    { These types are not yet supported
    tkUnknown:
    tkChar:
    tkFloat:
    tkString:
    tkSet:
    tkClass:
    tkMethod:
    tkWChar:
    tkLString:
    tkWString:
    tkVariant:
    tkArray:
    tkRecord:
    tkInterface:
    tkDynArray:
    tkUString:
    tkClassRef:
    tkPointer:
    tkProcedure:
    }
  end;
end;

function TFileKeyBrowserData.GetNextValues: TStringList;
{ Returns a StringList containing the next set of Values (or the first if the
  file is not yet open).
  If EOF is reached, nil is returned. Otherwise:
  - The first Value is an incrementing index, beginning at 0.
  - For ordinal types, the second Value is the ordinal value.
  - For record types, there will be one Value per field starting on the second Value. }
var
  Field: TRttiField;
  Value: TValue;
  RttiType: TRttiType;
  RttiRecord: TRttiRecordType;
begin
  if Valid then
  begin
    if not Assigned(fFile) then
    begin
      fFile:= TFileStream.Create(fBaseFileName + SFileDelimiter + FileKeys[fFileType] + '.' + SFileExtension, fmOpenRead);
      fValueIndex:= 0;
    end;

    RttiType:= fRttiContext.FindType(FileRttiTypes[fFileType]);
    if fFile.Read(fFileBuffer^, RttiType.TypeSize) = RttiType.TypeSize then
    begin
      fValues.Clear;
      fValues.Add(IntToStr(fValueIndex));
      case RttiType.TypeKind of
        tkInteger,
        tkChar,
        tkEnumeration:
        begin
          TValue.Make(fFileBuffer, RttiType.Handle, Value);
          fValues.Add(ValueToString(Value));
        end;
        tkRecord:
        begin
          RttiRecord:= RttiType.AsRecord;
          for Field in RttiRecord.GetFields do
          begin
            Value:= Field.GetValue(fFileBuffer);
            fValues.Add(ValueToString(Value));
          end;
        end;
        { These types are not yet supported
        tkUnknown:
        tkFloat:
        tkString:
        tkSet:
        tkClass:
        tkMethod:
        tkWChar:
        tkLString:
        tkWString:
        tkVariant:
        tkArray:
        tkInterface:
        tkInt64:
        tkDynArray:
        tkUString:
        tkClassRef:
        tkPointer:
        tkProcedure:
        }
      end;
      Inc(fValueIndex);
    end
    else
    begin
      fValues.Free;
      fValues:= nil;
    end;
    Result:= fValues;
  end
  else
    Result:= nil;
end;

end.
