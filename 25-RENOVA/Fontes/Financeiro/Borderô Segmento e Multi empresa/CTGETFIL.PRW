#Include 'Protheus.ch'


////////////////////////////////////////////////////////////////////////////////////
//                                                                                //
//  Função:    CTGETFIL 										Módulo: SIGAFIN   //
//                                                                                //
//  Autor:     Denis Guedes  							Data: 30/05/2015          //
//                                                                                //
//  Descrição: Pontos de Entrada na geração do Borderô a fim selecionar           //
//             as empresas para a geração do borderô                              //
//                                                                                //
////////////////////////////////////////////////////////////////////////////////////


User Function CTGETFIL()


Local aFil := ParamIxb[1]
//MsgInfo("Ponto de Entrada CTGETFIL - Adicionando filiais ao array das filiais selecionadas")
//aAdd(aFil, "03" ) // adicionar filial 03 ao arrayReturn(aFil)
Public _Cont := 1

If IsInCallStack("FINA240") .Or. IsInCallStack("FINA241")
	If Alltrim(CMODPGTO) == "ZU"
		aFil := zAdmGetFil(.T.,.F.,"SE2")
		Return(aFil)       
	EndIf
EndIf                      

Return

Static Function zADMGETFIL(lTodasFil,lSohFilEmp,cAlias,lSohFilUn,lHlp)                                  

Local cEmpresa 	:= cEmpAnt
Local cTitulo	:= ""
Local MvPar		:= ""
Local MvParDef	:= ""
Local nI 		:= 0
Local aArea 	:= GetArea() 					 // Salva Alias Anterior 
Local nReg	    := 0
Local nSit		:= 0
Local aSit		:= {}
Local aFil 		:= {}	
Local nTamFil	:= Len(xFilial("CT2"))
Local lDefTop 	:= IIF( FindFunction("IfDefTopCTB"), IfDefTopCTB(), .F.) // verificar se pode executar query (TOPCONN)
Local nInc		:= 0    
Local aSM0		:= AdmAbreSM0()
Local aFilAtu	:= {}
//Local lPEGetFil := ExistBlock("CTGETFIL")
Local aFil_Ant   
Local lFWCodFil := FindFunction( "FWCodFil" )
Local lGestao	:= AdmGetGest()
Local lFWCompany := FindFunction( "FWCompany" )
Local cEmpFil 	:= " "
Local cUnFil	:= " "
Local nTamEmp	:= 0
Local nTamUn	:= 0
Local lOk		:= .T.

Default lTodasFil 	:= .F.
Default lSohFilEmp 	:= .F.	//Somente filiais da empresa corrente (Gestao Corporativa)
Default lSohFilUn 	:= .F.	//Somente filiais da unidade de negocio corrente (Gestao Corporativa)
Default lHlp		:= .T.
Default cAlias		:= ""

/*
Defines do SM0
SM0_GRPEMP  // C?igo do grupo de empresas
SM0_CODFIL  // C?igo da filial contendo todos os n?eis (Emp/UN/Fil)
SM0_EMPRESA // C?igo da empresa
SM0_UNIDNEG // C?igo da unidade de neg?io
SM0_FILIAL  // C?igo da filial
SM0_NOME    // Nome da filial
SM0_NOMRED  // Nome reduzido da filial
SM0_SIZEFIL // Tamanho do campo filial
SM0_LEIAUTE // Leiaute do grupo de empresas
SM0_EMPOK   // Empresa autorizada
SM0_GRPEMP  // C?igo do grupo de empresas 
SM0_USEROK  // Usu?io tem permiss? para usar a empresa/filial
SM0_RECNO   // Recno da filial no SIGAMAT
SM0_LEIAEMP // Leiaute da empresa (EE)
SM0_LEIAUN  // Leiaute da unidade de neg?io (UU)
SM0_LEIAFIL // Leiaute da filial (FFFF)
SM0_STATUS  // Status da filial (0=Liberada para manuten?o,1=Bloqueada para manuten?o)
SM0_NOMECOM // Nome Comercial
SM0_CGC     // CGC
SM0_DESCEMP // Descricao da Empresa
SM0_DESCUN  // Descricao da Unidade
SM0_DESCGRP // Descricao do Grupo
*/

//Caso o Alias n? seja passado, traz as filiais que o usuario tem acesso (modo padrao)
lSohFilEmp := IF(Empty(cAlias),.F.,lSohFilEmp)
lSohFilUN  := IF(Empty(cAlias),.F.,lSohFilUn) .And. lSohFilEmp

//Caso use gest? corporativa , busca o codigo da empresa dentro do M0_CODFIL
//Em caso contrario, , traz as filiais que o usuario tem acesso (modo padrao)
cEmpFil := IIF(lGestao .and. lFwCompany, FWCompany(cAlias)," ")
cUnFil  := IIF(lGestao .and. lFwCompany, FWUnitBusiness(cAlias)," ")

//Tamanho do codigo da filial
nTamEmp := Len(cEmpFil)
nTamUn  := Len(cUnFil) 

