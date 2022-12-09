#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหออออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ PESQCONT  บ Autor  ณ Gustavo / Warleson บ Data ณ 15/01/13    บฑฑ
ฑฑฬออออออออออุอออออออออออสออออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Permite realizar consulta de contatos e historico.           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P10 - Certisign                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PesqCont( cOrigem, lDebug )

Local oDlg1,oBtn2,oPanel2,oBtn5,oBtn6,oBtn7,oBtn8,oBtn9,oBtn10,oBtn11,oBtn12,oBtn13

Local aPos		:= {}
Local aCPos		:= {}
Local oFont1	:= TFont():New('Segoe UI',,-12)
Local oFont2	:= TFont():New('Arial',,-14)
//Local nTam1		:=186  //Original
//Local nTam2		:=155  //Original

//*_______Inํcio Variaveis Grupo de Pesquisa_______ 

Local nTam1		:=177            
Local nTam2		:=155
Local cTheme := PtGetTheme()
Local nStatus :=0
Local _nLin:=0
Local cPicCPF	:= ""
Local nRemoteType	:= GetRemoteType() 	
Local nLinBtn	:= 0    

Private aBusca		:= aClone(AbasPesquisa()) 
Private _cAlias		:= ''
Private _cCodEnt	:= ''
Private _cLojaEnt	:= ''
Private	lTesta		:= .T.
Private oGrpAbas
Private oPnlAbas
Private oSay1,oSay2,oSay3,oSay4,oSay5,oSay6
Private oSay7,oSay8,oSay9,oSay10,oSay11,oSay12
Private oBtn1Abas,oBtn2Abas,oBtn3Abas,oBtn4Abas
Private oBtn14,oBtn15,oBtn16,oBtn17,oBtn18

//*_______Fim Variaveis Grupo de Pesquisa________

Private oGp1,oGp2,oGp3,oGp4,oGp5,oPesq,oBtn1,oBtn3,oPanel1,oPanel2,oPanel3,oPanel4,oPanel5,oPanel16, oFld1,oPanelList,oListResult,oSayR,oBtn4,oFld2,oFld3,oFld4
Private oGet1,oGet2,oGet3,oGet4,oGet5,oGet6,oGet7,oGet8,oGet9,oGet10,oGet11,oGet12
Private oPanelSus, oGrpSus, oBtnSus

Private aCHaves		:= {}                
 
//Entidade
Private cGet1		:= "" // Nome
Private cGet2		:= "" // DDD
Private cGet3		:= "" // CGC
Private cGet4		:= "" // E-mail
Private cGet5		:= "" // Status
Private cGet6		:= "" // Telefone
//Contato
Private cGet7		:= "" // Nome
Private cGet8		:= "" // DDD
Private cGet9		:= "" // Telefone
Private cGet10		:= "" // CGC
Private cGet11		:= "" // Email
Private cGet12		:= "" // Status

Private cPesq		:= 'PESQUISAR POR '+UPPER(Substr(aBusca[1],2,len(aBusca[1])))+'...'+space(200)
PRivate aPesqResult	:= { {{"", "", "",""}}}
PRivate aContatos	:= {{"",""}}
Private nAtu		:=1
Private nOld		:=2
PRivate aLegendas	:= {{'TEXTLEFT','ESQTIC'},{'TEXTCENTER','CENTIC'},{'TEXTRIGHT','DIRTIC'},{'TEXTJUSTIFY','JUSTIC'}}
Private nCountPesq	:= 0 //Qtd de registro retornado na pesquisa
Private	aNewTabs 	:= {'1'} 

Private oLtContatos
Private aRecno		:= { { '1SA1', 0, 'SA1', 'CLIENTE'     }, ;
					     { '2SUS', 0, 'SUS', 'PROSPECT'    }, ;
						 { '3ACH', 0, 'ACH', 'SUSPECT'     }, ;
						 { '4SU5', 0, 'SU5', 'CONTATO'     }, ;
						 { '5SZT', 0, 'SZT', 'COMMON NAME' }, ;
						 { '6SZ3', 0, 'SZ3', 'POSTOS'      } }

Private aTotalPesq	:= { 0, 0, 0, 0, 0, 0 }

Private cEntidades := ""

Private nLin:= 0 
Private lAc8Entidade:= .F.

Default cOrigem		:= "ADE"
Default lDebug		:= .F.
                     
	If nRemoteType # 5
		aPos  := {9,4,521,789}
	Else
		aPos  := {9,4,500,789}
	EndIf

	aCPos := {(49*(Apos[4]-Apos[2])/100),(44.7*(Apos[3]-Apos[1])/100)+1}
	                              
	// Define os campos das entidades serao pesquisados 
	aAdd( aChaves, { "A1_NOME"   , "A1_TEL"  , "A1_CGC"		, "A1_EMAIL"  	, "A1_HPAGE" , "A1_DDD"  } )	// Cliente
	aAdd( aChaves, { "US_NOME"   , "US_TEL"  , "US_CGC"		, "US_EMAIL"  	, "US_URL"   , "US_DDD"  } )	// Prospect
	aAdd( aChaves, { "ACH_RAZAO" , "ACH_TEL" , "ACH_CGC"	, "ACH_EMAIL" 	, "ACH_URL"  , "ACH_DDD" } )	// Suspect
	aAdd( aChaves, { "U5_CONTAT" , "U5_FCOM1", "U5_CPF"		, "U5_EMAIL"  	, "U5_URL"   , "U5_DDD"  } )	// Contatos
	aAdd( aChaves, { "ZT_EMPRESA", "ZT_FONE" , "ZT_CNPJ"	, "ZT_CONTTEC"	, "ZT_COMMON", ""        } )	// Common Name
	aAdd( aChaves, { "Z3_DESENT" , "Z3_TEL"  , "Z3_CGC"		, ""			, ""		 , "Z3_DDD"	 } )	// Postos de Atendimento
	
	If ldebug
		PREPARE ENVIRONMENT EMPRESA '01' FILIAL '02'
	Endif
               
	cGrpSZ3		:= GetNewPar( "MV_XGRPSZ3", "26/38/97/99" )
   
		cEntidades	:=''
	If Type("M->ADE_GRUPO") <> "U" .and. AllTrim( M->ADE_GRUPO ) $ cGrpSZ3
		cEntidades	:= " 'SZ3' " 
	Else
	    cEntidades	:= " 'SA1', 'SUS', 'ACH', 'SU5', 'SZT', 'SZ3' "  
    Endif
	
	oDlg1   := MSDialog():New(Apos[1],Apos[2],Apos[3],Apos[4],"Service Desk [Pesquisa Base de Chamados]",,,.F.,,rgb(0,50,100),rgb(241,241,251),,,.T.,,,.T. )
	oDlg1:SetFont(oFont1)

    *____________________________________________________________________________________________________________________________
    //Folder1
