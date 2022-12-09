#Include 'Protheus.CH'
#INCLUDE "rwmake.ch"
#include "topconn.ch"   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CADP006   ºAutor  ³aALEBAS			 º Data ³  26/06/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³CRIA TELA DE MANUTENÇÃO DA POLITICA DE PREÇO LASELVA.	      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Laselva                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CADP006()

Local oDlg
Local oCodPro, oDescPro
Local cCodPro	:= Space(15)
Local cDescPro	:= Space(45) 

Private oBtn1, oBtn2, oBtn3
Private aItens := {}
Private aCabec := {}
Private oBrowse

//Faz Cabeçalho do Grid
AAdd( aCabec, 'CodEstab' )
AAdd( aCabec, 'DescrEstab' )
AAdd( aCabec, 'CodPro' )
AAdd( aCabec, 'Descricao' )
AAdd( aCabec, 'Preco' )      
AAdd( aCabec, 'Novo Preco' )

//--Cria linha de itens vazia
aItens := Array( 1, Len( aCabec ) ) 

Define MSDialog oDlg Title 'Consulta e alteração de Preços' From 000, 000 To 500,650 Pixel

	//--PRIMEIRO BOX (FRAME)
	 TGroup():New( 015, 005, 055, 320, 'Editar Politica de Preço', oDlg, CLR_BLUE,, .T. )            
	@ 025, 010 Say 'Código do Produto:' Pixel Of oDlg
	@ 035, 010 MsGet oCodPro  ;
	           Var cCodPro Picture "@!" ;
	           F3 'SB1' ;
	           Size 70, 10 ;
			   Valid Empty( cCodPro ) .Or. VldPro( cCodPro, @cDescPro );      
	           Pixel Of oDlg

	@ 025, 085 Say 'Descrição: ' Pixel Of oDlg
	@ 035, 085 MsGet oDescPro ;
	           Var cDescPro Picture "@!" ;
			   When .F. ;
			   Size 150, 10 ;
	           Pixel Of oDlg

	

	//--BOTAO DE ACAO             
	oBtn1 := TButton():New( 030, 245, 'Consulta Produto', oDlg,;
									  {|| MsgRun( 'Obtendo dados, por favor aguarde...',, {||retornaArray (cCodPro)} ) },;   
									070,15,,,,.T. )
    
	//--SEGUNDO BOX (FRAME)
	TGroup():New( 060, 005, 230, 320, 'Preço nas Filiais', oDlg, CLR_BLUE,, .T. )

	//--Definicao e Criacao do Grid (BROWSE)
	oBrowse := TWBrowse():New( 	070, 010, 305, 135,, aCabec,, oDlg,,,,, {||},,,,,,, .F.,, .T.,, .F.,,, )
    

	
	//--Duplo clique no grid , chama janela para alteração de preços
	oBrowse:bLDblClick := {|| EditBrowse( oBrowse:nAT ) }
	
	
	//==Clique com o botão direito INSERE a linha no grid apenas se grid estiver preenchido
	
	oBrowse:brClicked := {|| criaBrowse( cCodPro )}   // 
	
	oBrowse:SetArray( aItens )  
	
	//Escreve no Browse
	oBrowse:bLine := {|| {aItens[ oBrowse:nAT, 01 ], aItens[ oBrowse:nAT, 02 ], aItens[ oBrowse:nAT, 03 ], aItens[ oBrowse:nAT, 04 ],aItens[ oBrowse:nAT, 05 ],aItens[ oBrowse:nAT, 06 ]} }
	oBrowse:Refresh()
				
	//--Grava os dados modificados no GRID
	oBtn2 := TButton():New(	210, 170, 'Confirmar', oDlg,;
									{|| MsgRun( 'Gravando Dados, por favor aguarde...',, {|| ConfBrowse(1)} ) },; 
									070, 015,,,,.T. )
		
	//--Cancela os Dados Modificados no Grid
	oBtn3 := TButton():New(	210, 245, 'Cancelar', oDlg,;
										{|| MsgRun( 'Cancelando as Modificações, por favor aguarde...',, {|| ConfBrowse(2,cCodPro)} ) },;
									070, 015,,,,.T. )

	//--DESABILITA O BOTAO DE ACAO
	oBtn2:Disable()
	oBtn3:Disable()

