#include "PROTHEUS.CH"
#include "TOPCONN.CH"
#INCLUDE "rwmake.ch"


//-----------------------------------------------------------------------
/*/{Protheus.doc} csADE04Cad()
Este fonte tem por objetivo exibir uma tela para o usuario incluir 
o Grupo, Produto, Cod. Prod. Protheus, Cod.Prod. GAR, AR.

Devido ao cadastro de Produto (SB1), PA8, DA0, DA1 nao exibir a AR, e 
eh preciso enviar o AR no link do Checkout, para nao ter que 'chumbar'
os codigos, realizando um de-para, criei a tabela ZZR para que o 
usuario realize o cadastro apos as consultas(query) e tambem nao sera
precisa realizar manutencao no fonte, e sim incluir, alterar na rotina.

Temos as AR atraves da consulta na tabela SZ3 com Z3_TIPENT=3 porem,
o usuario nao sabera para qual produto eh a AR tal.

obs.: Esses codigos o Rafael Papetti enviou.


@author	Douglas Parreja
@since	16/06/2016
@version 11.8
/*/
//-----------------------------------------------------------------------

user function csADE04Cad()

	local cMVUser		:= "MV_CHKUSER"
	private cCadastro	:= "Cadastro Produto -  ServiceDesk x Checkout"
	private aRotina 	:= { {"Pesquisar"	,"AxPesqui"			,0,1} ,;
			             {"Visualizar"	,"u_csTelaModel2(2)"	,0,2} ,;
			             {"Incluir"		,"u_csTelaModel2(3)"	,0,3} ,;
			             {"Alterar"		,"u_csTelaModel2(4)"	,0,4} ,;
			             {"Excluir"		,"u_csTelaModel2(5)"	,0,5} ,;
			             {"Importar"		,"u_CSADE04IMP()"		,0,6}}
	
	private cDelFunc 	:= ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock.
	private cExec 		:= "Service-Desk x Checkout"
	private cString 	:= "ZZR"
		
	dbSelectArea("ZZR")
	dbSetOrder(1) //ZZR_FILIAL+ZZR_ITEM
	dbSelectArea(cString)
	
	
	//----------------------	
	// Valida Upd/Ambiente
	//----------------------
	lOk := u_csCheckUpd()
	
	if lOk	
		//----------------------	
		// Valida Acesso
		//----------------------
		if u_csUserAcesso(cMVUser)
			mBrowse( 6,1,22,75,cString)			
		else
			msgInfo('Por gentileza, entre em contato com Sistemas Corporativos, pois o Sr(a) não possui acesso ao cadastro.','Cadastro Produto')
			return
		endif
	endif
	
return

//-----------------------------------------------------------------------
/*/{Protheus.doc} csTelaModel2()
Rotina para exibicao da tela


@author	Douglas Parreja
@since	16/06/2016
@version 11.8
/*/
//-----------------------------------------------------------------------
user function csTelaModel2(nOpcx)

	local cItens   	:= "ZZR_ITEM|ZZR_GRUPO|ZZR_CDPROD|ZZR_CDGAR|ZZR_DESC|ZZR_CODTAB"
	local cCampos		:= "ZZR_ITEM|ZZR_ORIGEM|ZZR_GRUPO|ZZR_CDPROD|ZZR_CDGAR|ZZR_DESC|ZZR_CODTAB|ZZR_AR|ZZR_AC|ZZR_STATUS"
	local nUsado		:= 0 
	local nUsadoCampos	:= 0
	local cZZRTIT		:= ""
	local cZZRPAR		:= ""
	local nLinGetD		:= 0
	local cTitulo		:= "Cadastro Produto - ServiceDesk x Checkout"
	local aCabec		:= {}
	local aR			:= {}
	local aCGD			:= {150,5,150,350}
	local lVisualiza	:= .F.
	private cLinhaOk 	:= ".T."
	private cTudoOk  	:= ".T."
	private aCols		:= {}
	private aGetsD		:= {}
	//----------------------------------------------
	// Variaveis do cabecalho						
	//----------------------------------------------
	private cOrigem	:= Space(10)
	private cGrupo		:= Space(10)
	private cProd		:= Space(10)
	private cCodProd	:= Space(20)
	private cCodGAR	:= Space(20)
	private cDescProd	:= Space(42)