//	oFld1   := TFolder():New(5,4,{"&Pesquisar","Con&figura็๕es"},,oDlg1,,,,.T.,,aCPos[1],aCPos[2]) 
	oFld1   := TFolder():New(5,4,{"&Pesquisar"},,oDlg1,,,,.T.,,aCPos[1],aCPos[2]) 
	oFld1:BCHANGE:={||ExibeConf()}

	@ 50,14 MSGET oPesq Var cPesq PICTURE "@!" SIZE 316,10 PIXEL OF oDlg1 VALID (ValidaPesquisa(cPesq))
	oPesq:bGotFocus	:={||oFld4:SetOption(1)}
	oBtn3   := TButton():New(49,335,"&Buscar",oDlg1,{||nOld:=nAtu,nAtu:=1,loadBitmaps(),buscar(alltrim(cPesq)+'%')},041,014,,,,.T.,,"",,,,.F. )

	If nRemoteType # 5
		oBtn3:SetCss("QPushButton{}")
	EndIf
	
	@ 045,004 MSPANEL oPanelList SIZE 195,106972 OF oFld1:aDialogs[1] COLORS 0,RGB(255,255,255)
  	  	oGp1:= tGroup():New(0,00,165,181.5,'Resultado',oPanelList,,,.T.)
    
   *________________________________Inํcio Grupo de Pesquisa ____________________________________________________________________________
    
	if 'MDI'$cTheme
	    @ 04,160 MSPANEL oPnlAbas SIZE 23,51.5 OF oPanelList COLORS 0,RGB(255,255,255)	
	   	oGrpAbas := TGroup():New(003.5,180,068-12,193,"",oPanelList,,,.T.,.F. )	 	 
	Else
	    @ 004.5,167 MSPANEL oPnlAbas SIZE 22,50.5 OF oPanelList COLORS 0,RGB(255,255,255)	
	   	oGrpAbas := TGroup():New(004,179.5,068-12,193,"",oPanelList,,,.T.,.F. )	 	 
    endif

	oBtn1Abas := TBtnBmp2():New( 18, 359, 25, 25, 'TEXTLEFT'    , , , ,{||nOld:=nAtu,nAtu:=1,loadBitmaps(),buscar(alltrim(cPesq)+'%')} ,oGrpAbas,, , )
	oBtn2Abas := TBtnBmp2():New( 40, 359, 25, 25, 'TEXTCENTER'	, , , ,{||nOld:=nAtu,nAtu:=2,loadBitmaps(),buscar('%'+alltrim(cPesq)+'%')}	,oGrpAbas,, , )
	oBtn3Abas := TBtnBmp2():New( 62, 359, 25, 25, 'TEXTRIGHT' 	, , , ,{||nOld:=nAtu,nAtu:=3,loadBitmaps(),buscar('%'+alltrim(cPesq))}		,oGrpAbas,, , )
	oBtn4Abas := TBtnBmp2():New( 84, 359, 25, 25, 'TEXTJUSTIFY'	, , , ,{||nOld:=nAtu,nAtu:=4,loadBitmaps(),buscar('%'+StrTran(alltrim(cPesq),' ','%')+'%')},oGrpAbas,, , )

	loadBitmaps()

   	//*__________________________________Fim Grupo de PEsquisa ____________________________________________________________________________

		oFld3:= Tabview():New(10,2,aNewTabs,{||Novaaba()},@oGp1,1,{0,64,128},.F.,nTam1,nTam2)	  		

  		oPanel:= tPanelCss():New(0,0,"",oFld3:oAreaView,,.F.,.F.,,,nTam1,(nTAm2-18),.F.,.F.)

		@ 0,0 LISTBOX oListResult FIELDS HEADER "Status","   " SIZE nTam1+8,(nTAm2-18) OF oPanel PIXEL 
		oListResult:lUseDefaultColors:=.T.
		oListResult:LHSCROLL:=.F.
		oListResult:LVSCROLL:=.F.
		oListResult:bchange:={||PopulaEntidade()}
		oListResult:SetArray( aPesqResult[len(aPesqResult)] )

		If len(aPesqResult[len(aPesqResult)]) = 0
			oListResult:bLine:={|| { "", "", "",""} }
		Else
			oListResult:bLine:={||{ aPesqResult[len(aPesqResult)][oListResult:nAt,1],;
									aPesqResult[len(aPesqResult)][oListResult:nAt,2],;
									aPesqResult[len(aPesqResult)][oListResult:nAt,3],;
									aPesqResult[len(aPesqResult)][oListResult:nAt,4] }}
			PopulaEntidade()
		EndIf

	oGp2:= tGroup():New(040,199,111,379,'Entidade' ,oFld1:aDialogs[1],,,.T.)
	oPanel4	:= tPanel():New(47,201,'',oFld1:aDialogs[1],,,,,,176,62)
    
	oSay1	:= tSay():New(02,2,{||'Nome'		},oPanel4,,,,,,.T.,rgb(0,0,0),,35,8)
	oSay2	:= tSay():New(12,2,{||'DDD'		},oPanel4,,,,,,.T.,rgb(0,0,0),,35,8)
	oSay6	:= tSay():New(22,2,{||'Telefone'	},oPanel4,,,,,,.T.,rgb(0,0,0),,35,8)
	oSay3	:= tSay():New(32,2,{||'CPF/CNPJ'	},oPanel4,,,,,,.T.,rgb(0,0,0),,35,8)
	oSay4	:= tSay():New(42,2,{||'E-mail'		},oPanel4,,,,,,.T.,rgb(0,0,0),,35,8)
	oSay5	:= tSay():New(52,2,{||'Status'		},oPanel4,,,,,,.T.,rgb(0,0,0),,35,8)			

	@ 01,30 MSGET oGet1 Var cGet1 PICTURE "@!" SIZE 146,8 PIXEL OF oPanel4 READONLY
	@ 11,30 MSGET oGet2 Var cGet2 PICTURE "@!" SIZE 146,8 PIXEL OF oPanel4 READONLY 
	@ 21,30 MSGET oGet6 Var cGet6 PICTURE "@!" SIZE 146,8 PIXEL OF oPanel4 READONLY 
	@ 31,30 MSGET oGet3 Var cGet3 PICTURE "@!" SIZE 146,8 PIXEL OF oPanel4 READONLY 
	@ 41,30 MSGET oGet4 Var cGet4 PICTURE "@!" SIZE 146,8 PIXEL OF oPanel4 READONLY 
	@ 51,30 MSGET oGet5 Var cGet5 PICTURE "@!" SIZE 146,8 PIXEL OF oPanel4 READONLY 

	oFld4 := TFolder():New(108,199,{"Contatos","Detalhes"},,oFld1:aDialogs[1],,,,.T.,,210,102) 
	oFld4:HidePage(2) ///Oculta aba 2, detalhes	
	oFld4:BCHANGE:={||IIF(lTesta,(detalhes(.F.),NovoContato(.F.)),lTesta:=.T.)}

	@ 1.5,1 LISTBOX oLtContatos FIELDS HEADER "Codigo","Nome" SIZE 175,64 OF oFld4:aDialogs[1] PIXEL 

	oLtContatos:lUseDefaultColors:=.T.
	oLtContatos:LHSCROLL:=.F.

	//oLtContatos:bchange:={||}
	oLtContatos:SetArray(aContatos)

	If len(aContatos) = 0
		oLtContatos:bLine:={|| { "", ""} }
	Else
		oLtContatos:bLine:={||{	aContatos[oLtContatos:nAt,1],;
								aContatos[oLtContatos:nAt,2]}}
	EndIf
	oPanel5	:= tPanel():New(67,0,'',oFld4:aDialogs[1],,,,,rgb(241,241,251),178,11.5)
	oPanel6	:= tPanel():New(67,0,'',oFld4:aDialogs[2],,,,,rgb(241,241,251),178,11.5)

	oBtn14 := TButton():New(0,0.5,"Detalhes",oPanel5,{||detalhes(.T.),restauraObjetos(),PopulaDetalhes(aContatos[oLtContatos:nAt,3])},035,11,,,,.T.,,"",,,,.F. )
	oBtn15 := TButton():New(0,35.5,"Novo",oPanel5,{||detalhes(.T.),NovoContato()},035,11,,,,.T.,,"",,,,.F. )
	oBtn16 := TButton():New(0,0.5 ,"Novo",oPanel6,{||detalhes(.T.),NovoContato()},035,11,,,,.T.,,"",,,,.F. )
	oBtn17 := TButton():New(0,35.5,"Editar",oPanel6,{||detalhes(.T.),PopulaNovo(.F.)},035,11,,,,.T.,,"",,,,.F. )
	oBtn18 := TButton():New(0,70.5,"Salvar",oPanel6,{||grava_contato(),restauraObjetos(),detalhes(.T.),oLtContatos:Refresh()},035,11,,,,.T.,,"",,,,.F. )

	If nRemoteType # 5
		oBtn14:SetCss("QPushButton{}")
		oBtn15:SetCss("QPushButton{}")		                                                                   
		oBtn16:SetCss("QPushButton{}")                                                                           
		oBtn17:SetCss("QPushButton{}")
		oBtn18:SetCss("QPushButton{}")		
	EndIf	

    *____________________________________________________________________________________________________________________________
   
	//Detalhes
	                 
	cPicCPF := Replicate( "9", TamSX3( "U5_CPF" )[1] )
	
	oPanel7	:= tPanel():New(1.5,1,'',oFld4:aDialogs[2],,,,,rgb(241,241,251),176,64)
	
	oSay7	:= tSay():New(02,2,{||'Nome'	},oPanel7,,,,,,.T.,rgb(0,0,0),,35,8)
	oSay8	:= tSay():New(12,2,{||'DDD'		},oPanel7,,,,,,.T.,rgb(0,0,0),,35,8)
	oSay9	:= tSay():New(22,2,{||'Telefone'},oPanel7,,,,,,.T.,rgb(0,0,0),,35,8)
	oSay10	:= tSay():New(32,2,{||'CPF'     },oPanel7,,,,,,.T.,rgb(0,0,0),,35,8)
	oSay11	:= tSay():New(42,2,{||'E-mail'	},oPanel7,,,,,,.T.,rgb(0,0,0),,35,8)
	oSay12	:= tSay():New(52,2,{||'Status'	},oPanel7,,,,,,.T.,rgb(0,0,0),,35,8)			

	@ 01,30 MSGET oGet7  Var cGet7  PICTURE "@!"  			SIZE 146,8 PIXEL OF oPanel7 READONLY
	@ 11,30 MSGET oGet8  Var cGet8  PICTURE "999" 			SIZE 146,8 PIXEL OF oPanel7 READONLY 
	@ 21,30 MSGET oGet9  Var cGet9  PICTURE "@R 9999-9999"	SIZE 146,8 PIXEL OF oPanel7 READONLY 
	@ 31,30 MSGET oGet10 Var cGet10 PICTURE cPicCPF			SIZE 146,8 PIXEL OF oPanel7 READONLY VALID Valida_Contato( 1 )
	@ 41,30 MSGET oGet11 Var cGet11 PICTURE "@!"  			SIZE 146,8 PIXEL OF oPanel7 READONLY VALID Valida_Contato( 2 )
	@ 51,30 MSGET oGet12 Var cGet12 PICTURE "@!"  			SIZE 146,8 PIXEL OF oPanel7 READONLY 
    
    *____________________________________________________________________________________________________________________________
	//Folder2
	oFld2   := TFolder():New(5,4,aBusca,,oFld1:aDialogs[1],,,,.T.,,aCPos[1]-10,35) 
	oFld2:BCHANGE:={||cPesq:='PESQUISAR POR '+UPPER(Substr(aBusca[oFld2:nOption],2,len(aBusca[oFld2:nOption])))+'...'+space(200),;
		oPesq:refresh(),;
		oPesq:Setfocus(),;
		oculta()}
	/*   	
   	oGp4:= tGroup():New(05,004,212,379,'Grupos',oFld1:aDialogs[2],,,.T.)
   	
		oPanel2	:= tPanel():New(15,8,'',oGp4,,,,,,45,192)
		oBtn5   := TButton():New(00,0,"A&dicionar"		,oPanel2,{||},045,014,,,,.T.,,"",,,,.F. )
		oBtn6   := TButton():New(14,0,"&Remover"		,oPanel2,{||},045,014,,,,.T.,,"",,,,.F. )
		oBtn7   := TButton():New(28,0,"Mover p/&Cima"	,oPanel2,{||},045,014,,,,.T.,,"",,,,.F. )
		oBtn8   := TButton():New(42,0,"Mover p/&Baixo"	,oPanel2,{||},045,014,,,,.T.,,"",,,,.F. )
		oBtn9   := TButton():New(56,0,"&Editar"			,oPanel2,{||},045,014,,,,.T.,,"",,,,.F. )

		oPanel3	:= tPanel():New(193,54,'',oGp4,,,,,,320,14)
		oBtn10   := TButton():New(0,000,"&Inicio"	,oPanel3,{||},045,014,,,,.T.,,"",,,,.F. )
		oBtn11   := TButton():New(0,045,"&Voltar"	,oPanel3,{||},045,014,,,,.T.,,"",,,,.F. )
		oBtn12   := TButton():New(0,090,"&Avan็ar"	,oPanel3,{||},045,014,,,,.T.,,"",,,,.F. )
		oBtn13   := TButton():New(0,135,"Sa&lvar"	,oPanel3,{||},045,014,,,,.T.,,"",,,,.F. )
                                     
		If nRemoteType # 5                                                                                                 
			oBtn5:SetCss("QPushButton{}")                                                             
			oBtn6:SetCss("QPushButton{}")
			oBtn7:SetCss("QPushButton{}")
			oBtn8:SetCss("QPushButton{}")
			oBtn9:SetCss("QPushButton{}")
			oBtn10:SetCss("QPushButton{}")
			oBtn11:SetCss("QPushButton{}")
			oBtn12:SetCss("QPushButton{}")
			oBtn13:SetCss("QPushButton{}")
		EndIf
		
        nAtual:=1
        aAtual:={'26 | SAC - Suporte Agentes','34 | CNS - Consultoria','42 | SAC - Vendas'}

     	@ 15,54 LISTBOX oAtual VAR nAtual ITEMS aAtual PIXEL SIZE 320,177 DIALOG oGp4
	*__________________________________________________________________________________________________________________________	
    */
    //Rodape                 
    If nRemoteType # 5
    	nLinBtn := 239.5
    Else
    	nLinBtn := 229.5
    EndIf	                        
    
	oPanel1	:= tPanel():New(nLinBtn,04,'',oDlg1,,,,rgb(241,241,251),,260,14)
	oBtn4	:= TBtnBmp2():New(0,0,30,30,'PMSINFO','PMSINFO',,,,oPanel1,,,.T.)

	oSayR	:= tSay():New(05,15,{||},oPanel1,,oFont2,,,,.T.,rgb(255,127,39),,255,20)
	oSayR:CCAPTION:= Substring(aBusca[oFld2:nOption],2,len(aBusca[oFld2:nOption]))+' "'+Alltrim(cPesq)+'" Nใo Encontrado!'
	
	oBtnInc := TButton():New(nLinBtn,265.5,"Incluir",oDlg1,{ || IncSuspect() }, 040, 014,,,,.T.,,"",,,,.F. )
	oBtn1   := TButton():New(nLinBtn,307.0,"Ok",oDlg1,{ || Iif( !Empty( aContatos[ oLtContatos:nAt, 1 ] ), GatilhaContatos( cOrigem ), .T.),oDlg1:end() }, 040, 014,,,,.T.,,"",,,,.F. )
	oBtn2   := TButton():New(nLinBtn,348.5,"Sair",oDlg1,{ || oDlg1:end() },040,014,,,,.T.,,"",,,,.F. )

	If nRemoteType # 5
		oBtnInc:SetCss("QPushButton{}")
		oBtn1:SetCss("QPushButton{}")
		oBtn2:SetCss("QPushButton{}")
	EndIf
    
	*__________________________________________________________________________________________________________________________	
    
	// Inclusao de Suspect
	oGrpSus		:= tGroup():New( 045, 199, 133, 379, 'Entidade', oFld1:aDialogs[1],,,.T. )
	oPanelSus	:= tPanel():New( 054, 201,  '', oFld1:aDialogs[1],,,,,, 176, 062 )
	oBtnSus		:= tPanel():New( 118, 201,  '', oFld1:aDialogs[1],,,,,, 176, 011.5 )
	
	oFld1:HidePage(2) // Ocultar a pแgina 2 - "Configuracoes"

	oDlg1:Activate(,,,GetScreenRes()[1]>800,,,{||oculta()})

Return                                                                           


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Buscar   บ Autor ณ Warleson           บ Data ณ  31/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Realiza a preparacao e chamada da rotina para pesquisa     บฑฑ
ฑฑบ          ณ da chave nas entidades e contatos                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Service Desk - Certisign                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function  Buscar(_cPesq)

	//zerando os Recnos das entidades
	AEval( aRecno, { |x| x[2] := 0 } )
	
	oFld3:SetTabs({'1'})	
	aPesqResult	:= {{}}

	oSayR:CCAPTION:= 'Aguarde...'
	oBtn4:Hide()
	oPanel1:Show()

	BuscaResult(_cPesq)

    if !empty(aPesqResult[1]) 
		Exibe()
		oBtn4:Hide()    
		oPanel1:Hide()
		PopulaEntidade()   
    Else  
		oculta()
		oSayR:CCAPTION := Substring(aBusca[oFld2:nOption],2,len(aBusca[oFld2:nOption]))+' "'+Alltrim(cPesq)+'" Nใo Encontrado!'
    	oBtn4:Show()                                   
    	oBtnInc:Enable()
		oPanel1:Show()
        oPesq:SetFocus()
    Endif
	
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Oculta   บAutor  ณ Warleson           บ Data ณ  31/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Oculta paineis de resultado, entidade e contatos           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Service Desk - Certisign                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function oculta()
	oPesq:Setfocus()	

	oPanel1:Hide()
	oPanelList:Hide()  
	oPanelList:Disable()
	oGp2:hide()
	oPanel4:hide()