Activate MSDialog oDlg Center On Init EnchoiceBar( oDlg, {|| oDlg:End()}, {|| oDlg:End()} )

Return 


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³	VldPro   ³ Autor ³Alebas    		    ³ Data ³ 26.Jun.08³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Valida digitacao do Produto na tela resumida 				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function VldPro( cCodPro, cDescPro)

Local lRet     := .T.
Local aAreaSB1 := SB1->( GetArea() )

SB1->( DbSetOrder(1) )
If SB1->( DbSeek( xFilial('SB1') + cCodPro ) )
	cDescPro := SB1->B1_DESC
	lRet := .T.
Else
	Help( ' ',1,'REGNOIS' )
	lRet := .F.
EndIf

RestArea( aAreaSB1 )

Return( lRet )  

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³	Retorna Array³ Autor ³Alebas    		³ Data ³ 27.Jun.08³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Retornas o Array contendo a Tabela DA1010 				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

static Function retornaArray (cCodPro)

Local nCount	:= 0  
Local cQuery	:= " "

  	aItens = {}	

	cQuery    += "SELECT A.DA1_CODTAB,C.DA0_DESCRI,A.DA1_CODPRO,B.B1_DESC,A.DA1_PRCVEN " 
	cQuery    += "FROM DA1010 A "
	cQuery    += "INNER JOIN DA0010 C ON C.DA0_CODTAB=A.DA1_CODTAB "
	cQuery    += "INNER JOIN  SB1010 B ON A.DA1_CODPRO=B.B1_COD "
	cQuery    += "WHERE A.DA1_CODPRO='" + ALLTRIM(cCodPro) +"' AND A.D_E_L_E_T_<>'*' AND C.D_E_L_E_T_<>'*' "
	
	memowrite("DA1LAS.SQL",cQuery)
	
	// Executa a query principal
	TcQuery cQuery NEW ALIAS "QRY1"
	
	// Conta os registros da Query
	TcQuery "SELECT COUNT(*) AS TOTALREG FROM (" + cQuery + ") AS T" NEW ALIAS "QRYCONT"
	QRYCONT->(dbgotop())
	nReg := QRYCONT->TOTALREG
	QRYCONT->(dbclosearea())
	
	If nReg > 0
		While QRY1->(!Eof())

			 	AAdd( aItens, { QRY1->DA1_CODTAB ,;
			 					QRY1->DA0_DESCRI ,;
					 			QRY1->DA1_CODPRO ,;
								QRY1->B1_DESC    ,;
				   				QRY1->DA1_PRCVEN ,;
				   				QRY1->DA1_PRCVEN } )
	
               QRY1->(dbskip())
               
		EndDo
    EndIf
    QRY1->(dbclosearea())  
    
    oBrowse:SetArray( aItens )
    oBrowse:bLine := {|| {aItens[ oBrowse:nAT, 01 ], aItens[ oBrowse:nAT, 02 ], aItens[ oBrowse:nAT, 03 ], aItens[ oBrowse:nAT, 04 ],aItens[ oBrowse:nAT, 05 ],aItens[ oBrowse:nAT, 06 ]} }
	oBrowse:Refresh()      

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³EditBrowse  ³Autor  ³Alebas               ³Data  ³ 30-Jun-08³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Edita uma coluna especifica do Grid                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function EditBrowse( nLin )
Local oDlg, oFont
Local oGetNewNec 
Local nOpcA   := 0
Local nPos    := 0

Local nAtuPrec := aItens[nLin,5]
Local nNewPrec := aItens[nLin,6]

