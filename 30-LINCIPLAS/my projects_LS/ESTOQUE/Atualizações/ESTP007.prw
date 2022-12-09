#INCLUDE "PROTHEUS.CH"    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ                                                             
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ESTP007   ³Autor³ Antonio Carlos         ³ Data ³ 13/04/09 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ajuste de estoque atraves de arquivo dbf 2    			  º±±
±±ºÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄº±±
±±ºModulos   ³ Estoque/Custos                                             º±±
±±ºÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄº±±
±±ºUso       ³ Especifico - Laselva Bookstore                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ESTP007()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis.                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local aArea      := GetArea()
Local nOpcao     := 0
Local cTitulo    := "Importa Arquivo"
Local aButtons   := {}
Local aSays      := {}
Local nOpcao     := 0
Private _cLocal  := Space(50)
Private lMsErroAuto := .F.

DEFINE MSDIALOG oDlg FROM 000,000 TO 200,400 TITLE "Processa Ajustes - TM" PIXEL
			
@ 010,050 SAY "Informe o arquivo: " PIXEL OF oDlg
@ 010,090 MSGET oArq VAR _cLocal PICTURE "@!" SIZE 50,10 PIXEL OF oDlg

@ 070,055 	BUTTON "Processa"		SIZE 040,015 OF oDlg PIXEL ACTION(LjMsgRun("Aguarde..., Processando registros...",, {|| ImportArq() }) ,oDlg:End()) 
@ 070,110 	BUTTON "Fechar"  		SIZE 040,015 OF oDlg PIXEL ACTION(oDlg:End()) 
  		
ACTIVATE MSDIALOG oDlg CENTERED

RestArea(aArea)

Return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processa atualização dos dados, através de arquivos.                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function ImportArq()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis.                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local nQtdReg   := 0
Local lLog      := .F.
Local cItem     := ""
Local lAtuMsg   := .T.
Local nPosOri   := 0
Local lStruct   := .F.
Local nUsado    := 0
Local lValid    := .F.
Local nPos      := 0
Local lOk       := .F. 
Local lAtualiza	:= .F.
Local nLin      := 0                                          
Local x         := 0
Local y         := 0
Local z         := 0
Local nx        := 0      
Local dDtAtu    := CTOD("  /  /  ")
Private cHora   := Time()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida arquivo selecionado.      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If !File(Alltrim(_cLocal))
	Aviso("Informação...","O arquivo selecionado não existe ou não esta disponível no diretório.",;
	{"OK"},1,"Arquivo não existe!!")  
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo temporario.          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//dbUseArea(.T.,,Alltrim(Upper(_cLocal)),"TMP",.F.,.F.) 
dbUseArea(.T.,,Alltrim(_cLocal),"TMP",.F.,.F.) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica estrutura do arquivo.       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aCampos	:= {}
Aadd(aCampos, {"D3_FILIAL"	,		"C",	2,	0})
Aadd(aCampos, {"D3_TM"		,		"C",	3,	0})
Aadd(aCampos, {"D3_COD"		,		"C",	15,	0})
Aadd(aCampos, {"D3_QUANT"	,		"N",	11,	2})
Aadd(aCampos, {"D3_CUSTO1"	,		"N",	14,	2})
Aadd(aCampos, {"D3_LOCAL"	,		"C",	2,	0})
Aadd(aCampos, {"D3_CC"		,		"C",	9,	0})    
Aadd(aCampos, {"D3_EMISSAO"	,		"D",	8,	0})    

cTrab := CriaTrab(aCampos)
DbCreate(cTrab, aCampos)
DbUseArea( .T.,, cTrab, "TAB", .F., .F. )

IndRegua("TAB",cTrab,"D3_FILIAL",,,"Ordenando por Filial")
dbSelectArea("TAB")
For x:=1 To Len(aCampos)		
	lStruct := .F.
	For y:=1 To TAB->(FCount())
		If Alltrim(aCampos[x][1]) == Alltrim(TAB->(FieldName(y)))
			SX3->( DbSetOrder(2) )	
			If SX3->(DbSeek(Alltrim(TAB->(FieldName(y)))))	
				If Valtype(TAB->&(FieldName(y))) == SX3->X3_TIPO
					lStruct := .T.  
				EndIf
			EndIf
		EndIf
	Next y

	If !lStruct
		Aviso("Atenção","O arquivo possui campos que não pertencem a estrutura da tabela ou formato está divergente. Contate o"+;
		" administrador do sistema ou verifique se o arquivo foi criado corretamente.",{"OK"},1,"Falha de estrutura!")
		TAB->(DBCLOSEAREA())
		Return
	EndIf
