#include "rwmake.ch"

/*
 *
 * Objetivo: Exibir relatório de estatística de vendas baseado no mesmo relatório no Gestoq
 * Estoque -> Relatórios -> Gerencial de Estoque -> Aba estatística
 *
*/
User Function rptEstatV()

	PRIVATE CbTxt     := ""
	PRIVATE CbCont    := ""
	PRIVATE nOrdem    := 0
	PRIVATE Alfa      := 0
	PRIVATE Z         := 0
	PRIVATE M         := 0
	PRIVATE tamanho   := "M"
	PRIVATE limite    := 136
	PRIVATE ctitulo   := PADC("rptEstVen - Estatística de vendas", 74)
	PRIVATE cDesc1    := PADC("Este Programa tem  a  Finalidade de Emitir a(s) Relação(ões) de Ro- ",74)
	PRIVATE cDesc2    := PADC("maneio(s). Desenvolvido para Uso Exclusivo da Empresa EletroMega    ",74)
	PRIVATE cDesc3    := PADC("                                                                    ",74)
	PRIVATE aReturn   := { "Especial", 1,"Administracao", 2, 2, 1,"",1 }
	PRIVATE nomeprog  := "rptEstVen"
	PRIVATE cPerg     := "AFI377"
	PRIVATE nLastKey  := 0
	PRIVATE lContinua := .T.
	PRIVATE _nLin     := 0
	PRIVATE Li        := 0
	PRIVATE wnrel     := "rptRelRom"

	// RPTESTVEND	
	Pergunte(cPerg,.F.)               // Pergunta no SX1
	
	PRIVATE cString:="SF4"
	
	Wnrel := SetPrint(cString,wnRel,cPerg,cTitulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,Tamanho)
	
	If nLastKey == 27
	   Return(.T.)
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
	   Return(.T.)
	Endif
	
	aReturn[ 4 ] := 1
	
	_cQuery := 'SELECT    COUNT( * ) FROM SC5010 '
	_cQuery += "WHERE     (SC5.C5_NOTA <> '      ') AND (SC5.D_E_L_E_T_ <> '*') AND (SF2.F2_EMISSAO >= '" + DtoS( MV_PAR01 ) + "') AND"
	_cQuery += "          (SF2.F2_EMISSAO <= '" + DtoS( MV_PAR02 ) + "') AND (SC5.C5_SERIE <> 'TRC')"
	
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cQuery), 'ROM' )
	
	_nRegua := ROM->REC_NO
	
	ROM->( dbCloseArea() )
	
	_cQuery := 'SELECT    SC5.C5_NOTA, SC5.C5_DESPACH, SC5.C5_CLIENTE, SC5.C5_LOJACLI, SC5.C5_TRANSP, SC5.C5_CANHOTO, SA1.A1_NREDUZ, '
	_cQuery += "          'Teste' AS OBS, SF2.F2_EMISSAO, SC5.C5_DESPACH "
	_cQuery += 'FROM      SC5010 SC5 INNER JOIN '
	_cQuery += '          SA1010 SA1 ON SC5.C5_CLIENTE = SA1.A1_COD AND SC5.C5_LOJACLI = SA1.A1_LOJA INNER JOIN'
	_cQuery += '          SF2010 SF2 ON SC5.C5_NOTA = SF2.F2_DOC '
	_cQuery += "WHERE     (SC5.C5_NOTA <> '      ') AND (SC5.D_E_L_E_T_ <> '*') AND (SF2.F2_EMISSAO >= '" + DtoS( MV_PAR01 ) + "') AND"
	_cQuery += "          (SF2.F2_EMISSAO <= '" + DtoS( MV_PAR02 ) + "') AND (SC5.C5_SERIE <> 'TRC')"
	_cQuery += 'ORDER BY SF2.F2_EMISSAO,  SC5.C5_NOTA'
	
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cQuery), 'ROM' )
	
	RptStatus({|| RptDetail() })
	
Return

Static Function RptDetail

	SetRegua( _nRegua )
	
	cTitulo :="RELATÓRIO DE ROMANEIOS"
	Cabec1  := ;
	' DESPACHO   NOTA FISCAL CLIENTE                  CANHOTO   LOCAL ENTREGA'
