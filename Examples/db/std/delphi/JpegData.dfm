object DataModule1: TDataModule1
  OldCreateOrder = True
  OnCreate = DataModule1Create
  OnDestroy = DataModule1Destroy
  Height = 150
  Width = 215
  object Table1: TTable
    TableName = 'Jpegs.db'
    Left = 32
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
