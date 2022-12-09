#include "protheus.ch"
#include "TopConn.ch"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � LIETQ001 � Autor �Fabricio E. da Costa   � Data � 27/01/10 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Etiqueta de producao                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � PCP                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   �Solic.�  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���Fabricio    �27/01/10�      �Implementacao                             ���
���            �        �      �                                          ���
���            �        �      �                                          ���
���            �        �      �                                          ���
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function ETQINV01()
	Local cPerg     := "ETQINV01"

	//	oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "ETQINV01" , __cUserID )

	Private cTitulo := "Etiqueta Produ��o"
	Private oPrn    := TMSPrinter():New()
	Private oFont1  := TFont():New("Arial" ,06,08,,.F.,,,,,.F.)
	Private oPen1   := TPen():New(, 002, RGB( 000, 000, 000 ))  // Caneta Preta

	
	Pergunte(cPerg, .T.)
	oPrn:Setup() 
	oPrn:SetPaperSize(9)  // para definir tamanho da pagina (A4, office, etc)
	RptStatus({ || PrintRel() }, "Imprimindo..." + cTitulo )

Return

Static Function PrintRel()
	Local cSql     := ""
	Local cCodIni  := ""
	Local cCodFim  := ""
	Local nReg     := 0
	Local nPosX    := 0
	Local nPosY    := 0
	Local nTamLin1 := 040        // Altura da linha
	Local nTamLin2 := 055        // Altura da linha
	Local nCelEsp  := 003        // Espacamento entre os dados e as celulas de uma tabela
	Local nEtqEspC := 030 //040        // Espacamento entre uma coluna de etiqueta e outra
	Local nEtqEspL := 030        // Espacamento entre uma linha de etiqueta e outra
	Local nEtqLin  := 3          // Numero de etiquetas por linha
	Local nEtqCol  := 2          // Numero de etiquetas por Coluna
	Local nLinEtq  := 9          // Numero de linhas por etiqueta
	Local nMargemS := 10         // Margem Superior
	Local nMargemI := 10         // Margem Inferior
	Local nMargemD := 10         // Margem Direita
	Local nMargemE := 10         // Margem Esquerda
	Local nWidth   := 1660//1690       // Tamanho horizontal
	Local nHeight  := 0770       // Tamanho Vertical	
	Local nCol01   := 0005       // Quadro 1 coluna 1
	Local nCol02   := 090 //0100       // Quadro 1 coluna 2
	Local nCol03   := 0365 //0375       // Quadro 1 coluna 3
	Local nCol04   := 0465 //0475       // Quadro 1 coluna 4
	Local nCol05   := 0690 //0700       // Quadro 1 coluna 5
	Local nCol06   := 0790 //0800       // Quadro 1 coluna 6
	Local nCol07   := 1020 //1030       // Quadro 1 coluna 6
	Local nCol08   := 1110 //1120       // Quadro 1 coluna 6
	Local nCol09   := 1360//1370       // Quadro 1 coluna 6
	Local nCol10   := 1450//1460       // Quadro 1 coluna 6
	Local nCol11   := 1650//1680       // Quadro 1 coluna 6
	Local nCont    := 1
	Local aArea    := GetArea()
	Local i, j, k

	cCodIni := MV_PAR01
	cCodFim := MV_PAR02

	cSql := "SELECT "
	cSql += "  SB2.B2_LOCAL, SB2.B2_COD, SB1.B1_DESC "
	cSql += "FROM "
	cSql += "  " + RetSqlName("SB2") + " SB2 JOIN " + RetSqlName("SB1") + " SB1 ON "
	cSql += "    SB2.B2_FILIAL = '" + xFilial("SB2") + "'   AND "
	cSql += "    SB1.B1_FILIAL = '" + xFilial("SB1") + "'   AND "
	cSql += "    SB2.B2_COD    = SB1.B1_COD "
	cSql += "WHERE "
	cSql += "  SB2.D_E_L_E_T_ = ' ' "
	cSql += "  AND SB1.D_E_L_E_T_ = ' ' "
	If !Empty(cCodIni) .And.  !Empty(cCodFim)
		cSql += "  AND SB2.B2_COD  Between '" + cCodIni + "' AND '" + cCodFim + "' "
	EndIF
	cSql += "ORDER BY "
	cSql += "  SB2.B2_LOCAL, SB2.B2_COD"
	TCQuery cSql NEW ALIAS "TMP"	

	oPrn:SetLandScape()
	While !TMP->(Eof())
		i     := 1
		nPosX := nMargemE
		nPosY := nMargemS
		oPrn:StartPage()
		While i <= nEtqCol .And. !TMP->(Eof())
			For j := 1 To nEtqLin
				oPrn:Say(nPosY, nPosX+nCelEsp, "Ficha de Invent�rio", oFont1)
				oPrn:Say(nPosY, nPosX+nCol04, DtoC(dDatabase), oFont1)
				oPrn:Say(nPosY, nPosX+nCol06, Str(j,1) + "� Contagem", oFont1)	
				oPrn:Say(nPosY, nPosX+nCol09, "N� " + StrZero(nCont, 6), oFont1)	
				nPosY += nTamLin1
				oPrn:Say(nPosY, nPosX+nCelEsp+nCol01, "Codigo", oFont1)
				oPrn:Say(nPosY, nPosX+nCelEsp+nCol03, "Descri��o do Item", oFont1) 
				//giane
				oPrn:Say(nPosY, nPosX+(nCol09-05) , "Local " + TMP->B2_LOCAL , oFont1)	
				nPosY += nTamLin1
				nPosY += nCelEsp
				oPrn:Box(nPosY, nPosX, nPosY + nTamLin1, nPosX + nWidth, oPen1)
				oPrn:Line(nPosY, nPosX+nCol03, nPosY+nTamLin1, nPosX+nCol03)
				oPrn:Say(nPosY, nPosX+nCelEsp+nCol01, TMP->B2_COD, oFont1)
				oPrn:Say(nPosY, nPosX+nCelEsp+nCol03, TMP->B1_DESC, oFont1)
				nPosY += nTamLin1
				oPrn:Box(nPosY, nPosX, nPosY + ((nTamLin2+nCelEsp)*nLinEtq), nPosX + nWidth, oPen1)
				oPrn:Line(nPosY, nPosX+nCol02, nPosY+((nTamLin2+nCelEsp)*nLinEtq), nPosX+nCol02)
				oPrn:Line(nPosY, nPosX+nCol03, nPosY+((nTamLin2+nCelEsp)*nLinEtq), nPosX+nCol03)
				oPrn:Line(nPosY, nPosX+nCol04, nPosY+((nTamLin2+nCelEsp)*nLinEtq), nPosX+nCol04)
				oPrn:Line(nPosY, nPosX+nCol05, nPosY+((nTamLin2+nCelEsp)*nLinEtq), nPosX+nCol05)
				oPrn:Line(nPosY, nPosX+nCol06, nPosY+((nTamLin2+nCelEsp)*nLinEtq), nPosX+nCol06)
				oPrn:Line(nPosY, nPosX+nCol07, nPosY+((nTamLin2+nCelEsp)*nLinEtq), nPosX+nCol07)
				oPrn:Line(nPosY, nPosX+nCol08, nPosY+((nTamLin2+nCelEsp)*nLinEtq), nPosX+nCol08)
				oPrn:Line(nPosY, nPosX+nCol09, nPosY+((nTamLin2+nCelEsp)*nLinEtq), nPosX+nCol09)
				oPrn:Line(nPosY, nPosX+nCol10, nPosY+((nTamLin2+nCelEsp)*nLinEtq), nPosX+nCol10)
				For k := 1 To nLinEtq
					nPosY += nCelEsp
					oPrn:Say(nPosY, nPosX+nCelEsp+nCol01, "Lote", oFont1)
					oPrn:Say(nPosY, nPosX+nCelEsp+nCol03, "Fab.", oFont1)
					oPrn:Say(nPosY, nPosX+nCelEsp+nCol05, "Val.", oFont1)
					oPrn:Say(nPosY, nPosX+nCelEsp+nCol07, "Qtd.", oFont1)
					oPrn:Say(nPosY, nPosX+nCelEsp+nCol09, "End.", oFont1)
					nPosY += nTamLin2
					oPrn:Line(nPosY, nPosX+nCol02, nPosY, nPosX+nCol03)
					oPrn:Line(nPosY, nPosX+nCol04, nPosY, nPosX+nCol05)
					oPrn:Line(nPosY, nPosX+nCol06, nPosY, nPosX+nCol07)
					oPrn:Line(nPosY, nPosX+nCol08, nPosY, nPosX+nCol09)
					oPrn:Line(nPosY, nPosX+nCol10, nPosY, nPosX+nWidth)
				Next
				nPosY += nTamLin2
				oPrn:Line(nPosY, nPosX+nCol01, nPosY, nPosX+nCol05)
				oPrn:Line(nPosY, nPosX+nCol06, nPosY, nPosX+nCol09)
				nPosY += nCelEsp
				oPrn:Say(nPosY, nPosX+260, "Contado Por:", oFont1)
				oPrn:Say(nPosY, nPosX+1050, "Visto", oFont1)
				nPosY := (nHeight + nEtqEspC) * j
			Next
			nCont++

			TMP->(DbSkip())
			nPosX := (nWidth + nEtqEspL) * i
			nPosY := nMargemS		
			i++
		End
		oPrn:EndPage()
	End
	TMP->(DbCloseArea())
	oPrn:Preview() //
	oPrn:End() //Fim da impressao grafica

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    � New_Page �Autor  �Fabricio E. da Costa� Data �  08/05/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �   Inicia o relatorio ou finaliza a pagina que esta sendo   ���
���          � impressa e inicia uma nova, ja colocando cabecalho e       ���
���          � numeracao.                                                 ���
���          �                                                            ���
���          �Parametros:                                                 ���
���          � lInicio.: .T. Inicia o relatorio grafico                   ���
���          �           .F. Finaliza a pagina que esta sendo impressa e  ���
���          �               inicia uma nova                              ���
���          �Retorno:                                                    ���
���          � Nil                                                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GERAL                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function New_Page(oPrint, lInicio)
	If !lInicio
		oPrint:EndPage()
		nPag++
	EndIf
	nPosX := nMargemE
	nPosY := nMargemS
	oPrint:StartPage()
Return