Next x

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Conta a quantidade de registros do arquivo.       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄSÄÄÄÄÄÙ

DbSelectArea("TMP")
TMP->( DbGoTop() )
While TMP->( !Eof() )
	
	DbSelectArea("TAB")
	
	RecLock("TAB",.T.)
	Replace TAB->D3_FILIAL	With TMP->D3_FILIAL
	Replace TAB->D3_COD 	With TMP->D3_COD
	Replace TAB->D3_QUANT	With TMP->D3_QUANT
	//Replace TAB->D3_QUANT	With 0
	Replace TAB->D3_CUSTO1 	With TMP->D3_CUSTO1
	Replace TAB->D3_LOCAL	With TMP->D3_LOCAL
	Replace TAB->D3_TM 		With TMP->D3_TM	
	//Replace TAB->D3_CC 		With TMP->D3_CC
	Replace TAB->D3_EMISSAO	With TMP->D3_EMISSAO
	MsUnLock() 
	
	nQtdReg++
	
	TMP->( DbSkip() )
	
EndDo

If nQtdReg > 0
	
	ProcRegua( nQtdReg )
	
	aCab 	:= {}
	aItens	:= {}
	aTotitem:= {}
	
	DbSelectArea("TAB")
	TAB->( DbGoTop() ) 
	TAB->( DbSeek(xFilial("SD3")) )	
	
	While TAB->( !Eof() )
	
		aTotitem	:= {}
		aItens		:= {}
		dDtAtu 		:= TAB->D3_EMISSAO
		
		While TAB->( !Eof() ) .And. TAB->D3_FILIAL == xFilial("SD3") .And. TAB->D3_EMISSAO == dDtAtu            
		
			IncProc("Incluindo itens... ")                                                                      
	
			cTm 	:= Alltrim(TAB->D3_TM)
			cCC 	:= Alltrim(TAB->D3_CC)

			lAtualiza := .T.		
		
			aCab 	:= { {"D3_TM" ,Alltrim(TAB->D3_TM),NIL},;
					{"D3_CC" ,TAB->D3_CC ,NIL},;
					{"D3_EMISSAO" ,TAB->D3_EMISSAO ,NIL}}
	
			DbSelectArea("SF5")
			SF5->( DbSetOrder(1) )
			If SF5->( DbSeek(xFilial("SF5")+Alltrim(TAB->D3_TM)) )
			
				DbSelectArea("SB1")
				DbSetOrder(1)
				If SB1->( DbSeek(xFilial("SB1")+Alltrim(TAB->D3_COD)) )
					Aadd(aItens, {"D3_COD"    	,Alltrim(TAB->D3_COD),NIL})                                            
					Aadd(aItens, {"D3_UM"    	,SB1->B1_UM    ,NIL})                                            
					Aadd(aItens, {"D3_QUANT"  	,TAB->D3_QUANT  ,NIL})
					Aadd(aItens, {"D3_LOCAL"  	,Alltrim(TAB->D3_LOCAL),NIL})
	    		
		    		If SF5->F5_VAL = "S"
						Aadd(aItens, {"D3_CUSTO1"	,TAB->D3_CUSTO1 ,NIL})
  					EndIf
  				
	  			Else	
					lAtualiza := .F.  			
  				EndIf	
  			
			Else
   				lAtualiza := .F.
			EndIf  

		    Aadd(aTotitem,aItens)
			aItens:={}
		
			If cTm <> Alltrim(TAB->D3_TM) .OR. cCC <> Alltrim(TAB->D3_CC)
				lAtualiza := .F.
	    	EndIf
    
	    	cTm := Alltrim(TAB->D3_TM)
		    cCC	:= Alltrim(TAB->D3_CC)
	
			TAB->( DbSkip() )

		EndDo                  
		
		If lAtualiza
			MSExecAuto({|x,y,z| MATA241(x,y,z)},aCab,aTotitem,3)
		Else
			Aviso("Atenção","O arquivo possui campos que não pertencem a estrutura da tabela ou formato está divergente. Contate o"+;
			" administrador do sistema ou verifique se o arquivo foi criado corretamente.",{"OK"},1,"Falha de estrutura!")
		EndIf

		If lMsErroAuto
			MostraErro()
		EndIf
		
	EndDo	
	
	Aviso("Atenção","Processamento efetuado com sucesso!",{"OK"},1,"Mensagem!")	

Else

	Aviso("Atenção","Nao existem registros para processamento!",{"OK"},1,"Arquivo vazio!")
	
EndIf	

DbSelectArea("TMP")
DbCloseArea()

TAB->(DbCloseArea())
Ferase("TAB")

Return