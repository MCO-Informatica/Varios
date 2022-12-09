#INCLUDE "PROTHEUS.CH"

// DATA DE IMPLANTACAO NA PRODUCAO	: 22/10/2012
// DATA DA ULTIMA ALTERACAO			: 22/10/2012


#DEFINE ALIAS_DA_TABELA 	"Z01"  	// Apos implantacao, n�o mudar de maneira alguma essa informa��o     
#DEFINE F3_ROTINA			"ZK"	// Apos implantacao, n�o mudar de maneira alguma essa informa��o      

#DEFINE DATA_DO_COMPATIBILIZADOR  Stod("20121022") // Data do compatibilizador


/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ĵ��
��� Funcao   � CSUSRSGSI � Autor � Marcelo Celi Marques � Data �26/10/2012���
�������������������������������������������������������������������������Ĵ��
���Descricao � Cadastro de operadores do modulo de SGSI.                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Certisign		                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
User Function CSUSRSGSI()
Private aRotina 	:= MenuDef()
Private cCadastro 	:="Operadores do SGSI"

If !CanUseRot()
	MsgAlert("Rotina n�o pode ser executada ates que o compatibilizador u_CSUpdUSGS() seja aplicado na base.")
Else		
	SCAtuSx5()
	mBrowse( 6, 1,22,75,ALIAS_DA_TABELA,,,,,,u_CSUSGSLEG())
EndIf

Return


/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �CSUpdUSGS  � Autor � Marcelo Celi Marques � Data � 26/10/12 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Atualizacao dos SXs.				                          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Certisign                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
#DEFINE X3_USADO_EMUSO 		"���������������"
#DEFINE X3_USADO_NAOUSADO 	"���������������"   

User Function CSUpdUSGS(lMenu)
Local aSX2 		:= {}
Local aSX3 		:= {}
Local aSIX 		:= {}   
Local aSX5		:= {} 
Local aSXB		:= {}
Local aEstrut	:= {}
Local i, j    
Local aArea		:= GetArea()     

Default lMenu := .T.

Private lUpdAuto //:= .F.    

SX3->(dbSetOrder(2))
If !lMenu .And. SX3->(dbSeek(Right(ALIAS_DA_TABELA,2)+"_FILIAL"))
	Return
