#Include "FiveWin.ch"
#Include "TbiConn.ch"
#Include "Ap5Mail.ch"
#Include "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "Font.ch"
#INCLUDE "Colors.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �Mod3Buzz	  � Autor � Silvio Cazela       � Data � 15/10/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Enchoice e GetDados                                         ���
�������������������������������������������������������������������������Ĵ��
���Parametros�01-cTitulo------Titulo da Janela                            ���
���          �02-cAlias1------Alias da enchoice                           ���
���          �03-cAlias2------Alias da getDados                           ���
���          �04-aMyEncho-----Array com campos da enchoice                ���
���          �05-cLinOk-------Funcao de validacao da linha                ���
���          �06-cTudoOk------Funcao de validacao na confirmacao          ���
���          �07-nOpcE--------nOpc da enchoice                            ���
���          �08-nOpcG--------nOpc da getdados                            ���
���          �09-cFieldOk-----Funcao de validaca dos campos da getdados   ���
���          �10-lVirtual-----Permite visualizar campos virtuais da enchoi���
���          �11-nLinhas------Numero maximo de linhas da getdados         ���
���          �12-aAltEnchoice-Array com campos alteraveis da enchoice     ���
���          �13-nFreeze------Congelamento das colunas                    ���
���          �14-aRodape------Array com texto e conteudo do rodape (Max.3)���
���          �       Ex.AADD(aRodape,{"Total de Itens",0})                ���
���          �15-aButtons-----Array com botoes a serem incluidos na bar   ���
���          �       Ex.AADD(aButtons, {"EDIT",{||Valid()},"Descricao"})  ���
���          �16-cCpoItem-----Campo para Controle de Numeracao de Itens   ���
���          �       Ex.'+PAF_ITEM'                                       ���
���          �17-aObj    -----Dimensao dos Objetos                        ���
���          �       Ex.{40,40,10}                                        ���
�������������������������������������������������������������������������Ĵ��
���Mudancas  �a)Rotina de AutoDimensiona Conforme Resolucao de Video Usada���
���          �b)Inclusao de Rodape (Maximo de 3 Elementos)                ���
���          �c)Inclusao de Botoes na EnchoiceBar                         ���
�������������������������������������������������������������������������Ĵ��
���Dicas     �1)Na utilizacao de rodapes, sera preciso atualizar (refresh)���
���          �  nos valores, ou seja, na rotina de validacao de linha por ���
���          �  exemplo, devera ser incluido o seguinte.                  ���
���          �  oRod1:refresh(),oRod2:refresh(),oRod3:refresh()->depende  ���
���          �  do numero de elementos passado como rodape.               ���
���          �2)Variavel lcancel - devera ser informado como private no   ���
���          �  inicio da rotina e controlado se e possivel efetuar o     ���
���          �  cancelamento da tela.                                     ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �.t. se confirmado ou .f. se cancelado                       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Mod3Buzz(cTitulo,cAlias1,cAlias2,aMyEncho,cLinOk,cTudoOk,nOpcE,nOpcG,cFieldOk,lVirtual,nLinhas,aAltEnchoice,nFreeze,aRodape,aButtons,cCpoItem,aObj)

Local lRet, nOpca	:= 0,cSaveMenuh,nReg:=(cAlias1)->(Recno()),oDlg
Local aSizeAut    	:= MsAdvSize(,.f.,400)
Local aInfo       	:= { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
Local aObjects 		:= {}
Local aPosObj		:= {}

lCancel := If(valtype(lCancel)=="U".or.lCancel==NIL,.t.,lCancel)

//aObj := If(aObj==NIL,{50,50,0},aObj) // Tamanho Original
aObj := If(aObj==NIL,{80,20,0},aObj)

Aadd( aObjects, {000,aObj[1], .T., .F. } )
Aadd( aObjects, {000,aObj[2], .T., .T. } )

If aRodape<>NIL
	Aadd( aObjects, {000,aObj[3], .T., .F. } )
Endif
aPosObj	:= MsObjSize( aInfo, aObjects )

Private Altera:=.t.,Inclui:=.t.,lRefresh:=.t.,aTELA:=Array(0,0),aGets:=Array(0),;
bCampo:={|nCPO|Field(nCPO)},nPosAnt:=9999,nColAnt:=9999
Private cSavScrVT,cSavScrVP,cSavScrHT,cSavScrHP,CurLen,nPosAtu:=0

nOpcE 	 	:= Iif(nOpcE==Nil		,3	,nOpcE)
nOpcG 	 	:= Iif(nOpcG==Nil		,3	,nOpcG)
lVirtual 	:= Iif(lVirtual==Nil	,.F.,lVirtual)
nLinhas	 	:= Iif(nLinhas==Nil		,99	,nLinhas)

DEFINE MSDIALOG oDlg TITLE cTitulo From aSizeAut[7],0 to aSizeAut[6],aSizeAut[5]	of oMainWnd PIXEL
EnChoice(cAlias1,nReg,nOpcE,,,,aMyEncho,{aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4]},aAltEnchoice,3,,,,,,lVirtual)
oGetDados := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcG,cLinOk,cTudoOk,cCpoItem,.T.,,nFreeze,,nLinhas,cFieldOk)

