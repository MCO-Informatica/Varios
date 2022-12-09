#include "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImpFin    บAutor  ณ Eduardo Vicente    บ Data ณ  24/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Importacao dos dados de titulos a pagar e receber, usando  บฑฑ
ฑฑบ          ณ MSEXECAUTO e gerando LOG de erros                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ImpFin()
Local nOpca 	:= 0
Local aSays 	:= {}
Local aButtons  := {}
Private cCadastro	:= "Importacao Dados Financeiro"

AADD(aSays,OemToAnsi( "O objetivo deste programa  efetuar a importa็ใo dos dados" ) ) 
AADD(aSays,OemToAnsi( "de contas a pagar e receber no sistema Protheus." ) )
AADD(aSays,OemToAnsi( " " ) )

AADD(aButtons, { 1,.T.,{|| nOpca := 1,FechaBatch() }} )
AADD(aButtons, { 2,.T.,{|| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )

If nOpca <> 1
	Return NIL
EndIf

Processa( {|lEnd| RunProc(@lEnd)}, "Aguarde...","Executando rotina.", .T. )

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRunProc   บAutor  ณ Ernani Forastieri  บ Data ณ  20/04/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina auxiliar de Processamento                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RunProc(lEnd)
Local aDados	:= {}
Local cCnpj     := ""
Local cLoja		:= ""
Local cTab		:= ""
Local _cFilial  := ""
Local nTotRec	:= 0
Local cCampo    := ""
Local cCod		:= ""
Local _cFileLog 
Local _cPath 	:= ""

AutoGrLog("INICIANDO O LOG - IMPORTACAO TITULOS A PAGAR/RECEBER")
AutoGrLog("-------------------------------------")
AutoGrLog("DATABASE...........: "+Dtoc(dDataBase))
AutoGrLog("DATA...............: "+Dtoc(MsDate()))
AutoGrLog("HORA...............: "+Time())
AutoGrLog("ENVIRONMENT........: "+GetEnvServer())
AutoGrLog("PATCH..............: "+GetSrvProfString("Startpath",""))
AutoGrLog("ROOT...............: "+GetSrvProfString("SourcePath",""))
AutoGrLog("VERSรO.............: "+GetVersao())
AutoGrLog("MำDULO.............: "+"SIGA"+cModulo)
AutoGrLog("EMPRESA / FILIAL...: "+SM0->M0_CODIGO+"/"+SM0->M0_CODFIL)
AutoGrLog("NOME EMPRESA.......: "+Capital(Trim(SM0->M0_NOME)))
AutoGrLog("NOME FILIAL........: "+Capital(Trim(SM0->M0_FILIAL)))
AutoGrLog("USUมRIO............: "+cUserName)

Alert('Pronto')

cQuery := " SELECT FILIAL, PREFIXO, NUM, PARCELA, TIPO, NATUREZ, CODIGO, LOJA, EMISSAO, VENCTO, "
cQuery += " VALOR, HIST, SALDO, MOTIVO, RECPAG "
cQuery += " FROM IMPORTACAO  (NOLOCK) WHERE  "
cQuery += "IMPORT = 'N' AND "
cQuery += " RECPAG IN('P','R') "       
//cQuery += " AND NUM = '12679' "
cQuery += " ORDER BY RECPAG "

DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

Count To nTotRec
ProcRegua(nTotRec)

TRB->(dbGoTop())

While !TRB->(EOF())
   	
   	IncProc("Processando...")
   
   	If TRB->RECPAG == 'R'

   		cTab := 'E1_'
   		
   		SA1->(dbSetOrder(1))
   		If !SA1->(dbSeek(xFilial("SA1")+TRB->CODIGO+TRB->LOJA))
   			AutoGrLog(Left(TRB->CODIGO+Replicate(" ",06),06) + " C๓digo de Cliente nใo cadastrado ")
			AutoGrLog(REPLICATE("=",15))
			
			TRB->(dbSkip())
			Loop
		Else
			cCod     := SA1->A1_COD
			cLoja    := SA1->A1_LOJA
			cCampo   := "E1_CLIENTE"
			_cFilial := xFilial("SE1")
   		EndIf
   			
   	Else

		cTab := 'E2_'
		
		SA2->(dbSetOrder(1))
   		If !SA2->(dbSeek(xFilial("SA2")+TRB->CODIGO+TRB->LOJA))
   			AutoGrLog(Left(TRB->CODIGO+Replicate(" ",06),06) + " C๓digo de Fornecedor nใo encontrado ")
			AutoGrLog(REPLICATE("=",15))
			
			TRB->(dbSkip())
			Loop
   		Else
			cCod     := SA2->A2_COD
			cLoja    := SA2->A2_LOJA
			cCampo   := "E2_FORNECE"
			_cFilial := xFilial("SE2")
   		EndIf
   		
   	EndIf
   	
   	SX5->(dbSetOrder(1))
   	If !SX5->(dbSeek(xFilial('SX5')+'05'+TRB->TIPO))
   		AutoGrLog(Left(TRB->TIPO+Replicate(" ",06),06) + " Tipo de Titulo nใo encontrado ")
		AutoGrLog(REPLICATE("=",15))
			
		TRB->(dbSkip())
		Loop
	EndIf
	
	SED->(dbSetOrder(1))
   	If !SED->(dbSeek(xFilial('SED')+TRB->NATUREZ))
   		AutoGrLog(Left(TRB->NATUREZ+Replicate(" ",06),06) + " Natureza de Titulo nใo encontrado ")
		AutoGrLog(REPLICATE("=",15))
			
		TRB->(dbSkip())
		Loop
	EndIf   		
   	
   	If TRB->RECPAG == 'P'
   		SE2->(dbSetOrder(1))
   		If SE2->(dbSeek(xFilial('SE2')+TRB->PREFIXO+Substr(Strzero(val(TRB->NUM),9),1,9)+TRB->PARCELA+TRB->TIPO+TRB->CODIGO+TRB->LOJA))
   			AutoGrLog( TRB->FILIAL+TRB->PREFIXO+TRB->NUM+TRB->PARCELA+TRB->TIPO+TRB->CODIGO+TRB->LOJA + " Titulo ja existe ")
			AutoGrLog(REPLICATE("=",15))
			
			TRB->(dbSkip())
			Loop	
   	    EndIf
   	    
   	    RecLock('SE2',.T.)
   	    
   	    SE2->E2_FILIAL  := _cFilial
		SE2->E2_FILORIG := TRB->FILIAL
		SE2->E2_MSFIL	:= TRB->FILIAL
		SE2->E2_PREFIXO := TRB->PREFIXO
		SE2->E2_NUM     := Substr(Strzero(val(TRB->NUM),9),1,9)
		SE2->E2_PARCELA := TRB->PARCELA
		SE2->E2_TIPO    := TRB->TIPO
		SE2->E2_NATUREZ := TRB->NATUREZ
		SE2->E2_FORNECE := cCod
		SE2->E2_LOJA    := cLoja
		SE2->E2_EMISSAO := StoD(TRB->EMISSAO)
		SE2->E2_VENCTO  := StoD(TRB->VENCTO)               
		dVencR	        := DataValida(StoD(TRB->VENCTO))
		SE2->E2_VENCREA := dVencR 
		SE2->E2_VALOR   := TRB->VALOR
		SE2->E2_HIST    := TRB->HIST
		SE2->E2_SALDO   := TRB->SALDO
		SE2->E2_MOTIVO  := TRB->MOTIVO
		SE2->E2_EMIS1   := StoD(TRB->EMISSAO)
		SE2->E2_VENCORI := StoD(TRB->VENCTO)
		SE2->E2_MOEDA   := 1
		SE2->E2_RATEIO  := 'N'
		SE2->E2_VLCRUZ  := TRB->VALOR
		SE2->E2_OCORREN := '01'
		SE2->E2_FLUXO   := 'S'
		SE2->E2_ORIGEM  := 'FINA050'
		SE2->E2_DESDOBR := 'N'
		SE2->E2_MULTNAT := '2'
		SE2->E2_PROJPMS := '2'
		SE2->E2_DIRF    := '2'
		SE2->E2_MODSPB  := '1'
		SE2->E2_MDRTISS := '1'
		SE2->E2_FRETISS := '1'
		SE2->E2_APLVLMN := '1'
		SE2->E2_TRETISS := '2'
		
	   	
	   	MsUnlock()    
   Else
   		SE1->(dbSetOrder(1))
   		If SE1->(dbSeek(xFilial('SE1')+TRB->PREFIXO+Substr(Strzero(val(TRB->NUM),9),1,9)+TRB->PARCELA+TRB->TIPO+TRB->CODIGO+TRB->LOJA))
   			AutoGrLog( TRB->FILIAL+TRB->PREFIXO+TRB->NUM+TRB->PARCELA+TRB->TIPO+TRB->CODIGO+TRB->LOJA + " Titulo ja existe ")
			AutoGrLog(REPLICATE("=",15))
			
			TRB->(dbSkip())
			Loop	
   	    EndIf
   	    
   	    RecLock('SE1',.T.)
   	    
   	    SE1->E1_FILIAL  := _cFilial
		SE1->E1_FILORIG := TRB->FILIAL
		SE1->E1_MSFIL	:= TRB->FILIAL
		SE1->E1_MSEMP   := "01"
		SE1->E1_PREFIXO := TRB->PREFIXO
		SE1->E1_NUM     := Substr(Strzero(val(TRB->NUM),9),1,9)
		SE1->E1_PARCELA := TRB->PARCELA
		SE1->E1_TIPO    := TRB->TIPO
		SE1->E1_NATUREZ := TRB->NATUREZ
		SE1->E1_CLIENTE := cCod
		SE1->E1_LOJA    := cLoja
		SE1->E1_EMISSAO := StoD(TRB->EMISSAO)
		SE1->E1_VENCTO  := StoD(TRB->VENCTO)
		dVencR	        := DataValida(StoD(TRB->VENCTO))
		SE1->E1_VENCREA := dVencR
		SE1->E1_VALOR   := TRB->VALOR
		SE1->E1_HIST    := TRB->HIST
		SE1->E1_SALDO   := TRB->SALDO
		SE1->E1_MOTIVO  := TRB->MOTIVO
		SE1->E1_EMIS1   := StoD(TRB->EMISSAO)
		SE1->E1_VENCORI := StoD(TRB->VENCTO)
		SE1->E1_MOEDA   := 1
		SE1->E1_VLCRUZ  := TRB->VALOR
		SE1->E1_OCORREN := '01'
		SE1->E1_FLUXO   := 'S'
		SE1->E1_ORIGEM  := 'FINA040'
		SE1->E1_DESDOBR := 'N'
		SE1->E1_MULTNAT := '2'
		SE1->E1_PROJPMS := '2'
		SE1->E1_MODSPB  := '1'
		SE1->E1_FRETISS := '1'
		SE1->E1_APLVLMN := '1'
	   	
	   	MsUnlock()    
   	    
   EndIf
   
    cQuery1 := " UPDATE	IMPORTACAO SET IMPORT = 'S' "
	cQuery1 += " WHERE 	FILIAL	= '" + TRB->FILIAL + "' "
	cQuery1 += " AND	PREFIXO = '" + TRB->PREFIXO + "' "
	cQuery1 += " AND	NUM     = '" + TRB->NUM + "' "
	cQuery1 += " AND	PARCELA = '" + TRB->PARCELA + "' "
	cQuery1 += " AND	TIPO    = '" + TRB->TIPO + "' "
	cQuery1 += " AND	NATUREZ = '" + TRB->NATUREZ + "' "
	cQuery1 += " AND	CODIGO  = '" + TRB->CODIGO + "' "
	cQuery1 += " AND	LOJA    = '" + TRB->LOJA + "' "   
	
	If TCSQLExec(cQuery1) < 0
		AutoGrLog(Left(TRB->CODIGO+Replicate(" ",06),06) + " Erro na atualiza็ใo da tabela IMPORTACAO ")
		AutoGrLog(REPLICATE("=",15))
	EndIf
   	/* 	    
	Aadd( aDados, { cTab+"FILIAL" , _cFilial    , NIL})
	Aadd( aDados, { cTab+"FILORIG", TRB->FILIAL , NIL})
	Aadd( aDados, { cTab+"MSFIL"  , TRB->FILIAL , NIL})
	Aadd( aDados, { cTab+"MSEMP"  , "01" , NIL})
	Aadd( aDados, { cTab+"PREFIXO", TRB->PREFIXO, NIL})
	Aadd( aDados, { cTab+"NUM"    , Substr(Strzero(val(TRB->NUM),9),1,9), NIL})
	Aadd( aDados, { cTab+"PARCELA", TRB->PARCELA, NIL})
	Aadd( aDados, { cTab+"TIPO"   , TRB->TIPO   , NIL})
	Aadd( aDados, { cTab+"NATUREZ", TRB->NATUREZ, NIL})
	Aadd( aDados, { cCampo		   , cCod	     , NIL})
	Aadd( aDados, { cTab+"LOJA"   , cLoja       , NIL})
	//Aadd( aDados, { cTab+"EMISSAO", StoD(TRB->EMISSAO), NIL})
	Aadd( aDados, { cTab+"EMISSAO", dDataBase, NIL})      
	Aadd( aDados, { cTab+"VENCTO" , StoD(TRB->VENCTO) , NIL})
	Aadd( aDados, { cTab+"VALOR"  , TRB->VALOR  , NIL})
	Aadd( aDados, { cTab+"HIST"   , TRB->HIST   , NIL})
	Aadd( aDados, { cTab+"SALDO"  , TRB->SALDO  , NIL})
	Aadd( aDados, { cTab+"MOTIVO" , TRB->MOTIVO , NIL})
   	
	lMsErroAuto := .F.
	
   	If TRB->RECPAG == 'R'	
		MSExecAuto({|x,y| FINA040(x,y)},aDados,3)
	Else
		MSExecAuto({|x,y| FINA050(x,y)},aDados,3)
   	EndIf
   	
   	If lMsErroAuto 
   	     //MostraErro()
		AutoGrLog(Left(TRB->CODIGO+Replicate(" ",06),06) + " C๓digo de Cliente ou Fornecedor nใo importado ")
		AutoGrLog(REPLICATE("=",15))
		//DisarmTransaction()
	Else
		cQuery1 := " UPDATE	IMPORTACAO SET IMPORT = 'S' "
		cQuery1 += " WHERE 	FILIAL	= '" + TRB->FILIAL + "' "
		cQuery1 += " AND	PREFIXO = '" + TRB->PREFIXO + "' "
		cQuery1 += " AND	NUM     = '" + TRB->NUM + "' "
		cQuery1 += " AND	PARCELA = '" + TRB->PARCELA + "' "
		cQuery1 += " AND	TIPO    = '" + TRB->TIPO + "' "
		cQuery1 += " AND	NATUREZ = '" + TRB->NATUREZ + "' "
		cQuery1 += " AND	CODIGO  = '" + TRB->CODIGO + "' "
		cQuery1 += " AND	LOJA    = '" + TRB->LOJA + "' "
		
		If TCSQLExec(cQuery1) < 0
			AutoGrLog(Left(TRB->CODIGO+Replicate(" ",06),06) + " Erro na atualiza็ใo da tabela IMPORTACAO ")
			AutoGrLog(REPLICATE("=",15))
		EndIf
		
	Endif
    */
	TRB->(dbSkip())
	
End

_cFileLog := NomeAutoLog()

If _cFileLog <> ""
	MostraErro(_cPath, _cFileLog)
Endif

MsgInfo("Importa็ใo dos titulos finalizada")

TRB->(dbCloseArea())

Return Nil