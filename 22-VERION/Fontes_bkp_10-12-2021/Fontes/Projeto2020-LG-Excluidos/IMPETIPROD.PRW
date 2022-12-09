#Include "RWMAKE.CH"
#INCLUDE "PRTOPDEF.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImEtqPro  º Autor ³Francisco Oliveira     º Data ³26/01/2010º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Etiqueta Produto - Verion                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ImEtqPro()

Local _cPorta  := "LPT1"
Local aSays		:= {}
Local aButtons	:= {}
Local nOpca		:= 0
Local cCadastro:= "Impressao de Etiquetas"
Private cPerg  := "ImpEti    "

//Verifica porta de impressao
//If !IsPrinter(_cPorta)
//	Return
//Endif

//Verifica dicionario de perguntas
AjustaSX1()
Pergunte(cPerg, .F.)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montagem da tela de processamento³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd( aSays, OemToAnsi( "Este programa emite etiquetas para embalagens" ) )
aAdd( aSays, OemToAnsi( "                                             " ) )
aAdd( aSays, OemToAnsi( "                                             " ) )
aAdd( aSays, OemToAnsi( "                                             " ) )

aAdd( aButtons, { 5, .T., {|| Pergunte( cPerg, .T. )						}} )
aAdd( aButtons, { 1, .T., {|| nOpca := 1,OKGeraEti(),FechaBatch()	}} )
aAdd( aButtons, { 2, .T., {|| FechaBatch()               				}} )

FormBatch( cCadastro, aSays, aButtons )

Return( Nil )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³OkGeraExl º Autor ³ Francisco Oliveira º Data ³  29/12/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ A funcao OkGeraEtl monta a janela com a regua de           º±±
±±º          ³ processamento.                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function OkGeraEti()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicializa a regua de processamento³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Processa({|| ExeGerEti() },"Aguarde...",, .T. )

Return( Nil )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ExeGerExl º Autor ³ Francisco Oliveira º Data ³  29/12/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela OkGeraEti. A funcao ExeGerEti º±±
±±º          ³ processa as informacoes para geracao de relatorio          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ExeGerEti()

