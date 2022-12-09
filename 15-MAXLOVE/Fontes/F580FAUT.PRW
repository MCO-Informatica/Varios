#include "PROTHEUS.CH"


User Function F580FAUT()

Local _cFiltro	:=	""

_cFiltro += "E2_FILIAL = '"+xFilial("SE2")+"'"
_cFiltro += " AND (E2_FORNECE>='"+mv_par01+"' AND E2_FORNECE<='"+mv_par02+"'"
_cFiltro += " AND E2_PORTADO>='"+mv_par03+"' AND E2_PORTADO<='"+mv_par04+"'"
_cFiltro += " AND E2_VENCTO >='"+DTOS(mv_par05)+"'"
_cFiltro += " AND E2_VENCTO <='"+Dtos(mv_par06)+"'"
_cFiltro += " AND E2_VENCTO >='"+DTOS(mv_par05)+"'"
_cFiltro += " AND E2_VALOR>="+ALLTRIM(STR(mv_par07,17,2))
_cFiltro += " AND E2_VALOR<="+ALLTRIM(STR(mv_par08,17,2))
_cFiltro +=	" AND E2_TIPO>='"+mv_par09+"' AND E2_TIPO<='"+mv_par10+"'"
_cFiltro += " AND E2_TIPO NOT IN " + FormatIn(MVABATIM,"|")
_cFiltro += " AND E2_SALDO>0)"
_cFiltro += " AND ((E2_DATALIB='"+dtos(ctod(""))+"')"
_cFiltro += " OR (E2_SALDO+E2_SDACRES-E2_SDDECRE<="+ALLTRIM(STR(GetMv('MV_VLMINPG'),17,2))
_cFiltro += " AND E2_SALDO>0"
_cFiltro += " AND E2_DATALIB='"+dTos(ctod(""))+"'))"
_cFiltro += " AND E2_DATASUS = '" + dTos(ctod("")) + "'"
_cFiltro += " AND E2_DATACAN = '" + dTos(ctod("")) + "'"

_cFiltro += " AND E2_EMISSAO >= '"+DTOS(MV_PAR13)+"'"
_cFiltro += " AND E2_EMISSAO <= '"+DTOS(MV_PAR14)+"'"
_cFiltro += " AND E2_PREFIXO >= '"+(MV_PAR15)+"'"
_cFiltro += " AND E2_PREFIXO <= '"+(MV_PAR16)+"'"
_cFiltro += " AND E2_NUM >= '"+(MV_PAR17)+"'"
_cFiltro += " AND E2_NUM <= '"+(MV_PAR18)+"'"
_cFiltro += " AND E2_EMIS1 >= '"+DTOS(MV_PAR19)+"'"
_cFiltro += " AND E2_EMIS1 <= '"+DTOS(MV_PAR20)+"'"

Return(_cFiltro)

