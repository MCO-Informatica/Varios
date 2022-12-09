#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ProdXOper � Autor � Luiz Alberto       � Data �  Abr/2014  ���
�������������������������������������������������������������������������͹��
���Descricao � Tela Respons�vel pela Digita��o de Qtde Produzida por       ��
���          � Operadores na tela de Lan�amento de Produ��o MATA681       ���
�������������������������������������������������������������������������͹��
���Uso       � Metalacre                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function ProdXOper(lInclui,lAltera)
Local nX
Local aFieldFill := {}
Local aFields := {"NOUSER"}
Local aAlterFields := {'PWI_CODOPE','PWI_DTINI','PWI_HRINI','PWI_DTFIM','PWI_HRFIM','PWI_QTDPRD'}
Local cGetOpc        := GD_INSERT+GD_DELETE+GD_UPDATE
Static oMSNewGe1
Private cTotal := 'Total Produzido: '
Private oChkLinha
Private lChkLinha := .f.
Private oDlg3
Private nTotal := 0.00

Return .t.	// FUNCAO DESABILITADA MOMENTANEAMENTE
If !IsInCallStack("MATA681")
	Return .t.
Endif

nUsado:=0
aHeaderEx:={}
If Type("aColsEx") == "U" .And. lInclui
	Public aColsEx := {}
	Public aColsCp := {}
	Public lPChkLinha := .f.
Endif

// Conteudo Variavel Publica

lChkLinha := lPChkLinha

DbSelectArea("SX3")
dbSetOrder(1)
DbSeek("PWI")
While !Eof().And.(x3_arquivo=="PWI")

	If X3USO(x3_usado).And.cNivel>=x3_nivel .And. !Alltrim(X3_CAMPO) $ "PWI_FILIAL*PWI_RECSH6*PWI_LINPRD"
		nUsado:=nUsado+1
		Aadd(aHeaderEx,{ Trim(x3_titulo), x3_campo, x3_picture,;
		x3_tamanho, x3_decimal, Iif(Alltrim(X3_CAMPO) $ "PWI_CODOPE",'U_ChkLinAnt(n)',x3_valid),;
		x3_usado, x3_tipo, x3_F3, x3_context, x3_cbox, x3_relacao } )


/*aAdd(aColunas, "SX3->X3_TITULO")
aAdd(aColunas, "SX3->X3_CAMPO")
aAdd(aColunas, "SX3->X3_PICTURE")
aAdd(aColunas, "SX3->X3_TAMANHO")
aAdd(aColunas, "SX3->X3_DECIMAL")
aAdd(aColunas, "SX3->X3_VALID")
aAdd(aColunas, "SX3->X3_USADO")
aAdd(aColunas, "SX3->X3_TIPO")
aAdd(aColunas, "SX3->X3_F3")
aAdd(aColunas, "SX3->X3_CONTEXT")
aAdd(aColunas, "SX3->X3_CBOX")
aAdd(aColunas, "SX3->X3_RELACAO")
aAdd(aColunas, "SX3->X3_WHEN")
aAdd(aColunas, "SX3->X3_VISUAL")
aAdd(aColunas, "SX3->X3_VLDUSER")
aAdd(aColunas, "SX3->X3_PICTVAR")
aAdd(aColunas, "IIf(!Empty(SX3->X3_OBRIGAT),.T.,.F.)")
  */
	Endif
	DbSkip()
End

// Se For Uma Altera��o ent�o carrega direto da Tabela
If lAltera 
	DbSelectArea("PWI")
	DbSetOrder(1)
	DbSeek(xFilial('PWI')+StrZero(SH6->(Recno()),10))
	While PWI->(!Eof()) .And. PWI->PWI_FILIAL == xFilial("PWI") .And. PWI->PWI_RECSH6 == StrZero(SH6->(Recno()),10)
		AADD(aColsEx,Array(nUsado+1))
		For _ni:=1 To nUsado
			aColsEx[Len(aColsEx),_ni]:=FieldGet(FieldPos(aHeaderEx[_ni,2]))
		Next 
		aColsEx[Len(aColsEx),nUsado+1]:=.F.
		PWI->(dbSkip(1))
	End        
Endif

aColsCp := aClone( aColsEx )
aCols := aClone( aColsEx )
aHeader := aClone( aHeaderEx )
RegToMemory("PWI",.f.)


If !lInclui .And. !lAltera	// Se For Visualiza��o ent�o N�o Permite Alterar os Campos
	cGetOpc        := GD_UPDATE

	aAlterFields := {}
Endif   

nOpc := 0