Else
	//->> Criacao da Tabela
	aEstrut:= {"X2_CHAVE"		,"X2_PATH"		,"X2_ARQUIVO"			,"X2_NOME"								,"X2_NOMESPAC"							,"X2_NOMEENGC"							,"X2_DELET"	,"X2_MODO"		,"X2_TTS"	,"X2_ROTINA"	}
	aAdd(aSX2,{ALIAS_DA_TABELA	,"\DADOSADV\"	,ALIAS_DA_TABELA+"990"	,"CADASTRO DE OPERADORES DO SGSI"		,"CADASTRO DE OPERADORES DO SGSI"		,"CADASTRO DE OPERADORES DO SGSI"		,0			,"C"			,""			,""				})	
	
	dbSelectArea("SX2")
	dbSetOrder(1)
	dbSeek("SE1")
	cPath := SX2->X2_PATH
	cNome := Substr(SX2->X2_ARQUIVO,4,5)
	cModo	:= "C"
	
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
	aEstrut:= 	{	"X3_ARQUIVO"		,"X3_ORDEM" ,"X3_CAMPO"  							,"X3_TIPO"  ,"X3_TAMANHO"				,"X3_DECIMAL"				,"X3_TITULO" 	,"X3_TITSPA","X3_TITENG","X3_DESCRIC"			,"X3_DESCSPA"	,"X3_DESCENG"	,"X3_PICTURE"			,"X3_VALID" 											,"X3_USADO"  		,"X3_RELACAO"						,"X3_F3"				,"X3_NIVEL" ,"X3_RESERV","X3_CHECK"	,"X3_TRIGGER"	,"X3_PROPRI","X3_BROWSE","X3_VISUAL","X3_CONTEXT"	,"X3_OBRIGAT"	,"X3_VLDUSER"									,"X3_CBOX"   						,"X3_CBOXSPA"	,"X3_CBOXENG"	,"X3_PICTVAR"	,"X3_WHEN"  				,"X3_INIBRW"		  			,"X3_GRPSXG","X3_FOLDER"	,"X3_PYME"	}			
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"01"		,u_SCGetCpo(ALIAS_DA_TABELA)+"_FILIAL"	,"C"		, Tamsx3("E1_FILIAL")[1]	, Tamsx3("E1_FILIAL")[2]	,"Filial"		,""			,""			,"Filial"				,""				,""				,"@!"					,""														,X3_USADO_NAOUSADO	,"xFilial('"+ALIAS_DA_TABELA+"')" 	,""						,1			,"��"		,""			,""				,"S"		,"S"		,""			,""				,""				,""												,""									,""				,""				,""				,".F."						,""					  			,""			,""				,"S"		})
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"02"		,u_SCGetCpo(ALIAS_DA_TABELA)+"_CDUSR"	,"C"		, 06						, 0							,"Usu�rio"		,""			,""			,"Usu�rio"				,""				,""				,"@!"					,"UsrExist(M->"+u_SCGetCpo(ALIAS_DA_TABELA)+"_CDUSR)"	,X3_USADO_EMUSO		,""	 		  						,"USR"					,1			,"��"		,""			,""				,"S"		,"S"		,""			,""				,"�"			,""												,""									,""				,""				,""				,".T."						,""					  			,""			,""				,"S"		})
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"03"		,u_SCGetCpo(ALIAS_DA_TABELA)+"_DSUSR"	,"C"		, 30						, 0							,"Nome"			,""			,""			,"Nome"					,""				,""				,"@!"					,""														,X3_USADO_EMUSO		,"" 								,""						,1			,"��"		,""			,""				,"S"		,"S"		,""			,""				,"�"			,""												,""									,""				,""				,""				,".T."						,""					  			,""			,""				,"S"		}) 
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"04"		,u_SCGetCpo(ALIAS_DA_TABELA)+"_BLCKED"	,"C"		, 1							, 0							,"Bloqueado"	,""			,""			,"Bloqueado"			,""				,""				,"@!"					,""														,X3_USADO_EMUSO		,"'2'" 								,""						,1			,"��"		,""			,""				,"S"		,"N"		,""			,""				,""				,""												,"1=Sim;2=N�o"						,""				,""				,""				,".T."						,""					  			,""			,""				,"S"		})
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"05"		,u_SCGetCpo(ALIAS_DA_TABELA)+"_ACESS"	,"C"		, 300						, 0							,"Acesso"		,""			,""			,"Acesso"				,""				,""				,"@!"					,""														,X3_USADO_EMUSO		,"" 								,ALIAS_DA_TABELA+"H"	,1			,"��"		,""			,""				,"S"		,"N"		,""			,""				,""				,""												,""									,""				,""				,""				,".T."						,""					  			,""			,""				,"S"		}) 
	aAdd( aSX3,	{ 	ALIAS_DA_TABELA		,"06"		,u_SCGetCpo(ALIAS_DA_TABELA)+"_CODGRP"	,"C"		, 300						, 0							,"Grupos"		,""			,""			,"Grupos"				,""				,""				,"@!"					,""														,X3_USADO_EMUSO		,"" 								,ALIAS_DA_TABELA+"I"	,1			,"��"		,""			,""				,"S"		,"N"		,""			,""				,""				,""												,""									,""				,""				,""				,".T."						,""					  			,""			,""				,"S"		}) 
			
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
	aEstrut:= {"INDICE"			,"ORDEM","CHAVE"												   						,"DESCRICAO"		,"DESCSPA"			,"DESCENG"			,"PROPRI"	,"F3"	,"NICKNAME","SHOWPESQ"}
	Aadd(aSIX,{ALIAS_DA_TABELA	,"1"	,u_SCGetCpo(ALIAS_DA_TABELA)+"_FILIAL+"+u_SCGetCpo(ALIAS_DA_TABELA)+"_CDUSR"	,"FILIAL+USUARIO"	,"FILIAL+USUARIO"	,"FILIAL+USUARIO"	,"S"		,""		,""})  
	Aadd(aSIX,{ALIAS_DA_TABELA	,"2"	,u_SCGetCpo(ALIAS_DA_TABELA)+"_FILIAL+"+u_SCGetCpo(ALIAS_DA_TABELA)+"_DSUSR"	,"FILIAL+NOME"		,"FILIAL+NOME"		,"FILIAL+NOME"		,"S"		,""		,""})  
		
	dbSelectArea("SIX")
	dbSetOrder(1)
	For i:= 1 To Len(aSIX)
		If !dbSeek(aSIX[i,1]+aSIX[i,2])
			RecLock("SIX",.T.)
		Else                  
			RecLock("SIX",.F.)
		EndIf
		For j:=1 To Len(aSIX[i])
			If FieldPos(aEstrut[j])>0
				FieldPut(FieldPos(aEstrut[j]),aSIX[i,j])
			EndIf
		Next j
		dbCommit()
		MsUnLock()
	Next i     
	
	//->> Cria��o do SXB -> Consulta Padr�o
	aEstrut:= {"XB_ALIAS"			,"XB_TIPO"	,"XB_SEQ"	,"XB_COLUNA"	,"XB_DESCRI"		,"XB_DESCSPA"		,"XB_DESCENG"		,"XB_CONTEM"		}
	Aadd(aSXB,{ALIAS_DA_TABELA+"H"	,"1"		,"01"		,"RE"			,"Acessos"			,"Acessos"			,"Acessos"			,ALIAS_DA_TABELA	})
	Aadd(aSXB,{ALIAS_DA_TABELA+"H"	,"2"		,"01"		,"01"			,""					,""					,""					,".T."				})
	Aadd(aSXB,{ALIAS_DA_TABELA+"H"	,"5"		,"01"		,""				,""					,""					,""					,"u_SCSELACES(,,'Acessos do SGSI','"+F3_ROTINA+"')"})
	
	Aadd(aSXB,{ALIAS_DA_TABELA+"I"	,"1"		,"01"		,"RE"			,"Setores"			,"Setores"			,"Setores"			,ALIAS_DA_TABELA	})
	Aadd(aSXB,{ALIAS_DA_TABELA+"I"	,"2"		,"01"		,"01"			,""					,""					,""					,".T."				})
	Aadd(aSXB,{ALIAS_DA_TABELA+"I"	,"5"		,"01"		,""				,""					,""					,""					,"u_SCSELGRUP(,,'Grupos de Atendimento do SGSI')"})
	
	
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
		For nX:=1 to Len(aSX2)	
			__SetX31Mode(.F.)
			If Select(aSX2[nX,1])>0
				dbSelecTArea(aSX2[nX,1])
				dbCloseArea()
			EndIf
			X31UpdTable(aSX2[nX,1])
			If __GetX31Error()
				If lUpdAuto    
					MsOpenDbf(.T.,"TOPCONN",cTabe+SM0->M0_CODIGO+"0",aSX2[nX,1],.T.,.F.,.F.,.F.)
				EndIf
			EndIf	
			dbSelectArea(aSX2[nX,1])
		Next nX
	EndIf
			