//	oGp3:hide()
	oFld4:Hide()
	oBtn1:disable()
	oBtnInc:Disable()
	oGrpSus:Hide()
	oPanelSus:Hide()
	oBtnSus:Hide()
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Exibe    บAutor  ณ Warleson           บ Data ณ  31/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Exibe paineis de resultado, entidade e contatos            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Service Desk - Certisign                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Exibe()

	//oPesq:Setfocus()
	oPanel1:Show()
	oPanelList:Show()
	oPanelList:Enable()
	oGp2:Show()
	oPanel4:Show()
//	oGp3:Show()                                  
	oFld4:Show()
	oBtn1:Enable()
	oBtnInc:Disable()
	
Return                                                                    


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ExibeConf บAutor  ณ Warleson          บ Data ณ  31/03/13   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Exibe aba de configuracoes                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Service Desk - Certisign                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Exibeconf()                                                                                                                                 

	if oFld1:nOption==2 //Aba configuracoes
		oPesq:Hide() //Caixa de pesquisa
		oBtn3:Hide() //botao buscar
		oculta()
	Else
		oPesq:Show()
		oBtn3:Show()
		oPesq:Setfocus()
		Exibe()
	Endif
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออหออออออัอออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AbasPesquisa บAutor ณ Warleson        บ Data ณ  31/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออออออสออออออฯอออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Define abas de pesquisa e cria arquivo com as abas default บฑฑ
ฑฑบ          ณ da pesquisa.                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Service Desk - Certisign                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AbasPesquisa()

local aRet		:= {}
local cDir1		:= '\PESQCERT'
local cDir2		:= '\GRUPO'
Local cFile 	:= '\DEFCONT.TXT'
Local cChave	:= 'Nome,Telefone,CPF/CNPJ,E-mail,Common Name'  
Local x
	
	If !(ExistDir(cDir1))
		MakeDir(cDir1)
	Endif
	
	If !(ExistDir(cDir1+cDir2))
		MakeDir(cDir1+cDir2)			
	endif

	if !file(cDir1+cDir2+cFile)
		memowrite(cDir1+cDir2+cFile,cChave)	
	Endif
	
	aRet:= StrTokArr(memoread(cDir1+cDir2+cFile),',')

	//Atalhos 
	For x:=1 to len(aRet)
		aRet[x]:= '&'+aRet[x]
	Next

Return aRet                                   


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ BuscaResult บ Autor ณ Warleson / Gustavo บ Data ณ 31/03/13 บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณ Realiza busca principal da chave nas entidades e contatos. บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Service Desk - Certisign                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function BuscaResult(_cPesq,lNovaAba)

Local cFilSU5		:= ""
Local cFilSUS		:= ""
Local cFilACH		:= ""
Local cFilSA1		:= ""
Local cFilSZT		:= ""
Local cFilAC8		:= ""
Local cQry 			:= "" 
Local cQuery		:= ""
Local cchave		:= Alltrim(_cPesq)
Local aCountPesq	:= { 0, 0, 0, 0, 0, 0 }
Local aContinua 	:= {}
Local aUsaFuncao	:= {}
Local nPos			:= 0
Local nOption		:= oFld2:nOption
Local x             := 0
Local nI			:= 0       
      