Local _nX
Local _CkhC6Prd:= .F.			//Validador de Produto no cadastro SB1
Local _dMesEmOP:= ""			//Mes de Emissão da O.P.
Local _dAnoEmOP:= ""			//Ano de Emissão da O.P.
Local _cDesCli := ""			// Descrição do Produto no Cliente
Local _dAnoval := ""			// Data da validade do produto - "_DtEmOp + 1 ano"
Local _nPesoEmb:= 0				// Peso da Embalagem
//Local _nCtrlot := MV_PAR03		// Controlador do numero de  embalagens, sempre mudar apos 40
Local _cCodigo := ""			//Codigo Produto na SC2(ordem de produção)
//Local _cLogo := FisxLogo("1")	//Logo Remo na impressão da Etiqueta
Local _cDtEmOp := ""			// Data Emissao da Ordem de Produção
Local _cLoteIn := ""			// Lote Interno Remo - Rastreabilidade - Numero da Ordem de Produção/Usado como numero de lote na etiqueta
Local _cCodPro := ""			// Codigo do Produto no Cliente
Local _nQtdEtq := 0				//Qtd digitada no parametro
Local _cDesProd:= ""			//Descrição Produto na Verion
Local _nTtlEti := 0				//Total de etiquetas solicitadas para impressão 
Local _cPratele:=""
Local nLin     := 1
Local nEtiq    := 1
Local nUltima  := 0
Local nQtdEtiq := 0
Local i		   := 0
oFont06  := TFont():New( "Arial",,06,,.F.,,,,,.F. )
oFont06B := TFont():New( "Arial",,06,,.T.,,,,,.F. )
oFont07  := TFont():New( "Arial",,07,,.F.,,,,,.F. )
oFont07B := TFont():New( "Arial",,07,,.T.,,,,,.F. )
oFont08  := TFont():New( "Arial",,08,,.F.,,,,,.F. )
oFont08B := TFont():New( "Arial",,08,,.T.,,,,,.F. )
oFont09  := TFont():New( "Arial",,09,,.F.,,,,,.F. )
oFont09B := TFont():New( "Arial",,09,,.T.,,,,,.F. )
oFont10  := TFont():New( "Arial",,10,,.F.,,,,,.F. )
oFont10B := TFont():New( "Arial",,10,,.T.,,,,,.F. )
oFont11  := TFont():New( "Arial",,11,,.F.,,,,,.F. )
oFont11B := TFont():New( "Arial",,11,,.T.,,,,,.F. )
oFont12  := TFont():New( "Arial",,12,,.F.,,,,,.F. )
oFont12B := TFont():New( "Arial",,12,,.T.,,,,,.F. )
oFont13  := TFont():New( "Arial",,13,,.F.,,,,,.F. )
oFont13B := TFont():New( "Arial",,13,,.T.,,,,,.F. )
oFont14  := TFont():New( "Arial",,14,,.F.,,,,,.F. )
oFont14B := TFont():New( "Arial",,14,,.T.,,,,,.F. )
oFont15  := TFont():New( "Arial",,15,,.F.,,,,,.F. )
oFont15B := TFont():New( "Arial",,15,,.T.,,,,,.F. )
oFont16  := TFont():New( "Arial",,16,,.F.,,,,,.F. )
oFont16B := TFont():New( "Arial",,16,,.T.,,,,,.F. )
oFont17  := TFont():New( "Arial",,17,,.F.,,,,,.F. )
oFont17B := TFont():New( "Arial",,17,,.T.,,,,,.F. )
oFont18  := TFont():New( "Arial",,18,,.F.,,,,,.F. )
oFont18B := TFont():New( "Arial",,18,,.T.,,,,,.F. )
oFont19  := TFont():New( "Arial",,19,,.F.,,,,,.F. )
oFont19B := TFont():New( "Arial",,19,,.T.,,,,,.F. )
oFont20  := TFont():New( "Arial",,20,,.F.,,,,,.F. )
oFont20B := TFont():New( "Arial",,20,,.T.,,,,,.F. )
oFont21  := TFont():New( "Arial",,21,,.F.,,,,,.F. )
oFont21B := TFont():New( "Arial",,21,,.T.,,,,,.F. )
oFont22  := TFont():New( "Arial",,22,,.F.,,,,,.F. )
oFont22B := TFont():New( "Arial",,22,,.T.,,,,,.F. )
oFont23  := TFont():New( "Arial",,23,,.F.,,,,,.F. )
oFont23B := TFont():New( "Arial",,23,,.T.,,,,,.F. )
oFont24  := TFont():New( "Arial",,24,,.F.,,,,,.F. )
oFont24B := TFont():New( "Arial",,24,,.T.,,,,,.F. )
oFont25  := TFont():New( "Arial",,25,,.F.,,,,,.F. )
oFont25B := TFont():New( "Arial",,25,,.T.,,,,,.F. )
oFont26  := TFont():New( "Arial",,26,,.F.,,,,,.F. )
oFont26B := TFont():New( "Arial",,26,,.T.,,,,,.F. )
oFont27  := TFont():New( "Arial",,27,,.F.,,,,,.F. )
oFont27B := TFont():New( "Arial",,27,,.T.,,,,,.F. )
oFont28  := TFont():New( "Arial",,28,,.F.,,,,,.F. )
oFont28B := TFont():New( "Arial",,28,,.T.,,,,,.F. )
oFont29  := TFont():New( "Arial",,29,,.F.,,,,,.F. )
oFont29B := TFont():New( "Arial",,29,,.T.,,,,,.F. )
oFont30  := TFont():New( "Arial",,30,,.F.,,,,,.F. )
oFont30B := TFont():New( "Arial",,30,,.T.,,,,,.F. )
Private _nPosHor := 0
Private _nLinha  := 0
Private _nEspLin := 0
Private _nTxtBox := 0
Private _nPosVer := 0

oprn     := TMSPrinter():New()
oprn:setup()

_nPosHor := 01
_nEspLin := 20
_nTxtBox := 05

//--Inicio do processamento

// Cabeçalho da Ordem de Produção
DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial("SB1") + Alltrim(MV_PAR01))

If !found()
	MsgAlert("Produto não encontrado no Cadastro","A T E N C A O")
	Return(.F.)
Endif

oprn:StartPage()
oprn:SetPortrait()

_nTtlEti	:= MV_PAR04 // Imprime a Qtde. Etiquetas informada no parametro
	
