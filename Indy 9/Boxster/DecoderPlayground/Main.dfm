object formMain: TformMain
  Left = 163
  Top = 136
  Width = 755
  Height = 579
  Caption = 'Decoder Playground'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 225
    Top = 29
    Width = 8
    Height = 496
    Cursor = crHSplit
    Beveled = True
  end
  object lboxMessages: TListBox
    Left = 0
    Top = 29
    Width = 225
    Height = 496
    Align = alLeft
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    PopupMenu = PopupMenu1
    Sorted = True
    TabOrder = 0
    OnDblClick = lboxMessagesDblClick
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 747
    Height = 29
    Caption = 'ToolBar1'
    TabOrder = 1
    object ToolButton1: TToolButton
      Left = 0
      Top = 2
      Action = actnTest_Test
    end
  end
  object Panel2: TPanel
    Left = 233
    Top = 29
    Width = 514
    Height = 496
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 514
      Height = 105
      Align = alTop
      TabOrder = 0
      object Label1: TLabel
        Left = 24
        Top = 8
        Width = 45
        Height = 13
        Caption = 'Filename:'
      end
      object Label2: TLabel
        Left = 24
        Top = 32
        Width = 62
        Height = 13
        Caption = 'Attachments:'
      end
      object Label3: TLabel
        Left = 24
        Top = 56
        Width = 51
        Height = 13
        Caption = 'Text Parts:'
      end
      object lablFilename: TLabel
        Left = 96
        Top = 8
        Width = 36
        Height = 13
        Caption = '<none>'
      end
      object lablAttachments: TLabel
        Left = 96
        Top = 32
        Width = 6
        Height = 13
        Caption = '0'
      end
      object lablTextParts: TLabel
        Left = 96
        Top = 56
        Width = 6
        Height = 13
        Caption = '0'
      end
      object Label4: TLabel
        Left = 24
        Top = 80
        Width = 30
        Height = 13
        Caption = 'Errors:'
      end
      object lablErrors: TLabel
        Left = 96
        Top = 80
        Width = 26
        Height = 13
        Caption = 'None'
      end
    end
    object pctlMessage: TPageControl
      Left = 0
      Top = 105
      Width = 514
      Height = 391
      ActivePage = TabSheet3
      Align = alClient
      TabIndex = 2
      TabOrder = 1
      object tshtBody: TTabSheet
        Caption = 'Body'
        object memoBody: TMemo
          Left = 0
          Top = 0
          Width = 487
          Height = 288
          Align = alClient
          ReadOnly = True
          ScrollBars = ssBoth
          TabOrder = 0
          WordWrap = False
        end
      end
      object TabSheet2: TTabSheet
        Caption = 'Attachments'
        ImageIndex = 1
        object Splitter2: TSplitter
          Left = 121
          Top = 0
          Width = 8
          Height = 363
          Cursor = crHSplit
          Beveled = True
        end
        object lboxAttachments: TListBox
          Left = 0
          Top = 0
          Width = 121
          Height = 363
          Align = alLeft
          ItemHeight = 13
          Sorted = True
          TabOrder = 0
          OnDblClick = lboxAttachmentsDblClick
        end
        object Panel4: TPanel
          Left = 129
          Top = 0
          Width = 377
          Height = 363
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          object Splitter5: TSplitter
            Left = 0
            Top = 161
            Width = 377
            Height = 8
            Cursor = crVSplit
            Align = alTop
            Beveled = True
          end
          object memoAttachment: TMemo
            Left = 0
            Top = 169
            Width = 377
            Height = 194
            Align = alClient
            ReadOnly = True
            ScrollBars = ssBoth
            TabOrder = 0
            WordWrap = False
          end
          object memoAttachmentHeader: TMemo
            Left = 0
            Top = 0
            Width = 377
            Height = 161
            Align = alTop
            ReadOnly = True
            ScrollBars = ssBoth
            TabOrder = 1
          end
        end
      end
      object TabSheet3: TTabSheet
        Caption = 'Text Parts'
        ImageIndex = 2
        object Splitter3: TSplitter
          Left = 121
          Top = 0
          Width = 8
          Height = 363
          Cursor = crHSplit
          Beveled = True
        end
        object lboxTextParts: TListBox
          Left = 0
          Top = 0
          Width = 121
          Height = 363
          Align = alLeft
          ItemHeight = 13
          Sorted = True
          TabOrder = 0
          OnDblClick = lboxTextPartsDblClick
        end
        object Panel3: TPanel
          Left = 129
          Top = 0
          Width = 377
          Height = 363
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          object Splitter4: TSplitter
            Left = 0
            Top = 161
            Width = 377
            Height = 8
            Cursor = crVSplit
            Align = alTop
            Beveled = True
          end
          object memoTextPart: TMemo
            Left = 0
            Top = 169
            Width = 377
            Height = 194
            Align = alClient
            ReadOnly = True
            ScrollBars = ssBoth
            TabOrder = 0
            WordWrap = False
          end
          object memoTextPartHeader: TMemo
            Left = 0
            Top = 0
            Width = 377
            Height = 161
            Align = alTop
            ReadOnly = True
            ScrollBars = ssBoth
            TabOrder = 1
          end
        end
      end
      object TabSheet1: TTabSheet
        Caption = 'Raw Message'
        ImageIndex = 3
        object memoRaw: TMemo
          Left = 0
          Top = 0
          Width = 506
          Height = 363
          Align = alClient
          ReadOnly = True
          ScrollBars = ssBoth
          TabOrder = 0
          WordWrap = False
        end
      end
    end
  end
  object alstMain: TActionList
    Images = ImageList1
    OnUpdate = alstMainUpdate
    Left = 64
    Top = 56
    object actnFile_Exit: TAction
      Category = 'File'
      Caption = 'E&xit'
      OnExecute = actnFile_ExitExecute
    end
    object actnTest_Test: TAction
      Category = 'Test'
      Caption = '&Test'
      ShortCut = 16468
      OnExecute = actnTest_TestExecute
    end
    object actnTest_Emit: TAction
      Category = 'Test'
      Caption = '&Emit'
      ShortCut = 16453
      OnExecute = actnTest_TestExecute
    end
    object actnTest_Verify: TAction
      Category = 'Test'
      Caption = '&Verify'
      ShortCut = 120
      OnExecute = actnTest_TestExecute
    end
    object actnTest_VerifyAll: TAction
      Category = 'Test'
      Caption = 'Verify &All'
      OnExecute = actnTest_VerifyAllExecute
    end
  end
  object MainMenu1: TMainMenu
    Images = ImageList1
    Left = 64
    Top = 136
    object File1: TMenuItem
      Caption = '&File'
      object Exit1: TMenuItem
        Action = actnFile_Exit
      end
    end
    object Emit2: TMenuItem
      Caption = 'Test'
      ShortCut = 16453
      object eset1: TMenuItem
        Action = actnTest_Emit
      end
      object actnFileTest1: TMenuItem
        Action = actnTest_Test
      end
      object estandVerify2: TMenuItem
        Action = actnTest_Verify
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object VerifyAll1: TMenuItem
        Action = actnTest_VerifyAll
      end
    end
  end
  object PopupMenu1: TPopupMenu
    Images = ImageList1
    Left = 64
    Top = 200
    object estandVerify1: TMenuItem
      Action = actnTest_Verify
      Default = True
    end
    object Exit2: TMenuItem
      Action = actnTest_Test
    end
    object Emit1: TMenuItem
      Action = actnTest_Emit
    end
  end
  object ImageList1: TImageList
    Left = 64
    Top = 272
  end
end
