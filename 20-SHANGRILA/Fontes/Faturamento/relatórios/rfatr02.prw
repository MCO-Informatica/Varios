#INCLUDE "RwMake.ch"
//#INCLUDE "protheus.CH"
//#INCLUDE "TOPCONN.CH"
/*
-----------------------------------------------------------------------------
Funcao   : RFatR02       
Autor    : Gildesio Campos                                    |Data: 18.06.07
-----------------------------------------------------------------------------
Descricao: Etiquetas na impressora ZEBRA
-----------------------------------------------------------------------------
*/
User Function RFatR02() 
Local   cTitulo := "Etiquetas de Produtos com Código de Barras                                          "
Local   cDesc1  := "Este programa imprime as etiquetas de produtos com código de barras na Impressora   "
Local   cDesc2  := "Zebra. " 
Local   cDesc3  := "" 
Local   cDesc4  := "Observacao:" 
Local   cDesc5  := "A rotina considera o formulario com 4 etiquetas por linha."
Local   nOpca
Local   aCampos := {}
Local   aCposBrw:= {}  
Local   cQuery  := ""
Local 	aSays   :={}
Local   aButtons:= {}

Private cMarca    := GetMark()
Private cCadastro := OemToAnsi(cTitulo) 
Private aRotina   := {{ "Imprimir", "U_RFatR02I", 0, 2 }}
Private cPerg     := "RFTR02"
Private cArqTrab 
Private cIndTrab 

AADD(aSays,OemToAnsi(cDesc1))
AADD(aSays,OemToAnsi(cDesc2))
AADD(aSays,OemToAnsi(cDesc3))
AADD(aSays,OemToAnsi(cDesc4))
AADD(aSays,OemToAnsi(cDesc5))

nOpca := 0
RFatR02Perg(cPerg)		
Pergunte(cPerg,.F.)

AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg) } } )
AADD(aButtons, { 1,.T.,{|o| nOpca:= 1, o:oWnd:End() } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

FormBatch( cCadastro, aSays, aButtons ) 

If nOpca != 1
	Return
EndIf
/*
------------------------
Arquivos utulizados
------------------------*/
aCampos:={{ "OK"    , "C", 2, 0 },;
		  { "CODIGO", "C", 6, 0 },;
		  { "DESCRI", "C",30, 0 },;
		  { "CODBAR", "C",14, 0 }}

AADD(aCposBrw,{"OK"    ,,OemToAnsi("")})
AADD(aCposBrw,{"CODIGO",,OemToAnsi("Produto")}) 
AADD(aCposBrw,{"DESCRI",,OemToAnsi("Descricao")}) 

cArqTrab:= CriaTrab(aCampos, .T.)
cIndTrab:= CriaTrab(Nil, .F.)
dbUseArea(.T.,__LocalDriver,cArqTrab,"TRB",.F.)

If Mv_Par06 == 1
	IndRegua("TRB",cIndTrab,"CODIGO",,,"Selecionando Registros...")    
Else
	IndRegua("TRB",cIndTrab,"DESCRI",,,"Selecionando Registros...")    
EndIf	
/*
---------------------------------------------------
Consulta Produtos
---------------------------------------------------*/
cQuery := " SELECT B1_COD,B1_DESC,B1_CODBAR"
cQuery += " FROM "
cQuery += RetSqlName("SB1")+" SB1 "
cQuery += " WHERE " 
cQuery += " SB1.B1_FILIAL  = '"+xFilial("SB1")+"' AND "   
cQuery += " SB1.B1_COD BETWEEN '" + Mv_Par01 + "' AND '" + Mv_Par02 + "' AND "  
cQuery += " SB1.B1_CODBAR <> ' ' AND "
cQuery += " SB1.D_E_L_E_T_ = ' ' "  
cQuery += " ORDER BY SB1.B1_COD"

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.F.,.T.)

dbSelectArea("TMP") 
nRegs := RecCount()
ProcRegua(nRegs) 
dbGoTop()

While TMP->(!Eof())
   	IncProc("Gerando arquivo temporario...")
	RecLock("TRB",.T.)
	TRB->CODIGO := TMP->B1_COD
    TRB->DESCRI := TMP->B1_DESC
	TRB->CODBAR := TMP->B1_CODBAR
    TRB->OK     := ""
	MsUnlock()
    TMP->(dbSkip())
End
dbSelectArea("TMP") 
dbCloseArea()

dbSelectArea("TRB") 
dbGoTop()

MarkBrow("TRB","OK",,aCposBrw,,cMarca,"U_R02MarkAll()",,,,"U_R02Mark()")
/*
-------------------------------------
Apaga arquivos e Indices Temporarios
-------------------------------------*/
dbSelectArea("TRB")
dbCloseArea()

FErase(cArqTrab + GetDBExtension())
FErase(cIndTrab + OrdBagExt())
Return                    
/*
-----------------------------------------------------------------------------
Funcao   : RFatR02I       
Autor    : Gildesio Campos                                    |Data: 18.06.07
-----------------------------------------------------------------------------
Descricao: Rotina de Impressao das Etiquetas
-----------------------------------------------------------------------------
*/
User Function RFatR02I()  
Local lContinua := .T.
Local lRet      := .T.
Local cCodBar   
Local cDescri   

dbSelectArea("TRB")
nRegs := RecCount()
ProcRegua(nRegs) 
dbGoTop()
/*	
-----------------------------------
Produto Importado
-----------------------------------*/	
If Mv_Par04 == 1	//Sim
	xMens    := "Produto importado por: "
EndIf
cNome    := Upper(AllTrim(SM0->M0_NOME))
cEmpresa := If(cempAnt=='01',"Shangri-la Ind.Com.Espanadores Ltda",Upper(AllTrim(SM0->M0_NOMECOM)))
cCnpj    := AllTrim(Transform(SM0->M0_CGC , "@R 99.999.999/9999-99"))
cEst     := Upper(AllTrim(SM0->M0_ESTENT))

/*	
-----------------------------------
Porta de Impressao 
-----------------------------------*/   
do case
	case MV_PAR05 == 1 // COM1
		cPorta := "COM1"
	case MV_PAR05 == 2 // COM2
		cPorta := "COM2"
	case MV_PAR05 == 3 // LPT1
		cPorta := "LPT1"
	case MV_PAR05 == 4 // LPT2
		cPorta := "LPT2"
endcase
/*	
-----------------------------------
Impressora
-----------------------------------*/   
MSCBPRINTER("S600",cPorta,,,.f.,,,,,,.T.,)
MSCBCHKSTATUS(.T.)	//Verifica a conexao com a impressora

While TRB->(!Eof())
	IncProc("Imprimindo Etiqueta......")
	cCodBar := Alltrim(TRB->CODBAR)  
	cDescri := Alltrim(TRB->DESCRI)
	
	If Empty(TRB->OK)
		DBSkip()
		Loop
	EndIf
	nQtdImp := (Mv_Par03 / 4)		//Qtde solicitada / Qtde colunas das etiquetas

	If nQtdImp > Int(nQtdImp)
		nQtdImp := Int(nQtdImp) + 1  
	EndIf
/*	-----------------------------------
	Impressao das Etiquetas
	-----------------------------------*/
	MSCBBEGIN(nQtdImp,4)
/*	-----------------------------------
	Produto Importado
	-----------------------------------*/	
	For _nCnt := 1 To 4
		If _nCnt == 1
			x := 1
		EndIf

		If Mv_Par04 == 1	//Sim   
			MSCBSAY(x,15,xMens,"B","B","13,10")      //015,008
			x:= x + 3
			MSCBSAY(x,1,cEmpresa,"B","B","13,8")   //"B","01,0.5"
			x:= x + 3
			MSCBSAY(x,7,"Cnpj: "+cCnpj+" "+cEst,"B","B","13,10")    
			x:= x + 3
			MSCBSAY(x,5,cDescri,"B","B","13,10")     //Descricao do Produto
			x:= x + 3
			MSCBSAYBAR(x,8,cCodBar,'B','MB04',9,.F.,.T.,.F.,,2,1) 
			x:= x + 15
		Else
			MSCBSAY(x,5,cDescri,"B","B","13,10")     //Descricao do Produto
			x:= x + 3
			MSCBSAY(x,7,"Cnpj: "+cCnpj+" "+cEst,"B","B","13,10")    
			x:= x + 4
			MSCBSAYBAR(x,8,cCodBar,'B','MB04',9,.F.,.T.,.F.,,2,1) 
			x:= x + 21
		EndIf
	Next	
	MSCBEND()
	TRB->(dbSkip())
EndDo
MSCBCLOSEPRINTER()

Return
/*
-----------------------------------------------------------------------------
Funcao   : R02MarkAll 
Autor    : Gildesio Campos                                    |Data: 17.07.07
-----------------------------------------------------------------------------
Descricao: Grava marca em todos os registros do Arquivo
-----------------------------------------------------------------------------
*/
User Function R02MarkAll()

Local nRecno	:=	0
DbSelectArea("TRB")
nRecno	:=	REcno()
DbGoTop()  

While !EOF()
	U_R02Mark(.T.)
	DbSkip()
Enddo
DbGoTo(nRecno)
Return
/*                       
-----------------------------------------------------------------------------
Funcao   : R02Mark 
Autor    : Gildesio Campos                                    |Data: 17.07.07
-----------------------------------------------------------------------------
Descricao: Grava marca no campo OK dos itens do pedido
-----------------------------------------------------------------------------
*/
User Function R02Mark(lTodos)
Local lRet	 :=	.F.
Local nX	 :=	0 
Local lAchou := .F.

lTodos	:=	Iif(lTodos == Nil, .F., lTodos)
            
DbSelectArea("TRB")

If IsMark("OK",cMarca)
	MsRLock(TRB->(RECNO()))
	Replace OK With "  "
	MsRUnLock(TRB->(RECNO()))
Else
	MsRLock(TRB->(RECNO()))
	Replace OK With cMarca
	MsRUnLock(TRB->(RECNO()))
Endif

Return
/*
-----------------------------------------------------------------------------
Funcao   : RFatR02Perg       
Autor    : Gildesio Campos                                    |Data: 18.06.07
-----------------------------------------------------------------------------
Descricao: Perguntas
-----------------------------------------------------------------------------
*/
Static Function RFatR02Perg(xPerg)
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)