Default lNovaAba	:= .F.

	CursorWait()
                   
	cFilSU5 := xFilial( "SU5" )
	cFilACH := xFilial( "ACH" )
	cFilSUS := xFilial( "SUS" )
	cFilSZT	:= xFilial( "SZT" )
	cFilSA1 := xFilial( "SA1" )
	cFilAC8 := xFilial( "AC8" )                                              
	cFilSZ3 := xFilial( "SZ3" )
	
	// Indica se deve utilizar funcao UPPER do Oracle ou outra funcao para comparacao de chave na Query
	aUsaFuncao := { .F., ;		// Nome
					.F., ;		// Telefone
					.F., ;		// CPF/CNPJ
					.F., ;  	// E-mail
					.T. }   	// Common Name
					
	// Indica se o proximo nivel deve continuar a busca (processamento da Query de selecao)
	aContinua 	:= { .T., ;		// Nivel Cliente
					 .T., ;     // Nivel Prospect
					 .T., ;		// Nivel Suspect
					 .T., ;		// Nivel Contato x Entidade
					 .T., ;		// Nivel Common Name                          
					 .T., ; 	// Nivel Postos de Atendimento
					 .T.  }		// Proximo Nivel (a definir)
					 
	// Inicializa totais de registros pesquisados se nao for uma nova aba
	If !lNovaAba
		aTotalPesq := { 0, 0, 0, 0, 0, 0 }
	EndIf

	For x := 1 to 2  // x==1 para Contador de registros; x==2 para selecionar os registros
                                             
		//  
		//	Seleciona Cliente (SA1) - aChaves[1]
		//
		cQry 	:= ""	
		cQuery	:= ""

		If x==1
			cQry += "SELECT COUNT( R_E_C_N_O_ ) AS COUNT FROM "
			cQry += RetSQlName('SA1') + CRLF
		Else//x==2
			cQry += "SELECT ALIAS, CHAVE, RECNO, STATUS FROM (SELECT "+aChaves[1,nOption]+" AS CHAVE, 'CLIENTE' AS STATUS, '1SA1' AS ALIAS, R_E_C_N_O_ AS RECNO FROM "
 			cQry += RetSQlName('SA1') + CRLF
		Endif
		
		cQry += "  WHERE " + CRLF
		cQry += "  A1_FILIAL = '" + cFilSA1 + "'" + CRLF
		     
		cQry += RetChvQry( aUsaFuncao[ nOption ], aChaves[ 1, nOption ], cChave, nOption )
		
		If !(aRecno[1,2]==0)
			cQry += " AND R_E_C_N_O_ > '" + CValToChar( aRecno[1,2] ) + "'" + CRLF
		Endif
		
		cQry += "AND D_E_L_E_T_ = ' ' " + CRLF
                                                     
        If x > 1
        	cQry += " AND ROWNUM <= '" + CValToChar( aTotalPesq[ 1 ] ) + "'" + CRLF
			cQry += "ORDER BY RECNO ) " + CRLF		
			cQry += "WHERE ROWNUM  <= 14 " + CRLF //Limite da Tela - Serแ criado uma nova pagina.
			cQry += "ORDER BY ALIAS, CHAVE, RECNO" + CRLF		
		EndIf		        

		cQuery := ChangeQuery(cQry)

		// Fecha query temporaria da consulta da entidade anterior
		If Select( Iif( x == 1, "TRB2", "TRB" ) ) > 0
			DbSelectArea( Iif( x == 1, "TRB2", "TRB" ) )
			DbCloseArea()
		EndIf
		
		If x == 1 //count                            
			
			dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery),"TRB2", .F., .T. )
			
			If ! TRB2->( Eof() )
				aCountPesq[ 1 ] := TRB2->COUNT
				aTotalPesq[ 1 ] := Iif( aTotalPesq[ 1 ] == 0, aCountPesq[ 1 ], aTotalPesq[ 1 ] )
			Endif
			
			//Caso tenha menos que 14 registro em tela, entใo continuo a pesquisa para preencher a primeira pagina
		
			If ! aCountPesq[1] < 14 
				aContinua[1] := .T.
				Loop
			EndIf
			
	    Else			
			
			If ! aContinua[1]
				Exit
			Endif
		         		
			If aCountPesq[1] >= 14  // Adicionando nova pแgina para o resultado
				oFld3:SetTabs( oFld3:AddItem('+') )
				aContinua[1] := .F.
			Else
				oFld3:aPrompts[ Len( oFld3:aPrompts ) ] := CValToChar( Len( oFld3:aPrompts ) )
				oFld3:SetTabs( oFld3:aPrompts )
			EndIf
			
			If !(Len(aPesqResult[Len(aPesqResult)])<14)
				aAdd(aPesqResult,{})
			EndIf
			               
			If aCountPesq[1] > 0 .And. Len( aPesqResult[ Len( aPesqResult ) ] ) < 14
				// Gera array aPesqResult com o resultado da consulta na entidade
				dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery),"TRB", .F., .T. )
				If ! EoF()
					PopulaResult()
				EndIf	
			EndIf
			
		Endif

		// Verifica se deve processar a selecao de recnos de Prospect
		If x == 2 .And. ! aContinua[1]
			Exit
		Endif

		//  
		//	Seleciona Prospect (SUS) - aChaves[2]
		// 		
		cQry 	:= ""	
		cQuery	:= ""
		
		If x == 1
			cQry += "SELECT COUNT( R_E_C_N_O_ ) COUNT FROM "
			cQry += RetSQlName('SUS') + CRLF
		Else // x==2
			cQry += "SELECT ALIAS, CHAVE, RECNO, STATUS FROM (SELECT "+aChaves[2,nOption]+" CHAVE,'PROSPECT' STATUS,'2SUS' ALIAS,R_E_C_N_O_ RECNO FROM "
 			cQry += RetSQlName('SUS') + CRLF
		Endif
	
		cQry += " WHERE " + CRLF
		cQry += " US_FILIAL = '" + cFilSUS + "'" + CRLF

		cQry += RetChvQry( aUsaFuncao[ nOption ], aChaves[ 2, nOption ], cChave, nOption )

		If !(aRecno[2,2]==0)
			cQry += "  AND R_E_C_N_O_ > '" + CValToChar( aRecno[2,2] ) + "'" + CRLF
		Endif

		cQry += " AND D_E_L_E_T_ = ' ' "+CRLF
		
        If x == 2
        	cQry += " AND ROWNUM <= '" + CValToChar( aTotalPesq[2] ) + "'" + CRLF
			cQry += " ORDER BY RECNO ) "+CRLF		
			cQry += " WHERE ROWNUM <= " + CValToChar( 14 - Len( aPesqResult[ Len( aPesqResult ) ] ) ) + CRLF //Limite da Tela - Serแ criado uma nova pagina.
			cQry += "ORDER BY ALIAS,CHAVE,RECNO"+CRLF		
		EndIf		        

		cQuery := ChangeQuery( cQry )

		// Fecha query temporaria da consulta da entidade anterior
		If Select( Iif( x == 1, "TRB2", "TRB" ) ) > 0
			DbSelectArea( Iif( x == 1, "TRB2", "TRB" ) )
			DbCloseArea()
		EndIf

		if x == 1 //count                            
			
			dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery),"TRB2", .F., .T. )
			
			If !TRB2->(Eof())
				aCountPesq[ 2 ] := ( aCountPesq[ 1 ] + TRB2->COUNT )
				aTotalPesq[ 2 ] := Iif( aTotalPesq[ 2 ] == 0, aCountPesq[ 2 ], aTotalPesq[ 2 ] )
			Endif
			
			//Caso tenha menos que 14 registro em tela, entใo continuo a pesquisa para preencher a primeira pagina
			 
			If ! aCountPesq[2] < 14
				aContinua[3] := .T.
				Loop
			EndIf

        Else

			If aCountPesq[2] >= 14  // Adicionando nova pแgina para o resultado
				oFld3:SetTabs(oFld3:AddItem('+'))
				aContinua[3] := .F.
			Else
				oFld3:aPrompts[ Len( oFld3:aPrompts ) ] := CValToChar( Len( oFld3:aPrompts ) )
				oFld3:SetTabs(oFld3:aPrompts)
			EndIf

		    If !(Len(aPesqResult[Len(aPesqResult)])<14)
				aAdd(aPesqResult,{})
			Endif		

			If aCountPesq[2] > 0 .And. Len( aPesqResult[ Len( aPesqResult ) ] ) < 14
				// Gera array aPesqResult com o resultado da consulta na entidade
				dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery),"TRB", .F., .T. )			
				If ! EoF()
					PopulaResult() 
				EndIf
			EndIf
			
		Endif

		// Verifica se deve processar a selecao de recnos de Suspect
		If x == 2 .And. ! aContinua[3]
			Exit
		Endif
	
		//  
		//	Seleciona Suspect (ACH) - aChaves[3]
		//
		cQry 	:= ""	
		cQuery	:= ""

		if x==1
			cQry += "SELECT COUNT( R_E_C_N_O_ ) COUNT FROM "
			cQry += RetSQlName('ACH') + CRLF
		Else//x==2
			cQry += "SELECT ALIAS, CHAVE, RECNO, STATUS FROM (SELECT "+aChaves[3,nOption] + " CHAVE,'SUSPECT' STATUS,'3ACH' ALIAS,R_E_C_N_O_ RECNO FROM "
 			cQry += RetSQlName('ACH') + CRLF
		Endif
                             
		cQry += "  WHERE " + CRLF
		cQry += "  ACH_FILIAL = '" + cFilACH + "'" + CRLF                              
		
		cQry += RetChvQry( aUsaFuncao[ nOption ], aChaves[ 3, nOption ], cChave, nOption )
		
		If !(aRecno[3,2]==0)
			cQry += "  AND R_E_C_N_O_ > '" + CValToChar( aRecno[3,2] ) + "'" + CRLF
		Endif

		cQry += "  AND D_E_L_E_T_ = ' ' "+CRLF   
		
        If x > 1
        	cQry += " AND ROWNUM <= '" + CValToChar( aTotalPesq[ 3 ] ) + "'" + CRLF
			cQry += " ORDER BY RECNO ) "+CRLF		
			cQry += " WHERE ROWNUM <= " + CValToChar( 14 - Len( aPesqResult[ Len( aPesqResult ) ] ) ) + CRLF //Limite da Tela - Serแ criado uma nova pagina.
			cQry += "ORDER BY ALIAS,CHAVE,RECNO"+CRLF		
		EndIf		        

		cQuery := ChangeQuery( cQry )

		// Fecha query temporaria da consulta da entidade anterior
		If Select( Iif( x == 1, "TRB2", "TRB" ) ) > 0
			DbSelectArea( Iif( x == 1, "TRB2", "TRB" ) )
			DbCloseArea()
		EndIf
		
		if x==1 //count                            
		
			dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery),"TRB2", .F., .T. )
			
			If !TRB2->(Eof())
				aCountPesq[ 3 ] := ( aCountPesq[ 2 ] + TRB2->COUNT )
				aTotalPesq[ 3 ] := Iif( aTotalPesq[ 3 ] == 0, aCountPesq[ 3 ], aTotalPesq[ 3 ] )
			Endif
			
			//Caso tenha menos que 14 registro em tela, entใo continuo a pesquisa para preencher a primeira pagina
		
			If ! aCountPesq[3] < 14 
					aContinua[4] := .T.
				Loop
			EndIf

		Else

			If aCountPesq[3] >= 14  // Adicionando nova pแgina para o resultado
				oFld3:SetTabs(oFld3:AddItem('+')) 
				aContinua[4] := .F.
			Else
				oFld3:aPrompts[len(oFld3:aPrompts)]:=cvaltochar(len(oFld3:aPrompts))
				oFld3:SetTabs(oFld3:aPrompts)
			EndIf

		    If !(Len(aPesqResult[Len(aPesqResult)])<14)
				aAdd(aPesqResult,{})
			Endif		
                                                                             
			If aCountPesq[3] > 0 .And. Len( aPesqResult[ Len( aPesqResult ) ] ) < 14
				// Gera array aPesqResult com o resultado da consulta na entidade
				dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery),"TRB", .F., .T. )
				If ! EoF() 
					PopulaResult()
				EndIf	
			EndIf
			
		Endif

		// Verifica se deve processar a selecao de recnos de Entidades x Contatos
		If x == 2 .And. ! aContinua[4]
			Exit
		Endif

		//  
		//	Seleciona relacionamentos Entidades x Contatos(SU5/AC8) - aChaves[4]
		//   		
		cQry 	:= ""	
		cQuery	:= ""	

		If x==1
			cQry += "SELECT COUNT( SU5.R_E_C_N_O_ ) COUNT FROM " 
			cQry += RetSQlName('SU5') + ' SU5 ' + CRLF
		Else//x==2
			cQry += "SELECT ALIAS, CHAVE, RECNO, AC8_RECNO, STATUS " + CRLF
			cQry += "FROM (SELECT SU5." + aChaves[4,nOption] + " CHAVE, 'CONTATO' STATUS, '4SU5' ALIAS, SU5.R_E_C_N_O_ RECNO, NVL(AC8.R_E_C_N_O_,0) AS AC8_RECNO FROM " 
			cQry += RetSQlName('SU5') + ' SU5 ' + CRLF
		Endif

		cQry += "LEFT JOIN " + RetSQlName( 'AC8' ) + " AC8 " + CRLF                                             
		cQry += "	ON " + CRLF
		cQry += "   AC8.AC8_FILIAL = '" + cFilAC8 + "' AND " + CRLF
		cQry += "   SU5.U5_CODCONT = AC8.AC8_CODCON AND " + CRLF
		cQry += "	AC8.D_E_L_E_T_ = ' ' AND " + CRLF
		cQry += "	AC8.AC8_ENTIDA IN (" + cEntidades + ") " + CRLF 
		cQry += "WHERE " + CRLF
		cQry += " SU5.U5_FILIAL = '" + cFilSU5 + "'" + CRLF
 
		cQry += RetChvQry( aUsaFuncao[ nOption ], "SU5." + aChaves[ 4, nOption ], cChave, nOption )

		If !(aRecno[4,2]==0)
			cQry += "  AND AC8.R_E_C_N_O_ > '" + CValToChar( aRecno[4,2] ) + "'" + CRLF
		Endif
		
		cQry += "  AND SU5.D_E_L_E_T_ = ' '" + CRLF

        If x > 1
        	cQry += " AND ROWNUM <= '" + CValToChar( aTotalPesq[ 4 ] ) + "'" + CRLF
			cQry += " ORDER BY AC8_RECNO ) " + CRLF		
			cQry += " WHERE ROWNUM <= " + CValToChar( 14 - Len( aPesqResult[ Len( aPesqResult ) ] ) ) + CRLF //Limite da Tela - Serแ criado uma nova pagina.
			cQry += "ORDER BY ALIAS,CHAVE,AC8_RECNO"+CRLF		
		EndIf		        

		cQuery := ChangeQuery( cQry )

		// Fecha query temporaria da consulta da entidade anterior
		If Select( Iif( x == 1, "TRB2", "TRB" ) ) > 0
			DbSelectArea( Iif( x == 1, "TRB2", "TRB" ) )
			DbCloseArea()
		EndIf

		If x==1 //count                            

			dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery),"TRB2", .F., .T. )
			
			If !TRB2->( Eof() )
				aCountPesq[ 4 ] := ( aCountPesq[ 3 ] + TRB2->COUNT )
				aTotalPesq[ 4 ] := Iif( aTotalPesq[ 4 ] == 0, aCountPesq[ 4 ], aTotalPesq[ 4 ] )
			Endif
			
			//Caso tenha menos que 14 registro em tela, entใo continuo a pesquisa para preencher a primeira pagina
		
			If ! aCountPesq[4] < 14
				aContinua[5] := .T. 
				Loop
			EndIf

		Else 
		
			If aCountPesq[4] >= 14  // Adicionando nova pแgina para o resultado
				oFld3:SetTabs(oFld3:AddItem('+'))
				aContinua[5] := .F.
			Else
				oFld3:aPrompts[len(oFld3:aPrompts)]:=cvaltochar(len(oFld3:aPrompts))
				oFld3:SetTabs(oFld3:aPrompts)
			EndIf

			If !(Len(aPesqResult[Len(aPesqResult)])<14)
				aAdd(aPesqResult,{})
			Endif		

			If aCountPesq[4] > 0 .And. Len( aPesqResult[ Len( aPesqResult ) ] ) < 14
				// Gera array aPesqResult com o resultado da consulta na entidade
				dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery),"TRB", .F., .T. )
				If ! EoF()
					PopulaResult( .T. )
				EndIf	
			EndIf
								
		Endif

		// Verifica se deve processar a selecao de recnos de Common Name
		If x == 2 .And. ! aContinua[5]
			Exit
		Endif

		//  
		//	Seleciona Common Name (SZT) - aChaves[5]
		//   		
		cQry 	:= ""
		cQuery	:= ""

		if x==1
			cQry += "SELECT COUNT( R_E_C_N_O_ ) COUNT FROM "
			cQry += RetSQlName('SZT') + CRLF
		Else//x==2
			cQry += "SELECT ALIAS, CHAVE, RECNO, STATUS FROM (SELECT "+aChaves[5,nOption] + " CHAVE,'COMMON NAME' STATUS,'5SZT' ALIAS,R_E_C_N_O_ RECNO FROM "
 			cQry += RetSQlName('SZT') + CRLF
		Endif
                             
		cQry += "  WHERE "
		cQry += "  ZT_FILIAL = '" + cFilSZT + "'" + CRLF

		cQry += RetChvQry( aUsaFuncao[ nOption ], aChaves[ 5, nOption ], cChave, nOption )

		If !(aRecno[5,2]==0)
			cQry += "  AND R_E_C_N_O_ > '" + CValToChar( aRecno[5,2] ) + "'" + CRLF
		Endif

		cQry += "  AND D_E_L_E_T_ = ' ' "+CRLF   
		
        If x > 1
        	cQry += " AND ROWNUM <= '" + CValToChar( aTotalPesq[ 5 ] ) + "'" + CRLF
			cQry += " ORDER BY RECNO ) " + CRLF		
			cQry += " WHERE ROWNUM <= " + CValToChar( 14 - Len(aPesqResult[ Len(aPesqResult) ] ) ) + CRLF //Limite da Tela - Serแ criado uma nova pagina.
			cQry += "ORDER BY ALIAS,CHAVE,RECNO"+CRLF		
		EndIf		        

		cQuery := ChangeQuery( cQry )

		// Fecha query temporaria da consulta da entidade anterior
		If Select( Iif( x == 1, "TRB2", "TRB" ) ) > 0
			DbSelectArea( Iif( x == 1, "TRB2", "TRB" ) )
			DbCloseArea()
		EndIf
		
		if x==1 //count                            
		
			dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery),"TRB2", .F., .T. )
			
			If !TRB2->(Eof())
				aCountPesq[ 5 ] := ( aCountPesq[ 4 ]+ TRB2->COUNT )
				aTotalPesq[ 5 ] := Iif( aTotalPesq[ 5 ] == 0, aCountPesq[ 5 ], aTotalPesq[ 5 ] )
			Endif
			
			//Caso tenha menos que 14 registro em tela, entใo continuo a pesquisa para preencher a primeira pagina
			 
			If ! aCountPesq[5] < 14
				aContinua[6] := .T.
				Loop
			EndIf

		Else

			If aCountPesq[5] >= 14  // Adicionando nova pแgina para o resultado
				oFld3:SetTabs(oFld3:AddItem('+'))
				aContinua[6] := .F.
			Else
				oFld3:aPrompts[len(oFld3:aPrompts)]:=cvaltochar(len(oFld3:aPrompts))
				oFld3:SetTabs(oFld3:aPrompts)
			EndIf
	
		    If !(Len(aPesqResult[Len(aPesqResult)])<14)
				aAdd(aPesqResult,{})
			Endif		
                                                                             
			If aCountPesq[5] > 0 .And. Len( aPesqResult[ Len( aPesqResult ) ] ) < 14
				// Gera array aPesqResult com o resultado da consulta na entidade
				dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery),"TRB", .F., .T. )
				If ! EoF()
					PopulaResult()
				EndIf	
			EndIf	
			
		Endif

		//  
		//	Seleciona Postos de Atendimento (SZ3) - aChaves[6]
		//   		
		If !Empty( aChaves[ 6, nOption ] )

			// Verifica se deve processar a selecao de recnos de Postos de Atendimento
			If x == 2 .And. ! aContinua[6]
				Exit
			Endif

			cQry 	:= ""
			cQuery	:= ""
	
			if x==1
				cQry += "SELECT COUNT( R_E_C_N_O_ ) COUNT FROM "
				cQry += RetSQlName('SZ3') + CRLF
			Else//x==2
				cQry += "SELECT ALIAS, CHAVE, RECNO, STATUS FROM (SELECT "+aChaves[6,nOption] + " CHAVE, 'POSTOS' STATUS,'6SZ3' ALIAS,R_E_C_N_O_ RECNO FROM "
	 			cQry += RetSQlName('SZ3') + CRLF
			Endif
	                             
			cQry += "  WHERE "
			cQry += "  Z3_FILIAL = '" + cFilSZ3 + "'" + CRLF
	                  
			cQry += RetChvQry( aUsaFuncao[ nOption ], aChaves[ 6, nOption ], cChave, nOption )
			
			If !(aRecno[6,2]==0)
				cQry += "  AND R_E_C_N_O_ > '" + CValToChar( aRecno[6,2] ) + "'" + CRLF
			Endif
	
			cQry += "  AND D_E_L_E_T_ = ' ' "+CRLF   
			
	        If x > 1
	        	cQry += " AND ROWNUM <= '" + CValToChar( aTotalPesq[ 6 ] ) + "'" + CRLF
				cQry += " ORDER BY RECNO ) " + CRLF		
				cQry += " WHERE ROWNUM <= " + CValToChar( 14 - Len(aPesqResult[ Len(aPesqResult) ] ) ) + CRLF //Limite da Tela - Serแ criado uma nova pagina.
				cQry += "ORDER BY ALIAS,CHAVE,RECNO"+CRLF		
			EndIf		        
	
			cQuery := ChangeQuery( cQry )
	
			// Fecha query temporaria da consulta da entidade anterior
			If Select( Iif( x == 1, "TRB2", "TRB" ) ) > 0
				DbSelectArea( Iif( x == 1, "TRB2", "TRB" ) )
				DbCloseArea()
			EndIf
			
			if x==1 //count                            
			
				dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery),"TRB2", .F., .T. )
				
				If !TRB2->(Eof())
					aCountPesq[ 6 ] := ( aCountPesq[ 5 ]+ TRB2->COUNT )
					aTotalPesq[ 6 ] := Iif( aTotalPesq[ 6 ] == 0, aCountPesq[ 6 ], aTotalPesq[ 6 ] )
				Endif
				
				//Caso tenha menos que 14 registro em tela, entใo continuo a pesquisa para preencher a primeira pagina
				 
				If ! aCountPesq[6] < 14
					aContinua[7] := .T.
					Loop
				EndIf
	
			Else 
			
				If aCountPesq[6] >= 14  // Adicionando nova pแgina para o resultado
					oFld3:SetTabs(oFld3:AddItem('+'))  
					aContinua[7] := .F.
				Else
					oFld3:aPrompts[len(oFld3:aPrompts)]:=cvaltochar(len(oFld3:aPrompts))
					oFld3:SetTabs(oFld3:aPrompts)
				EndIf
		
			    If !(Len(aPesqResult[Len(aPesqResult)])<14)
					aAdd(aPesqResult,{})
				Endif		
	                                                                             
				If aCountPesq[6] > 0 .And. Len( aPesqResult[ Len( aPesqResult ) ] ) < 14
					// Gera array aPesqResult com o resultado da consulta na entidade
					dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery),"TRB", .F., .T. )
					If ! EoF()
						PopulaResult()
					EndIf	
				EndIf	
				
			EndIf

		EndIf

	Next

	aCountPesq := { 0, 0, 0, 0, 0, 0 }
	aContinua  := { .T., .F., .F., .F., .F., .F. }

	If Len(aPesqResult[len(aPesqResult)])= 0
		oListResult:bLine:={|| { "", "", ""} }
	Else
		oListResult:SetArray( aPesqResult[len(aPesqResult)] )
		oListResult:bLine:={||{ aPesqResult[len(aPesqResult)][oListResult:nAt,1],;
								aPesqResult[len(aPesqResult)][oListResult:nAt,2],;
								aPesqResult[len(aPesqResult)][oListResult:nAt,3],;
								aPesqResult[len(aPesqResult)][oListResult:nAt,4] }}
		oListResult:Refresh()
		PopulaEntidade()
	EndIf

	CursorArrow()
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ NovaAba  บAutor  ณ Warleson           บ Data ณ  31/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Gera nova aba com resultado da pesquisa da chave nas       บฑฑ
ฑฑบ          ณ entidades.                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Service Desk - Certisign                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function NovaAba

	If alltrim(oFld3:aPrompts[oFld3:nOption])=='+'

		oSayR:CCAPTION:= 'Aguarde...'
		oBtn4:Hide()
		oPanel1:Show()

		BuscaResult(alltrim(cPesq)+'%',.T.)

		oPanel1:Hide()
		oBtn4:Show()
		oSayR:CCAPTION:= Substring(aBusca[oFld2:nOption],2,len(aBusca[oFld2:nOption]))+' "'+Alltrim(cPesq)+'" Nใo Encontrado!'

	Else
		// Atualiza grid		  
		oListResult:SetArray( aPesqResult[oFld3:nOption] )
		oListResult:bLine:={||{ aPesqResult[oFld3:nOption][oListResult:nAt,1],;
									aPesqResult[oFld3:nOption][oListResult:nAt,2],;
									aPesqResult[oFld3:nOption][oListResult:nAt,3],;
									aPesqResult[oFld3:nOption][oListResult:nAt,4] }}

		oListResult:Refresh()
		PopulaEntidade()		
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออหอออออออัอออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ PopulaEntidade บ Autor ณ Warleson      บ Data ณ 31/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออออออออสอออออออฯอออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDescricao ณ Atualiza os dados de detalhes das entidades e contatos     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Service Desk - Certisign                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PopulaEntidade()

