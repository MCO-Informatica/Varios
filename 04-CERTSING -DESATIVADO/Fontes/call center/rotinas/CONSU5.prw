#include "Protheus.ch"
#include "Topconn.ch"
 
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//쿝enato Ruy - 25/07/2016				?
//쿎onsulta Especifica de Contato - AC8	?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
User Function CONSU5()
 
Local bRet := .F.
 
Private cCodigo    := cContato
 
bRet := FiltraSU5()
 
Return(bRet)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//쿝enato Ruy - 25/07/2016				?
//쿐fetuar filtro de Entidade x Contato	?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
 
Static Function FiltraSU5()
 
Local cQuery
Local oLstSB1 := nil
Private oDlgSU5 := nil
Private _bRet := .F.
Private aDadosSU5 := {}

cCodEnt += Iif(cOriEnt$"ACB|SA1|SUS","01","") 

If Select("TMPSU5") > 0
	DbSelectArea("TMPSU5")
	TMPSU5->(DbCloseArea())
EndIf
 
//Query de marca x produto x referencia
Beginsql Alias "TMPSU5"

	SELECT 	U5_CODCONT,	//C줰igo
			U5_CONTAT,	//Nome 
			U5_FUNCAO,	//Fun뇙o
			U5_FONE,	//Telefone
			U5_OBS 
	FROM AC8010 AC8
	JOIN SU5010 SU5 ON U5_FILIAL = ' ' AND U5_CODCONT = AC8_CODCON AND SU5.D_E_L_E_T_ = ' '
	WHERE
	AC8_FILIAL = ' ' AND
	AC8_ENTIDA = %Exp:cOriEnt% AND
	AC8_CODENT = %Exp:cCodEnt% AND
	AC8.D_E_L_E_T_ = ' '
	ORDER BY U5_CONTAT

Endsql

cCodEnt := SubStr(cCodEnt,1,6)

TMPSU5->(DbGoTop())
If TMPSU5->(Eof())
	Aviso( "Entidade x Contato", "N?o existe dados para a consulta", {"Ok"} )
	Return .F.
Endif
 
Do While TMPSU5->(!Eof())
 
	aAdd( aDadosSU5, {	TMPSU5->U5_CODCONT,;
						TMPSU5->U5_CONTAT,;
						Posicione("SUM",1,xFilial("SUM")+TMPSU5->U5_FUNCAO,"UM_DESC"),;
						TMPSU5->U5_FONE,;
						TMPSU5->U5_OBS} )
	 
	TMPSU5->(DbSkip())
 
Enddo
 
TMPSU5->(DbCloseArea())
 
nList := aScan(aDadosSU5, {|x| alltrim(x[1]) == alltrim(cContato)})
 
iif(nList = 0,nList := 1,nList)
 
//--Montagem da Tela
Define MsDialog oDlgSU5 Title "Entidade x Contato" From 0,0 To 280, 500 Of oMainWnd Pixel
 
@ 5,5 LISTBOX oLstSU5 ;
VAR lVarMat ;
Fields HEADER "C?digo","Nome Contato";
SIZE 245,110 On DblClick ( ConfSU5(oLstSU5:nAt, @aDadosSU5, @_bRet) ) ;
OF oDlgSU5 PIXEL
 
oLstSU5:SetArray(aDadosSU5)
oLstSU5:nAt := nList
oLstSU5:bLine := { || {	aDadosSU5[oLstSU5:nAt,1],;
						aDadosSU5[oLstSU5:nAt,2],;
						aDadosSU5[oLstSU5:nAt,3],;
						aDadosSU5[oLstSU5:nAt,4],;
						aDadosSU5[oLstSU5:nAt,5]}}
 
DEFINE SBUTTON FROM 122,5 TYPE 1 ACTION ConfSU5(oLstSU5:nAt, @aDadosSU5, @_bRet) ENABLE OF oDlgSU5
DEFINE SBUTTON FROM 122,40 TYPE 2 ACTION oDlgSU5:End() ENABLE OF oDlgSU5 
//Editar o contato
DEFINE SBUTTON FROM 122,75 TYPE 11	ENABLE OF oDlgSU5 ACTION TkAltCt(@oLstSU5,1,@aDadosSU5,cCodEnt,"01",If(cOriEnt=="SUS",.T.,.F.))
 
