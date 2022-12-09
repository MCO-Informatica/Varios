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
user Function RFATA060()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ DECLARAR AS VARIAVEIS aROTINA E cCADASTRO COMO PRIVATE,  ³
//³ PORQUE A FUNCAO mBROWSE ESTA ESPERANDO....               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aCores    := {}
Private aRotina := {}
Private cCadastro := "CONTROLE DE DOCTOS QUALIDADE"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MONTAR O VETOR aROTINA, OBRIGATORIO PARA UTILIZACAO DA   ³
//³ FUNCAO mBROWSE                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCores    := {{	'PM1_DATAA=CTOD("  /  /  ")', 'BR_VERMELHO'},;	        // Processo Pendente
			   {'PM1_DATAA<>CTOD("  /  /  ")', 'BR_VERDE'}}        // Processo Liquidado


aAdd( aRotina, { "Pesquisar " , "AxPesqui   " , 0 , 1 })
aAdd( aRotina, { "Visualizar" , "u_RFAT60I  " , 0 , 2 })
aAdd( aRotina, { "Incluir   " , "u_RFAT60I   "   , 0 , 3 })
aAdd( aRotina, { "Alterar   " , "u_RFAT60I   "   , 0 , 4 })
aAdd( aRotina, { "Excluir   " , "u_RFAT60I   "   , 0 , 5 })
aAdd( aRotina, { "Reg.Previsao" , "u_RFT060PA  "   , 0 , 6 }) 
aAdd( aRotina, { "Canc.Previsao" , "u_RFT060Pc  "   , 0 , 7 })
aAdd( aRotina, { "Bx da Qualidade" , "u_RFT060Pe  "   , 0 ,8 })
aAdd( aRotina, { "Visualizar PV" , "u_RFT060Pv  "   , 0 ,9 }) 
aAdd( aRotina, { "Visualizar OC" , "u_RFT060Oc  "   , 0 ,10 }) 
aAdd( aRotina, { "Legenda","U_RFTL60B",0,11})  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SELECIONAR A TABELA, ORDEM E POSICIONAR NO PRIMEIRO      ³
//³ REGISTRO DA TABELA                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("PM1")
dbSetOrder(1)
dbGoTop()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ EXECUTAR A FUNCAO mBROWSE PARA TABELA MENCIONADA         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
mBrowse(6,1,22,75,"PM1",,,,,3,aCores)
//mBrowse(6,1,22,75,"SC5",,,,,3,aCores)
Return nil

User Function RFTL60B()
                                    
BrwLegenda(cCadastro,"Situacoes",{{"BR_VERMELHO","Pedidos Na Qualidade"}, {"BR_VERDE","Pedido Dispostos"}})