//	private cValor		:= Space(10)
	private cAR		:= Space(10)
	private cAC		:= Space(10)
	private cCodTab	:= ""	

	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("ZZR")
	
	aHeader :={}
	aCampos :={}
	
	//----------------------------------------------
	// Montando aHeader para a Getdados            
	//----------------------------------------------
	while !Eof() .And. (SX3->X3_ARQUIVO == "ZZR")
		if X3USO(SX3->X3_USADO) .And. AllTrim(SX3->X3_CAMPO) $ cItens
			nUsado := nUsado+1
			aAdd(aHeader,{ 	TRIM(X3_TITULO)	,;
							X3_CAMPO		,;
							X3_PICTURE		,;
							X3_TAMANHO		,;
							X3_DECIMAL		,;
							X3_VALID		,;
							X3_USADO		,;
							X3_TIPO			,; 
							X3_ARQUIVO		,;
							X3_CONTEXT 		})
		endif
		if X3USO(SX3->X3_USADO) .And. AllTrim(SX3->X3_CAMPO) $ cCampos
			nUsadoCampos := nUsadoCampos+1
			aAdd(aCampos,{ 	TRIM(X3_TITULO)	,;
							X3_CAMPO		,;
							X3_PICTURE		,;
							X3_TAMANHO		,;
							X3_DECIMAL		,;
							X3_VALID		,;
							X3_USADO		,;
							X3_TIPO			,; 
							X3_ARQUIVO		,;
							X3_CONTEXT 		})
		endif
		dbSkip()
	end
	
	//----------------------------------------------
	// INCLUSAO               
	//----------------------------------------------
	if nOpcx == 3 
		//----------------------------------------------
		// Montando aCols para a GetDados               
		//----------------------------------------------
		aCols:=Array(1,nUsado+1)
		SX3->(DbGoTop())
		DbSeek("ZZR")
		nUsado := 0
		
		while !Eof() .And. (x3_arquivo == "ZZR")
			if X3USO(SX3->X3_USADO) .And. AllTrim(SX3->X3_CAMPO) $ cItens
				nUsado:=nUsado+1
				if nOpcx == 3
					if x3_tipo == "C"
						aCols[1,nUsado] := SPACE(SX3->X3_TAMANHO)
					elseif x3_tipo == "N"
						aCols[1,nUsado] := 0
					elseif x3_tipo == "D"
						aCols[1,nUsado] := dDataBase
					elseif x3_tipo == "M"
						aCols[1,nUsado] := ""
					else
						aCols[1,nUsado] := .F.
					endif
				endif
			endif
			dbSkip()
		end
		
		aCols[1,nUsado+1] := .F.
		
		//----------------------------------------------
		// Verificar qual origem esta sendo o cadastro 
		//----------------------------------------------
		cOrigem 	:= u_csADEOrig()
		lVisualiza	:= .F.
	
	//----------------------------------------------
	// VISUALIZACAO, ALTERACAO e EXCLUSAO               
	//----------------------------------------------	
	elseIf nOpcx == 2 .Or. nOpcx == 4 .Or. nOpcx == 5
	    cOrigem		:= padr( alltrim(ZZR->ZZR_ORIGEM	), len(cOrigem)		,"" )
	    cGrupo		:= padr( alltrim(ZZR->ZZR_GRUPO		), len(cGrupo)		,"" )
	    cCodProd	:= padr( alltrim(ZZR->ZZR_CDPROD	), len(cCodProd)	,"" )
	    cCodGAR		:= padr( alltrim(ZZR->ZZR_CDGAR		), len(cCodGAR)		,"" )
	    cDescProd	:= padr( alltrim(ZZR->ZZR_DESC		), len(cDescProd)	,"" )
	    //cValor		:= padr( alltrim(ZZR->ZZR_VALOR		), len(cValor)		,"" )
	    cAR			:= padr( alltrim(ZZR->ZZR_AR		), len(cAR)			,"" )
	    cAC			:= padr( alltrim(ZZR->ZZR_AC		), len(cAC)			,"" )
	    cCodTab		:= alltrim(ZZR->ZZR_CODTAB)
		lVisualiza 	:= .T.			
	endif	

	//----------------------------------------------
	// Array com descricao dos campos do Cabecalho 
	//----------------------------------------------
	//1a coluna
	aAdd(aCabec,{"cOrigem" 		,{018,006} ,"Origem "				,"@!"	,""			,""			,.F.})
	aAdd(aCabec,{"cGrupo" 		,{038,008} ,"Grupo "	   			,"@!"	,""			,"ADE001"	,.T.})
	aAdd(aCabec,{"cProd"  		,{058,004} ,"Produto "				,"@!"	,"U_CSADE8G()",			,.T.})
	//2a coluna
	aAdd(aCabec,{"cCodProd"  	,{018,170} ,"Cod.Prod. Protheus "	,"@!"	,""			,""		  	,lVisualiza})
	aAdd(aCabec,{"cCodGAR" 		,{038,183} ,"Cod.Prod.GAR "			,"@!"	,""			,""	  		,lVisualiza})
	aAdd(aCabec,{"cDescProd" 	,{058,172} ,"Descrição Produto "	,"@!"	,""			,""	  		,lVisualiza})
	//3a coluna
	//aAdd(aCabec,{"cValor"  		,{038,388} ,"Valor R$ "				,"@!"	,""			,""			,.F.})
	//4a coluna
	aAdd(aCabec,{"cAR"  		,{018,530} ,"AR "					,"@!"	,""			,""			,.T.})
	aAdd(aCabec,{"cAC"  		,{038,530} ,"AC "					,"@!"	,""			,""			,.T.})
	
	//----------------------------------------------
	// Chamada da Modelo2                          
	// lRet = .T. se confirmou
	// lRet = .F. se cancelou
	//----------------------------------------------	
	lRet:=Modelo2(cTitulo,aCabec,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,,,,,,,.T.)
	
	if lRet
		u_csZZRProcess( nOpcx )	
	endif

