#include "rwmake.ch"  
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ EXTRAN06 º Autor ³Eduardo Felipe da Silva º Data ³  10/05/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina responsável pela geração de arquivo Texto de NFE's      º±±
±±º          ³ para integração nas LOJAS.                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                 				      		   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function EXTRAN06()

Private nReg    := 	0
Private cCodigo := Space(13)
// Numero de Registros da Query
//private aSays :={}, 	aButtons := {}, 	nOpca := 0, 	cCadastro := "Gera arquivo com notas de entrada"
//Private cPerg     := "EXM001" //Padronizado para utilizar o SX1
//ValidPerg()
//PERGUNTE(cPerg, .F.)

//AADD(aSays,"Este programa tem o objetivo gerar arquivo texto com notas")
//AADD(aSays,"de entrada." )
//AADD(aButtons, { 5,.T.,{|| pergunte(cPerg,.T.) } } )
//AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End() } } )
//AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

//FormBatch( cCadastro, aSays, aButtons )
	
// Se for confirmado o processamento
	
//if nOpcA == 1
//	If Pergunte(cPerg, .T.)
		Processa({|| EXPM001SQL()  } ,"Selecionando notas fiscais...")
		Processa({|| EXPM001Det() } ,"Gerando arquivo de notas de entrada...")
//	Endif
//endif
if select("TRB") > 0
	TRB->(dbclosearea())
endif
if select("QRY") > 0
	QRY->(dbclosearea())
endif
	
Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³EXPM001SQLº Autor ³Eduardo Felipe da Silva º Data ³  10/05/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao responsavel pela montagem e execucao da Query           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function EXPM001SQL()
	
Local CR 		:= chr(13) + chr(10)
Local cQuery	:= " "
Local cQueryOrd := " "
	
cQuery += CR + " SELECT D2_DOC, "
cQuery += CR + " D2_SERIE, "
cQuery += CR + " D2_EMISSAO, "
cQuery += CR + " D2_COD, "
cQuery += CR + " D2_QUANT, "
cQuery += CR + " D2_PRCVEN, "
cQuery += CR + " D2_VALICM, "
cQuery += CR + " D2_TOTAL, "
cQuery += CR + " D2_PICM "
cQuery += CR + " FROM " + RetSQLName("SD2") + " SD2 "
cQuery += CR + " JOIN " + RetSQLName("SB1") + " SB1 ON (B1_COD = D2_COD AND SB1.D_E_L_E_T_ = '') "
cQuery += CR + " WHERE SD2.D_E_L_E_T_=' ' AND "
cQuery += CR + " D2_FILIAL = '" + xFilial("SD2") + "' AND "
cQuery += CR + " D2_DOC = '" + SF2->F2_DOC + "' AND "
cQuery += CR + " D2_SERIE = '" + SF2->F2_SERIE + "' "
cQueryOrd := CR + " ORDER BY D2_DOC, D2_SERIE "
	
Memowrite("EXPM001.SQL",cQuery+cQueryOrd)
	
cQuery := strtran(cQuery, CR, "")
	
// Executa a query principal
TcQuery cQuery + cQueryOrd NEW ALIAS "QRY"
	
// Conta os registros da Query
TcQuery "SELECT COUNT(*) AS TOTALREG FROM (" + cQuery + ") AS T" NEW ALIAS "QRYCONT"
QRYCONT->(dbgotop())
nReg := QRYCONT->TOTALREG
QRYCONT->(dbclosearea())
	
return()
	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³EXPM001Detº Autor ³ Eduardo Felipe da Silva º Data ³  10/05/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao responsavel pela geracao de arquivo texto                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function EXPM001Det()
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Arquivo Temporario                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cPath   := "\\bigan02-proth01\Protheus_Data\ftpsites\LocalUser\lojas\"+SA1->A1_LOJA+"\" //GetSrvProfString("RootPath","")+cParam1
Local cArq    := ""
Local cProduto:= Space(15)
DbSelectArea("SF2")

_cSENHA		:= Round(((SF2->F2_VALBRUT + Val(SF2->F2_DOC) + SF2->F2_VALICM) / (Val(Right(SM0->M0_CGC,2))+2))*1000,0)

If _cSENHA > 9999
	_cSENHA	:= Right(STR(_cSENHA),4)	
Else
	_cSENHA	:= StrZero(_cSENHA,4)	
EndIf          

RecLock("SF2",.F.)
F2_SENHA	:= _cSENHA
MsUnlock()            

cArq    := SA1->A1_LOJA+_cSENHA+Alltrim(SF2->F2_DOC)+".TXT"
cCodigo := SF2->F2_DOC

If File(cPath+cArq)
	Ferase(cPath+cArq)
EndIf

nHdl := FCreate(cPath+cArq)
CR   := chr(13) + chr(10)

