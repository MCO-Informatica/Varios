/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ RFATA024 ³ Autor ³ ROBSON BUENO          ³ Data ³ 25/10/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ CONTROLE DE PROCESSO             						   ³±±	
±±³           ³ CHAMADA PELA FUNCAO MODELO2()                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ REMOTE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
#include "Protheus.ch"
#INCLUDE "Rwmake.CH" 

user Function RFATA024()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ DECLARAR AS VARIAVEIS aROTINA E cCADASTRO COMO PRIVATE,  ³
//³ PORQUE A FUNCAO mBROWSE ESTA ESPERANDO....               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aCores    := {},aCampos:={}
Private aRotina := {}
Private cCadastro := "CONTROLE DE PROCESSO"


aCores    := {{	'PC2_DTFIM==CTOD("  /  /  ")', 'BR_VERMELHO'},;		// Processo Pendente
			   {'PC2_DTFIM<>CTOD("  /  /  ")', 'BR_VERDE'}}         // Processo Finalizado	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MONTAR O VETOR aROTINA, OBRIGATORIO PARA UTILIZACAO DA   ³
//³ FUNCAO mBROWSE                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd( aRotina, { "Pesquisar  " 	, "AxPesqui   " , 0 , 1 })
aAdd( aRotina, { "Visualizar " 	, "u_RFAT24V  " , 0 , 2 })
aAdd( aRotina, { "Reg. Acao  " 	, "u_RFAT24R  " , 0 , 4 })
aAdd( aRotina, { "Reg. Rapido" 	, "u_RFAT24RP  " , 0 , 5 })
aAdd( aRotina, { "Excluir Fase" 	, "u_RFAT24E  " , 0 , 8 })
aAdd( aRotina, { "Excluir Proc" 	, "u_RFAT24V  " , 0 , 6 })
aAdd( aRotina, { "Legenda"			, "u_RFATLG  " ,	0 , 7 })
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SELECIONAR A TABELA, ORDEM E POSICIONAR NO PRIMEIRO      ³
//³ REGISTRO DA TABELA                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("PC2")
dbSetOrder(1)
dbGoTop()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ EXECUTAR A FUNCAO mBROWSE PARA TABELA MENCIONADA         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
mBrowse(6,1,22,75,"PC2",,,,,3,aCores)
Return nil


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³RFAT24I   ³ Autor ³ Robson Bueno          ³ Data ³ 23/03/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ CRIANDO A FUNCAO RFAT24I                                   ³±±
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

User Function RFAT24V(cAlias,nReg,nOpc)
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
Private cLinOk   := "u_PC2LIOK()"
Private cAllOk   := "u_PC2TudOk()"
Private aGetsGD  := {}
Private bF4      := {|| }
Private cIniCpos := "+_R_E_C_N_O"
Private nMax     := 999
Private aCordW   := {0,0,414,635}
Private lDelGetD := .T.
Private aHeader  := {}
Private aCOLS    := {}
Private nCount   := 0
Private bCampo   := {|nField| FieldName(nField) }
Private cNum	 	:= space(6)
Private cCliente	:= space(6)
Private cLoja 		:=Space(2)
Private cApelido	:= space(40)
Private cPedidocli := Space(40)
Private cEmissao := Ctod(" / / ")



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
	                   !(Trim(X3_CAMPO)$"PC2_NUM")   .And. ;
	                   !(TRIM(X3_CAMPO)$"PC2_CLI")   .And. ;
	                   !(TRIM(X3_CAMPO)$"PC2_LOJA") .And. ;
	                   !(TRIM(X3_CAMPO)$"PC2_PEDCLI")  
	                  
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
   cNum	 		:= (cAlias)->PC2_NUM
   cCliente		:= (cAlias)->PC2_CLI
   cLoja 		:= (cAlias)->PC2_LOJA
   cApelido		:= Posicione("SA1",1,xFilial("SA1")+(cAlias)->PC2_CLI+(cAlias)->PC2_LOJA,"A1_NREDUZ")
   cPedidocli 	:= (cAlias)->PC2_PEDCLI
   cEmissao     := (cAlias)->PC2_DREG  
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ DEVE-SE POSICIONAR, PORQUE NUNCA SE SABE EM QUAL ITEM³
	//³ ESTA, E NECESSARIO PEGAR TODOS OS ITENS.             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSeek(xFilial(cAlias)+cNum)
	While !Eof() .And. (cAlias)->(PC2_FILIAL+PC2_NUM) == xFilial(cAlias)+ cNum
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
aAdd(aC,{"cNum",{15,08},     "Pedido n.       ","@!",,,.T.})
aAdd(aC,{"cEmissao",{15,360},"Emissao       ",,,,.T.})
aAdd(aC,{"cCliente",{30,08},  "Cliente          ","@!",,,.T.})
aAdd(aC,{"cLoja   ",{30,120},  "Loja",,,,.T.})
aAdd(aC,{"cApelido",{30,180},  "Nome Fant.",,,,.T.})
//aAdd(aC,{"nDimz",{30,440},  "Dim Z","@e 99999",,,.T.}) 
//aAdd(aC,{"nCubagem",{45,360},"Cubagem(m3)     ","@e 99.99",,,.T.})
//aAdd(aC,{"cRefcli",{45,08},  "Ped. Cliente    ","@!",,,.T.})
//aAdd(aC,{"cRelInsp",{60,08}, "Rel. Inspecao","@!",,,.T.})
//aAdd(aC,{"cDtlib",{60,310},  "Dt. Liberacao",,,,.T.})
//aAdd(aC,{"nPesot",{60,400},  "Peso Total","@e 999999.99",,,.F.})
//                                                                    
// Coordenada do objeto Getdados 
//
aCGD:={120,5,118,315}
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
lRet := Modelo2(cTitulo,aC,aR,aCGD,nOpc,cLinOk,cAllOk,,,cIniCpos,nMax)
//
// Se confirmado...
//
If lRet
	//
	// Se opção for inclusao 
	//
    if nOpc == 6
		If MsgYesNo("Confirma eliminação dos dados ?",cTitulo)
			Processa({|| ExcluPC2(cAlias)},cTitulo,"Excluíndo os dados, aguarde...")
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
±±³Programa   ³ExcluSZO  ³ Autor ³ ROBSON BUENO          ³ Data ³ 23/03/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ CRIANDO A FUNCAO ExcluSZO                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ Manorma                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ExcluPC2(cAlias)

ProcRegua(Len(aCOLS))

