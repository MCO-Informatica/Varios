/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ CADNORMA ³ Autor ³ ROBSON BUENO          ³ Data ³ 23/03/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ CADASTRO DE NORMAS DE MATERIAIS 						   ³±±	
±±³           ³ CHAMADA PELA FUNCAO MODELO2()                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ REMOTE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
#include "Protheus.ch"
user Function CADNORMA()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ DECLARAR AS VARIAVEIS aROTINA E cCADASTRO COMO PRIVATE,  ³
//³ PORQUE A FUNCAO mBROWSE ESTA ESPERANDO....               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aRotina := {}
Private cCadastro := "Cadastro de Normas"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MONTAR O VETOR aROTINA, OBRIGATORIO PARA UTILIZACAO DA   ³
//³ FUNCAO mBROWSE                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd( aRotina, { "Pesquisar " , "AxPesqui   " , 0 , 1 })
aAdd( aRotina, { "Visualizar" , "u_manorma  " , 0 , 2 })
aAdd( aRotina, { "Incluir   " , "u_manorma   "   , 0 , 3 })
aAdd( aRotina, { "Alterar   " , "u_manorma   "   , 0 , 4 })
aAdd( aRotina, { "Excluir   " , "u_manorma   "   , 0 , 5 })

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SELECIONAR A TABELA, ORDEM E POSICIONAR NO PRIMEIRO      ³
//³ REGISTRO DA TABELA                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SZN")
dbSetOrder(1)
dbGoTop()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ EXECUTAR A FUNCAO mBROWSE PARA TABELA MENCIONADA         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
mBrowse(,,,,"SZN")
Return nil


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³Manorma   ³ Autor ³ Robson Bueno          ³ Data ³ 23/03/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ CRIANDO A FUNCAO Manorma                                   ³±±
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

User Function Manorma(cAlias,nReg,nOpc)
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
Private cLinOk   := ""
Private cAllOk   := "u_SZNTudOk()"
Private aGetsGD  := {}
Private bF4      := {|| }
Private cIniCpos := "+ZN_ITEM"
Private nMax     := 99
Private aCordW   := {}
Private lDelGetD := .T.
Private aHeader  := {}
Private aCOLS    := {}
Private nCount   := 0
Private bCampo   := {|nField| FieldName(nField) }
Private cCod	 := space(6)
Private cNormad  := space(30)
Private cNormat  := space(60)

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
	If X3Uso(X3_USADO) .And. cNivel >= X3_NIVEL .And. !(Trim(X3_CAMPO)$"ZN_COD") .AND. !(TRIM(X3_CAMPO)$"ZN_NORMAT") .AND. !(TRIM(X3_CAMPO)$"ZN_DESCRI")
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
	cCod := (cAlias)->ZN_COD
    cNormad:= (cAlias)->ZN_NORMAT
    cNormat:= (cAlias)->ZN_DESCRI
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ DEVE-SE POSICIONAR, PORQUE NUNCA SE SABE EM QUAL ITEM³
	//³ ESTA, E NECESSARIO PEGAR TODOS OS ITENS.             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSeek(xFilial(cAlias)+cCod)
	While !Eof() .And. (cAlias)->(ZN_FILIAL+ZN_COD) == xFilial(cAlias)+ cCod
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
	aCOLS[1,aScan(aHeader,{|x|Trim(x[2])=="ZN_ITEM"})] := "01"
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
aAdd(aC,{"cCod", {15,10}, "Codigo"         ,"@!"      ,,,.T.})
aAdd(aC,{"cNormaD", {15,80},"Norma"         ,"@!"      ,,,.T.})
aAdd(aC,{"cNormat", {30,11},"Literal "       ,"@!"      ,,,.T.})

//
// Coordenada do objeto Getdados 
//
aCGD:={50,5,118,315}
//
// Validacao na mudanca de linha e quando clicar no botao Ok 
//
cLinOk := "AllwaysTrue()"
//
// Atribuir a database do sistema a variável
//
dData := dDataBase
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
		If MsgYesNo("Confirma gravacao dos dados ?",cTitulo)
			Processa({|| IncluSZN(cAlias)},cTitulo,"Gravando os dados, aguarde...")
		Endif
	//
	// Se opção for alteração
	//
	Elseif nOpc == 4
		If MsgYesNo("Confirma alteração dos dados ?",cTitulo)
			Processa({|| AlterSZN(cAlias)},cTitulo,"Alterando os dados, aguarde...")
		Endif
	//
	// Se opção for exclusão 
	//
	Elseif nOpc == 5
		If MsgYesNo("Confirma eliminação dos dados ?",cTitulo)
			Processa({|| ExcluSZN(cAlias)},cTitulo,"Excluíndo os dados, aguarde...")
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
±±³Programa   ³MD2ALTER  ³ Autor ³ ROBSON BUENO          ³ Data ³ 23/03/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ CRIANDO A FUNCAO alterszn                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ Manorma                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AlterSZN(cAlias)

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
		Endif
		MsUnLock()
	Else
		If !aCOLS[i,Len(aHeader)+1]
			RecLock(cAlias,.T.)
			For y := 1 To Len(aHeader)
				FieldPut(FieldPos(Trim(aHeader[y,2])),aCOLS[i,y])
			Next y
			(cAlias)->ZN_COD := cCod
			(cAlias)->ZN_NORMAT := cNormad
			(cAlias)->ZN_DESCRI := cNormat
			MsUnLock()
		Endif
	Endif
Next i

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³MD2EXCLU  ³ Autor ³ ROBSON BUENO          ³ Data ³ 23/03/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ CRIANDO A FUNCAO ExcluSZN                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ Manorma                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ExcluSZN(cAlias)

ProcRegua(Len(aCOLS))

dbSelectArea(cAlias)
dbSetOrder(1)
dbSeek(xFilial(cAlias)+cCod)

While !Eof() .And. (cAlias)->ZN_FILIAL == xFilial(cAlias) .And. (cAlias)->ZN_COD == cCod
	IncProc()
	RecLock(cAlias,.F.)
	dbDelete()
	MsUnLock()
	dbSkip()
End

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³MD2INCLU  ³ Autor ³ MICROSIGA             ³ Data ³ 17/06/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ CRIANDO A FUNCAO IncluSZN                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ Manorma                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function IncluSZN(cAlias)

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
		(cAlias)->ZN_FILIAL := xFilial(cAlias)
		(cAlias)->ZN_COD := cCod
		(cAlias)->ZN_NORMAT := cNormad
		(cAlias)->ZN_DESCRI := cNormat
		MsUnLock()
	Endif
Next i

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³MD2TUDOK  ³ Autor ³ MICROSIGA             ³ Data ³ 17/06/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ CRIANDO A FUNCAO SZNTUDOK                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ Manorma                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SZNTudOk()

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
