#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CCDDPARA  ºAutor  ³Henio Brasil        º Data ³  09/04/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cadastro de De-Para Produtos BPag x Protheus 8              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³CertiSign Certificados                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CCDDPARA()

Private cCadastro 	:= OemToAnsi("De-Para de Produtos do BPAG ")
Private lExportXml	:= .F.

Private aRotina := { {"Pesquisar"			,"AxPesqui"		,0,1} ,;
		             {"Visualizar"			,"AxVisual"		,0,2} ,;
		             {"Incluir"				,"U_CCDDPAR5"	,0,3} ,;
		             {"Alterar"	   			,"U_CCDDPAR1"	,0,4} ,;
		             {"Excluir"				,"U_CCDDPAR3"	,0,5} ,;
		             {"Prod. s/ cat. rem."	,"U_CRPR020"	,0,6} ,;
		             {"Parametros Checkout","U_CSTA130P"	,0,7} ,;
		             {"Exportar Produtos"	,"U_CRPA053"	,0,8} ,;
		             {"Importar Produtos"	,"U_CRPA053I"	,0,9}}

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cString := "PA8"


dbSelectArea("PA8")
dbSetOrder(1)

//Renato Ruy - 14/09/16
//Alterada funcao para MBrowse para facilitar manutenção.
dbSelectArea(cString)

SetKey( VK_F12 , {|| lExportXml := MsgYesNo('Exportar o XML de envio?',cCadastro ) } )

mBrowse( 6,1,22,75,cString)

FWSetShowKeys(.T.)
SetKey( VK_F12 , Nil )

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CCDDPAR1  ºAutor  ³Renato Ruy		     º Data ³  14/09/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Recalculo na alteração						              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³CertiSign Certificados                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/      
User Function CCDDPAR1()

Local aCpos 	:= {}
Local nAltera	:= 0
Local nContar	:= 0
Local aPedidos	:= {}
Local cPeriodo	:= ""
Local cClass	:= PA8->PA8_CATPRO
Local cConect	:= PA8->PA8_PRDCON

SX3->(DbSetOrder(1))
SX3->(DbSeek(cString))

While !SX3->(EOF()) .And. SX3->X3_ARQUIVO == cString
    
    If X3Uso(SX3->X3_USADO) .And. SX3->X3_CONTEXT <> 'V'
		AADD(aCpos,SX3->X3_CAMPO)
	Endif
	
	SX3->(DbSkip())
Enddo

nAltera := AxAltera(cString,; 		// Parametro 1 - Alias da tabela
					PA8->(Recno()),;// Parametro 2 - Recno que sera alterado
					4,			   ;// Parametro 3 - Seta como alteração a rotina
					 ,			   ;// Parametro 4
					aCpos,		   ;// Parametro 5 - Campos que serao exibidos
					 ,			   ;// Parametro 6
					 ,			   ;// Parametro 7
					"U_CSTA060(PA8->PA8_CODMP8, PA8->PA8_CODBPG, 'A', PA8->PA8_DESBPG, , PA8->PA8_JPGPEQ, PA8->PA8_JPGMED, PA8->PA8_JPGGRA, PA8->(Recno()), lExportXml)") // Parametro 8 - Valida comunicacao HUB

//Renato Ruy - 26/09/2016
//Efetua recalculo na alteracao.
If cClass != PA8->PA8_CATPRO .Or. cConect <> PA8->PA8_PRDCON
	
	//Envia para processamento em background.
	StartJob("U_CCDDPAR2",GetEnvServer(),.F.,PA8->PA8_CODBPG,cUserName)	
	
EndIf

Return

//Renato Ruy - 14/02/17
//Efetua recalculo em background sempre que alterado sem perguntar para o usuario.
User Function CCDDPAR2(cProduto,cUsrNome)

Local aPedidos := {}

//Abre a conexão com a empresa
RpcSetType(3)
RpcSetEnv("01","02")

//Busca os pedidos que 
If Select("CCDPAR") > 0
	DbSelectArea("CCDPAR")
	CCDPAR->(DbCloseArea())
EndIf

BeginSql Alias "CCDPAR"
		
	SELECT Z6_PEDGAR PEDGAR 
	From %Table:SZ6% SZ6
	Where
	Z6_Filial = %xFilial:SZ6%
	And Z6_PERIODO = %Exp:AllTrim(getmv("MV_REMMES"))%
	And Z6_TIPO IN ('VERIFI','RENOVA')
	And Z6_PRODUTO = %Exp:cProduto%
	And D_E_L_E_T_ = ' '
	Group by Z6_PEDGAR
	
EndSql

DbSelectArea("CCDPAR")
CCDPAR->(DbGoTop())

While !CCDPAR->(EOF())
	
	SZ5->(DbSetOrder(1))
	If SZ5->(DbSeek(xFilial("SZ5")+CCDPAR->PEDGAR))
		//Grava o Tipo 7 que foi alterado cadastro e o campo alterado.
		RecLock("SZ5",.F.)
			SZ5->Z5_COMISS := "7"
			SZ5->Z5_OBSCOM := Iif("Z3" $ SZ5->Z5_OBSCOM,AllTrim(SZ5->Z5_OBSCOM)+"PA8_CODBPG","PA8_CODBPG")
		SZ5->(MsUnlock())
	EndIf
	
	CCDPAR->(DbSkip())
Enddo


//Busca os pedidos que serao calculados
If Select("COMAON") > 0
	DbSelectArea("COMAON")
	COMAON->(DbCloseArea())
EndIf

//Renato Ruy - 23/09/2016
//Mes atual em aberto no parametro MV_REMMES - ate dia 07 e mes futuro de calculo sempre.		
cPeriodo := "% And Z6_PERIODO = '"+Iif(SubStr(getmv("MV_REMMES"),5,2)=="12",Soma1(SubStr(getmv("MV_REMMES"),1,4))+"01",Soma1(getmv("MV_REMMES")))+"' %"

