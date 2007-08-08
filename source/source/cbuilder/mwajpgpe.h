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
