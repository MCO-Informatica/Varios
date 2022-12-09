#include "totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CRPA038  º Autor ³ RENATO RUY BERNARDO  º Data ³ 21/06/17  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cadastro de FAIXAS									      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CRPA038() 
    Local aaCampos  	:= {"Z4_CATPROD","Z4_PORSOFT","Z4_PORHARD","Z4_QTDMIN","Z4_QTDMAX"} //Variável contendo o campo editável no Grid
    Local aBotoes	:= {}         //Variável onde será incluido o botão para a legenda
    Local oSay1, oSay2, oSay3, oSay4, oSay5, oSay6
    Local aItems	:= {'1=Sim','2=Não'}
    Local aItems2	:= {'1=Incentivo','2=Corporate','3=Reseller'}
    Local oFont := TFont():New('Courier new',,-12,.T.)
    Private cCombo1, cCombo2
    Private cGet1 	:= SZ3->Z3_CODENT
    Private cGet2 	:= SZ3->Z3_DESENT
    Private cGet4 	:= SZ3->Z3_PRODFX
    Private oGet1, oGet2, oGet4
    Private oLista                    //Declarando o objeto do browser
    Private aCabecalho  := {}         //Variavel que montará o aHeader do grid
    Private aColsEx 	:= {}         //Variável que receberá os dados
 
    DEFINE MSDIALOG oDlg TITLE "CADASTRO DE FAIXAS" FROM 000, 000  TO 400, 700  PIXEL
        
		oSay1	:= TSay():New( 35,01,{||'Entidade'},oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
		oTGet1 	:= TGet():New( 45,01,{||cGet1},oDlg,050,,'@!',{|| .T. },,,,.F.,,.T.,,.F.,{|| .F.},.F.,.F., ,.F.,.F.,,"cGet1",,,,)
		
		oSay2	:= TSay():New( 35,60,{||'Descrição'},oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
       oTGet2 	:= TGet():New( 45,60,{||cGet2},oDlg,180,,'@!',{|| .T. },,,,.F.,,.T.,,.F.,{|| .F.},.F.,.F., ,.F.,.F.,,"cGet2",,,,)
        
		oSay5	:= TSay():New( 60,01,{||'Controla Faixa'},oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
       cCombo1	:= aItems[1]
		oCombo1	:= TComboBox():New(70,01,{||SZ3->Z3_FAIXA},aItems,50,20,oDlg,,{||},,,,.T.,,,,,,,,,'Faixa')
		
		oSay6	:= TSay():New( 60,60,{||'Tipo'},oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
       cCombo2	:= aItems2[1]
		oCombo2	:= TComboBox():New(70,60,{||SZ3->Z3_FAIXA},aItems2,50,20,oDlg,,{||Carregar()},,,,.T.,,,,,,,,,'Faixa')
        
       oSay4	:= TSay():New( 95,01,{||'Produtos'},oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
       oTGet4 	:= TGet():New( 105,01,{|u| If(PCount() > 0,cGet4 := u,cGet4)},oDlg,240,,'@!',{|| .T. },,,,.F.,,.T.,,.F.,{|| .T.},.F.,.F., ,.F.,.F.,,"cGet4",,,,)
       
       //chamar a função que cria a estrutura do aHeader
       CriaCabec()
 
        //Monta o browser com inclusão, remoção e atualização
        oLista := MsNewGetDados():New( 125, 001, 200, 352, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "AllwaysTrue", aACampos,, 003, "AllwaysTrue", "", "AllwaysTrue", oDlg, aCabecalho, aColsEx)
 
        //Carregar os itens que irão compor o conteudo do grid
        Carregar()
 
        //Alinho o grid para ocupar todo o meu formulário
        //oLista:oBrowse:Align := CONTROL_ALIGN_BOTTOM
 
        //Ao abrir a janela o cursor está posicionado no meu objeto
        oLista:oBrowse:SetFocus()
        
        //Crio o menu que irá aparece no botão Ações relacionadas
        //aadd(aBotoes,{"NG_ICO_LEGENDA", {||Legenda()},"Legenda","Legenda"})
 
        EnchoiceBar(oDlg, {|| CRPA038U() }, {|| oDlg:End() },,aBotoes)
 
    ACTIVATE MSDIALOG oDlg CENTERED
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CriaCabecº Autor ³ RENATO RUY BERNARDO  º Data ³ 21/06/17  º±±
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
	                  "Faixa",;//X3Titulo()
	                  "Z4_CATPROD",;//X3_CAMPO
	                  "@!",;		//X3_PICTURE
	                  3,;			//X3_TAMANHO
	                  0,;			//X3_DECIMAL
	                  "",;			//X3_VALID
	                  "",;			//X3_USADO
	                  "C",;			//X3_TIPO
	                  "ZY",;		//X3_F3
	                  "R",;			//X3_CONTEXT
	                  "",;			//X3_CBOX
	                  "",;			//X3_RELACAO
	                  ""})			//X3_WHEN 
	                  
    Aadd(aCabecalho, {;
	                  "Desc.Faixa",;//X3Titulo()
	                  "Z4_CATDESC",;//X3_CAMPO
	                  "@!",;		//X3_PICTURE
	                  20,;			//X3_TAMANHO
	                  0,;			//X3_DECIMAL
	                  "",;			//X3_VALID
	                  "",;			//X3_USADO
	                  "C",;			//X3_TIPO
	                  "",; 			//X3_F3
	                  "R",;			//X3_CONTEXT
	                  "",;			//X3_CBOX
	                  "",;			//X3_RELACAO
	                  ""})			//X3_WHEN 
	
    Aadd(aCabecalho, {;
	                  "Per.Soft",;	//X3Titulo()
	                  "Z4_PORSOFT",;//X3_CAMPO
	                  "@E 99.99",;	//X3_PICTURE
	                  5,;			//X3_TAMANHO
	                  2,;			//X3_DECIMAL
	                  "",;			//X3_VALID
	                  "",;			//X3_USADO
	                  "N",;			//X3_TIPO
	                  "",;			//X3_F3
	                  "R",;			//X3_CONTEXT
	                  "",;			//X3_CBOX
	                  0,;			//X3_RELACAO
	                  ""})			//X3_WHEN 
	                  
	   Aadd(aCabecalho, {;
		                  "Per.Hard.",;	//X3Titulo()
		                  "Z4_PORHARD",;//X3_CAMPO
		                  "@E 99.99",;	//X3_PICTURE
		                  5,;			//X3_TAMANHO
		                  2,;			//X3_DECIMAL
		                  "",;			//X3_VALID
		                  "",;			//X3_USADO
		                  "N",;			//X3_TIPO
		                  ""	,;		//X3_F3
		                  "R",;			//X3_CONTEXT
		                  "",;			//X3_CBOX
		                  0,;			//X3_RELACAO
		                  ""})			//X3_WHEN 
	
	Aadd(aCabecalho, {;
		                  "Inicio",;	//X3Titulo()
		                  "Z4_QTDMIN",; //X3_CAMPO
		                  "@E 99999",;	//X3_PICTURE
		                  5,;			//X3_TAMANHO
		                  0,;			//X3_DECIMAL
		                  "",;			//X3_VALID
		                  "",;			//X3_USADO
		                  "N",;			//X3_TIPO
		                  "",;			//X3_F3
		                  "R",;			//X3_CONTEXT
		                  "",;			//X3_CBOX
		                  0,;			//X3_RELACAO
		                  ""})			//X3_WHEN 
	
	Aadd(aCabecalho, {;
		                  "Final",	  ;	//X3Titulo()
		                  "Z4_QTDMAX",;//X3_CAMPO
		                  "@E 99999",;	//X3_PICTURE
		                  5,;			//X3_TAMANHO
		                  0,;			//X3_DECIMAL
		                  "",;			//X3_VALID
		                  "",;			//X3_USADO
		                  "N",;			//X3_TIPO
		                  "",;			//X3_F3
		                  "R",;			//X3_CONTEXT
		                  "",;			//X3_CBOX
		                  0,;			//X3_RELACAO
		                  ""})			//X3_WHEN 
	                  
 
Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Carregar º Autor ³ RENATO RUY BERNARDO  º Data ³ 21/06/17  º±±
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
    
    SZ4->(DbSetOrder(1))
	If SZ4->(DbSeek(xFilial("SZ4")+SZ3->Z3_CODENT+"F1"))
		aColsEx := {}
		While !SZ4->(EOF()) .And. SZ3->Z3_CODENT = SZ4->Z4_CODENT .And. SZ4->Z4_CATPROD $ "F1/F2/F3/F4/F5"
			aadd(aColsEx,{SZ4->Z4_CATPROD,SZ4->Z4_CATDESC,SZ4->Z4_PORSOFT,SZ4->Z4_PORHARD,SZ4->Z4_QTDMIN,SZ4->Z4_QTDMAX,.F.})
			SZ4->(DbSkip())
		Enddo
	Elseif oCombo2:NAT == 1
		aColsEx := {}
		aadd(aColsEx,{"F1","FAIXA1",33,20,201,400,.F.})
		aadd(aColsEx,{"F2","FAIXA2",35,20,401,500,.F.})
		aadd(aColsEx,{"F3","FAIXA3",37,20,501,99999,.F.})
	Elseif oCombo2:NAT == 2
		aColsEx := {}
		aadd(aColsEx,{"F1","FAIXA1",6,0,  1,50		,.F.})
		aadd(aColsEx,{"F2","FAIXA2",7,0, 51,150	,.F.})
		aadd(aColsEx,{"F3","FAIXA3",8,0,151,300	,.F.})
		aadd(aColsEx,{"F4","FAIXA4",9,0,301,500	,.F.})
		aadd(aColsEx,{"F5","FAIXA5",9,0,501,99999	,.F.})
	Elseif oCombo2:NAT == 3
		aColsEx := {}
		aadd(aColsEx,{"F1","FAIXA1",5	,0,  1,50		,.F.})
		aadd(aColsEx,{"F2","FAIXA2",5.5	,0, 51,150		,.F.})
		aadd(aColsEx,{"F3","FAIXA3",6	,0,151,300		,.F.})
		aadd(aColsEx,{"F4","FAIXA4",6.5	,0,301,500		,.F.})
		aadd(aColsEx,{"F5","FAIXA5",7	,0,501,99999	,.F.})
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
±±ºPrograma  ³ CRPA038U º Autor ³ RENATO RUY BERNARDO  º Data ³ 21/06/17  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Efetua gravacao dos dados de controle de faixas.		      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CRPA038U()

nCodFx	:= Ascan( oLista:aHeader, { |x| AllTrim(x[2])=="Z4_CATPROD" } )
nDescFx := Ascan( oLista:aHeader, { |x| AllTrim(x[2])=="Z4_CATDESC" } )
nPerSW	:= Ascan( oLista:aHeader, { |x| AllTrim(x[2])=="Z4_PORSOFT" } )
nPerHW	:= Ascan( oLista:aHeader, { |x| AllTrim(x[2])=="Z4_PORHARD" } )
nQtdMin	:= Ascan( oLista:aHeader, { |x| AllTrim(x[2])=="Z4_QTDMIN" } )
nQtdMax	:= Ascan( oLista:aHeader, { |x| AllTrim(x[2])=="Z4_QTDMAX" } )

//Posiciona SZ4 no indice
SZ4->(DbSetOrder(1)) // Z4_FILIAL + Z4_CODENT + Z4_CATPROD

//Grava informacoes do cabecalho do cadastro de entidade.
If oCombo1:NAT == 1
	Reclock("SZ3",.F.)
		SZ3->Z3_FAIXA := "1"
		SZ3->Z3_PRODFX:= cGet4
	SZ3->(MsUnlock())
Else
	Reclock("SZ3",.F.)
		SZ3->Z3_FAIXA := "2"
		SZ3->Z3_PRODFX:= cGet4
	SZ3->(MsUnlock())
Endif

For nZ := 1 To Len(oLista:aCols)
	
	//Se a linha está marcada para exclusão, verifica se existe na base para apagar.
	If oLista:aCols[nZ,Len(oLista:aCols[nZ])] .And. SZ4->(DbSeek(xFilial("SZ4")+cGet1+oLista:aCols[nZ,nCodFx]))
		RecLock("SZ4",.F.)
			DbDelete()
		SZ4->(MsUnlock())
	//Atualiza faixas existentes			
	Elseif !oLista:aCols[nZ,Len(oLista:aCols[nZ])] .And. SZ4->(DbSeek(xFilial("SZ4")+cGet1+oLista:aCols[nZ,nCodFx]))
		RecLock("SZ4",.F.)
			SZ4->Z4_PORSOFT	:= oLista:aCols[nZ,nPerSW]
			SZ4->Z4_PORHARD	:= oLista:aCols[nZ,nPerHW]
			SZ4->Z4_QTDMIN	:= oLista:aCols[nZ,nQtdMin]
			SZ4->Z4_QTDMAX	:= oLista:aCols[nZ,nQtdMax]
		SZ4->(MsUnlock())
	//Cria uma nova faixa caso não exista
	Elseif !oLista:aCols[nZ,Len(oLista:aCols[nZ])] .And. !SZ4->(DbSeek(xFilial("SZ4")+cGet1+oLista:aCols[nZ,nCodFx])) 
		RecLock("SZ4",.T.)
			SZ4->Z4_CODENT	:= cGet1
			SZ4->Z4_CATPROD := oLista:aCols[nZ,nCodFx]
			SZ4->Z4_CATDESC := oLista:aCols[nZ,nDescFx]
			SZ4->Z4_PORSOFT	:= oLista:aCols[nZ,nPerSW]
			SZ4->Z4_PORHARD	:= oLista:aCols[nZ,nPerHW]
			SZ4->Z4_QTDMIN	:= oLista:aCols[nZ,nQtdMin]
			SZ4->Z4_QTDMAX	:= oLista:aCols[nZ,nQtdMax]
		SZ4->(MsUnlock())
	Endif
Next

oDlg:End()
Return