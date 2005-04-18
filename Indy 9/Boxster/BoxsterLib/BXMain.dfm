object Form1: TForm1
  Left = 313
  Top = 216
  Width = 556
  Height = 395
  Caption = 'Indy Boxster'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  PixelsPerInch = 96
  TextHeight = 13
  object pctlMain: TPageControl
    Left = 0
    Top = 0
    Width = 548
    Height = 368
    ActivePage = tshtTests
    Align = alClient
    TabOrder = 0
    object tshtTests: TTabSheet
      Caption = 'Tests'
      object Splitter1: TSplitter
        Left = 0
        Top = 224
        Width = 540
        Height = 3
        Cursor = crVSplit
        Align = alBottom
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 540
        Height = 41
        Align = alTop
        TabOrder = 0
        object butnTestCategory: TButton
          Left = 86
          Top = 8
          Width = 75
          Height = 25
          Caption = 'Test &Category'
          Default = True
          TabOrder = 0
          OnClick = butnTestCategoryClick
        end
        object butnTestSelected: TButton
          Left = 168
          Top = 8
          Width = 75
          Height = 25
          Action = actnTestSelected
          TabOrder = 1
        end
        object butnTestAll: TButton
          Left = 6
          Top = 8
          Width = 75
          Height = 25
          Caption = 'Test &All'
          Default = True
          TabOrder = 2
          OnClick = butnTestAllClick
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 41
        Width = 540
        Height = 183
        Align = alClient
        TabOrder = 1
        object Splitter2: TSplitter
          Left = 122
          Top = 1
          Width = 3
          Height = 181
          Cursor = crHSplit
        end
        object lstvTests: TListView
          Left = 125
          Top = 1
          Width = 414
          Height = 181
          Align = alClient
          Columns = <
            item
              Caption = 'Name'
              Width = 200
            end
            item
              Caption = 'Status'
              Width = 75
            end
            item
              Caption = 'Message'
              Width = 400
            end>
          GridLines = True
          HideSelection = False
          IconOptions.WrapText = False
          ReadOnly = True
          RowSelect = True
          SortType = stText
          TabOrder = 0
          ViewStyle = vsReport
        end
        object lboxCategories: TListBox
          Left = 1
          Top = 1
          Width = 121
          Height = 181
          Align = alLeft
          ItemHeight = 13
          TabOrder = 1
          OnClick = lboxCategoriesClick
        end
      end
      object Panel3: TPanel
        Left = 0
        Top = 227
        Width = 540
        Height = 113
        Align = alBottom
        TabOrder = 2
        object Splitter3: TSplitter
          Left = 177
          Top = 1
          Width = 3
          Height = 111
          Cursor = crHSplit
        end
        object memoMessages: TMemo
          Left = 180
          Top = 1
          Width = 359
          Height = 111
          Align = alClient
          ScrollBars = ssVertical
          TabOrder = 0
        end
        object Memo1: TMemo
          Left = 1
          Top = 1
          Width = 176
          Height = 111
          Align = alLeft
          ScrollBars = ssVertical
          TabOrder = 1
        end
      end
    end
    object tshtGlobalParams: TTabSheet
      Caption = 'Global Params'
      ImageIndex = 1
      object memoGlobalParams: TMemo
        Left = 0
        Top = 0
        Width = 540
        Height = 340
        Align = alClient
        Lines.Strings = (
          'memoGlobalParams')
        TabOrder = 0
      end
    end
  end
  object ActionList1: TActionList
    Left = 168
    Top = 80
    object actnTestSelected: TAction
      Caption = 'Test &Selected'
      OnExecute = actnTestSelectedExecute
      OnUpdate = actnTestSelectedUpdate
    end
  end
end
