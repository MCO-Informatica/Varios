#include "protheus.ch"

/*
---------------------------------------------------------------------------
| Rotina    | CSSDKTRA     | Autor | Gustavo Prudente | Data | 28.10.2013 |
|-------------------------------------------------------------------------|
| Descricao | Rotina para transferencia de atendimento entre grupos       |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/        
User Function CSSDKTRA()

Local _lRet			:= .T. // Retorno da funcao

Local _oDlg
Local _oGroup
Local _oGrpName	
Local _cGrpDesc 		:= Space( TamSx3("U0_NOME")[1] )
Local _aCoordenadas 	:= MsAdvSize( .T. ) 
Local _aChamados		:= { M->ADE_CODIGO }
Local _oAssunto 		:= Nil
Local _cDescAssunto 	:= Space( 50 )
Local _oDescAssunto 	:= Nil
                 
Local _cAssuAnt		:= M->ADE_ASSUNT
Local _cGrpAtend	   	:= ""  
Local _cGrpAnt		:= "" 
Local _lF3Grpo		:= .F. 
Local _cOpcSel		:= ""
Local aAreaAtual	:= {}

Local _nOpc			:= 0

Private _cGrupo 	:= Space( TamSX3("U0_CODIGO")[1] )
Private _cOperador 	:= M->ADE_OPERAD //Space( TamSX3("U7_COD")[1] )
Private _cAssunto  	:= Space( TamSX3("ADE_ASSUNT")[1] )
Private _cProduto	:= ""
Private cCategoria	:= ""
Private cOrigem   	:= ""
Private cCausa    	:= ""
Private cEfeito   	:= ""
Private cCampanha 	:= ""

If INCLUI .Or. ALTERA
               
	// Cria consultas de Grupo e Assunto caso não existam
	AjustaSXB()

	Do While _lRet

		_oDlg := TDialog():New(_aCoordenadas[7],000,_aCoordenadas[6]/3.5,_aCoordenadas[5]/2,"Transferencia de área",,,,,,,,oMainWnd,.T.) //

		@ 005,005 SAY "Grupo:" PIXEL SIZE 55,9 OF _oDlg 
		@ 016,005 MSGET _oGroup Var _cGrupo SIZE 015,9 PICTURE PesqPict("SU0", "U0_CODIGO") OF _oDlg Pixel F3 "SDK001" VALID ;                                         
				Iif( ExistCpo( "SU0", _cGrupo ), ( _cGrpDesc := Posicione( "SU0", 1, xFilial("SU0") + _cGrupo, "U0_NOME" ), .T. ), .F. )
				
		@ 016,040 MSGET _oGrpName Var _cGrpDesc SIZE _oDlg:nClientWidth/2-45,9 PICTURE PesqPict("SU0", "U0_NOME") OF _oDlg Pixel When .F.

		@ 032,005 SAY "Assunto:" PIXEL SIZE 55,9 OF _oDlg 
		@ 042,005 MSGET _oAssunto Var _cAssunto SIZE 030,9 PICTURE "@!" OF _oDlg Pixel F3 "SDK002" VALID ValAssunto( @_cDescAssunto )
				
		@ 042,040 MSGET _oDescAssunto Var _cDescAssunto SIZE _oDlg:nClientWidth/2-45,9 PICTURE "@!" OF _oDlg Pixel When .F.
                                                          
	    DEFINE SBUTTON FROM _oDlg:nClientHeight/2-30,005 TYPE 1 ENABLE OF _oDlg ACTION (_nOpc := 1, Iif( _lRet := ValAssunto( @_cDescAssunto ),_oDlg:End(),Nil)   )
	    DEFINE SBUTTON FROM _oDlg:nClientHeight/2-30,035 TYPE 2 ENABLE OF _oDlg ACTION (_nOpc := 2, _lRet := .F., _oDlg:End() )

		_oDlg:Activate(,,,.T.)    
		       
		_lRet := _lRet .And. _nOpc <> 0
		                        
		If _lRet

			// Valida se a combinacao de assunto/produto/categoria/origem/causa/efeito e campanha eh valida
			If Empty( _cAssunto )
				MsgAlert( "Informe um assunto válido para transferência do atendimento." )
			Else
				
				// Valida transferencia para grupos de liberacao de pagamento
				_lRet := VldLibPag( _cGrupo )                      
									
				// Efetiva a transferencia para o grupo e assunto
				If _lRet .And. TK510CombVld( _cAssunto, _cGrupo )
					Exit
				EndIf
				
			EndIf
			
		EndIf

	EndDo

	If _lRet .And. !Empty( _cGrupo ) .And. !Empty( _cAssunto )
	
		If MsgYesNo( "Confirma a transferência do chamado?", "Atenção" )
		 	
		 	eval({|x,y,z| z := GetArea(), Tk510TGrp( x, y ), RestArea(z) }, _cGrupo, _cOperador, aAreaAtual) 
			
			aAreaAtual := GetArea()			
			Tk510IncAcols(	"TMK001", "Chamado Transferido para área :" + _cGrpDesc,,_cOperador,;
							_cAssunto, _cProduto	, _cGrupo	, cCategoria,;
							cOrigem	, cCausa	, cEfeito	, cCampanha	,;
							.F.		)
			RestArea(aAreaAtual) 
		Else
			_lRet := .F.
		EndIf

	EndIf

EndIf

//Se cancelou, restaura variaveis de memoria
If !_lRet
	M->ADE_ASSUNT := _cAssuAnt
EndIf

Return _lRet  

      
/*
---------------------------------------------------------------------------
| Rotina    | AjustaSXB    | Autor | Gustavo Prudente | Data | 28.10.2013 |
|-------------------------------------------------------------------------|
| Descricao | Rotina para criação das consultas SXB para rotina de        |
|           | transferência customizada.                                  |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/        
Static Function AjustaSXB()
                                       
Local aSXB 	:= {}
Local nX	:= 0      
      
// Cria consulta SXB de grupos de atendimento
If ! SXB->( DbSeek( "SDK001" ) )
      
	aSXB := {}
                        
	AAdd( aSXB, { "SDK001", "1", "01", "DB", "Grupo de Atendimento"	, "SU0"				} )
	AAdd( aSXB, { "SDK001", "2", "01", "01", "Grupo"				, ""				} )
	AAdd( aSXB, { "SDK001", "2", "02", "02", "Descricao"			, ""				} )
	AAdd( aSXB, { "SDK001", "4", "01", "01", "Grupo"				, "U0_CODIGO"		} )
	AAdd( aSXB, { "SDK001", "4", "01", "02", "Descricao"			, "U0_NOME"			} )
	AAdd( aSXB, { "SDK001", "4", "02", "01", "Descricao"			, "U0_NOME"			} )
	AAdd( aSXB, { "SDK001", "4", "02", "02", "Grupo"				, "U0_CODIGO"  		} )
	AAdd( aSXB, { "SDK001", "5", "01", ""  , ""						, "SU0->U0_CODIGO"	} )

    For nX := 1 To Len( aSXB )
           
    	RecLock( "SXB", .T. )

	    SXB->XB_ALIAS  	:= aSXB[ nX, 1 ]
	    SXB->XB_TIPO	:= aSXB[ nX, 2 ]
	    SXB->XB_SEQ		:= aSXB[ nX, 3 ]
	    SXB->XB_COLUNA	:= aSXB[ nX, 4 ]
	    SXB->XB_DESCRI	:= aSXB[ nX, 5 ]
	    SXB->XB_CONTEM	:= aSXB[ nX, 6 ]
    	
    	SXB->( MsUnlock() )
    
    Next nX
    
EndIf
      
// Cria consulta SXB de assuntos x grupos
If ! SXB->( DbSeek( "SDK002" ) )
                              
	aSXB := {}
                        
	AAdd( aSXB, { "SDK002", "1", "01", "RE", "Assuntos x Grupos"   	, "SX5"  			} )
	AAdd( aSXB, { "SDK002", "2", "01", "01", "Codigo"              	, "U_CSTRAXBT1()"   } )
	AAdd( aSXB, { "SDK002", "5", "01", ""  , ""						, "SX5->X5_CHAVE"	} )

    For nX := 1 To Len( aSXB )
           
    	RecLock( "SXB", .T. )

	    SXB->XB_ALIAS  	:= aSXB[ nX, 1 ]
	    SXB->XB_TIPO	:= aSXB[ nX, 2 ]
	    SXB->XB_SEQ		:= aSXB[ nX, 3 ]
	    SXB->XB_COLUNA	:= aSXB[ nX, 4 ]
	    SXB->XB_DESCRI	:= aSXB[ nX, 5 ]
	    SXB->XB_CONTEM	:= aSXB[ nX, 6 ]
    	
    	SXB->( MsUnlock() )
    
    Next nX
    
EndIf

Return .T.

/*
---------------------------------------------------------------------------
| Rotina    | CSTRAXBT1    | Autor | Gustavo Prudente | Data | 28.10.2013 |
|-------------------------------------------------------------------------|
| Descricao | Consulta assuntos do grupo selecionado                      |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/        
User Function CSTRAXBT1()

Local _oDlg
Local oLbx1
Local aItems   := {}
Local nPosLbx  := 0
Local nPos     := 0
Local nAchou   := 0
Local _lRet     := .F.  
Local cChvAss  := ""
Local cFilSKK  := xFilial( "SKK" )
Local cArea    := Alias()

SKK->( DbSetOrder( 1 ) )
SKK->( DbSeek( cFilSKK + _cGrupo ) )

Do While SKK->( ! EoF() ) .And. SKK->KK_FILIAL == cFilSKK .And. SKK->KK_CODSU0 == _cGrupo
	cChvAss += "'" + AllTrim( SKK->KK_CODSKQ ) + "',"
	SKK->( DbSkip() )
EndDo
           
If !Empty( cChvAss )

	cChvAss := "%( " + SubStr( cChvAss, 1, Len( cChvAss ) - 1 ) + " )%"

	BeginSql Alias "TRBSX5"
	
		SELECT X5_CHAVE, X5_DESCRI 
		FROM %Table:SX5%
		WHERE 	X5_FILIAL = %xFilial:SX5% AND
				X5_TABELA = "T1" AND
				X5_CHAVE IN %Exp:cChvAss% AND
				%notDel%
		ORDER BY X5_CHAVE
	
	EndSql

	Do While ! TRBSX5->( EoF() )
		TRBSX5->( AAdd( aItems, { X5_CHAVE, X5_DESCRI } ) )
		TRBSX5->( DbSkip() )
	EndDo
	
	TRBSX5->( DbCloseArea() )   

EndIf
	
DbSelectArea( "ADE" )

If Len( aItems ) <= 0
   Help(" ",1,"REGNOIS")
   Return(_lRet)
Endif

DEFINE MSDIALOG _oDlg FROM 50,3 TO 260,730 TITLE "Assuntos x Grupos" PIXEL 

	@ 3,4 LISTBOX oLbx1 VAR nPosLbx FIELDS HEADER "Código do assunto", "Descrição do assunto" SIZE 355,80 OF _oDlg PIXEL

	oLbx1:SetArray( aItems )
	oLbx1:bLine := { || { aItems[ oLbx1:nAt, 1 ], aItems[ oLbx1:nAt, 2 ] } }
   	oLbx1:BlDblClick := { || ( _lRet:= .T., nPos:= oLbx1:nAt, _oDlg:End() ) }
	oLbx1:Refresh()
	oLbx1:nAt := 1
	
	DEFINE SBUTTON FROM 88, 300 TYPE 1 ENABLE OF _oDlg ACTION ( _lRet:= .T., nPos := oLbx1:nAt, _oDlg:End() )
	DEFINE SBUTTON FROM 88, 335 TYPE 2 ENABLE OF _oDlg ACTION ( _lRet:= .F., _oDlg:End() )

ACTIVATE MSDIALOG _oDlg CENTERED

If _lRet

   DbSelectarea( "SX5" )
   DbSetorder( 1 )
   If DbSeek( xFilial( "SX5" ) + "T1" + aItems[ nPos, 1 ] )
      _cAssunto := SX5->X5_CHAVE
      M->ADE_ASSUNT := _cAssunto                            
      _cDescAssunto	:= Posicione( "SX5", 1, xFilial( "SX5" ) + "T1" + _cAssunto, "SX5->X5_DESCRI")
   EndIf
   
EndIf
              
DbSelectArea( cArea )

Return( _lRet )

           
/*
---------------------------------------------------------------------------
| Rotina    | ValAssunto   | Autor | Gustavo Prudente | Data | 29.10.2013 |
|-------------------------------------------------------------------------|
| Descricao | Valida assunto informado                                    |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/        
Static Function ValAssunto( _cDescAssunto )
           
Local _lRet := .F.                 
Local cFilSKK  := xFilial( "SKK" )

SKK->( DbSetOrder( 1 ) )
SKK->( DbSeek( cFilSKK + _cGrupo ) )


Do While SKK->( ! EoF() ) .And. SKK->KK_FILIAL == cFilSKK .And. SKK->KK_CODSU0 == _cGrupo
	If ! Empty( _cAssunto ) .AND. AllTrim(_cAssunto) == AllTrim(SKK->KK_CODSKQ)
		If ExistCpo( "SX5", "T1" + _cAssunto )
			M->ADE_ASSUNT	:= _cAssunto
			_cDescAssunto	:= Posicione( "SX5", 1, xFilial( "SX5" ) + "T1" + _cAssunto, "SX5->X5_DESCRI")
		_lRet := .T.
		EndIf
	EndIf
	SKK->( DbSkip() )
EndDo

if !_lRet
alert("Por favor, selecionar um assunto dentro do grupo de atendimento !","Falha ao localizar assunto")
endif

Return _lRet

/*
-------------------------------------------------------------------------------
| Rotina     | VldLibPag      | Autor | Gustavo Prudente | Data | 05.06.2014  |
|-----------------------------------------------------------------------------|
| Descricao  | Valida se foi preenchido pedido GAR ou pedido Site antes de    |
|            | transferir para o grupo de liberacao de pagamento              |
|-----------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                            |
-------------------------------------------------------------------------------
*/
Static Function VldLibPag( _cGrupo )
              