dbSelectArea("QRY")
QRY->(dbGoTop())
While !Eof() 	

	cQuant  := StrZero((QRY->D2_QUANT  *1000),14)  // QUANTIDADE
  	cPrcVen := StrZero((QRY->D2_PRCVEN * 100),14)  // PRECO DE VENDA
   	cTotal  := StrZero((QRY->D2_TOTAL  * 100),14)  // TOTAL    
	dEmissao:= Substr(QRY->D2_EMISSAO,7,2) +"/"+Substr(QRY->D2_EMISSAO,5,2) +"/"+Substr(QRY->D2_EMISSAO,3,2)  // DATA EMISSAO
/*	If QRY->B1_EMPRESA = "1"
		cProduto := QRY->B1_CODRED
	Else
		cProduto := QRY->D2_COD
	EndIf  */
	
	cProduto := QRY->D2_COD
	
	fWrite(nHdl,QRY->D2_DOC+" "+QRY->D2_SERIE+" "+QRY->D2_EMISSAO+" "+SM0->M0_CGC+" "+cProduto+" "+cQuant+" "+cPrcVen+" "+cTotal+CR)	
		
	QRY->(dbSkip())
		
Enddo   
      
FClose(nHdl)   
   
GrdEtiq()

Return()
//=========================================================================================//
//	Função    : MSBAR      		 Autor:  ALEX SANDRO VALARIO                 ata 06/99  //
//=========================================================================================//
//	Descrição :	Imprime Código de Barras                                               //
//=========================================================================================//
//	Parametros:	01 cTypeBar	String com o tipo do codigo de barras                   //
//             	            "EAN13","EAN8","UPCA" ,"SUP5"   ,"CODE128"                 //
//                          "INT25","MAT25,"IND25","CODABAR" ,"CODE3_9"                    //
//              02 nRow	 	Numero da Linha em centimentros                              //
//              03 nCol     Numero da coluna em centimentros                               //
//              04 cCode	String com o conteudo do codigo                                   //
//              05 oPr	    Objeto Printer                                                //
//              06 lcheck   Se calcula o digito de controle                                //
//              07 Cor 	 	Numero  da Cor, utilize a "common.ch"                        //
//              08 lHort	Se imprime na Horizontal                                          //
//              09 nWidth   Numero do Tamanho da barra em centimetros                      //
//              10 nHeigth  Numero da Altura da barra em milimetros                        //
//              11 lBanner  Se imprime o linha em baixo do codigo                          //
//              12 cFont	String com o tipo de fonte                                        //
//              13 cMode	String com o modo do codigo de barras CODE128                     //
//=========================================================================================//
//	Uso       :	Impressao de etiquetas codigo de Barras para HP e Laser                //
//=========================================================================================//

Static FuncTion GrdEtiq()                     


Local oPrn, oDlg, oBtn1, oBtn2, oBtn3, nLin, nCol, oFont1, oFont2
nLin    := 10 // Linha inicial
nCol    := 05 // Coluna inicial


//==========================//
// Definção das Fontes      //
//==========================//

oFont1  := TFont():New("Arial BLACK"    ,30,30,,.F.,,,,,.F.)   // Logotipo
oFont2  := TFont():New("Times New Roman",26,26,,.T.,,,,,.F.)   // Título
oFont3  := TFont():New("Times New Roman",20,20,,.T.,,,,,.F.)   // Dados da NF
oFont4  := TFont():New("Times New Roman",12,12,,.T.,,,,,.F.)   // Codigo de Barras
oPrn    := TMSPrinter():New()


//==========================//
// Definção das Bordas      //
//==========================//

oPrn:StartPage()
oPrn:Box(0700,100,1050,2150)  // Titulo
oPrn:Box(1150,100,1950,2150)  // Dados da NF
oPrn:Box(2100,100,2600,2150)  // Codigo de Barras

//==========================//
// Definção do Texto        //
//==========================//
            1234567890123                                          
cCodigo := '1234567890123  '
oPrn:Say(0300,  200, "LASELVA"                                            ,oFont1,100) // Logotipo
oPrn:Say(0800,  200, "TRANSFERÊNCIA DE MERCADORIA"                        ,oFont2,100) // Título
oPrn:Say(1300,  200, "DE     :  "   + SM0->M0_FILIAL                      ,oFont3,100) // Remetente
oPrn:Say(1500,  200, "PARA:  "      + SA1->A1_NREDUZ                      ,oFont3,100) // Destinatário
oPrn:Say(1700,  200, "REF.  :  NF " + Alltrim(SF2->F2_DOC) + " - " + SF2->F2_SERIE ,oFont3,100) // Referência
oPrn:Say(2250, 1200, "PASSE O LEITOR AQUI"                                ,oFont4,100) // Instrução para Leitor

MsBar("EAN13", nLin, nCol, cCodigo, oPrn, .F.,, .T., 0.015, 0.80 ,NIL,NIL,NIL,.F.) // Código de Barras

oPrn:EndPage()
//oPrn:Print()                                       
oPrn:Preview()

Return(nil)