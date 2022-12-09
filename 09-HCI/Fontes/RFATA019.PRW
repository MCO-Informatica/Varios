/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ RFATA019 ³ Autor ³ ROBSON BUENO          ³ Data ³ 23/03/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ ROMANEIO DE EMBARQUE            						   ³±±	
±±³           ³ CHAMADA PELA FUNCAO MODELO2()                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ REMOTE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
#include "Protheus.ch"
user Function RFATA019()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ DECLARAR AS VARIAVEIS aROTINA E cCADASTRO COMO PRIVATE,  ³
//³ PORQUE A FUNCAO mBROWSE ESTA ESPERANDO....               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aRotina := {}
Private cCadastro := "ROMANEIO DE EMBARQUE"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MONTAR O VETOR aROTINA, OBRIGATORIO PARA UTILIZACAO DA   ³
//³ FUNCAO mBROWSE                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd( aRotina, { "Pesquisar	" , "AxPesqui   " , 0 , 1 })
aAdd( aRotina, { "Visualizar" , "u_RFAT19I  " , 0 , 2 })
aAdd( aRotina, { "Incluir   " , "u_RFAT19I   "   , 0 , 3 })
aAdd( aRotina, { "Alterar   " , "u_RFAT19I   "   , 0 , 4 })
aAdd( aRotina, { "Excluir   " , "u_RFAT19I   "   , 0 , 5 })
aAdd( aRotina, { "C. Rapida	" , "u_RFT019PR  "   , 0 , 6 })
IF cPaisLoc == "PTG"
	aAdd( aRotina, { "Copia Romaneio HCI" , "u_CopyRoma" , 0 , 3 })
EndIF	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SELECIONAR A TABELA, ORDEM E POSICIONAR NO PRIMEIRO      ³
//³ REGISTRO DA TABELA                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SZO")
dbSetOrder(1)
dbGoTop()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ EXECUTAR A FUNCAO mBROWSE PARA TABELA MENCIONADA         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
mBrowse(6,1,22,75,"SZO")
Return nil


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³RFAT19I   ³ Autor ³ Robson Bueno          ³ Data ³ 23/03/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ CRIANDO A FUNCAO RFAT19I                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ REMOTE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Esta Funcao e utilizada para a Criacao de Telas de Cadastros onde poderemos 
trabalhar com um Esquema Cabecalho desenvolvido apenas com a utilizacao de 
Variaveis de Memoria e logo abaixo uma tela com linhas, utilizada para a 
digitacao dos dados, aparentando estarmos trabalhando com dois arquivos em 
tela, porem na verdade existira apenas um.
Como exemplo, podemos citar o cadastro de Controle de Reservas, existente no 
Modulo de Faturamento.
Sintaxe:
Modelo2(cTitulo,aCabec,aRodape,aGd,nOp,cLOk,cTOk,aGetsGD,bF4,cIniCpos,nMax,aCordw,lDelget)
Parametros
cTitulo	: Titulo da janela
aCabec	: Array com os campos do cabecalho
aRodape	: Array com os campos do rodape
aGd		: Array com as posições para edição dos itens (GETDADOS)
nOp:	: Modo de operacao (3 ou 4 altera e inclui itens, 6 altera mas nao 
		  inclui itens, qualquer outro numero so visualiza os itens)
cLOk 	: Função para validação da linha
cTOk 	: Função para validação de todos os dados (na confirmação)
aGetsGD : Array Gets editáveis (GetDados) * Default = Todos.
bF4 	: Codeblock a ser atribuído a tecla F4. *Default = Nenhum.
cIniCpos: String com o nome dos campos que devem ser inicializados ao teclar seta para baixo (GetDados).
nMAx 	: Limita o numero de linhas (GetDados). *Default = 99.
aCordw  : Array com quatro elementos numericos, correspondendo às coordenadas linha superior, 
		  coluna esquerda, linha interior e coluna direita, definindo a area de tela a ser usada. 
		  *Default = area de Dados Livre.