dbSelectArea(cAlias)
dbSetOrder(1)
dbSeek(xFilial(cAlias)+cNum)
While !Eof() .And. (cAlias)->PC2_FILIAL == xFilial(cAlias) .And. (cAlias)->PC2_Num == cNum
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
±±³Programa   ³ExcluSZO  ³ Autor ³ ROBSON BUENO          ³ Data ³ 23/03/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ CRIANDO A FUNCAO ExcluSZO                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ Manorma                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RFAT24E(cAlias)
Local nSaldo:=0
if MsgYesNo("Confirma eliminação dos dados ?","Exclusao de Registro")
  nSaldo:=PC2->PC2_QTD 
  DO WHILE (nSaldo>0) 
    IF U_HCIPDPR(PC2->PC2_NUM,PC2->PC2_ITEM,PC2->PC2_CTR)=.T.  // PEDIDO - ITEM - CONTROLE
      U_HCIEXPR(PC2->PC2_NUM,PC2->PC2_ITEM,PC2->PC2_CTR) 
      nSaldo:=PC2->PC2_QTD
    ELSE
      MsgInfo("O sistema nao permite a Eliminação de Dados com movimento de baixa....", "Processo Invalido") 
      nSaldo:=0
    ENDIF  
  enddo
endif

Return









/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³RFATR24R  ³ Autor ³ MICROSIGA             ³ Data ³ 17/06/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ CRIANDO A FUNCAO IncluPC2                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ Manorma                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RFAT24R(cAlias,nReg,nOpc)

//Local nOpca 
//nOpca := AxAltera(cAlias,nReg,nOpc,,,,,"U_PC2TUDOK")
//Return
// Variaveis Locais da Funcao
STATIC aComboBx1	 := {}
STATIC aComboBx2	 := {}
STATIC aComboBx3	 := {}
STATIC aComboBx4	 := {}
STATIC aComboBx5	 := {}
STATIC cComboBx1
STATIC cComboBx2
STATIC cComboBx3
STATIC cComboBx4
STATIC cComboBx5
STATIC cGet1	 := Space(6)
STATIC cGet2	 := Space(35)
STATIC cGet8	 := Space(20)
STATIC cGet9	 := Space(20)
STATIC cGet10	 := Space(20)
STATIC cGet11	 := Space(20)
STATIC cGet12	 := Space(20)
STATIC cGet13	 := Space(20)
STATIC cGet14	 := Space(20)
STATIC cGet15	 := Space(20)
STATIC cGet16	 := Space(20)
STATIC cGet17	 := Space(20)
STATIC cGet18	 := Space(50)
STATIC cGet19	 := Space(50)
STATIC cGet20	 := Space(50)
STATIC cGet21	 := Space(50)
STATIC cGet22	 := Space(50)
STATIC cGet89	 := Space(50)
STATIC nGet3	 := 0
STATIC nGet4	 := 0
STATIC nGet5	 := 0
STATIC nGet6	 := 0
STATIC nGet7	 := 0
STATIC oGet1
STATIC oGet10 
STATIC oGet89
STATIC oGet11
STATIC oGet12
STATIC oGet13
STATIC oGet14
STATIC oGet15
STATIC oGet16
STATIC oGet17
STATIC oGet18
STATIC oGet19
STATIC oGet2
STATIC oGet20
STATIC oGet21
STATIC oGet22
STATIC oGet3
STATIC oGet4
STATIC oGet5
STATIC oGet6
STATIC oGet7
STATIC oGet8
STATIC oGet9
STATIC cRothci
// Variaveis Private da Funcao
Private oDlg				// Dialog Principal
// Variaveis que definem a Acao do Formulario
Private VISUAL := .F.                        
Private INCLUI := .F.                        
Private ALTERA := .F.                        
Private DELETA := .F.      
// VERIFICA SE ABRE OU NAO A ROTINA
IF PC2->PC2_DTFIM<>CTOD("  /  /  ")
  MsgInfo("O sistema nao encontrou processo PENDENTE no item selecionado. Selecioneum item pendente de disposicao....", "Processo Invalido") 
  RETURN
ENDIF
cRothci:=PC2->PC2_SEQ+" - Proc: "+TRIM(Posicione("PC1",1,xFilial("PC1")+"PV0001"+PC2->PC2_SEQ,"PC1_DESAT"))
aComboBx1	 := {}
aComboBx2	 := {}
aComboBx3	 := {}
aComboBx4	 := {}
aComboBx5	 := {}


	IF PC2->PC2_SEQP1<>"      " 
	  aAdd(aComboBx1,PC2->PC2_SEQP1+" - "+Posicione("PC1",1,xFilial("PC1")+"PV0001"+(cAlias)->PC2_SEQP1,"PC1_DESAT"))
	  aAdd(aComboBx2,PC2->PC2_SEQP1+" - "+Posicione("PC1",1,xFilial("PC1")+"PV0001"+(cAlias)->PC2_SEQP1,"PC1_DESAT"))
	  aAdd(aComboBx3,PC2->PC2_SEQP1+" - "+Posicione("PC1",1,xFilial("PC1")+"PV0001"+(cAlias)->PC2_SEQP1,"PC1_DESAT"))
	  aAdd(aComboBx4,PC2->PC2_SEQP1+" - "+Posicione("PC1",1,xFilial("PC1")+"PV0001"+(cAlias)->PC2_SEQP1,"PC1_DESAT"))
	  aAdd(aComboBx5,PC2->PC2_SEQP1+" - "+Posicione("PC1",1,xFilial("PC1")+"PV0001"+(cAlias)->PC2_SEQP1,"PC1_DESAT"))
    ENDIF
    IF PC2->PC2_SEQP2<>"      " 
	  aAdd(aComboBx1,PC2->PC2_SEQP2+" - "+Posicione("PC1",1,xFilial("PC1")+"PV0001"+(cAlias)->PC2_SEQP2,"PC1_DESAT"))
	  aAdd(aComboBx2,PC2->PC2_SEQP2+" - "+Posicione("PC1",1,xFilial("PC1")+"PV0001"+(cAlias)->PC2_SEQP2,"PC1_DESAT"))
	  aAdd(aComboBx3,PC2->PC2_SEQP2+" - "+Posicione("PC1",1,xFilial("PC1")+"PV0001"+(cAlias)->PC2_SEQP2,"PC1_DESAT"))
	  aAdd(aComboBx4,PC2->PC2_SEQP2+" - "+Posicione("PC1",1,xFilial("PC1")+"PV0001"+(cAlias)->PC2_SEQP2,"PC1_DESAT"))
	  aAdd(aComboBx5,PC2->PC2_SEQP2+" - "+Posicione("PC1",1,xFilial("PC1")+"PV0001"+(cAlias)->PC2_SEQP1,"PC1_DESAT"))
    ENDIF
    IF PC2->PC2_SEQP3<>"      " 
	  aAdd(aComboBx1,PC2->PC2_SEQP3+" - "+Posicione("PC1",1,xFilial("PC1")+"PV0001"+(cAlias)->PC2_SEQP3,"PC1_DESAT"))
	  aAdd(aComboBx2,PC2->PC2_SEQP3+" - "+Posicione("PC1",1,xFilial("PC1")+"PV0001"+(cAlias)->PC2_SEQP3,"PC1_DESAT"))
	  aAdd(aComboBx3,PC2->PC2_SEQP3+" - "+Posicione("PC1",1,xFilial("PC1")+"PV0001"+(cAlias)->PC2_SEQP3,"PC1_DESAT"))
	  aAdd(aComboBx4,PC2->PC2_SEQP3+" - "+Posicione("PC1",1,xFilial("PC1")+"PV0001"+(cAlias)->PC2_SEQP3,"PC1_DESAT"))
	  aAdd(aComboBx5,PC2->PC2_SEQP3+" - "+Posicione("PC1",1,xFilial("PC1")+"PV0001"+(cAlias)->PC2_SEQP3,"PC1_DESAT"))
    ENDIF
    IF PC2->PC2_SEQP4<>"      " 
	  aAdd(aComboBx1,PC2->PC2_SEQP4+" - "+Posicione("PC1",1,xFilial("PC1")+"PV0001"+(cAlias)->PC2_SEQP4,"PC1_DESAT"))
	  aAdd(aComboBx2,PC2->PC2_SEQP4+" - "+Posicione("PC1",1,xFilial("PC1")+"PV0001"+(cAlias)->PC2_SEQP4,"PC1_DESAT"))
	  aAdd(aComboBx3,PC2->PC2_SEQP4+" - "+Posicione("PC1",1,xFilial("PC1")+"PV0001"+(cAlias)->PC2_SEQP4,"PC1_DESAT"))
	  aAdd(aComboBx4,PC2->PC2_SEQP4+" - "+Posicione("PC1",1,xFilial("PC1")+"PV0001"+(cAlias)->PC2_SEQP4,"PC1_DESAT"))
	  aAdd(aComboBx5,PC2->PC2_SEQP4+" - "+Posicione("PC1",1,xFilial("PC1")+"PV0001"+(cAlias)->PC2_SEQP4,"PC1_DESAT"))
    ENDIF
                  