local cAlias,nRecno,cStatus,nLi
local cChave		:= ''
local nAchou		:= 0 
local nX			:= 0
local cQuery		:= ''
local cCampoPesq	:= ''                     
local _nLin			:= 4
local aRet			:= {}

lAc8Entidade	:= .F.

	if !empty(aPesqResult[1]) .and. oListResult:nAt<=len(aPesqResult[oFld3:nOption])
		cAlias 	:= Substr(aPesqResult[oFld3:nOption][oListResult:nAt,3],2,3)
		nRecno 	:= aPesqResult[oFld3:nOption][oListResult:nAt,4]
		cStatus	:= aPesqResult[oFld3:nOption][oListResult:nAt,1]  
		nLin	:= Ascan(aRecno,{|x|x[1] == aPesqResult[oFld3:nOption][oListResult:nAt,3]})
	Endif

	if !empty(cAlias) .and. (nLin>0 .and. !(nLin==4))  //4== SU5 Contato
	
		DbSelectArea(cAlias)
		dbgoto(nRecno)

		//ENTIDADE
			
		cGet1		:= GetChave( cAlias, nLin, 1 )	// Nome
		cGet2		:= GetChave( cAlias, nLin, 6 )  // DDD
		cGet3		:= GetChave( cAlias, nLin, 3 )  // CGC
		cGet4		:= GetChave( cAlias, nLin, 4 )  // E-mail
		cGet5		:= Capital(cStatus) //Status
		cGet6		:= GetChave( cAlias, nLin, 2 )	// Telefone

		oGet1:Picture := GetPict( cAlias, nLin, 1 ) 
		oGet6:Picture := GetPict( cAlias, nLin, 2 ) 
		oGet4:Picture := GetPict( cAlias, nLin, 4 ) 

		oGet1:Refresh()
		oGet2:Refresh()
		oGet3:Refresh()
		oGet4:Refresh()
		oGet5:Refresh()
		oGet6:Refresh()

		cFilent	:= xFilial(cALias)  
		_cAlias	:= cAlias
								
		Do Case
	   		Case _cAlias == 'SA1'
				_cCodEnt  := SA1->A1_COD
				_cLojaEnt := SA1->A1_LOJA
	   		Case _cAlias == 'SUS'
				_cCodEnt  := SUS->US_COD
				_cLojaEnt := SUS->US_lOJA
	   		Case _cAlias == 'ACH'	   	
				_cCodEnt  := ACH->ACH_CODIGO
				_cLojaEnt := ACH->ACH_LOJA
	   		Case _cAlias == 'SU5'	   	
				_cCodEnt  := SU5->U5_CODCONT
				_cLojaEnt := ""
			Case _cAlias == 'SZT'
				_cCodEnt  := SZT->ZT_CODIGO
				_cLojaEnt := ""
			Case _cAlias == 'SZ3'
				_cCodEnt  := SZ3->Z3_CODENT
				_cLojaEnt := ""
	   	End CAse 

		cChave:= XFilial('AC8')+_cAlias+cFilent+_cCodEnt+_cLojaEnt
	
		DbSelectArea('AC8')
   		DbSetorder(2)
			
		lAc8Entidade := DbSeek(cChave) //Seek no AC8

    Else
 
		// SU5 CONTATO
		//	AC8->AC8_ENTIDA //Alias   	 		
	   	//	AC8_CODENTIDA // Codigo+Loja
 
   		if !empty(cAlias) .and. (nLin>0 .and. (nLin==4))  //4== SU5 Contato
		    
			If (aPesqResult[oFld3:nOption][oListResult:nAt,5])> 0 //AC8_RECNO
				lAc8Entidade := .T.
		  		DbSelectArea('AC8')
				dbgoto(aPesqResult[oFld3:nOption][oListResult:nAt,5])
			Else
				lAc8Entidade := .F.
		  		DbSelectArea('SU5')
				dbgoto(nRecno)
            Endif

	   		If lAc8Entidade
				cFilent			:= AC8->AC8_FILENT
				_cAlias			:= AC8->AC8_ENTIDA  
				_cCodEnt		:= AllTrim(AC8->AC8_CODENT) 	//Netes caso o contato encontro u o relacionametno  ocm uma entidade para ele
				_cLojaEnt		:= ""
			Else
				cFilent			:= xFilial(cALias)  
				_cAlias			:= cAlias
				_cCodEnt  		:= SU5->U5_CODCONT
				_cLojaEnt 		:= ""
			EndIf	            
			
   			//posiciona no alias e registro corretos
			buscaEntidade(cFilent,_cAlias,_cCodEnt,_cLojaEnt)
			
   		Endif

    Endif

	IF TYPE('oLtContatos')=='O'

		aRet := Filtra_Contatos(xFilial(_cAlias),_cAlias,_cCodEnt,_cLojaEnt)
	             
		aContatos	:= AClone( aRet[ 1 ] )
		aChvSU5		:= AClone( aRet[ 2 ] )
	
		oLtContatos:SetArray(aContatos)
	
		If len(aContatos) = 0 .or. (len(aContatos)==1.and. empty(aContatos[1][1])) //Codigo do contato vazio
			oLtContatos:bLine:={|| { "", ""} }
		Else                                           
		   	oLtContatos:nAt := 1
			oLtContatos:bLine:={||{	aContatos[oLtContatos:nAt,1],;
										aContatos[oLtContatos:nAt,2]}}
		EndIf
    	
    	If cAlias=='SU5'// Contatos
            if len(aPesqResult[len(aPesqResult)])>= oListResult:nAt 
				nAchou:= Ascan(aContatos,{|x|x[3] == aPesqResult[oFld3:NOPTION][oListResult:nAt,4]})
			Endif			
			If nAchou>0                                                                				
	    		oLtContatos:nAt:= nAchou
			Endif	
    	Else
    		oLtContatos:nAt:=1
    	Endif
		
		oLtContatos:refresh()

		If (nLin==4) .or. ((len(aContatos)==1) .and. !empty(aContatos[oLtContatos:nAt,1]))
			
			//o registro ้ um contato=4
			//ou possui apenas um relacionamento com codigo de contato preenchido
			Eval({||detalhes(.T.),restauraObjetos(),PopulaDetalhes(aContatos[oLtContatos:nAt,3])})
			
		Elseif ((len(aContatos)==1) .and. empty(aContatos[oLtContatos:nAt,1]))
			
			// possui apenas uma linha e codigo de contato vazio, entใo nใo possuo contato.
			Eval({||detalhes(.T.),PopulaNovo(.T.,.T.),oListResult:setFocus()})

		Elseif (nLin==4) .and.  !(lAc8Entidade)

			cGet1		:= cGet7  // Nome
			cGet2		:= cGet8 // DDD
			cGet6		:= cGet9  // Telefone
			cGet3		:= cGet10 // CGC
			cGet4		:= cGet11 // E-mail
			cGet5		:= cGet12 // Status

			oGet1:Refresh()
			oGet2:Refresh()
			oGet3:Refresh()
			oGet4:Refresh()
			oGet5:Refresh()
			oGet6:Refresh()

		Else                                                          

			// Prepara conteudo para pesquisa na tabela de contatos
			If At( '%', cPesq ) > 0
				cCampoPesq := AllTrim( Upper( StrTran( cPesq, '%', ' ' ) ) )
			Else
				cCampoPesq := AllTrim( Upper( cPesq	 ) )
			EndIf
			            
			// Percorre resultado da query com os contatos obtidos a partir da chave informada para pesquisa
			For nX := 1 To Len( aChvSU5 )
			                                           
				cCpoChave := AllTrim( Upper( aChvSU5[ nX, oFld2:nOption ] ) )
			
				If 	cCampoPesq == cCpoChave .Or. ;
					( aChaves[ _nLin, oFld2:nOption ] == "U5_EMAIL"  .And. cCampoPesq $ cCpoChave )	// E-mail					

					oLtContatos:nAt := nX
						
				EndIf
			     
			Next nX
                              
            DbSelectArea( cAlias )                  
                    
			// Restaura dados de contatos do cliente
			Detalhes(.T.)
			RestauraObjetos()
			PopulaDetalhes(aContatos[oLtContatos:nAt,3])
			
			oLtContatos:Refresh()                                                        
			
		Endif

	EndIf
	
