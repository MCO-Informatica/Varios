#include "rwmake.ch"
#include "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡"o    ³ MAFAR050 ³ Autor ³ MICROSIGA S/A         ³ Data ³ 04/10/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡"o ³ Relat¢rio Mapa Resumo (Reducao Z)                          ³±±
±±³Autera‡"o ³ Adequacao as normas legais do Estado de SP                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico - Etna                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MAFAR050()

SetPrvt("NPAGINA,CBTXT,CBCONT,CSTRING,NORDEM,TAMANHO,TITULO,CDESC1,CDESC2,CDESC3,ARETURN,NOMEPROG,CPERG,NLASTKEY,WNREL,_dDATASFI,ZOGFIL,MAXLIN,NLIN,NCOL,_cNOME,_cFUNCAO,TMOVTODIA,TCANCDESC,TVCONTABIL,TISENTAS,TBCALCULO,TBCALC1,TBCALC2,TBCALC3,TBCALC4,TIMPDEBT,TOUTROSR,TISUBTRIB,TGTFINAL,TGTINI")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Ambientais                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nPagina  			:= 1
CbTxt    			:= ""
CbCont   			:= ""
cString  			:= "SFI"
nOrdem   			:= 0
tamanho  			:= "P"
titulo   			:= "MAPA RESUMO DE CAIXA"
cDesc1   			:= "Este programa ira emitir o Relat¢rio Mapa Resumo de Caixa,"
cDesc2   			:= "onde serao impressos os valores das Reducoes Z de cada ECF,"
cDesc3   			:= "da data especificada no parametro."
aReturn  			:= { "zebrado",1,"administra€ao",2,2,1,"",1}
nomeprog 			:= "mafar050"
nLastKey 			:= 0
wnrel    			:= "Mapa Resumo de Caixa"
cPerg    			:= "FAR050"
_aBaseIcms 			:= SFI->(DbStruct())
_cQuery 			:= " "
_aCpoBas 			:= { }
_aCpoOk	 			:= { }
_aCpoNao 			:= { }
aArrayFI			:= { }
_nTReg   			:= 0
NX					:= 0
nReg				:= 1
_cStrBas 			:= ""
_cStrCte 			:= ""
_cCampo	 			:= ""
_cBase1  			:= ""
_cBase2  			:= ""
_cBase3  			:= ""
_cBase4  			:= ""
_cBas1	 			:= ""
_cBas2	 			:= ""
_cBas3	 			:= ""
_cBas4	 			:= ""

//Variaveis Especificas
ZOGFIL     			:= Substr(cNumEmp,3,2)
TMOVTODIA  			:= 0
TCANCDESC  			:= 0
TVCONTABIL 			:= 0
TISENTAS   			:= 0
TBCALCULO  			:= 0
TIMPDEBT   			:= 0
TOUTROSR   			:= 0
TGTFINAL   			:= 0
TGTINI     			:= 0
TISUBTRIB  			:= 0
TBCALC1    			:= 0
TBCALC2    			:= 0
TBCALC3    			:= 0
TBCALC4    			:= 0
Private _nRetReg 	:= 0
_cNOME     			:= Alltrim(GetMV("TL_ZMAPRSP")) + Space(50)
_cFUNCAO   			:= Alltrim(GetMV("TL_ZMAPFNC")) + Space(50)

