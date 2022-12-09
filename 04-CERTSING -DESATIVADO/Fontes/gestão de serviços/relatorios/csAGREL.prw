#include 'PARMTYPE.CH'
#include "PROTHEUS.CH"
#include "TBICONN.CH"
#include "RWMAKE.CH"

//-----------------------------------------------------------------------
/*{Protheus.doc} csAGRel
Funcao responsavel por exibir relatorio da Consulta de Agendamento 
por Tecnico e Data.

Substituido o relatorio realizado (CSAGAGEN.prw), pois o relatorio
os dados apenas em uma coluna. 


@author	Douglas Parreja 
@since	20/04/2017
@version 11.8
/*/
//-----------------------------------------------------------------------
user Function csAGRel( oBrowse )

	local oExcel 	:= NIL
	local aPergs	:= {}
	local aRet		:= {}
	local lRet		:= .F.
	local dDatIni	:= CriaVar("PA0_DTAGEN")
	local dDatFim	:= CriaVar("PA0_DTAGEN")
	local cCodAr	:= CriaVar("PA0_AR")  	
	
	aAdd( aPergs ,{1,"Data Inicial : "	,dDatIni,"","","","",50,.F.})
	aAdd( aPergs ,{1,"Data Final : "	,dDatFim,"","","","",50,.F.})   
	aAdd( aPergs ,{1,"Posto Atend.: "	,cCodAr	,"","","SZ3","",0,.F.})      
	
	if ParamBox(aPergs ,"Consulta Agenda",@aRet)      
	    
		lRet := .T.
		 
		dDatIni := aRet[1]
		dDatFim := aRet[2]
		cCodAr := aRet[3]
		
		if valid( dDatIni, dDatFim, cCodAr )			
			Processa( {|| procDados( dDatIni, dDatFim, cCodAr ) }, "Selecionando registros...")
		endif
			
	else         		
		lRet := .F.					
	endIf
	
	oBrowse:Refresh()
	                          
return (.T.)

