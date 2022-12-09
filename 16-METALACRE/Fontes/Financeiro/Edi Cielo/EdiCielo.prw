#INCLUDE "TOPCONN.CH"
#include "rwmake.ch"
#include "ap5mail.ch"
#include "tbiconn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ EdiCielo   º Autor ³ Luiz Alberto     º Data ³  09/08/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescrição ³ Importacao Arquivo EDI Cielo e Processamento Baixa Financeiro
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Exclusivo Metalacre                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#DEFINE CIE_IDPAY	001
#DEFINE CIE_DTVEN	002
#DEFINE CIE_VALOR	003
#DEFINE CIE_VLREA	004
#DEFINE CIE_REJEI	005
#DEFINE CIE_PREFI	006
#DEFINE CIE_TITUL	007
#DEFINE CIE_PARCE	008
#DEFINE CIE_CLIEN	009
#DEFINE CIE_LOJA	010
#DEFINE CIE_NOME	011
#DEFINE CIE_EMISS	012
#DEFINE CIE_VECTO	013
#DEFINE CIE_VLTIT	014
#DEFINE CIE_PEDWB	015
#DEFINE CIE_PEDID	016
#DEFINE CIE_SALDO	017
#DEFINE CIE_DTBAI	018
#DEFINE CIE_RECNO	019

 
User Function EdiCielo()
Local aArea := GetArea()
Local 	aSays      	:= {}
Local 	aButtons   	:= {}
Local 	nOpca    	:= 0    
Local	cCadastro	:=	'Baixa Financeiro com EDI Cielo'
Private cPerg := PadR('EDICIELO',10)

ValidPerg()

Pergunte(cPerg,.f.)

AADD (aSays, "Este programa tem por objetivo efetuar o processamento de ")
AADD (aSays, "baixa de titulos referente pagamentos com cartao de credtio")
AADD (aSays, "da CIELO, com opção de pré-impressão dos relacionamentos   ")
AADD (aSays, "de titulos localizados no financeiro x Arquivo EDIT.")