@ 63,1 TO 530,797 DIALOG oDlg3 TITLE "Produ��o por Operadores - Ordem "+M->H6_OP 

oMSNewGe1 := MsNewGetDados():New( 015, 004, 210, 391, cGetOpc, "u_linha(n)", "tudoOK()", "", aAlterFields,, 999,,,,oDlg3, aHeader, aCols)
oMSNewGe1:oBrowse:bChange := {||U_Linha(oMsNewGe1:nAt)}
oMSNewGe1:Refresh()  

@ 215, 300 CHECKBOX oChkLinha VAR lChkLinha PROMPT "Linha de Produ��o ?" SIZE 100, 014 OF oDlg3 COLORS 0, 16777215 PIXEL
oChkLinha:bChange := {||U_Linha(1)}

@ 215, 005 SAY   oSayTotal PROMPT cTotal  PIXEL SIZE 300, 16 COLORS CLR_BLUE,CLR_WHITE PIXEL OF oDlg3
oSayTotal:oFont := TFont():New('Arial',,24,,.T.,,,,.T.,.F.)


ACTIVATE DIALOG oDlg3 CENTERED ON INIT EnchoiceBar(oDlg3,{||nOpc:=1,if(TudoOk(),oDlg3:End(),nOpc := 0)},{||nOpc:=2,oDlg3:End()}) VALID nOpc != 0

If nOpc == 1
	aColsEx	:= oMSNewGe1:aCols
Else          
	Alert("Aten��o � Obrigat�rio o Preenchimento das Quantidades Produzidas por Operador !")
	Return .f.
EndIf
Return .T.

Static Function TudoOk()
If Empty(Len(oMSNewGe1:aCols))
	Return .f.
Endif

U_Linha(1)
If nTotal <> M->H6_QTDPROD 
	Alert("Aten��o o Total Produzido pelos Operadores N�o Pode Ser Diferente do Informado !")
	Return .f.
Endif

// Analise das Datas e Horas dos Lan�amentos

If !Empty(Len(oMSNewGe1:aCols))
	lDataIni := .t.
	lDataFim := .t.
	lHoraIni := .t.
	lHoraFim := .t.
	aLinhaIni:= {}
	aLinhaFim:= {}
	lLinha	:= .t.	

	For _nX := 1 To Len(oMSNewGe1:aCols)
		If !oMSNewGe1:aCols[_nX,Len(oMSNewGe1:aHeader)+1]
			If Empty(aLinhaIni)
				AAdd(aLinhaIni,{oMSNewGe1:aCols[_nX,Ascan(oMSNewGe1:aHeader,{|x|Alltrim(x[2])=="PWI_DTINI"})],;
								oMSNewGe1:aCols[_nX,Ascan(oMSNewGe1:aHeader,{|x|Alltrim(x[2])=="PWI_HRINI"})]})
			Endif
			
			// Comparacao de Data e Hora entre as Linhas
//			dDataI := oMSNewGe1:aCols[_nX,Ascan(oMSNewGe1:aHeader,{|x|Alltrim(x[2])=="PWI_DTINI"})]
//			dDataF := oMSNewGe1:aCols[_nX,Ascan(oMSNewGe1:aHeader,{|x|Alltrim(x[2])=="PWI_DTFIM"})]
//			cHoraI := oMSNewGe1:aCols[_nX,Ascan(oMSNewGe1:aHeader,{|x|Alltrim(x[2])=="PWI_HRINI"})]
//			cHoraF := oMSNewGe1:aCols[_nX,Ascan(oMSNewGe1:aHeader,{|x|Alltrim(x[2])=="PWI_HRFIM"})]
			
			
			
			aLinhaFim := {{oMSNewGe1:aCols[_nX,Ascan(oMSNewGe1:aHeader,{|x|Alltrim(x[2])=="PWI_DTFIM"})],;
								oMSNewGe1:aCols[_nX,Ascan(oMSNewGe1:aHeader,{|x|Alltrim(x[2])=="PWI_HRFIM"})]}}
		Endif
	Next

	If aLinhaIni[1,1] <> M->H6_DATAINI	// Problema Encontrado na Primeira Linha do Lan�amento Referente Data Inicial
		lDataIni := .f.
	Endif
	If aLinhaIni[1,2] <> M->H6_HORAINI	// Problema Encontrado na Primeira Linha do Lan�amento Referente Hora Inicial
		lHoraIni := .f.
	Endif
	If aLinhaFim[1,1] <> M->H6_DATAFIN // Problema Encontrado na Ultima Linha do Lan�amento Referente Data Final
		lDataFim := .f.
	Endif
	If aLinhaFim[1,2] <> M->H6_HORAFIN	// Problema Encontrado na Ultima Linha do Lan�amento Referente Hora Final
		lDataFim := .f.
	Endif
	
	If !lDataIni
		Alert("Aten��o Encontrada Diverg�ncia de Datas, a Data Inicial " + Chr(13) + "da Primeira Linha Deve Ser Igual a Data Inicial Informada !")
		Return .f.
	Endif
		
	If !lHoraIni
		Alert("Aten��o Encontrada Diverg�ncia de Horas, a Hora Inicial " + Chr(13) + "da Primeira Linha Deve Ser Igual a Hora Inicial Informada !")
		Return .f.
	Endif
	
	If !lDataFim
		Alert("Aten��o Encontrada Diverg�ncia de Datas, a Data Final " + Chr(13) + "da �ltima Linha Deve Ser Igual a Data Final Informada !")
		Return .f.
	Endif
	
	If !lHoraFim
		Alert("Aten��o Encontrada Diverg�ncia de Horas, a Hora Final " + Chr(13) + "da �ltima Linha Deve Ser Igual a Hora Final Informada !")
		Return .f.
	Endif         