PutSX1(cPerg,"01","Data De                   ?","","","mv_ch1" ,"D",08,0,0,"G","",""    ,"","","MV_PAR01"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","",{""},{},{})
PutSX1(cPerg,"02","Data Ate                  ?","","","mv_ch2" ,"D",08,0,0,"G","",""    ,"","","MV_PAR02"   ,"","","",""   ,"" ,"","",""          ,"","","","","","","",{""},{},{})
Pergunte(cPerg,.T.)

_dDATASFI 			:= mv_par01
_dDATASFIM 			:= mv_par02

/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtra as colunas com nome FI_BAS para uso na query.		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If Len(_aBaseIcms) > 0
For _cI := 1 To Len(_aBaseIcms)
If Subs(_aBaseIcms[_cI][1],1,6) == "FI_BAS"
Aadd(_aCpoBas, _aBaseIcms[_cI][1])
EndIf
Next
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta string para uso na query.								 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If Len(_aCpoBas) > 0
For _cCt := 1 To Len(_aCpoBas)
If  _cCt == Len(_aCpoBas)
_cStrBas += _aCpoBas[_cCt]
_cStrCte +=_aCpoBas[_cCt]+" > 0"
Else
_cStrBas +=_aCpoBas[_cCt]+", "
_cStrCte +=_aCpoBas[_cCt]+" > 0 OR "
EndIf
Next
EndIf
*/

If Select("TRB")  > 0
	TRB->(DbCloseArea())
EndIf

//_cQuery := "SELECT "+_cStrBas+",FI_DTMOVTO"
_cQuery := " SELECT FI_DTMOVTO, FI_NUMERO, FI_PDV, FI_SERPDV, FI_COO, 'ECF', FI_NUMFIM, FI_VALCON+FI_CANCEL AS MOVDIA, FI_CANCEL, FI_DESC, FI_ISENTO "
_cQuery += " , FI_VALCON, FI_SUBTRIB, FI_NTRIB, FI_BAS7, FI_BAS12, FI_BAS18, FI_BAS25, FI_IMPDEBT, FI_OUTROSR, FI_NUMREDZ, FI_GTFINAL, FI_GTINI "
_cQuery += " FROM "+RetSqlName("SFI")+ " (NOLOCK) "
_cQuery += " WHERE D_E_L_E_T_ 	= ''
_cQuery += " AND FI_FILIAL 		= '"+xFilial("SFI")+"' "
//_cQuery += " AND ("+_cStrCte+")"
_cQuery += " AND (FI_BAS7 > 0 OR FI_BAS12 > 0 OR FI_BAS18 > 0 OR FI_BAS25 > 0 OR FI_BAS001 > 0) "
//_cQuery += " AND FI_DTMOVTO 	= '"+Dtos(_dDATASFI)+"'"
_cQuery += " AND FI_DTMOVTO 	BETWEEN '"+Dtos(_dDATASFI)+"' AND '"+Dtos(_dDATASFIM)+"'"
//_cQuery += " AND FI_DTMOVTO 	BETWEEN '"+DTOS(_dDATASFI-1)+"' AND '"+Dtos(_dDATASFIM)+"'"
_cQuery := ChangeQuery(_cQuery)

MsAguarde( { || dbUseArea(.T.,'TOPCONN',TcGenQry(,,_cQuery),"TRB",.F.,.T.)},"Aguarde... Consultando o Banco de Dados...")
TRB->(dbEval({|| _nRetReg++ }))
TRB->(DbGotop())

dDataMovto	:= TRB->FI_DTMOVTO

WHILE !EOF()
	
	Aadd(aArrayFI,{	TRB->FI_DTMOVTO					,;
	TRB->FI_NUMERO					,;
	TRB->FI_PDV    					,;
	TRB->FI_SERPDV					,;
	TRB->FI_COO						,;
	"ECF"							,;
	TRB->FI_NUMFIM					,;
	TRB->MOVDIA						,;
	TRB->FI_CANCEL					,;
	TRB->FI_DESC					,;
	TRB->FI_ISENTO					,;
	TRB->FI_VALCON					,;
	TRB->FI_SUBTRIB					,;
	TRB->FI_NTRIB					,;
	TRB->FI_BAS7					,;
	TRB->FI_BAS12					,;
	TRB->FI_BAS18					,;
	TRB->FI_BAS25					,;
	TRB->FI_IMPDEBT					,;
	TRB->FI_OUTROSR					,;
	TRB->FI_NUMREDZ					,;
	TRB->FI_GTFINAL					,;
	TRB->FI_GTINI					})
	TRB->(DbSkip())
ENDDO



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtra as colunas com valores extraidos query para impressao ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
While ! TRB->(Eof())
For _n := 1 To Len(_aCpoBas)
_cCampo := _aCpoBas[_n]
If TRB->&_cCampo > 0
If aScan(_aCpoOk,_cCampo) == 0
Aadd(_aCpoOk, _aCpoBas[_n])
EndIf
EndIf
Next
TRB->(DbSkip())
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtra as colunas sem valores extraidos query para impressao ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

For _n := 1 To Len(_aCpoBas)
_cCampo := _aCpoBas[_n]
If aScan(_aCpoOk,_cCampo) == 0
Aadd(_aCpoNao, _aCpoBas[_n])
EndIf
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta as variaveis para soma nos valores das bases de icms   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If Len(_aCpoOk) == 4
_cBase1	:= _aCpoOk[1]
_cBase2	:= _aCpoOk[2]
_cBase3	:= _aCpoOk[3]
_cBase4	:= _aCpoOk[4]
ElseIf Len(_aCpoOk) == 3
_cBase1	:= _aCpoOk[1]
_cBase2	:= _aCpoOk[2]
_cBase3	:= _aCpoOk[3]
_cBase4	:= _aCpoNao[1]
ElseIf Len(_aCpoOk) == 2
_cBase1	:= _aCpoOk[1]
_cBase2	:= _aCpoOk[2]
_cBase3	:= _aCpoNao[1]
_cBase4	:= _aCpoNao[2]
ElseIf Len(_aCpoOk) == 1
_cBase1	:= _aCpoOk[1]
_cBase2	:= _aCpoNao[1]
_cBase3	:= _aCpoNao[2]
_cBase4	:= _aCpoNao[3]
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pega o nome para exibicao no relatorio conforme base impressa.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If Val(Substr(_cBase1,7,3)) > 100
_cBas1	:= Alltrim(Str(Val(Substr(_cBase1,7,3)) /100))
Else
_cBas1	:= Alltrim(Str(Val(Substr(_cBase1,7,3))))
EndIf

If Val(Substr(_cBase2,7,3)) > 100
_cBas2	:= Alltrim(Str(Val(Substr(_cBase2,7,3)) /100))
Else
_cBas2	:= Alltrim(Str(Val(Substr(_cBase2,7,3))))
EndIf

If Val(Substr(_cBase3,7,3)) > 100
_cBas3	:= Alltrim(Str(Val(Substr(_cBase3,7,3)) /100))
Else
_cBas3	:= Alltrim(Str(Val(Substr(_cBase3,7,3))))
EndIf

If Val(Substr(_cBase4,7,3)) > 100
_cBas4	:= Alltrim(Str(Val(Substr(_cBase4,7,3)) /100))
Else
_cBas4	:= Alltrim(Str(Val(Substr(_cBase4,7,3))))
EndIf
*/

//-Cria ou le parametro, com a quantidade adicional de linhas a ser usado no impresso
dbselectarea("SX6")
dbsetorder(1) // Filial + Parametro
dBseek(Space(2)+"TL_ZMAPLIN")
If Found()
	MAXLIN 	:= VAL(Alltrim(SX6->X6_CONTEUD))
Else
	Alert("Sera criado o parametro TL_ZMAPLIN com a quatidade de linhas a serem impressas no Mapa Resumo. Se necessario, solicite ao administrador do sistema a configuracao do sistema, de acordo com a impressora que sera utilizada.")
	RecLock("SX6",.T.)
	Replace SX6->X6_FIL     With "  "
	Replace SX6->X6_VAR     With "TL_ZMAPLIN"
	Replace SX6->X6_TIPO    With "C"
	Replace SX6->X6_DESCRIC With "Qtd.Max.de linhas impressas no Mapa Resumo"
	Replace SX6->X6_DSCSPA  With "Qtd.Max.de linhas impressas no Mapa Resumo"
	Replace SX6->X6_DSCENG  With "Qtd.Max.de linhas impressas no Mapa Resumo"
	Replace SX6->X6_CONTEUD With "50"
	Replace SX6->X6_PROPRI  With "U"
	SX6->(msUnLock())
	SX6->(dbCommit())
	MAXLIN := 50
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,TAMANHO)

