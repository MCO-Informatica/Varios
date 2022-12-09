
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ RCRMC002 ³ Autor ³ Derik Santos        ³ Data ³ 30/12/2016 ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de cadastro de Call Report       .                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico para a empresa Prozyn               			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RCRMC004()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local _cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local _cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.
Local aRotAdic := {}
Local aButtons := {}//adiciona botões na tela de inclusão, alteração, visualização e exclusao
Local cVldAlt := ".T."  //validacao para permitir a alteracao. Pode-se utilizar execblock
Local cVldExc := ".T."  //validacao para permitir a exclusao. Pode-se utilizar execblock

Private cAlias := "SZL"

dbSelectArea(cAlias)
dbSetOrder(1) //Filial + Código

aadd(aRotAdic,{ "Imprimir","U_Adic", 0 , 6 })
aadd(aRotAdic,{ "Enviar","U_Tela", 0 , 6 })

AxCadastro(cAlias,"Call Report", cVldExc,cVldAlt, aRotAdic, , , , , , , aButtons, , )
     
Return()                                                        

User Function Adic()   
	U_RCRMR003()
Return             

User Function Tela()

Local _cConteudo := ""
Static oDlg5

U_RCRME018(_cConteudo)

Close(oDlg5)

Return

User Function Envia()

Local _cMsg   := ""   
Local _cEnter := CHR(13) + CHR(10)  
Static oDlg5

_cCliente := Alltrim(Posicione("SA1",1,xFilial("SA1") + SZL->ZL_CODCLI + SZL->ZL_LOJA ,"A1_NREDUZ"))

_cMail:=_cConteudo
_cTitulo:= "Call Report " + _cCliente
_cMsg += "CALL REPORT " + _cCliente 		+ _cEnter
_cMsg += 									 _cEnter
_cMsg += "Data: " 							+ _cEnter
_cMsg += DtoC(Date())					    + _cEnter
_cMsg += 									  _cEnter
_cMsg += "Participantes: " 					+ _cEnter
_cMsg += ALLTRIM(M->ZL_PART)					+ _cEnter
_cMsg += 									  _cEnter
_cMsg += "Status: " 						+ _cEnter
_cMsg += ALLTRIM(M->ZL_STATUS) 						+ _cEnter
_cMsg += 									  _cEnter
_cMsg += "Maiores Oportunidades na conta: " + _cEnter
_cMsg += ALLTRIM(M->ZL_OPORT) 						+ _cEnter
_cMsg += 									  _cEnter
_cMsg += "Objetivos: " 						+ _cEnter
_cMsg += ALLTRIM(M->ZL_OBJETI) 						+ _cEnter
_cMsg += 									  _cEnter
_cMsg += "Resultados: " 					+ _cEnter
_cMsg += ALLTRIM(M->ZL_RESULT) 						+ _cEnter
_cMsg += 									  _cEnter
_cMsg += "Próximos Passos: " 				+ _cEnter
_cMsg += ALLTRIM(M->ZL_PASSOS) 						+ _cEnter

cDirUsr  := GetTempPath()
lCompacta := .T.
//_cPaTh :=StrTran(_cPaTh,".rel",".pdf")
//CpyT2S(cDirUsr+_cPaTh,"\spool\",lCompacta)
_cAnexo :=""
if _cMail = " "
	Return
else
	U_RCFGM001(_cTitulo,_cMsg,_cMail,_cAnexo) 
endif

Close(oDlg5)

Return                       