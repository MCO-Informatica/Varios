#INCLUDE "MATA120.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FWADAPTEREAI.CH"
/*/{Protheus.doc} TWFUN01
//TODO Valida??o do Produto informado com rela??o ao grupo de produtos, apenas produtos do grupo podem ser adicionados a SC.
@author Pirolo
@since 30/06/2020
@return return, return_description
/*/
User Function TWFUN01()
Local lRet 		:= .T.

If Empty(cGrp)
	Alert("Grupo de produtos n?o informado no cabe?alho, verifique.")
	lRet := .F.
Else
	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	
	//Valida se o grupo informado existe
	If !SB1->(DbSeek(xFilial("SB1")+&(ReadVar())) .AND. cGrp == B1_GRUPO) 
		lRet := .F.
		Alert("Grupo de produto informado n?o existe, verifique.")
	EndIf

EndIf

Return lRet

/*/{Protheus.doc} TWFUN01A
//TODO Valida??o do Grupo de Produtos no cabe?alho da SC.
@author Pirolo
@since 30/06/2020
@return return, return_description
/*/
User Function TWFUN01A()
Local lRet	:= .T.
Local nI	:= 0
Local nPosPrd	:= aScan(aHeader,{|x| AllTrim(x[2])=="C1_PRODUTO"})

If Empty(cGrp)
	Alert("? obrigat?ria a indica??o de um grupo de produtos.")
	lRet := .F.
EndIf

If SBM->(DbSeek(xFilial("SBM")+cGrp))
	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	
	//Verifica se os produtos do acols pertencem ao grupo informado
	For nI := 1 to Len(aCols)
		//Se o campo produto estiver preenchido e a linha n?o deletada
		If !Empty(aCols[nI, nPosPrd]) .AND. !aCols[nI, len(aCols[nI])]
			
			//Pesquisa o produto e verifica se corresponde ao mesmo grupo.
			If SB1->(DbSeek(xFilial("SB1")+aCols[nI, nPosPrd])) .AND. SB1->B1_GRUPO <> SBM->BM_GRUPO
				Alert("O produto "+AllTrim(aCols[nI, nPosPrd])+" (linha "+AllTrim(AllToChar(nI))+") n?o pertence ao grupo informado, remova os produtos antes de alterar grupo da Solicita??o.")
				lRet := .F.
				exit
			EndIf
			
		EndIf
	Next nI
Else
	lRet := .F.
	Alert("Grupo de produto informado n?o existe, verifique.")
EndIf

If lRet
	DbSelectArea("PA0")
	PA0->(DbSetOrder(1))
	
	If PA0->(DbSeek(xFilial("PA0")+cGrp))
		cCodCompr := PA0->PA0_CODCOM
	Else
		Alert("N?o existe comprador associado a este grupo de produtos, entre em contato com o departamento de Compras.")
		lRet := .F.
	EndIf
EndIf

Return lRet

/*/{Protheus.doc} TWFUN01B
//TODO Cadastro de amarra??o de Vendedor x Produto.
@author Pirolo
@since 23/06/2020
@return return, return_description
/*/
User Function TWFUN01B()

AXCADASTROS("PA0","Amarra??o Comprador x Grupo")

Return

/*/{Protheus.doc} TWFUN01C
//TODO Valida??o para evitar duplicidade na tabela PA0.
@author Pirolo
@since 23/06/2020
@return return, return_description
/*/
User Function TWFUN01C()
Local aAreaPA0	:= PA0->(GetArea())
Local nRecn		:= PA0->(Recno())
Local lRet		:= .T.

DbSelectArea("PA0")
PA0->(DbSetOrder(1))

If PA0->(DbSeek(xFilial("PA0")+M->PA0_GRUPO)) .AND. (inclui .OR. (altera .AND. nRecn <> PA0->(Recno())))
	lRet := .F.
	Alert("Grupo j? possui um vendedor associado.")
EndIf

RestArea(aAreaPA0)
Return lRet

/*/{Protheus.doc} User Function TWFUN01D
    (Altera o comprador de uma SC)
    @type  Function
    @author Pirolo
    @since 08/03/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function TWFUN01D()
Local cCodComp  := "   "
Local aAreaSC1  := SC1->(GetArea())
Local cNumSC    := SC1->(C1_FILIAL+C1_NUM)
Local aPergs	:= {}

aAdd(aPergs, {1, "C?d Comprador", cCodComp,  "", ".T.", "SY1", ".T.", 03,  .T.})

If ParamBox(aPergs ,"Migrar comprador")
    If SC1->(DbSeek(cNumSC))
        While SC1->(!Eof() .AND. cNumSC == SC1->(C1_FILIAL+C1_NUM))
            RecLock("SC1", .F.)
                SC1->C1_CODCOMP := MV_PAR01
			SC1->(MsUnlock())
			
			SC1->(DbSkip())
        EndDo
    EndIf
EndIf

RestArea(aAreaSC1)
Return

/*/{Protheus.doc} User Function TWFUN01E
	(long_description)
	@type  Function
	@author user
	@since 09/03/2021
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
User Function TWFUN01E()
Local dDtEmiss  := Date()
Local aAreaSC1  := SC1->(GetArea())
Local aPergs	:= {}
LOCAL bCondic := Nil