DEFINE MSDIALOG oDlg TITLE "Registro de Processo" FROM C(204),C(187) TO C(600),C(947) PIXEL

	// Cria as Groups do Sistema
	@ C(078+30),C(001) TO C(152+30),C(377) LABEL "Acoes P/: "+cRotHci PIXEL OF oDlg

	// Cria Componentes Padroes do Sistema

	@ C(003),C(002) Say "Pedido N." Size C(040),C(007) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(001),C(030) MsGet oGet1 Var cGet1 Size C(035),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg READONLY
	@ C(002),C(068) Say "Cliente" Size C(018),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(001),C(090) MsGet oGet2 Var cGet2 Size C(090),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg READONLY
	@ C(003),C(180) Say "Obs Atual" Size C(032),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(001),C(250) MsGet oGet89 Var cGet89 Size C(090),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg
	@ C(015),C(003) Say "Status do Item" Size C(040),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(080+30),C(147) Say "Qtd" Size C(015),C(007) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(080+30),C(175) Say "RI" Size C(008),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(080+30),C(232) Say "Corrida" Size C(018),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(080+30),C(289) Say "Obs ProcNovo" Size C(032),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(087+30),C(025) ComboBox cComboBx1 Items aComboBx1 Size C(120),C(010) PIXEL OF oDlg
	@ C(087+30),C(147) MsGet oGet3 Var nGet3 Size C(025),C(009) COLOR CLR_BLACK Picture "@E 9999.9" PIXEL OF oDlg
	@ C(087+30),C(175) MsGet oGet8 Var cGet8 Size C(055),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg
	@ C(087+30),C(232) MsGet oGet13 Var cGet13 Size C(055),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg
	@ C(087+30),C(289) MsGet oGet18 Var cGet18 Size C(080),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg
	@ C(089+30),C(005) Say "Acao1" Size C(018),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(099+30),C(025) ComboBox cComboBx2 Items aComboBx2 Size C(120),C(010) PIXEL OF oDlg
	@ C(099+30),C(147) MsGet oGet4 Var nGet4 Size C(025),C(009) COLOR CLR_BLACK Picture "@E 9999.9" PIXEL OF oDlg
	@ C(099+30),C(175) MsGet oGet9 Var cGet9 Size C(055),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg
	@ C(099+30),C(232) MsGet oGet14 Var cGet14 Size C(055),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg
	@ C(099+30),C(289) MsGet oGet19 Var cGet19 Size C(080),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg
	@ C(101+30),C(005) Say "Acao2" Size C(018),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(111+30),C(025) ComboBox cComboBx3 Items aComboBx3 Size C(120),C(010) PIXEL OF oDlg
	@ C(111+30),C(147) MsGet oGet5 Var nGet5 Size C(025),C(009) COLOR CLR_BLACK Picture "@E 9999.9" PIXEL OF oDlg
	@ C(111+30),C(175) MsGet oGet10 Var cGet10 Size C(055),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg
	@ C(111+30),C(232) MsGet oGet15 Var cGet15 Size C(055),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg
	@ C(111+30),C(289) MsGet oGet20 Var cGet20 Size C(080),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg
	@ C(113+30),C(005) Say "Acao3" Size C(020),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(123+30),C(025) ComboBox cComboBx4 Items aComboBx4 Size C(120),C(010) PIXEL OF oDlg
	@ C(123+30),C(147) MsGet oGet6 Var nGet6 Size C(025),C(009) COLOR CLR_BLACK Picture "@E 9999.9" PIXEL OF oDlg
	@ C(123+30),C(175) MsGet oGet11 Var cGet11 Size C(055),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg
	@ C(123+30),C(232) MsGet oGet16 Var cGet16 Size C(055),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg
	@ C(123+30),C(289) MsGet oGet21 Var cGet21 Size C(080),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg
	@ C(125+30),C(005) Say "Acao4" Size C(019),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(135+30),C(025) ComboBox cComboBx5 Items aComboBx5 Size C(120),C(010) PIXEL OF oDlg
	@ C(135+30),C(147) MsGet oGet7 Var nGet7 Size C(025),C(009) COLOR CLR_BLACK Picture "@E 9999.9" PIXEL OF oDlg
	@ C(135+30),C(175) MsGet oGet12 Var cGet12 Size C(055),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg
	@ C(135+30),C(232) MsGet oGet17 Var cGet17 Size C(055),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg
	@ C(135+30),C(289) MsGet oGet22 Var cGet22 Size C(080),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg
	@ C(137+30),C(005) Say "Acao5" Size C(018),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(170+15),C(003) Button "Ok" Size C(037),C(012) PIXEL OF oDlg ACTION RF024OK(odlg)
	@ C(170+15),C(044) Button "Cancela" Size C(037),C(012) PIXEL OF oDlg ACTION Finaliza(odlg)

	// Chamadas das DbTrees do Sistema
	cGet1:=PC2->PC2_NUM
	cGet2:=Posicione("SA1",1,xFilial("SA1")+(cAlias)->PC2_CLI+(cAlias)->PC2_LOJA,"A1_NREDUZ")
	  
	fDbTree1()
   
	// Cria ExecBlocks dos Componentes Padroes do Sistema

