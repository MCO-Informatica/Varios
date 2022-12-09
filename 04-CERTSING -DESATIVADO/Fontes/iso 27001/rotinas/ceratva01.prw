#INCLUDE "PROTHEUS.CH"

// DATA DE IMPLANTACAO NA PRODUCAO	: 22/10/2012
// DATA DA ULTIMA ALTERACAO			: 22/10/2012


#DEFINE ALIAS_DA_TABELA 	"SZZ"  	// Apos implantacao, não mudar de maneira alguma essa informação     
#DEFINE F3_FORMATO			"ZE"	// Apos implantacao, não mudar de maneira alguma essa informação      
#DEFINE F3_CLASSIF			"ZH"	// Apos implantacao, não mudar de maneira alguma essa informação      
#DEFINE F3_GERCHAV			"ZI"	// Apos implantacao, não mudar de maneira alguma essa informação     

#DEFINE DATA_DO_COMPATIBILIZADOR  Stod("20121022") // Data do compatibilizador


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Funcao   ³ CSATVA01  ³ Autor ³ Marcelo Celi Marques ³ Data ³02/10/2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Cadastro de inventario de Ativos.	                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Certisign		                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function CSATVA01()
Local lFiltrTipo	:= GetNewPar("CS_FILTPAT","S")=="S"
Local cCondFilt		:= ""
Local lAbriu		:= .F.

Private aRotina 	:= MenuDef()
Private cCadastro 	:="Inventário de Ativos ISO 27.001"
Private lAltera		:= .F.
Private cPergunte	:= "CSATVA01"
Private _cGrupos 	:= u_SCSGSIGRP()    
	
If !CanUseRot()
	MsgAlert("Rotina não pode ser executada ates que o compatibilizador u_CSUpdAtv1() seja aplicado na base.")
Else
	SCAtuSx5()
	If lFiltrTipo  
		For nX:=1 to 6
			If u_SCSGSIUse(Alltrim(Str(nX))+u_SCGetIdFu("CSATV1VIS"))
				If nX>1 .And. !Empty(cCondFilt) 
					cCondFilt+=" .Or. "
				ElseIf nX==1
					cCondFilt+= "( "
					lAbriu := .T.
				EndIf				
				cCondFilt+=ALIAS_DA_TABELA+"->"+Right(ALIAS_DA_TABELA,2)+"_TIPO=='"+Alltrim(Str(nX))+"'"					
			EndIf	     
		Next nX
	    If Empty(cCondFilt) 
	    	cCondFilt := ALIAS_DA_TABELA+"->"+Right(ALIAS_DA_TABELA,2)+"_TIPO==''"
	    EndIf
	    If lAbriu
		    cCondFilt+=")"
		EndIf
	    
	    //->> Condicao para filtrar ativos por departamento
	    cCondFilt += " .And. (" + u_SCFiltGTI(ALIAS_DA_TABELA,Right(ALIAS_DA_TABELA,2)+"_CODGRP") + ")"
	    
	    dbSelectArea(ALIAS_DA_TABELA)
	    Set Filter to &cCondFilt
	    	
	EndIf
		
	mBrowse( 6, 1,22,75,ALIAS_DA_TABELA,,,,,,u_CSATV1LEG())
	
	If lFiltrTipo	
		dbSelectArea(ALIAS_DA_TABELA)
	 	Set Filter to 
	EndIf
	
EndIf
	
Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CSATV1LEG  ³ Autor ³ Marcelo Celi Marques ³ Data ³ 01/10/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Legenda.							                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Certisign                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CSATV1LEG(cAlias,nReg)
Local uRetorno := .T.
Local aLegenda := {	{"BR_VERDE"		, 	"Informação"		},;	    
				   	{"BR_AZUL"		, 	"Software"			},;	   	 
				   	{"BR_AMARELO"	, 	"Físico"			},;	   	
				   	{"BR_BRANCO"	, 	"Serviços"			},;	   	
				   	{"BR_PINK"		, 	"Intangíveis"		},;	   	
				   	{"BR_CINZA"		, 	"Pessoas"			}}	   	

If nReg = Nil	
	uRetorno := {}
	Aadd(uRetorno, {Right(ALIAS_DA_TABELA,2)+"_TIPO == '1' "		, aLegenda[1][1]})  
	Aadd(uRetorno, {Right(ALIAS_DA_TABELA,2)+"_TIPO == '2' "		, aLegenda[2][1]})  
	Aadd(uRetorno, {Right(ALIAS_DA_TABELA,2)+"_TIPO == '3' "		, aLegenda[3][1]})  
	Aadd(uRetorno, {Right(ALIAS_DA_TABELA,2)+"_TIPO == '4' "		, aLegenda[4][1]})  
	Aadd(uRetorno, {Right(ALIAS_DA_TABELA,2)+"_TIPO == '5' "		, aLegenda[5][1]})  
	Aadd(uRetorno, {Right(ALIAS_DA_TABELA,2)+"_TIPO == '6' "		, aLegenda[6][1]})  
Else
	BrwLegenda(cCadastro,"Legenda",aLegenda) 
Endif

Return uRetorno

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CSUpdAtv1  ³ Autor ³ Marcelo Celi Marques ³ Data ³ 01/10/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Atualizacao dos SXs.				                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Certisign                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
#DEFINE X3_USADO_EMUSO 		"€€€€€€€€€€€€€€ "
#DEFINE X3_USADO_NAOUSADO 	"€€€€€€€€€€€€€€€"   

User Function CSUpdAtv1(lMenu)
Local aSX2 		:= {}
Local aSX3 		:= {}
Local aSIX 		:= {}   
Local aSXB		:= {}
Local aSX5		:= {}
Local aEstrut	:= {}
Local aTabelas	:= {ALIAS_DA_TABELA,"CN9","RD0","U04","U00"}
Local i, j    
Local aArea		:= GetArea()     
Local cPergunte	:= "CSATVA01"

Default lMenu := .T.

Private lUpdAuto //:= .F.    

SX3->(dbSetOrder(2))
If !lMenu .And. SX3->(dbSeek(Right(ALIAS_DA_TABELA,2)+"_FILIAL"))
	Return