//--Monta tela para edicao de Preço
Define MSDialog oDlg Title 'Editar Preço' From 000, 000 To 190, 450 Pixel

	oFont := TFont():New( 'Arial',, -12,, .T. )
	
	TGroup():New( 005, 005, 035, 220, ' Produto no Estabelecimento ', oDlg, CLR_BLUE,, .T. )
	TSay():New( 018, 010, {|| AllTrim( aItens[nLin, 2] ) + "   " + AllTrim( aItens[nLin, 3] ) + ' - ' + aItens[nLin,4]}, oDlg,, oFont,,,, .T., CLR_RED, CLR_WHITE, 200, 20 )


	TGroup():New( 040, 072, 070, 146, ' Preço Atual ', oDlg, CLR_BLUE,, .T. )
	TGet():New( 050, 077, {|| nAtuPrec}, oDlg, 50, 05, '99999', {|| },,,oFont,,,.T.,,,{|| .F.}) 

	TGroup():New( 040, 148, 070, 220, ' Novo Preço ', oDlg, CLR_BLUE,, .T. )
	ToGetNewNec := TGet():New( 050, 153, {|x| If( PCount() > 0, nNewPrec := x, nNewPrec )}, oDlg, 50, 05, '99999', {|| nNewPrec >=0 },,,oFont,,,.T.,,,{|| .T.}) 

	TButton():New( 075, 075, 'Confirmar', oDlg, {|| nOpcA := 1, oDlg:End() }, 070, 015,,,,.T. )
	TButton():New( 075, 150, 'Cancelar' , oDlg, {|| nOpcA := 0, oDlg:End() }, 070, 015,,,,.T. )

Activate MSDialog oDlg Centered

//--Efetiva a alteracao no Grid
If nOpcA == 1
	aItens[nLin,6] := nNewPrec  	
Else
	aItens[nLin,6] := nAtuPrec 	  
Endif  

//atualiza Botões
oBtn2:Enable()
oBtn3:Enable()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ConfBrowse   Autor  ³Alebas               ³Data  ³ 01-Jul-08³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Conclui Alterações                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ConfBrowse(nOpcao,cCodPro)  

Local cUpd	:= " " 
Local nCount

If nOpcao == 1

	For nCount := 1 To Len( aItens )
		If aItens[nCount,5] <> aItens[nCount,6] 
		
			cUpd	+= " UPDATE " + RetSQLName("DA1")
   			cUpd	+= " SET DA1_PRCVEN=" + str(aItens[nCount,6],12)
   			cUpd	+= " WHERE D_E_L_E_T_ = ' ' AND "
  			cUpd	+= " DA1_FILIAL  = '"	+ xFilial("DA1") + "' AND "
   			cUpd	+= " DA1_CODTAB    = '" + aItens[nCount,1] + "' AND"	
			cUpd	+= " DA1_CODPRO   = '" + aItens[nCount,3] + "'"    
			
			TcSQLExec(cUpd)
			
			//Atualiza Botões
   			oBtn2:Disable()
   			oBtn3:Disable()
					
		EndIf
	Next	

	retornaArray (cCodPro)
	oBrowse:Refresh()  
		
else
	//Retorna o Grid sem as alterações
	retornaArray (cCodPro)	

    //Atualiza Botões
	oBtn2:Disable()
	oBtn3:Disable()

EndIf
	 
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³EditBrowse  ³Autor  ³Alebas               ³Data  ³ 30-Jun-08³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Cria linha no Grid                         				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function criaBrowse(cCodPro )

Local oDlg, oFont   
Local oGetNewcodtab
Local oGetNewline
Local nOpcA      	:= 0
Local nPos		 	:= 0
Local nNewCodTab 	:= "  "
Local nNewPrec 	 	:= 0
Local nCodtab	 	:= .F.
Local cQuery2		:= " "  
Local aItems2:={}
Local oCombo
Local cCombo

DbSelectArea("SM0")
DbSetOrder(0)
DbGoTop()

While SM0->(!Eof())
 		Aadd(aItems2, SM0->M0_CODFIL + " - " + SM0->M0_FILIAL) 
      	SM0->(DbSkip())
enddo
 		
cCombo:= aItems2[1]

