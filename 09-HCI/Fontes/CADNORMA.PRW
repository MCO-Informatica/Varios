/*/
??????????????????????????????????????????????????????????????????????????????
??????????????????????????????????????????????????????????????????????????????
??????????????????????????????????????????????????????????????????????????Ŀ??
???Programa   ? CADNORMA ? Autor ? ROBSON BUENO          ? Data ? 23/03/06 ???
??????????????????????????????????????????????????????????????????????????Ĵ??
???Descri??o  ? CADASTRO DE NORMAS DE MATERIAIS 						   ???	
???           ? CHAMADA PELA FUNCAO MODELO2()                              ???
??????????????????????????????????????????????????????????????????????????Ĵ??
???USO        ? REMOTE                                                     ???
???????????????????????????????????????????????????????????????????????????ٱ?
??????????????????????????????????????????????????????????????????????????????
??????????????????????????????????????????????????????????????????????????????
/*/
#include "Protheus.ch"
user Function CADNORMA()
//??????????????????????????????????????????????????????????Ŀ
//? DECLARAR AS VARIAVEIS aROTINA E cCADASTRO COMO PRIVATE,  ?
//? PORQUE A FUNCAO mBROWSE ESTA ESPERANDO....               ?
//????????????????????????????????????????????????????????????
Private aRotina := {}
Private cCadastro := "Cadastro de Normas"

//??????????????????????????????????????????????????????????Ŀ
//? MONTAR O VETOR aROTINA, OBRIGATORIO PARA UTILIZACAO DA   ?
//? FUNCAO mBROWSE                                           ?
//????????????????????????????????????????????????????????????
aAdd( aRotina, { "Pesquisar " , "AxPesqui   " , 0 , 1 })
aAdd( aRotina, { "Visualizar" , "u_manorma  " , 0 , 2 })
aAdd( aRotina, { "Incluir   " , "u_manorma   "   , 0 , 3 })
aAdd( aRotina, { "Alterar   " , "u_manorma   "   , 0 , 4 })
aAdd( aRotina, { "Excluir   " , "u_manorma   "   , 0 , 5 })

//??????????????????????????????????????????????????????????Ŀ
//? SELECIONAR A TABELA, ORDEM E POSICIONAR NO PRIMEIRO      ?
//? REGISTRO DA TABELA                                       ?
//????????????????????????????????????????????????????????????
dbSelectArea("SZN")
dbSetOrder(1)
dbGoTop()
//??????????????????????????????????????????????????????????Ŀ
//? EXECUTAR A FUNCAO mBROWSE PARA TABELA MENCIONADA         ?
//????????????????????????????????????????????????????????????
mBrowse(,,,,"SZN")
Return nil


/*/
??????????????????????????????????????????????????????????????????????????????
??????????????????????????????????????????????????????????????????????????????
??????????????????????????????????????????????????????????????????????????Ŀ??
???Programa   ?Manorma   ? Autor ? Robson Bueno          ? Data ? 23/03/07 ???
??????????????????????????????????????????????????????????????????????????Ĵ??
???Descri??o  ? CRIANDO A FUNCAO Manorma                                   ???
??????????????????????????????????????????????????????????????????????????Ĵ??
???USO        ? REMOTE                                                     ???
???????????????????????????????????????????????????????????????????????????ٱ?
??????????????????????????????????????????????????????????????????????????????
??????????????????????????????????????????????????????????????????????????????
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
aGd		: Array com as posi??es para edi??o dos itens (GETDADOS)
nOp:	: Modo de operacao (3 ou 4 altera e inclui itens, 6 altera mas nao 
		  inclui itens, qualquer outro numero so visualiza os itens)
cLOk 	: Fun??o para valida??o da linha
cTOk 	: Fun??o para valida??o de todos os dados (na confirma??o)
aGetsGD : Array Gets edit?veis (GetDados) * Default = Todos.
bF4 	: Codeblock a ser atribu?do a tecla F4. *Default = Nenhum.
cIniCpos: String com o nome dos campos que devem ser inicializados ao teclar seta para baixo (GetDados).
nMAx 	: Limita o numero de linhas (GetDados). *Default = 99.
aCordw  : Array com quatro elementos numericos, correspondendo ?s coordenadas linha superior, 
		  coluna esquerda, linha interior e coluna direita, definindo a area de tela a ser usada. 
		  *Default = area de Dados Livre.
lDelget : Determina se as linhas podem ser deletadas ou nao (GetDados) *Default = .T.

Retorna:
lRet 	: Retorna .T. se for confirmado
/*/