EndIf

RestArea(aArea)

Return 
    
/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �SCAtuSx5   � Autor � Marcelo Celi Marques � Data � 26/10/12 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Ajusta o SX5 com as instru��es dos acessos.                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Certisign                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function SCAtuSx5()      
Local aSX5 := {}

//->> Ajuste da Tabela SX5 de formatos de ativos                                             
aAdd(aSX5,{F3_ROTINA	,"1"+u_SCGetIdFu("CSATV1VIS")		,"Ativo ISO-27001 - Visualiza��o - Informa��o"		,"",""}) 
aAdd(aSX5,{F3_ROTINA	,"1"+u_SCGetIdFu("CSATV1INC")		,"Ativo ISO-27001 - Inclus�o     - Informa��o"		,"",""})
aAdd(aSX5,{F3_ROTINA	,"1"+u_SCGetIdFu("CSATV1ALT")		,"Ativo ISO-27001 - Altera��o    - Informa��o"		,"",""}) 
aAdd(aSX5,{F3_ROTINA	,"1"+u_SCGetIdFu("CSATV1EXC")		,"Ativo ISO-27001 - Exclus�o     - Informa��o"		,"",""}) 
aAdd(aSX5,{F3_ROTINA	,"1"+u_SCGetIdFu("CSATV1IMP")		,"Ativo ISO-27001 - Impress�o    - Informa��o"		,"",""}) 
                                                                                                            
