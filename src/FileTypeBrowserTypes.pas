unit FileTypeBrowserTypes;

interface

uses
  PresortTypesX;

const
  { General Constants.
    Optional. (The default values may be used.) }

  { File extension used for all files }
  SFileExtension = 'MPS';

  { Human-readable File Name, used in the Application Title and the Browse dialog }
  SFileTitle = 'Presort File';

  { Delimiter between the Base File Name and the Key }
  SFileDelimiter = '_';

type
  { File Key enumeration.
    Required. }
  TFileKey = (
    ftNone,
    ftPCD,
    ftPCK,
    ftPPF,
    ftSCK
  );

const
  { File Name Keys. Used to determine active File Key.
    Required. }
  FileKeys: array[TFileKey] of String = (
    '',      { ftNone }
    'PCD',   { ftPCD }
    'PCK',   { ftPCK }
    'PPF',   { ftPPF }
    'SCK'    { ftSCK }
  );

  { Fully qualified type names. Used by RTTI.
    Required.
    NOTE: All units referred to must be included in the uses clause of this
    (or any other) unit to be present in the RTTI information. }
  FileRttiTypes: array[TFileKey] of String = (
    '',                            { ftNone }
    'PresortTypesX.TpSortType',    { ftPCD }
    'PresortTypesX.TPackRecord',   { ftPCK }
    'System.Integer',              { ftPPF }
    'PresortTypesX.TSackRecord'    { ftSCK }
  );

implementation

end.
