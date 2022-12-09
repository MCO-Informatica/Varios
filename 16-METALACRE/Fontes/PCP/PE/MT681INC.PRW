#include 'Protheus.ch'
#INCLUDE "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT681INC  บAutor  ณMicrosiga           บ Data ณ  04/27/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ PONTO DE ENTRADA NA SH6 PARA ENDERECAR UM PRODUTO          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
                          
User Function MT681INC()   
Local aArea := GetArea()

If cEmpAnt <> '01'
	Return
Endif

lLibCqAut := GetNewPar("MV_XCQAUT", .T.)

// Execauto para efetuar a libera็ใo automatica do cq.

If lLibCqAut
	
	lMsErroAuto := .F.
	
	cQuery := 	 " SELECT R_E_C_N_O_ REGSD7 "
	cQuery +=	 " FROM " + RetSqlName("SD7")
	cQuery +=	 " WHERE D7_FILIAL = '" + xFilial("SD7") + "' "
	cQuery +=	 " AND D_E_L_E_T_ = ''   "
	cQuery +=	 " AND D7_LOTECTL = '" + SH6->H6_LOTECTL + "' "
	cQuery +=	 " AND D7_SEQ = '001' " 
	cQuery +=	 " AND D7_LIBERA = '' " 
	cQuery +=	 " AND D7_TIPO = 0 " 
	cQuery +=	 " AND D7_PRODUTO = '" + SH6->H6_PRODUTO + "' " 
		
	TCQUERY cQuery NEW ALIAS "CHKCQ"
	
	nRegSd7 := CHKCQ->REGSD7
	
	CHKCQ->(dbCloseArea())
	
	If !Empty(nRegSd7)
		SD7->(dbGoTo(nRegSd7))

		SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+SH6->H6_PRODUTO))
		
		cMETLoc	   := SuperGetMv("MV_METLOC" , .F. , "EX") // Utilizado para retornar o estoque padrao Metalacre - Bruno Abrigo em 26/04/2012
		cLocPad    := IIF(SD7->D7_ORIGLAN=="PR",SB1->B1_LOCPAD,If(cLocCQ == SD7->D7_LOCDEST,SB1->B1_LOCPAD,SD7->D7_LOCDEST))
		cLocDes	   := Iif(Substr(SD7->D7_PRODUTO,1,2)=="LM" .And. SD7->D7_ORIGLAN=="PR",cMETLoc, cLocPad ) // Bruno Abrigo em 26/04/2012
		
		aLibera := {}
		aAdd(aLibera,{      {"D7_TIPO" ,1 ,Nil},; //D7_TIPO
		                    {"D7_DATA" ,dDataBase,Nil},; //D7_DATA
		                    {"D7_QTDE" ,SH6->H6_QTDPROD,Nil},; //D7_QTDE
		                    {"D7_QTSEGUM" ,0 ,Nil},; //D7_QTSEGUM
		                    {"D7_MOTREJE" ,"" ,Nil},; //D7_MOTREJE
		                    {"D7_LOCDEST" ,cLocDes,Nil},; //D7_LOCDEST
		                    {"D7_SALDO" ,NIL ,Nil},; //D7_SALDO
		                    {"D7_ESTORNO" ,NIL ,Nil}}) //D7_ESTORNO
		
	
		MSExecAuto({|x,y| mata175(x,y)},aLibera,4)
	
		IF lMsErroAuto
		     Alert("Erro na Libera็ใo do CQ, Verifique e Informe ao T.I. ")
		     MOSTRAERRO()
		Else
		     MsgInfo("Libera็ใo CQ Realizada com sucesso!")
		
		     U_A175GRV()
		Endif
	Endif
Endif

//local _LACHOU := .F. 


// TRECHO MATEUS HENGLE 

// Ponto de Entrada que Endere็a um PA somente na ultima opera็ใo
// CRIAR CAMPO H6_XENDPRO e C6_XENDPRO na Produ็ใo
// CRIAR CONSULTA PADRรO SBEX na Produ็ใo
// CRIAR PARAMETRO MV_XENDERE na Produ็ใo

cEnd   := Space(15)
cUser  := CUSERNAME
cProdu := SH6->H6_PRODUTO
cOper1 := SH6->H6_OPERAC
cOP    := SC2->C2_PEDIDO
cItem  := SC2->C2_ITEMPV

cProd1 := SUBSTR(cProdu,1,1)

cQry:= " SELECT MAX(G2_OPERAC) AS OPERAC" // QUERY QUE PEGA A ULTIMA OPERACAO PARA PODER ENDERECAR
cQry+= " FROM "+RETSQLNAME("SG2")+" SG2"
cQry+= " WHERE G2_PRODUTO = '"+cProdu+"'"           
cQry+= " AND D_E_L_E_T_=''"  

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