If lDefTop
	If !IsBlind()
		PswOrder(1)
		If PswSeek( __cUserID, .T. )

			aSit		:= {}
			aFilNome	:= {}
			aFilAtu		:= FWArrFilAtu( cEmpresa, cFilAnt )
			If Len( aFilAtu ) > 0
				cTxtAux := IIF(lGestao,"Empresa/Unidade/Filial de ","Filiais de ")
				cTitulo := cTxtAux + AllTrim( aFilAtu[6] )
			EndIf

			// Adiciona as filiais que o usuario tem permiss?
			For nInc := 1 To Len( aSM0 ) 
			lOk := .T.
				//DEFINES da SMO encontra-se no arquivo FWCommand.CH
				//Na fun?o FWLoadSM0(), ela retorna na posicao [SM0_USEROK] se esta filial ?v?ida para o user  
				If (aSM0[nInc][SM0_GRPEMP] == cEmpAnt .And. ((ValType(aSM0[nInc][SM0_EMPOK]) == "L" .And. aSM0[nInc][SM0_EMPOK]) .Or. ValType(aSM0[nInc][SM0_EMPOK]) <> "L") .And. aSM0[nInc][SM0_USEROK] )
					
					//Verificacao se as filiais a serem apresentadas serao 
					//Apenas as filiais da empresa conrrente (M0_CODFIL)
					If lGestao .and. lFwCompany .and. lSohFilEmp
						//Se for exclusivo para empresa
						If !Empty(cEmpFil)
							lOk := IIf(cEmpFil == Substr(aSM0[nInc][2],1,nTamEmp),.T.,.F.)
							/*
							Verifica se as filiais devem pertencer a mesma unidade de negocio da filial corrente*/
							If lOk .And. lSohFilUn
								//Se for exclusivo para unidade de negocio
								If !Empty(cUnFil)
									lOk := IIf(cUnFil == Substr(aSM0[nInc][2],nTamEmp + 1,nTamUn),.T.,.F.)
								Endif
							Endif
						Else
							//Se for tudo compartilhado, traz apenas a filial corrente	
							lOk := IIf(cFilAnt == aSM0[nInc][SM0_CODFIL],.T.,.F.)
						Endif
					Endif

					//Denis
					
					If lOk 
						_Grupo := aSM0[nInc][1]
						_Emp   := aSM0[nInc][3]
						_Und   := aSM0[nInc][4]
						_Fil   := aSM0[nInc][5]
						z03->(dbsetorder(1))
						z03->(DBSeek( xfilial("Z03") + _Grupo + _Emp + _Und   )) 

						lOk := !empty(Alltrim(z03->z03_NUMCON)) .And. !empty(Alltrim(z03->z03_FILCON))
					EndIf
						
  
					
					If lOk
						AAdd(aSit, {aSM0[nInc][SM0_CODFIL],aSM0[nInc][SM0_NOMRED],Transform(aSM0[nInc][SM0_CGC],PesqPict("SA1","A1_CGC"))})
						MvParDef += aSM0[nInc][SM0_CODFIL]
						nI++
					Endif
				Endif
				
			Next
			If Len( aSit ) <= 0
				// Se n? tem permiss? ou ocorreu erro nos dados do usuario, pego a filial corrente.
				Aadd(aSit, aFilAtu[2]+" - "+aFilAtu[7] )
				MvParDef := aFilAtu[2]
				nI++
			EndIf
		EndIf
		
		aFil := {}
		IF AdmOpcoes(@MvPar,cTitulo,aSit,MvParDef,,,.F.,nTamFil,nI,.T.,,,,,,,,.T.)  // Chama funcao Adm_Opcoes
			nSit := 1 
			For nReg := 1 To len(mvpar) Step nTamFil  // Acumula as filiais num vetor 
				If SubSTR(mvpar, nReg, nTamFil) <> Replicate("*",nTamFil)
			 		AADD(aFil, SubSTR(mvpar, nReg, nTamFil) ) 
				endif	
				nSit++
			next
			If Empty(aFil) .And. lHlp 
	 	  		Help(" ",1,"ADMFILIAL",,"Por favor selecionar pelo menos uma filial",1,0)		//"Por favor selecionar pelo menos uma filial"
			EndIF
			
			If Len(aFil) == Len(aSit)
				lTodasFil := .T.	
			EndIf 
		Endif
	Else
		aFil := {cFilAnt}
	EndIf	

	//ponto de entrada para usuario poder manipular as filiais selecionada 
	//por exemplo para um usuario especifico poderia adicionar uma filial que normalmente nao tem acesso
  /*
  	If lPEGetFil
		aFil_Ant := aClone(aFil)
		aFil := ExecBlock("CTGETFIL",.F.,.F.,{aFil})
		If aFil == NIL .Or. Empty(aFil)
			aFil := aClone(aFil_Ant)
		EndIf
	EndIf
	*/
		
Else
	Help("  ",1,"ADMFILTOP",,"Função disponíel apenas para ambientes TopConnect",1,0) //"Fun?o dispon?el apenas para ambientes TopConnect"
EndIf
	
RestArea(aArea)  

Return(aFil) 

Static Function AdmGetGest() 
Local lFWCodFil := FindFunction( "FWCodFil" )
Return Iif( lFWCodFil, ( "E" $ FWSM0Layout() .And. "U" $ FWSM0Layout() ), .F. )