lDelget : Determina se as linhas podem ser deletadas ou nao (GetDados) *Default = .T.

Retorna:
lRet 	: Retorna .T. se for confirmado
/*/

User Function RFAT19I(cAlias,nReg,nOpc)
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
Private cLinOk   := "u_SZOLIOK()"
Private cAllOk   := "u_SZOTudOk()"
Private aGetsGD  := {}
Private bF4      := {|| }
Private cIniCpos := "+ZO_SEQ"
Private nMax     := 999
Private aCordW   := {0,0,650,1000}
Private lDelGetD := .T.
Private aHeader  := {}
Private aCOLS    := {}
Private nCount   := 0
Private bCampo   := {|nField| FieldName(nField) }
Private cRom	 := space(20)
Private cEmbala  := space(50)
Private cEmissao := Ctod(" / / ")
Private cRefCli  := space(40)
Private cRelInsp := Space(40)
Private cDtlib	 := Ctod(" / / ")
Private nPesoT	 := 0
Private nDimx	 := 0
Private nDimy	 := 0
Private nDimz	 := 0
Private nCubagem := 0 
Private nPembal  :=0
Private nPesot   := nPembal
Private cM3:="0,00"
Private cEmpAtual := SM0->M0_CODIGO
if cEmpAtual="02"
  cEmbala:="DIVERSOS" 
  cRom:=GETSX8NUM("SZO","ZO_ROMAN") 
  cEmissao:=date()                                                                                                                                                                                                                           
endif



//Private dData    := Ctod(" / / ")
//Private cNumero  := Space(6)
Private aAlt     := {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CRIA VARIAVEIS DE MEMORIA M->???³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
	                   !(Trim(X3_CAMPO)$"ZO_ROMAN")   .And. ;
	                   !(TRIM(X3_CAMPO)$"ZO_EMBAL")   .And. ;
	                   !(TRIM(X3_CAMPO)$"ZO_EMISSAO") .And. ;
	                   !(TRIM(X3_CAMPO)$"ZO_REFCLI")  .And. ;
	                   !(TRIM(X3_CAMPO)$"ZO_RELINSP") .And. ;
	                   !(TRIM(X3_CAMPO)$"ZO_DTLIB")   .And. ;
	                   !(TRIM(X3_CAMPO)$"ZO_DIMX")    .And. ;
                       !(TRIM(X3_CAMPO)$"ZO_DIMY")    .And. ;
                       !(TRIM(X3_CAMPO)$"ZO_DIMZ")    .And. ;
                       !(TRIM(X3_CAMPO)$"ZO_CUBAGEM") .And. ;
                       !(TRIM(X3_CAMPO)$"ZO_PSMERC")	 	                   
		aAdd(aHeader,{TRIM(	X3_TITULO) ,;
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
	cRom    := (cAlias)->ZO_ROMAN
    cEmbala := (cAlias)->ZO_EMBAL
    cEmissao:= (cAlias)->ZO_EMISSAO
	cRefCli := (cAlias)->ZO_REFCLI
	cRelInsp:= (cAlias)->ZO_RELINSP
	cDtlib	:= (cAlias)->ZO_DTLIB  
    nDimx   := (cAlias)->ZO_DIMX  		
	nDimy   := (cAlias)->ZO_DIMY  		
	nDimz   := (cAlias)->ZO_DIMZ
	nCubagem:= (cAlias)->ZO_CUBAGEM 
	nPesot  := (cAlias)->ZO_PSMERC 		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ DEVE-SE POSICIONAR, PORQUE NUNCA SE SABE EM QUAL ITEM³
	//³ ESTA, E NECESSARIO PEGAR TODOS OS ITENS.             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSeek(xFilial(cAlias)+cRom)
	While !Eof() .And. (cAlias)->(ZO_FILIAL+ZO_ROMAN) == xFilial(cAlias)+ cRom
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
	aCOLS[1,aScan(aHeader,{|x|Trim(x[2])=="ZO_SEQ"})] := "001"
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
aAdd(aC,{"cRom",{15,08},     "Romaneio       ","@!",,,.T.})
aAdd(aC,{"cEmissao",{15,360},"Emissao       ",,,,.T.})
aAdd(aC,{"cEmbala",{30,08},  "Embalagem     ","@!","U_RP019VL()","SZM",.T.})
aAdd(aC,{"nDimx",{30,360},  "Dim X","@e 99999",,,.T.})
aAdd(aC,{"nDimy",{30,400},  "Dim Y","@e 99999",,,.T.})
aAdd(aC,{"nDimz",{30,440},  "Dim Z","@e 99999",,,.T.}) 
aAdd(aC,{"nCubagem",{45,360},"Cubagem(m3)     ","@E 9,999.9999",,,.T.})
aAdd(aC,{"cRefcli",{45,08},  "Ped. Cliente    ","@!",,,.T.})
aAdd(aC,{"cRelInsp",{60,08}, "Rel. Inspecao","@!",,,.T.})
aAdd(aC,{"cDtlib",{60,310},  "Dt. Liberacao",,,,.T.})
aAdd(aC,{"nPesot",{60,400},  "Peso Total","@e 999999.99",,,.F.})
//                                                                    
// Coordenada do objeto Getdados 
//
aCGD:={120,5,135,315}
//aCGD:={44,5,118,315}

//
// Validacao na mudanca de linha e quando clicar no botao Ok 
//

//
// Atribuir a database do sistema a variável
//
dData := dDataBase
//
// Executar a função Modelo2() 
//
lRet := Modelo2(cTitulo,aC,aR,aCGD,nOpc,cLinOk,cAllOk,,,cIniCpos,nMax,acordw)
//
// Se confirmado...
//
If lRet
	//
	// Se opção for inclusao 
	//
	If nOpc == 3
		If MsgYesNo("Confirma gravacao dos dados ?",cTitulo)
			Processa({|| IncluSZO(cAlias)},cTitulo,"Gravando os dados, aguarde...")
		Endif
	//
	// Se opção for alteração
	//
	Elseif nOpc == 4
		If MsgYesNo("Confirma alteração dos dados ?",cTitulo)
			Processa({|| AlterSZO(cAlias)},cTitulo,"Alterando os dados, aguarde...")
		Endif
	//
	// Se opção for exclusão 
	//
	Elseif nOpc == 5
		If MsgYesNo("Confirma eliminação dos dados ?",cTitulo)
			Processa({|| ExcluSZO(cAlias)},cTitulo,"Excluíndo os dados, aguarde...")
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
±±³Programa   ³AlterSZO  ³ Autor ³ ROBSON BUENO          ³ Data ³ 23/03/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ CRIANDO A FUNCAO AlterSZO                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ Manorma                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AlterSZO(cAlias)

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
			(cAlias)->ZO_FILIAL := xFilial(cAlias)
			(cAlias)->ZO_ROMAN  := cRom
			(cAlias)->ZO_EMBAL  := cEmbala
			(cAlias)->ZO_EMISSAO:= cEmissao
			(cAlias)->ZO_REFCLI := cRefcli
			(cAlias)->ZO_RELINSP:= cRelinsp
			(cAlias)->ZO_DTLIB  := cDtlib 
			(cAlias)->ZO_DIMX   := nDimx
            (cAlias)->ZO_DIMY   := nDimy
            (cAlias)->ZO_DIMZ   := nDimz 
            (cAlias)->ZO_CUBAGEM:= nCubagem  
            (cAlias)->ZO_PSMERC := nPesot 
			
		Endif
		MsUnLock()
	Else
		If !aCOLS[i,Len(aHeader)+1]
			RecLock(cAlias,.T.)
			For y := 1 To Len(aHeader)
				FieldPut(FieldPos(Trim(aHeader[y,2])),aCOLS[i,y])
			Next y
			(cAlias)->ZO_FILIAL := xFilial(cAlias)
			(cAlias)->ZO_ROMAN  := cRom
			(cAlias)->ZO_EMBAL  := cEmbala
			(cAlias)->ZO_EMISSAO:= cEmissao
			(cAlias)->ZO_REFCLI := cRefcli
			(cAlias)->ZO_RELINSP:= cRelinsp
			(cAlias)->ZO_DTLIB  := cDtlib 
			(cAlias)->ZO_DIMX   := nDimx
            (cAlias)->ZO_DIMY   := nDimy
            (cAlias)->ZO_DIMZ   := nDimz 
            (cAlias)->ZO_CUBAGEM:= nCubagem
            (cAlias)->ZO_PSMERC := nPesot 
			
			MsUnLock()
		Endif
	Endif
Next i

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ExcluSZO  ³ Autor ³ ROBSON BUENO          ³ Data ³ 23/03/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ CRIANDO A FUNCAO ExcluSZO                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ Manorma                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ExcluSZO(cAlias)

ProcRegua(Len(aCOLS))

dbSelectArea(cAlias)
dbSetOrder(1)
dbSeek(xFilial(cAlias)+cRom)

While !Eof() .And. (cAlias)->ZO_FILIAL == xFilial(cAlias) .And. (cAlias)->ZO_ROMAN == cRom
	IncProc()
	// TRATA CONTROLE DE PROCESSO
	dbselectarea("PC2")
    dbSetOrder(6)
    MsSeek(xfilial("PC2")+(cAlias)->ZO_PEDIDO+(cAlias)->ZO_ITEM+"Embalagem:"+(cAlias)->ZO_ROMAN+" - "+(cAlias)->ZO_SEQ)
    IF SUBSTRING(PC2->PC2_INF,1,36)="Embalagem:"+(cAlias)->ZO_ROMAN+" - "+(cAlias)->ZO_SEQ
       // Primeiramente Verifica se tem processo posterior registrado
       IF U_HCIPDPR(PC2->PC2_NUM,PC2->PC2_ITEM,PC2->PC2_CTR)=.T.  // PEDIDO - ITEM - CONTROLE
         U_HCIEXPR(PC2->PC2_NUM,PC2->PC2_ITEM,PC2->PC2_CTR) 
       ELSE
         lOkOP:=.F.
       ENDIF  
    ENDIF
	// FIM DE TRATAMENTO
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
±±³Programa   ³IncluSZO  ³ Autor ³ MICROSIGA             ³ Data ³ 17/06/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ CRIANDO A FUNCAO IncluSZO                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ Manorma                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IncluSZO(cAlias)

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
		(cAlias)->ZO_FILIAL := xFilial(cAlias)
		(cAlias)->ZO_ROMAN  := cRom
		(cAlias)->ZO_EMBAL  := cEmbala
		(cAlias)->ZO_EMISSAO:= cEmissao
		(cAlias)->ZO_REFCLI := cRefcli
		(cAlias)->ZO_RELINSP:= cRelinsp
		(cAlias)->ZO_DTLIB  := cDtlib
		(cAlias)->ZO_DIMX   := nDimx
        (cAlias)->ZO_DIMY   := nDimy
        (cAlias)->ZO_DIMZ   := nDimz 
        (cAlias)->ZO_CUBAGEM:= nCubagem 
        (cAlias)->ZO_PSMERC  := nPesot 
	     MsUnLock()
	Endif
	// Trata Controle de Processo
	dbselectarea("PC2")
    dbSetOrder(4)
    MsSeek(xfilial("PC2")+(cAlias)->ZO_PEDIDO+(cAlias)->ZO_ITEM+"000024")
    if PC2->PC2_QTDORI-PC2->PC2_QTD>0 .and. PC2->PC2_NUM=(cAlias)->ZO_PEDIDO .AND. (cAlias)->ZO_ITEM=PC2->PC2_ITEM .AND. PC2->PC2_SEQ="000024"
       cRegistro:=PC2->PC2_CTR
       // 2 BAIXA O FATURAMENTO OS E POE EM AGUARDANDO RECEBIMENTO
        U_HCICTPR((cAlias)->ZO_PEDIDO,(cAlias)->ZO_ITEM,"000024","000025",(cAlias)->ZO_QTD,"Aguardando Faturamento","","","Embalagem:"+(cAlias)->ZO_ROMAN+" - "+(cAlias)->ZO_SEQ,cRegistro) 
    endif
Next i

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³SZOTUDOK  ³ Autor ³ MICROSIGA             ³ Data ³ 17/06/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ CRIANDO A FUNCAO SZOTUDOK                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ Manorma                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SZOTUDOK()

Local lRet 	:= .T.
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

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³SZOLIOK   ³ Autor ³ MICROSIGA             ³ Data ³ 17/06/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ VALIDANDO LINHA DO ROMANEIO                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ Manorma                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SZOLIOK()
Local aArea := (GetArea())         
Local lRet 	:= .T.

nPesot:=nPembal
FOR X=1 TO LEN(ACOLS)
 If aCOLS[X,Len(aHeader)+1]
 ELSE
  nPesot:=nPesot+acols[x,12] 
 ENDIF
Next
cRefcli:=Posicione("SC5",1,xFilial("SC5")+acols[1,2],"C5_COTCLI")
IF Posicione("SB1",1,xFilial("SB1")+acols[N,4],"B1_PESO")<>acols[N,7] .and. GETMV("MV_ROMPESO")=1
  If MsgYesNo("O PESO do Produto no romaneio esta diferente do valor obtido do cadastro de produto. Deseja alterar cadastro de produto?",cTitulo)
      dbSelectArea("SB1")
	  dbSetOrder(1)
	  IF MsSeek(xFilial("SB1")+acols[N,4])
        Reclock("SB1",.F.)
        SB1->B1_PESO:=acols[N,7]
        MsUnLock()        
      ENDIF 
      dbSelectArea("SB5")
	  dbSetOrder(1)
	  IF MsSeek(xFilial("SB5")+acols[N,4])
        Reclock("SB5",.F.)
        SB5->B5_PESO:=acols[N,7]
        MsUnLock()        
      ENDIF
  ENDIF
ENDIF 
RestArea(aArea)
Return(lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³RF019GP   ³ Autor ³ MICROSIGA             ³ Data ³ 17/06/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ CRIANDO A FUNCAO RF019GP                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ Manorma                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RF019GP(cCod)
Local lRet 	:= .T.
  
Return(lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³RF019RP   ³ Autor ³ MICROSIGA             ³ Data ³ 17/06/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ CRIANDO A FUNCAO RF019RP                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ Manorma                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RF019RP(cPed,cIt)

Local lRet 	:= .T.
cRefcli:=Posicione("SC5",1,xFilial("SC5")+cPed+cIt,"C5_COTCLI")
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
User Function RP019VL()
Local lRet 	:= .T.
nDimx:=Posicione("SZM",1,xFilial("SZM")+cEmbala,"ZM_DIMX")
nDimy:=Posicione("SZM",1,xFilial("SZM")+cEmbala,"ZM_DIMY")
nDimz:=Posicione("SZM",1,xFilial("SZM")+cEmbala,"ZM_DIMZ")
nPembal:=Posicione("SZM",1,xFilial("SZM")+cEmbala,"ZM_PESO")
nCubagem:=nDimx*nDimy*nDimZ/1000000

Return(lRet)



USER Function RFT019PR()

u_hcirap() 

Return                                                                                                                   