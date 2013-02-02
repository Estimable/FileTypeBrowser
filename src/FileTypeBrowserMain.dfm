object FileTypeBrowserForm: TFileTypeBrowserForm
  Left = 0
  Top = 0
  Caption = '%s Browser'
  ClientHeight = 358
  ClientWidth = 657
  Color = clBtnFace
  Constraints.MinHeight = 209
  Constraints.MinWidth = 672
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    657
    358)
  PixelsPerInch = 96
  TextHeight = 13
  object LabelFileName: TLabel
    Left = 8
    Top = 5
    Width = 76
    Height = 13
    Caption = 'Base File Name:'
  end
  object LabelFileType: TLabel
    Left = 432
    Top = 5
    Width = 47
    Height = 13
    Caption = 'File Type:'
  end
  object ListViewData: TListView
    Left = 8
    Top = 64
    Width = 641
    Height = 286
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <>
    TabOrder = 0
    ViewStyle = vsReport
  end
  object EditFileName: TEdit
    Left = 9
    Top = 24
    Width = 321
    Height = 21
    ReadOnly = True
    TabOrder = 1
  end
  object ButtonFileNameBrowse: TButton
    Left = 336
    Top = 24
    Width = 81
    Height = 21
    Caption = 'Browse...'
    TabOrder = 2
    OnClick = ButtonFileNameBrowseClick
  end
  object ButtonRefresh: TButton
    Left = 567
    Top = 24
    Width = 81
    Height = 21
    Caption = 'Refresh'
    TabOrder = 3
    OnClick = ButtonRefreshClick
  end
  object ComboBoxFileTypes: TComboBox
    Left = 432
    Top = 24
    Width = 121
    Height = 21
    Style = csDropDownList
    Sorted = True
    TabOrder = 4
    OnChange = ComboBoxFileTypesChange
  end
end
