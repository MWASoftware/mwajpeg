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

#ifndef mwajpgpeH
#define mwajpgpeH
#if __TCPLUSPLUS__ >= 0x0560
#include <vcl\DesignEditors.HPP>
#include <vcl\DesignIntf.hpp>
#else
#include <vcl\DsgnIntf.hpp>
#endif
//---------------------------------------------------------------------------
class PACKAGE TJPEGDataFieldProperty: public TStringProperty
{
public:
#if __TCPLUSPLUS__ >= 0x0560
    virtual Designintf::TPropertyAttributes __fastcall  GetAttributes(void);
#else
    virtual Dsgnintf::TPropertyAttributes __fastcall  GetAttributes(void);
#endif
    void GetValueList(TStrings *List);
    virtual void __fastcall GetValues(Classes::TGetStrProc Proc);
};
#endif
