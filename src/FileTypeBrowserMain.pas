unit FileTypeBrowserMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls,
  FileTypeBrowserTypes;

type
  TFileTypeBrowserForm = class(TForm)
    ListViewData: TListView;
    EditFileName: TEdit;
    ButtonFileNameBrowse: TButton;
    ButtonRefresh: TButton;
    ComboBoxFileTypes: TComboBox;
    LabelFileName: TLabel;
    LabelFileType: TLabel;
    procedure ButtonFileNameBrowseClick(Sender: TObject);
    procedure ComboBoxFileTypesChange(Sender: TObject);
  private
    fBaseFileName: String;
    procedure RefreshFileTypes;
    procedure RefreshListView;
    procedure RefreshUI;
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  FileTypeBrowserForm: TFileTypeBrowserForm;

implementation

{$R *.dfm}

uses
  FileTypeBrowserData;

{ TFileTypeBrowserForm }

procedure TFileTypeBrowserForm.ButtonFileNameBrowseClick(Sender: TObject);
var
  OpenDialog: TOpenDialog;
  i: Integer;
begin
  { Show the Open Dialog }
  OpenDialog:= TOpenDialog.Create(Self);
  try
    OpenDialog.Title:= 'Browse for ' + SFileTitle;
    if fBaseFileName <> '' then
      OpenDialog.InitialDir:= ExtractFilePath(fBaseFileName)
    else
      OpenDialog.InitialDir:= GetCurrentDir;
    OpenDialog.Filter:= SFileTitle + '|*.' + SFileExtension;
    OpenDialog.FilterIndex:= 1;
    if OpenDialog.Execute then
      fBaseFileName:= OpenDialog.FileName
    else
      fBaseFileName:= '';
  finally
    OpenDialog.Free;
  end;

  if fBaseFileName <> '' then
  begin
    { Find the position of the Delimiter in the File Name specified by the user. }
    i:= Length(fBaseFileName);
    while (fBaseFileName[i] <> SFileDelimiter) and (i >= 0) do
      Dec(i);

    { If the delimiter is present, set the Base File Name and the Edit Box contents
      and refresh the List View. }
    if i >= 0 then
    begin
      fBaseFileName:= Copy(fBaseFileName, 1, i - 1);
      EditFileName.Text:= fBaseFileName + SFileDelimiter + '*.' + SFileExtension;
      RefreshFileTypes;
    end
    else
      fBaseFileName:= '';
  end;
  RefreshUI;
end;

procedure TFileTypeBrowserForm.ComboBoxFileTypesChange(Sender: TObject);
begin
  RefreshListView;
end;

constructor TFileTypeBrowserForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fBaseFileName:= '';
  Caption:= Format(Caption, [SFileTitle]);
  RefreshUI;
end;

procedure TFileTypeBrowserForm.RefreshFileTypes;
var
  FileType: TFileKey;
  ActiveFileType: TFileKey;
  lItemIndex: Integer;
  OldCursor: TCursor;
begin
  OldCursor:= Cursor;
  Cursor:= crHourglass;
  try
    { Save the currently selected Key, if applicable }
    if ComboBoxFileTypes.ItemIndex >= 0 then
      ActiveFileType:= TFileKey(ComboBoxFileTypes.Items.Objects[ComboBoxFileTypes.ItemIndex])
    else
      ActiveFileType:= ftNone;

    { Update the contents of the Combo Box }
    lItemIndex:= -1;
    ComboBoxFileTypes.Items.BeginUpdate;
    try
      ComboBoxFileTypes.Items.Clear;
      for FileType:= Low(FileType) to High(FileType) do
      begin
        if (FileType <> ftNone) and
           FileExists(fBaseFileName + SFileDelimiter + FileKeys[FileType] + '.' + SFileExtension) then
        begin
          ComboBoxFileTypes.Items.AddObject(FileKeys[FileType], TObject(FileType));
          if FileType = ActiveFileType then
            lItemIndex:= ComboBoxFileTypes.Items.Count - 1;
        end;
      end;
    finally
      ComboBoxFileTypes.Items.EndUpdate;
    end;

    { If the currently selected Key was present, select it;
      otherwise, select the first item }
    if (lItemIndex < 0) and (ComboBoxFileTypes.Items.Count > 0) then
      lItemIndex:= 0;
    ComboBoxFileTypes.ItemIndex:= lItemIndex;

    { Refresh the List View as we may have changed the currently selected Key }
    RefreshListView;
  finally
    Cursor:= OldCursor;
  end;
end;

procedure TFileTypeBrowserForm.RefreshListView;
var
  Data: TFileKeyBrowserData;
  Column: TListColumn;
  Index: Integer;
  ListItem: TListItem;
  Values: TStringList;
  OldCursor: TCursor;
begin
  OldCursor:= Cursor;
  Cursor:= crHourglass;
  try
    if ComboBoxFileTypes.ItemIndex >= 0 then
    begin
      Data:= TFileKeyBrowserData.Create(fBaseFileName, TFileKey(ComboBoxFileTypes.Items.Objects[ComboBoxFileTypes.ItemIndex]));
      try
        ListViewData.Columns.BeginUpdate;
        ListViewData.Items.BeginUpdate;
        try
          ListViewData.Items.Clear;
          ListViewData.Columns.Clear;
          { If the Data is not valid (e.g. TFileKey was ftNone or RTTI information
            could not be found), just leave the List View blank }
          if Data.Valid then
          begin
            { Columns }
            for Index:= 0 to Data.Captions.Count - 1 do
            begin
              Column:= ListViewData.Columns.Add;
              Column.Caption:= Data.Captions[Index];
              { Adjusts width to header, although if the contents are larger it
                appears Windows uses that instead }
              Column.Width:= -2;
            end;
            { Items }
            Values:= Data.GetNextValues;
            while Assigned(Values) do
            begin
              ListItem:= ListViewData.Items.Add;
              for Index:= 0 to Values.Count - 1 do
              begin
                case Index of
                  0:
                    ListItem.Caption:= Values[Index];
                  else
                    ListItem.SubItems.Add(Values[Index]);
                end;
              end;
              Values:= Data.GetNextValues;
            end;
          end;
        finally
          ListViewData.Columns.EndUpdate;
          ListViewData.Items.EndUpdate;
        end;
      finally
        Data.Free;
      end;
    end;
  finally
    Cursor:= OldCursor;
  end;
end;

procedure TFileTypeBrowserForm.RefreshUI;
begin
  ComboBoxFileTypes.Enabled:= fBaseFileName <> '';
  ButtonRefresh.Enabled:= fBaseFileName <> '';
end;

end.
