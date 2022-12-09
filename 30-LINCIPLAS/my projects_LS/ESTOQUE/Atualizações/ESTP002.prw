#include "rwmake.ch"
#include "topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ESTP002   ºAutor  ³Marcelo Scibarauskasº Data ³  11/02/08   º±±
±±º          ³          º       ³Ricardo Felipelli   º Data ³  04/10/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Inclui nota fiscal de consignacao.                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Laselva                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function ESTP002()
///////////////////////

Private aSays      := {}
Private aButtons   := {}
Private	nOpca      := 0
Private _cCadastro := "Inclui Nota Consignacao"
Private cPerg		:= Padr("ESTP01" ,len(SX1->X1_GRUPO)," ")
Private _cEmpFil	:= ""

ValidPerg()
PERGUNTE(cPerg, .F.)

AADD(aSays,"Este programa tem o objetivo de gerar a nota ")
AADD(aSays,"de consignacao com base em tabela fornecida ")
AADD(aSays,"pelo cliente. ")
AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End() } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
FormBatch( _cCadastro, aSays, aButtons )

if nOpcA == 1
	If Pergunte(cPerg, .T.)
		ValidPerg()
		Processa({|| DefFilial()   },"Gerando Nota de Consignacao...  "+mv_par03)
	Endif
endif

Return

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function DefFilial()
///////////////////////////

Local aEmpFil  := {}
Local nHdlLock := 0

Local cArqLock := "estp001.lck"
Local APARAM :={"01","01"}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Efetua o Lock de gravacao da Rotina - Monousuario            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FErase(cArqLock)
nHdlLock := MsFCreate(cArqLock)
//IF nHdlLock < 0
//	Conout("Rotina "+FunName()+" ja em execução.")
//	Return(.T.)
//EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa ambiente.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RpcSetType(3)
IF FindFunction('WFPREPENV')
	WfPrepEnv( aParam[1], aParam[2])
Else
	Prepare Environment Empresa aParam[1] Filial aParam[2]
EndIF
ChkFile("SM0")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ log de importacao                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cArqLog:="\LOGS\COLIG"+mv_par03
nHdlArq:=FCreate(cArqLOG)
PAGI  :=  1
li    := 80
cLine := ""
cNL   := CHR(13)+CHR(10)
If nHdlArq==-1
	tone(5000,1)
	alert("Impossivel Criar Arquivo COLIG"+mv_par03+".log Verificar...")
	Return nil
Endif
nCtErro:=0


cline := 'Codigo     ' + cNL
fWrite(nHdlArq,cLine,Len(cLine))
cline:=cNL
fWrite(nHdlArq,cLine,Len(cLine))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona filiais.   						   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbSelectArea("SM0")
DbSetOrder(1)
DbGoTop()
While !Eof()
	if mv_par03 == alltrim(SM0->M0_EMERGEN)
		_cEmpFil := alltrim(SM0->M0_EMERGEN)
		AAdd(aEmpFil,{SM0->M0_CODIGO,SM0->M0_CODFIL,Alltrim(SM0->M0_NOME)+"/"+Alltrim(SM0->M0_FILIAL)})
	EndIf
	DbSkip()
EndDo


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha filial corrente.						   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Reset Environment

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa rotinas por Empresa/filial.  			   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX := 1 To Len(aEmpFil)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Comando para nao comer licensas.     				  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RpcSetType(3)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Abre a respectiva filial.            				  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF FindFunction('WFPREPENV')
		WfPrepEnv( aEmpFil[nX,1], aEmpFil[nX,2])
	Else
		Prepare Environment Empresa aEmpFil[nX,1] Filial aEmpFil[nX,2]
	EndIF
	ChkFile("SM0")
	
	GeraNF()
	
	Reset Environment
Next


fclose(nHdlArq)

Alert("PROCESSAMENTO FINALIZADO COM SUCESSO !")

cQryD := " insert into PROGET.Informatica.SMS.fila (para,sms) values ('92513645','Finalizada importacao filiais peso:  '"+_cEmpFil+"' ') "
TcSQLExec(cQryD)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cancela o Lock de gravacao da rotina                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FClose(nHdlLock)
FErase(cArqLock)

Return(.T.)


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function GeraNF()
////////////////////////

Local cQuery   := ""
Local cQueryOrd:= ""
Local cNota    := ""
Local cSerie   := ""
Local cFornece := ""
Local cLoja    := ""
Local cTes     := ""
Local aCabec   := {}
Local aItens   := {}
Local nReg     := 0
Local nQde     := 0
Local nPrUnit  := 0
Local dData

Private lMsErroAuto := .F.