//-----------------------------------------------------------------------
/*{Protheus.doc} procDados
Funcao responsavel por realizar o processamento do relatorio.
Realizado validacoes afim de evitar incidentes fora do padrao.

@param	dDatIni		Data Inicio do relatorio a ser extraido.
		dDatFim		Data Fim do relatorio a ser extraido.
		cCodAr		Codigo da AR.

@author	Douglas Parreja
@since	24/04/2017
@version 11.8
/*/
//-----------------------------------------------------------------------
static function procDados( dDatIni, dDatFim, cCodAr )    

	local nQtd			:= 0 
	local cDados		:= ""
	local cRetQuery		:= ""
	local cDataAgend	:= ""
	local cDataLayout	:= ""
	
	default dDatIni	:= date()
	default dDatFim	:= date()	
	default cCodAr		:= ""

	//-----------------------------------------------------------------------
    // Criacao da Query
    //-----------------------------------------------------------------------
	cDados := csQuery( dDatIni, dDatFim, cCodAr )
     
    //-----------------------------------------------------------------------
    // Retorno da tabela temporaria
    //-----------------------------------------------------------------------
    cRetQuery := ExecuteQuery( cDados )
                    
	//-----------------------------------------------------------------------
	// Valido se a tabela esta aberta para prosseguir com o Processamento.
	//-----------------------------------------------------------------------
	if select(cRetQuery) > 0
	
		cPath := GetTempPath()
		cName  := cPath + "Consulta_Agendas.xml"
		
		//--------------------------------------------------------------------
		// Objetos Excell 		
		//--------------------------------------------------------------------
		oExcel := FWMSEXCEL():New()
		cExcel := ""
		
		//--------------------------------------------------------------------
		// Retorno da Query 		
		//--------------------------------------------------------------------	
		(cRetQuery)->(dbGoTop())		
		while (cRetQuery)->(!EOF())
		
			if cDataAgend <> (cRetQuery)->(DataAgend)
			
				cDataAgend	:= (cRetQuery)->(DataAgend)
				cDataLayout	:= iif( valtype(cDataAgend) == "C" .and. !empty(cDataAgend), dtoc(stod(cDataAgend)), "" )				
			 
				oExcel:AddworkSheet(cDataAgend)
				oExcel:AddTable (cDataAgend, cCodAr)
				if .T. //Fazer tratamento para segunda vez colocar 		
					oExcel:AddColumn(cDataAgend, cCodAr,"Horario"		,1,1,.F.)		//1
				endif
				oExcel:AddColumn(cDataAgend, cCodAr,"Consultor"		,1,1,.F.)		//2
				oExcel:AddColumn(cDataAgend, cCodAr,"Ordem Serv"		,1,1,.F.)		//2
				oExcel:AddColumn(cDataAgend, cCodAr,"Razao Social"	,1,1,.F.)		//3		
				oExcel:AddColumn(cDataAgend, cCodAr,"Endereco"		,1,1,.F.)		//4
				oExcel:AddColumn(cDataAgend, cCodAr,"Complemento"		,1,1,.F.)		//3
				oExcel:AddColumn(cDataAgend, cCodAr,"Telefone"		,1,1,.F.)		//3
				oExcel:AddColumn(cDataAgend, cCodAr,"e-mail"			,1,1,.F.)		//3
				oExcel:AddColumn(cDataAgend, cCodAr,"Contato"			,1,1,.F.)		//3
			
			endif				
			 	
			//--------------------------------------------------------------------
			// Exibicao do Processamento 		
			//--------------------------------------------------------------------	 			
			nQtd += 1	
			IncProc( "Exportando " + alltrim(str(nQtd)) + " --> Data: " + cDataLayout )
			ProcessMessage()
				
																		
			//-------------------------------------------------------------------
			// Montagem da 1a Aba da Planilha 		
			//--------------------------------------------------------------------																		
			oExcel:AddRow(cDataAgend, cCodAr, {	alltrim((cRetQuery)->(Horario))					,; //1 
												alltrim((cRetQuery)->(NomeTec))					,; //2
												alltrim((cRetQuery)->(OrdemServ))				,; //3
												alltrim((cRetQuery)->(RazaoSocial))				,; //4
												alltrim((cRetQuery)->(EndCli))					,; //5
												alltrim((cRetQuery)->(ComplCli))				,; //6
												"(" + alltrim((cRetQuery)->(dddCli)) + ")" + 	;  //7	
												alltrim((cRetQuery)->(telCli))					,; //7
												alltrim((cRetQuery)->(emailCli))				,; //8
												alltrim((cRetQuery)->(contato))					}) //9																																				
		
			(cRetQuery)->(dbSkip())
			
		end                       
		(cRetQuery)->(dbCloseArea())
	else
		lRet := .F.
	endif																							
	//--------------------------------------------------------------------
	// Somente criarei Excell, caso tenha registros no Objeto, com essa
	// validacao eu reforco a seguranca da integridade das informacoes
	// afim de evitar incidentes fora do padrao.	
	//--------------------------------------------------------------------
	if len(oExcel:aTable) > 0
		if len(oExcel:aTable[1][4]) > 0 																									
			oExcel:Activate()
			oExcel:GetXMLFile(cName)
			Shellexecute("OPEN", cName, '', '' , 1)   
			lRet := .T.
		else
			lRet := .F.
		endif
	endif
	
	//--------------------------------------------------------------------	
	// Caso deu algum erro em algum momento abortarei o processamento
	// e exibirei a mensagem abaixo para o usuario.
	//--------------------------------------------------------------------
	if !(lRet)
		msgAlert("Não há dados para os parâmetros informados, por favor revise os parâmetros")
	endif
	
return(lRet)