aAdd(aPergs, {1, "Data Aprova??o",  dDtEmiss	,  "", ".T.", ""	, ".T.", 80,  .T.})

If ParamBox(aPergs ,"Aprovar todas SCs")

	SC1->(dbSetFilter({ || C1_EMISSAO == MV_PAR01 .AND. C1_APROV == 'B' }, "C1_EMISSAO == MV_PAR01 .AND. C1_APROV == 'B' " ))
	SC1->(dbGoTop())

	While SC1->(!Eof() .AND. SC1->C1_EMISSAO == MV_PAR01)
		
		If Empty(SC1->C1_COTACAO) .AND. SC1->(C1_APROV == 'B' .AND. C1_QUJE == 0) 
			RecLock("SC1", .F.)
				SC1->C1_APROV := 'L' 
			SC1->(MsUnlock())
		EndIf
		
		SC1->(DbSkip())
	EndDo

	SC1->(DBClearFilter())

EndIf

RestArea(aAreaSC1)
Return

/*/{Protheus.doc} TWFUN01F
	(Valid do campo F1_XMLDOC que valida a exist?ncia do arquivo xml no servidor e grava na pasta)
	@type  Function
	@author Bruno Pirolo
	@since 11/01/2021
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
User Function TWFUN01F()
Local lRet 		:= .T.
Local cFile 	:= cGetFile( "*.XML|*.XML" , "Abrir arquivo", 0, "c:\temp", .F., , .T., .T.)
Local cNomeArq	:= Iif(!Empty(cFile), STRTOKARR(cFile, "\")[len(STRTOKARR(cFile, "\"))], "")
Local cDirServ	:= "\XML_NF_Entrada\"
Private cXMLDOC	:= ""

If Empty(cFile)
	lRet := .F.
	MsgInfo("O anexo do XML da NF ? obrigat?rio para o processo de entrada.", "XML obrigat?rio.")
EndIf

If lRet .AND. File(cFile)
	If Upper(Substring(cFile, 1, Len(cDirServ))) <> UPPER(cDirServ)
		Conout("Subir para o servidor")

		//Verifica se o arquivo j? existe no servidor
		If !File(cDirServ+cNomeArq)
			If CpyT2S( cFile, cDirServ )
				cXMLDOC := cDirServ+cNomeArq
			Else
				MsgInfo("Erro ao copiar arquivo XML para o servidor, verifique ou entre em contato com a TI.")
						EndIf
		EndIf
	Else
		Conout("Arquivo j? consta no servidor")
	EndIf
Else
	MsgInfo("Erro ao abrir o arquivo XML, vrifique.")
	lRet := .F.
EndIf

Return lRet

/*/{Protheus.doc} User Function A120Track
	(Montagem da chamada da tela Tracker do Mata120)
	@type  Function
	@author Pirolo
	@since 22/03/2021
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
User Function A120Track()

Local aEnt     		:= {}
Local cPed     		:= SC7->C7_NUM
Local cFilPed		:= SC7->C7_FILIAL
Local nLoop    		:= 0
Local cFilialEnt 	:= SC7->C7_FILENT

//?????????????????????????????????????????????Ŀ
//?Inicializa a funcao fiscal                   ?
//???????????????????????????????????????????????
SC7->(DbSetOrder(1))
SC7->(DbSeek(cFilPed+cPed))

While SC7->(!Eof() .AND. C7_FILIAL == cFilPed .AND. C7_NUM == cPed)
	AAdd( aEnt, { "SC7", Iif(cFilialEnt <> xFilial("SC7") , cFilialEnt , xFilial("SC7")) + SC7->C7_NUM + SC7->C7_ITEM } )
	SC7->(DbSkip())
EndDo

Processa( { || MaFisSave() }, 'Carregando dados' )
Processa( { || MaFisEnd() }, 'Limpando variaveis' )

MaTrkShow( aEnt )

Processa( { || MaFisRestore() }, 'Restaurando Dados' )


Return( .T. )

/*/{Protheus.doc} User Function TWFUN01G
	(long_description)
	@type  Function
	@author user
	@since 23/06/2021
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
User Function TWFUN01G()
Local aAreaSC7 := SC7->(GetArea())
Local aAreaSC1 := SC1->(GetArea())
Private l120Auto:= .F.
Private nTipoPed:= 1

If !Empty(SC1->C1_PEDIDO)
	DbSelectArea("SC7")
	SC7->(DbSetOrder(1))

	If SC7->(DbSeek(SC1->(C1_FILIAL+C1_PEDIDO)))
		A120Pedido("SC7",SC7->(RecNo()),2,,.F.,.F.)
	Else
		MsgInfo("Pedido n?o localizado.", "Visualizar pedido")
	EndIf
Else
	MsgInfo("Solicita??o sem Pedido gerado.", "Visualizar pedido")
EndIf

RestArea(aAreaSC7)
RestArea(aAreaSC1)
Return 
