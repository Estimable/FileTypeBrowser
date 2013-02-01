FileTypeBrowser
===============

Small Delphi utility allowing users to explore multiple related files of &lt;type> based solely on the types defined.

Overview
========

The utility will generate List Views showing the contents of files with simple file structures, with the structures being pulled directly from the code at runtime. Specifically, each file must consist of only one type (`File of <type>`). These types may be any ordinal or enumerated type, or records containing any combination of ordinal and enumerated types.

This is of particular value for legacy Delphi applications which may store large amounts of data in many working files.

Initially, this application is intended to work only with multiple files of the form:

    <Base File Name><Delimiter><Key>.<Extension>
		
So, for instance, the following group of files would match the above form:

    FILE-ABC.DAT
		FILE-DEF.DAT
		FILE-GHI.DAT

Setup
=====

This project has been tested on Delphi 2010. It should compile on Delphi 2007, but will not compile on older versions of Delphi.

The utility requires some initial setup before compilation, since it compiles in units containing definitions of the appropriate type(s) and uses enhanced RTTI to determine the file type at runtime.

All required setup is in the unit `FileTypeBrowserTypes.pas`.

The following constants contain default values but may be modified:
- `SFileExtension`: File extension.
- `SFileTitle`: Human-readable name of the File Type, used in the Application Title and the Browse dialog.
- `SFileDelimiter`: Delimiter between the Base File Name and the Key.

For each key, an enumerated value must be added to the `TFileKey` type. Two further values must also be added for each key:
- `FileKeys`: The Key value used in the actual filename. So for the above example, the FileKeys value would be `'ABC'`, `'DEF'`, and `'GHI'`.
- `FileRttiTypes`: Fully qualified names of the type of each file. If the file was structured as a `File of Integer`, for instance, the FileRttiTypes value would be `'System.Integer'`.

All of the `TFileKey` data is required.

Usage
=====

Browse to any one of the files in a file group. The utility will derive the Base File Name and check for the presence of files for all TFileKeys it knows about. The files in the group may be switched, by Key, by using the File Type Combo Box.

The contents of the file will be shown in the List Box. The Index value is always included as the first column for reference purposes.