If aRodape<>NIL
	If len(aRodape)>0
		@ aPosObj[3,1],010 Say aRodape[1,1] Pixel
		@ aPosObj[3,1],050 MsGet oRod1 Var aRodape[1,2] Picture "@E 9999,999.99" When .f. Pixel
	Endif
	If len(aRodape)>1
		@ aPosObj[3,1],130 Say aRodape[2,1] Pixel
		@ aPosObj[3,1],170 MsGet oRod2 Var aRodape[2,2] Picture "@E 9999,999.99" When .f. Pixel
	Endif
	If len(aRodape)>2
		@ aPosObj[3,1],240 Say aRodape[3,1] Pixel
		@ aPosObj[3,1],280 MsGet oRod3 Var aRodape[3,2] Picture "@E 9999,999.99" When .f. Pixel
	Endif
Endif

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpca:=1,If(oGetDados:TudoOk(),If(!obrigatorio(aGets,aTela),nOpca := 0,oDlg:End()),nOpca := 0)},{||iif(lCancel,oDlg:End(),Aviso("Atencao","Nao e possivel cancelamento.",{"OK"}))},,aButtons)

lRet:=(nOpca==1)
Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CalcDig   �Autor  �Ricardo Nunes       � Data �  27/03/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Calculo do digito verificador do nosso numero.              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Uso especifico para o BankBoston                           ���
�������������������������������������������������������������������������͹��
���Parametros�01-_cNum - Numero do Titulo (Nosso Numero)                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CalcDig(_cNum)

Local _cPond  := "98765432"  //Poderacao fornecida pelo banco
Local _cNosso := AllTrim(Str(_cNum))
Local _nSoma  := 0
Local _cDigito:=""

For I := 1 To 8
	
	_nSoma += Val(SubStr(_cPond,I,1))*Val(SubStr(_cNosso,I,1))
	
Next I

_nSoma := Mod(_nSoma*10,11)

_cDigito := If(_nSoma==10,0,_nSoma)

Return(Str(_cDigito,1))