aAdd(aSX5,{F3_ROTINA	,"2"+u_SCGetIdFu("CSATV1VIS")		,"Ativo ISO-27001 - Visualiza��o - Software"		,"",""}) 
aAdd(aSX5,{F3_ROTINA	,"2"+u_SCGetIdFu("CSATV1INC")		,"Ativo ISO-27001 - Inclus�o     - Software"		,"",""})
aAdd(aSX5,{F3_ROTINA	,"2"+u_SCGetIdFu("CSATV1ALT")		,"Ativo ISO-27001 - Altera��o    - Software"		,"",""})
aAdd(aSX5,{F3_ROTINA	,"2"+u_SCGetIdFu("CSATV1EXC")		,"Ativo ISO-27001 - Exclus�o     - Software"		,"",""})
aAdd(aSX5,{F3_ROTINA	,"2"+u_SCGetIdFu("CSATV1IMP")		,"Ativo ISO-27001 - Impress�o    - Software"		,"",""})

aAdd(aSX5,{F3_ROTINA	,"3"+u_SCGetIdFu("CSATV1VIS")		,"Ativo ISO-27001 - Visualiza��o - Fisico" 			,"",""}) 
aAdd(aSX5,{F3_ROTINA	,"3"+u_SCGetIdFu("CSATV1INC")		,"Ativo ISO-27001 - Inclus�o     - Fisico"			,"",""})
aAdd(aSX5,{F3_ROTINA	,"3"+u_SCGetIdFu("CSATV1ALT")		,"Ativo ISO-27001 - Altera��o    - Fisico"			,"",""})
aAdd(aSX5,{F3_ROTINA	,"3"+u_SCGetIdFu("CSATV1EXC")		,"Ativo ISO-27001 - Exclus�o     - Fisico"			,"",""})
aAdd(aSX5,{F3_ROTINA	,"3"+u_SCGetIdFu("CSATV1IMP")		,"Ativo ISO-27001 - Impress�o    - Fisico"			,"",""}) 

aAdd(aSX5,{F3_ROTINA	,"4"+u_SCGetIdFu("CSATV1VIS")		,"Ativo ISO-27001 - Visualiza��o - Servi�o"			,"",""}) 
aAdd(aSX5,{F3_ROTINA	,"4"+u_SCGetIdFu("CSATV1INC")		,"Ativo ISO-27001 - Inclus�o     - Servi�o"			,"",""})
aAdd(aSX5,{F3_ROTINA	,"4"+u_SCGetIdFu("CSATV1ALT")		,"Ativo ISO-27001 - Altera��o    - Servi�o"			,"",""})
aAdd(aSX5,{F3_ROTINA	,"4"+u_SCGetIdFu("CSATV1EXC")		,"Ativo ISO-27001 - Exclus�o     - Servi�o"			,"",""})
aAdd(aSX5,{F3_ROTINA	,"4"+u_SCGetIdFu("CSATV1IMP")		,"Ativo ISO-27001 - Impress�o    - Servi�o"			,"",""}) 

aAdd(aSX5,{F3_ROTINA	,"5"+u_SCGetIdFu("CSATV1VIS")		,"Ativo ISO-27001 - Visualiza��o - Intang�vel"		,"",""}) 
aAdd(aSX5,{F3_ROTINA	,"5"+u_SCGetIdFu("CSATV1INC")		,"Ativo ISO-27001 - Inclus�o     - Intang�vel"		,"",""})
aAdd(aSX5,{F3_ROTINA	,"5"+u_SCGetIdFu("CSATV1ALT")		,"Ativo ISO-27001 - Altera��o    - Intang�vel"		,"",""})
aAdd(aSX5,{F3_ROTINA	,"5"+u_SCGetIdFu("CSATV1EXC")		,"Ativo ISO-27001 - Exclus�o     - Intang�vel"		,"",""})
aAdd(aSX5,{F3_ROTINA	,"5"+u_SCGetIdFu("CSATV1IMP")		,"Ativo ISO-27001 - Impress�o    - Intang�vel"		,"",""})