For i:= 1 to _nTtlEti

    DbSelectArea("SB1")
    DbSetOrder(1)
    DbSeek(xFilial("SB1") + Alltrim(MV_PAR01))

	While Alltrim(SB1->B1_COD) >= Alltrim(MV_PAR01) .AND. Alltrim(SB1->B1_COD) <= Alltrim(MV_PAR02)
		_cCodigo	:= Alltrim(SB1->B1_COD)			//Codigo do Produto na O.P.
		_cDesProd	:=        (SB1->B1_DESC)		//Data Emissao da Ordem de Produção
   
   		DbSelectArea("SB2")
   		DbSetOrder(1)           
   		Dbgotop()
  		_cPratele := Alltrim(Posicione("SB2", 1, xFilial("SB2")+_cCodigo, "B2_LOCALIZ")) //Numero da ordem de produção/Usado como numero de lote na etiqueta

   		DbSelectArea("SB1")
   		DbSetOrder(1)

	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se usuario teclou ALT+A para abandonar                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
		Inkey( 0.01 )	
		If LastKey() == 286
			@ nLin +  1, 000 PSAY "*** CANCELADO PELO USUARIO ***"
			Exit
		EndIf
	
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se estourou o tamanho da página ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    
    	If nQtdEtiq > 07
			oprn:EndPage()
			oprn:StartPage()
			nLin     := 1
			nQtdEtiq := 0
		EndIf

		nLin := nLin + 2
		oprn:say(_nPosHor+((nLin)*_nEspLin),0015,"VERION OLEOHIDRAULICA LTDA",ofont11,60)
		nLin := nLin + 2                       
		oprn:say(_nPosHor+((nLin)*_nEspLin),0015,"Codigo:     "+_cCodigo,ofont11,60)
   		nLin := nLin + 2
    	oprn:say(_nPosHor+((nLin)*_nEspLin),0015,"Descricao:  "+SubStr(_cDesProd,01,20)+" "+SubStr(_cDesProd,21,20),ofont11,60)
		nLin := nLin + 2                                     
		oprn:say(_nPosHor+((nLin)*_nEspLin),0015,"Prateleira: "+_cPratele,ofont11,60)
		nLin := nLin + 2                                     
		oprn:say(_nPosHor+((nLin)*_nEspLin),0015,"Exp./Fabr.: "+ Dtoc(Mv_par03),ofont11,60)
		nLin := nLin + 2
		oprn:say(_nPosHor+((nLin)*_nEspLin),0015,"No.Lote:    ",ofont11,60)
		nLin := nLin + 2
		oprn:say(_nPosHor+((nLin)*_nEspLin),0015,"Fone: ++55 11 2100-7400 / Fax: ++55 11 2100-7409",ofont11,60)
		nLin := nLin + 2
		oprn:say(_nPosHor+((nLin)*_nEspLin),0015,"E-mail: vendas@verion.com.br / www.verion.com.br",ofont11,60)
		nLin := nLin + 2
		
		If nQtdEtiq == 0
			nLin := nLin + 5
		Else
			nLin := nLin + 4            
		EndIf
		
		nQtdEtiq := nQtdEtiq + 1

		SB1->(dbSkip())

	EndDo

Next i
oprn:EndPage()
oprn:Preview()

FT_PFLUSH()

Return( Nil )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³AjustaSX1 º Autor ³ Francisco Oliveira º Data ³  29/12/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Verifica a existencia das perguntas criando-as caso seja   º±±
±±º          ³ necessario (caso nao existam).                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1()
cAlias:=Alias()
_nPerg := 1
dbSelectArea("SX1")
dbSetOrder(1) 
dbGotop()
If dbSeek(alltrim(cPerg))
	DO WHILE ALLTRIM(SX1->X1_GRUPO) == ALLTRIM(cPerg)
		_nPerg := _nPerg + 1
		DBSKIP()
	ENDDO
ENDIF

aRegistro:= {}
//          Grupo/Ordem/Pergunt              		/SPA/ENG/Variavl/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefSPA1/DefENG1/Cnt01/Var02/Def02/DefSPA2/DefENG2/Cnt02/Var03/Def03/DefSPA3/DefENG3/Cnt03/Var04/Def04/DefSPA4/DefENG4/Cnt04/Var05/Def05/DefSPA5/DefENG5/Cnt05/F3/Pyme/GRPSXG/HELP/PICTURE
aAdd(aRegistro,{cPerg,"01","Do Produto?			","","","mv_ch1","C",30,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""})
aAdd(aRegistro,{cPerg,"02","Ate Produto?		","","","mv_ch2","C",30,00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""})
aAdd(aRegistro,{cPerg,"03","Data Fabricacao?	","","","mv_ch3","D",08,00,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})
aAdd(aRegistro,{cPerg,"04","Qtde. Etiquetas?	","","","mv_ch4","N",03,00,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})

IF Len(aRegistro) >= _nPerg
	For i:= _nPerg  to Len(aRegistro)
		Reclock("SX1",.t.)
		For j:=1 to FCount()
			If J<= LEN (aRegistro[i])
				FieldPut(j,aRegistro[i,j])
			Endif
		Next
		MsUnlock()
	Next
EndIf
dbSelectArea(cAlias)
Return