if cCodPro <> " "
	//--Monta tela para edicao de Preço
	Define MSDialog oDlg Title 'Inserir Preço' From 000, 000 To 190, 450 Pixel
		
		oFont := TFont():New( 'Arial',, -12,, .T. )
			
		TGroup():New( 005, 005, 035, 220, 'Produto ', oDlg, CLR_BLUE,, .T. )
		TSay():New( 018, 010, {|| cCodpro}, oDlg,, oFont,,,, .T., CLR_RED, CLR_WHITE, 200, 20 )
			
		TGroup():New( 040, 005, 070, 220, 'Descrição da Loja ', oDlg, CLR_BLUE,, .T. )
		oCombo:= tComboBox():New(050,008,{|u|if(PCount()>0,cCombo:=u,cCombo)},;
								aItems2,65,20,oDlg,,{|| nNewCodTab := left(cCombo,2) },;
								,,,.T.,,,,,,,,,"cCombo")
		
		TGroup():New( 040, 072, 070, 146, 'Codigo da Loja ', oDlg, CLR_BLUE,, .T. )
		TGet():New( 050, 077, {|x| If( PCount() > 0, nNewCodTab  := x, nNewCodTab  )}, oDlg, 50, 05, '@!', {|| },,,oFont,,,.T.,,,{|| .F.}) 

		TGroup():New( 040, 148, 070, 220, ' Novo Preço ', oDlg, CLR_BLUE,, .T. )
		ToGetNewLine := TGet():New( 050, 153, {|x| If( PCount() > 0, nNewPrec := x, nNewPrec )}, oDlg, 50, 05, '99999', {|| nNewPrec >=0 },,,oFont,,,.T.,,,{|| .T.}) 
		
		TButton():New( 075, 075, 'Confirmar', oDlg, {|| nOpcA := 1, oDlg:End() }, 070, 015,,,,.T. )
		TButton():New( 075, 150, 'Cancelar' , oDlg, {|| nOpcA := 0, oDlg:End() }, 070, 015,,,,.T. )
		
	Activate MSDialog oDlg Centered
			
	// Verifica se o codigo da Tabela digitada Existe
	dbSelectArea("SM0")
	dbsetorder(1)
	If !dbSeek("01"+left(nNewCodTab,2))
		Msgstop("Codigo da Filial não existe" ,"Politica de Preço")
   	Else
		cQuery2    += "SELECT A.DA1_CODTAB,C.DA0_DESCRI,A.DA1_CODPRO,B.B1_DESC,A.DA1_PRCVEN " 
   		cQuery2    += "FROM DA1010 A "
   		cQuery2    += "INNER JOIN DA0010 C ON C.DA0_CODTAB=A.DA1_CODTAB "
   		cQuery2    += "INNER JOIN  SB1010 B ON A.DA1_CODPRO=B.B1_COD "
  		cQuery2    += "WHERE A.DA1_CODPRO='" + ALLTRIM(cCodPro) +"' " 
  		cQuery2    += "AND   A.DA1_CODTAB='" + ALLTRIM(left(nNewCodTab,2)) +"'  AND A.D_E_L_E_T_<>'*' AND C.D_E_L_E_T_<>'*'"
	   		
		memowrite("DA1LAS2.SQL",cQuery2)
					
		// Conta os registros da Query
		TcQuery "SELECT COUNT(*) AS TOTALREG FROM (" + cQuery2 + ") AS T" NEW ALIAS "QRYCONT2"
		QRYCONT2->(dbgotop())
		nReg := QRYCONT2->TOTALREG
		QRYCONT2->(dbclosearea())
	
   		If nReg > 0 
			Msgstop("Politica de Preço ja cadastrada para a filial " + nNewCodTab  ,"Politica de Preço")	   			  	
		Else		
			nCodtab := .T.					
		EndIf
			    
	Endif
				
	//--INSERE NO BD E ATUALIZA GRID
	If nOpcA == 1 .and. nCodtab == .T.
		RecLock("DA1",.T.)
		DA1->DA1_FILIAL := ""
		DA1->DA1_ITEM   := GETSXENUM("DA1","DA1_ITEM") 
		DA1->DA1_CODTAB := left(nNewCodTab,2)
		DA1->DA1_CODPRO := cCodPro 
		DA1->DA1_PRCVEN := nNewPrec
		MsUnlock()
				
		retornaArray (cCodPro)	       
		
	Else
		retornaArray (cCodPro)	  
	Endif  
		
	//atualiza Botões
	oBtn2:Disable()
	oBtn3:Disable()

Else
		MsgBox("Digite o Codigo do produto" ,"Politica de Preços","INFO")
		//atualiza Botões
	   	oBtn2:Disable()
	   	oBtn3:Disable()			
endif
		
Return    

Static Function Teste()

Local oDlg, oList, nList:= 1, aItems:={}

DEFINE MSDIALOG oDlg FROM 0,0 TO 400,400 PIXEL TITLE “Teste”
oList:= tListBox():New(10,10,{|u|if(Pcount()>0,nList:=u,nList)};
,aItems,100,100,,oDlg,,,,.T.)
ACTIVATE MSDIALOG oDlg CENTERED

Return 