User Function Manorma(cAlias,nReg,nOpc)
//????????????????????????Ŀ
//? DECLARACAO DE VARIAVEIS?
//??????????????????????????
Local cChave := ""
Local nCOLS  := 0
Local i 	 := 0
Local lRet   :=.F.
//???????????????????????????????????????????????????????????Ŀ
//? VARIAVEIS QUE SERVIRAO DE PARAMETROS PARA A FUNCAO MODELO2?
//?????????????????????????????????????????????????????????????
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
//?????????????????????????????????Ŀ
//? CRIA VARIAVEIS DE MEMORIA M->????
//???????????????????????????????????
dbSelectArea(cAlias)
For i := 1 To FCount()
	M->&(Eval(bCampo,i)) := CriaVar(FieldName(i),.T.)
Next nX
//????????????????????????????????????????????????Ŀ
//? CRIA VETOR aHEADER CONFORME DICIONARIO DE DADOS?
//??????????????????????????????????????????????????
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
//??????????????????????????????????????????????????????Ŀ
//? SE A OPCAO FOR DIFERENTE DE INCLUIR, ENTAO ATRIBUIR  ?
//? OS DADOS NO VETOR aCOLS. CASO CONTRARIO, CRIAR O     ?
//? VETOR aCOLS COM A CARACTERISTICA DE CADA CAMPO       ?
//????????????????????????????????????????????????????????
If nOpc <> 3
	cCod := (cAlias)->ZN_COD
    cNormad:= (cAlias)->ZN_NORMAT
    cNormat:= (cAlias)->ZN_DESCRI
	//??????????????????????????????????????????????????????Ŀ
	//? DEVE-SE POSICIONAR, PORQUE NUNCA SE SABE EM QUAL ITEM?
	//? ESTA, E NECESSARIO PEGAR TODOS OS ITENS.             ?
	//????????????????????????????????????????????????????????
	dbSeek(xFilial(cAlias)+cCod)
	While !Eof() .And. (cAlias)->(ZN_FILIAL+ZN_COD) == xFilial(cAlias)+ cCod
		//
		// Criar o vetor com sua devida dimens?o em rela??o ao dicion?rio de dados 
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
		// Criar uma ?ltima coluna para o controle da Getdados, se deletado ou n?o 
		//
		aCOLS[nCOLS,Len(aHeader)+1] := .F.
		//
		// Atribuir o n?mero do registro neste vetor para o controle na grava??o 
		//
		aAdd(aAlt,RecNo())
		dbSelectArea(cAlias)
		dbSkip()
	End
Else
	//
	// Atribuir ? vari?vel o inicializador padr?o do campo 
	//
   	//cNorma := GetSxeNum("SZN","ZN_COD")
   	//cNormad:= GetSxeNum("SZN","ZN_NORMA")
    //cNormat:= GetSxeNum("SZN","ZN_DESCRI")
	//
	// Criar o vetor com sua devida dimens?o em rela??o ao dicion?rio de dados 
	//
	aAdd(aCOLS,Array(Len(aHeader)+1))
	For i := 1 To Len(aHeader)
		aCOLS[1,i] := CriaVar(aHeader[i,2])
	Next i
	//
	// Criar uma ?ltima coluna para o controle da Getdados, se deletado ou n?o 
	//
	aCOLS[1,Len(aHeader)+1] := .F.
	
	//
	// Atribuir 01 para a primeira linha da Getdados
	//
	aCOLS[1,aScan(aHeader,{|x|Trim(x[2])=="ZN_ITEM"})] := "01"