Return            


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัอออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ LoadBitMaps บ Autor ณ Warleson        บ Data ณ  31/03/13   บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯอออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Atualiza bitmaps dos botoes das paginas de pesquisa.       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Service Desk - Certisign                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function LoadBitmaps()
	
	&('oBtn'+cvaltochar(nOld)+'Abas'):loadBitmaps(aLegendas[nOld,1])
	&('oBtn'+cvaltochar(nAtu)+'Abas'):loadBitmaps(aLegendas[nAtu,2])

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Detalhes  บ Autor ณ Warleson          บ Data ณ  31/03/13   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Ocultar ou exibir os detalhes dos contatos                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Service Desk - Certisign                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Detalhes(lexibe)

	if lExibe    
		oFld4:ShowPage(2) ///Exibe aba 2, detalhes	
		oFld4:SetOption(2)
	Else
		if oFld4:nOption==1
			lTesta:=.F.
			oFld4:HidePage(2) ///Oculta aba 2, detalhes	
		endif
	Endif
return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออหอออออออัอออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Filtra_Contatos บ Autor ณ Warleson    บ Data ณ  03/31/13   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออสอออออออฯอออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Seleciona Contatos x Entidades                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Service Desk - Certisign                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Filtra_Contatos(_cFilent,_cAlias,_cCodEnt,_cLojaEnt)

Local cQry 		:= ""                         
Local aResult	:= {}
Local aChvSU5	:= {}             
     
Local nLinSU5	:= 4
Local nX		:= 0              
Local nPos		:= 0
Local nTotChv	:= Len( aChaves[ nLinSU5 ] )

	if !empty(_cAlias) .and. !empty(_cCodEnt+_cLojaEnt) .and. ( lAC8Entidade .or. _cAlias == "SU5" )

		cQry += " SELECT U5.U5_CODCONT,U5.R_E_C_N_O_ U5_RECNO, "

		// Sempre buscar as informacoes do contato (posicao 4)
		For nX := 1 To nTotChv
			cQry += "U5."+aChaves[ nLinSU5, nX ]
			If nX < nTotChv
				cQry += ", "
			EndIf	
		Next nX

		cQry += " FROM "+RetSQlName('SU5')+' U5 '+CRLF
		
		If lAc8Entidade
			cQry += " INNER JOIN "+RetSQlName('AC8')+' AC8 '+CRLF
			cQry += " ON U5.U5_CODCONT = AC8.AC8_CODCON AND "
			cQry += " AC8.AC8_FILIAL = '"+XFILIAL('AC8')+"' AND "
			cQry += " AC8.AC8_FILENT = '"+_cFilent+ "' AND "
			cQry += " AC8.AC8_ENTIDA = '"+_cAlias+"'  AND "
			cQry += " AC8.AC8_CODENT = '"+_cCodEnt+_cLojaEnt+"' AND  "
			cQry += " AC8.D_E_L_E_T_ = ' ' "+CRLF		
		Endif
		
		cQry+= " WHERE U5.D_E_L_E_T_ = ' '"+CRLF

		If !(lAc8Entidade)
			cQry+= " AND U5.U5_CODCONT = '"+_cCodEnt+"'"+CRLF
		EndIf
		
		cQry+= " AND U5.U5_FILIAL = '"+XFILIAL('SU5')+"'"+CRLF
		cQry+= " Order by U5.U5_CONTAT"+CRLF	
		
		cQry := ChangeQuery(cQry)
			
		If Select("TRB2") > 0
			DbSelectArea("TRB2")
			DbCloseArea()
		EndIf
	  		
		dbUseArea( .T., "TOPCONN", TcGenQry(,,cQry),"TRB2", .F., .T. )
	                                      
		While ! EoF()
			AAdd( aResult, { U5_CODCONT, U5_CONTAT, U5_RECNO } )
			AAdd( aChvSU5, {} )      
			nPos := Len( aChvSU5 )
			For nX := 1 To nTotChv
				AAdd( aChvSU5[ nPos ], FieldGet( FieldPos( aChaves[ nLinSU5, nX ] ) ) )
			Next nX
			dbskip()
		Enddo
		
		TRB2->( DbCloseArea() )
		DbSelectArea( _cAlias )

	Endif
	
	If empty(aResult)
		aResult	:= {{"","",0}}
		oBtn14:disable() //Botใo de Detalhes
    Else
		oBtn14:Enable() //Botใo de Detalhes
		If _cAlias == "SU5"
			oBtn15:Disable()
		Else
			oBtn15:Enable()
		EndIf	
	Endif

	oFld4:SetOption(1) //Aba de contatos

Return( { aResult, aChvSU5 } )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออหอออออออัอออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ PopulaDetalhes บ Autor ณ Warleson      บ Data ณ 31/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออออออออสอออออออฯอออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDescricao ณ Preenche pasta de detalhes do contato                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Service Desk - Certisign                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PopulaDetalhes(_nRecno)

Local _cAlias := 'SU5'	// Contatos
Local _nLin	  := 4 		// Contatos

	If !empty(_cAlias) .and. _nLin>0
	
		DbSelectArea(_cAlias)
		dbgoto(_nRecno)
		
		//Contato	
		cGet7		:= GetChave( _cAlias, _nLin, 1 ) // Nome
		cGet8		:= GetChave( _cAlias, _nLin, 6 ) // DDD
		cGet9		:= GetChave( _cAlias, _nLin, 2 ) // Telefone
		cGet10		:= GetChave( _cAlias, _nLin, 3 ) // CGC
		cGet11		:= GetChave( _cAlias, _nLin, 4 ) // E-mail
		cGet12		:= 'Contato' //Status
		
		oGet6:Picture  := GetPict( _cAlias, _nLin, 2 )
		oGet7:Picture  := GetPict( _cAlias, _nLin, 1 )
		oGet9:Picture  := GetPict( _cAlias, _nLin, 2 )
		oGet11:Picture := GetPict( _cAlias, _nLin, 4 )

		oGet6:Refresh()
		oGet7:Refresh()
		oGet8:Refresh()
		oGet9:Refresh()
		oGet10:Refresh()
		oGet11:Refresh()
		oGet12:Refresh()
	
    Endif
    
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ PopulaNovo บ Autor ณ Warleson         บ Data ณ  31/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Atualiza tela de detalhes para cadastro de novo conato.    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Service Desk - Certisign                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PopulaNovo( lNew, lFirst )

Local _nLin	:= 4 		// Contatos

default lNew	:= .T.
default lFirst 	:= .F.

	oBtn16:disable()
	oBtn17:disable()
	oBtn18:Enable()

	oPanel7:NCLRPANE := rgb(208,208,242)

	If lNew  

		If lFirst
		
			//Contatos
			cGet7		:= cGet1 // Nome
			cGet8		:= cGet2 // DDD
			cGet9		:= cGet6 // Telefone
			cGet10		:= Iif( !Empty( cGet3 ) .And. Valida_Contato( 1, cGet3, .F. ), cGet3, Space( TamSX3( aChaves[ _nLin, 3 ] )[1] ) )	// CGC
			cGet11		:= Iif( !Empty( cGet4 ) .And. Valida_Contato( 2, cGet4, .F. ), cGet4, Space( TamSX3( aChaves[ _nLin, 4 ] )[1] ) )	// E-mail
			cGet12		:= 'Contato' //Status
	
			oGet6:Refresh()
			
			oGet7:Refresh()
			oGet8:Refresh()
			oGet9:Refresh()
			oGet10:Refresh()
			oGet11:Refresh()
			oGet12:Refresh()
	    
		Else
	
			cGet7		:= Space( TamSX3( aChaves[ _nLin, 1 ] )[1] )
			cGet8		:= Space( TamSX3( aChaves[ _nLin, 6 ] )[1] )
			cGet9		:= Space( TamSX3( aChaves[ _nLin, 2 ] )[1] )
			cGet10		:= Space( TamSX3( aChaves[ _nLin, 3 ] )[1] )
			cGet11		:= Space( TamSX3( aChaves[ _nLin, 4 ] )[1] )
			cGet12		:= "Contato"	// Status
			
		EndIf
			
    Endif
    
	oGet7:lReadOnly  := .F.
	oGet8:lReadOnly  := .F.
	oGet9:lReadOnly  := .F.
	oGet10:lReadOnly := .F.
	oGet11:lReadOnly := .F.
	//oGet12:lReadOnly:=.F. 

	oGet6:Refresh()	
	oGet7:Refresh()
	oGet8:Refresh()
	oGet9:Refresh()
	oGet10:Refresh()
	oGet11:Refresh()
	oGet12:Refresh()
	
	oGet7:SetFocus()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออหอออออออัออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ RestauraObjetos บ Autor ณ Warleson       บ Data ณ 03/31/13 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออสอออออออฯออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณ Atualiza objetos da tela de detalhes do contato            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Service Desk - Certisign                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RestauraObjetos()   

Local cCodCont := SuperGetMv("SDK_CODCTTO",,"007323")

	If Empty( aContatos[ oLtContatos:nAt, 1 ] )
		oBtn14:Disable()
	Else	
		oBtn14:Enable()
	EndIf	

	If _cAlias == "SU5"
	    oBtn16:Disable()
	Else	    
	    oBtn16:Enable()
	EndIf

    If _cAlias == "SU5" .And. (_cAlias)->U5_CODCONT == cCodCont
    	oBtn17:Disable()
    Else
		oBtn17:Enable()
	EndIf
	
	oBtn18:Disable()    
	
	oPanel7:NCLRPANE:= rgb(241,241,251)

	oGet7:lReadOnly  := .T.
	oGet8:lReadOnly  := .T.
	oGet9:lReadOnly  := .T.
	oGet10:lReadOnly := .T.
	oGet11:lReadOnly := .T.
	oGet12:lReadOnly := .T. 
	
	oGet6:Refresh()
	oGet7:Refresh()
	oGet8:Refresh()
	oGet9:Refresh()
	oGet10:Refresh()
	oGet11:Refresh()
	oGet12:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออหอออออออัออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ BuscaEntidade บ Autor ณ Warleson       บ Data ณ  31/03/13  บฑฑ
ฑฑฬออออออออออุอออออออออออออออสอออออออฯออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDescricao ณ Atualiza painel com os dados da entidade pesquisada        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Service Desk - Certisign                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function BuscaEntidade(cFilent,_cAlias,_cCodEnt,_cLojaEnt)

	dbselectarea(_cAlias)
	dbsetorder(1)

	If DbSeek(cFilent+_cCodEnt+_cLojaEnt)
		
		nRecno 	:= recno()
		_nLin	:= Ascan(aRecno,{|x|x[3] == _cAlias})
		
		if _nLin>0
			cStatus 	:= aRecno[_nLin,4]
			cGet1		:= GetChave( _cAlias, _nLin, 1 ) // Nome
			cGet2		:= GetChave( _cAlias, _nLin, 6 ) // DDD
			cGet3		:= GetChave( _cAlias, _nLin, 3 ) // CGC
			cGet4		:= GetChave( _cAlias, _nLin, 4 ) // E-mail
			cGet5		:= Capital(cStatus) //Status
			cGet6		:= GetChave( _cAlias, _nLin, 2 ) // Telefone
			
			oGet1:Picture:= GetPict( _cAlias, _nLin, 1 )
			oGet6:Picture:= GetPict( _cAlias, _nLin, 2 )
			oGet4:Picture:= GetPict( _cAlias, _nLin, 4 )
		Endif
		oGet1:Refresh()
		oGet2:Refresh()
		oGet3:Refresh()
		oGet4:Refresh()
		oGet5:Refresh()
		oGet6:Refresh()
	Endif
		   			
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออหอออออออัอออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ GatilhaContatos บ Autor ณ Warleson      บ Data ณ 31/03/13  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออสอออออออฯอออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao ณ Gatilha os campos do contato na tela de atendimento do     บฑฑ
ฑฑบ          ณ Service Desk                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Service Desk - Certisign                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GatilhaContatos( cOrigem )
	U_GATCONT( cOrigem )
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออหอออออออัออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ Grava_Contato บ Autor ณ Warleson       บ Data ณ 31/03/13   บฑฑ
ฑฑฬออออออออออุอออออออออออออออสอออออออฯออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDescricao ณ Realiza a gravacao do contato e gera relacionamento na     บฑฑ
ฑฑบ          ณ tabela AC8                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Service Desk - Certisign                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Grava_Contato()

