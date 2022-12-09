#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Obs_cli()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_CTEXTO,_CTEXTOORIG,_NTAMANHO,J,_CSUBTEXTO,I")
SetPrvt("CSTRING,NTIPO,CRODATXT,NCNTIMPR,CDESC1,CDESC2")
SetPrvt("CDESC3,TAMANHO,ARETURN,NOMEPROG,ALINHA,NLASTKEY")
SetPrvt("LI,TITULO,CABEC1,CABEC2,CCANCEL,M_PAG")
SetPrvt("WNREL,_CTXT,_NTAMTOT,_NPOS,_NCOL,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ OBS_CLI  ³ Autor ³ Luciano Lorenzetti ³ Data ³  29/05/00   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Desenha tela que permite alteracao dos dados historicos do ³±±
±±³          ³ cliente.                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Espec¡fico para clientes KENIA                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

dbSelectArea("SZA")
dbSetOrder(1)
_cTexto := ""              // CAMPO UTILIZADO PARA ARMAZENAR O TEXTO DIGITADO.
If dbSeek(xFilial("SZA")+SA1->A1_COD+SA1->A1_LOJA)
//If dbSeek(SA1->A1_COD+SA1->A1_LOJA)
   Do While SZA->ZA_X_CODIG==SA1->A1_COD .AND. SZA->ZA_X_LOJA==SA1->A1_LOJA
//		msgbox(sza->za_x_texto)
	  _cTexto  := _cTexto + SZA->ZA_X_TEXTO
//		msgbox(_ctexto)
	  dbSkip()
   EndDo
EndIf
_cTextoOrig := AllTrim(_cTexto)
_cTexto 	:= _cTextoOrig
dbGoTop()
dbSeek(xFilial("SZA")+SA1->A1_COD+SA1->A1_LOJA)
//dbSeek(SA1->A1_COD+SA1->A1_LOJA)
///
@ 116,090 To 416,607 Dialog oDlgMemo Title "Atual. Informacoes de Clientes:"
@ 003,002 To 040,210
///

@ 014,009 Say OemToAnsi("Cliente : "+ SA1->A1_COD +"-"+ SA1->A1_LOJA + " - " +SA1->A1_NOME )     Object oNome
@ 024,009 Say OemToAnsi("Ultima atualizacao em " + DTOC(SZA->ZA_X_DATA) + " as " +  SZA->ZA_X_HORA + "h,  por " + UPPER(SZA->ZA_X_USUAR))
///
///
@ 06,220 BmpButton Type 1 Action FRSalva()// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> @ 06,220 BmpButton Type 1 Action Execute(FRSalva)
@ 21,220 BmpButton Type 2 Action FRSair()// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> @ 21,220 BmpButton Type 2 Action Execute(FRSair)
@ 36,220 BmpButton Type 6 Action FRImpr()                   // Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> @ 36,220 BmpButton Type 6 Action Execute(FRImpr)                   

@ 055,005 Get _cTexto   Size 250,080  MEMO                                 Object oMemo

Activate Dialog oDlgMemo Center

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ FRSALVA  º Autor ³ Luciano Lorenzetti º Data ³Thu  08/02/00º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Rotina para salvar o conteudo da variavel cTEXTO no arquivoº±±
±±º          ³ SZA.                                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Espec¡fico para clientes Microsiga                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function FRSalva
Static Function FRSalva()
   If _cTextoOrig == _cTexto
	  Close(oDlgMemo)
	  Return
   EndIf
   If !MSGBOX("Confirma a gravacao dos dados acima (S/N)?","Atencao","YESNO")
	  Return
   EndIf
   _nTamanho := Int(Len(AllTrim(_cTexto))/200)  // Numero de linhas a ser gravado.
   If Len(AllTrim(_cTexto))>0
	  dbSelectArea("SZA")
	  j := 0
	  If dbSeek(xFilial("SZA")+SA1->A1_COD+SA1->A1_LOJA)
//		If dbSeek(SA1->A1_COD+SA1->A1_LOJA)
		 Do While SZA->ZA_X_CODIG == SA1->A1_COD .AND. SZA->ZA_X_LOJA == SA1->A1_LOJA
			_cSubTexto := Substr(_cTexto,(j*200),200)
			RecLock("SZA",.F.)
			If j <= _nTamanho
			   SZA->ZA_X_CODIG := SA1->A1_COD
			   SZA->ZA_X_LOJA  := SA1->A1_LOJA
			   SZA->ZA_X_TEXTO := _cSubTexto
			   SZA->ZA_X_USUAR := Substr(cUSUARIO,7,14)
			   SZA->ZA_X_DATA  := Date()
			   SZA->ZA_X_HORA  := Substr(Time(),1,5)
			Else
			   Delete
			EndIf
			MsUnlock()
			dbSkip()
			j := j + 1
		 EndDo
	  EndIf
	  If j <= _nTamanho
		 For  i:=j to _nTamanho
			 _cSubTexto := Substr(_cTexto,(i*200),200)
			 RecLock("SZA",.T.)
			 SZA->ZA_X_CODIG := SA1->A1_COD
			 SZA->ZA_X_LOJA  := SA1->A1_LOJA
			 SZA->ZA_X_TEXTO := _cSubTexto
			 SZA->ZA_X_USUAR := Substr(cUSUARIO,7,14)
			 SZA->ZA_X_DATA  := Date()
			 SZA->ZA_X_HORA  := Substr(Time(),1,5)
			 MsUnlock()
		 Next
	  EndIf
   EndIf
   dbSelectArea("SA1")
   Close(oDlgMemo)
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÂÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ FRSAIR   º Autor ³ Luciano Lorenzetti º Data ³Thu  08/02/00º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Rotina para abandonar a  tela de digitacao.                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Espec¡fico para clientes Microsiga                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function FRSair
Static Function FRSair()
   If _cTextoOrig == _cTexto
	  Close(oDlgMemo)
   Else
	  If MSGBOX("Deseja realmente abandonar as alteracoes executadas (S/N)?","Atencao","YESNO")
		 Close(oDlgMemo)
	  EndIf
   EndIf
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ FRIMPR   º Autor ³ Luciano Lorenzetti º Data ³Thu  08/02/00º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Rotina para salvar o conteudo da variavel cTEXTO no arquivoº±±
±±º          ³ SZA.                                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Espec¡fico para clientes Microsiga                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function FRIMPR
Static Function FRIMPR()
   If Len(AllTrim(_cTexto))==0
	  MSGBOX("Nao ha conteudo a ser impresso !!!")
	  Return
   EndIf
   cString:="SZA"
   nTipo        := 0
   cRodaTxt := "REGISTRO(S)"
   nCntImpr := 0
   cDesc1:= OemToAnsi("Este programa tem como objetivo, imprimir as informacoes  ")
   cDesc2:= OemToAnsi("do cliente.      ")
   cDesc3:= ""
   tamanho:="P"
   aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
   nomeprog:="CTATCL"
   aLinha  := { }
   nLastKey := 0

   li := 80
   titulo          :="Informacoes de Cliente"
   cabec1          :="Informacoes do Cliente : "+ SA1->A1_COD  + " - " +SA1->A1_NOME
   cabec2          :=""
   cCancel := "***** CANCELADO PELO OPERADOR *****"

   m_pag := 0  //Variavel que acumula numero da pagina

   wnrel:="CTATCL"            //Nome Default do relatorio em Disco
   SetPrint(cString,wnrel,,titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho)

   If nLastKey == 27
	   Set Filter To
	   Return
   Endif

   SetDefault(aReturn,cString)

   If nLastKey == 27
	   Set Filter To
	   Return
   Endif

   RptStatus({|| RptDetail() })// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>    RptStatus({|| Execute(RptDetail) })
   Return
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RptDetail ³ Autor ³ Ary Medeiros          ³ Data ³ 15.02.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Impressao do corpo do relatorio                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function RptDetail
Static Function RptDetail()
_cTxt    := AllTrim(_cTexto)
_nTamTot := Len(AllTrim(_cTxt))  // Numero de linhas a ser gravado.
SetRegua(_nTamTot + 1)                     //Ajusta numero de elementos da regua de relatorios
_nPos := 0
_nCol := 0
m_pag := 1
Do While _nPos <= _nTamTot
	If lEnd
		Exit
	Endif
	If li > 54
	   cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
	EndIf
	//Para impressao utiliza-se o comando PSAY
	Do While .T.
	   If Substr(_cTxt,1,2) == CHR(13)+CHR(10)       // verifica se foi gravado caracter
		  _nCol   := 0                                                   // de quebra de linha.
		  _nPos   := _nPos + 2
		  _cTxt := Substr(_cTxt,3,_nTamTot - _nPos)
		  _nPos := 0
		  Exit
	   EndIf
	   @ Li,_nCol PSAY Substr(_cTxt,1,1)
	   _cTxt := Substr(_cTxt,2,_nTamTot - _nPos)
	   _nPos := _nPos + 1
	   IncRegua()                              //Incrementa a posicao da regua de relatorios
	   If len(_cTxt) == 0
		  _nPos := _nTamTot + 10
		  Exit
	   EndIf
	   //If _nPos > _nTamTot
	   //   Exit
	   //EndIf
	   If _nPos > 79
		  _nPos := 0
		  Exit
	   EndIf
	EndDo
	li := li + 1
EndDo
li := li + 1
If li > 54
   cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
EndIf
@ Li,0 PSAY "Ultima atualizacao em "+Dtoc(SZA->ZA_X_DATA) +" as "+SZA->ZA_X_HORA+"h."
IF li != 80
	Roda(nCntImpr,cRodaTxt,Tamanho)
EndIF
Set Filter To
If aReturn[5] == 1
   Set Printer To
   Commit
   Ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool
Return