Endif
Return .t.

User Function Linha(nn)
nTotal := Iif(lChkLinha,M->H6_QTDPROD,0)

If lChkLinha .And. !lPChkLinha
	aColsCp := aClone( oMSNewGe1:aCols )
ElseIf !lChkLinha .And. !lPChkLinha
	aColsCp := aClone( oMSNewGe1:aCols )
ElseIf !lChkLinha .And. lPChkLinha
	oMSNewGe1:aCols := aClone( aColsCp )
Endif

For _nX := 1 To Len(oMSNewGe1:aCols)
	If !oMSNewGe1:aCols[_nX,Len(oMSNewGe1:aHeader)+1] .And. !lChkLinha
		nTotal += oMSNewGe1:aCols[_nX,Ascan(oMSNewGe1:aHeader,{|x|Alltrim(x[2])=="PWI_QTDPRD"})]
	ElseIf lChkLinha
		oMSNewGe1:aCols[_nX,Ascan(oMSNewGe1:aHeader,{|x|Alltrim(x[2])=="PWI_DTINI"})] := M->H6_DATAINI
		oMSNewGe1:aCols[_nX,Ascan(oMSNewGe1:aHeader,{|x|Alltrim(x[2])=="PWI_HRINI"})] := M->H6_HORAINI
		oMSNewGe1:aCols[_nX,Ascan(oMSNewGe1:aHeader,{|x|Alltrim(x[2])=="PWI_DTFIM"})] := M->H6_DATAFIN
		oMSNewGe1:aCols[_nX,Ascan(oMSNewGe1:aHeader,{|x|Alltrim(x[2])=="PWI_HRFIM"})] := M->H6_HORAFIN
		oMSNewGe1:aCols[_nX,Ascan(oMSNewGe1:aHeader,{|x|Alltrim(x[2])=="PWI_QTDPRD"})] := M->H6_QTDPROD
	Endif
Next
	
lPChkLinha := lChkLinha

cTotal := 'Total Produzido: '+TransForm(nTotal,"@E 999,999")
oMSNewGe1:Refresh(.T.)   
oSayTotal:Refresh()      
DlgRefresh(oDlg3)
Return .t.
                               
/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � A680Hora � Autor � Rodrigo de A. Sartorio� Data � 25.09.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Faz a consistencia dos Horarios digitados.                 ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � A680Hora()                                                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Mata680                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PRDChkHora()
Local lRet   := .T.
Local cCampo := ReadVar()
Local nEndereco
Local nHora,nMinutos
Local nPos
Local cHoraIni := oMSNewGe1:aCols[n,Ascan(oMSNewGe1:aHeader,{|x|Alltrim(x[2])=="PWI_HRINI"})]
Local dDataIni := oMSNewGe1:aCols[n,Ascan(oMSNewGe1:aHeader,{|x|Alltrim(x[2])=="PWI_DTINI"})]
Local cHoraFim := oMSNewGe1:aCols[n,Ascan(oMSNewGe1:aHeader,{|x|Alltrim(x[2])=="PWI_HRFIM"})]
Local dDataFim := oMSNewGe1:aCols[n,Ascan(oMSNewGe1:aHeader,{|x|Alltrim(x[2])=="PWI_DTFIM"})]