aAdd(aSX5,{F3_ROTINA	,"6"+u_SCGetIdFu("CSATV1VIS")		,"Ativo ISO-27001 - Visualiza��o - Pessoas"			,"",""}) 
aAdd(aSX5,{F3_ROTINA	,"6"+u_SCGetIdFu("CSATV1INC")		,"Ativo ISO-27001 - Inclus�o     - Pessoas"			,"",""})                                                                                                 
aAdd(aSX5,{F3_ROTINA	,"6"+u_SCGetIdFu("CSATV1ALT")		,"Ativo ISO-27001 - Altera��o    - Pessoas"			,"",""})
aAdd(aSX5,{F3_ROTINA	,"6"+u_SCGetIdFu("CSATV1EXC")		,"Ativo ISO-27001 - Exclus�o     - Pessoas"			,"",""})
aAdd(aSX5,{F3_ROTINA	,"6"+u_SCGetIdFu("CSATV1IMP")		,"Ativo ISO-27001 - Impress�o    - Pessoas"			,"",""})

aAdd(aSX5,{F3_ROTINA	,+u_SCGetIdFu("CSISO27M1","RD0")	,"Participantes       - ISO27001"					,"",""}) 
aAdd(aSX5,{F3_ROTINA	,+u_SCGetIdFu("CSISO27M1","CN9")	,"Gest�o de Contratos - ISO27001"					,"",""})
aAdd(aSX5,{F3_ROTINA	,+u_SCGetIdFu("CSISO27M1","U00")	,"Hardwares           - ISO27001"					,"",""})
aAdd(aSX5,{F3_ROTINA	,+u_SCGetIdFu("CSISO27M1","U04")	,"Softwares           - ISO27001"					,"",""})
                                        
aAdd(aSX5,{F3_ROTINA	,+u_SCGetIdFu("CSPF3HARD")			,"Busca F3 Hardware"								,"",""}) 
aAdd(aSX5,{F3_ROTINA	,+u_SCGetIdFu("CSPF3SOFT")			,"Busca F3 Software"								,"",""})
aAdd(aSX5,{F3_ROTINA	,+u_SCGetIdFu("CSPF3CONT")			,"Busca F3 Contratos"								,"",""})
aAdd(aSX5,{F3_ROTINA	,+u_SCGetIdFu("CSPF3PESS")			,"Busca F3 Pessoas"									,"",""})
		
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
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �CanUseRot  � Autor � Marcelo Celi Marques � Data � 18/10/12 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Retorna se a rotina pode ser utilizada ou rodar compatibiliz���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Certisign                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function CanUseRot()    
Local aPRW 	:= GetAPOInfo("CSUSRSGSI.prw")
Local lRet 	:= .T. 
Local dData := DATA_DO_COMPATIBILIZADOR      
           
SX3->(dbSetOrder(1))
If !SX3->(dbSeek(ALIAS_DA_TABELA)) .Or. aPRW[4] < dData
	lRet := .F.
EndIf

Return lRet

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �CSUSGSLEG  � Autor � Marcelo Celi Marques � Data � 26/10/12 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Legenda.							                          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Certisign                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function CSUSGSLEG(cAlias,nReg)
Local uRetorno := .T.
Local aLegenda := {	{"ENABLE"		, 	"Ativo"			},;	    
				   	{"DISABLE"		, 	"Bloqueado"		}}	   	

If nReg = Nil	
	uRetorno := {}
	Aadd(uRetorno, {u_SCGetCpo(ALIAS_DA_TABELA)+"_BLCKED <> '1' "		, aLegenda[1][1]})  
	Aadd(uRetorno, {u_SCGetCpo(ALIAS_DA_TABELA)+"_BLCKED == '1' "		, aLegenda[2][1]})  
Else
	BrwLegenda(cCadastro,"Legenda",aLegenda) 
Endif

Return uRetorno

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MenuDef    � Autor � Marcelo Celi Marques � Data � 26/10/12 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Opcoes no Menu.	     			                          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Certisign                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MenuDef()
Private aRotina := { {"Pesquisar"	, "AxPesqui"  	,0,1,0	,.F.},;  
					 {"Visualizar"	, "u_CSATV1VIS"	,0,2,0	,nil},;  
					 {"Incluir"		, "u_CSUSGSINC"	,0,3,81	,nil},; 
					 {"Alterar"		, "u_CSUSGSALT"	,0,4,3	,nil},;
					 {"Excluir"		, "u_CSUSGSEXC"	,0,5,81	,nil},;  
					 {"Legenda"		, "u_CSUSGSLEG" ,0,2, 	,.F.}}					 					 