Return

//-----------------------------------------------------------------------
/*/{Protheus.doc} csTelaAlt()
Rotina para exibicao da tela de Alteracao do Cadastro.


@author	Douglas Parreja
@since	15/07/2016
@version 11.8
/*/
//-----------------------------------------------------------------------
user function csTelaAlt( aDados )
 
	local aACampos  	:= {"CODIGO"} 	//Variável contendo o campo editável no Grid
	local aBotoes		:= {}        	//Variável onde será incluido o botão para a legenda
	
	private oLista                	//Declarando o objeto do browser
	private aCabecalho	:= {}        	//Variavel que montará o aHeader do grid
	private aColsEx 	:= {}        	//Variável que receberá os dados
	private oVerde  	:= LoadBitmap( GetResources(), "BR_VERDE")
	private oAzul  	:= LoadBitmap( GetResources(), "BR_AZUL")
	private oVermelho	:= LoadBitmap( GetResources(), "BR_VERMELHO")
		
	default aDados		:= {}
	
	DEFINE MSDIALOG oDlg TITLE "CADASTRO ALTERACAO" FROM 000, 000  TO 300, 880  PIXEL
	
		//---------------------------------------------------------
		//chamar a função que cria a estrutura do aHeader
		//---------------------------------------------------------
		csCriaCabec()
		
		//---------------------------------------------------------	
		//Monta o browser com inclusão, remoção e atualização
		//---------------------------------------------------------
		oLista := MsNewGetDados():New( 053, 078, 415, 775, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "AllwaysTrue", aACampos,1, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg, aCabecalho, aColsEx)
				
		//---------------------------------------------------------
		//Carregar os itens que irão compor o conteudo do grid
		//---------------------------------------------------------
		csCarregar( aDados )
		
		//---------------------------------------------------------
		//Alinho o grid para ocupar todo o meu formulário
		//---------------------------------------------------------
		oLista:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
		
		//---------------------------------------------------------
		//Ao abrir a janela o cursor está posicionado no meu objeto
		//---------------------------------------------------------
		oLista:oBrowse:SetFocus()
		
		//---------------------------------------------------------
		//Crio o menu que irá aparece no botão Ações relacionadas
		//---------------------------------------------------------
		aadd(aBotoes,{"NG_ICO_LEGENDA", {||Legenda()},"Legenda","Legenda"})
		
		EnchoiceBar(oDlg, {|| oDlg:End() }, {|| oDlg:End() },,aBotoes)
	
	ACTIVATE MSDIALOG oDlg CENTERED
    