Else
	//->> Criacao da Tabela
	aEstrut:= {"X2_CHAVE"		,"X2_PATH"		,"X2_ARQUIVO"			,"X2_NOME"								,"X2_NOMESPAC"							,"X2_NOMEENGC"							,"X2_DELET"	,"X2_MODO"		,"X2_TTS"	,"X2_ROTINA"	}
	aAdd(aSX2,{ALIAS_DA_TABELA	,"\DADOSADV\"	,ALIAS_DA_TABELA+"990"	,"CADASTRO DE INVENTARIOS DE ATIVOS"	,"CADASTRO DE INVENTARIOS DE ATIVOS"	,"CADASTRO DE INVENTARIOS DE ATIVOS"	,0			,"E"			,""			,""				})	
	
	dbSelectArea("SX2")
	dbSetOrder(1)
	dbSeek("SE1")
	cPath := SX2->X2_PATH
	cNome := Substr(SX2->X2_ARQUIVO,4,5)
	cModo	:= "E"
	
	For i:= 1 To Len(aSX2)
		If !dbSeek(aSX2[i,1])
			RecLock("SX2",.T.) 
		Else
			RecLock("SX2",.F.)	
		EndIf			
		For j:=1 To Len(aSX2[i])
			If FieldPos(aEstrut[j]) > 0
				FieldPut(FieldPos(aEstrut[j]),aSX2[i,j])
			EndIf
		Next j
		SX2->X2_PATH    := cPath
		SX2->X2_ARQUIVO := aSX2[i,1]+cNome
		SX2->X2_MODO    := cModo
		dbCommit()
		MsUnLock()
	Next i
	
	//->> Criacao dos campos da tabela
	aEstrut:= 	{	"X3_ARQUIVO"		,"X3_ORDEM" ,"X3_CAMPO"  						,"X3_TIPO"  ,"X3_TAMANHO"				,"X3_DECIMAL"				,"X3_TITULO" 	,"X3_TITSPA","X3_TITENG","X3_DESCRIC"			,"X3_DESCSPA"	,"X3_DESCENG"	,"X3_PICTURE"			,"X3_VALID" 												 									,"X3_USADO"  		,"X3_RELACAO"							  																										,"X3_F3"			,"X3_NIVEL" ,"X3_RESERV","X3_CHECK"	,"X3_TRIGGER"	,"X3_PROPRI","X3_BROWSE","X3_VISUAL","X3_CONTEXT"	,"X3_OBRIGAT"	,"X3_VLDUSER"									,"X3_CBOX"   															,"X3_CBOXSPA"	,"X3_CBOXENG"	,"X3_PICTVAR"	,"X3_WHEN"  																		,"X3_INIBRW"																									  			,"X3_GRPSXG","X3_FOLDER"	,"X3_PYME"	}			
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"01"		,Right(ALIAS_DA_TABELA,2)+"_FILIAL"	,"C"		, Tamsx3("E1_FILIAL")[1]	, Tamsx3("E1_FILIAL")[2]	,"Filial"		,""			,""			,"Filial"				,""				,""				,"@!"					,""										   					  									,"€€€€€€€€€€€€€€€"	,"xFilial('"+ALIAS_DA_TABELA+"')" 		  																										,""					,1			,"şÀ"		,""			,""				,"S"		,"S"		,""			,""				,""				,""												,""																		,""				,""				,""				,"u_CSVlAlAtv('"+ALIAS_DA_TABELA+"','"+Right(ALIAS_DA_TABELA,2)+"_FILIAL')"			,""																												  			,""			,""				,"S"		})
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"02"		,Right(ALIAS_DA_TABELA,2)+"_TIPO"	,"C"		, 01						, 0							,"Tipo"			,""			,""			,"Tipo"					,""				,""				,"@!"					,""										   					  									,"€€€€€€€€€€€€€€ "	,"If(ISINCALLSTACK('u_CSATV1INC'),_cTipoAtv,'')"	 		  																					,""					,1			,"şÀ"		,""			,""				,"S"		,"S"		,""			,""				,""				,""												,"1=Informação;2=Software;3=Físico;4=Serviços;5=Intangíveis;6=Pessoas"	,""				,""				,""				,".F."																				,""																												  			,""			,""				,"S"		})
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"03"		,Right(ALIAS_DA_TABELA,2)+"_CODIGO"	,"C"		, 15						, 0							,"Codigo"		,""			,""			,"Codigo"				,""				,""				,"@!"					,"ExistChav('"+ALIAS_DA_TABELA+"',M->"+Right(ALIAS_DA_TABELA,2)+"_COD)"							,"€€€€€€€€€€€€€€ "	,"u_GetNewCodigo('"+ALIAS_DA_TABELA+"')" 																										,""					,1			,"şÀ"		,""			,""				,"S"		,"S"		,""			,""				,"€"			,""												,""																		,""				,""				,""				,".F."																				,""																												  			,""			,""				,"S"		})
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"04"		,Right(ALIAS_DA_TABELA,2)+"_PARTIC"	,"C"		, Tamsx3("RD0_CODIGO")[1]	, 0							,"Particip."	,""			,""			,"Participante"			,""				,""				,"@!"					,"Vazio() .Or. ExistCpo('RD0',M->"+Right(ALIAS_DA_TABELA,2)+"_PARTIC,,,,.F.)"					,"€€€€€€€€€€€€€€ "	,"" 																																			,"RD0"				,1			,"şÀ"		,""			,""				,"S"		,"N"		,""			,""				,""				,"u_CSGetPess()"								,""																		,""				,""				,""				,"u_CSVlAlAtv('"+ALIAS_DA_TABELA+"','"+Right(ALIAS_DA_TABELA,2)+"_PARTIC')"			,""																												  			,""			,""				,"S"		}) 	
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"05"		,Right(ALIAS_DA_TABELA,2)+"_CODSFT"	,"C"		, Tamsx3("U04_CODSFT")[1]	, 0							,"Software"		,""			,""			,"Software"				,""				,""				,"@!"					,"Vazio() .Or. ExistCpo('U04',M->"+Right(ALIAS_DA_TABELA,2)+"_CODSFT,,,,.F.)"					,"€€€€€€€€€€€€€€ "	,"" 																																			,"U04XISO"			,1			,"şÀ"		,""			,""				,"S"		,"N"		,""			,""				,""				,"u_CSGetSoft()"								,""																		,""				,""				,""				,"u_CSVlAlAtv('"+ALIAS_DA_TABELA+"','"+Right(ALIAS_DA_TABELA,2)+"_CODSFT')"			,""																												  			,""			,""				,"S"		}) 	 
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"06"		,Right(ALIAS_DA_TABELA,2)+"_CODHRD"	,"C"		, Tamsx3("U00_CODHRD")[1]	, 0							,"Hardware"		,""			,""			,"Hardware"				,""				,""				,"@!"					,"Vazio() .Or. ExistCpo('U00',M->"+Right(ALIAS_DA_TABELA,2)+"_CODHRD,,,,.F.)"					,"€€€€€€€€€€€€€€ "	,"" 																																			,"U00XISO"			,1			,"şÀ"		,""			,""				,"S"		,"N"		,""			,""				,""				,"u_CSGetHard()"								,""																		,""				,""				,""				,"u_CSVlAlAtv('"+ALIAS_DA_TABELA+"','"+Right(ALIAS_DA_TABELA,2)+"_CODHRD')"			,""																												  			,""			,""				,"S"		}) 	
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"07"		,Right(ALIAS_DA_TABELA,2)+"_NOME"	,"C"		, 40						, 0							,"Nome"			,""			,""			,"Nome"					,""				,""				,"@!"					,""																								,"€€€€€€€€€€€€€€ "	,"" 																																			,""					,1			,"şÀ"		,""			,""				,"S"		,"S"		,"V"		,"V"			,"€"			,""												,""																		,""				,""				,""				,"u_CSVlAlAtv('"+ALIAS_DA_TABELA+"','"+Right(ALIAS_DA_TABELA,2)+"_NOME')"			,""																												  			,""			,""				,"S"		}) 	
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"08"		,Right(ALIAS_DA_TABELA,2)+"_FUNCAO"	,"C"		, 40						, 0							,"Função"		,""			,""			,"Função"				,""				,""				,"@!"					,""																								,"€€€€€€€€€€€€€€ "	,"" 																																			,""					,1			,"şÀ"		,""			,""				,"S"		,"N"		,""			,""				,""				,""												,""																		,""				,""				,""				,"u_CSVlAlAtv('"+ALIAS_DA_TABELA+"','"+Right(ALIAS_DA_TABELA,2)+"_FUNCAO')"			,""																												  			,""			,""				,"S"		}) 	
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"09"		,Right(ALIAS_DA_TABELA,2)+"_FGCHAV"	,"C"		, 03						, 0							,"Ger.Chaves"	,""			,""			,"Func. Gerencia Chaves",""				,""				,"@!"					,""																								,"€€€€€€€€€€€€€€ "	,"" 																																			,F3_GERCHAV			,1			,"şÀ"		,""			,""				,"S"		,"N"		,""			,""				,""				,""												,""																		,""				,""				,""				,"u_CSVlAlAtv('"+ALIAS_DA_TABELA+"','"+Right(ALIAS_DA_TABELA,2)+"_FGCHAV')"			,""																												  			,""			,""				,"S"		}) 	
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"10"		,Right(ALIAS_DA_TABELA,2)+"_SUPERI"	,"C"		, 40						, 0							,"Superior Imed",""			,""			,"Superior Imediato"	,""				,""				,"@!"					,""																								,"€€€€€€€€€€€€€€ "	,"" 																																			,""					,1			,"şÀ"		,""			,""				,"S"		,"N"		,""			,""				,""				,""												,""																		,""				,""				,""				,"u_CSVlAlAtv('"+ALIAS_DA_TABELA+"','"+Right(ALIAS_DA_TABELA,2)+"_SUPERI')"			,""																												  			,""			,""				,"S"		}) 	
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"11"		,Right(ALIAS_DA_TABELA,2)+"_AVALDE"	,"N"		, 06						, 0							,"Aval.Desempen",""			,""			,"Niv. Aval. Desempenho",""				,""				,"@E 999.99"			,""																								,"€€€€€€€€€€€€€€ "	,"" 																																			,""					,1			,"şÀ"		,""			,""				,"S"		,"N"		,""			,""				,""				,""												,""																		,""				,""				,""				,"u_CSVlAlAtv('"+ALIAS_DA_TABELA+"','"+Right(ALIAS_DA_TABELA,2)+"_AVALDE')"			,""																												  			,""			,""				,"S"		}) 	
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"12"		,Right(ALIAS_DA_TABELA,2)+"_CLASS"	,"C"		, 03						, 0							,"Classificação",""			,""			,"Classificação"		,""				,""				,"@!"					,"ExistCpo('SX5','"+F3_CLASSIF+"'+M->"+Right(ALIAS_DA_TABELA,2)+"_CLASS)"						,"€€€€€€€€€€€€€€ "	,""										  																										,F3_CLASSIF			,1			,"şÀ"		,""			,""				,"S"		,"N"		,""			,""				,""				,"u_CSGetFATV(,'C')"							,""																		,""				,""				,""				,"u_CSVlAlAtv('"+ALIAS_DA_TABELA+"','"+Right(ALIAS_DA_TABELA,2)+"_CLASS')"			,""																					  							  			,""			,""				,"S"		})
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"13"		,Right(ALIAS_DA_TABELA,2)+"_DSCLAS"	,"C"		, 20						, 0							,"Desc.Classif" ,""			,""			,"Descrição Classif."	,""				,""				,"@!"					,""																								,"€€€€€€€€€€€€€€ "	,""																																		 		,""					,1			,"şÀ"		,""			,""				,"S"		,"N"		,"V"		,""				,""				,""												,""																		,""				,""				,""				,"u_CSVlAlAtv('"+ALIAS_DA_TABELA+"','"+Right(ALIAS_DA_TABELA,2)+"_DSCLAS')"			,"Posicione('SX5',1,xFilial('SX5')+'"+F3_CLASSIF+"'+"+ALIAS_DA_TABELA+"->"+Right(ALIAS_DA_TABELA,2)+"_CLASS,'X5_DESCRI')"	,""			,""				,"S"		})	    
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"14"		,Right(ALIAS_DA_TABELA,2)+"_PREST"	,"C"		, Tamsx3("A2_COD")[1]		, 0							,"Prest.Serv"	,""			,""			,"Prestador Serviço"	,""				,""				,"@!"					,"Vazio() .Or. ExistCpo('SA2',M->"+Right(ALIAS_DA_TABELA,2)+"_PREST,,,,.F.)"					,"€€€€€€€€€€€€€€ "	,"" 																																			,"SA2"				,1			,"şÀ"		,""			,""				,"S"		,""			,""			,""				,""				,""												,""																		,""				,""				,""				,"u_CSVlAlAtv('"+ALIAS_DA_TABELA+"','"+Right(ALIAS_DA_TABELA,2)+"_PREST')"			,""																															,""			,""				,"S"		}) 	 
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"15"		,Right(ALIAS_DA_TABELA,2)+"_LOJA"	,"C"		, Tamsx3("A2_LOJA")[1]		, 0							,"Loja"			,""			,""			,"Loja"					,""				,""				,"@!"					,"ExistCpo('SA2',M->"+Right(ALIAS_DA_TABELA,2)+"_PREST+M->"+Right(ALIAS_DA_TABELA,2)+"_LOJA)"	,"€€€€€€€€€€€€€€ "	,"" 																																			,""					,1			,"şÀ"		,""			,""				,"S"		,""			,""			,""				,""				,""												,""																		,""				,""				,""				,"u_CSVlAlAtv('"+ALIAS_DA_TABELA+"','"+Right(ALIAS_DA_TABELA,2)+"_LOJA')"			,""																															,""			,""				,"S"		}) 	
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"16"		,Right(ALIAS_DA_TABELA,2)+"_CONTR"	,"C"		, Tamsx3("CN9_NUMERO")[1]	, 0							,"Contrato"		,""			,""			,"Contrato"				,""				,""				,"@!"					,"Vazio() .Or. ExistCpo('CN9',M->"+Right(ALIAS_DA_TABELA,2)+"_CONTR,,,,.F.)"					,"€€€€€€€€€€€€€€ "	,"" 																																			,"CN9"				,1			,"şÀ"		,""			,""				,"S"		,""			,""			,""				,""				,"u_CSGetServ()"								,""																		,""				,""				,""				,"u_CSVlAlAtv('"+ALIAS_DA_TABELA+"','"+Right(ALIAS_DA_TABELA,2)+"_CONTR')"			,""																															,""			,""				,"S"		}) 	 
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"17"		,Right(ALIAS_DA_TABELA,2)+"_EXPIR"	,"D"		, 08						, 0							,"Exp.Contr"	,""			,""			,"Expiracao Contrato"	,""				,""				,""						,""																								,"€€€€€€€€€€€€€€ "	,"" 																																			,""					,1			,"şÀ"		,""			,""				,"S"		,""			,""			,""				,""				,""												,""																		,""				,""				,""				,"u_CSVlAlAtv('"+ALIAS_DA_TABELA+"','"+Right(ALIAS_DA_TABELA,2)+"_EXPIR')"			,""																															,""			,""				,"S"		}) 		
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"18"		,Right(ALIAS_DA_TABELA,2)+"_REVIS"	,"D"		, 08						, 0							,"Revisão"		,""			,""			,"Revisão Contrato"		,""				,""				,""						,""																								,"€€€€€€€€€€€€€€ "	,"" 																																			,""					,1			,"şÀ"		,""			,""				,"S"		,""			,""			,""				,""				,""												,""																		,""				,""				,""				,"u_CSVlAlAtv('"+ALIAS_DA_TABELA+"','"+Right(ALIAS_DA_TABELA,2)+"_REVIS')"			,""																															,""			,""				,"S"		}) 	
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"19"		,Right(ALIAS_DA_TABELA,2)+"_IDENT"	,"C"		, Tamsx3("U04_LICENC")[1]	, 0							,"Identificação",""			,""			,"Identificação"		,""				,""				,"@!"					,""																								,"€€€€€€€€€€€€€€ "	,"" 									   																										,""					,1			,"şÀ"		,""			,""				,"S"		,"N"		,"V"		,"V"			,""				,""												,""																		,""				,""				,""				,"u_CSVlAlAtv('"+ALIAS_DA_TABELA+"','"+Right(ALIAS_DA_TABELA,2)+"_IDENT')"			,""																															,""			,""				,"S"		})
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"20"		,Right(ALIAS_DA_TABELA,2)+"_MARCA"	,"C"		, 20						, 0							,"Marca/Modelo" ,""			,""			,"Marca/Modelo"			,""				,""				,"@!"					,""																								,"€€€€€€€€€€€€€€€"	,"" 								   																											,""					,1			,"şÀ"		,""			,""				,"S"		,"N"		,""			,""				,""				,""												,""																		,""				,""				,""				,"u_CSVlAlAtv('"+ALIAS_DA_TABELA+"','"+Right(ALIAS_DA_TABELA,2)+"_MARCA')"			,""																															,""			,""				,"S"		})
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"21"		,Right(ALIAS_DA_TABELA,2)+"_ENTID1"	,"C"		, 01						, 0							,"Ent.Respons."	,""			,""			,"Entidade"				,""				,""				,"@!"					,"u_CSGetProp()"						   					  									,"€€€€€€€€€€€€€€ "	,""	 		  																																	,""					,1			,"şÀ"		,""			,""				,"S"		,"N"		,""			,""				,""				,""												,"1=Participantes;2=Cargos/Funções;3=Locais"							,""				,""				,""				,"u_CSVlAlAtv('"+ALIAS_DA_TABELA+"','"+Right(ALIAS_DA_TABELA,2)+"_ENTID1')"			,""																												  			,""			,""				,"S"		})
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"22"		,Right(ALIAS_DA_TABELA,2)+"_PROPRI"	,"C"		, 40						, 0							,"Responsavel" ,""			,""			,"Responsavel"			,""				,""				,"@!"					,""																								,"€€€€€€€€€€€€€€ "	,"" 									  																										,""					,1			,"şÀ"		,""			,""				,"S"		,"N"		,""			,""				,""				,""												,""																		,""				,""				,""				,".F."																				,""																					  										,""			,""				,"S"		})
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"23"		,Right(ALIAS_DA_TABELA,2)+"_FORMAT"	,"C"		, 03						, 0							,"Natureza"	    ,""			,""			,"Natureza"				,""				,""				,"@!"					,"ExistCpo('SX5','"+F3_FORMATO+"'+M->"+Right(ALIAS_DA_TABELA,2)+"_FORMAT)"						,"€€€€€€€€€€€€€€ "	,""										  																										,F3_FORMATO			,1			,"şÀ"		,""			,""				,"S"		,"N"		,""			,""				,"€"			,"u_CSGetFATV(,'F')"							,""																		,""				,""				,""				,"u_CSVlAlAtv('"+ALIAS_DA_TABELA+"','"+Right(ALIAS_DA_TABELA,2)+"_FORMAT')"			,""																					  										,""			,""				,"S"		})
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"24"		,Right(ALIAS_DA_TABELA,2)+"_DSFORM"	,"C"		, 20						, 0							,"Desc.Formato" ,""			,""			,"Descrição Formato"	,""				,""				,"@!"					,""																								,"€€€€€€€€€€€€€€ "	,""																																 				,""					,1			,"şÀ"		,""			,""				,"S"		,"N"		,"V"		,""				,""				,""												,""																		,""				,""				,""				,"u_CSVlAlAtv('"+ALIAS_DA_TABELA+"','"+Right(ALIAS_DA_TABELA,2)+"_DSFORM')"			,"Posicione('SX5',1,xFilial('SX5')+'"+F3_FORMATO+"'+"+ALIAS_DA_TABELA+"->"+Right(ALIAS_DA_TABELA,2)+"_FORMAT,'X5_DESCRI')"	,""			,""				,"S"		})	
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"25"		,Right(ALIAS_DA_TABELA,2)+"_ENTLOC"	,"C"		, 01						, 0							,"Localidade"	,""			,""			,"Localidade"			,""				,""				,"@!"					,"u_CSGetLoca()"						   					  									,"€€€€€€€€€€€€€€ "	,""	 		  																																	,""					,1			,"şÀ"		,""			,""				,"S"		,"N"		,""			,""				,""				,""												,"1=Filiais;2=Postos Atendimento;3=Data Center Backup"					,""				,""				,""				,"u_CSVlAlAtv('"+ALIAS_DA_TABELA+"','"+Right(ALIAS_DA_TABELA,2)+"_ENTLOC')"			,""																												  			,""			,""				,"S"		})
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"26"		,Right(ALIAS_DA_TABELA,2)+"_LOCAL"	,"C"		, 40						, 0							,"Local"		,""			,""			,"Localização"			,""				,""				,"@!"					,""																								,"€€€€€€€€€€€€€€ "	,"" 									  																										,""		  			,1			,"şÀ"		,""			,""				,"S"		,"N"		,""			,""				,""				,""												,""																		,""				,""				,""				,".F."																				,""																															,""			,""				,"S"		})
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"27"		,Right(ALIAS_DA_TABELA,2)+"_LOCCON"	,"C"		, 40						, 0							,"Contingencia"	,""			,""			,"Local Contingencia"	,""				,""				,"@!"					,""																								,"€€€€€€€€€€€€€€ "	,"" 					  																														,""		  			,1			,"şÀ"		,""			,""				,"S"		,"N"		,""			,""				,""				,""												,""																		,""				,""				,""				,"u_CSVlAlAtv('"+ALIAS_DA_TABELA+"','"+Right(ALIAS_DA_TABELA,2)+"_LOCCON')"			,""																															,""			,""				,"S"		})
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"28"		,Right(ALIAS_DA_TABELA,2)+"_QTDLIC"	,"N"		, 08						, 0							,"Qtd. Licenças",""			,""			,"Qtde Licenças"		,""				,""				,"@E 99,999,999"		,""																								,"€€€€€€€€€€€€€€ "	,"" 																																			,""		  			,1			,"şÀ"		,""			,""				,"S"		,"N"		,""			,""				,""				,""												,""																		,""				,""				,""				,"u_CSVlAlAtv('"+ALIAS_DA_TABELA+"','"+Right(ALIAS_DA_TABELA,2)+"_QTDLIC')"			,""																															,""			,""				,"S"		})
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"29"		,Right(ALIAS_DA_TABELA,2)+"_USOAPL"	,"C"		, Tamsx3("QDH_DOCTO")[1]	, 0							,"Polit. Uso"	,""			,""			,"Polit.Uso Aplicavel"	,""				,""				,"@!"					,""																								,"€€€€€€€€€€€€€€ "	,"" 									  																										,"QDH"	  			,1			,"şÀ"		,""			,""				,"S"		,"N"		,""			,""				,""				,""												,""																		,""				,""				,""				,"u_CSVlAlAtv('"+ALIAS_DA_TABELA+"','"+Right(ALIAS_DA_TABELA,2)+"_USOAPL')"			,""																															,""			,""				,"S"		})  
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"30"		,Right(ALIAS_DA_TABELA,2)+"_CONHEC"	,"C"		, 01						, 0							,"Conhecimento"	,""			,""			,"Conhecimento"			,""				,""				,""						,"Pertence('12345')"																			,"€€€€€€€€€€€€€€ "	,"'5'" 									   																										,""		  			,1			,"şÀ"		,""			,""				,"S"		,"N"		,""			,""				,""				,"u_CSGetVATV('P')"								,"5=Critico;4=Alto;3=Medio;2=Baixo;1=Irrelevante"						,""				,""				,""				,"u_CSVlAlAtv('"+ALIAS_DA_TABELA+"','"+Right(ALIAS_DA_TABELA,2)+"_CONHEC')"			,""																															,""			,""				,"S"		})  
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"31"		,Right(ALIAS_DA_TABELA,2)+"_HABILI"	,"C"		, 01						, 0							,"Habilidade"	,""			,""			,"Habilidade"			,""				,""				,""						,"Pertence('12345')"																			,"€€€€€€€€€€€€€€ "	,"'5'" 									 																										,""					,1			,"şÀ"		,""			,""				,"S"		,"N"		,""			,""				,""				,"u_CSGetVATV('P')"								,"5=Critico;4=Alto;3=Medio;2=Baixo;1=Irrelevante"						,""				,""				,""				,"u_CSVlAlAtv('"+ALIAS_DA_TABELA+"','"+Right(ALIAS_DA_TABELA,2)+"_HABILI')"			,""																															,""			,""				,"S"		})  
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"32"		,Right(ALIAS_DA_TABELA,2)+"_CONFID"	,"C"		, 01						, 0							,"Confidencial" ,""			,""			,"Confidencialidade"	,""				,""				,""						,"Pertence('12345')"																			,"€€€€€€€€€€€€€€ "	,"'5'" 									   																										,""		  			,1			,"şÀ"		,""			,""				,"S"		,"N"		,""			,""				,""				,"u_CSGetVATV('N')"								,"5=Critico;4=Alto;3=Medio;2=Baixo;1=Irrelevante"						,""				,""				,""				,"u_CSVlAlAtv('"+ALIAS_DA_TABELA+"','"+Right(ALIAS_DA_TABELA,2)+"_CONFID')"			,""																															,""			,""				,"S"		})  
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"33"		,Right(ALIAS_DA_TABELA,2)+"_INTEGR"	,"C"		, 01						, 0							,"Integridade"	,""			,""			,"Integridade"			,""				,""				,""						,"Pertence('12345')"																			,"€€€€€€€€€€€€€€ "	,"'5'" 									 																										,""					,1			,"şÀ"		,""			,""				,"S"		,"N"		,""			,""				,""				,"u_CSGetVATV('N')"								,"5=Critico;4=Alto;3=Medio;2=Baixo;1=Irrelevante"						,""				,""				,""				,"u_CSVlAlAtv('"+ALIAS_DA_TABELA+"','"+Right(ALIAS_DA_TABELA,2)+"_INTEGR')"			,""																															,""			,""				,"S"		})  
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"34"		,Right(ALIAS_DA_TABELA,2)+"_DISPON"	,"C"		, 01						, 0							,"Disponibilid.",""			,""			,"Disponibilidade"		,""				,""				,""						,"Pertence('12345')"																			,"€€€€€€€€€€€€€€ "	,"'5'" 									 																										,""					,1			,"şÀ"		,""			,""				,"S"		,"N"		,""			,""				,""				,"u_CSGetVATV('NP')"							,"5=Critico;4=Alto;3=Medio;2=Baixo;1=Irrelevante"						,""				,""				,""				,"u_CSVlAlAtv('"+ALIAS_DA_TABELA+"','"+Right(ALIAS_DA_TABELA,2)+"_DISPON')"			,""																															,""			,""				,"S"		})  
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"35"		,Right(ALIAS_DA_TABELA,2)+"_VLMERC"	,"C"		, 01						, 0							,"Val. Mercado"	,""			,""			,"Valor Mercado"		,""				,""				,""						,"Pertence('12345')"																			,"€€€€€€€€€€€€€€ "	,"'5'" 									   																										,""		  			,1			,"şÀ"		,""			,""				,"S"		,"N"		,""			,""				,""				,"u_CSGetVATV('I')"								,"5=Critico;4=Alto;3=Medio;2=Baixo;1=Irrelevante"						,""				,""				,""				,"u_CSVlAlAtv('"+ALIAS_DA_TABELA+"','"+Right(ALIAS_DA_TABELA,2)+"_VLMERC')"			,""																															,""			,""				,"S"		})  
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"36"		,Right(ALIAS_DA_TABELA,2)+"_RENTAB"	,"C"		, 01						, 0							,"Integridade"	,""			,""			,"Integridade"			,""				,""				,""						,"Pertence('12345')"																			,"€€€€€€€€€€€€€€ "	,"'5'" 									 																										,""					,1			,"şÀ"		,""			,""				,"S"		,"N"		,""			,""				,""				,"u_CSGetVATV('I')"								,"5=Critico;4=Alto;3=Medio;2=Baixo;1=Irrelevante"						,""				,""				,""				,"u_CSVlAlAtv('"+ALIAS_DA_TABELA+"','"+Right(ALIAS_DA_TABELA,2)+"_RENTAB')"			,""																															,""			,""				,"S"		})  
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"37"		,Right(ALIAS_DA_TABELA,2)+"_CUSTO"	,"C"		, 01						, 0							,"Custo"		,""			,""			,"Custo"				,""				,""				,""						,"Pertence('12345')"																			,"€€€€€€€€€€€€€€ "	,"'5'" 									 																										,""					,1			,"şÀ"		,""			,""				,"S"		,"N"		,""			,""				,""				,"u_CSGetVATV('I')"								,"5=Critico;4=Alto;3=Medio;2=Baixo;1=Irrelevante"						,""				,""				,""				,"u_CSVlAlAtv('"+ALIAS_DA_TABELA+"','"+Right(ALIAS_DA_TABELA,2)+"_CUSTO')"			,""																															,""			,""				,"S"		})  
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"38"		,Right(ALIAS_DA_TABELA,2)+"_VALOR"	,"N"		, 02						, 0							,"Valor"		,""			,""			,"Valor"				,""				,""				,"@E 99"				,""																								,"€€€€€€€€€€€€€€ "	,"15" 									  																										,""					,1			,"şÀ"		,""			,""				,"S"		,"S"		,"V"		,""				,""				,""												,""																		,""				,""				,""				,"u_CSVlAlAtv('"+ALIAS_DA_TABELA+"','"+Right(ALIAS_DA_TABELA,2)+"_VALOR')"			,""																															,""			,""				,"S"		})  
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"39"		,Right(ALIAS_DA_TABELA,2)+"_DSVAL"	,"C"		, 10						, 0							,"Importancia"	,""			,""			,"Importancia"			,""				,""				,"@!"					,""																								,"€€€€€€€€€€€€€€ "	,"'Critico'" 																																	,""					,1			,"şÀ"		,""			,""				,"S"		,"S"		,"V"		,""				,""				,""												,""																		,""				,""				,""				,"u_CSVlAlAtv('"+ALIAS_DA_TABELA+"','"+Right(ALIAS_DA_TABELA,2)+"_DSVAL')"			,""																															,""			,""				,"S"		})  
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"40"		,Right(ALIAS_DA_TABELA,2)+"_ORIGEM"	,"C"		, 10						, 0							,"Origem"		,""			,""			,"Origem"				,""				,""				,"@!"					,""										   					  									,"€€€€€€€€€€€€€€€"	,"Funname()" 		  																															,""					,1			,"şÀ"		,""			,""				,"S"		,"N"		,""			,""				,""				,""												,""																		,""				,""				,""				,"u_CSVlAlAtv('"+ALIAS_DA_TABELA+"','"+Right(ALIAS_DA_TABELA,2)+"_ORIGEM')"			,""																												  			,""			,""				,"S"		})
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"41"		,Right(ALIAS_DA_TABELA,2)+"_CODGRP"	,"C"		, Tamsx3("U07_CODGRU")[1]	, 0							,"Grupo"		,""			,""			,"Grupo"				,""				,""				,"@!"					,"Vazio() .Or. ExistCpo('U07',M->"+Right(ALIAS_DA_TABELA,2)+"_CODGRP,,,,.F.)"					,"€€€€€€€€€€€€€€ "	,"" 		  																																	,"U07_01"			,1			,"şÀ"		,""			,""				,"S"		,"N"		,""			,""				,""				,""												,""																		,""				,""				,""				,"u_CSVlAlAtv('"+ALIAS_DA_TABELA+"','"+Right(ALIAS_DA_TABELA,2)+"_CODGRP')"			,""																												  			,""			,""				,"S"		})
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"42"		,Right(ALIAS_DA_TABELA,2)+"_SUBNIVE","C"		, 40						, 0							,"Sub Nivel"	,""			,""			,"Sub Nivel"			,""				,""				,"@!"					,""																								,"€€€€€€€€€€€€€€€"	,"" 		  																																	,""					,1			,"şÀ"		,""			,""				,"S"		,"N"		,""			,""				,""				,""												,""																		,""				,""				,""				,""																					,""																												  			,""			,""				,"S"		})		
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"43"		,Right(ALIAS_DA_TABELA,2)+"_LOCCONT","C"		, 40						, 0							,"Local Contig"	,""			,""			,"Local Contig"			,""				,""				,"@!"					,""																								,"€€€€€€€€€€€€€€€"	,"" 		  																																	,""					,1			,"şÀ"		,""			,""				,"S"		,"N"		,""			,""				,""				,""												,""																		,""				,""				,""				,""																					,""																												  			,""			,""				,"S"		})		
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"44"		,Right(ALIAS_DA_TABELA,2)+"_SBNVCON","C"		, 40						, 0							,"Sb Nv Contig"	,""			,""			,"Sb Nv Contig"			,""				,""				,"@!"					,""																								,"€€€€€€€€€€€€€€€"	,"" 		  																																	,""					,1			,"şÀ"		,""			,""				,"S"		,"N"		,""			,""				,""				,""												,""																		,""				,""				,""				,""																					,""																												  			,""			,""				,"S"		})		
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"45"		,Right(ALIAS_DA_TABELA,2)+"_REFPROC","M"		, 10						, 0							,"Ref Processo"	,""			,""			,"Ref Processo"			,""				,""				,""						,""																								,"€€€€€€€€€€€€€€€"	,"" 		  																																	,""					,1			,"şÀ"		,""			,""				,"S"		,"N"		,""			,""				,""				,""												,""																		,""				,""				,""				,""																					,""																												  			,""			,""				,"S"		})		
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"46"		,Right(ALIAS_DA_TABELA,2)+"_ATIINFO" ,"C"		, 01						, 0							,"Informacoes"	,""			,""			,"Informacoes"			,""				,""				,"@!"					,""																								,"€€€€€€€€€€€€€€€"	,"" 		  																																	,""					,1			,"şÀ"		,""			,""				,"S"		,"N"		,""			,""				,""				,""												,"1=Publico;2=Interno;3=Restrito;4=Confidencial"						,""				,""				,""				,""																					,""																												  			,""			,""				,"S"		})		
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"47"		,Right(ALIAS_DA_TABELA,2)+"_OBSERVA","M"		, 10						, 0							,"Observacoes"	,""			,""			,"Observacoes"			,""				,""				,""						,""																								,"€€€€€€€€€€€€€€€"	,"" 		  																																	,""					,1			,"şÀ"		,""			,""				,"S"		,"N"		,""			,""				,""				,""												,""																		,""				,""				,""				,""																					,""																												  			,""			,""				,"S"		})		
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"48"		,Right(ALIAS_DA_TABELA,2)+"_MATRICU","C"		, 06						, 0							,"Matricula"	,""			,""			,"Matricula"			,""				,""				,"@!"					,""																								,"€€€€€€€€€€€€€€€"	,"" 		  																																	,""					,1			,"şÀ"		,""			,""				,"S"		,"N"		,""			,""				,""				,""												,""																		,""				,""				,""				,""																					,""																												  			,""			,""				,"S"		})		
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"49"		,Right(ALIAS_DA_TABELA,2)+"_NOMFUNC","C"		, 30						, 0							,"Funcionario"	,""			,""			,"Funcionario"			,""				,""				,"@!"					,""																								,"€€€€€€€€€€€€€€€"	,"" 		  																																	,""					,1			,"şÀ"		,""			,""				,"S"		,"N"		,""			,""				,""				,""												,""																		,""				,""				,""				,""																					,""																												  			,""			,""				,"S"		})		
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"50"		,Right(ALIAS_DA_TABELA,2)+"_CODFUNC","C"		, 05						, 0							,"Cod Funcao"	,""			,""			,"Cod Funcao"			,""				,""				,"@!"					,""																								,"€€€€€€€€€€€€€€€"	,"" 		  																																	,""					,1			,"şÀ"		,""			,""				,"S"		,"N"		,""			,""				,""				,""												,""																		,""				,""				,""				,""																					,""																												  			,""			,""				,"S"		})		
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"51"		,Right(ALIAS_DA_TABELA,2)+"_DESCFUN","C"		, 50						, 0							,"Desc Funcao"	,""			,""			,"Desc Funcao"			,""				,""				,"@!"					,""																								,"€€€€€€€€€€€€€€€"	,"" 		  																																	,""					,1			,"şÀ"		,""			,""				,"S"		,"N"		,""			,""				,""				,""												,""																		,""				,""				,""				,""																					,""																												  			,""			,""				,"S"		})		
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"52"		,Right(ALIAS_DA_TABELA,2)+"_CODSUPE","C"		, 05						, 0							,"Cod Superior"	,""			,""			,"Cod Superior"			,""				,""				,"@!"					,""																								,"€€€€€€€€€€€€€€€"	,"" 		  																																	,""					,1			,"şÀ"		,""			,""				,"S"		,"N"		,""			,""				,""				,""												,""																		,""				,""				,""				,""																					,""																												  			,""			,""				,"S"		})		
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"53"		,Right(ALIAS_DA_TABELA,2)+"_NOMSUPE","C"		, 50						, 0							,"Superior"		,""			,""			,"Superior"				,""				,""				,"@!"					,""																								,"€€€€€€€€€€€€€€€"	,"" 		  																																	,""					,1			,"şÀ"		,""			,""				,"S"		,"N"		,""			,""				,""				,""												,""																		,""				,""				,""				,""																					,""																												  			,""			,""				,"S"		})			
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"54"		,Right(ALIAS_DA_TABELA,2)+"_CHAVGER","C"		, 03						, 0							,"Chave Gerenc"	,""			,""			,"Chave Gerenc"			,""				,""				,"@!"					,""																								,"€€€€€€€€€€€€€€€"	,"" 		  																																	,""					,1			,"şÀ"		,""			,""				,"S"		,"N"		,""			,""				,""				,""												,""																		,""				,""				,""				,""																					,""																												  			,""			,""				,"S"		})				
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"55"		,Right(ALIAS_DA_TABELA,2)+"_DESCHAV","C"		, 30						, 0							,"Desc Chave"	,""			,""			,"Desc Chave"			,""				,""				,"@!"					,""																								,"€€€€€€€€€€€€€€€"	,"" 		  																																	,""					,1			,"şÀ"		,""			,""				,"S"		,"N"		,""			,""				,""				,""												,""																		,""				,""				,""				,""																					,""																												  			,""			,""				,"S"		})				

	//->> Campos da Integração                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
	aAdd( aSX3,	{ 	"CN9"				,"80"		,"CN9_I27001"						,"C"		, 15						, 0							,"ISO27001"		,""			,""			,"ISO27001"				,""				,""				,"@!"					,""										   					  									,"€€€€€€€€€€€€€€ "	,"" 		  																																	,""					,1			,"şÀ"		,""			,""				,"S"		,"S"		,""			,""				,""				,""												,""																		,""				,""				,""				,".F."																				,""																												  			,""			,""				,"S"		}) 
	aAdd( aSX3,	{ 	"CN9"				,"81"		,"CN9_FILISO"						,"C"		, Tamsx3("E1_FILIAL")[1]	, 0							,"Fil ISO"		,""			,""			,"Filial ISO"			,""				,""				,"@!"					,""										   					  									,"€€€€€€€€€€€€€€ "	,"" 		  																																	,""					,1			,"şÀ"		,""			,""				,"S"		,"S"		,""			,""				,""				,""												,""																		,""				,""				,""				,".F."																				,""																												  			,""			,""				,"S"		})
	
	aAdd( aSX3,	{ 	"RD0"				,"80"		,"RD0_I27001"						,"C"		, 15						, 0							,"ISO27001"		,""			,""			,"ISO27001"				,""				,""				,"@!"					,""										   					  									,"€€€€€€€€€€€€€€ "	,"" 		  																																	,""					,1			,"şÀ"		,""			,""				,"S"		,"S"		,""			,""				,""				,""												,""																		,""				,""				,""				,".F."																				,""																												  			,""			,""				,"S"		})
	aAdd( aSX3,	{ 	"RD0"				,"81"		,"RD0_FILISO"						,"C"		, Tamsx3("E1_FILIAL")[1]	, 0							,"Fil ISO"		,""			,""			,"Filial ISO"			,""				,""				,"@!"					,""										   					  									,"€€€€€€€€€€€€€€ "	,"" 		  																																	,""					,1			,"şÀ"		,""			,""				,"S"		,"S"		,""			,""				,""				,""												,""																		,""				,""				,""				,".F."																				,""																												  			,""			,""				,"S"		})
	
	aAdd( aSX3,	{ 	"U04"				,"80"		,"U04_I27001"						,"C"		, 15						, 0							,"ISO27001"		,""			,""			,"ISO27001"				,""				,""				,"@!"					,""										   					  									,"€€€€€€€€€€€€€€ "	,"" 		  																																	,""					,1			,"şÀ"		,""			,""				,"S"		,"S"		,""			,""				,""				,""												,""																		,""				,""				,""				,".F."																				,""																												  			,""			,""				,"S"		})
	aAdd( aSX3,	{ 	"U04"				,"81"		,"U04_FILISO"						,"C"		, Tamsx3("E1_FILIAL")[1]	, 0							,"Fil ISO"		,""			,""			,"Filial ISO"			,""				,""				,"@!"					,""										   					  									,"€€€€€€€€€€€€€€ "	,"" 		  																																	,""					,1			,"şÀ"		,""			,""				,"S"		,"S"		,""			,""				,""				,""												,""																		,""				,""				,""				,".F."																				,""																												  			,""			,""				,"S"		})
	aAdd( aSX3,	{ 	"U04"				,"82"		,"U04_CODGRP"						,"C"		, Tamsx3("U07_CODGRU")[1]	, 0							,"Grupo"		,""			,""			,"Grupo"				,""				,""				,"@!"					,"Vazio() .Or. ExistCpo('U07',M->U04_CODGRP,,,,.F.)"											,"€€€€€€€€€€€€€€ "	,"" 		  																																	,"U07_01"			,1			,"şÀ"		,""			,""				,"S"		,"S"		,""			,""				,""				,""												,""																		,""				,""				,""				,".T."																				,""																												  			,""			,""				,"S"		})
	
	aAdd( aSX3,	{ 	"U00"				,"80"		,"U00_I27001"						,"C"		, 15						, 0							,"ISO27001"		,""			,""			,"ISO27001"				,""				,""				,"@!"					,""										   					  									,"€€€€€€€€€€€€€€ "	,"" 		  																																	,""					,1			,"şÀ"		,""			,""				,"S"		,"S"		,""			,""				,""				,""												,""																		,""				,""				,""				,".F."																				,""																												  			,""			,""				,"S"		})
	aAdd( aSX3,	{ 	"U00"				,"81"		,"U00_FILISO"						,"C"		, Tamsx3("E1_FILIAL")[1]	, 0							,"Fil ISO"		,""			,""			,"Filial ISO"			,""				,""				,"@!"					,""										   					  									,"€€€€€€€€€€€€€€ "	,"" 		  																																	,""					,1			,"şÀ"		,""			,""				,"S"		,"S"		,""			,""				,""				,""												,""																		,""				,""				,""				,".F."																				,""																												  			,""			,""				,"S"		})
	aAdd( aSX3,	{ 	"U00"				,"82"		,"U00_CODGRP"						,"C"		, Tamsx3("U07_CODGRU")[1]	, 0							,"Grupo"		,""			,""			,"Grupo"				,""				,""				,"@!"					,"Vazio() .Or. ExistCpo('U07',M->U00_CODGRP,,,,.F.)"											,"€€€€€€€€€€€€€€ "	,"" 		  																																	,"U07_01"			,1			,"şÀ"		,""			,""				,"S"		,"S"		,""			,""				,""				,""												,""																		,""				,""				,""				,".T."																				,""																												  			,""			,""				,"S"		})
		
	dbSelectArea("SX3")
	dbSetOrder(2)
	For i:= 1 To Len(aSX3)
		SX3->(dbSetOrder(2))
		If !dbSeek(aSX3[i,3])
			RecLock("SX3",.T.)
		Else                  
			RecLock("SX3",.F.)
		EndIf			
		For j:=1 To Len(aSX3[i])
			If FieldPos(aEstrut[j])>0
				FieldPut(FieldPos(aEstrut[j]),aSX3[i,j])
			EndIf
		Next j
		dbCommit()
		MsUnLock()
	Next i                      
	
	//->>Criacao dos indices da tabela
	aEstrut:= {"INDICE"			,"ORDEM","CHAVE"																,"DESCRICAO"		,"DESCSPA"			,"DESCENG"			,"PROPRI"	,"F3"	,"NICKNAME","SHOWPESQ"}
	Aadd(aSIX,{ALIAS_DA_TABELA	,"1"	,Right(ALIAS_DA_TABELA,2)+"_FILIAL+"+Right(ALIAS_DA_TABELA,2)+"/te"		,"Fabricante"		,""																									})
	Aadd(aSXB,{"U04XISO"   		,"3"		,"01"		,"01"			,"Cadastra Novo"		,"Cadastra Novo"	,"Cadastra Novo"	,"01"																								})
	Aadd(aSXB,{"U04XISO"   		,"4"		,"01"		,"01"			,"Cod Software"			,"Cod Software "	,"Cod Software "	,"U04_CODSFT"																						})
	Aadd(aSXB,{"U04XISO"   		,"4"		,"01"		,"02"			,"Desc Soft"			,"Desc Soft"		,"Desc Soft "		,"U04_DESSFT"																						})
	Aadd(aSXB,{"U04XISO"   		,"4"		,"01"		,"03"			,"Fabricante"			,"Fabricante"		,"Fabricante "		,"U04_FABRIC"																						})
	Aadd(aSXB,{"U04XISO"   		,"4"		,"01"		,"04"			,"Saldo Licenc"			,"Saldo Licenc"		,"Saldo Licenc"		,"U04_SLDLIC"																						})
	Aadd(aSXB,{"U04XISO"   		,"4"		,"02"		,"01"			,"Desc Soft"			,"Desc Soft"		,"Desc Soft"		,"U04_DESSFT"																						})
	Aadd(aSXB,{"U04XISO"   		,"4"		,"02"		,"02"			,"Cod Software"			,"Cod Software"		,"Cod Software"		,"U04_CODSFT"																						})
	Aadd(aSXB,{"U04XISO"   		,"4"		,"02"		,"03"			,"Fabricante"			,"Fabricante"		,"Fabricante"		,"U04_FABRIC"																						})
	Aadd(aSXB,{"U04XISO"   		,"4"		,"02"		,"04"			,"Saldo Licenc"			,"Saldo Licenc"		,"Saldo Licenc"		,"U04_SLDLIC"																						})
	Aadd(aSXB,{"U04XISO"   		,"4"		,"03"		,"01"			,"Fabricante"			,"Fabricante"		,"Fabricante"		,"U04_FABRIC"																						})
	Aadd(aSXB,{"U04XISO"   		,"4"		,"03"		,"02"			,"Desc Soft"			,"Desc Soft"		,"Desc Soft "		,"U04_DESSFT"																						})
	Aadd(aSXB,{"U04XISO"   		,"4"		,"03"		,"03"			,"Cod Software"			,"Cod Software"		,"Cod Software"		,"U04_CODSFT"																						})
	Aadd(aSXB,{"U04XISO"   		,"4"		,"03"		,"04"			,"Saldo Licenc"			,"Saldo Licenc"		,"Saldo Licenc"		,"U04_SLDLIC"																						})
	Aadd(aSXB,{"U04XISO"   		,"5"		,"01"		,""				,""						,""					,""					,"U04->U04_CODSFT"							 														})
	Aadd(aSXB,{"U04XISO"   		,"6"		,"01"		,""				,""						,""					,""					,"U04->U04_STATUS == '1' .AND. U04->U04_SLDLIC > 0"	})
	
	Aadd(aSXB,{"U00XISO"   		,"1"		,"01"		,"DB"			,"Hardware"				,"Hardware"				,"Hardware"				,"U00"																								})
	Aadd(aSXB,{"U00XISO"   		,"2"		,"01"		,"01"			,"Cod Hardware+cod Har"	,"Cod Hardware+cod Har"	,"Cod Hardware+cod Har"	,""																									}) 
	Aadd(aSXB,{"U00XISO"   		,"4"		,"01"		,"01"			,"Cod Hardware"			,"Cod Hardware"			,"Cod Hardware"			,"U00_CODHRD"																									})
	Aadd(aSXB,{"U00XISO"   		,"4"		,"01"		,"02"			,"Descr. Hard."			,"Descr. Hard."			,"Descr. Hard."			,"U00_DESHRD"																									})
	Aadd(aSXB,{"U00XISO"   		,"4"		,"01"		,"03"			,"Marca"				,"Marca"				,"Marca"				,"U00_MARCA"																								})
	Aadd(aSXB,{"U00XISO"   		,"4"		,"01"		,"05"			,"Setor"				,"Setor"				,"Setor"				,"U00_SETOR"																						})
	Aadd(aSXB,{"U00XISO"   		,"5"		,"01"		,""				,""						,""						,""						,"U00->U00_CODHRD"							 														})
	Aadd(aSXB,{"U00XISO"   		,"6"		,"01"		,""				,""						,""						,""						,""	})
	
	dbSelectArea("SXB")
	dbSetOrder(1)
	For i:= 1 To Len(aSXB)
		If !Empty(aSXB[i][1])
			If !dbSeek(Padr(aSXB[i,1], Len(SXB->XB_ALIAS))+aSXB[i,2]+aSXB[i,3]+aSXB[i,4])
				RecLock("SXB",.T.)			
			Else                            
				RecLock("SXB",.F.)			
			EndIf				
			For j:=1 To Len(aSXB[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSXB[i,j])
				EndIf
			Next j			
			dbCommit()
			MsUnLock()
		EndIf
	Next i
    
	//->> Ajuste Fisico na Tabela, caso ja exista.
	If lMenu
		For nX:=1 to Len(aTabelas)	
			__SetX31Mode(.F.)
			If Select(aTabelas[nX])>0
				dbSelecTArea(aTabelas[nX])
				dbCloseArea()
			EndIf
			X31UpdTable(aTabelas[nX])
			If __GetX31Error()
				If lUpdAuto    
					MsOpenDbf(.T.,"TOPCONN",cTabe+SM0->M0_CODIGO+"0",aTabelas[nX],.T.,.F.,.F.,.F.)
				EndIf
			EndIf	
			//dbSelectArea(aTabelas[nX])
		Next nX
	EndIf
			
EndIf

RestArea(aArea)

Return 
    
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³SCAtuSx5   ³ Autor ³ Marcelo Celi Marques ³ Data ³ 01/10/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Ajusta o SX5.								                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Certisign                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function SCAtuSx5()      
Local aSX5 := {}
//->> Ajuste da Tabela SX5 de formatos de ativos                 
aAdd(aSX5,{F3_FORMATO	,"001"		,"Arquivo Digital"			,"Arquivo Digital"			,"Arquivo Digital"})
aAdd(aSX5,{F3_FORMATO	,"002"		,"Midia Removivel"			,"Midia Removivel"			,"Midia Removivel"})
aAdd(aSX5,{F3_FORMATO	,"003"		,"Equipamento Comunicação"	,"Equipamento Comunicação"	,"Equipamento Comunicação"})

aAdd(aSX5,{F3_CLASSIF	,"001"		,"Know-How"					,"Know-How"					,"Know-How"})
aAdd(aSX5,{F3_CLASSIF	,"002"		,"Tecnologia"				,"Tecnologia"				,"Tecnologia"})
aAdd(aSX5,{F3_CLASSIF	,"003"		,"Marca"					,"Marca"					,"Marca"}) 
aAdd(aSX5,{F3_CLASSIF	,"004"		,"Direitos Autorais"		,"Direitos Autorais"		,"Direitos Autorais"})
aAdd(aSX5,{F3_CLASSIF	,"005"		,"Cliente"					,"Cliente"					,"Cliente"})

aAdd(aSX5,{F3_GERCHAV	,"001"		,"gerchav1"					,"gerchav1"					,"gerchav1"})	                    
aAdd(aSX5,{F3_GERCHAV	,"002"		,"gerchav2"					,"gerchav2"					,"gerchav2"})	                   
aAdd(aSX5,{F3_GERCHAV	,"003"		,"gerchav3"					,"gerchav3"					,"gerchav3"})	                   		
	
SX5->(dbSetOrder(1))
For nX:=1 to Len(aSX5)
	If !SX5->(dbSeek(xFilial("SX5")+PadR(aSX5[nX,01],Tamsx3("X5_TABELA")[1])+PadR(aSX5[nX,02],Tamsx3("X5_CHAVE")[1])))
    	Reclock("SX5",.T.)
	Else                  
		Reclock("SX5",.F.)	
	EndIf                 
	SX5->X5_FILIAL 	:= xFilial("SX5")
	SX5->X5_TABELA 	:= aSX5[nX,01] 
	SX5->X5_CHAVE 	:= aSX5[nX,02]
	SX5->X5_DESCRI 	:= aSX5[nX,03] 
	SX5->X5_DESCSPA	:= aSX5[nX,04]
	SX5->X5_DESCENG	:= aSX5[nX,05]
	SX5->(MsUnlock())
Next nX
Return 


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MenuDef    ³ Autor ³ Marcelo Celi Marques ³ Data ³ 01/10/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Opcoes no Menu.	     			                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Certisign                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MenuDef()
Private aRotina := { {"Pesquisar"	, "AxPesqui"  	,0,1,0	,.F.},;  
					 {"Visualizar"	, "u_CSATV1VIS"	,0,2,0	,nil},;  
					 {"Incluir"		, "u_CSATV1INC"	,0,3,81	,nil},; 
					 {"Alterar"		, "u_CSATV1ALT"	,0,4,3	,nil},;
					 {"Excluir"		, "u_CSATV1EXC"	,0,5,81	,nil},;  
					 {"Imprimir"	, "u_CSATV1IMP"	,0,5,81	,nil},; 
					 {"Legenda"		, "u_CSATV1LEG" ,0,2, 	,.F.}}					 					 

Return(aRotina) 
                              
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CSATV1VIS  ³ Autor ³ Marcelo Celi Marques ³ Data ³ 01/10/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Visualizacao. 	     			                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Certisign                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CSATV1VIS(cAlias,nReg,nOpc)                                 
Local aButtons := {}      
Local nTipo := Val((cAlias)->&(Right(ALIAS_DA_TABELA,2)+"_TIPO"))
Local aCpos := GetCposAtv(nTipo,nOpc)

Return(AxVisual(cAlias,nReg,nOpc,aCpos,,,,aButtons,))

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CSATV1INC  ³ Autor ³ Marcelo Celi Marques ³ Data ³ 01/10/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Inclusao.     	     			                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Certisign                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CSATV1INC(cAlias,nReg,nOpc,cRec1,cRec2,lSubst,nTipo,cRotInic)                                 
Local 	aRecNo		:= {}	
Local 	aButtons 	:= {{"CARGA",{|| CSFUNCSUBS(@aRecNo,nTipo)},"Func Subst"}}
Local 	aCpos		:= {}         
Local 	cCondicao	:= ""
Local 	xGrupos		:= ""     
Local 	nX			:= 0	
Local	nS			:= 0
Default nTipo		:= 0 
Default cRotInic	:= NIL
Private _TipoAtv := "" // Variavel utilizada no inicializador padrão

If nTipo==0
	nTipo		:= GetTipAtv()           
EndIf	
_cTipoAtv	:= Alltrim(Str(nTipo)) 

If nTipo>0
	If u_SCSGSIUse(Alltrim(Str(nTipo))+u_SCGetIdFu("CSATV1INC"))
		aCpos := GetCposAtv(nTipo)
		If Len(aCpos)>0          
		
			Begin Transaction
				AxInclui(cAlias,nReg,nOpc,aCpos,cRotInic,,,,"u_CSISOAINC('"+cAlias+"')",aButtons)		
			
				If Len(aRecNo) > 0
					RecLock("SZZ",.F.)
					
						For nS	:= 1 To Len(aRecNo)
					    	SZZ->(FieldPut(FieldPos(aRecno[nS,01]),aRecno[nS,02]))
					    Next nS
					    
					SZZ->(MsUnLock())
				EndIf	
			End Transaction
			
		EndIf
	Else
		MsgAlert("Usuário sem direito de acesso a esta funcionalidade.")
	EndIf
EndIf			
dbSelectArea(cAlias)

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CSATV1ALT  ³ Autor ³ Marcelo Celi Marques ³ Data ³ 01/10/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Alteracao.    	     			                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Certisign                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                                    
User Function CSATV1ALT(cAlias,nReg,nOpc)                                 
Local aButtons := {}
Local nTipo := Val((cAlias)->&(Right(ALIAS_DA_TABELA,2)+"_TIPO"))
Local aCpos := GetCposAtv(nTipo)

If nTipo>0
	If u_SCSGSIUse(Alltrim(Str(nTipo))+u_SCGetIdFu("CSATV1ALT"))	
		If Len(aCpos)>0
			Begin Transaction
				AxAltera(cAlias,nReg,nOpc,aCpos,,,,/*Validacao*/,,,aButtons)	
			End Transaction
		EndIf
	Else
		MsgAlert("Usuário sem direito de acesso a esta funcionalidade.")
	EndIf
EndIf		
dbSelectArea(cAlias)

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CSATV1EXC  ³ Autor ³ Marcelo Celi Marques ³ Data ³ 01/10/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Exclusao.     	     			                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Certisign                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CSATV1EXC(cAlias,nReg,nOpc)                                 
Local aButtons := {}
Local nTipo := Val((cAlias)->&(Right(ALIAS_DA_TABELA,2)+"_TIPO"))
Local aCpos := GetCposAtv(nTipo)

If Len(aCpos)>0
	If nTipo>0
		If u_SCSGSIUse(Alltrim(Str(nTipo))+u_SCGetIdFu("CSATV1EXC"))	
			If Upper(Funname()) $ Upper(&((cAlias)+"->"+Right(ALIAS_DA_TABELA,2)+"_ORIGEM"))	
				dbSelectArea(cAlias)
				Begin Transaction	
					AxDeleta(cAlias,nReg,nOpc,"U_CSATVDESV()",aCpos,aButtons,,,.T.)	
				End Transaction
			Else
				MsgAlert("Ativo não pode ser excluido pelo módulo de Manutenção de Ativos ISO27001 pois foi criado por outra rotina.  Antes você precisa desvincula-lo pela rotina que o originalizou.")
			EndIf
		Else
			MsgAlert("Usuário sem direito de acesso a esta funcionalidade.")
		EndIf
	EndIf				
EndIf

dbSelectArea(cAlias)
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GetNewCodigoºAutor  ³Marcelo Celi Marquesº Data ³ 01/10/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza da geracao de chave de ativo.				          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GetNewCodigo(cAlias)               
Local cCodigo 	:= ""
Local aArea		:= GetArea()

(cAlias)->(dbSetOrder(1))
(cAlias)->(dbGoBottom())
cCodigo := (cAlias)->&(Right(ALIAS_DA_TABELA,2)+"_CODIGO")
Do While .T.             
	cCodigo := Soma1(cCodigo)
	If (cAlias)->(dbSeek(xFilial(cAlias)+cCodigo))
		Loop
	Else
		Exit
	EndIf
EndDo
RestArea(aArea)
Return cCodigo

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSGetVATV   ºAutor  ³Marcelo Celi Marquesº Data ³ 02/10/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualiza o campo Valor com base nos criterios.	          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CSGetVATV(cTipo)
Local xTipo 	:= "M->"+Right(ALIAS_DA_TABELA,2)+"_TIPO" 
//Local xValor 	:= "M->"+Right(ALIAS_DA_TABELA,2)+"_VALOR" 
//Local xConfid 	:= "M->"+Right(ALIAS_DA_TABELA,2)+"_CONFID"
//Local xIntegr 	:= "M->"+Right(ALIAS_DA_TABELA,2)+"_INTEGR"
//Local xDispon 	:= "M->"+Right(ALIAS_DA_TABELA,2)+"_DISPON"
Local xVlmerc 	:= "M->"+Right(ALIAS_DA_TABELA,2)+"_VLMERC"
Local xRentab 	:= "M->"+Right(ALIAS_DA_TABELA,2)+"_RENTAB"
Local xCusto 	:= "M->"+Right(ALIAS_DA_TABELA,2)+"_CUSTO"
//Local xConhec 	:= "M->"+Right(ALIAS_DA_TABELA,2)+"_CONHEC"
//Local xHabili 	:= "M->"+Right(ALIAS_DA_TABELA,2)+"_HABILI"
//Local xImport	:= "M->"+Right(ALIAS_DA_TABELA,2)+"_DSVAL"

Default cTipo	:= ""

If "I" $ cTipo                                                 			
	&xValor := Val(&xVlmerc) + Val(&xRentab) + Val(&xCusto)
ElseIf "P" $ cTipo .And. &xTipo=="6" 
	&xValor := Val(&xConhec) + Val(&xHabili) + Val(&xDispon)
ElseIf "N" $ cTipo .And. &xTipo$"1234" 
	&xValor := Val(&xConfid) + Val(&xIntegr) + Val(&xDispon)
Else
	&xValor := 0	
EndIf	
	
If &xValor >= 3 .And. &xValor <= 4
	&xImport := "Irrelevante"
ElseIf &xValor >= 5 .And. &xValor <= 7
	&xImport := "Baixo"
ElseIf &xValor >= 8 .And. &xValor <= 10
	&xImport := "Medio"
ElseIf &xValor >= 11 .And. &xValor <= 13
	&xImport := "Alto"
ElseIf &xValor >= 14 .And. &xValor <= 15
	&xImport := "Critico"
Else
	&xImport := ""
EndIf	

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSGetFATV   ºAutor  ³Marcelo Celi Marquesº Data ³ 02/10/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualiza o campo virtual Formato ou Classificacao do Ativo. º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CSGetFATV(lInic,cTipo)
Local xFormat	:= "M->"+Right(ALIAS_DA_TABELA,2)+"_FORMAT"		
Local xDsForm	:= "M->"+Right(ALIAS_DA_TABELA,2)+"_DSFORM"		
Local xClass	:= "M->"+Right(ALIAS_DA_TABELA,2)+"_CLASS"		
Local xDsClass	:= "M->"+Right(ALIAS_DA_TABELA,2)+"_DSCLAS"		

Default lInic 	:= .F.
Default cTipo	:= ""

If cTipo == "C"
	SX5->(dbSetOrder(1))
	If SX5->(dbSeek(xFilial("SX5")+F3_CLASSIF+&xClass))
		&xDSClass := SX5->X5_DESCRI
	Else
		&xDSClass := ""
	EndIf	
Else
	SX5->(dbSetOrder(1))
	If SX5->(dbSeek(xFilial("SX5")+F3_FORMATO+&xFormat))
		&xDSForm := SX5->X5_DESCRI
	Else
		&xDSForm := ""
	EndIf	
EndIf

If lInic
	Return
Else
	Return .T.
EndIf	

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GetTipAtv   ºAutor  ³Marcelo Celi Marquesº Data ³ 02/10/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna o tipo do ativo para inclusao.			          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetTipAtv()
Local nTipo 	:= 0
LOcal nRadio	:= 1
Local oDlg, oPanel, oFWLayer, oRadio

DEFINE MSDIALOG oDlg FROM 020,001 TO 200,340 TITLE "Tipo de Ativo" PIXEL Style 1 Color CLR_BLACK,CLR_WHITE 

oFWLayer := FWLayer():New()  
oFWLayer:Init(oDlg,.F.,.T.)  	  
oFWLayer:addLine("LINHA1",100,.F.)  
oFWLayer:AddCollumn("QUADRO1"	,100,.T.,"LINHA1")    
oFWLayer:AddWindow("QUADRO1"	,"oPanel"	,"Tipo de Ativo"	,100,.F.,.T.,,"LINHA1",{ || })   
oPanel := oFWLayer:GetWinPanel("QUADRO1","oPanel","LINHA1")   

@ 05,10 RADIO nRadio ITEMS 'Informação','Software','Físico','Serviço','Intangíveis','Pessoas' PIXEL SIZE 50,10 OF oPanel

Activate MsDialog oDlg ON INIT u_CSGEnchBar(oDlg,{|| nTipo:=nRadio,oDlg:End() },{ || nTipo:=0,oDlg:End() },{},,.F.,,,0,.T.) Center 

Return nTipo

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GetCposAtv  ºAutor  ³Marcelo Celi Marquesº Data ³ 03/10/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna os campos conforme o tipo do cadastro.	          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetCposAtv(nTipo,nOpc)
Local aCpos := {}

If nTipo == 1 // Informação                        
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_TIPO"	)
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_CODIGO")
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_NOME"  )
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_IDENT" )
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_PROPRI") 
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_ENTID1")	
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_FORMAT")
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_DSFORM")
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_LOCAL" ) 
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_ENTLOC")	
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_LOCCON")
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_USOAPL")
//	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_CONFID")
//	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_INTEGR")
//	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_DISPON")
//	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_VALOR" )
//	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_DSVAL" )
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_SUBNIVE")
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_LOCCONT")
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_SBNVCON")
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_ATIINFO")
ElseIf nTipo==2 // Software              
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_TIPO"	)
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_CODIGO")
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_NOME"  )
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_IDENT" )
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_MARCA" )
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_PROPRI")
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_ENTID1")	
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_LOCAL" )
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_ENTLOC" )	
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_LOCCON")
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_QTDLIC")
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_USOAPL")
//	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_CONFID")
//	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_INTEGR")
//	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_DISPON")
//	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_VALOR" )
//	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_DSVAL" )	
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_CODSFT" ) 
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_SUBNIVE" )   
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_CODGRP" )    	
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_DESGRUP" )    	
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_LOCCONT" )
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_SBNVCON" )
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_REFPROC" )
ElseIf nTipo==3 // Fisico
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_TIPO"	)
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_CODIGO")
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_NOME"  )
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_IDENT" )
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_MARCA" )
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_PROPRI")
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_ENTID1")	
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_FORMAT")
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_DSFORM")
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_LOCAL" )
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_ENTLOC" )	
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_LOCCON")
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_QTDLIC")
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_USOAPL")
//	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_CONFID")
//	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_INTEGR")
//	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_DISPON")
//	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_VALOR" )
//	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_DSVAL" )
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_CODHRD" )    
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_CODGRP" )  
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_DESGRUP" )  
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_SUBNIVE" )  
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_LOCCONT" )
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_SBNVCON" )
ElseIf nTipo==4 // Serviços
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_TIPO"	)
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_CODIGO")
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_NOME"  )	
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_PREST" ) 
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_EXPIR" )
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_REVIS" )
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_CONTR" )
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_PROPRI")
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_ENTID1")	 
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_LOJA"	 )
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_LOCAL" )
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_ENTLOC" )	
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_LOCCON")
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_USOAPL")
//	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_CONFID")
//	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_INTEGR")
//	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_DISPON")
//	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_VALOR" )
//	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_DSVAL" )
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_SUBNIVE" )
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_LOCCONT" )
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_SBNVCON" )	
ElseIf nTipo==5 // Intangíveis	
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_TIPO"	)
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_CODIGO")
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_NOME"  )		
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_CLASS") 
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_DSCLAS")	
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_PROPRI")
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_ENTID1")	
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_VLMERC")
//	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_RENTAB")
  //aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_CUSTO")
//	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_VALOR" )
//	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_DSVAL" )
ElseIf nTipo==6 // Pessoas
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_TIPO"	)
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_CODIGO")
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_NOME"  )	
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_FUNCAO")		
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_FGCHAV")		
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_SUPERI")		
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_AVALDE")		
//	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_CONHEC")		
//	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_HABILI")		 
//	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_DISPON")
//	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_VALOR" )
//	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_DSVAL" )	
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_PARTIC")
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_ENTLOC")
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_LOCAL")       
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_SUBNIVE" )
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_LOCCONT" )
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_SBNVCON" )	
	aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_OBSERVA")

	If nOpc == 2 .Or. ALTERA
		aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_MATRICU")
		aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_NOMFUNC")
//		aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_CODFUNC")
		aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_DESCFUN")
		aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_CODSUPE")
		aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_NOMSUPE")
		aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_CHAVGER")
		aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_DESCHAV")
    EndIf

Endif		

Return aCpos

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSATV1IMP   ºAutor  ³Marcelo Celi Marquesº Data ³ 04/10/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressão de Ativos.								          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CSATV1IMP()
Local oReport     
Local nTipo			:= GetTipAtv()           
Local aCpos 		:= GetCposAtv(nTipo)
Private _cTipoAtv	:= Alltrim(Str(nTipo)) 

aCpos := GetCposAtv(nTipo)
  
If nTipo>0
	If u_SCSGSIUse(Alltrim(Str(nTipo))+u_SCGetIdFu("CSATV1IMP"))	
		If Len(aCpos)>0
			oReport:= ReportDef(nTipo,aCpos)
			oReport:PrintDialog()
		EndIf
	Else
		MsgAlert("Usuário sem direito de acesso a esta funcionalidade.")
	EndIf
EndIf		
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportDef   ºAutor  ³Marcelo Celi Marquesº Data ³ 04/10/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressão de Ativos.								          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportDef(nTipo,aCpos)
Local oReport 
Local oSection1
Local oCell         
Local aOrdem := {}
Local nX
Local cTitulo := cCadastro+" - "+GetDsTipo(nTipo)

Pergunte(cPergunte,.F.)      

oReport:= TReport():New(cPergunte,cTitulo,cPergunte, {|oReport| ReportPrint(oReport,nTipo,aCpos)},cTitulo)
oReport:SetTotalInLine(.F.)
oReport:SetLandScape()

oSection1 := TRSection():New(oReport,cTitulo,{},aOrdem) 
oSection1 :SetTotalInLine(.F.)                                

For nX:=1 to Len(aCpos)                              
	If aCpos[nX]<>Right(ALIAS_DA_TABELA,2)+"_TIPO"
		TRCell():New(oSection1,	aCpos[nX]	,""	,(ALIAS_DA_TABELA)->(RetTitle(aCpos[nX]))	,PesqPict(ALIAS_DA_TABELA,aCpos[nX])	,Tamsx3(aCpos[nX])[1],,) 
	EndIf	
Next nX

Return(oReport)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportPrint ºAutor  ³Marcelo Celi Marquesº Data ³ 04/10/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressão de Ativos.								          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportPrint(oReport,nTipo,aCpos)
Local oSection1 := oReport:Section(1) 
Local nOrdem    := oReport:Section(1):GetOrder() 
Local nX		:= 0
Local nY		:= 0
Local cQuery	:= ""

cQuery := "SELECT * FROM "+RetSqlName(ALIAS_DA_TABELA)+" TMP "
cQuery += "			WHERE 	TMP.D_E_L_E_T_ = '' "
cQuery += "				AND	TMP."+Right(ALIAS_DA_TABELA,2)+"_TIPO = "+Alltrim(Str(nTipo))
cQuery += "				AND TMP."+Right(ALIAS_DA_TABELA,2)+"_CODIGO BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
cQuery += "			ORDER BY TMP."+Right(ALIAS_DA_TABELA,2)+"_NOME "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TRB", .F., .T.)

oReport:SetMeter(TRB->(RecCount()))
Do While !TRB->(Eof())	
	// Se cancelado pelo usuario                            	     
	If oReport:Cancel()
		Exit			
	Else	
		For nX:=1 to Len(aCpos)        
			If aCpos[nX]<>Right(ALIAS_DA_TABELA,2)+"_TIPO"
				oSection1:Cell(aCpos[nX]):SetValue(TRB->&(aCpos[nX]))			
			EndIf	
		Next nX
						
		oSection1:Init() 
		oSection1:PrintLine()
	 EndIf
	 TRB->(dbSkip())
EndDo	           
TRB->(dbCloseArea())
oSection1:Finish() 
			
Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AtuSx1      ºAutor  ³Marcelo Celi Marquesº Data ³ 05/10/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualização dos SX1.								          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AtuSx1(cPerg)
Local aHlpPor := {}
aHlpPor := {}
Aadd( aHlpPor, ""	)
Aadd( aHlpPor, ""	)
PutSx1(cPerg,	"01","Do Ativo?","","","mv_ch1","C",TamSX3(Right(ALIAS_DA_TABELA,2)+"_CODIGO")[1],0,1,;   
				"G","",ALIAS_DA_TABELA,"","S","mv_par01","","","","","","","","","","","","","","","","",aHlpPor,aHlpPor,aHlpPor)

aHlpPor := {}
Aadd( aHlpPor, ""	)
Aadd( aHlpPor, ""		)
PutSx1(cPerg,	"02","Até o Ativo?","","","mv_ch2","C",TamSX3(Right(ALIAS_DA_TABELA,2)+"_CODIGO")[1],0,1,;   
				"G","",ALIAS_DA_TABELA,"","S","mv_par02","","","","","","","","","","","","","","","","",aHlpPor,aHlpPor,aHlpPor)

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GetDsTipo   ºAutor  ³Marcelo Celi Marquesº Data ³ 05/10/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna a descrição do tipo do ativo.				          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetDsTipo(nTipo)
Local cDescric := ""
If nTipo==1 
	cDescric :="Informação"
ElseIf nTipo==2
	cDescric := "Software"
ElseIf nTipo==3
	cDescric := "Fisico"
ElseIf nTipo==4 
	cDescric := "Serviços"
ElseIf nTipo==5 
	cDescric := "Intangíveis"
ElseIf nTipo==6 
	cDescric := "Pessoas"
Endif		

Return cDescric

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AtuHelp     ºAutor  ³Marcelo Celi Marquesº Data ³ 05/10/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualiza is helps de campos.						          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AtuHelp()
Local aHelp := {}

aHelp:= {"Informar o tipo do ativo."}
PutHelp("P"+Right(ALIAS_DA_TABELA,2)+"_TIPO",aHelp,aHelp,aHelp)	

aHelp:= {"Informar o código do ativo."}
PutHelp("P"+Right(ALIAS_DA_TABELA,2)+"_CODIGO",aHelp,aHelp,aHelp)	
                                                                    
aHelp:= {"Informar o nome do ativo."}
PutHelp("P"+Right(ALIAS_DA_TABELA,2)+"_NOME",aHelp,aHelp,aHelp)	

aHelp:= {"Informar a função do ativo."}
PutHelp("P"+Right(ALIAS_DA_TABELA,2)+"_FUNCAO",aHelp,aHelp,aHelp)	

aHelp:= {"Informar a função de gerencia de chaves."}
PutHelp("P"+Right(ALIAS_DA_TABELA,2)+"_FGCHAV",aHelp,aHelp,aHelp)	

aHelp:= {"Informar o superior imediato."}
PutHelp("P"+Right(ALIAS_DA_TABELA,2)+"_SUPERI",aHelp,aHelp,aHelp)	

aHelp:= {"Informar a avaliação de desempenho."}
PutHelp("P"+Right(ALIAS_DA_TABELA,2)+"_AVALDE",aHelp,aHelp,aHelp)	

aHelp:= {"Informar a classificação do ativo."}
PutHelp("P"+Right(ALIAS_DA_TABELA,2)+"_CLASS",aHelp,aHelp,aHelp)	

aHelp:= {"Informar a descrição da classificação."}
PutHelp("P"+Right(ALIAS_DA_TABELA,2)+"_DSCLAS",aHelp,aHelp,aHelp)	

aHelp:= {"Informar o prestador de serviço."}
PutHelp("P"+Right(ALIAS_DA_TABELA,2)+"_PREST",aHelp,aHelp,aHelp)	

aHelp:= {"Informar a data de expiração de contrato."}
PutHelp("P"+Right(ALIAS_DA_TABELA,2)+"_EXPIR",aHelp,aHelp,aHelp)	

aHelp:= {"Informar a identificação do ativo."}
PutHelp("P"+Right(ALIAS_DA_TABELA,2)+"_IDENT",aHelp,aHelp,aHelp)	

aHelp:= {"Informar a marca do ativo."}
PutHelp("P"+Right(ALIAS_DA_TABELA,2)+"_MARCA",aHelp,aHelp,aHelp)	

aHelp:= {"Informar o proprietário do ativo."}
PutHelp("P"+Right(ALIAS_DA_TABELA,2)+"_PROPRI",aHelp,aHelp,aHelp)	

aHelp:= {"Informar o formato do ativo."}
PutHelp("P"+Right(ALIAS_DA_TABELA,2)+"_FORMAT",aHelp,aHelp,aHelp)	

aHelp:= {"Informar a descrição do formato."}
PutHelp("P"+Right(ALIAS_DA_TABELA,2)+"_DSFORM",aHelp,aHelp,aHelp)	

aHelp:= {"Informar a localização do ativo."}
PutHelp("P"+Right(ALIAS_DA_TABELA,2)+"_LOCAL",aHelp,aHelp,aHelp)	

aHelp:= {"Informar a localização de contingencia do ativo."}
PutHelp("P"+Right(ALIAS_DA_TABELA,2)+"_LOCCON",aHelp,aHelp,aHelp)	

aHelp:= {"Informar a quantidade de licenças e cópias."}
PutHelp("P"+Right(ALIAS_DA_TABELA,2)+"_QTDLIC",aHelp,aHelp,aHelp)	

aHelp:= {"Informar a politica de uso aplicável."}
PutHelp("P"+Right(ALIAS_DA_TABELA,2)+"_USOAPL",aHelp,aHelp,aHelp)	

//aHelp:= {"Informar o conhecimento do ativo."}
//PutHelp("P"+Right(ALIAS_DA_TABELA,2)+"_CONHEC",aHelp,aHelp,aHelp)	

//aHelp:= {"Informar a habilidade do ativo."}
//PutHelp("P"+Right(ALIAS_DA_TABELA,2)+"_HABILI",aHelp,aHelp,aHelp)	

aHelp:= {"Informar a confidencialidade do ativo."}
//PutHelp("P"+Right(ALIAS_DA_TABELA,2)+"_CONFID",aHelp,aHelp,aHelp)	

//aHelp:= {"Informar a integridade do ativo."}
//PutHelp("P"+Right(ALIAS_DA_TABELA,2)+"_INTEGR",aHelp,aHelp,aHelp)	

//aHelp:= {"Informar a disponibilidade do ativo."}
//PutHelp("P"+Right(ALIAS_DA_TABELA,2)+"_DISPON",aHelp,aHelp,aHelp)	

aHelp:= {"Informar o valor de mercado."}
PutHelp("P"+Right(ALIAS_DA_TABELA,2)+"_VLMERC",aHelp,aHelp,aHelp)	

aHelp:= {"Informar a rentabilidade."}
PutHelp("P"+Right(ALIAS_DA_TABELA,2)+"_RENTAB",aHelp,aHelp,aHelp)	

aHelp:= {"Informar o custo."}
PutHelp("P"+Right(ALIAS_DA_TABELA,2)+"_CUSTO",aHelp,aHelp,aHelp)	

//aHelp:= {"Informar o valor."}
//PutHelp("P"+Right(ALIAS_DA_TABELA,2)+"_VALOR",aHelp,aHelp,aHelp)	

//aHelp:= {"Informar o descritivo do valor."}
//PutHelp("P"+Right(ALIAS_DA_TABELA,2)+"_DSVAL",aHelp,aHelp,aHelp)	

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CSVlAlAtv  ³ Autor ³ Marcelo Celi Marques ³ Data ³ 17/10/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Valida de campo pode ser alterado.	                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Certisign                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CSVlAlAtv(cAlias,cCampo)
Local lRet 	:= .T.
Local aCpos	:= {}                             

Default cCampo := ""

//Servicos
aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_PREST" )  
aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_LOJA"	 )
aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_EXPIR" ) 
aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_REVIS" )
aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_CONTR" )
//Pessoas
aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_PARTIC" )
aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_NOME" )
//Software
aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_NOME" )
aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_CODSFT" )
aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_IDENT" )
aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_QTDLIC" )
//Hardware
aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_NOME" )
aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_CODHRD" )
aAdd(aCpos,Right(ALIAS_DA_TABELA,2)+"_IDENT" ) 

If Altera
	If !Empty(&((cAlias)+"->"+Right(ALIAS_DA_TABELA,2)+"_ORIGEM")) .And. !(Upper(Funname()) $ Upper(&((cAlias)+"->"+Right(ALIAS_DA_TABELA,2)+"_ORIGEM")))	.And. aScan(aCpos,{|x|Alltrim(x)==Alltrim(cCampo)})>0
		lRet := .F.
	EndIf
EndIf	

If lRet
	If !Empty(cCampo) .And. ValType(cCampo) == "C" 
		Do Case
			Case "_CODSFT" $ cCampo 
				If !u_SCSGSIUse("FS")		
					lRet := .F.
					EndIf	
				Case "_CODHRD" $ cCampo   
					If !u_SCSGSIUse("FH")		
					lRet := .F.
				EndIf	
			Case "_PARTIC" $ cCampo 	
				If !u_SCSGSIUse("FP")				
					lRet := .F.      
				EndIf	
			Case "_CONTR" $ cCampo  
				If !u_SCSGSIUse("FC") 		
					lRet := .F.
				EndIf	
			Case "_NOME" $ cCampo .And. M->ZZ_TIPO == "5"
				lRet := .T.			
			Case "_NOME" $ cCampo .And. M->ZZ_TIPO <> "5"
				lRet := .F.
		End Case	
    EndIf
EndIf

Return lRet

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CSGetProp  ³ Autor ³ Marcelo Celi Marques ³ Data ³ 17/10/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Escolhe qual entidade a ser utilizada.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Certisign                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CSGetProp(lCpo)
Local aSubNiv	:= {"Nível 1","Nível 2","Nível 3 – Data Center","Nível 3 – Escritório","Nível 4 – Online","Nível 4 – Offline","Nível 5 – Online","Nível 5 – Offline","Nível 6 – Cofre","Nível 6 – Cage","Nível 7"}
Local oDlg, oPanel, oFWLayer
Local cOpc 		:= &("M->"+Right(ALIAS_DA_TABELA,2)+"_ENTID1") 
Local nOpcA		:= 0
Local cTexto 	:= If(cOpc=='1',"Participantes",If(cOpc=='2',"Cargos/Funções","Locais"))
Local cEntidade	:= ""  
Local cDSEntid	:= ""
Local cSubNiv	:= ""

DEFINE MSDIALOG oDlg FROM 020,001 TO 150,340 TITLE "Entidade - "+cTexto PIXEL Style 1 Color CLR_BLACK,CLR_WHITE 

oFWLayer := FWLayer():New()  
oFWLayer:Init(oDlg,.F.,.T.)  	  
oFWLayer:addLine("LINHA1",100,.F.)  
oFWLayer:AddCollumn("QUADRO1"	,100,.T.,"LINHA1")    
oFWLayer:AddWindow("QUADRO1"	,"oPanel"	,"Entidade - "+cTexto ,100,.F.,.T.,,"LINHA1",{ || })   
oPanel := oFWLayer:GetWinPanel("QUADRO1","oPanel","LINHA1")   

If cOpc=='1' 
	cEntidade := Criavar("RD0_CODIGO",.F.)
	@ 005, 005 Say "Participante"	OF oPanel PIXEL  
	@ 018, 005 Say "Nome"			OF oPanel PIXEL 
	@ 005, 041 MSGET cEntidade 		SIZE 120, 09 F3 "RD0"	OF oPanel PIXEL Hasbutton Valid GetDsEnt1(@cDSEntid,"RD0",xFilial("RD0")+cEntidade,"RD0_NOME")
	@ 018, 041 MSGET cDSEntid 		SIZE 120, 09 WHEN .F.	OF oPanel PIXEL Hasbutton 	
ElseIf cOpc=='2'
	cEntidade := Criavar("RJ_FUNCAO",.F.)
	@ 005, 005 Say "Função"			OF oPanel PIXEL  
	@ 018, 005 Say "Descrição"		OF oPanel PIXEL 
	@ 005, 041 MSGET cEntidade 		SIZE 120, 09 F3 "SRJ"	OF oPanel PIXEL Hasbutton Valid GetDsEnt1(@cDSEntid,"SRJ",xFilial("SRJ")+cEntidade,"RJ_DESC")  
	@ 018, 041 MSGET cDSEntid 		SIZE 120, 09 WHEN .F.	OF oPanel PIXEL Hasbutton 	
Else
	cEntidade := Criavar("RJ_FILIAL",.F.)
	@ 005, 005 Say "Local"			OF oPanel PIXEL  
	@ 018, 005 Say "Descrição"		OF oPanel PIXEL 
	@ 031, 005 Say "Sub-Nivel"		OF oPanel PIXEL 
	@ 005, 041 MSGET cEntidade 		SIZE 120, 09 F3 "SM0"	OF oPanel PIXEL Hasbutton Valid GetDsEnt1(@cDSEntid,"SM0",cEmpant+cEntidade,"M0_FILIAL")  
	@ 018, 041 MSGET cDSEntid 		SIZE 120, 09 WHEN .F.	OF oPanel PIXEL Hasbutton 	
	@ 051, 46.5 COMBOBOX cSubNiv ITEMS aSubNiv SIZE 120, 09 PIXEL OF oDlg 
EndIf

Activate MsDialog oDlg ON INIT u_CSGEnchBar(oDlg,{|| nOpcA:=1,oDlg:End() },{ || nOpcA:=0,oDlg:End() },{},,.F.,,,0,.T.) Center 

If nOpcA==1                 
	If !lCpo
		&("M->"+Right(ALIAS_DA_TABELA,2)+"_PROPRI") := cDSEntid 
		&("M->"+Right(ALIAS_DA_TABELA,2)+"_SUBNIVE") := cSubNiv 
	Else 
		&("M->"+Right(ALIAS_DA_TABELA,2)+"_LOCCONT") := cDSEntid 
		&("M->"+Right(ALIAS_DA_TABELA,2)+"_SBNVCON") := cSubNiv 	
	EndIf
EndIf

Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CSGetLoca  ³ Autor ³ Marcelo Celi Marques ³ Data ³ 18/10/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Escolhe qual entidade a ser utilizada.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Certisign                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CSGetLoca(lCpo)
Local aSubNiv	:= {"Nível 1","Nível 2","Nível 3 – Data Center","Nível 3 – Escritório","Nível 4 – Online","Nível 4 – Offline","Nível 5 – Online","Nível 5 – Offline","Nível 6 – Cofre","Nível 6 – Cage","Nível 7"}
Local oDlg, oPanel, oFWLayer
Local cOpc 		:= Iif(!lCpo,&("M->"+Right(ALIAS_DA_TABELA,2)+"_ENTLOC") ,&("M->"+Right(ALIAS_DA_TABELA,2)+"_LOCCON") )
Local nOpcA		:= 0
Local cTexto 	:= If(cOpc=='1',"Filiais","Postos de Atendimento")
Local cEntidade	:= ""  
Local cDSEntid	:= ""
Local cSubNiv	:= ""

DEFINE MSDIALOG oDlg FROM 020,001 TO 150,340 TITLE "Entidade - "+cTexto PIXEL Style 1 Color CLR_BLACK,CLR_WHITE 

oFWLayer := FWLayer():New()  
oFWLayer:Init(oDlg,.F.,.T.)  	  
oFWLayer:addLine("LINHA1",100,.F.)  
oFWLayer:AddCollumn("QUADRO1"	,100,.T.,"LINHA1")    
oFWLayer:AddWindow("QUADRO1"	,"oPanel"	,"Entidade - "+cTexto ,100,.F.,.T.,,"LINHA1",{ || })   
oPanel := oFWLayer:GetWinPanel("QUADRO1","oPanel","LINHA1")   

If cOpc == "1" .Or. cOpc == "3"
	cEntidade := Criavar("RJ_FILIAL",.F.)
	@ 005, 005 Say "Local"			OF oPanel PIXEL  
	@ 018, 005 Say "Descrição"		OF oPanel PIXEL 
	@ 031, 005 Say "Sub-Nivel"		OF oPanel PIXEL 
	@ 005, 041 MSGET cEntidade 		SIZE 120, 09 F3 Iif(cOpc == "3",CSRETLOC(@cEntidade,@cDSEntid),"SM0")	OF oPanel PIXEL Hasbutton Valid Iif(cOpc == "3",,GetDsEnt1(@cDSEntid,"SM0",cEmpant+cEntidade,"M0_FILIAL")  )
	@ 018, 041 MSGET cDSEntid 		SIZE 120, 09 WHEN .F.	OF oPanel PIXEL Hasbutton 	
	@ 051, 46.5 COMBOBOX cSubNiv ITEMS aSubNiv SIZE 120, 09 PIXEL OF oDlg 
Else
	cEntidade := Criavar("Z3_CODENT",.F.)
	@ 005, 005 Say "Entidade"		OF oPanel PIXEL  
	@ 018, 005 Say "Descrição"		OF oPanel PIXEL 
	@ 005, 041 MSGET cEntidade 		SIZE 120, 09 F3 "SZ3"	OF oPanel PIXEL Hasbutton Valid GetDsEnt1(@cDSEntid,"SZ3",xFilial("SZ3")+cEntidade,"Z3_DESENT")
	@ 018, 041 MSGET cDSEntid 		SIZE 120, 09 WHEN .F.	OF oPanel PIXEL Hasbutton 	
EndIf

Activate MsDialog oDlg ON INIT u_CSGEnchBar(oDlg,{|| nOpcA:=1,oDlg:End() },{ || nOpcA:=0,oDlg:End() },{},,.F.,,,0,.T.) Center 

If nOpcA==1
	If !lCpo
		&("M->"+Right(ALIAS_DA_TABELA,2)+"_LOCAL") := cDSEntid 
		&("M->"+Right(ALIAS_DA_TABELA,2)+"_SUBNIVE") := cSubNiv 
	Else 
		&("M->"+Right(ALIAS_DA_TABELA,2)+"_LOCCONT") := cDSEntid 
		&("M->"+Right(ALIAS_DA_TABELA,2)+"_SBNVCON") := cSubNiv 	
	EndIf
EndIf

Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GetDsEnt1  ³ Autor ³ Marcelo Celi Marques ³ Data ³ 17/10/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Retorna a Descricao da entidade.		                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Certisign                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GetDsEnt1(cDSEntid,cAlias,cBuscar,cCampoRet)
cDSEntid:=Posicione(cAlias,1,cBuscar,cCampoRet)  
Return .T.                                                                

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CanUseRot  ³ Autor ³ Marcelo Celi Marques ³ Data ³ 18/10/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Retorna se a rotina pode ser utilizada ou rodar compatibiliz³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Certisign                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CanUseRot()    
Local aPRW 	:= GetAPOInfo("ceratva01.prw")
Local lRet 	:= .T. 
Local dData := DATA_DO_COMPATIBILIZADOR      
             
SX3->(dbSetOrder(1))
If !SX3->(dbSeek(ALIAS_DA_TABELA)) .Or. aPRW[4] < dData
	lRet := .F.
EndIf

// Rotina para atualizar as configurações das classificações de importância.
// Data.: 04.04.2013
// Autor: Robson Luiz - Rleg.
UpdClassif()

Return lRet

//+--------------------------------------------------------------------
// Rotina | UpdClassif | Autor | Robson Luiz - Rleg | Data | 04.04.2013
//+--------------------------------------------------------------------
// Descr. | Rotina p/ atualizar as config. das classif. de importância
//+--------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//+--------------------------------------------------------------------
Static Function UpdClassif()
	Local cX3_VALID := '', cX3_CBOX := '', cX3_RELACAO := '', aCpo := {}, nI := 0
	
	cX3_VALID   := "Pertence('12345')"
	cX3_CBOX    := "5=Critico;4=Alto;3=Medio;2=Baixo;1=Irrelevante"
	cX3_RELACAO := "'Irrelevante'"
	
//	AAdd( aCpo, 'ZZ_CONHEC' )
//	AAdd( aCpo, 'ZZ_HABILI' )
//	AAdd( aCpo, 'ZZ_CONFID' )
//	AAdd( aCpo, 'ZZ_INTEGR' )
//	AAdd( aCpo, 'ZZ_DISPON' )
	AAdd( aCpo, 'ZZ_VLMERC' )
	AAdd( aCpo, 'ZZ_RENTAB' )
//	AAdd( aCpo, 'ZZ_DSVAL'  )
	AAdd( aCpo, 'ZZ_CUSTO'  )
	
	SX3->( dbSetOrder( 2 ) )
	For nI := 1 To Len( aCpo )
		If SX3->( dbSeek( aCpo[ nI ] ) )
			If aCpo[ nI ] == 'ZZ_DSVAL'
				If !(cX3_RELACAO $ RTrim(SX3->X3_RELACAO))
					SX3->( RecLock( 'SX3', .F. ) )
					SX3->X3_RELACAO := cX3_RELACAO
					SX3->( MsUnLock() )
				Endif
		   Else
		   	SX3->( RecLock( 'SX3', .F. ) )
		   	If !(cX3_VALID $ RTrim(SX3->X3_VALID))
		   		SX3->X3_VALID := cX3_VALID
		   	Endif
		   	If !(cX3_CBOX $ RTrim(SX3->X3_CBOX))
		   		SX3->X3_CBOX := cX3_CBOX
		   	Endif
		   	If !(cX3_CBOX $ RTrim(SX3->X3_CBOXSPA))
		   		SX3->X3_CBOXSPA := cX3_CBOX
		   	Endif
		   	If !(cX3_CBOX $ RTrim(SX3->X3_CBOXENG))
		   		SX3->X3_CBOXENG := cX3_CBOX
		   	Endif
		   	SX3->( MsUnLock() )
		   Endif
		Endif
	Next nI 
Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CSISOAINC  ³ Autor ³ Marcelo Celi Marques ³ Data ³ 18/10/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao auxiliar no cadastro de ativos iso27001.			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Certisign                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/     
User Function CSISOAINC(cAlias)

If CN9->(Fieldpos("CN9_I27001"))>0 .And. RD0->(Fieldpos("RD0_I27001"))>0 .And. U04->(Fieldpos("U04_I27001"))>0 .And. U00->(Fieldpos("U00_I27001"))>0 
	If Val((cAlias)->&(Right(ALIAS_DA_TABELA,2)+"_TIPO"))==2 .And. !Empty((cAlias)->&(Right(ALIAS_DA_TABELA,2)+"_CODSFT")) 		// Software              
		Reclock("U04",.F.)
		U04->U04_I27001 := (cAlias)->&(Right(ALIAS_DA_TABELA,2)+"_CODIGO")	
		U04_FILISO		:= (cAlias)->&(Right(ALIAS_DA_TABELA,2)+"_FILIAL")
		U04->(MsUnlock())	  
		 
	ElseIf Val((cAlias)->&(Right(ALIAS_DA_TABELA,2)+"_TIPO"))==3 .And. !Empty((cAlias)->&(Right(ALIAS_DA_TABELA,2)+"_CODHRD")) 	// Fisico (Hardware)              
		Reclock("U00",.F.)
		U00->U00_I27001 := (cAlias)->&(Right(ALIAS_DA_TABELA,2)+"_CODIGO")
		U00_FILISO		:= (cAlias)->&(Right(ALIAS_DA_TABELA,2)+"_FILIAL")	
		U00->(MsUnlock())	  
		
	ElseIf Val((cAlias)->&(Right(ALIAS_DA_TABELA,2)+"_TIPO"))==4 .And. !Empty((cAlias)->&(Right(ALIAS_DA_TABELA,2)+"_CONTR")) 	// Servicos
		Reclock("CN9",.F.)
		CN9->CN9_I27001 := (cAlias)->&(Right(ALIAS_DA_TABELA,2)+"_CODIGO")	
		CN9_FILISO		:= (cAlias)->&(Right(ALIAS_DA_TABELA,2)+"_FILIAL")
		CN9->(MsUnlock())	  
	
	ElseIf Val((cAlias)->&(Right(ALIAS_DA_TABELA,2)+"_TIPO"))==6 .And. !Empty((cAlias)->&(Right(ALIAS_DA_TABELA,2)+"_PARTIC")) 	// Pessoas
		Reclock("RD0",.F.)
		RD0->RD0_I27001 := (cAlias)->&(Right(ALIAS_DA_TABELA,2)+"_CODIGO")	
		RD0_FILISO		:= (cAlias)->&(Right(ALIAS_DA_TABELA,2)+"_FILIAL")
		RD0->(MsUnlock())	  
	
	EndIf
EndIf
	              
Return
   
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CSGetSoft  ³ Autor ³ Marcelo Celi Marques ³ Data ³ 18/10/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Valida informacoes do cadastro de software.				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Certisign                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CSGetSoft()
Local lRet 		:= .T. 
Local cCodSft 	:= &(Readvar())
                            
U04->(dbSetOrder(1))
If !Empty(cCodSft) .And. U04->(dbSeek(xFilial("U04")+cCodSft)) 
	If !Empty(U04->U04_CODGRP) .And. !(Alltrim(U04->U04_CODGRP) $ _cGrupos)
	    MsgAlert("Você não tem permissão para usar este Software.")    
	    M->&(Right(ALIAS_DA_TABELA,2)+"_NOME" )		:= Criavar(Right(ALIAS_DA_TABELA,2)+"_NOME" )
		M->&(Right(ALIAS_DA_TABELA,2)+"_IDENT" )    := Criavar(Right(ALIAS_DA_TABELA,2)+"_IDENT" )
		M->&(Right(ALIAS_DA_TABELA,2)+"_QTDLIC" )   := Criavar(Right(ALIAS_DA_TABELA,2)+"_QTDLIC" )
		M->&(Right(ALIAS_DA_TABELA,2)+"_CODGRP" )	:= Criavar(Right(ALIAS_DA_TABELA,2)+"_CODGRP" )
		lRet := .F.                                  
	Else
		If Empty(U04->U04_I27001) 
			M->&(Right(ALIAS_DA_TABELA,2)+"_NOME" )		:= U04->U04_DESSFT
			M->&(Right(ALIAS_DA_TABELA,2)+"_IDENT" )    := U04->U04_LICENC
			M->&(Right(ALIAS_DA_TABELA,2)+"_QTDLIC" )   := U04->U04_QTDLIC
			M->&(Right(ALIAS_DA_TABELA,2)+"_CODGRP" )   := U04->U04_CODGRP
		Else
			MsgAlert("Software já amarrado ao ativo numero "+Alltrim(U04->U04_I27001))
			M->&(Right(ALIAS_DA_TABELA,2)+"_NOME" )		:= Criavar(Right(ALIAS_DA_TABELA,2)+"_NOME" )
			M->&(Right(ALIAS_DA_TABELA,2)+"_IDENT" )    := Criavar(Right(ALIAS_DA_TABELA,2)+"_IDENT" )
			M->&(Right(ALIAS_DA_TABELA,2)+"_QTDLIC" )   := Criavar(Right(ALIAS_DA_TABELA,2)+"_QTDLIC" )  
			M->&(Right(ALIAS_DA_TABELA,2)+"_CODGRP" )	:= Criavar(Right(ALIAS_DA_TABELA,2)+"_CODGRP" )  
			lRet := .F.
		EndIf
	EndIf			
EndIf 

Return lRet

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CSGetHard  ³ Autor ³ Marcelo Celi Marques ³ Data ³ 18/10/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Valida informacoes do cadastro de Hardware.				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Certisign                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CSGetHard()  

Local lRet 		:= .T. 
Local cCodHrd 	:= &(Readvar())
                            
U00->(dbSetOrder(1))
If !Empty(cCodHrd) .And. U00->(dbSeek(xFilial("U00")+cCodHrd)) 
	If !Empty(U00->U00_CODGRP) .And. !(Alltrim(U00->U00_CODGRP) $ _cGrupos)
	    MsgAlert("Você não tem permissão para usar este Hardware.")    
	    M->&(Right(ALIAS_DA_TABELA,2)+"_NOME" )		:= Criavar(Right(ALIAS_DA_TABELA,2)+"_NOME" )
		M->&(Right(ALIAS_DA_TABELA,2)+"_IDENT" )    := Criavar(Right(ALIAS_DA_TABELA,2)+"_IDENT" )    
		M->&(Right(ALIAS_DA_TABELA,2)+"_CODGRP" )	:= Criavar(Right(ALIAS_DA_TABELA,2)+"_CODGRP" )  
		lRet := .F.                                  
	Else
		If Empty(U00->U00_I27001) 
			M->&(Right(ALIAS_DA_TABELA,2)+"_NOME" )		:= U00->U00_DESHRD
			M->&(Right(ALIAS_DA_TABELA,2)+"_IDENT" )    := U00->U00_NUMSER 
			M->&(Right(ALIAS_DA_TABELA,2)+"_CODGRP" )   := U00->U00_CODGRP
		Else
			MsgAlert("Hardware já amarrado ao ativo numero "+Alltrim(U00->U00_I27001))
			M->&(Right(ALIAS_DA_TABELA,2)+"_NOME" )		:= Criavar(Right(ALIAS_DA_TABELA,2)+"_NOME" )
			M->&(Right(ALIAS_DA_TABELA,2)+"_IDENT" )    := Criavar(Right(ALIAS_DA_TABELA,2)+"_IDENT" ) 
			M->&(Right(ALIAS_DA_TABELA,2)+"_CODGRP" )	:= Criavar(Right(ALIAS_DA_TABELA,2)+"_CODGRP" )  
			lRet := .F.
		EndIf
	EndIf			
EndIf 

Return lRet

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CSGetPess  ³ Autor ³ Marcelo Celi Marques ³ Data ³ 18/10/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Valida informacoes do cadastro de Pessoas.				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Certisign                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CSGetPess()
Local lRet := .T.

If !Empty(M->&(Right(ALIAS_DA_TABELA,2)+"_PARTIC" )) .And. !RD0->(Eof()) .And. !RD0->(Bof())
	If Empty(RD0->RD0_I27001) 
		M->&(Right(ALIAS_DA_TABELA,2)+"_NOME" )		:= RD0->RD0_NOME
	Else
		MsgAlert("Pessoa já amarrado ao ativo numero "+Alltrim(RD0->RD0_I27001)) 
		lRet := .F.
	EndIf
Else
	lRet := .F.		
EndIf 

Return lRet

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CSGetServ  ³ Autor ³ Marcelo Celi Marques ³ Data ³ 18/10/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Valida informacoes do cadastro de Servicos.				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Certisign                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CSGetServ()
Local lRet := .T.

If !Empty(M->&(Right(ALIAS_DA_TABELA,2)+"_CONTR" )) .And. !CN9->(Eof()) .And. !CN9->(Bof())
	If Empty(CN9->CN9_I27001) 
		M->&(Right(ALIAS_DA_TABELA,2)+"_EXPIR" )		:= CN9->CN9_DTFIM 
		M->&(Right(ALIAS_DA_TABELA,2)+"_REVIS" )		:= CN9->CN9_DTREV
	Else
		MsgAlert("Contrato já amarrado ao ativo numero "+Alltrim(CN9->CN9_I27001)) 
		lRet := .F.
	EndIf
Else
	lRet := .F.		
EndIf 

Return lRet
   
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³SCATVINCS  ³ Autor ³ Marcelo Celi Marques ³ Data ³ 19/10/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Inclui o ativo pelos cadastros de Entidades.				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Certisign                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SCATVINCS(cAlias,nReg,nOpc)
Local nTipo 	:= 0 
Local cRotInic 	:= ""

Do Case
	Case Upper(cAlias) == "U04"
		If Empty(U04->U04_I27001)	
			nTipo 	:= 2 
			cRotInic:= "U_ATVINSO"
		Else
			MsgAlert("Software já vinculado ao ativo "+Alltrim(U04->U04_I27001)+".")
		EndIf	
		
	Case Upper(cAlias) == "U00"
		If Empty(U00->U00_I27001)	
			nTipo 	:= 3 
			cRotInic:= "U_SCATVINHA"
		Else
			MsgAlert("Hardware já vinculado ao ativo "+Alltrim(U00->U00_I27001)+".")
		EndIf	
		
	Case Upper(cAlias) == "CN9"
		If Empty(CN9->CN9_I27001)			
			nTipo 	:= 4 
			cRotInic:= "U_ATVINS2"
		Else
			MsgAlert("Contrato já vinculado ao ativo "+Alltrim(CN9->CN9_I27001)+".")
		EndIf	
		
	Case Upper(cAlias) == "RD0"
		If Empty(RD0->RD0_I27001)	
			nTipo 	:= 6 
			cRotInic:= "U_SCATVINPE"
		Else
			MsgAlert("Participante já vinculado ao ativo "+Alltrim(RD0->RD0_I27001)+".")
		EndIf	
		
End Case

If nTipo>0
	u_CSATV1INC(ALIAS_DA_TABELA,0,3,,,,nTipo,cRotInic)      
EndIf	

Return
      
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ATVINSO  ³ Autor ³ Marcelo Celi Marques ³ Data ³ 19/10/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Inicializa as variaveis de memoria quando inclusao realizada³±± 
±±³			 ³pelo cadastro de Software.								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Certisign                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ATVINSO()
M->&(Right(ALIAS_DA_TABELA,2)+"_CODSFT" )	:= U04->U04_CODSFT
M->&(Right(ALIAS_DA_TABELA,2)+"_NOME" )		:= U04->U04_DESSFT
M->&(Right(ALIAS_DA_TABELA,2)+"_IDENT" )    := U04->U04_LICENC
M->&(Right(ALIAS_DA_TABELA,2)+"_QTDLIC" )   := U04->U04_QTDLIC
Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³SCATVINHA  ³ Autor ³ Marcelo Celi Marques ³ Data ³ 19/10/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Inicializa as variaveis de memoria quando inclusao realizada³±± 
±±³			 ³pelo cadastro de Hardware.								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Certisign                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SCATVINHA()
M->&(Right(ALIAS_DA_TABELA,2)+"_CODHRD" ) 	:= U00->U00_CODHRD
M->&(Right(ALIAS_DA_TABELA,2)+"_NOME" )		:= U00->U00_DESHRD
M->&(Right(ALIAS_DA_TABELA,2)+"_IDENT" )    := U00->U00_NUMSER
M->&(Right(ALIAS_DA_TABELA,2)+"_MARCA" )    := AllTrim(U00->U00_DESHRD) + " / " + U00->U00_MARCA
Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ATVINS2  ³ Autor ³ Marcelo Celi Marques ³ Data ³ 19/10/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Inicializa as variaveis de memoria quando inclusao realizada³±± 
±±³			 ³pelo cadastro de Servicos.								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Certisign                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ATVINS2()
M->&(Right(ALIAS_DA_TABELA,2)+"_CONTR" )		:= CN9->CN9_NUMERO 
M->&(Right(ALIAS_DA_TABELA,2)+"_EXPIR" )		:= CN9->CN9_DTFIM 
M->&(Right(ALIAS_DA_TABELA,2)+"_REVIS" )		:= CN9->CN9_DTREV
Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³SCATVINPE  ³ Autor ³ Marcelo Celi Marques ³ Data ³ 19/10/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Inicializa as variaveis de memoria quando inclusao realizada³±± 
±±³			 ³pelo cadastro de Pessoas.									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Certisign                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SCATVINPE()
M->&(Right(ALIAS_DA_TABELA,2)+"_PARTIC" )	:= RD0->RD0_CODIGO
M->&(Right(ALIAS_DA_TABELA,2)+"_NOME" )		:= RD0->RD0_NOME
Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CSATVMANU  ³ Autor ³ Marcelo Celi Marques ³ Data ³ 19/10/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Altera/exclui ativo pelo cadastro de entidades.			  ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Certisign                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CSATVMANU(nTipoTab,cTipoMan)

Begin Transaction     
	Do Case
		Case nTipoTab==2
			If !Empty(U04->U04_I27001)
				(ALIAS_DA_TABELA)->(dbSetOrder(1))     
	  			If (ALIAS_DA_TABELA)->(dbSeek(U04->(U04_FILISO+U04_I27001)))
	  				Reclock(ALIAS_DA_TABELA,.F.)  
	  				If cTipoMan=="A"
	  					(ALIAS_DA_TABELA)->&(Right(ALIAS_DA_TABELA,2)+"_NOME" )		:= U04->U04_DESSFT
						(ALIAS_DA_TABELA)->&(Right(ALIAS_DA_TABELA,2)+"_IDENT" )    := U04->U04_LICENC
						(ALIAS_DA_TABELA)->&(Right(ALIAS_DA_TABELA,2)+"_QTDLIC" )   := U04->U04_QTDLIC  			
	  				Else
	  					Delete
	  				EndIf
	  				(ALIAS_DA_TABELA)->(MsUnlock())
				EndIf
			EndIf	
		Case nTipoTab==3
			If !Empty(U00->U00_I27001) 
				(ALIAS_DA_TABELA)->(dbSetOrder(1))     
	            If (ALIAS_DA_TABELA)->(dbSeek(U00->(U00_FILISO+U00_I27001)))
	            	Reclock(ALIAS_DA_TABELA,.F.)
	            	If cTipoMan=="A"
	            		(ALIAS_DA_TABELA)->&(Right(ALIAS_DA_TABELA,2)+"_NOME" )	:= U00->U00_DESHRD
						(ALIAS_DA_TABELA)->&(Right(ALIAS_DA_TABELA,2)+"_IDENT" ):= U00->U00_NUMSER
	            	Else
	            		Delete
	            	EndIf	
	            	(ALIAS_DA_TABELA)->(MsUnlock())
	            EndIf
			EndIf	            
		Case nTipoTab==4
			If !Empty(CN9->CN9_I27001)
				(ALIAS_DA_TABELA)->(dbSetOrder(1))     
	  			If (ALIAS_DA_TABELA)->(dbSeek(CN9->(CN9_FILISO+CN9_I27001)))
	  				Reclock(ALIAS_DA_TABELA,.F.)                         
	  				If cTipoMan=="A"
	  					(ALIAS_DA_TABELA)->&(Right(ALIAS_DA_TABELA,2)+"_EXPIR" ):= CN9->CN9_DTFIM 
						(ALIAS_DA_TABELA)->&(Right(ALIAS_DA_TABELA,2)+"_REVIS" ):= CN9->CN9_DTREV  			
	  				Else
	  					Delete
	  				EndIf	
	  				(ALIAS_DA_TABELA)->(MsUnlock())
				EndIf
			EndIf	
		Case nTipoTab==6
			If !Empty(RD0->RD0_I27001)
				(ALIAS_DA_TABELA)->(dbSetOrder(1))     
	  			If (ALIAS_DA_TABELA)->(dbSeek(RD0->(RD0_FILISO+RD0_I27001)))
	        		Reclock(ALIAS_DA_TABELA,.F.)
	        		If cTipoMan=="A"
	        			(ALIAS_DA_TABELA)->&(Right(ALIAS_DA_TABELA,2)+"_NOME" )	:= RD0->RD0_NOME    
	        	    Else
	        	    	Delete
	        	    EndIf	
	        	    (ALIAS_DA_TABELA)->(MsUnlock())
				EndIf
			EndIf	
	End Case          
End Transaction

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CSATVDESV  ³ Autor ³ Marcelo Celi Marques ³ Data ³ 22/10/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Desvincula Ativo x Entidade.								  ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Certisign                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CSATVDESV(cAlias,nReg,nOpc)  
Local nTipo

Do Case
	Case cAlias=="U04"
		nTipo:=2

	Case cAlias=="U00"
		nTipo:=3

	Case cAlias=="CN9"
		nTipo:=4

	Case cAlias=="RD0"
		nTipo:=6

EndCase                                 

(ALIAS_DA_TABELA)->(dbSetOrder(1))	
If nTipo==2 .And.!Empty(U04->U04_I27001) .And. MsgYesNo("Confirma o desvinculo do ativo "+U04->U04_I27001+" com a atual entidade?")	// Software              
	If (ALIAS_DA_TABELA)->(dbSeek(U04->(U04_FILISO+U04_I27001)))
		Reclock(ALIAS_DA_TABELA,.F.)
		(ALIAS_DA_TABELA)->&(Right(ALIAS_DA_TABELA,2)+"_CODSFT" )	:= ""
		(ALIAS_DA_TABELA)->&(Right(ALIAS_DA_TABELA,2)+"_NOME" )		:= ""
		(ALIAS_DA_TABELA)->&(Right(ALIAS_DA_TABELA,2)+"_IDENT" )    := ""
		(ALIAS_DA_TABELA)->&(Right(ALIAS_DA_TABELA,2)+"_QTDLIC" )   := 0 
		(ALIAS_DA_TABELA)->&(Right(ALIAS_DA_TABELA,2)+"_ORIGEM" )	:= "CSATVA01"
		(ALIAS_DA_TABELA)->(MsUnlock())	
	EndIf
	Reclock("U04",.F.)
	U04->U04_I27001 := ""	
	U04_FILISO		:= ""
	U04->(MsUnlock())	  
			 
ElseIf nTipo==3 .And.!Empty(U00->U00_I27001) .And. MsgYesNo("Confirma o desvinculo do ativo "+U00->U00_I27001+" com a atual entidade?") // Fisico (Hardware)              
	If (ALIAS_DA_TABELA)->(dbSeek(U00->(U00_FILISO+U00_I27001)))
		Reclock(ALIAS_DA_TABELA,.F.)
		(ALIAS_DA_TABELA)->&(Right(ALIAS_DA_TABELA,2)+"_CODHRD" ) 	:= ""
		(ALIAS_DA_TABELA)->&(Right(ALIAS_DA_TABELA,2)+"_NOME" )		:= ""
		(ALIAS_DA_TABELA)->&(Right(ALIAS_DA_TABELA,2)+"_IDENT" )    := ""		
		(ALIAS_DA_TABELA)->&(Right(ALIAS_DA_TABELA,2)+"_ORIGEM" )	:= "CSATVA01"
		(ALIAS_DA_TABELA)->(MsUnlock())	
	EndIf  
	Reclock("U00",.F.)
	U00->U00_I27001 := ""
	U00_FILISO		:= ""	
	U00->(MsUnlock())	
		
ElseIf nTipo==4 .And.!Empty(CN9->CN9_I27001) .And. MsgYesNo("Confirma o desvinculo do ativo "+CN9->CN9_I27001+" com a atual entidade?") // Servicos
	If (ALIAS_DA_TABELA)->(dbSeek(CN9->(CN9_FILISO+CN9_I27001)))
		Reclock(ALIAS_DA_TABELA,.F.)
		(ALIAS_DA_TABELA)->&(Right(ALIAS_DA_TABELA,2)+"_CONTR" )	:= "" 
		(ALIAS_DA_TABELA)->&(Right(ALIAS_DA_TABELA,2)+"_EXPIR" )	:= cTOD("") 
		(ALIAS_DA_TABELA)->&(Right(ALIAS_DA_TABELA,2)+"_REVIS" )	:= cTOD("")		
		(ALIAS_DA_TABELA)->&(Right(ALIAS_DA_TABELA,2)+"_ORIGEM" )	:= "CSATVA01"
		(ALIAS_DA_TABELA)->(MsUnlock())	
	EndIf  
	Reclock("CN9",.F.)
	CN9->CN9_I27001 := ""	
	CN9_FILISO		:= ""
	CN9->(MsUnlock())	  
	 
ElseIf nTipo==6 .And.!Empty(RD0->RD0_I27001) .And. MsgYesNo("Confirma o desvinculo do ativo "+RD0->RD0_I27001+" com a atual entidade?") 	// Pessoas
	If (ALIAS_DA_TABELA)->(dbSeek(RD0->(RD0_FILISO+RD0_I27001)))
		Reclock(ALIAS_DA_TABELA,.F.)
		(ALIAS_DA_TABELA)->&(Right(ALIAS_DA_TABELA,2)+"_PARTIC" )	:= ""
		(ALIAS_DA_TABELA)->&(Right(ALIAS_DA_TABELA,2)+"_NOME" )		:= ""		
		(ALIAS_DA_TABELA)->&(Right(ALIAS_DA_TABELA,2)+"_ORIGEM" )	:= "CSATVA01"
		(ALIAS_DA_TABELA)->(MsUnlock())	
	EndIf  
	Reclock("RD0",.F.)
	RD0->RD0_I27001 := ""	
	RD0_FILISO		:= ""
	RD0->(MsUnlock())	            
	
EndIf
	
Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CSISO27M1  ³ Autor ³ Marcelo Celi Marques ³ Data ³ 22/10/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Chama da Integracao das entidades x ativos, pelos cadastros ³±±  
±±³			 ³das entidades.											  ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Certisign                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CSISO27M1(cAlias,nReg,nOpc)
Local aButtons  := {}   
Local aSays		:= {}
Local nOpcA		:= 0                    
Local cDescric	:= ""

Do Case
	Case cAlias=="RD0" 
		cDescric := "Participantes" 
		
	Case cAlias=="CN9" 
		cDescric := "Contratos" 
		
	Case cAlias=="U00" 
		cDescric := "Hardwares"
		
	Case cAlias=="U04" 
		cDescric := "Softwares"	                      
		
EndCase
         
If u_SCSGSIUse(u_SCGetIdFu("CSISO27M1",cAlias))
	aAdd(aSays,"Opção de integrar a entidade "+cDescric+" com o cadastro")
	aAdd(aSays,"de ativos ISO27001.") 
	aAdd(aSays,"")
	aAdd(aSays,"Incluir Vinculo - Amarra o registro da entidade ao ativo.")
	aAdd(aSays,"") 
	aAdd(aSays,"Excluir Vinculo - Desamarra o registro vinculado ao ativo.")
	
	aAdd(aButtons,{4,.T.,{|x| U_SCATVINCS(cAlias,nReg,nOpc), x:oWnd:End() }})
	aAdd(aButtons,{3,.T.,{|x| U_CSATVDESV(cAlias,nReg,nOpc), x:oWnd:End() }})
	aAdd(aButtons,{2,.T.,{|x| x:oWnd:End() }})
	
	If !CanUseRot()
		MsgAlert("Rotina não pode ser executada ates que o compatibilizador u_CSUpdAtv1() seja aplicado na base.")
	Else
		FormBatch("ISO27001",aSays,aButtons,,,425)
	EndIf
Else
	MsgAlert("Usuário sem direito de acesso a esta funcionalidade.")
EndIf
	
Return                  

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CSISO27M1  ³ Autor ³ Marcelo Celi Marques ³ Data ³ 22/10/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Chama da Integracao das entidades x ativos, pelos cadastros ³±±  
±±³			 ³das entidades.											  ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Certisign                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SCFiltGTI(cAlias,cCampo)
Local nX		:= 0	
Local xGrupos 	:= u_SCSGSIGRP()    
Local cCondicao := ""

xGrupos := "{'"+StrTran(xGrupos,"|","','")+"'}"
xGrupos := &xGrupos

For nX:=1 to Len(xGrupos)
	If nX > 1
		cCondicao += " .Or. "
	EndIf
	cCondicao += cAlias + "->" + cCampo + " == '" + PadR(xGrupos[nX],Tamsx3(cCampo)[1]) + "'" 
Next nX	 

If !Empty(cCondicao)
	cCondicao+=" .Or. "
EndIf

cCondicao+= cAlias+"->"+cCampo+" == ''"  

Return cCondicao
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CERATVA01 ºAutor  ³Microsiga           º Data ³  02/05/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CSRETLOC(cEntidade,cDSEntid)

Local aParamBox	:= {}
Local aRet		:= {}

aAdd(aParamBox,{3,"Local",1,{"Data Center Backup Mooca","Data Center Backup Certisign"},100,"",.F.})

If ParamBox(aParamBox,"Local Data Base...",@aRet)
	cEntidade := StrZero(aRet[01],2)
	
	If cEntidade == "01"
		cDSEntid := "Data Center Backup Mooca"
	Else
		cDSEntid := "Data Center Backup Certisign"
	EndIf
	
EndIf

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CERATVA01 ºAutor  ³Microsiga           º Data ³  02/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CSFUNCSUBS(aRecNo,nTipo)
Local oDlg		:= Nil
Local oPanel 	:= Nil
Local oFWLayer	:= Nil 
Local cMatric	:= Space(TamSX3("ZZ_MATRICU")[01])
Local cNomFunc	:= Space(TamSX3("ZZ_NOMFUNC")[01])
//Local cCodFunc	:= Space(TamSX3("RA_CODFUNC")[01])
Local cDesFunc	:= Space(TamSX3("RA_DESCFUN")[01])
Local cCodSup	:= Space(TamSX3("ZZ_CODSUPE")[01])
Local cNomeSup	:= Space(TamSX3("ZZ_NOMSUPE")[01])
Local cGerChav	:= Space(TamSX3("ZZ_CHAVGER")[01])
Local cDescChav	:= Space(TamSX3("ZZ_DESCHAV")[01])
Local oMatric	:= Nil
Local oNomFunc	:= Nil

If nTipo == 6

	If Len(aRecno) > 0
		cMatric		:= aRecno[01,02]
		cNomFunc 	:= aRecno[02,02]
		cDesFunc 	:= aRecno[03,02]
		cCodSup 	:= aRecno[04,02]
		cNomeSup 	:= aRecno[05,02]
		cGerChav 	:= aRecno[06,02]
		cDescChav 	:= aRecno[07,02]
	EndIf

	DEFINE MSDIALOG oDlg FROM 020,001 TO 260,440 TITLE "Funcionário Substituto" PIXEL Style 1 Color CLR_BLACK,CLR_WHITE 
	
	oFWLayer := FWLayer():New()  
	oFWLayer:Init(oDlg,.F.,.T.)  	  
	oFWLayer:addLine("LINHA1",100,.F.)  
	oFWLayer:AddCollumn("QUADRO1"	,100,.T.,"LINHA1")    
	oFWLayer:AddWindow("QUADRO1"	,"oPanel"	,"Funcionário Substituto" ,100,.F.,.T.,,"LINHA1",{ || })   
	oPanel := oFWLayer:GetWinPanel("QUADRO1","oPanel","LINHA1") 
	
	@ 005, 005 Say "Matricula"		OF oPanel PIXEL  
	@ 018, 005 Say "Nome Func"		OF oPanel PIXEL 
	@ 031, 005 Say "Função"			OF oPanel PIXEL 
	@ 044, 005 Say "Cod Superior"	OF oPanel PIXEL 
	@ 057, 005 Say "Nome Superior"	OF oPanel PIXEL 
	@ 070, 005 Say "Ger. Chave"		OF oPanel PIXEL 
	@ 083, 005 Say "Desc Chave"		OF oPanel PIXEL 
	
	@ 005, 041 MSGET cMatric 		SIZE 170, 09 F3 "SRA"	OF oPanel PIXEL Hasbutton Valid {||  cNomFunc := Posicione("SRA",1,xFilial("SRA") + cMatric,"RA_NOME"),cDesFunc := Posicione("SRA",1,xFilial("SRA") + cMatric,"RA_DESCFUN")}
	@ 018, 041 MSGET cNomFunc 		SIZE 159, 09 WHEN .F.	OF oPanel PIXEL Hasbutton 	
	@ 031, 041 MSGET cDesFunc 		SIZE 159, 09 WHEN .F.	OF oPanel PIXEL Hasbutton
	@ 044, 041 MSGET cCodSup 		SIZE 170, 09 F3 "SRA"	OF oPanel PIXEL Hasbutton Valid {||  cNomeSup := Posicione("SRA",1,xFilial("SRA") + cCodSup,"RA_NOME")}
	@ 057, 041 MSGET cNomeSup 		SIZE 159, 09 WHEN .F.	OF oPanel PIXEL Hasbutton
	@ 070, 041 MSGET cGerChav 		SIZE 170, 09 F3 "ZI"	OF oPanel PIXEL Hasbutton Valid cDescChav := Posicione("SX5",1,xFilial("SX5") + "ZI" + cGerChav,"X5_DESCRI")
	@ 083, 041 MSGET cDescChav 		SIZE 159, 09 WHEN .F.	PICTURE "@!" OF oPanel PIXEL Hasbutton
	
	Activate MsDialog oDlg ON INIT u_CSGEnchBar(oDlg,{|| oDlg:End() },{ || oDlg:End() },{},,.F.,,,0,.T.) Center

	If Len(aRecno) > 0
		aRecNo := {}
	EndIf

	aAdd(aRecNo,{"ZZ_MATRICU",cMatric})
	aAdd(aRecNo,{"ZZ_NOMFUNC",cNomFunc})
	aAdd(aRecNo,{"ZZ_DESCFUN",cDesFunc})
	aAdd(aRecNo,{"ZZ_CODSUPE",cCodSup})
	aAdd(aRecNo,{"ZZ_NOMSUPE",cNomeSup})
	aAdd(aRecNo,{"ZZ_CHAVGER",cGerChav})
	aAdd(aRecNo,{"ZZ_DESCHAV",cDescChav})

Else
	MsgAlert("Rotina disponibilizada somente para opção PESSOAS.","Certisign")
EndIf

Return