Endif
//
//Caracter?stica do vetor
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
// Atribuir a database do sistema a vari?vel
//
dData := dDataBase
//
// Executar a fun??o Modelo2() 
//
lRet := Modelo2(cTitulo,aC,aR,aCGD,nOpc,cLinOk,cAllOk,,,cIniCpos,nMax)
//
// Se confirmado...
//
If lRet
	//
	// Se op??o for inclusao 
	//
	If nOpc == 3
		If MsgYesNo("Confirma gravacao dos dados ?",cTitulo)
			Processa({|| IncluSZN(cAlias)},cTitulo,"Gravando os dados, aguarde...")
		Endif
	//
	// Se op??o for altera??o
	//
	Elseif nOpc == 4
		If MsgYesNo("Confirma altera??o dos dados ?",cTitulo)
			Processa({|| AlterSZN(cAlias)},cTitulo,"Alterando os dados, aguarde...")
		Endif
	//
	// Se op??o for exclus?o 
	//
	Elseif nOpc == 5
		If MsgYesNo("Confirma elimina??o dos dados ?",cTitulo)
			Processa({|| ExcluSZN(cAlias)},cTitulo,"Exclu?ndo os dados, aguarde...")
		Endif
	Endif
Else
	//
	// Se n?o confirmado, reestabelecer a n?mera??o autom?tica do cadastro
	//
	RollBackSX8()
Endif

Return

/*/
??????????????????????????????????????????????????????????????????????????????
??????????????????????????????????????????????????????????????????????????????
??????????????????????????????????????????????????????????????????????????Ŀ??
???Programa   ?MD2ALTER  ? Autor ? ROBSON BUENO          ? Data ? 23/03/07 ???
??????????????????????????????????????????????????????????????????????????Ĵ??
???Descri??o  ? CRIANDO A FUNCAO alterszn                                  ???
??????????????????????????????????????????????????????????????????????????Ĵ??
???USO        ? Manorma                                                    ???
???????????????????????????????????????????????????????????????????????????ٱ?
??????????????????????????????????????????????????????????????????????????????
??????????????????????????????????????????????????????????????????????????????
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
??????????????????????????????????????????????????????????????????????????????
??????????????????????????????????????????????????????????????????????????????
??????????????????????????????????????????????????????????????????????????Ŀ??
???Programa   ?MD2EXCLU  ? Autor ? ROBSON BUENO          ? Data ? 23/03/07 ???
??????????????????????????????????????????????????????????????????????????Ĵ??
???Descri??o  ? CRIANDO A FUNCAO ExcluSZN                                  ???
??????????????????????????????????????????????????????????????????????????Ĵ??
???USO        ? Manorma                                                    ???
???????????????????????????????????????????????????????????????????????????ٱ?
??????????????????????????????????????????????????????????????????????????????
??????????????????????????????????????????????????????????????????????????????
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
??????????????????????????????????????????????????????????????????????????????
??????????????????????????????????????????????????????????????????????????????
??????????????????????????????????????????????????????????????????????????Ŀ??
???Programa   ?MD2INCLU  ? Autor ? MICROSIGA             ? Data ? 17/06/05 ???
??????????????????????????????????????????????????????????????????????????Ĵ??
???Descri??o  ? CRIANDO A FUNCAO IncluSZN                                  ???
??????????????????????????????????????????????????????????????????????????Ĵ??
???USO        ? Manorma                                                    ???
???????????????????????????????????????????????????????????????????????????ٱ?
??????????????????????????????????????????????????????????????????????????????
??????????????????????????????????????????????????????????????????????????????
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
??????????????????????????????????????????????????????????????????????????????
??????????????????????????????????????????????????????????????????????????????
??????????????????????????????????????????????????????????????????????????Ŀ??
???Programa   ?MD2TUDOK  ? Autor ? MICROSIGA             ? Data ? 17/06/05 ???
??????????????????????????????????????????????????????????????????????????Ĵ??
???Descri??o  ? CRIANDO A FUNCAO SZNTUDOK                                  ???
??????????????????????????????????????????????????????????????????????????Ĵ??
???USO        ? Manorma                                                    ???
???????????????????????????????????????????????????????????????????????????ٱ?
??????????????????????????????????????????????????????????????????????????????
??????????????????????????????????????????????????????????????????????????????
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
