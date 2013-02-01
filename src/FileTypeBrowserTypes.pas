unit FileTypeBrowserTypes;

interface

//uses
  { Units for any types referred to in FileRttiTypes must be included here. }

const
  { General Constants.
    Optional. (The default values may be used.) }

  { File extension used for all files }
  SFileExtension = 'DAT';

  { Human-readable File Name, used in the Application Title and the Browse dialog }
  SFileTitle = 'DAT File';

  { Delimiter between the Base File Name and the Key }
  SFileDelimiter = '_';

type
  { File Key enumeration.
    Required. }
  TFileKey = (
    ftNone,
//  ft<...>
  );

const
  { File Name Keys. Used to determine active File Key.
    Required. }
  FileKeys: array[TFileKey] of String = (
    '',      { ftNone }
//  '...'    { ft<...> }
  );

  { Fully qualified type names. Used by RTTI.
    Required.
    NOTE: All units referred to must be included in the uses clause of this
    (or any other) unit to be present in the RTTI information. }
  FileRttiTypes: array[TFileKey] of String = (
    '',                            { ftNone }
//  'UnitName.TypeName',           { ft<...> }
  );

implementation

end.
