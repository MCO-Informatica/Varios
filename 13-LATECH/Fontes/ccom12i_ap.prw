#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function ccom12i()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_ACAMPOS,_AFIELDS,AROTINA,CDELFUNC,CCADASTRO,CMARCA")
SetPrvt("ACAMPOS,_N,_AFIELSX3,_CARQUIVO,_CPOSICAO,LINVERTE")
SetPrvt("_CMARCALL,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CCOM12I  ³ Autor ³Ricardo Correa de Souza³ Data ³04.08.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Geracao de Pedidos de Transferencia para Sao Roque         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Coel Controles Eletricos Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/

DbSelectArea("SB1")     //----> Produtos
DbSetOrder(1)           //----> Codigo

DbSelectArea("SC5")     //----> Cabecalho Pedido Venda
DbSetOrder(1)           //----> Numero Pedido

DbSelectArea("SC6")     //----> Itens Pedido Venda
DbSetOrder(1)           //----> Numero Pedido + Item

_aCampos := {}
_aFields := {}

CreateSX3()

aRotina   := { { "Pesquisa"  ,"AxPesqui" ,0,1},;
               { "Gera Pedidos",'Execblock("GERAPED")',0,4}  }           

cDelFunc  := ".T."

cCadastro := "Geracao de Pedidos de Transferencia"

cmarca    := getmark()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa a funcao MARKBROW. Sintaxe:                                       ³
//³                                                                           ³
//³MarkBrow(<Alias,campo1,campo2,aCampos,linverte,cmarca,,,,,{nLin1,..nCol2}) ³
//³Onde:                                                        ³
//³Alias         - Alias do arquivo a ser "Browseado".          ³
//³campo1        - Campo a ser preenchido no caso de marcado    ³
//³campo2        - Se este campo estiver preenchido o registro  ³
//³                aparece  desabilitado                        ³
//³aCampos       - Array multidimensional com os campos a serem ³
//³                exibidos no browse. Se nao informado, os cam-³
//³                pos serao obtidos do dicionario de dados.    ³
//³                E util para o uso com arquivos de trabalho.  ³
//³                Segue o padrao:                              ³
//³                aCampos := { {<CAMPO>,<FUNCAO>,<DESCRICAO>}; ³
//³                             {<CAMPO>,<FUNCAO>,<DESCRICAO>}; ³
//³                             . . .                           ³
//³                             {<CAMPO>,<FUNCAO>,<DESCRICAO>}} ³
//³                Como por exemplo:                            ³
//³                aCampos := { {"TRB_DATA","AXPESQUI"Data"},;  ³
//³                  {"TRB_COD","EXECBLOCK{'TESTE'),"Codigo"}}  ³
//³               Caso seja definido, os parametros campo1 nao  ³
//³                tera finalidade.                             ³
//³ cCampo       - Nome de um campo (entre aspas) que sera usado³
//³                como "flag". Se o campo estiver vazio, o re- ³
//³                gistro ficara de uma cor no browse, senao fi-³
//³                cara de outra cor.                           ³
//³ nLin1,..2 - Coordenadas dos cantos aonde o browse sera      ³
//³                exibido. Para seguir o padrao da AXCADASTRO  ³
//³                use sempre 6,1,22,75 (o que nao impede de    ³
//³                criar o browse no lugar desejado da tela).   ³
//³                Obs.: Na versao Windows, o browse sera exibi-³
//³                do sempre na janela ativa. Caso nenhuma este-³
//³                ja ativa no momento, o browse sera exibido na³
//³                janela do proprio SIGAADV.                   ³
//³                                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

AADD(_aCampos,  {"D1_OK"     ,{},"OK"                       })

For _n := 1 to Len(_aFields)
	//+------------------------------------------------------------+
	//¦ 1-Campo 5-Descricao do Campo 7- Picture do Campo           ¦
	//+------------------------------------------------------------+
    If _aFields[_n,1] <> 'D1_OK'
        AADD(_aCampos,{_aFields[_n,1],{},_aFields[_n,5],_aFields[_n,7]})
	EndIf
Next

DbSelectArea("SD1")
DbGoTop()

MarkBrow("SD1","D1_OK","",,,cmarca,"OkMark('SD1','D1_OK')")

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CREATESX3 ³ Autor ³Marllon Figueiredo     ³ Data ³ 01/18/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta array com dados do arquivo SX3.                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function CreateSX3
Static Function CreateSX3()
_aFielSX3   := {}

DbSelectArea("SX3")
DbSetOrder(1)
DbGoTop()

If !DbSeek("SD1")
	Help(" ",1,"Aviso",,"Nao encontrei dados no SX3",1,1)
	Return
Endif


While SX3->X3_ARQUIVO == "SD1" .AND. !EOF()
	
	if SX3->X3_CONTEXT == "V"
		DbSkip()
		Loop
	endif
	
	AADD(_aFielSX3,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_TITULO,SX3->X3_BROWSE,SX3->X3_PICTURE})
	
	DbSkip()
	
End

_aFields := _aFielSX3

Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function OkMark
Static Function OkMark()

/*********************************************************************************************
* ATENCAO SR. PROGRAMADOR !!!
*
* Para o funcionamento desta rotina, deve-se atentar para as seguintes
* definicoes :
*
* -> O Nome do Alias do arquivo a ser marcado/desmarcado devera vir no
* -> parametro na chamada desta funcao juntamento com o nome do campo ??_OK do arquivo
*   Exemplo:   OkMark( 'SC5', 'C5_OK' )
*
*
* -> O Campo referente a marcacao do marKbrowse com tamanho de 2 caracteres
*    devera estar na primeira posicao do array acampos
*
*    Ex: Campo C5_OK do SC5
*
* -> Devera ser inicializada antes da chamada a MarkBrowse a variavel _cMarcAll
*    como sendo falsa ou verdadeira para que o browse seja inicializado com marca ou sem
****************************************************************************************/

_cArquivo  :=  "SD1"
_cPosicao  := FieldPos("D1_OK")

DbSelectArea(_cArquivo)
DbGoTop()

While !Eof()
	IF _cMarcAll
		linverte := .T.
		RecLock(_cArquivo,.F.)
		FieldPut(_cPosicao,SPACE(02))
		MsUnLock()
	Else
		linverte := .F.
		RecLock(_cArquivo,.F.)
		FieldPut(_cPosicao,cmarca)
		MsUnLock()
	Endif
	DbSkip()
End

DbGoTop()

_cMarcAll := !_cMarcAll

Return