If cCampo == "M->PWI_HRINI" .Or. cCampo == "M->PWI_HRFIM" .And. lRet
	If cCampo == "M->PWI_HRFIM"
		nPos:=AT(":",M->PWI_HRFIM)
	Else
		nPos:=AT(":",M->PWI_HRINI)
	EndIf
	If Val(Substr(&(ReadVar()),nPos-2,2)) > 24 .Or. Val(Substr(&(ReadVar()),nPos+1,2)) > 59 
		Help(" ",1,"A680HRINVL")
		lRet := .f.
	ElseIf Val(Substr(&(ReadVar()),nPos-2,2)) == 24 .And. Val(Substr(&(ReadVar()),nPos+1,2)) > 0 
		Help(" ",1,"A680HRINVL")
	    lRet := .f.
	EndIf
	If!Empty(cHoraFim) .And. cHoraFim <= cHoraIni .And. dDataFim == dDataIni .And. lRet
		Help(" ",1,"A680Hora")
		lRet := .F.
	EndIf
EndIf

//�����������������������������������Ŀ
//�Substitui espacos em branco por "0"�
//�������������������������������������
If lRet
	&(ReadVar()) := StrTran(&(ReadVar())," ", "0")
EndIf

Return(lRet)


/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � A680Data � Autor � Jose Lucas            � Data � 28.10.93 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Faz a consistencia da data Final digitada                  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � A680Data()                                                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MatA680                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PRDChkData()
Local lRet := .T.,nEndereco:=0
Local cHoraIni := oMSNewGe1:aCols[n,Ascan(oMSNewGe1:aHeader,{|x|Alltrim(x[2])=="PWI_HRINI"})]
Local dDataIni := oMSNewGe1:aCols[n,Ascan(oMSNewGe1:aHeader,{|x|Alltrim(x[2])=="PWI_DTINI"})]
Local cHoraFim := oMSNewGe1:aCols[n,Ascan(oMSNewGe1:aHeader,{|x|Alltrim(x[2])=="PWI_HRFIM"})]
Local dDataFim := oMSNewGe1:aCols[n,Ascan(oMSNewGe1:aHeader,{|x|Alltrim(x[2])=="PWI_DTFIM"})]

If !Empty(dDataFim) .And. dDataFim < dDataIni
	Help(" ",1,"A680DATA")
	lRet := .F.
EndIf

If lRet .And. !Empty(dDataIni) .And. !Empty(dDataFim) .And. !Empty(cHoraIni) .And. !Empty(cHoraFim)
	If (DTOS(dDataIni) + cHoraIni) >= (DTOS(dDataFim) + cHoraFim)
		Help(" ",1,"A680Hora")
		lRet := .F.
	EndIf
EndIf
Return( lRet )

// Sugere Informa��es da Linha anterior na nova linha a ser digitada

User Function ChkLinAnt(nPos)
If nPos > 1 .And. Empty(oMSNewGe1:aCols[n,Ascan(oMSNewGe1:aHeader,{|x|Alltrim(x[2])=="PWI_CODOPE"})])
	If !oMSNewGe1:aCols[nPos-1,Len(oMSNewGe1:aHeader)+1]
		cHoraIni := oMSNewGe1:aCols[nPos-1,Ascan(oMSNewGe1:aHeader,{|x|Alltrim(x[2])=="PWI_HRINI"})]
		dDataIni := oMSNewGe1:aCols[nPos-1,Ascan(oMSNewGe1:aHeader,{|x|Alltrim(x[2])=="PWI_DTINI"})]
		cHoraFim := oMSNewGe1:aCols[nPos-1,Ascan(oMSNewGe1:aHeader,{|x|Alltrim(x[2])=="PWI_HRFIM"})]
		dDataFim := oMSNewGe1:aCols[nPos-1,Ascan(oMSNewGe1:aHeader,{|x|Alltrim(x[2])=="PWI_DTFIM"})]
		
		oMSNewGe1:aCols[nPos,Ascan(oMSNewGe1:aHeader,{|x|Alltrim(x[2])=="PWI_DTINI"})] := M->H6_DATAINI
		oMSNewGe1:aCols[nPos,Ascan(oMSNewGe1:aHeader,{|x|Alltrim(x[2])=="PWI_HRINI"})] := cHoraFim
		oMSNewGe1:aCols[nPos,Ascan(oMSNewGe1:aHeader,{|x|Alltrim(x[2])=="PWI_HRFIM"})] := M->H6_HORAFIN
		oMSNewGe1:aCols[nPos,Ascan(oMSNewGe1:aHeader,{|x|Alltrim(x[2])=="PWI_DTFIM"})] := M->H6_DATAFIN
	Endif
Endif
Return .t.
		
		