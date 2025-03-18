/*
    This file is part of the MWA JPEG COMPONENT LIBRARY.

    The MWA JPEG COMPONENT LIBRARY is free software: you can redistribute it
    and/or modify it under the terms of the GNU Lesser General Public License as
    published by the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    The MWA JPEG COMPONENT LIBRARY is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with the MWA JPEG COMPONENT LIBRARY.  If not, see <https://www.gnu.org/licenses/>.
*/
//---------------------------------------------------------------------------

#include <vcl.h>
#include <vcl\typinfo.hpp>
#include <vcl\db.hpp>
#if __TCPLUSPLUS__ == 0x0560
#include <vcl\DesignEditors.hpp>
#endif
#pragma hdrstop

#include "mwajpgpe.h"

#if __TCPLUSPLUS__ >= 0x0560
Designintf::TPropertyAttributes __fastcall  TJPEGDataFieldProperty::GetAttributes(void)
#else
Dsgnintf::TPropertyAttributes __fastcall  TJPEGDataFieldProperty::GetAttributes(void)
#endif
{
  return TPropertyAttributes() << paValueList << paSortList << paMultiSelect;
}

void TJPEGDataFieldProperty::GetValueList(TStrings *List)
{
  TComponent* Instance = dynamic_cast<TComponent*>(GetComponent(0));
  Typinfo::PPropInfo PropInfo = Typinfo::GetPropInfo((PTypeInfo)(Instance->ClassInfo()), "DataSet");
  Db::TDataSet* DataSet;
  if ((PropInfo != NULL) && ((*(PropInfo->PropType))->Kind == tkClass)) {
    DataSet = dynamic_cast<TDataSet*>((TObject*)GetOrdProp(Instance, PropInfo));
    if ((DataSet != NULL)) 
      DataSet->GetFieldNames(List);
  }
}

void __fastcall TJPEGDataFieldProperty::GetValues(Classes::TGetStrProc Proc)
{
  TStringList*  Values = new TStringList;    

  GetValueList(Values);
  for (int i = 0; i < Values->Count;i++) Proc(Values->Strings[i]);
  delete Values;
}
//---------------------------------------------------------------------------

#pragma package(smart_init)
