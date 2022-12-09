#include "Protheus.ch"
#INCLUDE "Rwmake.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ RFATA023 ³ Autor ³ ROBSON BUENO          ³ Data ³ 18/01/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ CONTROLE DE INSPECAO                                       ³±±	
±±³           ³ CHAMADA PELA FUNCAO MODELO2()                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ REMOTE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
user Function RFATA023()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ DECLARAR AS VARIAVEIS aROTINA E cCADASTRO COMO PRIVATE,  ³
//³ PORQUE A FUNCAO mBROWSE ESTA ESPERANDO....               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aRotina := {}
Private cCadastro := "CONVOCACAO DE INSPECAO"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MONTAR O VETOR aROTINA, OBRIGATORIO PARA UTILIZACAO DA   ³
//³ FUNCAO mBROWSE                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd( aRotina, { "Pesquisar " , "AxPesqui   " , 0 , 1 })
aAdd( aRotina, { "Visualizar" , "u_RFAT23I  " , 0 , 2 })
aAdd( aRotina, { "Incluir   " , "u_RFAT23I   "   , 0 , 3 })
aAdd( aRotina, { "Alterar   " , "u_RFAT23I   "   , 0 , 4 })
aAdd( aRotina, { "Excluir   " , "u_RFAT23I   "   , 0 , 5 })
aAdd( aRotina, { "Reg.Previsao" , "u_RFT023PA  "   , 0 , 6 }) 
aAdd( aRotina, { "Canc.Previsao" , "u_RFT023Pc  "   , 0 , 7 })
aAdd( aRotina, { "Reg.Inspecao" , "u_RFT023Pe  "   , 0 ,8 })
aAdd( aRotina, { "Envia Solic" , "u_RFT023Pf  "   , 0 ,9 }) 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SELECIONAR A TABELA, ORDEM E POSICIONAR NO PRIMEIRO      ³
//³ REGISTRO DA TABELA                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("PB1")
dbSetOrder(1)
dbGoTop()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ EXECUTAR A FUNCAO mBROWSE PARA TABELA MENCIONADA         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
mBrowse(6,1,22,75,"PB1")
Return nil


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³RFAT23I   ³ Autor ³ Robson Bueno          ³ Data ³ 18/01/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ TRATANDO AS OPCOES DA MBROWSE                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ REMOTE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFAT23I(cAlias,nReg,nOpc)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ DECLARACAO DE VARIAVEIS³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cChave := ""
Local nCOLS  := 0
Local i 	 := 0
Local lRet   :=.F.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VARIAVEIS QUE SERVIRAO DE PARAMETROS PARA A FUNCAO MODELO2³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cTitulo  := cCadastro
Private aC       := {}
Private aR       := {}
Private aCGF     := {}
Private cLinOk   := "u_PB1LIOK()"
Private cAllOk   := "u_PB1TudOk()"
Private aGetsGD  := {}
Private bF4      := {|| }
Private cIniCpos := "+PB1_SEQ"
Private nMax     := 999
Private aCordW   := {0,0,600,1000}
Private lDelGetD := .T.
Private aHeader  := {}
Private aCOLS    := {}
Private nCount   := 0
Private bCampo   := {|nField| FieldName(nField) }
// VARIAVEIS DO MODULO
Private cNumero := Space(9)
Private cCliente:=Space(6)
Private cLoja   :=Space(2)
Private dData   := ctod("  /  /  ")
//Private dData    := Ctod(" / / ")
//Private cNumero  := Space(6)

Private cRevisao:= Space(2)
Private cFornec	:= Space(6)
Private cForLoj	:= Space(2)
Private cNomeFor:= Space(60)