Return

//-----------------------------------------------------------------------
/*/{Protheus.doc} csCriaCabec()
Rotina para criacao do Cabecalho da rotina.
Obs.:Utilizado outro nome de variavel para diferenciar acima.

@author	Douglas Parreja
@since	15/07/2016
@version 11.8
/*/
//-----------------------------------------------------------------------
static function csCriaCabec()
    
    Aadd(aCabecalho, {;
			"",;			//X3Titulo()
	       "IMAGEM",;  	//X3_CAMPO
	       "@BMP",;		//X3_PICTURE
	       3,;				//X3_TAMANHO
	       0,;				//X3_DECIMAL
	       ".F.",;			//X3_VALID
	       "",;			//X3_USADO
	       "C",;			//X3_TIPO
	       "",; 			//X3_F3
			"V",;			//X3_CONTEXT
	       "",;			//X3_CBOX
	       "",;			//X3_RELACAO
	       "",;			//X3_WHEN
	       "V"})			//
    Aadd(aCabecalho, {;
			"Item",;		//X3Titulo()
           "ITEM",;  		//X3_CAMPO
           "@!",;			//X3_PICTURE
           5,;				//X3_TAMANHO
           0,;				//X3_DECIMAL
           "",;			//X3_VALID
           "",;			//X3_USADO
           "C",;			//X3_TIPO
           "",; 			//X3_F3
           "R",;			//X3_CONTEXT
           "",;			//X3_CBOX
           "",;			//X3_RELACAO
           ""})			//X3_WHEN
    Aadd(aCabecalho, {;
           "Campo",;		//X3Titulo()
           "CAMPO",; 	 	//X3_CAMPO
           "@!",;			//X3_PICTURE
           20,;			//X3_TAMANHO
           0,;				//X3_DECIMAL
           "",;			//X3_VALID
           "",;			//X3_USADO
           "C",;			//X3_TIPO
           "",; 			//X3_F3
           "R",;			//X3_CONTEXT
           "",;			//X3_CBOX
           "",;			//X3_RELACAO
           ""})			//X3_WHEN
    Aadd(aCabecalho, {;
           "Descricao Gravada",;		//X3Titulo()
           "DESCGRV",;  	//X3_CAMPO
           "@!",;			//X3_PICTURE
           46,;			//X3_TAMANHO
           0,;				//X3_DECIMAL
           "",;			//X3_VALID
           "",;			//X3_USADO
           "C",;			//X3_TIPO
           "",;			//X3_F3
           "R",;			//X3_CONTEXT
           "",;			//X3_CBOX
           "",;			//X3_RELACAO
           ""})			//X3_WHEN             
    Aadd(aCabecalho, {;
           "Descricao Alterada",;	//X3Titulo()
           "DESCALT",;  	//X3_CAMPO
           "@!",;			//X3_PICTURE
           46,;			//X3_TAMANHO
           0,;				//X3_DECIMAL
           "",;			//X3_VALID
           "",;			//X3_USADO
           "C",;			//X3_TIPO
           "",;			//X3_F3
           "R",;			//X3_CONTEXT
           "",;			//X3_CBOX
           "",;			//X3_RELACAO
           ""})			//X3_WHEN

return