//-----------------------------------------------------------------------
/*{Protheus.doc} csQuery
Funcao responsavel por realizar a query a ser processada.

@param	dDatIni		Data Inicio do relatorio a ser extraido.
		dDatFim		Data Fim do relatorio a ser extraido.
		cCodAr		Codigo da AR.
		
@return	cQuery		Query a ser realizada.	

@author	Douglas Parreja
@since	24/04/2017
@version 11.8
/*/
//-----------------------------------------------------------------------
static function csQuery( dDatIni, dDatFim, cCodAr ) 

	local cQuery		:= ""
	
	default dDatIni	:= date()
	default dDatFim	:= date()	
	default cCodAr		:= ""

	cQuery := " SELECT						" 
	cQuery += "	PA2.PA2_DATA 	DataAgend, 	"
	cQuery += "	PA0.PA0_HRAGEN 	Horario, 	" 
	cQuery += "	pa2.pa2_codtec	CodigoTec,	"	
	cQuery += "	PA2.PA2_NOMTEC	NomeTec,	"
	cQuery += "	PA2.PA2_NUMOS 	OrdemServ,	" 
	cQuery += "	PA0.PA0_CLLCNO	RazaoSocial,"
	cQuery += "	PA0.PA0_END		EndCli,		"
	cQuery += "	PA0.PA0_COMPLE	ComplCli,	"
	cQuery += "	PA0.PA0_DDD		dddCli,		"
	cQuery += "	PA0.PA0_TEL		telCli,		"
	cQuery += "	PA0.PA0_EMAIL	emailCli,	"
	cQuery += "	PA0.PA0_CONAGE	contato		"	
	cQuery += " FROM " + RetSqlName("PA2") + " PA2, " + RetSqlName("PA0") + " PA0"
	cQuery += " WHERE " 	
	cQuery += " PA2.PA2_NUMOS = PA0.PA0_OS "
	cQuery += " AND PA2.PA2_DATA >= '" + dtos(dDatIni) + "'
	cQuery += " AND PA2.PA2_DATA <= '" + dtos(dDatFim) + "'
	cQuery += " AND PA0.PA0_HRAGEN <> ' ' " //= '16:00'"
	cQuery += " AND PA2.PA2_CODTEC <> ' ' " //= '004147'"
	cQuery += " AND PA0.D_E_L_E_T_ = ' ' "
	cQuery += " AND PA2.D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY DataAgend,horario " 

return cQuery

//-----------------------------------------------------------------------
/*{Protheus.doc} valid
Funcao responsavel por validar os parametros digitados pelo usuario.

@param	dDatIni		Data Inicio do relatorio a ser extraido.
		dDatFim		Data Fim do relatorio a ser extraido.
		cCodAr		Codigo da AR.
@return	lOk			Retorna se esta Ok para prosseguir.

@author	Douglas Parreja
@since	24/04/2017
@version 11.8
/*/
//-----------------------------------------------------------------------
static function valid( dDatIni, dDatFim, cCodAr )

	local lOk			:= .F.	
	default dDatIni 	:= date()
	default dDatFim 	:= date()
	default cCodAr		:= ""
	
	if ( valtype(dDatIni) == "D" .and. valtype(dDatFim) == "D" .and. !empty(cCodAr) )
		lOk := .T.
	else
		msgInfo("Por gentileza, revise os parÂmetros informados.")
	endif 

return lOk

//-------------------------------------------------------------------
/*{Protheus.doc} executeQuery
Funcao executa a query.

@param	cQuery		Query que sera executada
@return cAlias		Alias da query executada

@author  Douglas Parreja
@since   26/06/2015
@version 11.8
/*/
//-------------------------------------------------------------------
static function ExecuteQuery( cQuery )

	local cAlias	:= getNextAlias()
	local cExec		:= "Function csAgRel
	local cProcExp	:= "Relatorio Agend Externo"
	
	default cQuery	:= ""
	
	if ( !Empty(cQuery) )
		
		cQuery := ChangeQuery( cQuery )
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T.)
			
		if ( (cAlias)->(eof()) )
		
			(cAlias)->(dbCloseArea())
			
			cAlias := ""
			u_autoMsg(cExec,cProcExp,"Query nao retornou registros" )
		//Else
		//	u_autoMsg(cExec,cProcExp, "Executando query" )
		endif
	else
		
		cAlias := ""
		u_autoMsg(cExec,cProcExp, "Query nao retornou registros" )
	
	endif

return cAlias