Local lseek                                                        
Local cCodCont                  
Local nPosNovo
              
	nPosNovo := Len(aContatos)
	
	If !Empty(aContatos[nPosNovo,1])
		DbSelectarea("SU5")	
		dbgoto(aContatos[oLtContatos:nAt,3])	
		lseek:= .T.
	Else
		lseek:= .F.
	Endif

	if lseek
		cCodCont := SU5->U5_CODCONT
	Else
		cCodCont := GetSXENum("SU5","U5_CODCONT")	
	Endif

	Reclock("SU5",!lseek)

	Replace U5_FILIAL	  With  xFilial("SU5")
	Replace U5_CODCONT    With  cCodCont	// Codigo do contato
	Replace U5_CPF		  With  cGet10	 	// CPF
	Replace U5_CONTAT     With  cGet7 		// Nome
	Replace U5_DDD        With  cGet8 		// DDD
	Replace U5_FCOM1      With  cGet9 		// Telefone Comercial 1
	Replace U5_EMAIL      With  cGet11 		// E-mail do Contato

	MsUnlock()

	if !lseek

		ConfirmSx8()
		      
		Grava_Relacionamento( cCodCont )
		
		aContatos[nPosNovo,1] := cCodCont
		aContatos[nPosNovo,2] := cGet7
		aContatos[nPosNovo,3] := SU5->( Recno() )
           
        If Len( aContatos ) > 1            
	  		aContatos := ASort( aContatos,,, { |x,y| x[2] < y[2] } )
			nPosNovo  := AScan( aContatos,   { |x| x[2] == cGet7 } )
		EndIf

		oLtContatos:SetArray( aContatos )
		oLtContatos:nAt := nPosNovo
		oLtContatos:bLine :={|| { aContatos[oLtContatos:nAt,1],;
								  aContatos[oLtContatos:nAt,2] } }
		     
		                         
		PopulaDetalhes(aContatos[oLtContatos:nAt,3])
		
	Endif			
	
	msginfo('Contato Gravado com Sucesso!'+CRLF+'CำDIGO: '+cCodCont+CRLF+'NOME: '+cGet7)

Return .t.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออหอออออออัอออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ ValidaPesquisa บ Autor ณ Warleson      บ Data ณ 31/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออออออออสอออออออฯอออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDescricao ณ Valida chave de pesquisa antes de realizar o processamento บฑฑ
ฑฑบ          ณ de busca.                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Service Desk - Certisign                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidaPesquisa(cPesq)

local lRet		:= .F.
local cPesq		:= ALLTRIM(cPesq)
local aInvalido	:= {" select","select ",'"',"'","<",">"}
Local x  := 0
	if len(cPesq)>2
		lRet:=.T.
		
		For x:=1 to len(aInvalido)
			if aInvalido[x]$cPesq
				lRet:=.F.
				oSayR:CCAPTION:= "Pesquisa invแlida - Favor remover o caracter "+aInvalido[x]
				oPanel1:Show()
				Exit
			Endif
		Next
	Else
		oSayR:CCAPTION:= "Pesquisa invแlida - Digite no mํnimo 3 caracteres!" 
		oPanel1:Show()
	endif

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัอออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ NovoContato บ Autor ณ Gustavo Prudente  บ Data ณ  03/26/13  บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯอออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDescricao ณ Realiza tratamento para criacao de novo contato             บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Service Desk - Certisign                                    บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function NovoContato( lNovo )

Local lPrimeiro := .T.

Default lNovo := .T.

If lNovo
	   
	lPrimeiro := ( Len( aContatos ) == 1 .And. Empty( aContatos[ Len( aContatos ), 1 ] ) )

	If !lPrimeiro
		AAdd( aContatos, { "", "", 0 } )
	EndIf	
	
	PopulaNovo( lNovo, lPrimeiro )
	
Else

	If Len( aContatos ) > 1 .And. Empty( aContatos[ Len( aContatos ), 1 ] )

		nLenContatos := Len( aContatos )
		
		ADel(  aContatos, nLenContatos ) 
		ASize( aContatos, nLenContatos - 1 )

	EndIf

EndIf

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออหอออออออัออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Grava_Relacionamento บAutor  ณ Gustavo Prudente บ Data ณ  03/26/13   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออสอออออออฯออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Cria relacionamento entre a entidade e o contato na tabela AC8.      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Service Desk - Certisign                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Grava_relacionamento( cCodCont )

DbSelectArea("AC8")
DbSetOrder(2) 				//AC8_FILIAL+AC8_ENTIDA+AC8_FILENT+AC8_CODENT+AC8_CODCON

If !(DbSeek(xFilial("AC8")+_cAlias+xFilial(_cAlias)+AllTrim(_cCodEnt+_cLojaEnt)+cCodCont))
	Reclock("AC8",.T.)
	AC8->AC8_FILIAL := xFilial("AC8")
	AC8->AC8_ENTIDA := _cAlias  
	AC8->AC8_FILENT := xFilial(_cAlias)  
	AC8->AC8_CODENT	:= AllTrim(_cCodEnt+_cLojaEnt)
	AC8->AC8_CODCON	:= cCodCont 
	MsUnlock()
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Valida_Contato        บAutor  ณ Gustavo / Warleson บ Data ณ  22/03/12   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Valida Cpf ou CNPJ digitado 				                               บฑฑ
ฑฑบ          ณ Tipo 1 - CPF        	             		                               บฑฑ
ฑฑบ          ณ Tipo 2 - E-mail    	             		                               บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Service Desk - Certisign                                                บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Valida_Contato( nTipo, cVar, lMsg )

Local cSavAlias	:= ""
Local cDVC		:= ""
Local cDIG 		:= ""                
Local cCPF		:= ""
Local cCGC		:= ""
Local cEmail	:= ""

Local nSavRec	:= 0
Local nSavOrd	:= 0
Local nCnt		:= 0
Local i			:= 0
Local j			:= 0
Local nSum		:= 0
Local nDIG		:= 0

Local aEmail 	:= {}

Local lRet 		:= .T.                     

Default cVar	:= ""
Default lMsg	:= .T.

oPanel1:Hide()            

Do Case

	// Validacao de CPF/CNPJ
	Case nTipo == 1
	                 
		If ! Empty( cVar )
			cCpf := cVar
		Else
			cCPF := &( ReadVar() )
		EndIf	
                                                 
		// Permite CPF em branco
		If !Empty( cCPF )
        
			nTamanho := Len( AllTrim( cCPF ) )
			
			// Nao permite campo preenchido com zeros
			If Replicate( '0', nTamanho ) == AllTrim( cCPF )
				If lMsg
					oSayR:CCaption := 'CPF/CNPJ invแlido!'
					oPanel1:Show()
					oBtn4:Show()
				EndIf	
				Return .F.
			EndIf	
	
			If nTamanho < 14
		
				cDVC := SubStr( cCPF, 10, 2 )
				cCPF := SubStr( cCPF, 1, 9 )
				cDIG := ""
		
				For j := 10 To 11
					nCnt := j
					nSum := 0
					For i := 1 To Len(Trim(cCPF))
						nSum += (Val(SubStr(cCPF,i,1))*nCnt)
						nCnt--
					Next i
					nDIG := Iif((nSum%11)<2,0,11-(nSum%11))
					cCPF := cCPF+STR(nDIG,1)
					cDIG := cDIG+STR(nDIG,1)
				Next j
		
				lRet := ( cDIG == cDVC )
				
				If ! lRet
					If lMsg
						oSayR:CCaption := 'CPF/CNPJ invแlido!'
						oPanel1:Show()
						oBtn4:Show()
					EndIf	
				EndIf
		
			Else        
			    
			    cDVC := SubStr( cCPF, 13, 02 )
				cCGC := SubStr( cCPF, 01, 12 )

				For j := 12 To 13
					nCnt := 1
					nSum := 0
					For i := j To 1 Step -1
						nCnt ++
						If nCnt > 9
							nCnt := 2 
						EndIf
						nSum += ( Val( SubStr( cCGC, i, 1 ) ) * nCnt )
					Next i
					nDIG := Iif( ( nSum % 11 ) < 2, 0, 11 - ( nSum % 11 ) )
					cCGC := cCGC + Str( nDIG, 1 )
					cDIG := cDIG + Str( nDIG, 1 )
				Next j

				lRet := ( cDIG == cDVC )
                                           
				If !lRet
				    If lMsg
						oSayR:CCaption := 'CPF/CNPJ invแlido!'
						oPanel1:Show()
						oBtn4:Show()
					EndIf
				EndIf
						
			EndIf

		EndIf               
		
	// Validacao de E-Mail	
	Case nTipo == 2
		     
		If ! Empty( cVar )
			cEmail := cVar
		Else			           
			cEmail := &( ReadVar() )
		EndIf
		
		aEmail := StrTokArr( cEmail, ';' )
		
		If !Empty( cEmail )
			For j := 1 to Len( aEMail )               
				lRet := Testa_email( AllTrim( aEmail[j] ) )
		    	If ! lRet
					If lMsg
						oSayR:CCaption := "E-mail invแlido!" 
						oPanel1:Show()
						oBtn4:Show()												
					EndIf	
					Exit
	    		Endif
			Next j
    	Endif
		
EndCase

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัอออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ teste_email บAutor  ณ Warleson/Opvs   บ Data ณ  27/11/12   บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯอออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ  Valida endere็o d ee-mail                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Service Desk - Certisign                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Testa_email(cEmail)

Local aCharEspecial	:={}
Local nLen			:= len(cEmail)
Local cParteLocal	:= ''
Local cDominio    	:= ''
Local cChave		:= ''
Local cValidPonto	:= ''
local nArroba		:= 0
local nPonto		:= 0
local lRet			:= .F.
Local nX

aCharEspecial		:= {'"',"'",'!','@','#',;
 				 		'$','%','จ','&','*',;
 				 		'(',')','+','=','ด',;
 				 		'`','{','[','}',']',;
 						 '^','~',':',';',',',;
 				 		'<','>','/','\','?',;
 						 '|',' '}
	If nLen >= 5                
		If !('..'$cEmail)
			nArroba:= RAT ('@',cEmail)
			If (nArroba > 1) .and. (nArroba < nLen)
				nPonto:= RAT ('.',cEmail)
				if (nPonto>(nArroba+1)) .and. (nPonto<nLen)
					cParteLocal	:= Substr(cEmail,1,(nArroba-1))
					cDominio	:= Substr(cEmail,(nArroba+1),nLen-nArroba)
				    cValidPonto	:= substr(cParteLocal,1,1)+substr(cParteLocal,len(cParteLocal),1)+substr(cDominio,1,1)
					if !('.'$ cValidPonto)
						cChave := (cParteLocal+cDominio)
						lRet := .T.
						For nX:=1 to len(aCharEspecial)					
							if (aCharEspecial[nX]$cChave)
								lRet:= .F.
								Exit
							Endif
	 					Next
				    Endif
				Endif
			Endif
		Endif
	Endif

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออัออออออออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ PopulaResult  บAutor  ณ Gustavo Prudente บ Data ณ 27/03/13 บฑฑ
ฑฑฬออออออออออุออออออออออสออออฯออออออออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณ Gera dados no vetor aResult a partir da consulta realizada บฑฑ
ฑฑบ          ณ nas entidades.                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Service Desk - Certisign                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PopulaResult( lRecAC8 )