cPerg := Padr(cPerg,10)
aRegs:= {}

AADD(aRegs,{cPerg,"01","Codigo do Produto de       ?","","","mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","","",""})       //43 CAMPOS
AADD(aRegs,{cPerg,"02","Codigo do Produto ate      ?","","","mv_ch2","C",15,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","","",""})
AADD(aRegs,{cPerg,"03","Qtde. Etiquetas p/ Produto ?","","","mv_ch3","N",05,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Produto Importado          ?","","","mv_ch4","N",01,0,0,"C","","mv_par04","Sim"   ,"","","","","Nao","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Qual Porta de Impressao    ?","","","mv_ch5","N",01,0,4,"C","","mv_par05","COM1"  ,"","","","","COM2","","","","","LPT1","","","","","LPT2","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Ordem de selecao           ?","","","mv_ch6","N",01,0,0,"C","","mv_par06","Codigo","","","","","Descricao","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

Return(.T.)            

MSCBSay(nXmm,nYmm,cTexto,cRotacao,cFonte,cTam)
MSCBSay(21.62,2.67,"PRODUTO IMPORTADO POR:","B",cFonte,cTam)//


/*---------------------
MSCBSay(nXmm,nYmm,cTexto,cRotacao,cFonte,cTam)
Tipo: Impressão
	Imprime uma String

Parâmetros
    nXmm      = Posição X em Milímetros         
    nYmm      = Posição Y em Milímetros                        
	cTexto    = String a ser impressa                          
	cRotação  = String com o tipo de Rotação (N,R,I,B)         
		   	N-Normal
			R-Cima p/baixo
			I-Invertido
			B-Baixo p/ Cima
cFonte    = String com os tipos de Fonte 
        		      Zebra: (A,B,C,D,E,F,G,H,0) 0(zero)- fonte escalar
             	      Allegro: (0,1,2,3,4,5,6,7,8,9) 9 - fonte escalar
             	      Eltron: (0,1,2,3,4,5) 
cTam      = String com o tamanho da Fonte
      	*[lReverso]= Imprime  em reverso quando tiver sobre um box preto                             
      	[lSerial] = Serializa o código                              
      	[cIncr]   = Incrementa quando for serial positivo ou negativo
      	*[lZerosL] = Coloca zeros a esquerda no numero serial       


Exemplo
MSCBSAY(15,3,"MICROSIGA ","N","C","018,010",.t.)
MSCBSAY(15,3,"MICROSIGA ","N","C","018,010",.t.,.t.,"3",.t.)
              


----------------------------------------------------------------------------
Exemplo padrão Zebra.
----------------------------------------------------------------------------
MSCBPRINTER("S500-8","COM2:9600,e,7,2",,42) //Seta tipo de impressora padrao ZPL
MSCBLOADGRF("LOGO.GRF") //Carrega o logotipo para impressora
MSCBBEGIN(2,4) //Inicio da Imagem da Etiqueta
//com 2 copias e velocidade 4 etiquetas por polegadas
MSCBBOX(01,01,80,40) //Monta BOX
MSCBBOX(12,01,31.5,10,37)
MSCBGRAFIC(2.3,2.5,"LOGO") //Posiciona o logotio
MSCBSAY(15,3,"MICROSIGA ","N","C","018,010") //Imprime Texto
MSCBSAY(13,6.5,"SOFTWARE S/A","N","C","018,010")
MSCBLineH(01,10,80) //Monta Linha Horizontal
MSCBSAY(35,2,"Código Interno","N","B","11,7")
MSCBSAY(35,5,SB1->B1_COD,"N","E","28,15")
MSCBSAY(4,12,"Descricao","N","B","11,7")
MSCBSAY(4,16,SB1->B1_DESC,"N","F","26,13")
MSCBLINEH(01,20,80)
MSCBSAYBAR(20,22,AllTrim(SB1->B1_CODBAR),"N","C",13,.f.,.t.,,,3,2,.t.)
//monta código de barras
MSCBEND() //Fim da Imagem da Etiqueta
MSCBCLOSPRINTER()
_________
359 Tipos de Fontes para Zebra:

As fontes A,B,C,D,E,F,G,H, são do tipo BITMAPPEDs, tem tamanhos definidos e podem ser expandidos proporcionalmente 
a dimensão mínima.
Exemplo: Fonte do tipo A, 9 X 5 ou 18 x 10 ou 27 X 15 _
A fonte 0 (Zero) é do tipo ESCALAR, esta será gerada na memória da impressora, portanto torna-se um processamento 
lento.


1755 MSCBPRINTER

Descrição:

Configura modelo da impressora, saída utilizada, resolução na impressão e tamanho da etiqueta a ser impresso.

Parâmetros:
[ModelPrt] = String com o modelo de impressora:
Zebra:
S400, S600, S500-6, Z105S-6,Z16S-6,S300,S500-8, Z105S-8, Z160S-8, Z140XI, Z90XI e Z170ZI.
Allegro:
ALLEGRO, PRODIGY, DMX e DESTINY.
Eltron:
ELTRON E ARGOX
cPorta = String com a porta
[nDensidade] = Numero com a densidade referente a quantidade de pixel por mm
[nTamanho] = Tamanho da etiqueta em Milímetros.
[lSrv] = Se .t. imprime no server,.f. no client
[nPorta] = numero da porta de outro server
[cServer] = endereço IP de outro server
[cEnv] = environment do outro server
[nMemoria] = Numero com bloco de memória


Observações:
O parâmetro nDensidade não é necessário informar, pois ModelPrt o atualizará automaticamente. A utilização deste 
parâmetro (nDensidade) deverá ser quando não souber o modelo da impressora, a aplicação entendera que se trata de 
uma impressora Zebra.
O tamanho da etiqueta será necessário quando a mesma não for continua.

Exemplos:
MSCBPRINTER("S500-8", "COM2:9600,e,7,2",NIL, 42)

MSCBPRINTER("S500-8", "LPT1",NIL, 42)
MSCBPRINTER("S600","COM1:9600,N,8,2",NIL,NIL,.T.,1024,"SERVER-AP","ENVCODEBASEPORT609")

MSCBPRINTER("S600", "LPT1",NIL, 42,.F.,NIL,NIL,NIL,10240)

*/

