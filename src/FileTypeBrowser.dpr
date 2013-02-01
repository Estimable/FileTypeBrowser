program FileTypeBrowser;

uses
  Forms,
  FileTypeBrowserData in 'FileTypeBrowserData.pas',
  FileTypeBrowserMain in 'FileTypeBrowserMain.pas',
  FileTypeBrowserTypes in 'FileTypeBrowserTypes.pas';

{$R *.res}

{ Since we are not directly using the types we are pulling RTTI for, this flag
  must be on to force the linker to include the types in RTTI anyway }
{$STRONGLINKTYPES ON}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFileTypeBrowserForm, FileTypeBrowserForm);
  Application.Run;
end.