Return (.T.) 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³RFAT60I   ³ Autor ³ Robson Bueno          ³ Data ³ 18/01/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ TRATANDO AS OPCOES DA MBROWSE                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ REMOTE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFAT60I(cAlias,nReg,nOpc)
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
Private cLinOk   := "u_PM1LIOK()"
Private cAllOk   := "u_PM1TudOk()"
Private aGetsGD  := {}
Private bF4      := {|| }
Private cIniCpos := "+PM1_SEQ"
Private nMax     := 999
Private aCordW   := {0,0,700,980}
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
Private cTipo	:=Space(2)
//Private dData    := Ctod(" / / ")
//Private cNumero  := Space(6)
Private aAlt     := {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CRIA VARIAVEIS DE MEMORIA M->???³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOpc = 3
  //cNumero:=GETSX8NUM("PM1","PM1_NUMERO") 
  dData:=date()
  cCLiente:="000000"
  cLoja:="00"                                                                                                                                                                                                                           
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
	                   !(Trim(X3_CAMPO)$"PM1_NUMERO")   .And. ;
	                   !(TRIM(X3_CAMPO)$"PM1_DATAE") .and. ;
	                   !(TRIM(X3_CAMPO)$"PM1_CLI") .AND.;
	                   !(TRIM(X3_CAMPO)$"PM1_LOJA") 
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
	cNumero  := (cAlias)->PM1_NUMERO
    cCliente := (cAlias)->PM1_CLI
    cLoja    := (cAlias)->PM1_LOJA
	dData    := (cAlias)->PM1_DATAE
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ DEVE-SE POSICIONAR, PORQUE NUNCA SE SABE EM QUAL ITEM³
	//³ ESTA, E NECESSARIO PEGAR TODOS OS ITENS.             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSeek(xFilial(cAlias)+cNumero)
	While !Eof() .And. (cAlias)->(PM1_FILIAL+PM1_NUMERO) == xFilial(cAlias)+ cNumero
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
	aCOLS[1,aScan(aHeader,{|x|Trim(x[2])=="PM1_DATAP"})] := CTOD("  /  /  ")
   	aCOLS[1,aScan(aHeader,{|x|Trim(x[2])=="PM1_DATAA"})] := CTOD("  /  /  ")
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
	aCOLS[1,aScan(aHeader,{|x|Trim(x[2])=="PM1_SEQ"})] := "001"
   	aCOLS[1,aScan(aHeader,{|x|Trim(x[2])=="PM1_DATAP"})] := CTOD("  /  /  ")
   	aCOLS[1,aScan(aHeader,{|x|Trim(x[2])=="PM1_DATAA"})] := CTOD("  /  /  ")
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
aAdd(aC,{"cNumero",	    {15,08}	,"Numero de Registro","@!",,,.T.})
aAdd(aC,{"dData",		{15,200},"Emissao",,,,.F.})
aAdd(aC,{"cCliente",	{30,08}	,"Cliente/Fornecedor ","@!",,,.F.})
aAdd(aC,{"cLoja",		{30,200},"Loja   ","@!",,,.F.})
//aAdd(aC,{"cCliente",	{30,08}	,"Cliente/Fornecedor ","@!",,"SA1",.T.})
//                                                                    
// Coordenada do objeto Getdados 
//
aCGD:={60,5,118,315}
//aCGD:={44,5,118,315}

//
// Validacao na mudanca de linha e quando clicar no botao Ok 
//

//
// Atribuir a database do sistema a variável
//
IF nOpc=3
  dData := dDataBase
ENDIF
//
// Executar a função Modelo2() 
//
lRet := Modelo2(cTitulo,aC,aR,aCGD,nOpc,cLinOk,cAllOk,,,cIniCpos,nMax)
//
// Se confirmado...
//
If lRet
	//
	// Se opção for inclusao 
	//
	If nOpc == 3
	//	If MsgYesNo("Confirma gravacao dos dados ?",cTitulo)
			Processa({|| IncluPM1(cAlias)},cTitulo,"Gravando os dados, aguarde...")
	//	Endif
	//
	// Se opção for alteração
	//
	Elseif nOpc == 4
	   //	If MsgYesNo("Confirma alteração dos dados ?",cTitulo)
			Processa({|| AlterPM1(cAlias)},cTitulo,"Alterando os dados, aguarde...")
	   //	Endif
	//
	// Se opção for exclusão 
	//
	Elseif nOpc == 5
		If MsgYesNo("Confirma eliminação dos dados ?",cTitulo)
			Processa({|| ExcluPM1(cAlias)},cTitulo,"Excluíndo os dados, aguarde...")
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
±±³Programa   ³AlterPM1  ³ Autor ³ ROBSON BUENO          ³ Data ³ 18/01/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ ALTERACAO DOS REGISTROS DA PM1                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ Manorma                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AlterPM1(cAlias)

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
			(CaLIAS)->PM1_FILIAL := XFILIAL("PM1")
			(cAlias)->PM1_NUMERO := cNumero
			(cAlias)->PM1_DATAE  := dData
			IF (cAlias)->PM1_TIPO="PV"
     		  (cAlias)->PM1_CLI    := Posicione("SC6",1,xFilial("SC6")+(cAlias)->PM1_PEDIDO+SUBSTRING((cAlias)->PM1_ITEM,1,2),"C6_CLI")              
	    	  (cAlias)->PM1_LOJA   := Posicione("SC6",1,xFilial("SC6")+(cAlias)->PM1_PEDIDO+SUBSTRING((cAlias)->PM1_ITEM,1,2),"C6_LOJA") 
		    endif
		    IF (cAlias)->PM1_TIPO="OC"
     		  (cAlias)->PM1_CLI    := Posicione("SC7",1,xFilial("SC7")+(cAlias)->PM1_PEDIDO+(cAlias)->PM1_ITEM,"C7_FORNECE")                             
	    	  (cAlias)->PM1_LOJA   := Posicione("SC7",1,xFilial("SC7")+(cAlias)->PM1_PEDIDO+(cAlias)->PM1_ITEM,"C7_LOJA")                             
		    endif
		    IF (cAlias)->PM1_TIPO="OS"
     	      (cAlias)->PM1_CLI    := Posicione("AB7",1,xFilial("AB7")+(cAlias)->PM1_PEDIDO+SUBSTRING((cAlias)->PM1_ITEM,1,2),"AB7_CODCLI")             
	    	  (cAlias)->PM1_LOJA   := Posicione("AB7",1,xFilial("AB7")+(cAlias)->PM1_PEDIDO+SUBSTRING((cAlias)->PM1_ITEM,1,2),"AB7_LOJA") 
		    endif
			(cAlias)->PM1_INSPIN	:=Substr(cUsuario,7,15)
		Endif
		MsUnLock()
	Else
		If !aCOLS[i,Len(aHeader)+1]
			RecLock(cAlias,.T.)
			For y := 1 To Len(aHeader)
				FieldPut(FieldPos(Trim(aHeader[y,2])),aCOLS[i,y])
			Next y
		    (CaLIAS)->PM1_FILIAL := XFILIAL("PM1")
		    (cAlias)->PM1_NUMERO := cNumero
			(cAlias)->PM1_DATAE  := dData
		    IF (cAlias)->PM1_TIPO="PV"
     		  (cAlias)->PM1_CLI    := Posicione("SC6",1,xFilial("SC6")+(cAlias)->PM1_PEDIDO+SUBSTRING((cAlias)->PM1_ITEM,1,2),"C6_CLI")              
	    	  (cAlias)->PM1_LOJA   := Posicione("SC6",1,xFilial("SC6")+(cAlias)->PM1_PEDIDO+SUBSTRING((cAlias)->PM1_ITEM,1,2),"C6_LOJA") 
		    endif
		    IF (cAlias)->PM1_TIPO="OC"
     	      (cAlias)->PM1_CLI    := Posicione("SC7",1,xFilial("SC7")+(cAlias)->PM1_PEDIDO+(cAlias)->PM1_ITEM,"C7_FORNECE")                             
	    	  (cAlias)->PM1_LOJA   := Posicione("SC7",1,xFilial("SC7")+(cAlias)->PM1_PEDIDO+(cAlias)->PM1_ITEM,"C7_LOJA")                             
		    endif
		    IF (cAlias)->PM1_TIPO="OS"
     		  (cAlias)->PM1_CLI    := Posicione("AB7",1,xFilial("AB7")+(cAlias)->PM1_PEDIDO+SUBSTRING((cAlias)->PM1_ITEM,1,2),"AB7_CODCLI")             
	    	  (cAlias)->PM1_LOJA   := Posicione("AB7",1,xFilial("AB7")+(cAlias)->PM1_PEDIDO+SUBSTRING((cAlias)->PM1_ITEM,1,2),"AB7_LOJA") 
		    endif
	    	(cAlias)->PM1_INSPIN	:=Substr(cUsuario,7,15)
			MsUnLock()
		Endif
	Endif
Next i

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ExcluPM1  ³ Autor ³ ROBSON BUENO          ³ Data ³ 18/01/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ EXCLUSAO DE REGISTROS DA PM1                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ Manorma                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ExcluPM1(cAlias)
ProcRegua(Len(aCOLS))

dbSelectArea(cAlias)
dbSetOrder(1)
dbSeek(xFilial(cAlias)+cNumero)
if (cAlias)->PM1_INSPIN=Substr(cUsuario,7,15) .or. Substr(cUsuario,7,15)="Administrador  "
  While !Eof() .And. (cAlias)->PM1_FILIAL == xFilial(cAlias) .And. (cAlias)->PM1_NUMERO == cNumero
	IncProc()
	/*
	dbselectarea("PC2")
    dbSetOrder(6)
    MsSeek(xfilial("PC2")+(cAlias)->PM1_NUMERO+(cAlias)->PM1_ITEM+"CV INSPECAO N.:"+(cAlias)->PM1_NUMERO+" - "+(cAlias)->PM1_SEQ)
    IF SUBSTRING(PC2->PC2_INF,1,29)="CV INSPECAO N.:"+(cAlias)->PM1_NUMERO+" - "+(cAlias)->PM1_SEQ
       // Primeiramente Verifica se tem processo posterior registrado
       IF U_HCIPDPR(PC2->PC2_NUM,PC2->PC2_ITEM,PC2->PC2_CTR)=.T.  // PEDIDO - ITEM - CONTROLE
         U_HCIEXPR(PC2->PC2_NUM,PC2->PC2_ITEM,PC2->PC2_CTR) 
       ELSE
         lOkOP:=.F.
       ENDIF  
    ENDIF
	*/
	RecLock(cAlias,.F.)
	dbDelete()
	MsUnLock()
	dbSkip()
  End
else 
   MsgInfo("Somente o Usuario ->"+(cAlias)->PM1_INSPIN+"<- pode excluir Processo", "Acao nao autorizada")   
endif
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³IncluPM1  ³ Autor ³ ROBSON BUENO          ³ Data ³ 18/01/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ INCLUINDO REGISTROS NA PM1                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ Manorma                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IncluPM1(cAlias)

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
		(cAlias)->PM1_FILIAL := xFilial(cAlias)
      	(cAlias)->PM1_NUMERO := cNumero
		(cAlias)->PM1_DATAE  := dData
		IF (cAlias)->PM1_TIPO="PV"
     		(cAlias)->PM1_CLI    := Posicione("SC6",1,xFilial("SC6")+(cAlias)->PM1_PEDIDO+SUBSTRING((cAlias)->PM1_ITEM,1,2),"C6_CLI")              
	    	(cAlias)->PM1_LOJA   := Posicione("SC6",1,xFilial("SC6")+(cAlias)->PM1_PEDIDO+SUBSTRING((cAlias)->PM1_ITEM,1,2),"C6_LOJA") 
		endif
		IF (cAlias)->PM1_TIPO="OC"
     		(cAlias)->PM1_CLI    := Posicione("SC7",1,xFilial("SC7")+(cAlias)->PM1_PEDIDO+(cAlias)->PM1_ITEM,"C7_FORNECE")                             
	    	(cAlias)->PM1_LOJA   := Posicione("SC7",1,xFilial("SC7")+(cAlias)->PM1_PEDIDO+(cAlias)->PM1_ITEM,"C7_LOJA")                             
		endif
		IF (cAlias)->PM1_TIPO="OS"
     		(cAlias)->PM1_CLI    := Posicione("AB7",1,xFilial("AB7")+(cAlias)->PM1_PEDIDO+SUBSTRING((cAlias)->PM1_ITEM,1,2),"AB7_CODCLI")             
	    	(cAlias)->PM1_LOJA   := Posicione("AB7",1,xFilial("AB7")+(cAlias)->PM1_PEDIDO+SUBSTRING((cAlias)->PM1_ITEM,1,2),"AB7_LOJA") 
		endif
		(cAlias)->PM1_DATAP  :=CTOD("  /  /  ")
		(cAlias)->PM1_DATAA  :=CTOD("  /  /  ")
		(cAlias)->PM1_INSPIN	:=Substr(cUsuario,7,15)
	     MsUnLock()
	     // TRATA CONTROLE DE PROCESSO
	     /*
	     dbselectarea("PC2")
         dbSetOrder(4)                                            	
         MsSeek(xfilial("PC2")+(cAlias)->PM1_PEDIDO+(cAlias)->PM1_ITEM+"000018")
         if PC2->PC2_QTDORI-PC2->PC2_QTD>0 .and. PC2->PC2_NUM=(cAlias)->PM1_PEDIDO .AND. (cAlias)->PM1_ITEM=PC2->PC2_ITEM .AND. PC2->PC2_SEQ="000018"
           cRegistro:=PC2->PC2_CTR
           // 2 BAIXA O FATURAMENTO OS E POE EM AGUARDANDO RECEBIMENTO
           U_HCICTPR((cAlias)->PM1_PEDIDO,(cAlias)->PM1_ITEM,"000018","000019",(cAlias)->PM1_QTD,"Aguardando Previsao","","","CV INSPECAO N.:"+(cAlias)->PM1_NUMERO+" - "+(cAlias)->PM1_SEQ,cRegistro,(cAlias)->PM1_DATAC+5) 
         endif
	     */
	     // FIM TRATAMENTO
	Endif
Next i

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³PM1TUDOK  ³ Autor ³ ROBSON BUENO          ³ Data ³ 18/01/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ VALIDANDO TUDO OK PARA GRAVACAO                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ Manorma                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PM1TUDOK()

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
if len(trim(cNumero))=0 
    MsgInfo("Defina o Numero de processo para Inclusão","Operacao Invalida")
	lRet:=.F.
endif
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³PM1LIOK   ³ Autor ³ ROBSON BUENO          ³ Data ³ 18/01/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ VALIDANDO LINHA DO CONTROLE DE INSPECAO                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ Manorma                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PM1LIOK()
Local aArea := (GetArea())         
Local lRet 	:= .T.

if cCliente="      " .OR. cLoja="  " 
  lRet:=.f. 
  MsgInfo("Defina o Cliente/Fornecedor", "Processo Invalido")  
else
  if cCliente="      " .OR. cLoja="  " 
  IF acols[N,2]="PV"
    if cCLiente<>Posicione("SC5",1,xFilial("SC5")+acols[N,3],"C5_CLIENTE")
      cCliente:=Posicione("SC5",1,xFilial("SC5")+acols[N,3],"C5_CLIENTE")
      cLoja:=Posicione("SC5",1,xFilial("SC5")+acols[N,3],"C5_LOJACLI")
    ENDIF
  ELSE
    if cCLiente<>Posicione("SC7",1,xFilial("SC7")+acols[N,3],"C7_FORNECE")
      cCliente:=Posicione("SC7",1,xFilial("SC7")+acols[N,3],"C7_FORNECE")
      cLoja:=Posicione("SC7",1,xFilial("SC7")+acols[N,3],"C7_LOJA")	
    ENDIF
  ENDIF 
  endif 
endif
RestArea(aArea)
Return(lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³RF060GP   ³ Autor ³ ROBSON BUENO          ³ Data ³ 18/01/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ TRATAMENTO DO CODIGO DO PRODUTO                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ Manorma                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RF060GP(cCl,cLj)
Local lRet 	:= .T.
if cCl="      " .OR. cLj="  " 
  lRet:=.f. 
  MsgInfo("Defina o Cliente/Fornecedor", "Processo Invalido")  
endif
   
Return(lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³RF060RP   ³ Autor ³ ROBSON BUENO          ³ Data ³ 18/01/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ TRATAMENTO PARA O PEDIDO                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ Manorma                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RF060RP(cPed,cIt)

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
User Function RP060VL()
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
±±³Programa   ³RFT60PA   ³ Autor ³ MICROSIGA             ³ Data ³ 17/06/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ CRIANDO A FUNCAO RFT060PA                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ Manorma                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

USER Function RFT060PA(cAlias)

Local cNumero2:=PM1_NUMERO
Local oDlgl
Local dData :=ctod("  /  /  ")
Local cResp :=Space(30) 
cResp:=Substr(cUsuario,7,15)
@ 000,000 To 150,400 Dialog Odlg1 Title OemToAnsi("Informe:")
@ 003,008 To 75,200 Title OemToAnsi("Qual a Previsao de Baixa da Qualidade?")

@ 015,015 Say OemToAnsi("Data:") OF Odlgl PIXEL
@ 015,045 msget dData SIZE 60,10 OF Odlgl PIXEL 
@ 030,015 Say OemToAnsi("Resp:") OF Odlgl PIXEL
@ 030,045 msget cResp SIZE 60,10 OF Odlgl PIXEL
@ 045,030 BMPBUTTON TYPE 1 ACTION OkProc(cAlias,odlg1,dData,cNumero2,cResp)
@ 045,060 BMPBUTTON TYPE 2 ACTION Finaliza(odlg1)
Activate Dialog Odlg1 CENTER
Return

// trata a finalizacao
Static Function Finaliza(odlg1)
  Close(Odlg1)
Return
// REGISTRA A PREVISAO DA ACAO
Static Function okProc(cAlias,odlg1,dData,cNumero2,cResp)
Close(Odlg1)
If MsgYesNo("Deseja Realmente informar que o processo esta agendado?","Confirmacao de Operacao")
  dbSelectArea(cAlias)
  dbSetOrder(1)
  dbSeek(xFilial(cAlias)+(cAlias)->PM1_NUMERO)
  While !Eof() .And. (cAlias)->PM1_FILIAL == xFilial(cAlias) .And. (cAlias)->PM1_NUMERO == cNumero2
	RecLock(cAlias,.F.)
	(cAlias)->PM1_DATAP:=dData
    (cAlias)->PM1_RESP:=cResp
	MsUnLock()
	dbselectarea("PM1")
	dbSkip()
  End
endif


Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³RFT60PA   ³ Autor ³ MICROSIGA             ³ Data ³ 17/06/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ CRIANDO A FUNCAO RFT060PA                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ Manorma                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

USER Function RFT060Pc(cAlias)
Local cNumero2:=PM1_NUMERO
If MsgYesNo("Deseja cancelar o processo que esta agendado?","Confirmacao de Operacao")
  dbSelectArea(cAlias)
  dbSetOrder(1)
  dbSeek(xFilial(cAlias)+(cAlias)->PM1_NUMERO)
  While !Eof() .And. (cAlias)->PM1_FILIAL == xFilial(cAlias) .And. (cAlias)->PM1_NUMERO == cNumero2
    /*
	dbselectarea("PC2")
    dbSetOrder(6)
    MsSeek(xfilial("PC2")+(cAlias)->PM1_PEDIDO+(cAlias)->PM1_ITEM+"CV N.:"+(cAlias)->PM1_NUMERO+" - "+(cAlias)->PM1_SEQ + " - Prev:" + dtos((cAlias)->PM1_datar))
    IF SUBSTRING(PC2->PC2_INF,1,38)="CV N.:"+(cAlias)->PM1_NUMERO+" - "+(cAlias)->PM1_SEQ + " - Prev:" + dtos((cAlias)->PM1_datar)
       // Primeiramente Verifica se tem processo posterior registrado
       IF U_HCIPDPR(PC2->PC2_NUM,PC2->PC2_ITEM,PC2->PC2_CTR)=.T.  // PEDIDO - ITEM - CONTROLE
         U_HCIEXPR(PC2->PC2_NUM,PC2->PC2_ITEM,PC2->PC2_CTR) 
       ELSE
         lOkOP:=.F.
       ENDIF  
    ENDIF
    */
    dbselectarea("PM1")
	RecLock(cAlias,.F.)
	(cAlias)->PM1_DATAP:=ctod("  /  /  ")
	(cAlias)->PM1_RESP:="                              "
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
±±³Programa   ³RFT60Pe   ³ Autor ³ MICROSIGA             ³ Data ³ 17/06/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ BAIXANDO PENDENCIA DA QUALIDADE                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ Manorma                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

USER Function RFT060Pe(cAlias)

Local cNumero2:=PM1_NUMERO
Local oDlgl
Local dData :=date()
Local cCLM :=Space(60)
Local cResp:=space(30) 
dbSelectArea(cAlias)
dbSetOrder(1)
dbSeek(xFilial(cAlias)+cNumero2)
cResp:=(cAlias)->PM1_RESP 
@ 000,000 To 150,400 Dialog Odlg1 Title OemToAnsi("Informe:")
@ 003,008 To 70,200 Title OemToAnsi("Dados da Baixa")

@ 015,015 Say OemToAnsi("Data:") OF Odlgl PIXEL
@ 015,045 msget dData SIZE 60,10 OF Odlgl PIXEL
@ 030,015 Say OemToAnsi("Disposicao:") OF Odlgl PIXEL
@ 030,045 msget cCLM SIZE 120,10 OF Odlgl PIXEL
@ 045,015 Say OemToAnsi("Resp:") OF Odlgl PIXEL
@ 045,045 msget cResp SIZE 60,10 OF Odlgl PIXEL
@ 060,030 BMPBUTTON TYPE 1 ACTION OkProc2(cAlias,odlg1,dData,cCLM,cNumero2,cResp)
@ 060,060 BMPBUTTON TYPE 2 ACTION Finaliza2(odlg1)
Activate Dialog Odlg1 CENTER
Return

// trata a finalizacao
Static Function Finaliza2(odlg1)
  Close(Odlg1)
Return
// trata a data
Static Function okProc2(cAlias,odlg1,dData,cCLM,cNumero2,cResp)
Close(Odlg1)
If MsgYesNo("Deseja Realmente Baixar Pendencia Da Qualidade?","Confirmacao de Operacao")
  dbSelectArea(cAlias)
  dbSetOrder(1)
  dbSeek(xFilial(cAlias)+PM1_NUMERO)
  While !Eof() .And. (cAlias)->PM1_FILIAL == xFilial(cAlias) .And. (cAlias)->PM1_NUMERO == cNumero2
	RecLock(cAlias,.F.)
	(cAlias)->PM1_DATAA:=dData 
	(cAlias)->PM1_ACAO :=cCLM
	(cAlias)->PM1_RESP :=cResp
	(cAlias)->PM1_QTA  :=(cAlias)->PM1_QTD
	MsUnLock()
    dbSelectArea(cAlias)
	DbSkip()
  End
endif

//u_hcirap() 

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³RFT60PA   ³ Autor ³ MICROSIGA             ³ Data ³ 17/06/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ CRIANDO A FUNCAO RFT060PA                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ Manorma                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

USER Function RFT060OC(cAlias)
Local cNumero2:=(cAlias)->PM1_NUMERO
if (cAlias)->PM1_TIPO="PV"
   MsgInfo("O processo Selecionado refere-se a um PV", "Processo Invalido")
else
   If MsgYesNo("Deseja Abrir Ordem de Compra N." + (cAlias)->PM1_PEDIDO + "?","Confirmacao de Operacao")
     MaViewPC((cAlias)->PM1_PEDIDO)
   ENDIF
endif

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³RFT60PA   ³ Autor ³ MICROSIGA             ³ Data ³ 17/06/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ CRIANDO A FUNCAO RFT060PA                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ Manorma                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

USER Function RFT060PV(cAlias)
	Local cNumero2:=(cAlias)->PM1_NUMERO
	Local aArea := (GetArea())   
	if (cAlias)->PM1_TIPO="OC"
   		MsgInfo("O processo Selecionado refere-se a uma OC", "Processo Invalido")
	else
   		If MsgYesNo("Deseja Abrir Pedido de Venda N." + (cAlias)->PM1_PEDIDO + "?","Confirmacao de Operacao")
      		dbSelectArea("SC5")
	  		dbSetOrder(1)
	  		MsSeek(xFilial("SC5")+(cAlias)->PM1_PEDIDO)
	  		A410Visual("SC5",RECNO(),2)
   		ENDIF
	endif
	RestArea(aArea)
Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³RFT60PA   ³ Autor ³ MICROSIGA             ³ Data ³ 17/06/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ CRIANDO A FUNCAO RFT060PA                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ Manorma                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

USER Function RFT060RR(cItem,cOper)
Local lRet:=.t.
IF len(trim(cItem))>2 
   if cOper<>"OC" 
     LRET:=.F.
   ENDIF  
elseif len(trim(M->PM1_ITEM))=2 .and. substring(M->PM1_PEDIDO,1,1) $ "2/3/4/5/6/7/8/9"	
   IF cOper<>"PV"
     lRet:=.F.
   endif
else
   IF cOper<>"OS"
     lRet:=.F.
   endif
ENDIF
Return (lRet)