cQuery    += " SELECT * "
cQuery    += " FROM SIGA.dbo.NOTASCONSIG "
cQuery    += " WHERE "
//cQuery    += " FILIAL = '"+xFilial("SD3")+"' AND QUANTIDADE<>0 AND len(NFISCAL)<7 "
cQuery    += " FILIAL = '"+xFilial("SD3")+"' AND QUANTIDADE<>0 "
cQueryOrd := " ORDER BY NFISCAL,SERIE,FORNECEDOR  "

U_GravaQuery('ESTP002.SQL',_cQuery)


// Executa a query principal
TcQuery cQuery+cQueryOrd NEW ALIAS "QUERY"

TcSetField("QUERY","EMISSAO","D",8,0)

// Conta os registros da Query
TcQuery "SELECT COUNT(*) AS TOTALREG FROM (" + cQuery + ") AS T" NEW ALIAS "QRYCONT"
QRYCONT->(dbgotop())
nReg := QRYCONT->TOTALREG
QRYCONT->(dbclosearea())


ProcRegua(QUERY->(RecCount()))

If nReg > 0
	
	While QUERY->(!Eof())
		
		
		If alltrim(QUERY->NFISCAL)<>cNota .or. alltrim(QUERY->SERIE)<>cSerie .or. alltrim(QUERY->FORNECEDOR)<>cFornece
			
			If !Empty(cNota)
				
				dbselectarea("SF1")
				dbsetorder(1)//F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
				If !dbseek(xFilial("SF1")+QUERY->NFISCAL+QUERY->SERIE+QUERY->FORNECEDOR+QUERY->LOJA)
					lMsErroAuto := .F.
					MSExecAuto({|x,y,z|Mata103(x,y,z)},aCabec,aItens,3)
					
					If lMsErroAuto
						cline:=" Erro: "+ xFilial("SF1")+QUERY->NFISCAL+QUERY->SERIE+QUERY->FORNECEDOR+QUERY->LOJA + cNL
						fWrite(nHdlArq,cLine,Len(cLine))
					EndIf
				Else
					Alert("Nota Fiscal "+QUERY->NFISCAL+"/"+QUERY->SERIE+" ja cadastrada.")
				Endif
				
			Endif
			
			
			dbselectarea("QUERY")
			
			cNota    := alltrim(QUERY->NFISCAL)
			cSerie   := alltrim(QUERY->SERIE)
			cFornece := alltrim(QUERY->FORNECEDOR)
			cLoja    := alltrim(QUERY->LOJA)
			aCabec   := {}
			aItens   := {}
			dData    := QUERY->EMISSAO
			
			
			aadd(aCabec,{"F1_TIPO"   ,"N"})
			aadd(aCabec,{"F1_FORMUL" ,"N"})
			aadd(aCabec,{"F1_DOC"    ,cNota})
			aadd(aCabec,{"F1_SERIE"  ,cSerie})
			aadd(aCabec,{"F1_EMISSAO",dData})
			aadd(aCabec,{"F1_FORNECE",cFornece})
			aadd(aCabec,{"F1_LOJA"   ,cLoja})
			aadd(aCabec,{"F1_ESPECIE","NFE"})
			aadd(aCabec,{"F1_COND","001"})
			
		Endif
		
		
		nQde    := QUERY->QUANTIDADE
		nPrUnit := QUERY->VLUNIT
		cTes    := iif(QUERY->ESTOQUE="S","401","400" )
		aLinha  := {}
		aadd(aLinha,{"D1_COD"    ,QUERY->PRODUTO ,Nil})
		aadd(aLinha,{"D1_QUANT"  ,nQde,Nil})
		aadd(aLinha,{"D1_LOCAL"  ,"01",Nil})
		aadd(aLinha,{"D1_TES"    ,cTes,Nil})
		aadd(aLinha,{"D1_VUNIT"  ,nPrUnit,Nil})
		aadd(aLinha,{"D1_TOTAL"  ,nPrUnit*nQde,Nil})
		aadd(aItens,aLinha)
		
		
		QUERY->(dbskip())
		IncProc()
	EndDo
	QUERY->(dbclosearea())
Endif

Return()



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VALIDPERG ºAutor  ³Marcelo Sciba       º Data ³  15/12/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria as perguntas do SX1                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
static function VALIDPERG()
///////////////////////////

// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,;
// cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
PutSX1(cPerg,"01","Documento"			,"Documento"		    ,"Documento" 			,"mv_ch1","C",06,0,0,"G","",""	 ,"",,"mv_par01","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"02","Data"        		,"Data"     		    ,"Data"     	    	,"mv_ch2","D",08,0,0,"G","",""	 ,"",,"mv_par02","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"03","Peso"        		,"Peso"     		    ,"Peso"     	    	,"mv_ch3","C",01,0,0,"G","",""	 ,"",,"mv_par03","","","","","","","","","","","","","","","","")

return()