TCQUERY cQry New Alias "TRB"
TRB->(dbGoTop())

WHILE TRB->(!EOF())
	cOper := TRB->OPERAC   // PEGA O RESULTADO DA QUERY QUE EH APENAS A ULTIMA OPERACAO
	TRB->(DbSkip()) 
ENDDO

DBSELECTAREA("SB1")  // dbseek pra saber se ้ PA
DBSETORDER(1)
DBSEEK(xFilial("SB1")+ cProdu)

cTipo := SB1->B1_TIPO  // pega o tipo do produto

IF cProd1 == 'L' .AND. cTipo == 'PA' //SE FOR ULTIMA OPERAวรO, SE O PRODUTO COMEวAR COM 'L' E SE FOR 'PA' CHAMA A TELA PARA ENDEREวAR // cOper1 == cOper .AND. 
	U_TELA()   // TELA DE ENDEREวAMENTO
ENDIF                      

TRB->(DbCloseArea())

// Para Apontamentos com mais de um operador, sera excluido o movimento, e replicado para cada um dos funcionarios.

aDados := {}

If Len(AllTrim(SH6->H6_IDOPERA)) > 7 //TamSx3("H6_CODOPER")[1]  
	aOperador	:=	Separa(SH6->H6_IDOPERA,'|',.T.)
	
	cNumSeq	:=	SH6->H6_IDENT       
	cProduto:=  SH6->H6_PRODUTO  
	cNumOP	:=	SH6->H6_OP
		
	/// Localiza SD3

	Begin Transaction
			
	cQry:= " SELECT TOP 1 R_E_C_N_O_ AS REGI " // QUERY QUE PEGA A ULTIMA OPERACAO PARA PODER ENDERECAR
	cQry+= " FROM "+RETSQLNAME("SD3")+" D3"
	cQry+= " WHERE D3_IDENT = '"+cNumSeq+"'"           
	cQry+= " AND D3.D_E_L_E_T_=''"  
	cQry+= " AND LEFT(D3.D3_COD,3) = 'MOD' "           
	cQry+= " AND D3.D3_OP = '" + cNumOp + "' " 
	cQry+= " AND LEFT(D3.D3_OBSERVA,4) <> '|Op|' " 

	
	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf
	
	TCQUERY cQry New Alias "TRB"

	TRB->(dbGoTop())
	
	While TRB->(!EOF())
		SD3->(dbGoTo(TRB->REGI))

		// Joga os Dados do Registro D3 no Vetor.
					
		For nI := 1 To SD3->(FCount())
			AAdd(aDados, {SD3->(FieldName(nI)),SD3->(FieldGet(nI))} )
		Next         
		
		// Exclui o Apontamento Padrao

		If RecLock("SD3",.F.)
			SD3->(dbDelete())
			SD3->(MsUnlock())
		Endif
		TRB->(dbSkip(1))           
	Enddo
	
	TRB->(dbCloseArea())
	
	lFalha := .F.
						
	For nOpera := 1 To Len(aOperador)
		cCodOper	:=	aOperador[nOpera]
		
		If !Empty(cCodOper)
			If !SRA->(dbSetOrder(1), dbSeek(xFilial("SRA")+cCodOper))
				lFalha := .T.
				Exit
			Endif
			
			cCusto	:=	SRA->RA_CC   
			
			If !CTT->(dbSetOrder(1), dbSeek(xFilial("CTT")+cCusto))
				lFalha := .T.
				Exit
			Endif
			
			cCusto	:=	Iif(Empty(CTT->CTT_CCSUP),cCusto,CTT->CTT_CCSUP)
			cProd	:=	'MOD'+cCusto
			
			If !SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+cProd))
				lFalha := .t.
				Exit
			Endif

			/// Altera os Dados
					
			For nI := 1 To Len(aDados)    
				If AllTrim(aDados[nI,1])=='D3_COD'
					aDados[nI,2] := cProd
				ElseIf AllTrim(aDados[nI,1])=='D3_CC'
					aDados[nI,2] := cCusto
				ElseIf AllTrim(aDados[nI,1])=='D3_OBSERVA'
					aDados[nI,2] := '|Op|' + cCodOper + '|' + Capital(SRA->RA_NOME)
				Endif
			Next
					
			If RecLock("SD3",.t.)
				For nI := 1 To Len(aDados)
					nPos := SD3->(FieldPos(aDados[nI,1]))
					SD3->(FieldPut(nPos,aDados[nI,2]))
				Next
				SD3->(MsUnlock())
			Endif  
		Endif
	Next         
	
	If lFalha
		DisarmTransaction()
		Return Nil
	Endif
	End Transaction	