BeginSql Alias "COMAON"
		
	SELECT Z6_PERIODO, Z6_PEDGAR 
	From %Table:SZ6% SZ6
	Where
	Z6_Filial = %xFilial:SZ6%
	%Exp:cPeriodo%
	And Z6_TIPO IN ('VERIFI','RENOVA')
	And Z6_PRODUTO = %Exp:cProduto%
	And D_E_L_E_T_ = ' '
	Group by Z6_PERIODO, Z6_PEDGAR
	
EndSql

DbSelectArea("COMAON")
COMAON->(DbGoTop())

While !COMAON->(EOF())
	
	SZ5->(DbSetOrder(1))
	If SZ5->(DbSeek(xFilial("SZ5")+COMAON->Z6_PEDGAR))
	
		Aadd(aPedidos,{SZ5->(Recno()),COMAON->Z6_PERIODO})
	
	EndIf
	
	COMAON->(DbSkip())
Enddo

//Envio o conteúdo para Thread se o array for maior que um e terceiro parametro true para aguardar recalculo.
If Len(aPedidos) > 0
	StartJob("U_CRPA020B",GetEnvServer(),.T.,'01','02',aPedidos,"COMAON",cUsrNome)
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CCDDPAR3  ºAutor  ³Renato Ruy		     º Data ³  05/04/17	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Exclusão de De-Para							              º±±
±±º          ³Valida se ja tem item vinculado na tabela de preços         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³CertiSign Certificados                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/      
User Function CCDDPAR3()

Local cTable := " "
Local nCount := 0
Local nExclui:= 0

//Verifica se o produto tem vinculo na tabela de preço antes de excluir
If Select("TMPVIN") > 0
	DbSelectArea("TMPVIN")
	TMPVIN->(DbCloseArea())
Endif

Beginsql Alias "TMPVIN"
	SELECT DA1_CODTAB FROM %Table:DA1%
	WHERE
	DA1_FILIAL = %xFilial:DA1% AND
	DA1_CODGAR = %Exp:PA8->PA8_CODBPG% AND
	DA1_CODPRO = %Exp:PA8->PA8_CODMP8% AND
	%NOTDEL%
	GROUP BY DA1_CODTAB
Endsql

While !TMPVIN->(EOF())
	nCount += 1
	cTable += Iif(Empty(cTable),"",", ")+TMPVIN->DA1_CODTAB 
	TMPVIN->(DbSkip())
Enddo

If nCount == 0
	nExclui := AxDeleta(cString,PA8->(Recno()), 5, , , ,; 
	{{||.T.},{||U_CSTA060(PA8->PA8_CODMP8, PA8->PA8_CODBPG, "E", PA8->PA8_DESBPG, , PA8->PA8_JPGPEQ, PA8->PA8_JPGMED, PA8->PA8_JPGGRA, PA8->(Recno()), lExportXml)},{||.T.},{||.T.}})
Else
	Alert("O Produto não pode ser excluido!"+chr(13)+ chr(10) +"Está vinculado a " + AllTrim(Str(nCount)) + " tabela(s) - ("+ cTable +") de preço!")
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CCDDPAR4  ºAutor  ³Renato Ruy		     º Data ³  05/04/17	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Validação de campo para não permitir incluir itens duplicadoº±±
±±º          ³													          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³CertiSign Certificados                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/      
User Function CCDDPAR4()

Local lRet := .T.

//Verifica se o vinculo ja existe
If Select("TMPDUP") > 0 
	DbSelectArea("TMPDUP")
	TMPDUP->(DbCloseArea())
Endif

//Valida se tem caractere especial no campo
lRet := U_ExisteCaracEspecial( M->PA8_CODBPG , .T.)[1]

Beginsql Alias "TMPDUP"
	SELECT COUNT(*) CONTAGEM FROM %Table:PA8%
	WHERE
	PA8_FILIAL = %xFilial:PA8% AND
	PA8_CODBPG = %Exp:M->PA8_CODBPG% AND
	PA8_CODMP8 = %Exp:M->PA8_CODMP8% AND
	%NOTDEL%
Endsql

If TMPDUP->CONTAGEM > 0
	Alert("O cadastro já foi realizado anteriormente!")
	lRet := .F.
Endif


Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CCDDPAR5  ºAutor  ³Renato Ruy		     º Data ³  14/09/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de inclusão de produto e chama notifica HUB         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³CertiSign Certificados                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/      
User Function CCDDPAR5()

Local aCpos 	:= {}
Local nInclui	:= 0

SX3->(DbSetOrder(1))
SX3->(DbSeek(cString))

While !SX3->(EOF()) .And. SX3->X3_ARQUIVO == cString
    
    If X3Uso(SX3->X3_USADO) .And. SX3->X3_CONTEXT <> 'V'
		AADD(aCpos,SX3->X3_CAMPO)
	Endif
	
	SX3->(DbSkip())
Enddo

nInclui := AxInclui(cString,; 		// Parametro 1 - Alias da tabela
						  ,;		// Parametro 2 - Recno que sera incluido
					3,			   ;// Parametro 3 - Seta como inclusão a rotina
					 ,			   ;// Parametro 4
					 ,		   	   ;// Parametro 5 - Campos que serao exibidos
					 ,			   ;// Parametro 6
					"U_CSTA060(M->PA8_CODMP8, M->PA8_CODBPG, 'A', M->PA8_DESBPG, , M->PA8_JPGPEQ, M->PA8_JPGMED, M->PA8_JPGGRA, PA8->(Recno()), lExportXml, .T.)") // Parametro 7 - Valida comunicacao HUB

Return