Return(aRotina) 
                              
/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �CSUSGSVIS  � Autor � Marcelo Celi Marques � Data � 26/10/12 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Visualizacao. 	     			                          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Certisign                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function CSUSGSVIS(cAlias,nReg,nOpc)                                 
Local aButtons := {}      
Return(AxVisual(cAlias,nReg,nOpc,aCpos,,,,aButtons,))

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �CSUSGSINC  � Autor � Marcelo Celi Marques � Data � 26/10/12 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Inclusao.     	     			                          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Certisign                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function CSUSGSINC(cAlias,nReg,nOpc)                                 
Local 	aButtons 	:= {}

Begin Transaction
	AxInclui(cAlias,nReg,nOpc,,,,,,,aButtons)		
End Transaction
	
dbSelectArea(cAlias)

Return

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �CSUSGSALT  � Autor � Marcelo Celi Marques � Data � 26/10/12 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Alteracao.    	     			                          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Certisign                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/                                    
User Function CSUSGSALT(cAlias,nReg,nOpc)                                 
Local aButtons := {}

Begin Transaction
	AxAltera(cAlias,nReg,nOpc,,,,,,,,aButtons)	
End Transaction

dbSelectArea(cAlias)

Return

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �CSUSGSEXC  � Autor � Marcelo Celi Marques � Data � 26/10/12 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Exclusao.     	     			                          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Certisign                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function CSUSGSEXC(cAlias,nReg,nOpc)                                 
Local aButtons := {}

dbSelectArea(cAlias)
Begin Transaction	
	AxDeleta(cAlias,nReg,nOpc,,,aButtons,,,.T.)	
End Transaction
dbSelectArea(cAlias)
	
Return

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �SCSGSIUse  � Autor � Marcelo Celi Marques � Data � 26/10/12 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Retorna se usuario esta devidamente configurado no cadastro ��� 
���          �de operadores do SGSI e se tem acesso de operar a rotina.	  ��� 
�������������������������������������������������������������������������Ĵ��
��� Uso      � Certisign                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function SCSGSIUse(cRotina)                                 
Local lRet 	:= .T.
Local cUser := RetCodUsr()

(ALIAS_DA_TABELA)->(dbSetOrder(1)) 
If 	!(ALIAS_DA_TABELA)->(dbSeek(xFilial(ALIAS_DA_TABELA)+cUser)) .Or.;
	 (ALIAS_DA_TABELA)->&(u_SCGetCpo(ALIAS_DA_TABELA)+"_BLCKED")=="1" .Or.;
	 !(cRotina $ (ALIAS_DA_TABELA)->&(u_SCGetCpo(ALIAS_DA_TABELA)+"_ACESS"))
     lRet:=.F.
EndIf
	
Return lRet

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �SCSGSIGRP  � Autor � Marcelo Celi Marques � Data � 15/02/13 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Retorna os grupos de usuarios que o operador pode visualizar��� 
���          �no SGSI.													  ��� 
�������������������������������������������������������������������������Ĵ��
��� Uso      � Certisign                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function SCSGSIGRP()                                 
Local cRet  := ""
Local cUser := RetCodUsr()

(ALIAS_DA_TABELA)->(dbSetOrder(1)) 
If 	(ALIAS_DA_TABELA)->(dbSeek(xFilial(ALIAS_DA_TABELA)+cUser)) 
	cRet := Alltrim((ALIAS_DA_TABELA)->&(u_SCGetCpo(ALIAS_DA_TABELA)+"_CODGRP")) 
EndIf
	
Return cRet

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �SCSELACES  � Autor � Marcelo Celi Marques � Data � 29/10/12 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Retorna os acessos para serem configurados no cadastro de   ��� 
���          �operadores do SGSI.	 									  ��� 
�������������������������������������������������������������������������Ĵ��
��� Uso      � Certisign                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function SCSELACES(l1Elem,lTipoRet,cTitulo,cX5Tabela)
Local MvPar   	:= 	m->&(u_SCGetCpo(ALIAS_DA_TABELA)+"_ACESS")
Local MvParDef 	:=	""
Local aDados 	:= 	{} 
Local aArea		:= 	GetArea()
Local cString	:= 	""
      