Endif


RestArea(aArea)
Return



//// TELA DE ENDEREวAMENTO /////
User Function Tela()

Local oDlg 
Local cUsuario := GetMv("MV_XENDERE") //"eduardo.silva#rafael.santos#renan.antunes#lucas.lacerda#Administrador"

IF cUser $ cUsuario  // NAO ESTA ENTRANDO NO IF

	DEFINE MSDIALOG oDlg TITLE "ENDERECAMENTO" FROM 0,0 TO 100,400 OF oDlg PIXEL

	@ 07, 10 SAY   "Endere็o"     SIZE 100,8 PIXEL OF oDlg
	@ 07, 40 MSGET cEnd F3 "SBEX" SIZE 80,10 PIXEL OF oDlg // CONSULTA PADRAO NA TABELA SBE
	@ 07,140 BUTTON "OK"          SIZE 25,13 PIXEL ACTION oDlg: End()
	
	ACTIVATE MSDIALOG oDlg CENTER ON INIT(oDlg) 
	

	IF !Empty(cEnd)
   		RecLock("SH6",.F.)       // ENDEREวA NA TABELA DE APONTAMENTO       	
		SH6->H6_XENDPRO := cEnd 
		SH6->(MsUnlock())
 	     	
 		If SC6->(dbSetOrder(1), dbSeek(xFilial("SC6")+cOp+cItem))
	   		If RecLock("SC6",.F.)          	 // ENDEREวA NO ITEM DO PEDIDO DE VENDA
				SC6->C6_XENDPRO := cEnd 
				SC6->(MsUnlock())
			Endif
		Endif
		MSGINFO("Endere็amento concluํdo com sucesso !") 
	ENDIF
ENDIF

Return


// AQUI INCLUSAO DA ROTINA QUE IRม GRAVAR OS DADOS DO LOTE NA TABELA DE EMPENHO.
// OS CAMPOS NA TABELA DE EMPENHO QUE TEM O CAMPO OPORIG GRAVADO SรO OS ITENS INTERMEDIARIOS. QUE PRECISAM TER O NUMERO DO LOTE ATRELADO.
/*dbselectarea("SD4")
DBSETORDER(4) // PROCURA PELO NUMOPORIG.    
IF DBSEEK(XFILIAL("SD4") + SH6->H6_OP )
	DO WHILE !EOF() .AND. ALLTRIM(SD4->D4_OPORIG) == ALLTRIM(SH6->H6_OP) .AND. !_LACHOU 
		IF ALLTRIM(SD4->D4_COD) == ALLTRIM(SH6->H6_PRODUTO) 
			RECLOCK("SD4",.F.)
				SD4->D4_LOTECTL := SUBSTR(SD4->D4_OP,1,8)
				_LACHOU := .T.
			SD4->(MSUNLOCK())
		ENDIF
		DBSELECTAREA("SD4")
		DBSKIP()
	ENDDO
ENDIF*/                         

// FIM DA ROTINA




User Function fVldEmpLt(cNumOP,cProduto)
Local aArea := GetArea()


cQry:= " SELECT * " // QUERY QUE PEGA A ULTIMA OPERACAO PARA PODER ENDERECAR
cQry+= " FROM "+RETSQLNAME("SD4")+" D4"
cQry+= " WHERE D4_OP = '" + cNumOp + "' "           
cQry+= " AND D4_PRODUTO = '" + cProduto + "' "           
cQry+= " AND D4.D4_QUANT > 0 "  
cQry+= " AND D4.D_E_L_E_T_= '' "  

If Select("TRB1") > 0
	TRB1->(dbCloseArea())
EndIf

TCQUERY cQry New Alias "TRB1"

Count To nReg

TRB1->(dbGoTop())

If Empty(nReg)
	MsgStop("Atencao, Nao Existem Itens Empenhados para Esta Ordem de Producao, Verifique !")
	TRB1->(dbCloseArea())
	RestArea(aArea)
	Return .F.
Endif

lSemLote := .F.

While TRB1->(!Eof())

	If Empty(TRB1->D4_LOTECTL)
		lSemLote	:=	.T.
	Endif
	
	TRB1->(dbSkip(1))
Enddo

TRB1->(dbCloseArea())

RestArea(aArea)

If lSemLote
	MsgStop("Atencao, Existem Empenhos Nao Amarrados em Lote, Verifique !")
//	Return .F.	 Por enquanto nao vai barrar
Endif

Return .T.