//	'99/99/9999  999.999 XXX XXXXXXXXXXXXXXXXXXXXX   99/99/9999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
//	C5_DESPACH C5_NOTA C5_SERIE A1_NREDUZ           C5_CANHOTO  C5_MENNOTA
	cabec2  :=""
	
	M_Pag   := 1 
	@ 0,0 PSAY Chr( 15 )
	_nLin   := Cabec(ctitulo,cabec1,cabec2,nomeprog,tamanho,1)
	_nLin   += 2
	_nSaldo := 0
	_nEntr  := 0
	_nSaida := 0

	_dSaldo := 0
	_dEntr  := 0
	_dSaida := 0
	
	_dDia := ROM->F2_EMISSAO

	While ! Eof()
	
	   If _dDia != ROM->F2_EMISSAO
	
	      @ _nLin, 62 PSAY "----------"
	      @ _nLin, 73 PSAY "----------"
	      @ _nLin, 84 PSAY "----------"
	      _nLin ++
	
	      @ _nLin, 62 PSAY _dEntr  Picture "@E 999,999.99"
	      @ _nLin, 73 PSAY _dSaida Picture "@E 999,999.99"
	      @ _nLin, 84 PSAY _dSaldo Picture "@E) 999,999.99"
	      _nLin += 2
      
	      _nEntr  += _dEntr
	      _nSaida += _dSaida
	      _nSaldo += _dSaldo
	
	      _dEntr  := Query->F1_VALBRUT
	      _dSaida := Query->F2_VALMERC
	      _dSaldo := Query->Saldo
	      _dDia   := Query->F2_EMISSAO
	
	   Else
	
	      _dEntr  += Query->F1_VALBRUT
	      _dSaida += Query->F2_VALMERC
	      _dSaldo += Query->Saldo
	
	   End
	
      PrtLine()
	   
	   If _nLin > 59
	
	      _nLin := Cabec(ctitulo,cabec1,cabec2,nomeprog,tamanho,1)
	      _nLin += 2
	
	   End

	   _cEmissao := Substr( Query->F2_EMISSAO, 7, 2 )
	   _cEmissao += '/'
	   _cEmissao += Substr( Query->F2_EMISSAO, 5, 2 )
	
	   @ _nLin,  0 PSAY Query->F2_DOC Picture "@R 999.999"
	   @ _nLin, 10 PSAY _cEmissao
	   @ _nLin, 20 PSAY Query->F2_CLIENTE Picture "999999"
	   @ _nLin, 29 PSAY Query->F2_LOJA Picture "99"
	   @ _nLin, 33 PSAY Query->A1_NREDUZ
	   @ _nLin, 62 PSAY Query->F1_VALBRUT Picture "@E 999,999.99"
	   @ _nLin, 73 PSAY Query->F2_VALMERC Picture "@E 999,999.99"

	   If Query->EXCLUIDA != '*'
	      @ _nLin, 84 PSAY Query->SALDO Picture "@E) 999,999.99"
	   Else
	      @ _nLin, 84 PSAY ' CANCELADA *'
	   End

	   _cVend := rTrim( Query->A3_NREDUZ )
	
	   If Query->EXCLUIDA != ' '
	
	      _cVend += ' * CANCELADA'
	      _dEntr  -= Query->F1_VALBRUT
	      _dSaida -= Query->F2_VALMERC
	      _dSaldo -= Query->Saldo
	
	   End

	   @ _nLin, 98 PSAY _cVend
	
	   _nLin ++
	   
	   Query->( dbSkip() )
	   IncRegua()

	End

	_nEntr  += _dEntr
	_nSaida += _dSaida
	_nSaldo += _dSaldo
	
	@ _nLin, 62 PSAY "----------"
	@ _nLin, 73 PSAY "----------"
	@ _nLin, 84 PSAY "----------"
	_nLin ++
	
	@ _nLin, 62 PSAY _dEntr  Picture "@E 999,999.99"
	@ _nLin, 73 PSAY _dSaida Picture "@E 999,999.99"
	@ _nLin, 84 PSAY _dSaldo Picture "@E) 999,999.99"
	_nLin ++
	
	@ _nLin, 62 PSAY "----------"
	@ _nLin, 73 PSAY "----------"
	@ _nLin, 84 PSAY "----------"
	_nLin ++
	
	@ _nLin, 62 PSAY _nEntr  Picture "@E 999,999.99"
	@ _nLin, 73 PSAY _nSaida Picture "@E 999,999.99"
	@ _nLin, 84 PSAY _nSaldo Picture "@E) 999,999.99"
	
                                                   
	__Eject()
	MS_Flush()
	
	Set device to screen
	Set Printer To
	
	If aReturn[ 5 ] == 1
	   dbCommitAll()
	   OurSpool( wnrel )
	Endif
	
	Query->( dbCloseArea() )

Return()           