AAdd(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. )    }} )
AAdd(aButtons, { 1,.T.,{|| nOpca := 1,FechaBatch() }} )
AAdd(aButtons, { 2,.T.,{|| nOpca := 0,FechaBatch() }} )
aAdd(aButtons, { 6,.T.,{|| nOpca := 4,FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )
	
If nOpca == 1
	Processa( {|lEnd| U_fImporta(MV_PAR04,.f.)}, "Aguarde...","Aguarde o Processamento...", .T. )
ElseIf nOpca == 4
	Processa( {|lEnd| U_fImporta(MV_PAR04,.t.)}, "Aguarde...","Aguarde Gerando Relatorio...", .T. )
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
User Function fImporta(cArquivo,lImpressao)
Local aCabec  := {}  
Local aItens  := {}
Local aCliente:= {}
Local aFornece:= {}
Local nCont   := 0	
LOCAL nHdl:= nHdlA := 0
Local nX
Local nTamFile, nTamLin, cBuffer, nBtLidos
Local lExiste := .T.
Local lHabil  := .F.
Private nHdl  := 0
Private cEOL  := "CHR(8)"
Private aRelacao := {}

If Empty(Alltrim(cArquivo))
	Alert("Nao existem arquivos para importar. Processo ABORTADO")
	Return.F.	
EndIf

//+---------------------------------------------------------------------+
//| Abertura do arquivo texto                                           |
//+---------------------------------------------------------------------+
cArqTxt := cArquivo

nHdl := fOpen(cArqTxt,0 )
IF nHdl == -1
	IF FERROR()== 516
		ALERT("Feche o programa que gerou o arquivo.")
		Return 
	EndIF
EndIf
	
//+---------------------------------------------------------------------+
//| Verifica se foi possível abrir o arquivo                            |
//+---------------------------------------------------------------------+
If nHdl == -1
	MsgAlert("O arquivo de nome "+cArquivo+" nao pode ser aberto! Verifique os parametros.","Atencao!" )
	Return
Endif
	
If !SA6->(dbSetOrder(1), dbSeek(xFilial("SA6")+MV_PAR01+MV_PAR02+MV_PAR03))
	Alert("Banco, Agencia e Conta Não Localizados !!!")
	Return
Endif

cBanco := MV_PAR01
cAgencia:= MV_PAR02
cConta := MV_PAR03

FSEEK(nHdl,0,0 )
nTamArq:=FSEEK(nHdl,0,2 )
FSEEK(nHdl,0,0 )
fClose(nHdl)

FT_FUse(cArquivo )  //abre o arquivo
FT_FGoTop()         //posiciona na primeira linha do arquivo
//nTamLinha := AT(cEOL,cBuffer )
nTamLinha := Len(FT_FREADLN() ) //Ve o tamanho da linha
FT_FGOTOP()
	
//+---------------------------------------------------------------------+
//| Verifica quantas linhas tem o arquivo                               |
//+---------------------------------------------------------------------+
nLinhas := FT_FLastRec() 

ProcRegua(nLinhas)

While !FT_FEOF()
	IF nCont > nLinhas
		exit
	endif   
	IncProc("Lendo a Linha "+Alltrim(str(nCont)))
	cLinha := Alltrim(FT_FReadLn())
	nRecno := FT_FRecno() // Retorna a linha corrente

	If Empty(cLinha )
		FT_FSKIP()  
		nCont++
		Loop
	endif

	// Efetuando Relacionamento de EDI Cielo com Titulo no Contas a Receber
	
	If Left(cLinha,1) == '0'	// Header do Arquivo - 04 Identifica Arquivo de Pagamento CIELO
		If SubStr(cLinha,48,2)<>'04'
			MsgStop("Atenção Este Arquivo não se Refere ao Extrato de Pagamento, Verifique, Linha 1 Posição 48 a 49 deve ser código 04 !")
			Exit
		Endif
	ElseIf Left(cLinha,1) == '1'	// Pega Valor Real Pagamento
		nVlrChei	:=	Round(Val(SubStr(cLinha,45,13))/100,2)	// Valor total da Venda ou da Parcela
		nVlrReal	:=	Round(Val(SubStr(cLinha,87,13))/100,2)	// Valor total da Venda ou da Parcela
		nPercDsc	:=	Round(100-Round((nVlrReal/nVlrChei)*100,6),6)
	ElseIf Left(cLinha,1) == '2'	// Registro de Pagamento
		cIdPay	:=	SubStr(cLinha,73,20)	// TID
		dDtVen	:=	StoD(SubStr(cLinha,38,8))	// Data da Venda
		nValor	:=	Round(Val(SubStr(cLinha,47,13))/100,2)	// Valor total da Venda ou da Parcela
		cRejeita:=	SubStr(cLinha,64,3)	// Codigo de Rejeicao
				
		AAdd(aRelacao,{cIdPay,;
						dDtVen,;
						nValor,;
						Round(nValor-((nValor*nPercDsc)/100),2),;
						cRejeita,;
						'',;	// Prefixo,;
						'',;  	// Titulo,;
						'',;	// Parcela,;
						'',;	// Cliente,;
						'',;	// Loja,;
						'',;	// Nome Cliente,;
						CtoD(''),;	// Emissao,;
						CtoD(''),;	// Vencimento,;
						0,;		// Valor,;
						'',;	// Pedido Web,;
						'',;	// Pedido Interno,;
						0,;		// Saldo,;
						CtoD(''),;	// Data da Baixa
						0})		// E1 RECNO

		If Empty(cRejeita)
			cQry:= " SELECT TOP 1 R_E_C_N_O_ REGIS " 
			cQry+= " FROM "+RETSQLNAME("SE1")+" E1"
			cQry+= " WHERE E1_IDPAY = '" +cIdPay+ "'
			cQry+= " AND E1.E1_FILIAL ='" + xFilial("SE1") + "' " 
			cQry+= " AND E1.D_E_L_E_T_=''"
			
			If Select("TTMP") > 0
				TRD->(dbCloseArea())
			EndIf
			
			TCQUERY cQry New Alias "TTMP"
			
			nReg := TTMP->REGIS
			
			TTMP->(dbCloseArea())
			
			If !Empty(nReg)
				SE1->(dbGoTo(nReg))

				If SE1->E1_EMISSAO > aRelacao[Len(aRelacao),CIE_DTVEN]
					If RecLock("SE1",.f.)
						SE1->E1_EMISSAO	:=	aRelacao[Len(aRelacao),CIE_DTVEN]
						SE1->(MsUnlock())
					Endif
				Endif
				
				SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA))
				SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+SE1->E1_PEDIDO))
				
				aRelacao[Len(aRelacao),CIE_PREFI]	:=	SE1->E1_PREFIXO
				aRelacao[Len(aRelacao),CIE_TITUL]	:=	SE1->E1_NUM
				aRelacao[Len(aRelacao),CIE_PARCE]	:=	SE1->E1_PARCELA
				aRelacao[Len(aRelacao),CIE_CLIEN]	:=	SE1->E1_CLIENTE
				aRelacao[Len(aRelacao),CIE_LOJA]	:=	SE1->E1_LOJA
				aRelacao[Len(aRelacao),CIE_NOME]	:=	SA1->A1_NREDUZ
				aRelacao[Len(aRelacao),CIE_EMISS]	:=	SE1->E1_EMISSAO
				aRelacao[Len(aRelacao),CIE_VECTO]	:=	SE1->E1_VENCREA
				aRelacao[Len(aRelacao),CIE_VLTIT]	:=	SE1->E1_VALOR
				aRelacao[Len(aRelacao),CIE_PEDWB]	:=	SC5->C5_PEDWEB
				aRelacao[Len(aRelacao),CIE_PEDID]	:=	SE1->E1_PEDIDO
				aRelacao[Len(aRelacao),CIE_SALDO]	:=	SE1->E1_SALDO
				aRelacao[Len(aRelacao),CIE_DTBAI]	:=	SE1->E1_BAIXA
				aRelacao[Len(aRelacao),CIE_RECNO]	:=	nReg
			Else                                                      
				aRelacao[Len(aRelacao),CIE_NOME]	:=	'(Nao Localizado)'
			Endif
		Endif							
	Endif	


	FT_FSKIP()  
	nCont++
