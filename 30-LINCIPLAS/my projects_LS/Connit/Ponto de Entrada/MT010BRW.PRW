/*
5415 5502 2699 1711
518
02/2018
*/

#INCLUDE "PROTHEUS.CH"

/*
+============================================================+
|Programa: MT010BRW |Autor: Antonio Carlos |Data: 06/11/08   |
+============================================================+
|Descricao: Ponto de Entrada utilizado para adicionar rotinas|
|no menu de opcoes.                                          |
+============================================================+
|Uso: Laselva                                                |
+============================================================+
*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function MT010BRW()
////////////////////////

Local aArea	:= GetArea()
Local lPyme		:= Iif(Type("__lPyme") <> "U",__lPyme,.F.)

xRotina := aclone(aRotina)

aRotina := {}

aadd(aRotina,aclone(xRotina[1]))
aadd(aRotina,aclone(xRotina[2]))
aadd(aRotina,aclone(xRotina[3]))
aadd(aRotina,aclone(xRotina[4]))
aadd(aRotina,aclone(xRotina[5]))
//aadd(aRotina,aclone(xRotina[6]))
aadd(aRotina,aclone(xRotina[7]))
Aadd(aRotina,{"Alteração Laselva"	,"AxAltera('SB1',SB1->(Recno()), 4,,{" +GetMv("LS_ALTPROD")+ "},,,,,,,,,,.T.,,,,,)", 0 , 4})
Aadd(aRotina,{"Consulta Laselva"	,"U_COMP001(SB1->B1_COD)", 0 , 1})
Aadd(aRotina,{"Manutencao Tes"		,"U_FISP002(SB1->B1_COD)", 0 , 1})
Aadd(aRotina,{"Zera Repartes"		,"U_TELREPARTE()", 0 , 1})

// Após ativar os Paineis online, a variavel acBrowse não esta sendo preenchida corretamente
// Tratativa de correção
// Thiago Queiroz - 27/11/13
IF TYPE("acbrowse") != "U"
	
	If upper(substr(acbrowse,11,1)) == 'X'
		Aadd(aRotina,{"Gera Reparte"		,"U_CADP005(SB1->B1_COD,SB1->B1_DESC,SB1->B1_LOCPAD,SB1->B1_ENCALHE,SB1->B1_GRUPO,SB1->B1_PRV1,SB1->B1_PRV2,SB1->B1_EDICAO,SB1->B1_MSBLQL, SB1->B1_ORIGEM)", 0 , 1})
	EndIf
	
	If upper(substr(acbrowse,12,1)) == 'X'
		Aadd(aRotina,{"Reparte p/ Arquivo"	,"U_SB1LIBERA()", 0 , 1})
	EndIf
	Aadd(aRotina,{"Consulta KARDEX"		,"U_LSKARDEX(SB1->B1_COD)", 0 , 1})
	
	If IntDl() .and. upper(substr(acbrowse,13,1)) == 'X'
		AAdd( aRotina, {  "Assistente WMS" ,"A010Wizard", 0 , 3}) // "Assistente WMS"
	EndIf
	
	If !lPyme .and. upper(substr(acbrowse,14,1)) == 'X'
		AAdd( aRotina, { "Conhecimento", "MsDocument", 0, 4 } )  //"Conhecimento"
	EndIf
	
ENDIF
Aadd(aRotina,{"Romaneios"			,"U_LS177Rom"					,0,1 })

RestArea(aArea)

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LSKARDEX()
////////////////////////
cPerg := 'MTC030    '
Private lCusUnif  := Iif(FindFunction("A330CusFil"),A330CusFil(),GetNewPar("MV_CUSFIL",.F.))

If Pergunte(cPerg,.t.)
	_cFilAnt := cFIlAnt
	cFilAnt := upper(MV_PAR09)
	MC030Con()
	cFilAnt := _cFIlAnt
EndIf
cPerg := 'MTA010    '
Pergunte(cPerg,.f.)
DbSelectArea('SB1')
Return()


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ALTERA INFORMAÇÕES SOBRE A GERAÇÃO DE DIRF PARA CADA IMPOSTO NA ABA DE IMPOSTO DA NF
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function MT103DRF()
////////////////////////
Local nCombo  := PARAMIXB[1]
Local cCodRet := PARAMIXB[2]
Local aImpRet := {}

nCombo  := 1
cCodRet := iif(SA2->A2_TIPO == 'J',"1708",'0588')
aadd(aImpRet,{"IRR",nCombo,cCodRet})

nCombo  := 2
cCodRet := "1708"
aadd(aImpRet,{"ISS",nCombo,cCodRet})

nCombo  := 1
cCodRet := "2008"
aadd(aImpRet,{"PIS",nCombo,cCodRet})

nCombo  := 1
cCodRet := "2010"
aadd(aImpRet,{"COF",nCombo,cCodRet})

nCombo  := 2
cCodRet := "2050"
aadd(aImpRet,{"CSL",nCombo,cCodRet})

Return(aImpRet)


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ALTERA INFORMAÇÕES SOBRE A GERAÇÃO DE DIRF PARA CADA IMPOSTO NA ABA DE IMPOSTO DA NF
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function __ MT100PIS()
////////////////////////
_nRet := PARAMIXB[1]

Return(_nRet)

User Function MT100GE2()

_aColsSE2 := PARAMIXB

Return()