/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � RFIN001  � Autor � Jeremias Lameze Junior� Data � 08/04/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Transformacao da Linha digitavel em codigo de barra.       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
/*/

User Function RFIN001()

SetPrvt("_cRetorno")
SetPrvt("CSTR,I,NMULT,NMODULO,CCHAR")
SetPrvt("CDIGITO,CDV1,CDV2,CDV3,CCAMPO1,CCAMPO2")
SetPrvt("CCAMPO3,NVAL,NCALC_DV1,NCALC_DV2,NCALC_DV3,NREST")

_cRetorno := ''

if ValType(M->E2_LINHADG) == NIL
	Return(_cRetorno)
Endif

cStr := M->E2_LINHADG

i := 0
nMult := 2
nModulo := 0
cChar   := SPACE(1)
cDigito := SPACE(1)

cDV1    := SUBSTR(cStr,10, 1)
cDV2    := SUBSTR(cStr,21, 1)
cDV3    := SUBSTR(cStr,32, 1)

cCampo1 := SUBSTR(cStr, 1, 9)
cCampo2 := SUBSTR(cStr,11,10)
cCampo3 := SUBSTR(cStr,22,10)

nMult   := 2
nModulo := 0
nVal    := 0

// Calcula DV1

For i := Len(cCampo1) to 1 Step -1
	cChar := Substr(cCampo1,i,1)
	If isAlpha(cChar)
		Help(" ", 1, "ONLYNUM")
		Return(_cRetorno)
	endif
	nModulo := Val(cChar)*nMult
	If nModulo >= 10
		nVal := NVAL + 1
		nVal := nVal + (nModulo-10)
	Else
		nVal := nVal + nModulo
	EndIf
	nMult:= if(nMult==2,1,2)
Next
nCalc_DV1 := 10 - (nVal % 10)

//Calcula DV2

nMult   := 2
nModulo := 0
nVal    := 0

For i := Len(cCampo2) to 1 Step -1
	cChar := Substr(cCampo2,i,1)
	If isAlpha(cChar)
		Help(" ", 1, "ONLYNUM")
		Return(_cRetorno)
	endif
	nModulo := Val(cChar)*nMult
	If nModulo >= 10
		nVal := nVal + 1
		nVal := nVal + (nModulo-10)
	Else
		nVal := nVal + nModulo
	EndIf
	nMult:= if(nMult==2,1,2)
Next
nCalc_DV2 := 10 - (nVal % 10)

// Calcula DV3

nMult   := 2
nModulo := 0
nVal    := 0

For i := Len(cCampo3) to 1 Step -1
	cChar := Substr(cCampo3,i,1)
	if isAlpha(cChar)
		Help(" ", 1, "ONLYNUM")
		Return(_cRetorno)
	endif
	nModulo := Val(cChar)*nMult
	If nModulo >= 10
		nVal := nVal + 1
		nVal := nVal + (nModulo-10)
	Else
		nVal := nVal + nModulo
	EndIf
	nMult:= if(nMult==2,1,2)
Next
nCalc_DV3 := 10 - (nVal % 10)

If nCalc_DV1 == 10
	nCalc_DV1 := 0
EndIf
If nCalc_DV2 == 10
	nCalc_DV2 := 0
EndIf
If nCalc_DV3 == 10
	nCalc_DV3 := 0
EndIf

if !(nCalc_DV1 == Val(cDV1) .and. nCalc_DV2 == Val(cDV2) .and. nCalc_DV3 == Val(cDV3) )
	Help(" ",1,"INVALCODBAR")
	Return(_cRetorno)
endif

_cRetorno := SUBSTR(cStr, 1, 4)+SUBSTR(cStr, 33, 1)+iif(Len(alltrim(SUBSTR(cStr, 34, 14)))<14,StrZero(Val(Alltrim(SUBSTR(cStr, 34, 14))),14),SUBSTR(cStr, 34, 14))+SUBSTR(cStr, 5, 5)+SUBSTR(cStr, 11, 10)+SUBSTR(cStr, 22, 10)
Return(_cRetorno)

// Calcula DV3

nMult   := 2
nModulo := 0
nVal    := 0

For i := Len(cCampo3) to 1 Step -1
	cChar := Substr(cCampo3,i,1)
	if isAlpha(cChar)
		Help(" ", 1, "ONLYNUM")
		Return(_cRetorno)
	endif
	nModulo := Val(cChar)*nMult
	If nModulo >= 10
		nVal := nVal + 1
		nVal := nVal + (nModulo-10)
	Else
		nVal := nVal + nModulo
	EndIf
	nMult:= if(nMult==2,1,2)
Next
nCalc_DV3 := 10 - (nVal % 10)

If nCalc_DV1 == 10
	nCalc_DV1 := 0
EndIf
If nCalc_DV2 == 10
	nCalc_DV2 := 0
EndIf
If nCalc_DV3 == 10
	nCalc_DV3 := 0
EndIf

if !(nCalc_DV1 == Val(cDV1) .and. nCalc_DV2 == Val(cDV2) .and. nCalc_DV3 == Val(cDV3) )
	Help(" ",1,"INVALCODBAR")
	Return(_cRetorno)
endif

_cRetorno := SUBSTR(cStr, 1, 4)+SUBSTR(cStr, 33, 1)+iif(Len(alltrim(SUBSTR(cStr, 34, 14)))<14,StrZero(Val(Alltrim(SUBSTR(cStr, 34, 14))),14),SUBSTR(cStr, 34, 14))+SUBSTR(cStr, 5, 5)+SUBSTR(cStr, 11, 10)+SUBSTR(cStr, 22, 10)
Return(_cRetorno)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �HQFUN01   �Autor  �Ricardo Nunes       � Data �  15/04/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function HQFUN01(_cNumPed)

Local _cQuery	:= ""
Local _cQuery2	:= ""
Local lSPed 	:= ""
xcFILFAT := LEFT(GETMV("MV_FILFAT"),2)
xcFILORIG := SUBS(GETMV("MV_FILFAT"),4,2)
IF !EMPTY(xcFILORIG)
	xcFILFAT := xcFILORIG
ENDIF
IF TYPE("CFILFAT")!="U"
	xcFILFAT := CFILFAT
ENDIF

#IFDEF TOP
	_cQuery  += "SELECT COUNT(*) NUMERO FROM "+RetSqlName("SZ2")+" "
	// 	_cQuery	 += "WHERE Z2_FILIAL ='"+xFilial("SZ2")+"'"
	_cQuery	 += "WHERE Z2_FILIAL ='"+xcFILFAT +"'"
	_cQuery  += "  AND Z2_NUMPED ='"+_cNumPed+"'"
	_cQuery  += "  AND Z2_FATURA =''"
	_cQuery  += "  AND D_E_L_E_T_<>'*'"
	_cQuery  := ChangeQuery(_cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TOPQRY",.F.,.T.)
	
	_cQuery2 += "SELECT COUNT(*) NUMERO2 FROM "+RetSqlName("SZ2")+" "
	// 	_cQuery2 += "WHERE Z2_FILIAL ='"+xFilial("SZ2")+"'"
	_cQuery2 += "WHERE Z2_FILIAL ='"+xcFILFAT +"'"
	_cQuery2 += "  AND Z2_NUMPED ='"+_cNumPed+"'"
	_cQuery2 += "  AND D_E_L_E_T_<>'*'"
	_cQuery2 := ChangeQuery(_cQuery2)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),"TOPQRY2",.F.,.T.)
	
	If (TOPQRY->NUMERO = 0)
		lSPed := "S" //Faturado SIM
	ElseIf (TOPQRY->NUMERO > 0 .And. TOPQRY->NUMERO < TOPQRY2->NUMERO2)
		lSPed := "P" //Faturado Parcialmente
	Else
		lSPed := "" //Nao Faturado
	EndIf
	TOPQRY->(dbCloseArea())
	TOPQRY2->(dbCloseArea())
#ENDIF

Return(lSPed)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CNABPG    �Autor  �Ricardo Nunes       � Data �  06/13/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao para ira retornar o codigo do tipo de pagamento do   ���
���          �Banco BankBoston de acordo com o manual do banco.           ���
�������������������������������������������������������������������������͹��
���Uso       �Uso especifico HQ - CNAB A PAGAR AP                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CNABPG(_cParam)

Local _cRet

If _cParam == "TP"
	_cRet := If(SA2->A2_BANCO=="479","CC ",If(EMPTY(SE2->E2_CODBAR),"DOC","COB"))
ElseIf _cParam == "CC"
	_cRet := If(SA2->A2_BANCO=="479","000",If(SE2->E2_MODSPB $("2,3"),"700","018"))
Endif

Return(_cRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �DropaBa  	  � Autor � Fabio Veiga Oliva   � Data � 15/08/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Funcao para gerar query para dropar arquivos usada          ���
���          �na fase de implantacao do sistema.                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function DropaBa()
aStru := {}
Aadd(aStru,{"LINHA"   ,"C",50,0})
_cArqTmp := CriaTrab(aStru, .T.)
DbUseArea(.T.,__LocalDriver,_cArqTmp,"TRB2",.F.,.F.)
_cArq := "DROPAR.DBF"
DbUseArea(.T.,__LocalDriver,_cArq,"TRB",.F.,.F.)
dbSelectArea("TRB")
_aArqs := {}
dbGotop()
While !Eof()
	If TRB->X2_DROPAR == "S"
		RecLock("TRB2",.T.)
		TRB2->LINHA := "DROP TABLE "+TRB->X2_CHAVE+SM0->M0_CODIGO+"0"
		MsUnlock()
	EndIf
	dbSelectArea("TRB")
	dbSkip()
EndDo
dbSelectArea("TRB2")
COPY TO DROP
dbCloseArea("TRB")
dbCloseArea("TRB2")
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �RFMesRef  � Autor �Cosme da Silva Nunes� Data � 15/07/2003  ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao para retornar o extenso do mes correspondente       ���
���          � ao processado pela funcao Month()                          ���
�������������������������������������������������������������������������͹��
���Uso       � Gatilho Z1_Emissao para identificar mes de referencia      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RFMesRef(_nMes)
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
_aMeses := {}
_aMeses := {"Janeiro","Fevereiro","Marco","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"}
_cRet := _aMeses[_nMes]

Return(_cRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CALCFTAB  �Autor  �Ricardo Nunes       � Data �  11/11/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao para retornar o preco da sala de tabela              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CALCFTAB(_cTabela,_cProduto,_nFator)

Local _cArea	:= GetArea()
Local _nValor 	:= 0
Local _nMensal	:= GetMv("MV_FTORMNS") //Percentual do plano mensal
Local _nTrimes	:= GetMv("MV_FTORTRI") //Percentual do plano trimestra
Local _nAnual	:= GetMv("MV_FTORANU") //Percentual do plano anual
Local _n2Anos	:= GetMv("MV_FTOR2AN") //Percentual do plano 2 anual

dbSelectArea("DA1")
dbSetOrder(1)

If MsSeek(XFILIAL("DA1")+_cTabela+_cProduto)
	_nValor := DA1->DA1_PRCVEN
Endif

If SubStr(_cProduto,1,3) == "FTO"
	If AllTrim(_nFator) == "1"
		_nValor := (_nMensal*_nValor)
	ElseIf AllTrim(_nFator) == "2"
		_nValor := (_nTrimes*_nValor)
	ElseIf AllTrim(_nFator) == "4"
		_nValor := (_nAnual*_nValor)
	ElseIf AllTrim(_nFator) == "5"
		_nValor := (_n2Anos*_nValor)
	Endif
Endif

_nValor := NoRound(_nValor,2)

RestArea(_cArea)
Return(_nValor)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �HQXFUN    �Autor  �Microsiga           � Data �  12/18/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao de fim Mes                                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function Fimmes(cMes,cAno)

cProxMes := StrZero(VAL(cMes)+1,2)
IF cProxMes == "13"
	cProxMes := "01"
	cAno     := Alltrim(Str(VAL(cAno)+1))
EndIf

Return _dFimMes := Ctod("01/"+cProxMes+"/"+cAno)-1

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �HQXFUN    �Autor  �Microsiga           � Data �  12/18/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Mes Extenso                                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MesExtenso(nMes)

Local aMeses := {"Janeiro","Fevereiro","Marco","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"}

Return(aMeses[nMes])

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NRegSZ5   �Autor  �Ricardo Nunes       � Data �  06/04/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao para buscar a Sequencia da ocorencia automatica      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Uso especifico HQ                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function NRegSZ5()//_cVend,_cOport,_dDataVis)

Local _cRet

_cQuery := "SELECT COUNT(*) REGISTRO"
_cQuery += "  FROM "+ RetSqlName("SZ5") + " SZ5 "
_cQuery += " WHERE Z5_FILIAL = '"+xFilial("SZ5")+"'"
_cQuery += "   AND Z5_VEND   = '"+M->Z5_VEND+"'"
_cQuery += "   AND Z5_NROPOR = '"+M->Z5_NROPOR+"'"
_cQuery += "   AND Z5_DATA   = '"+DTOS(M->Z5_DATA)+"'"
_cQuery += "   AND D_E_L_E_T_ <> '*'"
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'QUERY', .F., .T.)

_cRet := StrZero(QUERY->REGISTRO+1,2)
QUERY->(dbClosearea())

Return(_cRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GravaSZ5  �Autor  �Ricardo Nunes       � Data �  02/07/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao para gravar ocorroncias X oportunidade			      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Uso especifico HQ                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GravaSZ5(_cVend,_cOport,_dDataVis,_cTipoOcor,_cHora,_cDesc)

Local _cSeq
Private aMemos	 :={{"Z5_CODMEM","Z5_OBSERV"}}

_cQuery := "SELECT COUNT(*) REGISTRO"
_cQuery += "  FROM "+ RetSqlName("SZ5") + " SZ5 "
_cQuery += " WHERE Z5_FILIAL = '"+xFilial("SZ5")+"'"
_cQuery += "   AND Z5_VEND   = '"+_cVend+"'"
_cQuery += "   AND Z5_NROPOR = '"+_cOport+"'"
_cQuery += "   AND Z5_DATA   = '"+_dDataVis+"'"
_cQuery += "   AND D_E_L_E_T_ <> '*'"
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'QUERY', .F., .T.)

_cSeq := StrZero(QUERY->REGISTRO+1,2)
QUERY->(dbClosearea())

dbSelectArea("SZ5")
RecLock("SZ5",.T.)
SZ5->Z5_FILIAL	:= xFilial("SZ5")
SZ5->Z5_VEND	:= _cVend
SZ5->Z5_NROPOR	:= _cOport
SZ5->Z5_DATA	:= _dDataVis
SZ5->Z5_SEQUEN	:= _cSeq     //
SZ5->Z5_TPOCOR	:= _cTipoOcor
SZ5->Z5_HORA1	:= _cHora
SZ5->Z5_OBSERV	:= _cDesc     //
MsUnlock()


Return()
