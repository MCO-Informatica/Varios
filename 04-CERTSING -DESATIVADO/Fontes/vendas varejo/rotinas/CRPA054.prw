#include "totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CRPA054  º Autor ³ RENATO RUY BERNARDO  º Data ³ 05/07/18  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Vincula Entidade x Fornecedor								    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CRPA054() 
    Local aaCampos  	:= {"Z3_CODFOR"} //Variável contendo o campo editável no Grid
    Local aBotoes	:= {}         //Variável onde será incluido o botão para a legenda
    Local oSay1, oSay2
    Local oFont := TFont():New('Courier new',,-12,.T.)
    Private cCombo1, cCombo2
    Private cGet1 	:= SZ3->Z3_CODENT
    Private cGet2 	:= SZ3->Z3_DESENT
    Private oGet1, oGet2
    Private oTGet1, oTGet2
    Private oLista                    //Declarando o objeto do browser
    Private aCabecalho  := {}         //Variavel que montará o aHeader do grid
    Private aColsEx 	:= {}         //Variável que receberá os dados
 
    DEFINE MSDIALOG oDlg TITLE "VINCULO ENTIDADE X FORNECEDORES" FROM 000, 000  TO 400, 700  PIXEL
        
		oSay1	:= TSay():New( 35,01,{||'Entidade'},oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
		oTGet1 	:= TGet():New( 45,01,{||cGet1},oDlg,050,,'@!',{|| .T. },,,,.F.,,.T.,,.F.,{|| .F.},.F.,.F., ,.F.,.F.,,"cGet1",,,,)
		
		oSay2	:= TSay():New( 35,60,{||'Descrição'},oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
       oTGet2 	:= TGet():New( 45,60,{||cGet2},oDlg,180,,'@!',{|| .T. },,,,.F.,,.T.,,.F.,{|| .F.},.F.,.F., ,.F.,.F.,,"cGet2",,,,)
        
		//chamar a função que cria a estrutura do aHeader
       CriaCabec()
 
        //Monta o browser com inclusão, remoção e atualização
        oLista := MsNewGetDados():New( 085, 001, 200, 352, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "AllwaysTrue", aACampos,, 100, "AllwaysTrue", "", "AllwaysTrue", oDlg, aCabecalho, aColsEx)
 
        //Carregar os itens que irão compor o conteudo do grid
        Carregar()
 
        //Alinho o grid para ocupar todo o meu formulário
        //oLista:oBrowse:Align := CONTROL_ALIGN_BOTTOM
 
        //Ao abrir a janela o cursor está posicionado no meu objadeto
        oLista:oBrowse:SetFocus()
        
        //Crio o menu que irá aparece no botão Ações relacionadas
        //aadd(aBotoes,{"NG_ICO_LEGENDA", {||Legenda()},"Legenda","Legenda"})
 
        EnchoiceBar(oDlg, {|| CRPA054U() }, {|| oDlg:End() },,aBotoes)
 
    ACTIVATE MSDIALOG oDlg CENTERED
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CriaCabecº Autor ³ RENATO RUY BERNARDO  º Data ³ 05/07/18  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Montar array com os dados do cabecalho.				      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CriaCabec()
    

	Aadd(aCabecalho, {;
	                  "Fornecedores"	,;	//X3Titulo()
	                  "Z3_CODFOR"		,;	//X3_CAMPO
	                  "@!"				,;	//X3_PICTURE
	                  8					,;	//X3_TAMANHO
	                  0					,;	//X3_DECIMAL
	                  "U_CRPA054V()"	,;	//X3_VALID
	                  "€€€€€€€€€€€€€€ ",;	//X3_USADO
	                  "C"				,;	//X3_TIPO
	                  "SA2PAR"			,;	//X3_F3
	                  "R"				,;	//X3_CONTEXT
	                  ""					,;	//X3_CBOX
	                  ""					,;	//X3_RELACAO
	                  "Empty(M->Z3_CODFOR)"})	//X3_WHEN 
	 
	 AADD(aCabecalho,{;
	 					"Descricao"		,;	//X3Titulo()
						"A2_NOME"			,;	//X3_CAMPO
						""					,;	//X3_PICTURE
						50					,;	//X3_TAMANHO
						0					,;	//X3_DECIMAL
						""					,;	//X3_VALID
						"€€€€€€€€€€€€€€"	,;	//X3_USADO
						"C"					,;	//X3_TIPO
						"SZ3"				,;	//X3_F3
						"V"					,;	//X3_CONTEXT
		              ""					,;	//X3_CBOX
		              ""					,;	//X3_RELACAO
		              ""					})	//X3_WHEN 
	 
	 AADD(aCabecalho,{;
	 					"CNPJ"		,;	//X3Titulo()
						"A2_CGC"			,;	//X3_CAMPO
						""					,;	//X3_PICTURE
						15					,;	//X3_TAMANHO
						0					,;	//X3_DECIMAL
						""					,;	//X3_VALID
						"€€€€€€€€€€€€€€"	,;	//X3_USADO
						"C"					,;	//X3_TIPO
						"SZ3"				,;	//X3_F3
						"V"					,;	//X3_CONTEXT
		              ""					,;	//X3_CBOX
		              ""					,;	//X3_RELACAO
		              ""					})	//X3_WHEN 
	 
	 AADD(aCabecalho,{;
	 					"RECNO"		,;	//X3Titulo()
						"RECNO"			,;	//X3_CAMPO
						""					,;	//X3_PICTURE
						15					,;	//X3_TAMANHO
						0					,;	//X3_DECIMAL
						""					,;	//X3_VALID
						"€€€€€€€€€€€€€€"	,;	//X3_USADO
						"N"					,;	//X3_TIPO
						"SZ3"				,;	//X3_F3
						"V"					,;	//X3_CONTEXT
		              ""					,;	//X3_CBOX
		              ""					,;	//X3_RELACAO
		              ""					})	//X3_WHEN 
	                  	                  
 
Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Carregar º Autor ³ RENATO RUY BERNARDO  º Data ³ 05/07/18  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Montar acols com os dados padrao ou da base de dados.      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Carregar()
    Local aProdutos := {}
    
    AC9->(DbSetOrder(2)) //AC9_FILIAL, AC9_ENTIDA, AC9_FILENT, AC9_CODENT
	If AC9->(DbSeek(xFilial("AC9")+"SZ3"+xFilial("SZ3")+SZ3->Z3_CODENT))
		aColsEx := {}
		SA2->(DbSetOrder(1))
		While !AC9->(EOF()) .And. AllTrim(SZ3->Z3_CODENT) = AllTrim(AC9->AC9_CODENT)
			If SA2->(DbSeek(xFilial("SA2")+SubStr(AC9->AC9_CODOBJ,1,8)))
				aadd(aColsEx,{SubStr(AC9->AC9_CODOBJ,1,8),SA2->A2_NOME,SA2->A2_CGC,AC9->(Recno()),.F.})
			Endif
			AC9->(DbSkip())
		Enddo
		//Se se encontrou, mas não e um fornecedor, adiciona a primeira linha
		If Len(aColsEx) == 0
			aadd(aColsEx,{Space(8),Space(50),Space(15),0,.F.})
		Endif
	Else
		aadd(aColsEx,{Space(8),Space(50),Space(15),0,.F.})
	Endif
	
    //Setar array do aCols do Objeto.
    oLista:SetArray(aColsEx,.T.)

    //Atualizo as informações no grid
    oLista:Refresh()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CRPA054U º Autor ³ RENATO RUY BERNARDO  º Data ³ 05/07/18  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Efetua gravacao dos dados de controle de faixas.		      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CRPA054U()

nCodFor:= Ascan( oLista:aHeader, { |x| AllTrim(x[2])=="Z3_CODFOR"	} )
nRecno := Ascan( oLista:aHeader, { |x| AllTrim(x[2])=="RECNO" 		} )

For nZ := 1 To Len(oLista:aCols)
	
	//Se a linha está marcada para exclusão, verifica se existe na base para apagar.
	If oLista:aCols[nZ,Len(oLista:aCols[nZ])] .And. oLista:aCols[nZ,nRecno] > 0
		AC9->(DbGoTo(oLista:aCols[nZ,nRecno]))
		RecLock("AC9",.F.)
			DbDelete()
		AC9->(MsUnlock())
	//Atualiza faixas existentes			
	Elseif !oLista:aCols[nZ,Len(oLista:aCols[nZ])] .And. oLista:aCols[nZ,nRecno] == 0 .And. !Empty(oLista:aCols[nZ,nCodFor])
		RecLock("AC9",.T.)
			AC9->AC9_FILIAL := xFilial("AC9")
			AC9->AC9_FILENT := xFilial("SZ3")
			AC9->AC9_ENTIDA := "SZ3"
			AC9->AC9_CODENT := cGet1
			AC9->AC9_CODOBJ := oLista:aCols[nZ,nCodFor]
		AC9->(MsUnlock())
	Endif
Next

oDlg:End()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CRPA054V º Autor ³ RENATO RUY BERNARDO  º Data ³ 05/07/18  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Efetua gravacao dos dados de controle de faixas.		      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CRPA054V()

Local lRet := .T.
Local nNomFor	:= Ascan( oLista:aHeader, { |x| AllTrim(x[2])=="A2_NOME"	} )
Local nCgc 	:= Ascan( oLista:aHeader, { |x| AllTrim(x[2])=="A2_CGC"		} )

//Filial + Codigo + Loja
SA2->(DbSetOrder(1))

If Ascan( oLista:aCols,{|x| x[1]==M->Z3_CODFOR } ) > 0
	lRet := .F.
	MsgInfo('Fornecedor já foi vinculado anteriormente!')
Endif

if SA2->(DbSeek(xFilial("SA2")+M->Z3_CODFOR))
	aCols[oLista:nAt,nNomFor]	:= SA2->A2_NOME
	aCols[oLista:nAt,nCgc]		:= SA2->A2_CGC
	
	//Atualizo as informações no grid
    oLista:Refresh()
Else
	lRet := .F.
	MsgInfo('Não existe cadastro para o fornecedor informado!')
Endif

Return lRet