Local nPos := 0

Default lRecAC8 := .F.     

Do While ! Eof()
	
	nPos := Ascan( aRecno, { |x| x[1] == ALIAS } )
	
	//Captura o RECNO Mแximo de Cada Alias/Entidade
	If nPos > 0 .And. Iif( lRecAC8, AC8_RECNO,RECNO) > aRecno[nPos,2] 
		aRecno[ nPos, 2 ] := Iif( lRecAC8, AC8_RECNO,RECNO)
	Endif
	 
    AAdd( aPesqResult[ Len( aPesqResult ) ], { STATUS, CHAVE, ALIAS, RECNO, Iif( lRecAC8, AC8_RECNO, 0 ) } )
	    
	DbSkip()
	
EndDo

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GetChave บAutor  ณ Gustavo Prudente   บ Data ณ  10/04/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Trata retorno de chave de acordo com o campo do nivel      บฑฑ
ฑฑบ          ณ atual de pesquisa                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Service Desk - Certisign                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetChave( cAlias, nEntidade, nCampo )
           
Local cRet := ""           
           
If (cAlias)->( FieldPos( aChaves[ nEntidade, nCampo ] ) ) > 0
	cRet := (cAlias)->( FieldGet( FieldPos( aChaves[ nEntidade, nCampo ] ) ) )
EndIf

Return cRet
           

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GetPict  บAutor  ณ Gustavo Prudente   บ Data ณ  10/04/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Trata retorno de picture de acordo com o campo de chave    บฑฑ
ฑฑบ          ณ do nivel selecionado para pesquisa.                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Service Desk - Certisign                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetPict( cAlias, nEntidade, nCampo )

Local cRet := "@!"

If !Empty( aChaves[ nEntidade, nCampo] )
	cRet := PesqPict( cAlias, aChaves[ nEntidade, nCampo ] )
EndIf	

Return cRet
      
/*
-------------------------------------------------------------------------
| Rotina    | IncSuspect | Autor | Gustavo Prudente | Data | 03.06.2013 |
|-----------------------------------------------------------------------|
| Descricao | Cria opcao de inclusao de suspect caso o resultado da     |
|           | pesquisa nao seja encontrado.                             |
|-----------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                       |
-------------------------------------------------------------------------
*/
Static Function IncSuspect()

Local oSay1
Local oSay2
Local oSay3
Local oSay4
Local oSay5   

Local oGet1
Local oGet2
Local oGet3
Local oGet4
Local oGet5
Local oGet6
     
Local oBtn1
Local oBtn2

Local cGetNome
Local cGetDDD
Local cGetTel
Local cGetCPF
Local cGetEmail
Local cGetStatus

Local bDelMsg	:= { || oSayR:cCaption := "", oPanel1:Show(), oBtn4:Hide() }
                                                            
Local bGrava	:= { || Oculta(), GrvSuspect(  cGetNome, cGetDDD, cGetTel, cGetCPF, cGetEmail ) }
Local bPesq		:= { || PesqSuspect( cGetNome, cGetDDD, cGetTel, cGetCPF, cGetEmail ), Buscar( cPesq + '%' ) }
Local bValida	:= { || ValSuspect( cGetNome, cGetDDD, cGetTel, cGetCPF, cGetEMail, oGet1 ) }

Local cTxtPesq	:= 'PESQUISAR POR ' + Upper( SubStr( aBusca[oFld2:nOption], 2, Len(aBusca[oFld2:nOption] ) ) ) + '...' + Space( 200 )

Local nRemoteType := GetRemoteType() 	
          
// Suspect
_nLin := 3      
                                       
// Define campos para inclusao dos dados do Suspect
cGetNome	:= Space( TamSX3( aChaves[ _nLin, 1 ] )[1] )
cGetDDD		:= Space( TamSX3( aChaves[ _nLin, 6 ] )[1] )
cGetTel		:= Space( TamSX3( aChaves[ _nLin, 2 ] )[1] )
cGetCPF		:= Space( TamSX3( aChaves[ _nLin, 3 ] )[1] )
cGetEmail	:= Space( TamSX3( aChaves[ _nLin, 4 ] )[1] )
cGetStatus	:= "SUSPECT"	// Status

oSay1	:= tSay():New( 02, 02, { || 'Nome'		}, oPanelSus,,,,,,.T.,rgb(0,0,0),,35,8 )
oSay2	:= tSay():New( 12, 02, { || 'DDD'		}, oPanelSus,,,,,,.T.,rgb(0,0,0),,35,8 )
oSay3	:= tSay():New( 22, 02, { || 'Telefone'	}, oPanelSus,,,,,,.T.,rgb(0,0,0),,35,8 )
oSay4	:= tSay():New( 32, 02, { || 'CPF/CNPJ'	}, oPanelSus,,,,,,.T.,rgb(0,0,0),,35,8 )
oSay5	:= tSay():New( 42, 02, { || 'E-mail'	}, oPanelSus,,,,,,.T.,rgb(0,0,0),,35,8 )
oSay6	:= tSay():New( 52, 02, { || 'Status'	}, oPanelSus,,,,,,.T.,rgb(0,0,0),,35,8 )

@ 01,30 MSGET oGet1 Var cGetNome 	PICTURE "@!" SIZE 146,8 PIXEL OF oPanelSus 
@ 11,30 MSGET oGet2 Var cGetDDD	 	PICTURE "@!" SIZE 146,8 PIXEL OF oPanelSus 
@ 21,30 MSGET oGet3 Var cGetTel  	PICTURE "@!" SIZE 146,8 PIXEL OF oPanelSus 
@ 31,30 MSGET oGet4 Var cGetCPF 	PICTURE "@!" SIZE 146,8 PIXEL OF oPanelSus ;
		VALID Iif( Empty( cGetCPF ), Eval( bDelMsg ), Iif( Valida_Contato( 1, cGetCPF    , .T. ), Eval( bDelMsg ), .F. ) )
		
@ 41,30 MSGET oGet5 Var cGetEmail	PICTURE "@!" SIZE 146,8 PIXEL OF oPanelSus ;
		VALID Iif( Empty( cGetEmail ), Eval( bDelMsg ), Iif( Valida_Contato( 2, cGetEMail, .T. ), Eval( bDelMsg ), .F. ) )
		
@ 51,30 MSGET oGet6 Var cGetStatus	PICTURE "@!" SIZE 146,8 PIXEL OF oPanelSus READONLY
                                                   
// Botoes para salvar ou cancelar, definidos dentro do painel oBtnSus
oBtn1 := TButton():New( 0, 0.5,  "Salvar"  , oBtnSus, { || Iif( Eval( bValida )  , ;
															  (	Eval( bGrava  )  , ;
																Eval( bPesq   ) ), ;
																.F. ) }, ;
															035, 11,,,,.T.,,"",,,,.F. )

oBtn2 := TButton():New( 0, 35.5, "Cancelar", oBtnSus, { || cPesq := cTxtPesq, Oculta() }, 035, 11,,,,.T.,,"",,,,.F. )

If nRemoteType # 5
	oBtn1:SetCss( "QPushButton{}" )
	oBtn2:SetCss( "QPushButton{}" )
EndIf

// Altera a cor do painel para inclusao
oPanelSus:nClrPane := RGB( 208, 208, 242 )
                             
oGet1:SetFocus()

// Inibe mensagem do resultado da busca
oSayR:cCaption := ""
oBtn4:Hide()
oPanel1:Show()
     
// Habilita objetos para permitir a inclusao de um novo suspect
oGrpSus:Show()
oPanelSus:Show()
oBtnSus:Show()
oPanelList:Show()

oBtnInc:Disable()

Return

/*
-------------------------------------------------------------------------
| Rotina    | GrvSuspect | Autor | Gustavo Prudente | Data | 04.06.2013 |
|-----------------------------------------------------------------------|
| Descricao | Grava dados da nova entidade como Suspect.                |
|-----------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                       |
-------------------------------------------------------------------------
*/
Static Function GrvSuspect( cGetNome, cGetDDD, cGetTel, cGetCPF, cGetEmail )
                        
Local aArea := GetArea()

ACH->( DbSetOrder( 1 ) )

RecLock( "ACH", .T. )

ACH->ACH_FILIAL	:= xFilial( "ACH" )
ACH->ACH_CODIGO := GetSXENum( "ACH", "ACH_CODIGO" )
ACH->ACH_LOJA	:= "01"
ACH->ACH_RAZAO  := cGetNome
ACH->ACH_TIPO	:= "1"
ACH->ACH_CGC	:= cGetCPF
ACH->ACH_DDD	:= cGetDDD
ACH->ACH_TEL	:= cGetTel
ACH->ACH_EMAIL	:= cGetEmail

ACH->( MsUnlock() )

ConfirmSx8()

RestArea( aArea )

Return

/*
---------------------------------------------------------------------------
| Rotina    | PesqSuspect | Autor | Gustavo Prudente | Data | 04.06.2013  |
|-------------------------------------------------------------------------|
| Descricao | Pesquisa Suspect incluso e prepara para inclusใo do contato |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
Static Function PesqSuspect( cGetNome, cGetDDD, cGetTel, cGetCPF, cGetEmail )
                                                              
Local _nLin	:= 3	// Suspect                                                         

If ! Empty( cGetCPF )
	oFld2:nOption := aScan( aChaves[_nLin], { |x| x == "ACH_CGC"   } )
	cPesq := AllTrim( cGetCPF )
	oPesq:Refresh()
                                                         
ElseIf ! Empty( cGetTel )
	oFld2:nOption := aScan( aChaves[_nLin], { |x| x == "ACH_TEL"   } )
	cPesq := AllTrim( cGetTel )
	oPesq:Refresh()
	
ElseIf ! Empty( cGetNome )
	oFld2:nOption := aScan( aChaves[_nLin], { |x| x == "ACH_RAZAO" } )
	cPesq := AllTrim( Upper( cGetNome ) )
	oPesq:Refresh()
	
ElseIf ! Empty( cGetEMail )
	oFld2:nOption := aScan( aChaves[_nLin], { |x| x == "ACH_EMAIL" } )
	cPesq := AllTrim( Upper( cGetEMail ) )
	oPesq:Refresh()
	
EndIf

Return


/*
---------------------------------------------------------------------------
| Rotina    | ValSuspect  | Autor | Gustavo Prudente | Data | 04.06.2013  |
|-------------------------------------------------------------------------|
| Descricao | Valida dados para permitir a inclusao do Suspect.           |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
Static Function ValSuspect( cGetNome, cGetDDD, cGetTel, cGetCPF, cGetEMail, oGet1 )
               
Local lRet := .T.

If 	Empty( cGetNome ) .Or. ( Empty( cGetNome ) .And. Empty( cGetDDD ) .And. Empty( cGetTel ) .And. Empty( cGetCPF ) .And. Empty( cGetEMail ) )

	oSayR:cCaption := "Inclusใo invแlida! Campo Nome deve ser preenchido."
	oBtn4:Show()
	oPanel1:Show()
	oGet1:SetFocus()	
	lRet := .F.           

EndIf

Return lRet


/*
---------------------------------------------------------------------------
| Rotina    | RetChvQry   | Autor | Gustavo Prudente | Data | 27.06.2013  |
|-------------------------------------------------------------------------|
| Descricao | Retorna a chave de pesquisa para montar a clausula where    |
|           | da query principal, com uso de funcao se necessario         |
|-------------------------------------------------------------------------|
| Parametros| EXPL1 - Indica se usa funcao para tratamento da chave       |
|           | EXPC2 - Campo de chave de pesquisa da tabela do nivel atual |
|           | EXPC3 - String efetiva para pesquisa                        |
|           | EXPC4 - Numero da "aba" selecionada para pesquisa           |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
Static Function RetChvQry( lFuncao, cCpoChv, cChave, nOption )
              
Local cRet := ""
              
If lFuncao
	cRet += " AND UPPER( " + cCpoChv + " ) LIKE '" + cChave + "'" + CRLF
Else  
	If nOption == 1			// Nome
		cChave := Upper( cChave )		
	ElseIf nOption == 4		// Email
		cChave := Lower( cChave )
	EndIf
	cRet += "  AND " + cCpoChv + " LIKE '" + cChave + "'" + CRLF
EndIf
              
Return( cRet )