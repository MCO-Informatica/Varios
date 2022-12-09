#INCLUDE "TOPCONN.CH"
#include "rwmake.ch"
#include "ap5mail.ch"
#include "tbiconn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AjSucata   º Autor ³ Luiz Alberto     º Data ³  17/01/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescrição ³ Ajusta Saldo Sucata na Virada do Mes Para Zerar
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Exclusivo Metalacre                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function AjSucata()
Local aArea := GetArea()
Local 	aSays      	:= {}
Local 	aButtons   	:= {}
Local 	nOpca    	:= 0    
Local	cCadastro	:=	'Ajuste Saldo SUCATAS'
Private cPerg := PadR('AJSUCATA',10)

ValidPerg()

Pergunte(cPerg,.f.)

AADD (aSays, "Este programa tem por objetivo efetuar o processamento de ")
AADD (aSays, "saldo de Sucatas e redistribui-los nas Ops do Mes de")
AADD (aSays, "fechamento e desta forma zerando seu Saldo.   ")

AAdd(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. )    }} )
AAdd(aButtons, { 1,.T.,{|| nOpca := 1,FechaBatch() }} )
AAdd(aButtons, { 2,.T.,{|| nOpca := 0,FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )
	
If nOpca == 1
	Processa( {|lEnd| U_fPrcSC(MV_PAR01,PadR(MV_PAR02,TamSX3('B2_COD')[1]),MV_PAR03,.f.)}, "Aguarde...","Aguarde o Processamento...", .T. )
Endif

RestArea(aArea)
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  fImporta  º Autor ³ Luiz Alberto        º Data ³  06/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Processamento Baixa EDI Cielo                               ±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function fPrcSC(dDtBs,cProdSuc,cAlmSuc)
Local aArea := GetArea()

cQry:= " SELECT SUM(D3_QUANT) TOTAL_PRODUZIDO " 
cQry+= " FROM "+RETSQLNAME("SD3")+" D3 "
cQry+= " WHERE LEFT(D3.D3_EMISSAO,6) = '" +Left(DtoS(dDtBs),6)+ "'
cQry+= " AND LEFT(D3.D3_CF,2) = 'PR'  " 
cQry+= " AND D3.D3_TIPO = 'PA'  " 
cQry+= " AND D3.D3_LOCAL = '98' " 
cQry+= " AND D3.D_E_L_E_T_=''"
			
If Select("TTMP") > 0
	TRD->(dbCloseArea())
EndIf
			
TCQUERY cQry New Alias "TTMP"
			
nTotProduz	:=	TTMP->TOTAL_PRODUZIDO

TTMP->(dbCloseArea())

RestArea(aArea)

If !Empty(nTotProduz)                      
	If !SB2->(dbSetOrder(1), dbSeek(xFilial("SB2")+PadR(cProdSuc,TamSX3('B2_COD')[1])+cAlmSuc))
		MsgStop("Atencao, Nao Localizado Saldo do Produto Sucata !")
		Return .f.
	Endif     
	
	If !(SB2->B2_QFIM > 0)
		Return .F.
	Endif
	
	nSaldoSucata	:=	SB2->B2_QFIM
	
	nSldDistribu	:=	(nSaldoSucata / nTotProduz)
	
	If MsgYesNo("Saldo Sucata: " + TransForm(nSaldoSucata,'@E 9,999,999.999') + " - Total Produzido: " + TransForm(nTotProduz,'@E 9,999,999.999') + ", Deseja Efetuar a Distribuicao de Saldos de Sucatas ?")	
		cQry:= " SELECT D3.R_E_C_N_O_ REGI " 
		cQry+= " FROM "+RETSQLNAME("SD3")+" D3 "
		cQry+= " WHERE LEFT(D3.D3_EMISSAO,6) = '" +Left(DtoS(dDtBs),6)+ "'
		cQry+= " AND LEFT(D3.D3_CF,2) = 'PR'  " 
		cQry+= " AND D3.D3_TIPO = 'PA'  " 
		cQry+= " AND D3.D3_LOCAL = '98' " 
		cQry+= " AND D3.D_E_L_E_T_=''"
				
		TCQUERY cQry New Alias "TTMP"     
		
		Count To nReg
		
		TTMP->(dbGoTop())
		
		Begin Transaction

		ProcRegua(nReg)
		While TTMP->(!Eof()) .And. nSaldoSucata > 0.00
			IncProc("Distribuicao de Saldo de Sucatas, Saldo Restante: " + TransForm(nSaldoSucata, '@E 999,999,999.9999'))
			
			SD3->(dbGoTo(TTMP->REGI))
			
			// Joga os Dados do Registro D3 no Vetor.
			
			aDados := {}
			For nI := 1 To SD3->(FCount())
				AAdd(aDados, {SD3->(FieldName(nI)),SD3->(FieldGet(nI))} )
			Next                    
			
			xQtdDistr	:=	(nSldDistribu * SD3->D3_QUANT)                                     
			
			If xQtdDistr > nSaldoSucata
				xQtdDistr := nSaldoSucata
			Endif
			nSaldoSucata -= xQtdDistr

			/// Efetua Lancamento de Sucata 
			
			For nI := 1 To Len(aDados)    
				If AllTrim(aDados[nI,1])=='D3_TM'
					aDados[nI,2] := '501' 
				ElseIf AllTrim(aDados[nI,1])=='D3_COD'
					aDados[nI,2] := cProdSuc
				ElseIf AllTrim(aDados[nI,1])=='D3_LOCAL'
					aDados[nI,2] := cAlmSuc         
				ElseIf AllTrim(aDados[nI,1])=='D3_QUANT'
					aDados[nI,2] := xQtdDistr
				ElseIf AllTrim(aDados[nI,1])=='D3_CF'
					aDados[nI,2] := 'RE0'
				ElseIf AllTrim(aDados[nI,1])=='D3_CUSTO1'
					aDados[nI,2] := 0.00
				ElseIf AllTrim(aDados[nI,1])=='D3_CUSTO2'
					aDados[nI,2] := 0.00
				Endif
			Next
			
			If RecLock("SD3",.t.)
				For nI := 1 To Len(aDados)
					nPos := SD3->(FieldPos(aDados[nI,1]))
					SD3->(FieldPut(nPos,aDados[nI,2]))
				Next
				SD3->(MsUnlock())
			Endif  
			
			TTMP->(dbSkip(1))
		Enddo
		End Transaction
				
		TTMP->(dbCloseArea())

		MsgInfo("Processamento Efetuado Com Sucesso !")
	Endif	           
	
Endif			

RestArea(aArea)
Return .T.


// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function ValidPerg
Static Function ValidPerg()
_aArea := GetArea()
DbSelectArea("SX1")
DbSetOrder(1)
cPerg := PadR(cPerg,10)

aRegs :={}
Aadd(aRegs,{cPerg,"01","Data Base   ?","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Prod.Sucata ?","mv_ch2","C",TamSX3('B2_COD')[1],0,0,"G","","mv_par02","","","","","","","","","","","","","","","SB1",""})
Aadd(aRegs,{cPerg,"03","Armazem Suc ?","mv_ch3","C",02,0,0,"G","","mv_par03","","","","","","","","","","","","","","","NNR",""})

For i := 1 To Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		SX1->X1_GRUPO   := aRegs[i,01]
		SX1->X1_ORDEM   := aRegs[i,02]
		SX1->X1_PERGUNT := aRegs[i,03]
		SX1->X1_VARIAVL := aRegs[i,04]
		SX1->X1_TIPO    := aRegs[i,05]
		SX1->X1_TAMANHO := aRegs[i,06]
		SX1->X1_DECIMAL := aRegs[i,07]
		SX1->X1_PRESEL  := aRegs[i,08]
		SX1->X1_GSC     := aRegs[i,09]
		SX1->X1_VALID   := aRegs[i,10]
		SX1->X1_VAR01   := aRegs[i,11]
		SX1->X1_DEF01   := aRegs[i,12]
		SX1->X1_CNT01   := aRegs[i,13]
		SX1->X1_VAR02   := aRegs[i,14]
		SX1->X1_DEF02   := aRegs[i,15]
		SX1->X1_CNT02   := aRegs[i,16]
		SX1->X1_VAR03   := aRegs[i,17]
		SX1->X1_DEF03   := aRegs[i,18]
		SX1->X1_CNT03   := aRegs[i,19]
		SX1->X1_VAR04   := aRegs[i,20]
		SX1->X1_DEF04   := aRegs[i,21]
		SX1->X1_CNT04   := aRegs[i,22]
		SX1->X1_VAR05   := aRegs[i,23]
		SX1->X1_DEF05   := aRegs[i,24]
		SX1->X1_CNT05   := aRegs[i,25]
		SX1->X1_F3      := aRegs[i,26]    
		SX1->X1_VALID	:= aRegs[i,27]
		MsUnlock()
		DbCommit()
	Endif
Next

RestArea(_aArea)

Return()