lTipoRet := .T.
l1Elem := IF (l1Elem = NIL, .f., .T.)

SX5->(dbSetOrder(1))
SX5->(dbSeek(xFilial("SX5")+cX5Tabela))
CursorWait()
While !SX5->(Eof()) .And. cX5Tabela == SX5->X5_TABELA
	AADD(aDados,SX5->X5_CHAVE+" - "+SX5->X5_DESCRI)
	MvParDef += Padr(Alltrim(SX5->X5_CHAVE)+"|",3)		 
	SX5->(DbSkip())
Enddo
CursorArrow()

If lTipoRet
	f_opcoes(@MvPar,cTitulo,aDados,MvParDef,Nil,Nil,l1Elem,3,len(aDados))	
Endif 

MvPar := StrTran(MvPar,'*','')
RestArea(aArea)  

Return MvPar

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �SCSELGRUP  � Autor � Marcelo Celi Marques � Data � 15/01/13 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Retorna os grupos para serem configurados no cadastro de    ��� 
���          �operadores do SGSI.	 									  ��� 
�������������������������������������������������������������������������Ĵ��
��� Uso      � Certisign                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function SCSELGRUP(l1Elem,lTipoRet,cTitulo)
Local MvPar   	:= 	m->&(u_SCGetCpo(ALIAS_DA_TABELA)+"_CODGRP") 
Local MvParDef 	:=	""
Local aDados 	:= 	{} 
Local aArea		:= 	GetArea()
Local cString	:= 	""
      
lTipoRet := .T.
l1Elem := IF (l1Elem = NIL, .f., .T.)

U07->(dbSetOrder(1))
U07->(dbSeek(xFilial("U07")))
CursorWait()
While !U07->(Eof()) .And. U07->U07_FILIAL == xFilial("U07")
	AADD(aDados,U07->U07_CODGRU+" - "+U07->U07_DESGRU)
	MvParDef += Padr(Alltrim(U07->U07_CODGRU)+"|",Tamsx3("U07_CODGRU")[1]+1)		 
	U07->(DbSkip())
Enddo
CursorArrow()

If lTipoRet
	f_opcoes(@MvPar,cTitulo,aDados,MvParDef,Nil,Nil,l1Elem,Tamsx3("U07_CODGRU")[1]+1,len(aDados))	
Endif 

MvPar := StrTran(MvPar,'*','')
RestArea(aArea)  

Return MvPar
		
/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �SCGetIdFu  � Autor � Marcelo Celi Marques � Data � 29/10/12 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Retorna o ID da Funcao.								      ��� 
�������������������������������������������������������������������������Ĵ��
��� Uso      � Certisign                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/                                                                                                    
User Function SCGetIdFu(cRot,cCompl)
Local aFuncoes 	:= {}               
Local nPos		:= 0
Local cRet		:= ""

Default cRot	:= ""
Default cCompl	:= ""

aAdd(aFuncoes,{"CSATV1VIS",""	,"0"	}) 
aAdd(aFuncoes,{"CSATV1INC",""	,"1"	}) 
aAdd(aFuncoes,{"CSATV1ALT",""	,"2"	})
aAdd(aFuncoes,{"CSATV1EXC",""	,"3"	})
aAdd(aFuncoes,{"CSATV1IMP",""	,"4"	})
aAdd(aFuncoes,{"CSISO27M1","RD0","CP"	})
aAdd(aFuncoes,{"CSISO27M1","CN9","CC"	})
aAdd(aFuncoes,{"CSISO27M1","U00","CH"	}) 
aAdd(aFuncoes,{"CSISO27M1","U04","CS"	})
aAdd(aFuncoes,{"CSPF3HARD",""	,"FH"	})
aAdd(aFuncoes,{"CSPF3SOFT",""	,"FS"	}) 
aAdd(aFuncoes,{"CSPF3CONT",""	,"FC"	})
aAdd(aFuncoes,{"CSPF3PESS",""	,"FP"	})

nPos := Ascan(aFuncoes,{|x| Alltrim(Upper(x[1]))==Alltrim(Upper(cRot)) .And. Alltrim(Upper(x[2]))==Alltrim(Upper(cCompl)) } )
If nPos>0 
	cRet := aFuncoes[nPos,3]
EndIf

Return cRet