//-----------------------------------------------------------------------
/*/{Protheus.doc} csCarregar
Rotina para criacao do Cabecalho da rotina.
Obs.:Utilizado outro nome de variavel para diferenciar acima.

@param	aDados		Consta as informacoes gravadas e alteradas.


@author	Douglas Parreja
@since	15/07/2016
@version 11.8
/*/
//-----------------------------------------------------------------------
static function csCarregar( aDados )

	local nX := 0
	
	default aDados		:= {}
	
	//----------------------------------------
	// STATUS ARRAY
	// aColsEx[1] - Legenda
	// aColsEx[2] - Item
	// aColsEx[3] - Campo
	// aColsEx[4] - Descricao Gravada
	// aColsEx[5] - Descricao Alterada	
	//
	// Legenda: 
	// Azul  -> Registro nao modificado.
	// Verde -> Registro alterado.
	// Vermelho -> Nao existe campo na base.
	//----------------------------------------
	
	for nX := 1 to len( aDados )	
		if(aDados[nX,2]=="1")
			aadd(aColsEx,{oAzul,StrZero(nX,3), aDados[nX,1],aDados[nX,3], aDados[nX,4],.F.})
		elseif(aDados[nX,2]=="2")
			aadd(aColsEx,{oVerde,StrZero(nX,3), aDados[nX,1],aDados[nX,3], aDados[nX,4],.F.})
		elseif(aDados[nX,3]=="3")
			aadd(aColsEx,{oVermelho,StrZero(nX,3), aDados[nX,1],aDados[nX,3], aDados[nX,4],.F.})
		endif
	next
	
	//----------------------------------------
	//Setar array do aCols do Objeto
	//----------------------------------------
	oLista:SetArray(aColsEx,.T.)
	
	//----------------------------------------
	//Atualizo as informacoes no grid
	//----------------------------------------
	oLista:Refresh()
	
Return

//-----------------------------------------------------------------------
/*/{Protheus.doc} Legenda()
Funcao para obter as cores da Legenda.

@author	Douglas Parreja
@since	15/07/2016
@version 11.8
/*/
//-----------------------------------------------------------------------
static function Legenda()

    local aLegenda := {}
    
    aAdd( aLegenda,{"BR_AZUL"    	,"   Registro nao modificado" 	})
    aAdd( aLegenda,{"BR_VERDE"    	,"   Registro alterado" 		})
    aAdd( aLegenda,{"BR_VERMELHO" 	,"   Nao existe campo na base" 	})

    BrwLegenda("Legenda", "Legenda", aLegenda)

Return Nil


User Function CSADE04V(xCodProd,xCodGar, xDescProd, xValor, xCodTab)

cCodProd 	:= xCodProd
cCodGAR		:= xCodGar	
cDescProd	:= xDescProd	
//cValor		:= xValor 	
cCodTab		:= xCodTab

Return

User Function CSADE8G()
U_csADE02Send()
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma: CSADE04IMP ºAutor  ³Renato Ruy Bernardo º Data ³  25/05/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para atualizar dados da campanha e clube.			 º±±
±±º          ³ 			                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CSADE04IMP()

Local aPergs 	:= {}
Local cCodRec 	:= space(08)
Local lRet

Private aPedidos:= {}
Private aRet 	:= {}
Private cPedIn	:= ""
Private cPerg   := "CRP037"

//ValidPerg()
//pergunte(cPerg,.T.)  

aAdd( aPergs ,{ 1,"Tabela de Preço",Space(3) ,"@!","","DA0"		,"",50,.F.})
aAdd( aPergs ,{ 1,"Grupo"			,Space(6) ,"@!","",""		,"",50,.F.})
aAdd( aPergs ,{ 1,"AR"				,Space(6) ,"@!","",""		,"",50,.F.})
aAdd( aPergs ,{ 1,"AC"				,Space(6) ,"@!","","SZ3_02"	,"",50,.F.})

If !ParamBox(aPergs ,"Tabelas",aRet)
	Alert("A atualizacao foi cancelada!")
	Return
EndIf

Processa( {|| GerReg() }, "Selecionando registros...")

Return

//Renato Ruy - 25/05/2018
//Subrotina para geração do dados na ZZR
Static Function GerReg

Local lNovo := .T.
Local cItem := ""

//Busca sequencia de numeracao do grupo
IncProc( "Seleciona sequencia atual do grupo.." )
ProcessMessage()

If Select("TMPSEQ") > 0
	DbSelectArea("TMPSEQ")
	TMPSEQ->(DbCloseArea())
Endif

Beginsql Alias "TMPSEQ"
	SELECT MAX(ZZR_ITEM) ITEM FROM PROTHEUS.ZZR010
	WHERE
	ZZR_FILIAL = ' ' AND
	ZZR_GRUPO = 'PUBLI' AND
	D_E_L_E_T_ = ' '