If nLastKey == 27
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica Posicao do Formulario na Impressora                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetDefault(aReturn,cString)
If nLastKey == 27
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio do Processamento                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus({|| RptDetail()})

Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//***************************************************************************************************************************//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Static Function RptDetail()

_lIni	:= .T.
lFIRST	:= .T.

/*
Private oFtSublin	:= TFont():New("Arial"      ,09,09,,.F.,,,,.T.,.F.)
Private oFtNegrito 	:= TFont():New("Arial"      ,09,09,,.T.,,,,.T.,.F.)
Private oFtNormal	:= TFont():New("Arial"      ,09,09,,.F.,,,,.T.,.F.)
Private oFtMedio 	:= TFont():New("Arial"      ,09,11,,.T.,,,,.T.,.F.)
Private oFtGrande	:= TFont():New("Arial"      ,09,12,,.T.,,,,.T.,.F.)
Private oFtMedia 	:= TFont():New("Arial"      ,09,10,,.F.,,,,.T.,.F.)
Private oFtMediaNeg	:= TFont():New("Arial"      ,09,10,,.T.,,,,.T.,.F.)
Private oFtItem1 	:= TFont():New("Courier New",09,10,,.T.,,,,.T.,.F.)
Private oFtItem2 	:= TFont():New("Courier New",09,09,,.T.,,,,.T.,.F.)

oPrn:=TMSPrinter():New()
oPrn:SetPortRait()
oPrn:Setup()
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do cabecalho do relatorio. . .                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Salto de Pagina. Neste caso o formulario tem 55 linhas...
dbSelectArea("TRB")
DbGotop()
While !Eof()
	
	// SetPrc(0,0)
	NLIN 				:= 01   //-Valor da Linha Inicial
	NCOL 				:= 03   //-Valor da Coluna Inicial
	
	IF lFIRST == .T.
		dDataMovto 		:= ""
	ENDIF
	
	IF TRB->FI_DTMOVTO == dDataMovto
		_lIni			:= .F.
	ELSE
		_lIni			:= .T.
		dDataMovto		:= TRB->FI_DTMOVTO
	ENDIF
	
	IF _lIni
		Set Date Format to "dd/mm/yyyy"
		@ nLin++,nCol PSay ""
		@ nLin++,nCol PSay "\----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------/"
		//@ nLin++,nCol PSay "|                       M A P A    R E S U M O    E C F                  |           Numero:   " + SFI->FI_NUMERO + "          |      Data: " + DtoC(SFI->FI_DTMOVTO) + "                                                                                 |"
		@ nLin++,nCol PSay "|                       M A P A    R E S U M O    E C F                  |           Numero:   " + TRB->FI_NUMERO + "          |      Data: " + substring(TRB->FI_DTMOVTO,7,2)+"/"+substring(TRB->FI_DTMOVTO,5,2)+"/"+substring(TRB->FI_DTMOVTO,1,4) + "                                                                                 |"
		@ nLin++,nCol PSay "|------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------|"
		@ nLin++,nCol PSay "|              Nome/Razao Social: " + SM0->M0_NOME +      "                        |                       Inscricao Estadual:       " + SM0->M0_INSC + "                                                                              |"
		@ nLin++,nCol PSay "|------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------|
		@ nLin++,nCol PSay "|Endereco: " + SM0->M0_ENDENT +      "  + Municipio: " + SM0->M0_CIDENT +  " UF: " + SM0->M0_ESTENT + "    | CNPJ:    " + Transform(SM0->M0_CGC, "@R 99.999.999/9999-99") + "                             |"
		@ nLin++,nCol PSay "|----+--------------------+---------+--------------+-----------+---------+-----------+-----------+---------+-----------+-----------+-----------+-----------+-----------+------------+----------------------------------|"
		@ nLin++,nCol PSay "|Num |Numero de Serie do  | Cont.Ord| Docto.Fiscal | Movimento |Cancel./ |   Valor   |  Subst.   |Isenta ou|  Base de  |  Base de  |  Base de  |  Base de  |  Imposto  |  Outros    |Cont. |GT.Final     |GT.Inicio    |"
		@ nLin++,nCol Psay "|ECF | Equipamento        | Operacao|-----+--------|  do Dia   |Desconto | Contabil  |Tributária |Nao Trib.|  Calculo  |  Calculo  |  Calculo  |  Calculo  |  Debitado |Recebimentos|Red.  |             |             |"
		//@ nLin++,nCol Psay "|    |                    | Nr.Final|Serie|Nr.Final|   (R$)    |  (R$)   |   (R$)    |   (R$)    |   (R$)  |  "+_cBas1+"% (R$) |  "+_cBas2+"% (R$)  |  "+_cBas3+"% (R$) |  "+_cBas4+"% (R$) |    (R%)   |    (R$)    |  -Z- |             |             |"
		@ nLin++,nCol Psay "|    |                    | Nr.Final|Serie|Nr.Final|   (R$)    |  (R$)   |   (R$)    |   (R$)    |   (R$)  |  7 % (R$) |  12% (R$) |  18% (R$) |  25% (R$) |    (R%)   |    (R$)    |  -Z- |             |             |"
		@ nLin++,nCol Psay "|----|--------------------|---------|-----|--------|-----------|---------|-----------|-----------|---------|-----------|-----------|-----------|-----------|-----------|------------|------|-------------|-------------|"
		
		If _nRetReg == 0
			@ nLin,nCol Psay "|" +Substr(TRB->FI_PDV,1,4) + "|" + TRB->FI_SERPDV + "| " + TRB->FI_COO + "  | ECF | " + Alltrim(TRB->FI_NUMFIM) + " |" + Transform((TRB->FI_GTFINAL-TRB->FI_GTINI), "9999,999.99") + "|" + Transform(0.00, "999999.99") + "|" + Transform(0.00, "9999,999.99") + "|" + Transform(0.00, "9999,999.99") + "|" +  Transform((0.00), "999999.99") + "|" + Transform( 0.00, "9999,999.99") + "|"  + Transform( 0.00, "9999,999.99") + "|" + Transform( 0.00, "9999,999.99") + "|" + Transform( 0.00, "9999,999.99") + "|" + Transform(0.00, "9999,999.99") + "|" + Transform(0.00, "99999,999.99") + "| " + TRB->FI_NUMREDZ + "|"+ "|" + Transform(0.00, "9999,999.99") + "|" + Transform(0.00, "99999,999.99") + " |"
			nLin++
		Else
			FOR NX := 1 TO LEN(aArrayFI)
				//IF aArrayFI[NX][1] == TRB->FI_DTMOVTO .AND. _lIni == .T.
				IF aArrayFI[NX][1] == dDataMovto //.AND. _lIni == .T.
					// PREENCHE A LINHA DO RELATORIO COM AS INFORMAÇÕES A BAIXO
					//-    Nro.Ord.Equip                    Cont.Ord.Final         Serie       Nr.Final                             Movimento do Dia                                                       Cancel / Desconto                                                 Valor Contabil               Subst. Tributária                                   Isento / Nao Tributado                                                                                                                        Base de Calculo                             Imposto Debitado                                                                        Imposto Debitado                                    Outros Recebimentos                       Nro. Red. Z
					@ nLin,nCol Psay "|" 															+ ;
					Substr(aArrayFI[NX][3],1,4) 										+ "|" 		+ ;
					aArrayFI[NX][4] 													+ "| " 		+ ;
					aArrayFI[NX][5] 																+ ;
					"  | ECF | " 																	+ ;
					Alltrim(aArrayFI[NX][7]) 											+ " |" 		+ ;
					Transform((aArrayFI[NX][22]-aArrayFI[NX][23]), "9999,999.99") 		+ "|" 		+ ;
					Transform((aArrayFI[NX][9]+aArrayFI[NX][10]), "999999.99") 			+ "|" 		+ ;
					Transform(aArrayFI[NX][12], "9999,999.99") 							+ "|" 		+ ;
					Transform(aArrayFI[NX][13], "9999,999.99") 							+ "|" 		+ ;
					Transform((aArrayFI[NX][11]+aArrayFI[NX][14]), "999999.99") 		+ "|" 		+ ;
					Transform(aArrayFI[NX][15], "9999,999.99") 							+ "|"  		+ ;
					Transform(aArrayFI[NX][16], "9999,999.99") 							+ "|" 		+ ;
					Transform(aArrayFI[NX][17], "9999,999.99") 							+ "|" 		+ ;
					Transform(aArrayFI[NX][18], "9999,999.99") 							+ "|" 		+ ;
					Transform(aArrayFI[NX][19], "9999,999.99") 							+ "|" 		+ ;
					Transform(aArrayFI[NX][20], "99999,999.99") 						+ "| " 		+ ;
					aArrayFI[NX][21] 													+ "|"		+ ;
					Transform(aArrayFI[NX][22], "9999,999.99") 							+ "  |" 	+ ;
					Transform(aArrayFI[NX][23], "99999,999.99") 						+ " |"
					// TERMINA DE PREENCHER A LINHA E SOMA OS TOTALIZADORES
					
					TMOVTODIA  := TMOVTODIA  +  (aArrayFI[NX][22] - aArrayFI[NX][23])
					TCANCDESC  := TCANCDESC  +  (aArrayFI[NX][9]  + aArrayFI[NX][10])
					TVCONTABIL := TVCONTABIL +  aArrayFI[NX][12]
					TISUBTRIB  := TISUBTRIB  +  aArrayFI[NX][13]
					TISENTAS   := TISENTAS   +  (aArrayFI[NX][11]  + aArrayFI[NX][14])
					TBCALC1    := TBCALC1    +  aArrayFI[NX][15]
					TBCALC2    := TBCALC2    +  aArrayFI[NX][16]
					TBCALC3    := TBCALC3    +  aArrayFI[NX][17]
					TBCALC4    := TBCALC4    +  aArrayFI[NX][18]
					TBCALCULO  := TBCALCULO  +  (aArrayFI[NX][15] + aArrayFI[NX][16] + aArrayFI[NX][17] + aArrayFI[NX][18])
					TIMPDEBT   := TIMPDEBT   +  aArrayFI[NX][19]
					TOUTROSR   := TOUTROSR   +  aArrayFI[NX][20]
					TGTFINAL   := TGTFINAL   +  aArrayFI[NX][22]
					TGTINI     := TGTINI     +  aArrayFI[NX][23]
					nLin++
				ENDIF
			NEXT NX
			
		EndIf
		
		If nLin < MAXLIN
			While nLin < MAXLIN
				@ nLin,nCol Psay "|    |                    |         |     |        |           |         |           |           |         |           |           |           |           |           |            |      |             |             |"
				nLin++
			EndDo
		Endif
		//                     --------------------------------------T  O  T  A  L  I  Z  A  C   A   O     D A S     C  O  L  U  N  A  S--------------
		//-                         Variaveis Totalizadoras   |TMOVTODIA   TCANCDESC  TVCONTABIL TISENTAS  TBCALCULO   TIMPDEBT    TOUTROSR
		//-                    |------------------------------|-----------|---------|-----------|---------|-----------|-----------|------------|-----|"
		//-                    |    Templates ->              |9999,999.99|999999.99|9999,999.99|999999.99|9999,999.99|9999,999.99|99999,999.99|Red.Z|"
		
		@ nLin++,nCol Psay "|--------------------------------------------------|-----------|---------|-----------|-----------|---------|-----------|-----------|-----------|-----------|-----------|------------|------|-------------|-------------|"
		@ nLin++,nCol Psay "|     T O T A I S   D O   D I A                    |" + Transform(TMOVTODIA,"9999,999.99") + "|" + Transform(TCANCDESC,"999999.99") + "|" + Transform(TVCONTABIL,"9999,999.99") + "|"+ Transform(TISUBTRIB,"9999,999.99") + "|" +Transform(TISENTAS,"999999.99") + "|" + Transform(TBCALC1,"9999,999.99") + "|" + Transform(TBCALC2,"9999,999.99") + "|" + Transform(TBCALC3,"9999,999.99") + "|" + Transform(TBCALC4,"9999,999.99") + "|" + Transform(TIMPDEBT,"9999,999.99") +"|" + Transform(TOUTROSR,"99999,999.99") + "|  -X- |" + Transform(TGTFINAL,"99,999,999.99") +"|" + Transform(TGTINI,"99,9999,999.99")+"|"
		@ nLin++,nCol Psay "|--------------------------------------------------+-----------|---------|-----------|-----------|---------|-----------|-----------|-----------|-----------|-----------|------------|------|-------------|-------------|""
		@ nLin++,nCol Psay "|__________________________Observacoes_________________________________________________________________________________|____________________Responsavel_pelo_Estabelecimento___________________________________________|"
		@ nLin++,nCol Psay "|                                                                            | Nome: " + Substr(_cNome,1,45 ) + "                                                                                     |"
		@ nLin++,nCol Psay "|                                                                            |-----------------------------------------------------------------------------------------------------------------------------------------|"
		@ nLin++,nCol Psay "|                                                                            | Funcao: " + Substr(_cFuncao,1,15) +"    | Ass.:                                                                                                      |"
		@ nLin++,nCol Psay "/----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\"
		Set Date Format to "dd/mm/yy"
		
		TMOVTODIA  	:= 0
		TCANCDESC  	:= 0
		TVCONTABIL 	:= 0
		TISUBTRIB  	:= 0
		TISENTAS   	:= 0
		TBCALC1    	:= 0
		TBCALC2    	:= 0
		TBCALC3    	:= 0
		TBCALC4    	:= 0
		TBCALCULO  	:= 0
		TIMPDEBT   	:= 0
		TOUTROSR   	:= 0
		TGTFINAL   	:= 0
		TGTINI     	:= 0
		nLin 		:= 01
		lFIRST		:= .F.
		//nTotREG		:= SELECT("TRB")
		//IF NREG < NTOTREG
		//	nReg++
		//ENDIF
		
	ENDIF
	dbSelectArea("TRB")
	DbSkip()
	//DBGoTo(NREG)
	//LOOP
EndDo


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apresenta relatorio na tela                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//oPrn:Preview()

Set Device To Screen

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnRel)
EndIf

MS_FLUSH()
Return

Return NIL