Private aAlt     := {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CRIA VARIAVEIS DE MEMORIA M->???³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOpc = 3
  cNumero:=GETSX8NUM("PB1","PB1_NUMERO") 
  dData:=date()                                                                                                                                                                                                                           
endif
dbSelectArea(cAlias)
For i := 1 To FCount()
	M->&(Eval(bCampo,i)) := CriaVar(FieldName(i),.T.)
Next nX
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CRIA VETOR aHEADER CONFORME DICIONARIO DE DADOS³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek(cAlias)
While !Eof() .And. SX3->X3_ARQUIVO == cAlias
	If X3Uso(X3_USADO) .And. cNivel >= X3_NIVEL .And. ;
	                   !(Trim(X3_CAMPO)$"PB1_NUMERO")   .And. ;
	                   !(Trim(X3_CAMPO)$"PB1_REVISA")	.AND. ;
	                   !(TRIM(X3_CAMPO)$"PB1_DATAC") .and. ;
	                   !(TRIM(X3_CAMPO)$"PB1_CLI") .AND.;
	                   !(TRIM(X3_CAMPO)$"PB1_LOJA") .AND. ;
	                   !(TRIM(X3_CAMPO)$"PB1_DATAC") .and. ;
	                   !(Trim(X3_CAMPO)$"PB1_FORNEC") .AND. ;
	                   !(Trim(X3_CAMPO)$"PB1_FORLOJ") .AND. ;
	                   !(Trim(X3_CAMPO)$"PB1_NOMFO")
	                   	                    
        aAdd(aHeader,{TRIM(X3_TITULO) ,;
							X3_CAMPO   ,;
							X3_PICTURE ,;
							X3_TAMANHO ,;
							X3_DECIMAL ,;
							X3_VALID ,;
							X3_USADO ,;
							X3_TIPO ,;
							X3_ARQUIVO ,;
							X3_CONTEXT })
	Endif
	dbSkip()
End
dbSelectArea(cAlias)
dbSetOrder(1)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SE A OPCAO FOR DIFERENTE DE INCLUIR, ENTAO ATRIBUIR  ³
//³ OS DADOS NO VETOR aCOLS. CASO CONTRARIO, CRIAR O     ³
//³ VETOR aCOLS COM A CARACTERISTICA DE CADA CAMPO       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOpc <> 3
	cNumero  := (cAlias)->PB1_NUMERO
    cCliente := (cAlias)->PB1_CLI
    cLoja    := (cAlias)->PB1_LOJA
	dData    := (cAlias)->PB1_DATAC
	/*
	cRevisao	:= (cAlias)->PB1_REVISA
	cFornec		:= (cAlias)->PB1_FORNEC
	cForLoj		:= (cAlias)->PB1_FORLOJ
	cNomeFor	:= (cAlias)->PB1_NOMFOR	
    */
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ DEVE-SE POSICIONAR, PORQUE NUNCA SE SABE EM QUAL ITEM³
	//³ ESTA, E NECESSARIO PEGAR TODOS OS ITENS.             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSeek(xFilial(cAlias)+cNumero)
	While !Eof() .And. (cAlias)->(PB1_FILIAL+PB1_NUMERO) == xFilial(cAlias)+ cNumero
    	//
		// Criar o vetor com sua devida dimensão em relação ao dicionário de dados 
		//
		aAdd(aCOLS,Array(Len(aHeader)+1))
		nCOLS++
		//
		// Atribuir o dado para cada coluna do vetor 
		//
		For i := 1 To Len(aHeader)
			If aHeader[i,10]<>"V"
				aCOLS[nCOLS,i] := FieldGet(FieldPos(aHeader[i,2]))
			Else
				aCOLS[nCOLS,i] := CriaVar(aHeader[i,2],.T.)
			Endif
		Next i
		//
		// Criar uma última coluna para o controle da Getdados, se deletado ou não 
		//
		aCOLS[nCOLS,Len(aHeader)+1] := .F.
		//
		// Atribuir o número do registro neste vetor para o controle na gravação 
		//
		aAdd(aAlt,RecNo())
		dbSelectArea(cAlias)
		dbSkip()
	End
Else
	//
	// Atribuir à variável o inicializador padrão do campo 
	//
   	//cNorma := GetSxeNum("SZN","ZN_COD")
   	//cNormad:= GetSxeNum("SZN","ZN_NORMA")
    //cNormat:= GetSxeNum("SZN","ZN_DESCRI")
	//
	// Criar o vetor com sua devida dimensão em relação ao dicionário de dados 
	//
  	aAdd(aCOLS,Array(Len(aHeader)+1))
	For i := 1 To Len(aHeader)
		aCOLS[1,i] := CriaVar(aHeader[i,2])
	Next i
	//
	// Criar uma última coluna para o controle da Getdados, se deletado ou não 
	//
	aCOLS[1,Len(aHeader)+1] := .F.
	
	//
	// Atribuir 01 para a primeira linha da Getdados
	//
	aCOLS[1,aScan(aHeader,{|x|Trim(x[2])=="PB1_SEQ"})] := "001"
	aCOLS[1,aScan(aHeader,{|x|Trim(x[2])=="PB1_DATAR"})] := CTOD("  /  /  ")
	aCOLS[1,aScan(aHeader,{|x|Trim(x[2])=="PB1_DATAI"})] := CTOD("  /  /  ")
	aCOLS[1,aScan(aHeader,{|x|Trim(x[2])=="PB1_DTCLM"})] := CTOD("  /  /  ")
Endif
//
//Característica do vetor
// aC[n,1] = Nome da Variavel Ex.:"cCliente"
// aC[n,2] = Array com coordenadas do Get [x,y] em PIXEL 
// aC[n,3] = Titulo do Campo
// aC[n,4]=Picture
// aC[n,5] = Validacao
// aC[n,6]=F3
// aC[n,7] = Se campo e editavel .T. se nao .F. 
//
aAdd(aC,{"cNumero",		{15,08}	,"Numero da Convocacao","@!",,,.T.})

aAdd(aC,{"cRevisao",	{15,130},"Revisao","@!",,,.T.})

aAdd(aC,{"dData",		{30,08}/*{15,200}*/,"Emissao",,,,.T.})

aAdd(aC,{"cCliente",	/*{30,08}*/{45,08}	,"Cliente             ","@!",,"SA1",.T.})
aAdd(aC,{"cLoja",		/*{30,200}*/{45,150},"Loja   ","@!",,,.T.})

aAdd(aC,{"cFornec",		{60,08},"Fornecedor","@!",,"SA2",.T.})
aAdd(aC,{"cForLoj",		{60,150},"Loja","@!",,,.T.})
aAdd(aC,{"cNomeFor",	{60,208},"Nome Fornecedor","@!",,,.F.})

//                                                                    
// Coordenada do objeto Getdados 
//
aCGD:={150,5,200,315}
//aCGD:={44,5,118,315}

//
// Validacao na mudanca de linha e quando clicar no botao Ok 
//

//
// Atribuir a database do sistema a variável
//
IF NOPC=1
  dData := dDataBase
ENDIF
//
// Executar a função Modelo2() 
//
lRet := Modelo2(cTitulo,aC,aR,aCGD,nOpc,cLinOk,cAllOk,,,cIniCpos,nMax,aCordW)
//      Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLineOk,cAllOk,aGetsGD,bF4,cIniCpos,nMax,aCordW,lDelGetD,lMaximized, aButtons)

// Se confirmado...
//
If lRet
	//
	// Se opção for inclusao 
	//
	If nOpc == 3
		If MsgYesNo("Confirma gravacao dos dados ?",cTitulo)
			Processa({|| IncluPB1(cAlias)},cTitulo,"Gravando os dados, aguarde...")
		Endif
	//
	// Se opção for alteração
	//
	Elseif nOpc == 4
		If MsgYesNo("Confirma alteração dos dados ?",cTitulo)
			Processa({|| AlterPB1(cAlias)},cTitulo,"Alterando os dados, aguarde...")
		Endif
	//
	// Se opção for exclusão 
	//
	Elseif nOpc == 5
		If MsgYesNo("Confirma eliminação dos dados ?",cTitulo)
			Processa({|| ExcluPB1(cAlias)},cTitulo,"Excluíndo os dados, aguarde...")
		Endif
	Endif
Else
	//
	// Se não confirmado, reestabelecer a númeração automática do cadastro
	//
	RollBackSX8()
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³AlterPB1  ³ Autor ³ ROBSON BUENO          ³ Data ³ 18/01/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ ALTERACAO DOS REGISTROS DA PB1                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ Manorma                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AlterPB1(cAlias)

Local i := 0
Local y := 0

ProcRegua(Len(aCOLS))
dbSelectArea(cAlias)
dbSetOrder(1)

For i:=1 To Len(aCOLS)
	If i<=Len(aAlt)
		dbGoTo(aAlt[i])
		RecLock(cAlias,.F.)
		If aCOLS[i,Len(aHeader)+1]
			dbDelete()
		Else
			For y := 1 To Len(aHeader)
				FieldPut(FieldPos(Trim(aHeader[y,2])),aCOLS[i,y])
			Next y
			(cAlias)->PB1_NUMERO := cNumero
			(cAlias)->PB1_DATAC  := dData
			(cAlias)->PB1_CLI    := cCliente
			(cAlias)->PB1_LOJA   := cLoja
			(cAlias)->PB1_NOME   := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_NREDUZ")
		Endif
		MsUnLock()
	Else
		If !aCOLS[i,Len(aHeader)+1]
			RecLock(cAlias,.T.)
			For y := 1 To Len(aHeader)
				FieldPut(FieldPos(Trim(aHeader[y,2])),aCOLS[i,y])
			Next y
		    (cAlias)->PB1_NUMERO := cNumero
			(cAlias)->PB1_DATAC  := dData
			(cAlias)->PB1_CLI    := cCliente
			(cAlias)->PB1_LOJA   := cLoja
			(cAlias)->PB1_NOME   := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_NREDUZ")
			MsUnLock()
		Endif
	Endif
Next i

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ExcluPB1  ³ Autor ³ ROBSON BUENO          ³ Data ³ 18/01/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ EXCLUSAO DE REGISTROS DA PB1                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ Manorma                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ExcluPB1(cAlias)

ProcRegua(Len(aCOLS))

dbSelectArea(cAlias)
dbSetOrder(1)
dbSeek(xFilial(cAlias)+cNumero)

While !Eof() .And. (cAlias)->PB1_FILIAL == xFilial(cAlias) .And. (cAlias)->PB1_NUMERO == cNumero
	IncProc()
	dbselectarea("PC2")
    dbSetOrder(6)
    MsSeek(xfilial("PC2")+(cAlias)->PB1_NUMERO+(cAlias)->PB1_ITEM+"CV INSPECAO N.:"+(cAlias)->PB1_NUMERO+" - "+(cAlias)->PB1_SEQ)
    IF SUBSTRING(PC2->PC2_INF,1,29)="CV INSPECAO N.:"+(cAlias)->PB1_NUMERO+" - "+(cAlias)->PB1_SEQ
       // Primeiramente Verifica se tem processo posterior registrado
       IF U_HCIPDPR(PC2->PC2_NUM,PC2->PC2_ITEM,PC2->PC2_CTR)=.T.  // PEDIDO - ITEM - CONTROLE
         U_HCIEXPR(PC2->PC2_NUM,PC2->PC2_ITEM,PC2->PC2_CTR) 
       ELSE
         lOkOP:=.F.
       ENDIF  
    ENDIF
	RecLock(cAlias,.F.)
	dbDelete()
	MsUnLock()
	dbSkip()
End

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³IncluPB1  ³ Autor ³ ROBSON BUENO          ³ Data ³ 18/01/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ INCLUINDO REGISTROS NA PB1                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ Manorma                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IncluPB1(cAlias)

Local i := 0
Local y := 0

ProcRegua(Len(aCOLS))
dbSelectArea(cAlias)
dbSetOrder(1)

For i := 1 To Len(aCOLS)
	IncProc()
	If !aCOLS[i,Len(aHeader)+1]
		RecLock(cAlias,.T.)
		For y := 1 To Len(aHeader)
			FieldPut(FieldPos(Trim(aHeader[y,2])),aCOLS[i,y])
		Next y
		(cAlias)->PB1_FILIAL := xFilial(cAlias)
      	(cAlias)->PB1_NUMERO := cNumero
		(cAlias)->PB1_DATAC  := dData
		(cAlias)->PB1_CLI    := cCliente
		(cAlias)->PB1_LOJA   := cLoja 
		(cAlias)->PB1_NOME   := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_NREDUZ")
		(cAlias)->PB1_DATAR  :=CTOD("  /  /  ")
		(cAlias)->PB1_DATAI  :=CTOD("  /  /  ")
		(cAlias)->PB1_DTCLM  :=CTOD("  /  /  ")
	     MsUnLock()
	     // TRATA CONTROLE DE PROCESSO
	     dbselectarea("PC2")
         dbSetOrder(4)                                            	
         MsSeek(xfilial("PC2")+(cAlias)->PB1_PEDIDO+(cAlias)->PB1_ITEM+"000018")
         if PC2->PC2_QTDORI-PC2->PC2_QTD>0 .and. PC2->PC2_NUM=(cAlias)->PB1_PEDIDO .AND. (cAlias)->PB1_ITEM=PC2->PC2_ITEM .AND. PC2->PC2_SEQ="000018"
           cRegistro:=PC2->PC2_CTR
           // 2 BAIXA O FATURAMENTO OS E POE EM AGUARDANDO RECEBIMENTO
           U_HCICTPR((cAlias)->PB1_PEDIDO,(cAlias)->PB1_ITEM,"000018","000019",(cAlias)->PB1_QTD,"Aguardando Previsao","","","CV INSPECAO N.:"+(cAlias)->PB1_NUMERO+" - "+(cAlias)->PB1_SEQ,cRegistro,(cAlias)->PB1_DATAC+5) 
         endif
	     // FIM TRATAMENTO
	Endif
Next i
ConfirmSX8()
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³PB1TUDOK  ³ Autor ³ ROBSON BUENO          ³ Data ³ 18/01/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ VALIDANDO TUDO OK PARA GRAVACAO                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ Manorma                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PB1TUDOK()

Local lRet 	:= .T.
/*
Local i 	:= 0
Local nDel 	:= 0

For i:=1 To Len(aCOLS)
	If aCOLS[i,Len(aHeader)+1]
		nDel++
	Endif
Next i

If nDel == Len(aCOLS)
	MsgInfo("Para excluir todos os itens, utilize a opcao EXCLUIR",cTitulo)
	lRet:=.F.
Endif
*/
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³PB1LIOK   ³ Autor ³ ROBSON BUENO          ³ Data ³ 18/01/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ VALIDANDO LINHA DO CONTROLE DE INSPECAO                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ Manorma                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PB1LIOK()
Local aArea := (GetArea())         
Local lRet 	:= .T.
/*
nPesot:=nPembal
FOR X=1 TO LEN(ACOLS)
 If aCOLS[X,Len(aHeader)+1]
 ELSE
  nPesot:=nPesot+acols[x,10] 
 ENDIF
Next
cRefcli:=Posicione("SC5",1,xFilial("SC5")+acols[1,2],"C5_COTCLI")
IF Posicione("SB1",1,xFilial("SB1")+acols[N,4],"B1_PESO")<>acols[N,7]
  If MsgYesNo("O PESO do Produto no romaneio esta diferente do valor obtido do cadastro de produto. Deseja alterar cadastro de produto?",cTitulo)
      dbSelectArea("SB1")
	  dbSetOrder(1)
	  IF MsSeek(xFilial("SB1")+acols[N,4])
        Reclock("SB1",.F.)
        SB1->B1_PESO:=acols[N,7]
        MsUnLock()
      ENDIF
  ENDIF
ENDIF 
*/
RestArea(aArea)
Return(lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³RF023GP   ³ Autor ³ ROBSON BUENO          ³ Data ³ 18/01/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ TRATAMENTO DO CODIGO DO PRODUTO                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ Manorma                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RF023GP(cCod)
Local lRet 	:= .T.
  
Return(lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³RF023RP   ³ Autor ³ ROBSON BUENO          ³ Data ³ 18/01/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ TRATAMENTO PARA O PEDIDO                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ Manorma                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RF023RP(cPed,cIt)

Local lRet 	:= .T.
/*cRefcli:=Posicione("SC5",1,xFilial("SC5")+cPed+cIt,"C5_COTCLI")
*/
Return(lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³RP019VL   ³ Autor ³ MICROSIGA             ³ Data ³ 17/06/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ CRIANDO A FUNCAO RP019VL                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ Manorma                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RP023VL()
Local lRet 	:= .T.
/*nDimx:=Posicione("SZM",1,xFilial("SZM")+cEmbala,"ZM_DIMX")
nDimy:=Posicione("SZM",1,xFilial("SZM")+cEmbala,"ZM_DIMY")
nDimz:=Posicione("SZM",1,xFilial("SZM")+cEmbala,"ZM_DIMZ")
nPembal:=Posicione("SZM",1,xFilial("SZM")+cEmbala,"ZM_PESO")
nCubagem:=nDimx*nDimy*nDimZ/1000000
*/
Return(lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³RFT23PA   ³ Autor ³ MICROSIGA             ³ Data ³ 17/06/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ CRIANDO A FUNCAO RFT023PA                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ Manorma                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

USER Function RFT023PA(cAlias)

Local cNumero2:=PB1_NUMERO
Local oDlgl
Local dData :=ctod("  /  /  ")

@ 000,000 To 150,400 Dialog Odlg1 Title OemToAnsi("Informe:")
@ 003,008 To 55,200 Title OemToAnsi("Qual a Previsao de Inspecao?")

@ 015,015 Say OemToAnsi("Data:") OF Odlgl PIXEL
@ 015,045 msget dData SIZE 60,10 OF Odlgl PIXEL
@ 035,030 BMPBUTTON TYPE 1 ACTION OkProc(cAlias,odlg1,dData,cNumero2)
@ 035,060 BMPBUTTON TYPE 2 ACTION Finaliza(odlg1)
Activate Dialog Odlg1 CENTER
Return

// trata a finalizacao
Static Function Finaliza(odlg1)
  Close(Odlg1)
Return
// trata a data
Static Function okProc(cAlias,odlg1,dData,cNumero2)
Close(Odlg1)
If MsgYesNo("Deseja Realmente informar que o processo esta agendado?","Confirmacao de Operacao")
  dbSelectArea(cAlias)
  dbSetOrder(1)
  dbSeek(xFilial(cAlias)+(cAlias)->PB1_NUMERO)
  While !Eof() .And. (cAlias)->PB1_FILIAL == xFilial(cAlias) .And. (cAlias)->PB1_NUMERO == cNumero2
	RecLock(cAlias,.F.)
	(cAlias)->PB1_DATAR:=dData
	MsUnLock()
	// TRATA CONTROLE DE PROCESSO
	dbselectarea("PC2")
    dbSetOrder(4)
    MsSeek(xfilial("PC2")+(cAlias)->PB1_PEDIDO+(cAlias)->PB1_ITEM+"000019")
    if PC2->PC2_QTDORI-PC2->PC2_QTD>0 .and. PC2->PC2_NUM=(cAlias)->PB1_PEDIDO .AND. (cAlias)->PB1_ITEM=PC2->PC2_ITEM .AND. PC2->PC2_SEQ="000019"
      cRegistro:=PC2->PC2_CTR
      // 2 BAIXA O FATURAMENTO OS E POE EM AGUARDANDO RECEBIMENTO
      U_HCICTPR((cAlias)->PB1_PEDIDO,(cAlias)->PB1_ITEM,"000019","000020",(cAlias)->PB1_QTD,"Aguardando CLM","","","CV N.:"+(cAlias)->PB1_NUMERO+" - "+(cAlias)->PB1_SEQ + " - Prev:" + dtos((cAlias)->PB1_datar),cRegistro,(cAlias)->PB1_DATAR) 
    endif
	// FIM TRATAMENTO
	dbselectarea("PB1")
	dbSkip()
  End
endif

//u_hcirap() 

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³RFT23PA   ³ Autor ³ MICROSIGA             ³ Data ³ 17/06/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ CRIANDO A FUNCAO RFT023PA                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ Manorma                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

USER Function RFT023Pc(cAlias)
Local cNumero2:=PB1_NUMERO
If MsgYesNo("Deseja cancelar o processo que esta agendado?","Confirmacao de Operacao")
  dbSelectArea(cAlias)
  dbSetOrder(1)
  dbSeek(xFilial(cAlias)+(cAlias)->PB1_NUMERO)
  While !Eof() .And. (cAlias)->PB1_FILIAL == xFilial(cAlias) .And. (cAlias)->PB1_NUMERO == cNumero2
	dbselectarea("PC2")
    dbSetOrder(6)
    MsSeek(xfilial("PC2")+(cAlias)->PB1_PEDIDO+(cAlias)->PB1_ITEM+"CV N.:"+(cAlias)->PB1_NUMERO+" - "+(cAlias)->PB1_SEQ + " - Prev:" + dtos((cAlias)->PB1_datar))
    IF SUBSTRING(PC2->PC2_INF,1,38)="CV N.:"+(cAlias)->PB1_NUMERO+" - "+(cAlias)->PB1_SEQ + " - Prev:" + dtos((cAlias)->PB1_datar)
       // Primeiramente Verifica se tem processo posterior registrado
       IF U_HCIPDPR(PC2->PC2_NUM,PC2->PC2_ITEM,PC2->PC2_CTR)=.T.  // PEDIDO - ITEM - CONTROLE
         U_HCIEXPR(PC2->PC2_NUM,PC2->PC2_ITEM,PC2->PC2_CTR) 
       ELSE
         lOkOP:=.F.
       ENDIF  
    ENDIF
	dbselectarea("PB1")
	RecLock(cAlias,.F.)
	(cAlias)->PB1_DATAR:=ctod("  /  /  ")
	MsUnLock()
	dbSkip()
  End
endif

//u_hcirap() 

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³RFT23Pe   ³ Autor ³ MICROSIGA             ³ Data ³ 17/06/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ Registrando relatorio de insp                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ Manorma                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

USER Function RFT023Pe(cAlias)

Local cNumero2:=PB1_NUMERO
Local oDlgl
Local dData :=ctod("  /  /  ")
Local cCLM :=Space(25)
@ 000,000 To 150,400 Dialog Odlg1 Title OemToAnsi("Informe:")
@ 003,008 To 55,200 Title OemToAnsi("Dados da Inspecao?")

@ 015,015 Say OemToAnsi("Data:") OF Odlgl PIXEL
@ 015,045 msget dData SIZE 60,10 OF Odlgl PIXEL
@ 030,015 Say OemToAnsi("CLM:") OF Odlgl PIXEL
@ 030,045 msget cCLM SIZE 80,10 OF Odlgl PIXEL
@ 045,030 BMPBUTTON TYPE 1 ACTION OkProc2(cAlias,odlg1,dData,cCLM,cNumero2)
@ 045,060 BMPBUTTON TYPE 2 ACTION Finaliza2(odlg1)
Activate Dialog Odlg1 CENTER
Return

// trata a finalizacao
Static Function Finaliza2(odlg1)
  Close(Odlg1)
Return
// trata a data
Static Function okProc2(cAlias,odlg1,dData,cCLM,cNumero2)
Close(Odlg1)
If MsgYesNo("Deseja Realmente Baixar Pendencia de Inspecao?","Confirmacao de Operacao")
  dbSelectArea(cAlias)
  dbSetOrder(1)
  dbSeek(xFilial(cAlias)+PB1_NUMERO)
  While !Eof() .And. (cAlias)->PB1_FILIAL == xFilial(cAlias) .And. (cAlias)->PB1_NUMERO == cNumero2
	RecLock(cAlias,.F.)
	(cAlias)->PB1_DATAI:=dData 
	(cAlias)->PB1_CLM:=cCLM
	MsUnLock()
	// TRATA CONTROLE DE PROCESSO
	dbselectarea("PC2")
    dbSetOrder(4)
    MsSeek(xfilial("PC2")+(cAlias)->PB1_PEDIDO+(cAlias)->PB1_ITEM+"000020")
    if PC2->PC2_QTDORI-PC2->PC2_QTD>0 .and. PC2->PC2_NUM=(cAlias)->PB1_PEDIDO .AND. (cAlias)->PB1_ITEM=PC2->PC2_ITEM .AND. PC2->PC2_SEQ="000020"
      cRegistro:=PC2->PC2_CTR
      // 2 BAIXA O FATURAMENTO OS E POE EM AGUARDANDO RECEBIMENTO
      U_HCICTPR((cAlias)->PB1_PEDIDO,(cAlias)->PB1_ITEM,"000020","000024",(cAlias)->PB1_QTD,"EM EMBALAGEM","","","CV N.:"+(cAlias)->PB1_NUMERO+" - "+(cAlias)->PB1_SEQ + " - CLM:" + (cAlias)->PB1_CLM,cRegistro) 
    endif
	// FIM TRATAMENTO
    dbSelectArea(cAlias)
	DbSkip()
  End
endif

//u_hcirap() 

Return   


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATA023  ºAutor  ³Microsiga           º Data ³  03/04/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VPEDPB1()
Local cPedido := &(ReadVar())          
Local aArea := GetArea()
Local nOldN := n
Local aGatilhos := {;
			{"PB1_COD"		,"SC6->C6_PRODUTO"},;
			{"PB1_PEDIDO"	,"SC6->C6_NUM"},;
			{"PB1_ITEM"     ,"SC6->C6_ITEM"},;
			{"PB1_DESCRI"	,"SC6->C6_DESCRI"},;
			{"PB1_QTD"   	,"SC6->C6_QTDVEN"},;
			{"PB1_UNIT"  	,"SC6->C6_PRCVEN"},;
			{"PB1_TOTAL" 	,"SC6->C6_VALOR"},;
			{"PB1_PESOU" 	,"SB1->B1_PESO"},;
			{"PB1_PESOT" 	,"SC6->C6_QTDVEN + SB1->B1_PESO"},;
			{"PB1_REFCLI"	,"SC6->C6_NUMREF"},;
			{"PB1_PEDCLI"	,"SC6->C6_PV"},;
			{"PB1_ITCLI" 	,"SC6->C6_ITEMCLI"},;
			{"PB1_NOME"  	,"SC5->C5_XNREDUZ"},;
			{"PB1_VENCTO"	,"SC6->C6_ENTREG"}}
Local lRet := .T.			
Local cSeq
Local lFirst := .T. 

if !Empty(cPedido) // Pedido Preenchido
	dbSelectArea("SC6")
	if dbSeek(xFilial("SC6")+cPedido)
		dbSelectArea("SC5")
		dbSetOrder(1)
		dbSeek(xFilial("SC5")+cPedido)
		cCliente := SC5->C5_CLIENTE
		cLoja    := SC5->C5_LOJACLI
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSelectArea("SC6")
	    cSeq := aCols[n,1]
		while !Eof() .and. (SC6->C6_FILIAL + SC6->C6_NUM = xFilial("SC6")+cPedido)
	        
			if n > Len(aCols)
				aadd(aCols,Array(Len(aHeader)+1))
				aCols[n,Len(aHeader)+1] := .F.
				cSeq := Soma1(cSeq)
				aCols[n,1] := cSeq
			endif
			
			lFirst := .F.
			
			dbSelectArea("SB1")
			dbSeek(xFilial("SB1")+SC6->C6_PRODUTO)
			
			For nX	:= 2 To Len(aHeader)
				nPos := aScan(aGatilhos,{|x| Alltrim(x[1])= Alltrim(aHeader[nX, 2])})
				if nPos > 0
					aCols[n, nX] := &(aGatilhos[nPos,2])
				else	
					aCols[n, nX] := CriaVar(aHeader[nx][2])
				endif	
			Next nX
			SC6->(dbSkip())
			n++
			
		enddo
	else
		Aviso("Atenção","Pedido Não Encontrado. Verificar o numero e tentar novamente",{"Ok"})
		lRet := .F.	
	endif	
endif 
n := nOldN
Return lRet