EndDo		
FT_FUSE()
fClose(nHdl )


If !lImpressao .And. Len(aRelacao)>0	// Senão for Impressao Inicia o Processo de Baixa
	If !MsgYesNo("Deseja Iniciar o Processamento de Baixa dos Titulos Pagamento CIELO ?")	
		Return .f.
	Endif
				
	ProcRegua(Len(aRelacao))	
	For nI := 1 To Len(aRelacao)
		IncProc("Processando Baixas, Aguarde... ")
		Begin Transaction
		
		SE1->(dbGoTo(aRelacao[nI,CIE_RECNO]))
		If SE1->E1_SALDO > 0.00 .And. SE1->E1_SALDO>=aRelacao[nI,CIE_VALOR]
			
			nVlrTax := Round(aRelacao[nI,CIE_VALOR]-aRelacao[nI,CIE_VLREA],2)	// Valor da Venda - Valor Recebido = Taxa do Cartao
			nVlrRec := aRelacao[nI,CIE_VLREA]
			
			//Baixa Automatica dos Titulos a Receber da VetFin
			aVetorSE1 := {}
			lMsErroAuto = .F.
			aVetorSE1 := {		{"E1_PREFIXO"		,SE1->E1_PREFIXO   	,Nil},;
								{"E1_NUM"		 	,SE1->E1_NUM       	,Nil},;
								{"E1_PARCELA"	 	,SE1->E1_PARCELA    ,Nil},;
								{"E1_TIPO"	    	,SE1->E1_TIPO      	,Nil},;
								{"AUTBANCO"			,PadR(cBanco,TamSX3("E5_BANCO")[1]),Nil},;
								{"AUTAGENCIA"		,PadR(cAgencia,TamSX3("E5_AGENCIA")[1])      		,Nil},;
								{"AUTCONTA"			,PadR(cConta,TamSX3("E5_CONTA")[1])				,Nil},;
								{"AUTMOTBX"	    	,"NOR" 				,Nil},;
								{"AUTDTBAIXA"      	,dDataBase     		,Nil},;
								{"AUTDTCREDITO"		,dDataBase     		,Nil},;
								{"AUTHIST"	    	,"Baixa CIELO"		,Nil},;
      							{"AUTDESCONT"	 	,nVlrTax			,Nil},;
      							{"AUTVALREC"	 	,nVlrRec			,Nil}}
	      
   			MSExecAuto({|x,y| fina070(x,y)},aVetorSE1,3)
											
			If lMsErroAuto
				MostraErro()
				DisarmTransaction()
				MsgStop("Atencao Erro na Baixa do Titulo " + SE1->E1_NUM + " Processamento Abortado !")
				Return .F.				
		    Endif 
		Endif	    
			
		End Transaction
		
    Next
Else 
	U_fImpCielo(aRelacao)
Endif
Return



// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function ValidPerg
Static Function ValidPerg()
_aArea := GetArea()
DbSelectArea("SX1")
DbSetOrder(1)
cPerg := PadR(cPerg,10)

aRegs :={}
Aadd(aRegs,{cPerg,"01","Banco                   ?","mv_ch1","C",03,0,0,"G","","mv_par01","","","","","","","","","","","","","","","SA6",""})
Aadd(aRegs,{cPerg,"02","Agencia                 ?","mv_ch2","C",05,0,0,"G","","mv_par02","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Conta		            ?","mv_ch3","C",10,0,0,"G","","mv_par03","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"04","Arquivo EDI Cielo       ?","mv_ch4","C",50,0,0,"G","","mv_par04","","","","","","","","","","","","","","","DIR",""})

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