ACTIVATE MSDIALOG oDlg CENTERED 

Return(.T.)


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
User Function PC2TUDOK()



Return(.t.)

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
User Function PC2LIOK()
Local lRet  := .T.
Local aArea := (GetArea())         

RestArea(aArea)
Return(lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³RF024GP   ³ Autor ³ MICROSIGA             ³ Data ³ 17/06/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ CRIANDO A FUNCAO RF019GP                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ Manorma                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RF024GP(cCod)
Local lRet 	:= .T.
  
Return(lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³RF024RP   ³ Autor ³ MICROSIGA             ³ Data ³ 17/06/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ CRIANDO A FUNCAO RF024RP                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ Manorma                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RF024RP(cPed,cIt)



Return(lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³RP024VL   ³ Autor ³ MICROSIGA             ³ Data ³ 17/06/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ CRIANDO A FUNCAO RP019VL                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ Manorma                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RP024VL()
Local lRet 	:= .T.


Return(lRet)



USER Function RFT024PR()

u_hcirap() 

Return   

User Function RFATLG()

BrwLegenda(cCadastro,"Situacoes",{{"BR_VERMELHO","Processo em Aberto"}, {"BR_VERDE","Processo Encerrado"}})

Return (.T.) 


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³fDbTree1()  ³ Autor ³ Robson Bueno          ³ Data ³27/10/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Montagem da DbTree                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fDbTree1()
Static oDbTree1
Local lCargo   := .T.  // Utiliza a opcao CARGO
Local lDisable := .F.  // Desabilita a DBTree
Local cNumero
Local aAreaAtu	:= GetArea()
// Voce pode usar a opcao oDbTree1:GetCargo() para resgatar o CARGO do Item selecionado

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿   
//³ Cria DbTree  ³   
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
oDbTree1 := DbTree():New(C(020),C(000),C(105),C(378),oDlg,,,lCargo,lDisable)
oDbTree1:Reset()       
oDbTree1:BeginUpdate() 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria Itens Pais ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    dbselectarea("SC6")
    dbSetOrder(1)
    MsSeek(xfilial("SC6")+PC2->PC2_NUM)
   	While ( !Eof() .and. PC2->PC2_NUM=SC6->C6_NUM) 
   	  cNumero:=SC6->C6_NUM+SC6->C6_ITEM
	  dbselectarea("PC2")
      dbSetOrder(1)
      MsSeek(xfilial("PC2")+cNumero)
	 //oDbTree1:AddItem(PC2->PC2_ITEM+" - Cd:"+PC2->PC2_COD+" - Ds:"+trim(PC2->PC2_DESCRI)+" - Qtd:"+transform(PC2->PC2_QTDORI,"@e 9999")+" - Pzo:"+dtoc(PC2->PC2_PRAZO)+SPACE(50),cNumero,"cResNameOpen","cResNameClose",,,1)
	 oDbTree1:AddItem(PC2->PC2_ITEM+" - Cd:"+PC2->PC2_COD+" - Ds:"+trim(PC2->PC2_DESCRI)+" - Qtd:"+transform(PC2->PC2_QTDORI,"@e 9999")+" - Pzo:"+dtoc(PC2->PC2_PRAZO)+SPACE(100),cNumero,"FOLDER5","FOLDER6",,,1)
	  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  //³ Cria Itens Filhos ³
	  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	  If oDbTree1:TreeSeek(cNumero)
	    dbselectarea("PC2")
        dbSetOrder(8)
        MsSeek(xfilial("PC2")+cNumero)
        While ( !Eof() .And. cNumero == PC2->PC2_NUM+PC2->PC2_ITEM)
	   	  IF dtoc(PC2->PC2_DTFIM)<>"  /  /  "  
	   	    oDbTree1:AddItem(PC2->PC2_SEQ+" - RG:"+SUBSTRING(PC2->PC2_CTR,1,6)+" - Proc: "+TRIM(Posicione("PC1",1,xFilial("PC1")+"PV0001"+PC2->PC2_SEQ,"PC1_DESAT"))+" - Qtd:"+transform(PC2->PC2_QTDORI,"@e 9999")+" - Disp:"+transform(PC2->PC2_QTD,"@e 9999")+" - Dt.Prv:"+dtoc(PC2->PC2_DPREV)+" - Dt.Ini:"+dtoc(PC2->PC2_DTINI)+" - Dt.Fim:"+dtoc(PC2->PC2_DTFIM)+" - Inf:"+PC2->PC2_INF,cNumero+PC2->PC2_SEQ,"FOLDER10","FOLDER11")
	      ELSE
  	        IF PC2->PC2_DPREV>=date()
  	          oDbTree1:AddItem(PC2->PC2_SEQ+" - RG:"+SUBSTRING(PC2->PC2_CTR,1,6)+" - Proc: "+TRIM(Posicione("PC1",1,xFilial("PC1")+"PV0001"+PC2->PC2_SEQ,"PC1_DESAT"))+" - Qtd:"+transform(PC2->PC2_QTDORI,"@e 9999")+" - Disp:"+transform(PC2->PC2_QTD,"@e 9999")+" - Dt.Prv:"+dtoc(PC2->PC2_DPREV)+" - AGUARDANDO DISPOSICAO - ",cNumero+PC2->PC2_SEQ,"FOLDER5","FOLDER6")
	        else
	          oDbTree1:AddItem(PC2->PC2_SEQ+" - RG:"+SUBSTRING(PC2->PC2_CTR,1,6)+" - Proc: "+TRIM(Posicione("PC1",1,xFilial("PC1")+"PV0001"+PC2->PC2_SEQ,"PC1_DESAT"))+" - Qtd:"+transform(PC2->PC2_QTDORI,"@e 9999")+" - Disp:"+transform(PC2->PC2_QTD,"@e 9999")+" - Dt.Prv:"+dtoc(PC2->PC2_DPREV)+" - >>>PROCESSO ATRASADO<<<<< - ",cNumero+PC2->PC2_SEQ,"FOLDER7","FOLDER8")
	        endif
	      ENDIF
	      dbSkip()
        EndDo
	  Endif
      dbselectarea("SC6")
      DBSKIP()
    EndDo
oDbTree1:EndUpdate()
RestArea(aAreaAtu)
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()   ³ Autores ³ Norbert/Ernani/Mansano ³ Data ³10/05/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolucao horizontal do Monitor do Usuario.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function C(nTam)                                                         
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor     
	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)  
		nTam *= 0.8                                                                
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600                
		nTam *= 1                                                                  
	Else	// Resolucao 1024x768 e acima                                           
		nTam *= 1.28                                                               
	EndIf                                                                         
                                                                                
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿                                               
	//³Tratamento para tema "Flat"³                                               
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                               
	If "MP8" $ oApp:cVersion                                                      
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()                      
			nTam *= 0.90                                                            
		EndIf                                                                      
	EndIf                                                                         
Return Int(nTam) 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()   ³ Autores ³ ROBSON BUENO DA SILCA  ³ Data ³25/10/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ FINALIZACAO DO DIALOGO ABERTO                                ³±±
±±³           ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function Finaliza(Odlg1)

Close(Odlg1)

RETURN

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()   ³ Autores ³ ROBSON BUENO DA SILCA  ³ Data ³25/10/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ FINALIZACAO DO DIALOGO ABERTO                                ³±±
±±³           ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function RF024OK(Odlg1)
Local cPedhci :=substring(oDbTree1:GetCARGO(),1,6)
Local cItemhci:=substring(oDbTree1:GetCARGO(),7,2)
Local cProcesso:=substring(oDbTree1:GetPrompt(),1,6)
Local cRegistro:=substring(oDbTree1:GetPrompt(),13,6)
dbselectarea("PC2")
dbSetOrder(4)
if MsSeek(xfilial("PC2")+cPedhci+cItemhci+cProcesso+cRegistro)
   // verifica se as quantidades dispostas sao maiores que o 
  if nGet3+nGet4+nGet5+nGet6+nGet7>PC2->PC2_QTDORI-PC2->PC2_QTD .OR. nGet3+nGet4+nGet5+nGet6+nGet7=0
    IF nGet3+nGet4+nGet5+nGet6+nGet7=0
      MsgInfo("<<ATENCAO>>, Nao Foram dispostas acoes", "Processo Invalido")  
    else
      MsgInfo("<<ATENCAO>>, A Soma das quantidades ultrapassaram o saldo do processo ", "Processo Invalido")  
    endif
  ELSE
    if nGet3>0 
      U_HCICTPR(cPedHci,cItemHci,cProcesso,substring(cComboBx1,1,6),nGet3,cGet18,cGet8,cGet13,cGet89,cRegistro)                               //(PEDIDO/ITEM/PROCESSO ATUAL/NOVO PROCESSO/QTD/INFORMACAO/RI/CORRIDA)
    endif
    if nGet4>0
      U_HCICTPR(cPedHci,cItemHci,cProcesso,substring(cComboBx2,1,6),nGet4,cGet19,cGet9,cGet14,cGet89,cRegistro)                               //(PEDIDO/ITEM/PROCESSO ATUAL/NOVO PROCESSO/QTD/INFORMACAO/RI/CORRIDA)
    endif
    if nGet5>0
      U_HCICTPR(cPedHci,cItemHci,cProcesso,substring(cComboBx3,1,6),nGet5,cGet20,cGet10,cGet15,cGet89,cRegistro)                               //(PEDIDO/ITEM/PROCESSO ATUAL/NOVO PROCESSO/QTD/INFORMACAO/RI/CORRIDA)
    endif
    if nGet6>0 
      U_HCICTPR(cPedHci,cItemHci,cProcesso,substring(cComboBx4,1,6),nGet6,cGet21,cGet11,cGet16,cGet89,cRegistro)                               //(PEDIDO/ITEM/PROCESSO ATUAL/NOVO PROCESSO/QTD/INFORMACAO/RI/CORRIDA)
    endif
    if nGet7>0 
      U_HCICTPR(cPedHci,cItemHci,cProcesso,substring(cComboBx5,1,6),nGet7,cGet22,cGet12,cGet17,cGet89,cRegistro)                               //(PEDIDO/ITEM/PROCESSO ATUAL/NOVO PROCESSO/QTD/INFORMACAO/RI/CORRIDA)
    endif
  ENDIF
  hc024lp()  
else
   MsgInfo("O sistema nao encontrou processo no item selecionado. Selecioneum item pendente de disposicao e depois OK", "Processo Invalido")  
endif

RETURN                                                           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ HCICTPR  ³ Autor ³ ROBSON BUENO          ³ Data ³ 25/10/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ INCLUSAO AUTOMATICA DE ROTINAS DE PROCESSO   			   ³±±	
±±³           ³ CHAMADA PELA FUNCAO MODELO2()                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ REMOTE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                                           
 
User Function HCICTPR(cPedHci,cItemHci,cProcAt,cProcNovo,nQtd,cInfo,cRI,cCorrida,cInfAt,cRegistro,dPrazo) 
    Local aAreaAtu	:= GetArea() 
	local xPcFilial 
	Local xPcNUM
	Local xPcCLI
	Local xPcLOJA	 
	Local xPcPEDCLI
	Local xPcROTINA	
	Local xPcSEQ  
	Local xPcSEQA
	Local xPcSEQP1 
	Local xPcSEQP2 
	Local xPcSEQP3 
	Local xPcSEQP4 
	Local xPcSEQP5 
	Local xPcRESP  
	Local xPcEMAIL 
	Local xPcPORTAL
	Local xPcNOMERED
	Local xPcDREG  
	Local xPcDPREV
	Local xPcITEM         
	Local xPcCOD
	Local xPcDESCRI
	Local xPcQTDORI
	Local xPcCODCLI
	Local xPcITCLI
	Local xPcPRAZO
	Local xPcRi
	Local 	 xPcCorrida
	lOCAL 	 xPcControle
    //FASE 1 ATUALIZAR DADOS DO PROCESSO ATUAL
	dbselectarea("PC2")
	dbSetOrder(4)
	if MsSeek(xfilial("PC2")+cPedHCI+cItEMHCI+cProcAt+cRegistro)
	  RecLock("PC2",.F.)
	  PC2->PC2_DTINI :=DATE()
	  PC2->PC2_QTD:=PC2->PC2_QTD+nQtd
	  IF PC2->PC2_QTD=PC2->PC2_QTDORI
	    PC2->PC2_DTFIM :=DATE()
	    PC2->PC2_RACAOE :=Substr(cUsuario,7,15)
	    PC2->PC2_INF:=cInfat
	  endif
	  MSUNLOCK()
	ENDIF
	//FASE 2 POSICIONAR NO REGISTRO DO PROCESSO ATUAL E COPIAR DADOS PARA O NOVO PROCESSO
	xPcFilial	:=PC2->PC2_FILIAL 
	xPcNUM		:=PC2->PC2_NUM
	xPcCLI		:=PC2->PC2_CLI
	xPcLOJA		:=PC2->PC2_LOJA
	xPcPEDCLI	:=PC2->PC2_PEDCLI
	xPcROTINA   :=PC2->PC2_ROTINA
	xPcSEQ		:=PC2->PC2_SEQ
	xPcSEQA		:=PC2->PC2_SEQA
	xPcSEQP1	:=PC2->PC2_SEQP1
	xPcSEQP2    :=PC2->PC2_SEQP2
	xPcSEQP3    :=PC2->PC2_SEQP3 
	xPcSEQP4	:=PC2->PC2_SEQP4
	xPcSEQP5	:=PC2->PC2_SEQP5
	xPcRESP		:=PC2->PC2_RESP 
	xPcEMAIL    :=PC2->PC2_EMAIL 
	xPcPORTAL	:=PC2->PC2_PORTAL
	xPcNOMERED  :=PC2->PC2_NOMERED
	xPcDREG		:=PC2->PC2_DREG
	xPcDPREV   	:=PC2->PC2_DPREV
	xPcITEM     :=PC2->PC2_ITEM       
	xPcCOD		:=PC2->PC2_COD
	xPcDESCRI	:=PC2->PC2_DESCRI
	xPcCODCLI	:=PC2->PC2_CODCLI
	xPcITCLI	:=PC2->PC2_ITCLI
	xPcPRAZO	:=PC2->PC2_PRAZO
	xPcRi       :=PC2->PC2_RI
	xPcCorrida	:=PC2->PC2_CORRIDA 
	xPcControle	:=PC2->PC2_CTR  
	//FASE 3 Inserir Novo Registro
	dbselectarea("PC1")
	dbSetOrder(1)
	MsSeek(xfilial("PC1")+"PV0001"+cProcNovo)
	DbSelectArea("PC2")
	dbSetOrder(4)
	RecLock("PC2",.T.)
	// CAMPOS PADROES DO PEDIDO
	PC2->PC2_FILIAL		:=xfilial("PC2")
	PC2->PC2_NUM 		:=xPcNUM
	PC2->PC2_CLI		:=xPcCLI
	PC2->PC2_LOJA	 	:=xPcLOJA
	PC2->PC2_PEDCLI		:=xPcPEDCLI
	PC2->PC2_ROTINA		:="PV0001"
	PC2->PC2_SEQ	    :=cProcNovo
	PC2->PC2_SEQA	 	:=xPcSEQ	
	PC2->PC2_SEQP1		:=PC1->PC1_PRACA1 
	PC2->PC2_SEQP2		:=PC1->PC1_PRACA2
	PC2->PC2_SEQP3		:=PC1->PC1_PRACA3
	PC2->PC2_SEQP4		:=PC1->PC1_PRACA4
	PC2->PC2_SEQP5		:=PC1->PC1_PRACA5
	PC2->PC2_RESP  		:=PC1->PC1_RESPPD
	PC2->PC2_EMAIL 		:=PC1->PC1_EMAIL
	PC2->PC2_PORTAL		:=PC1->PC1_PORTAL
	PC2->PC2_NOMERED	:=xPcNOMERED
	PC2->PC2_DREG  		:=DATE()
    if dPrazo=NIL
	  PC2->PC2_DPREV		:=DATE()+PC1->PC1_TPMED1
	else
	  PC2->PC2_DPREV:= dPrazo
	endif  
	PC2->PC2_ITEM		:=xPcITEM             
	PC2->PC2_COD		:=xPcCOD
	PC2->PC2_DESCRI		:=xPcDESCRI
	PC2->PC2_QTDORI		:=nQtd
	PC2->PC2_CODCLI		:=xPcCODCLI
	PC2->PC2_ITCLI		:=xPcITCLI
    if cRi=""    
      PC2->PC2_RI		:=xPcRi 
    else  
      PC2->PC2_RI       :=cRi
    endif
    if cCorrida=""    
      PC2->PC2_CORRIDA	:=xPcCorrida 
    else  
      PC2->PC2_CORRIDA  :=cCorrida
    endif
   	PC2->PC2_PRAZO		:=xPcPRAZO  
	PC2->PC2_INF		:=cInfo
    PC2->PC2_CTR  		:=RTRIM(TRANSFORM(PC2->(recno()),"@E 999999"))
    PC2->PC2_CTRORI		:=xPcControle
	MSUNLOCK()
	RestArea(aAreaAtu)
	  
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ HCIEXPR  ³ Autor ³ ROBSON BUENO          ³ Data ³ 25/10/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ EXCLUSAO AUTOMATICA DE ROTINAS DE PROCESSO   			   ³±±	
±±³           ³ CHAMADA PELA FUNCAO MODELO2()                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ REMOTE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                                           
 
User Function HCIEXPR(cPedHci,cItemHci,cRegistro) // PEDIDO - ITEM - CONTROLE DE REGISTRO
    Local aAreaAtu	:= GetArea() 
	local cProcAnt:=SPACE(9)
	Local nQtd
	Local lOkProc:=.T.
	//FASE 1 Excluir processo atual
	dbselectarea("PC2")
	dbSetOrder(7)
	if MsSeek(xfilial("PC2")+cPedHCI+cItemHci+cRegistro)
	  cProcAnt:=PC2->PC2_CTRORI
	  nQtd:=PC2->PC2_QTDORI
	  RecLock("PC2",.F.)
	  DbDelete()
	  MSUNLOCK()
	else
	  lOkProc:=.F.
	endif  
	//FASE 2 rEABRE PROCESSO ANTERIOR
	dbselectarea("PC2")
	dbSetOrder(8)
	if MsSeek(xfilial("PC2")+cPedHCI+cItEMHCI+cProcAnt) .and. lOkProc
	  RecLock("PC2",.F.)
	  PC2->PC2_QTD:=PC2->PC2_QTD-nQtd
	  IF PC2->PC2_QTD<PC2->PC2_QTDORI
	    IF PC2->PC2_QTD=0
	      PC2->PC2_DTINI:=CTOD("  /  /  ")
	    ENDIF
	    PC2->PC2_DTFIM :=CTOD("  /  /  ")
	    PC2->PC2_RACAOE := ""
	    PC2->PC2_INF:="Reaberto por EPP"
	  endif
	  MSUNLOCK()
	ENDIF
	RestArea(aAreaAtu)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ HCIPDPR    Autor ³ ROBSON BUENO          ³ Data ³ 25/10/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ Ve se Pode Excluir o Porcesso Atual         			   ³±±	
±±³           ³ CHAMADA PELA FUNCAO MODELO2()                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ REMOTE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                                           
 
User Function HCIPDPR(cPedHci,cItemHci,cControle)  // PEDIDO - ITEM - CONTROLE
    Local aAreaAtu	:= GetArea() 
	local lok:=.t.
	//FASE 1 VERIFICAR 
	dbselectarea("PC2")
	dbSetOrder(7)
	if MsSeek(xfilial("PC2")+cPedHCI+cItemHci+cControle)
	  While ( !Eof() .And. cPedHci == PC2->PC2_NUM .and. cItemHci==PC2->PC2_ITEM .and. cControle==PC2->PC2_CTRORI .AND. lOk=.T.)
	    if PC2->PC2_QTD >0
	      lOk:=.F.
	    ENDIF
	    DBSKIP()
	  ENDDO
	ENDIF
	RestArea(aAreaAtu)
Return (lOk)




Static Function hc024lp()
cGet8	 := Space(20)
cGet9	 := Space(20)
cGet10	 := Space(20)
cGet11	 := Space(20)
cGet12	 := Space(20)
cGet13	 := Space(20)
cGet14	 := Space(20)
cGet15	 := Space(20)
cGet16	 := Space(20)
cGet17	 := Space(20)
cGet18	 := Space(50)
cGet19	 := Space(50)
cGet20	 := Space(50)
cGet21	 := Space(50)
cGet22	 := Space(50)
nGet3	 := 0
nGet4	 := 0
nGet5	 := 0
nGet6	 := 0
nGet7	 := 0
oDlg:REFRESH()
RETURN

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RFAT24RP  ³ Autor ³ Robson Bueno          ³ Data ³13/12/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³ Fabr.Tradicional ³Contato ³ HCI                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³  tela de registro rapido                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Bops ³ Manutencao Efetuada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³      ³                                        ³±±
±±³              ³  /  /  ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function RFAT24RP(cAlias,nReg,nOpc)
// Variaveis Locais da Funcao
static cGetRef   :="" 
static aComboRP1 := {}
static cComboRP1 :=""
static cGetRef  := Space(50)
STATIC cGetRP1	 := Space(50)
STATIC cGetRP2	 := Space(50)
STATIC nGetQtd	 := 0
STATIC oGetRef
STATIC oGetRP1
STATIC oGetRP2
STATIC oGetQtd

// Variaveis da Funcao de Controle e GertArea/RestArea
Local _aArea   		:= {}
Local _aAlias  		:= {}
// Variaveis Private da Funcao
Private oDlg				// Dialog Principal
// Variaveis que definem a Acao do Formulario
Private VISUAL := .F.                        
Private INCLUI := .F.                        
Private ALTERA := .F.                        
Private DELETA := .F.                        

IF PC2->PC2_DTFIM<>CTOD("  /  /  ")
  MsgInfo("O sistema nao encontrou processo PENDENTE no item selecionado. Selecioneum item pendente de disposicao....", "Processo Invalido") 
  RETURN
ENDIF
aComboRP1 := {}
cGetRp1:=""
cGetRp2:=""
IF PC2->PC2_SEQP1<>"      " 
	  aAdd(aComboRP1,PC2->PC2_SEQP1+" - "+Posicione("PC1",1,xFilial("PC1")+"PV0001"+(cAlias)->PC2_SEQ,"PC1_DACAO1"))
	 
ENDIF
IF PC2->PC2_SEQP2<>"      " 
	  aAdd(aComboRP1,PC2->PC2_SEQP2+" - "+Posicione("PC1",1,xFilial("PC1")+"PV0001"+(cAlias)->PC2_SEQ,"PC1_DACAO2"))
ENDIF
IF PC2->PC2_SEQP3<>"      " 
	  aAdd(aComboRP1,PC2->PC2_SEQP3+" - "+Posicione("PC1",1,xFilial("PC1")+"PV0001"+(cAlias)->PC2_SEQ,"PC1_DACAO3"))
ENDIF
IF PC2->PC2_SEQP4<>"      " 
	  aAdd(aComboRP1,PC2->PC2_SEQP4+" - "+Posicione("PC1",1,xFilial("PC1")+"PV0001"+(cAlias)->PC2_SEQ,"PC1_DACAO4"))
ENDIF
cGetRef:=PC2->PC2_NUM + "-" + PC2->PC2_ITEM +"-"+ PC2->PC2_SEQ+ "-Qtd:"+transform(PC2->PC2_QTDORI,"@e 9999")+" -Proc:"+TRIM(Posicione("PC1",1,xFilial("PC1")+"PV0001"+PC2->PC2_SEQ,"PC1_DESAT"))                  
nGetQtd:=PC2->PC2_QTDORI-PC2->PC2_QTD
dbselectarea("PC1")
dbSetOrder(1)
MsSeek(xfilial("PC1")+"PV0001"+PC2->PC2_SEQ) 
IF LEN(TRIM(PC1->PC1_QUEST))>0
  DEFINE MSDIALOG oDlg TITLE PC1->PC1_QUEST FROM C(182),C(184) TO C(362),C(603) PIXEL
ELSE
  DEFINE MSDIALOG oDlg TITLE "Disposicao Unica de Acao" FROM C(182),C(184) TO C(362),C(603) PIXEL
ENDIF 


	// Cria Componentes Padroes do Sistema
	@ C(002),C(003) Say "Referencia:" Size C(032),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(003),C(045) MsGet oGetRef Var cGetRef Size C(156),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg
	@ C(018),C(002) Say "Proximas Ações" Size C(043),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(017),C(045) ComboBox cComboRP1 Items aComboRP1 Size C(156),C(010) PIXEL OF oDlg ON CHANGE RF24MSG() VALID RF24MSG()
	@ C(031),C(002) Say "Qtd " Size C(040),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(030),C(045) MsGet oGetQtd Var nGetQtd Size C(020),C(009) COLOR CLR_BLACK Picture "@E 9999.9" PIXEL OF oDlg
	@ C(043),C(002) Say "Obs Proc Atual" Size C(039),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(042),C(045) MsGet oGetRP1 Var cGetRP1 Size C(156),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg
	@ C(056),C(002) Say "Obs Proc Novo" Size C(040),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(055),C(045) MsGet oGetRP2 Var cGetRP2 Size C(156),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg
	@ C(071),C(045) Button "Ok" Size C(037),C(012) PIXEL OF oDlg ACTION RF024RP2(oDlg, nGetQtd,cComboRP1,cGetRP1,cGetRp2)
	@ C(071),C(085) Button "Cancela" Size C(037),C(012) PIXEL OF oDlg ACTION Finaliza(odlg)



	// Cria ExecBlocks dos Componentes Padroes do Sistema
  

ACTIVATE MSDIALOG oDlg CENTERED 

Return(.T.)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RFAT24RP2 ³ Autor ³ Robson Bueno          ³ Data ³13/12/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³ Fabr.Tradicional ³Contato ³ HCI                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Incluindo Processos via registro rapido                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Bops ³ Manutencao Efetuada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³      ³                                        ³±±
±±³              ³  /  /  ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/


Static Function RF024RP2(Odlg1,nQtd,cProxima,cObsAtual,cObsnovo)
Local cPedhci :=PC2->PC2_NUM
Local cItemhci:=PC2->PC2_ITEM
Local cProcesso:=PC2->PC2_SEQ
Local cRegistro:=PC2->PC2_CTR
dbselectarea("PC2")
dbSetOrder(4)
if MsSeek(xfilial("PC2")+cPedhci+cItemhci+cProcesso+cRegistro)
   // verifica se as quantidades dispostas sao maiores que o 
  if nQtd>PC2->PC2_QTDORI-PC2->PC2_QTD .OR. nQtd=0
    IF nQtd=0
      MsgInfo("<<ATENCAO>>, Nao Foram dispostas acoes", "Processo Invalido")  
    else
      MsgInfo("<<ATENCAO>>, A Soma das quantidades ultrapassaram o saldo do processo ", "Processo Invalido")  
    endif
  ELSE
    if nQtd>0 
      U_HCICTPR(cPedHci,cItemHci,cProcesso,substring(cProxima,1,6),nQtd,cObsNovo,"","",cObsAtual,cRegistro)                               //(PEDIDO/ITEM/PROCESSO ATUAL/NOVO PROCESSO/QTD/INFORMACAO/RI/CORRIDA)
              // (cPedHci,cItemHci,cProcAt,cProcNovo,nQtd,cInfo,cRI,cCorrida,cInfAt,cRegistro,dPrazo) 
    endif
  ENDIF
else
   MsgInfo("O sistema nao encontrou processo no item selecionado. Selecione um item pendente de disposicao e depois OK", "Processo Invalido")  
endif
Close(Odlg1)

RETURN                                                           



Static Function RF24MSG()
  do case 
    case substring(cGetRef,11,6)="000001" 
    
    case substring(cGetRef,11,6)="000002"
      if substring(cComboRp1,1,6) ="000003"
         cGetRp1:="Analisar Lotes:                   "
         cGetRp2:="Favor Analisar Lotes"
      ENDIF
      if substring(cComboRp1,1,6) ="000004" 
         cGetRp1:="Disposto Separar"
         cGetRp2:="Favor Baixar Separacao"
      ENDIF
      if substring(cComboRp1,1,6) ="000005" 
         cGetRp1:="Disposto Comprar"
         cGetRp2:="Favor Analisar Solicitacao"
      ENDIF
    
    case substring(cGetRef,11,6)="000003" 
      if substring(cComboRp1,1,6) ="000004" 
         cGetRp1:="Disposto Separar"
         cGetRp2:="Favor Baixar Separacao"
      ENDIF
      if cGetRp2:=substring(cComboRp1,1,6) ="000005" 
         cGetRp1:="Disposto Comprar"
         cGetRp2:="Favor Analisar Solicitacao"
      ENDIF
        
    case substring(cGetRef,11,6)="000004" 
       if substring(cComboRp1,1,6) ="000016"
          cGetRp1:="Material Separado"
          cGetRp2:="Emitir Certificado"
       endif
         
    case substring(cGetRef,11,6)="000005" 
    case substring(cGetRef,11,6)="000006" 
    case substring(cGetRef,11,6)="000007" 
    case substring(cGetRef,11,6)="000008" 
    case substring(cGetRef,11,6)="000009" 
    case substring(cGetRef,11,6)="000010" 
    case substring(cGetRef,11,6)="000011" 
    case substring(cGetRef,11,6)="000012" 
   
    case substring(cGetRef,11,6)="000013" 
       if substring(cComboRp1,1,6) ="000015"
         cGetRp1:="Documentos Ok"
         cGetRp2:="Favor analisar Doctos"
       else
         cGetRp1:="Em Follow-up de Documentos"
         cGetRp2:="Cobrar Documentos"
       endif  
   
   
    case substring(cGetRef,11,6)="000014" 
       if substring(cComboRp1,1,6) ="000015"
         cGetRp1:="Documentos Ok"
         cGetRp2:="Verificar Norma de Materiais"
       else
         cGetRp1:="NC Detectada: <FALTA DE DOCUMENTACAO>"
         cGetRp2:="Abrir Rnc para o Processo"
       endif
   
   
    case substring(cGetRef,11,6)="000015" 
       if substring(cComboRp1,1,6) ="000016"
         cGetRp1:="Norma Materiais Ok"
         cGetRp2:="Emitir Certificado"
       else
         cGetRp1:="NC Detectada: <NORMA DE MATERIAIS>"
         cGetRp2:="Abrir Rnc para o Processo"
       endif  
   
   
    case substring(cGetRef,11,6)="000016" 
       if substring(cComboRp1,1,6) ="000017"
         cGetRp1:="Cert. Emitido: Nr.                   "
         cGetRp2:="Analisar Crit. Inspecao
       else
         cGetRp1:="NC Detectada: <NORMA DE MATERIAIS>"
         cGetRp2:="Abrir Rnc para o Processo"
       endif
    
    case substring(cGetRef,11,6)="000017" 
    case substring(cGetRef,11,6)="000018"
    case substring(cGetRef,11,6)="000019" 
    case substring(cGetRef,11,6)="000020" 
    case substring(cGetRef,11,6)="000021" 
    case substring(cGetRef,11,6)="000022" 
    case substring(cGetRef,11,6)="000023" 
    case substring(cGetRef,11,6)="000024" 
    case substring(cGetRef,11,6)="000025" 
    case substring(cGetRef,11,6)="000026" 
    case substring(cGetRef,11,6)="000027" 
  endcase
  oDlg:REFRESH()
RETURN
 