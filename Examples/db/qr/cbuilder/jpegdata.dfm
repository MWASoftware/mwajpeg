object DataModule1: TDataModule1
  OldCreateOrder = True
  OnCreate = DataModule1Create
  OnDestroy = DataModule1Destroy
  Left = 200
  Top = 108
  Height = 126
  Width = 173
  object Table1: TTable
    TableName = 'Jpegs.db'
    Left = 24
    Top = 16
    object Table1Subject: TStringField
      FieldName = 'Subject'
      Size = 100
    end
    object Table1Picture: TBlobField
      FieldName = 'Picture'
      Size = 1
    end
  end
end