Endsql

cItem := Iif(Empty(TMPSEQ->ITEM),"00001",SOMA1(TMPSEQ->ITEM))

//Busca produtos ativos da tabela
IncProc( "Seleciona dados da tabela de preço.." )
ProcessMessage()

If Select("TMPTAB") > 0
	DbSelectArea("TMPTAB")
	TMPTAB->(DbCloseArea())
Endif

Beginsql Alias "TMPTAB"
	SELECT DA1_ITEM,
        	DA1_CODPRO,
        	DA1_CODGAR,
        	DA1_DESGAR,
        	DA1_PRCVEN 
	FROM %Table:DA1%
	WHERE
	DA1_FILIAL = ' ' AND
	DA1_CODTAB = %Exp:aRet[1]% AND
	DA1_ATIVO = '1' AND
	%Notdel%
Endsql

//ZZR_FILIAL, ZZR_CDGAR, ZZR_GRUPO, ZZR_CDPROD
ZZR->(DbSetOrder(3))

//Z3_FILIAL, Z3_TIPENT, Z3_CODGAR
SZ3->(DbSetOrder(6))
If SZ3->(DbSeek(xFilial("SZ3")+"5"+AllTrim(aRet[2])))
	If !(aRet[1] $ SZ3->Z3_CODTAB)
		MsgInfo("O Grupo não tem esta tabela vinculada!")
		Return
	Endif
Else
	MsgInfo("O Grupo não foi localizado e a rotina não efetuará a importação")
	Return
Endif

While !TMPTAB->(EOF())

	//Busca produtos ativos da tabela
	IncProc( "Gerando dados para o produto: " + AllTrim(TMPTAB->DA1_CODGAR))
	ProcessMessage()
	
	//Verifica se já existe, para apenas atualizar
	lNovo := .T.
	If ZZR->(DbSeek(xFilial("ZZR")+ AllTrim(TMPTAB->DA1_CODGAR)))
		
		While AllTrim(ZZR->ZZR_CDGAR) == AllTrim(TMPTAB->DA1_CODGAR)
		
			If AllTrim(ZZR->ZZR_CODTAB) == aRet[1] .And. AllTrim(ZZR->ZZR_GRUPO) == AllTrim(aRet[2]) .And.;
			   AllTrim(ZZR->ZZR_AR) == alltrim(aRet[3])
				lNovo := .F.
				Exit
			Endif
			
			ZZR->(DbSkip())
		Enddo
		
	Endif
		
	//Cria Registro se não existe
	ZZR->( Reclock( 'ZZR', lNovo ))
		ZZR->ZZR_FILIAL	:= xFilial("ZZR")
		ZZR->ZZR_ORIGEM	:= "1"
		ZZR->ZZR_ITEM		:= Iif(lNovo,cItem,ZZR->ZZR_ITEM)
		ZZR->ZZR_GRUPO	:= AllTrim(aRet[2])
		ZZR->ZZR_CDPROD	:= AllTrim(TMPTAB->DA1_CODPRO)
		ZZR->ZZR_CDGAR	:= alltrim(TMPTAB->DA1_CODGAR)
		ZZR->ZZR_DESC		:= alltrim(TMPTAB->DA1_DESGAR)
		ZZR->ZZR_VALOR	:= alltrim(TMPTAB->DA1_PRCVEN)
		ZZR->ZZR_CODTAB	:= alltrim(aRet[1])
		ZZR->ZZR_AR		:= alltrim(aRet[3])
		ZZR->ZZR_AC		:= alltrim(aRet[4])	
		ZZR->ZZR_STATUS	:= Iif(lNovo,"1","2")
		ZZR->ZZR_USER		:= "User: " + logusername() + " | " + "Data: " + dtoc(Date()) + " - " + Time() + " | " + "IPClient: " + getClientIP()
	ZZR->( MsUnlock() )
	
	cItem := Iif(lNovo,SOMA1(cItem),cItem)
	TMPTAB->(DbSkip()) 
Enddo

MsgInfo("A tabela: "+aRet[1]+" foi importada!")

Return