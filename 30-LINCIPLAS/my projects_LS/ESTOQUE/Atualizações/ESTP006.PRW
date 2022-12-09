#INCLUDE "PROTHEUS.CH"

User Function ESTP006()

Local aArea  	:= GetArea()
Local cAlias  	:= "SF1"
Local aCores	:= {}

Private aRotina    := {}
Private cCadastro  := "Laselva - Classificacao"

Private aLegenda := {;
{'ENABLE'	  	,'NF Nao Classificada'	, 'Empty(F1_STATUS)'},;
{'BR_LARANJA'	,'NF Bloqueada'			, 'B'	},;
{'BR_DISABLE'	,'NF Normal'			, 'N'	},;
{'BR_AZUL'		,'NF Compl. IPI'		, 'P'	},;
{'BR_MARRON'	,'NF Compl. ICMS'		, 'I'	},;
{'BR_PINK'		,'NF Compl. Preco'		, 'C'	},;
{'BR_CINZA'		,'NF de Beneficiamento'	, 'B'	},;
{'BR_AMARELO'	,'NF de Devolucao'		, 'D'	}}

aCores	:= {{ 'Empty(F1_STATUS)', 'ENABLE' },; // NF Nao Classificada
	{'F1_STATUS=="B"','BR_LARANJA'},; // NF Bloqueada
	{'F1_TIPO=="N"', 'DISABLE'   },; // NF Normal
	{'F1_TIPO=="P"', 'BR_AZUL'   },; // NF de Compl. IPI
	{'F1_TIPO=="I"', 'BR_MARRON' },;	 // NF de Compl. ICMS
	{'F1_TIPO=="C"', 'BR_PINK'   },;	 // NF de Compl. Preco/Frete
	{'F1_TIPO=="B"', 'BR_CINZA'  },;	 // NF de Beneficiamento
	{'F1_TIPO=="D"', 'BR_AMARELO'} }	 // NF de Devolucao

Aadd(aRotina,{"Pesquisar" 			,"AxPesqui"	   		,0,1 })
Aadd(aRotina,{"Classificar"  		,"U_Estp06" 		,0,2 })
Aadd(aRotina,{"Legenda"  			,"U_EstpL"			,0,3 })

mBrowse( 7, 4,20,74,cAlias,,,,,,aCores)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Restaura a integridade da rotina                               �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
DbSelectArea(cAlias)
RestArea(aArea)

Return(.T.)

User Function Estp06()

Local aArea		:= GetArea()
Local _nReg		:= 0
Local aCabec	:= {}
Local aLinha	:= {}	
Local aItens	:= {}     
Local _cNumNF	:= Space(9)
Private lMsErroAuto := .F.

DbSelectArea("SD1")
SD1->( DbSetOrder(1) )                                    
If SD1->( DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA) )     
		
	While SD1->( !Eof() ) .And. SD1->D1_FILIAL == xFilial("SD1") .And. SD1->D1_DOC == SF1->F1_DOC .And. SD1->D1_SERIE == SF1->F1_SERIE .And. SD1->D1_FORNECE == SF1->F1_FORNECE .And. SD1->D1_LOJA == SF1->F1_LOJA
		
		If Empty(_cNumNF)
			
			_cNumNF := SD1->D1_DOC
						
			Aadd(aCabec,{"F1_TIPO"    , "B"})
			Aadd(aCabec,{"F1_FORMUL"  , "N"})
			Aadd(aCabec,{"F1_DOC"     , SD1->D1_DOC})
			Aadd(aCabec,{"F1_SERIE"   , SD1->D1_SERIE})
			Aadd(aCabec,{"F1_EMISSAO" , SD1->D1_EMISSAO})
			Aadd(aCabec,{"F1_DTDIGIT" , SD1->D1_DTDIGIT})
			Aadd(aCabec,{"F1_FORNECE" , SD1->D1_FORNECE})
			Aadd(aCabec,{"F1_LOJA"    , SD1->D1_LOJA})
			Aadd(aCabec,{"F1_ESPECIE" , "NFE"})
			Aadd(aCabec,{"F1_COND"    , "075"})
				
		EndIf                                    
					
		aLinha	:= {} 
											
		Aadd(aLinha,{"D1_COD"    , SD1->D1_COD 					,Nil})
		Aadd(aLinha,{"D1_QUANT"  , SD1->D1_QUANT				,Nil})
		Aadd(aLinha,{"D1_VUNIT"  , SD1->D1_VUNIT				,Nil})
		Aadd(aLinha,{"D1_TOTAL"  , SD1->D1_QUANT*SD1->D1_VUNIT	,Nil})
		Aadd(aLinha,{"D1_LOCAL"  , SD1->D1_LOCAL				,Nil})
		Aadd(aLinha,{"D1_TES"    , "231"						,Nil})
									
		aAdd(aItens,aLinha)
		_nReg++
			
		SD1->( DbSkip() )
					
	EndDo

EndIf	

If _nReg > 0
	
	MSExecAuto({|x,y,z|Mata103(x,y,z)},aCabec,aItens,4)
	
	If lMsErroAuto
		MostraErro()
	Else
		MsgInfo("Processamento efetuado com sucesso!")
	EndIf	

EndIf	
		
RestArea(aArea)

Return

User Function EstpL()

BrwLegenda("Laselva - Classificacao",'Legenda',;
	{{'ENABLE'	  	,'NF Nao Classificada'	},;
	{'BR_LARANJA'	,'NF Bloqueada'			},;
	{'BR_DISABLE'	,'NF Normal'			},;
	{'BR_AZUL'		,'NF Compl. IPI'		},;
	{'BR_MARRON'	,'NF Compl. ICMS'		},;
	{'BR_PINK'		,'NF Compl. Preco'		},;
	{'BR_CINZA'		,'NF de Beneficiamento'	},;
	{'BR_AMARELO'	,'NF de Devolucao'		}})			
				
Return(.T.) 