Local _lRet		:= .T.
Local cGrpProc	:= GetNewPar( "MV_XGRPLPG", "" )

// Compara grupo passado como parametro com os grupos de liberacao de pagamento
If _cGrupo $ cGrpProc

	// Se nao informou pedido GAR nem pedido Site, nao permite a transferencia 
	
	// Adequação para validar se é uma solicitação de atendimento - Claudio Henrique Corrêa
	
	If Select("_ADE") > 0
		DbSelectArea("_ADE")
		DbCloseArea("_ADE")
	End If
	
	cQryADE := "SELECT ADE_OS, ADE_CODIGO "
	cQryADE += " FROM "+RetSqlName("ADE")
	cQryADE += " WHERE D_E_L_E_T_ = '' "
	cQryADE += " AND ADE_CODIGO = '"+ADE->ADE_CODIGO+"'"
	cQryADE := changequery(cQryADE)
				
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQryADE),"_ADE",.F.,.T.)
	
	dbSelectArea("PA0")
	
	dbSetOrder(1)
	
	dbSeek(xFilial("PA0")+_ADE->ADE_OS)
	
	if Found()
	    
		_lRet := .T.
	
	Else	
	
		If Empty( M->ADE_PEDGAR ) .And. Empty( M->ADE_XPSITE )
		
		    MsgAlert( "Transferência não realizada. Informe o número do Pedido GAR ou Pedido Site no atendimento e tente novamente." )
			_lRet := .F.
		
		EndIf
		
	Endif	

EndIf

Return( _lRet )