Activate MSDialog oDlgSU5 Centered 

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//쿝enato Ruy - 25/07/2016				?
//쿝etorna dados da consulta			?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
 
Return _bRet
 
Static Function ConfSU5(_nPos, aDadosSU5, _bRet)
 
cCodigo := aDadosSU5[_nPos,1]
cDesCont:= aDadosSU5[_nPos,2]
                   
cContato := cCodigo
 
_bRet := .T.

oData2:cText := aDadosSU5[_nPos,2]
 
oDlgSU5:End()
 
Return

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿑un뇙o	 쿟kAltCt	? Autor ? Vendas Clientes  		? Data ?12/03/04  낢?
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿏escri뇙o 쿐xecuta a rotina de Altera놹o de contatos                   낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿢so		 쿎ALL CENTER                                                 낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
/*/
Static Function TkAltCt(oLstSU5	, nPos	, aCont	, cCliente	,;
						cLoja, lProspect )

Local aArea		  := GetArea()						// Salva a area atual
Local cCod	      := ""								// Codigo do contato	
Local cDFuncao    := ""								// Cargo do contato
Local cAlias	  := If(lProspect,"SUS","SA1")		// Alias 
Local nOpcA       := 0								// Opcao de retorno OK ou CANCELA
Local lRet		  := .T.							// Retorno da funcao
Local lTkFilCont  := ExistBlock("TKFILCONT")		//Ponto de entrada para filtrar os contatos
Local lFilSU5	  := .T.
	
DEFAULT lProspect := .F.

Private cCadastro := "Altera뇙o de Contatos"		//Private para compatibilizacao com a funcao AXaltera
Private lRefresh  := .T.

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? A ocorrencia 82 (ACS), verifica se o usu쟲io poder? ou n꼘 alterar cadastros ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
If !ChkPsw(82)
	HELP(" ",1,"TMKACECAD")
	lRet := .F.	
	Return(lRet)
Endif

cCod := Eval(oLstSU5:bLine)[nPos]

DbSelectArea("SU5")
DbSetOrder(1)
If DbSeek(xFilial("SU5")+ cCod)

	BEGIN TRANSACTION

		If lRet
			nOpcA:=A70ALTERA("SU5",RECNO(),4)
		Endif

	END TRANSACTION

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
	//쿞e houve altera놹o do registro atualizo o listbox de contatos?
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
	If nOpcA == 1
		lRet  := .T.
		aCont := {}
		DbSelectArea("AC8")
		DbSetOrder(2)
		If DbSeek(xFilial("AC8") + cAlias + xFilial(cAlias) + cCliente + cLoja,.T.)
			While (!Eof()) 							  	.AND.;
				  (AC8->AC8_FILIAL == xFilial("AC8")) 	.AND.;
				  (AC8->AC8_ENTIDA == cAlias) 		  	.AND.;
				  (AC8->AC8_FILENT == xFilial(cAlias))	.AND.;
				  (AllTrim(AC8->AC8_CODENT) == AllTrim(cCliente + cLoja))
		
				DbSelectArea("SU5")
				DbSetOrder(1)
				If DbSeek(xFilial("SU5") + AC8->AC8_CODCON)
					If lTkFilCont
						lFilSU5 := ExecBlock("TKFILCONT",.F.,.F.)	
					EndIf
	                
					If lFilSU5
						cDFuncao := Posicione("SUM",1,xFilial("SUM")+SU5->U5_FUNCAO,"UM_DESC")
						Aadd(aCont,{SU5->U5_CODCONT,;		//C줰igo
									SU5->U5_CONTAT,;		//Nome 
									cDFuncao,;				//Fun뇙o
									SU5->U5_FONE,;			//Telefone
									SU5->U5_OBS} )			//Observacao
					EndIf
				Else
					Aadd(aCont,{"","","","",""})
				Endif
		
				DbSelectArea("AC8")
				DbSkip()
			End
		Endif	
		
		oLstSU5:SetArray(aCont)
		oLstSU5:bLine:={||{aCont[oLstSU5:nAt,1],;  //C줰igo
						aCont[oLstSU5:nAt,2],;  //Nome 
						aCont[oLstSU5:nAt,3],;	 //Fun뇙o
						aCont[oLstSU5:nAt,4],;	 //Telefone
						aCont[oLstSU5:nAt,5] }} //Observacao
		oLstSU5:Refresh()

	Endif
Endif

RestArea(aArea)

Return(lRet) 
