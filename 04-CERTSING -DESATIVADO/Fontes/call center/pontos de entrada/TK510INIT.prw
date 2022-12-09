#include "PROTHEUS.ch"

/*
---------------------------------------------------------------------------
| Rotina    | TK510INIT    | Autor | Gustavo Prudente | Data | 30.10.2014 |
|-------------------------------------------------------------------------|
| Descricao | Ponto de entrada para tratamento de regras ao alterar um    |
|           | atendimento.                                                |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
User Function TK510INIT
	Local nCodPos	:= 0
	Local cOperador	:= ""
	Local cGrpAss	:= "2"
	Local cGrpOper	:= ""
	Local lUsrSup	:= .F.
	Local aArea		:= {}
	Local aCabec 	:= {}
	Local aItens 	:= {}
	Local aLinha 	:= {}
	Local codChama	:= ""
	Local nI 		:= 0
	Local nElem		:= 0
	Local cGrupo := ''
	Local cMV_TK510INI := 'MV_TK510IN'
	Local aRet 		:= {}
	Private aPar 	:= {}
	PRIVATE lMsErroAuto := .F.

	If .NOT. SX6->( ExisteSX6( cMV_TK510INI ) )
		CriarSX6( cMV_TK510INI, 'C', 'Grupos que nao podem alterar/deletar o registros do atendimento. TK510INIT.prw',;
		"19,20,21,22,23,24,25,26,27,28,29,30,31,32,35,36,38,42,46,48,49,51,52,53,54,55,56,57,58,59,60,70,76,78,79,97,98,99,9E,9W" )
	Endif

	cGrupo := GetMv( cMV_TK510INI )

	// Se nao for inclusao, inicia atribuicao do atendimento ao operador
	If	ParamIxb[1] != 3

		aArea := GetArea()

		// Posiciona tabela de atendimentos
		DbSelectArea( "ADE" )
		DbSetOrder( 1 )		// ADE_FILIAL + ADE_CODIGO
		DbSeek( xFilial("ADE") + M->ADE_CODIGO )

		// Retorna o grupo do operador e se o grupo assume atendimento automaticamente
		If SU0->( FieldPos( "U0_XASSAUT" ) > 0 )
			cGrpOper := u_RTmkRetGrp()
			cGrpAss  := Posicione( "SU0", 1, xFilial( "SU0" ) + cGrpOper, "U0_XASSAUT" )
		EndIf

		// Se nao for inclusao e o grupo assume automaticamente, inicia atribuicao do atendimento ao operador
		If cGrpAss == "1"
		
			//Renato Ruy - 06/01/17
			//Possibilita ao supervisor alterar proprietario do atendimento
			//Solicitante: Ana Paula Alves
			lUsrSup	 := AllTrim(ADE->ADE_GRUPO) $ GetNewPar("MV_XALTOPR", "22") .And.;
						Posicione( "SU7", 1, xFilial("SU7") + TkOperador(), "U7_TIPO" ) == "2" .And.;
						ParamIXB[1] == 4
						
            
			If lUsrSup .And. !Empty( ADE->ADE_OPERAD ) 			
				//Utilizo parambox para fazer a pergunta
				aAdd( aPar,{ 1  ,"Operador " 	 ,ADE->ADE_OPERAD	,"","","SU7","",50,.F.})
				aAdd( aPar,{ 3  ,"Desvincular" 	 ,1			  	  	,{"Não","Sim"} ,50,"",.F.})
				
				ParamBox( aPar, 'Selecione um operador', @aRet, {|| .T. }, , , , , ,"XTK510A" , .T., .F. )
				
				//Se o usuario não cancelou, faz a alteração
				If Len(aRet)>0
					RecLock( "ADE", .F. )
					ADE->ADE_OPERAD := Iif(aRet[2]==1,aRet[1],"")
					ADE->( MsUnlock() )
				Endif			
			
			EndIf
			
			// Se o atendimento nao esta com nenhum operador, atribui atendimento
			If Empty( ADE->ADE_OPERAD ) .And. Len(aRet) == 0

				// Grava dados do operador no atendimento
				cOperador := TkOperador()

				TK510UsrLock( "L", M->ADE_CODIGO, cOperador )

				RecLock( "ADE", .F. )
				ADE->ADE_OPERAD := cOperador
				ADE->ADE_GRUPO  := Posicione( "SU7", 1, xFilial("SU7") + cOperador, "U7_POSTO" )
				ADE->ADE_XSTOPE := "1"	// Atendimento atribuido ao operador
				ADE->( MsUnlock() )

			EndIf

			/*
			Inclusão automatica de linha de atendimento (forçar o registro do inicio do atendimento)
			OTRS = 2014122610000438
			*/
			if	ADE->ADE_GRUPO $ "/03/96/17/11/10/05/14/18/" .and. ParamIxb[1] = 4
				OCORRENCIA := "007122"
				codsuq := POSICIONE("SUR",1,XFILIAL("SUR")+OCORRENCIA+'0000001'+'0000002',"UR_CODSOL")
				AAdd( aCOLS, Array( Len( aHeader )+1 ) )
				nElem := Len( aCOLS )							//posicionar no registro
				
				For nI := 1 To Len( aHeader )-2
					IF  EMPTY(aHeader[ nI, 12]) 	
						DO CASE
						   CASE ValType(aHeader[ nI, 2 ]) = "N"
						  	 aCOLS[ nElem, nI ] :=  0    
			          	   CASE ValType(aHeader[ nI, 2 ]) = "C"
			          	  	 aCOLS[ nElem, nI ] :=  SPACE(TAMSX3(aHeader[ nI, 2] )[1])
			          	ENDCASE
			        ELSE
			          		aCOLS[ nElem, nI ] := &(aHeader[ nI, 12])
					ENDIF
				Next nI
				aCOLS[ nElem, Len(aHeader)-1 ] := ""
				aCOLS[ nElem, Len(aHeader) ]   := 0
				aCOLS[ nElem, Len(aHeader)+1 ] := .F.
				
				// campos de preenchimento manual.
				ACOLS[nElem][aScan(AHEADER, { |x| Upper(AllTrim(x[2])) == "ADF_ITEM"})]   := strzero(val(ADF->ADF_ITEM)+1,3)
				ACOLS[nElem][aScan(AHEADER, { |x| Upper(AllTrim(x[2])) == "ADF_CODSU9"})] := OCORRENCIA
				ACOLS[nElem][aScan(AHEADER, { |x| Upper(AllTrim(x[2])) == "ADF_NMSU9"})]  := POSICIONE("SU9",2,XFILIAL("SU9")+OCORRENCIA,"U9_DESC")       						     
	
			endif

		endif
		//+---------------------------------------------------------*
		//| Autor | Rafael Beghini | Data | 10.06.2016              |
		//+---------------------------------------------------------+
		//| Não permite deletar o registro. Otrs [2016060810000686] |
		//+---------------------------------------------------------+
		IF ADE->ADE_GRUPO $ cGrupo
			oGetD:lDelete := .F.
			oGetD:oBrowse:bDelete := {|| Alert('Não é possível deletar o registro') }
		EndIF

		RestArea( aArea )
	EndIf

Return( .T. )