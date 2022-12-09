#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
#Include "Protheus.Ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณOpcionais บAutor  ณMateus Hengle       บ Data ณ  16/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Mostra a Tela de opcionais							      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico modulo CRM			                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/   
User Function OPCIONAIS() 
Local cFiltro  		:= ""
Local cKey     		:= ""
Local cArq     		:= ""
Local nIndex   		:= 0
Local aSay   	    := {}
Local aButton 	    := {}
Local nOpcao  		:= 0
Local aCpos   		:= {}
Local aCampos	 	:= {}
Local nI       		:= 0
Private aRotina     := {}
Private cMarca      := ""
Private cCadastro   := "GRUPO DE OPCIONAIS"
Private cRetorno    := ""
Private cOpcional   := " "
Private cGruOPC     := " " 

Private aColsAux := {} 

Private nPosProd := ASCAN(aHeader, {|aVal| Alltrim(aVal[2]) == "UB_PRODUTO"}) 

cProd00	:= aCols[n,nPosProd]  // PEGA O PRODUTO

cRetorno := U_SelOpc()
Return cRetorno

/*


// QUERY PRA VER SE EXISTE OPCIONAL PRA ESTE PRODUTO E PRA VERIFICAR SE EH CABO
cQry9:= " SELECT G1_OPC, G1_GROPC" // GA_DESCOPC
cQry9+= " FROM "+RETSQLNAME("SG1")+" SG1"
//cQry9+= " INNER JOIN "+RETSQLNAME("SGA")+" SGA"
//cQry9+= " ON GA_GROPC = G1_GROPC AND G1_OPC = GA_OPC"
cQry9+= " WHERE G1_COD = '"+cProd00+"' "  
cQry9+= " AND G1_OPC <> '' "  // VERIFICA SE TEM ALGUM COMPRIMENTO
cQry9+= " AND (SUBSTRING(G1_COMP, 1,1) ='C'  OR  SUBSTRING(G1_COMP, 1,2) ='CP' OR  SUBSTRING(G1_COMP, 1,1) ='F' OR  SUBSTRING(G1_COMP, 1,1) ='N' )" //VERIFICA SE EH CABO
cQry9+= " AND SG1.D_E_L_E_T_ ='' " 
//cQry9+= " ORDER BY G1_COMP " 

If Select("TRA") > 0
	TRA->(dbCloseArea())
EndIf
	
TCQUERY cQry9 New Alias "TRA"    

cOpcional := TRA->G1_OPC
cGruOPC   := TRA->G1_GROPC
                                                                                                                      	
IF  !EMPTY(cOpcional) 
	
	aRotina   := {{"Selecionar","U_GRAVAOPC",0,3}}
	
	//+----------------------------------------------------------------------------
	//| Atribui as variaveis os campos que aparecerao no mBrowse()
	//+----------------------------------------------------------------------------
	aCpos := {"G1_MARK","G1_GROPC","G1_COD","G1_OPC"} 
	
	dbSelectArea("SX3")
	dbSetOrder(2)
	For nI := 1 To Len(aCpos)
		dbSeek(aCpos[nI])
		aAdd(aCampos,{X3_CAMPO,"",Iif(nI==1,"",Trim(X3_TITULO)),Trim(X3_PICTURE)})
	Next
	
	//+----------------------------------------------------------------------------
	//| Monta o filtro especifico das notas que aparecerใo na Tela do Mark Browse
	//+----------------------------------------------------------------------------
	
	dbSelectArea("SG1")
	cKey  := IndexKey()
		
	cFiltro := "G1_GROPC == '"+cGruOPC+"'"
	cFiltro += " .AND. G1_COD == '"+cProd00+"'"
    
	cArq := CriaTrab( Nil, .F. )
	IndRegua("SG1",cArq,cKey,,cFiltro)
	nIndex := RetIndex("SG1")
	nIndex := nIndex + 1
	dbSelectArea("SG1")
	#IFNDEF TOP
		dbSetIndex(cArq+OrdBagExt())
	#ENDIF
	dbSetOrder(nIndex)
	dbGoTop()
	
	cMarca:= GetMark(,"SG1","G1_MARK")
	
	//+----------------------------------------------------------------------------
	//| Limpa os campos F2_MARK para aparecer no Mark Browse
	//+----------------------------------------------------------------------------
	DbSelectArea("SG1")
	SG1->(dbGoTop())
	While SG1->(!EOF())
		SG1->G1_MARK == cMarca
		RecLock("SG1",.F.)
		SG1->G1_MARK := ""
		MsUnLock()
		DbSkip()
	ENDDO           
	SG1->(dbGoTop())
	
	
	// Chama a MarkBrow para Montar a Tela
	MarkBrow("SG1","G1_MARK",,aCampos,,cMarca,,,,,"U_MarcaOne()")
	
	//+----------------------------------------------------------------------------
	//| Desfaz o indice e filtro temporario
	//+----------------------------------------------------------------------------
	
	dbSelectArea("SG1")
	RetIndex("SG1")
	Set Filter To
	cArq += OrdBagExt()
	FErase( cArq )   
	
ELSE 
	MSGINFO("Este produto nใo necessita de opcionais !") 
	Return cRetorno	
ENDIF 

Return cRetorno	

	
//+----------------------------------------------------------------------------
//| Marca UM registro na Tela de Mark Browse
//+----------------------------------------------------------------------------
User Function MarcaOne() 

	IF SG1->G1_MARK == cMarca 
 		RecLock("SG1",.F.)
 		SG1->G1_MARK := ""
 		MsUnLock()
	ELSE
		RecLock("SG1",.F.)
		SG1->G1_MARK := cMarca 
 		MsUnLock()
	ENDIF  

Return
	
//+----------------------------------------------------------------------------
//| Funcao que traz o registro selecionado pela Mark Browse
//+----------------------------------------------------------------------------
User Function GRAVAOPC()

cRetorno := ""
	
cQry:= " SELECT G1_GROPC, G1_OPC"
cQry+= " FROM "+RETSQLNAME("SG1")+" SG1" 
//cQry+= " INNER JOIN "+RETSQLNAME("SGA")+" SGA"
//cQry+= " ON GA_FILIAL = G1_FILIAL AND GA_GROPC = G1_GROPC AND G1_OPC = GA_OPC"
cQry+= " WHERE G1_MARK <> '' " 
cQry+= " AND G1_GROPC = '"+cGruOPC+"' " // Ajuste feito em 14-01-14
cQry+= " AND SG1.D_E_L_E_T_ ='' " 

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf
	
TCQUERY cQry New Alias "TRB"    // LACO PARA GRAVAR NOS CAMPOS DE TODOS OS ITENS DO PEDIDO 

cRetor1 := TRB->G1_GROPC
cRetor2 := TRB->G1_OPC

cRetorno := cRetor1 + cRetor2 + "/" // GA_GROPC + "" + GA_OPC + "/"
	
IF EMPTY(cRetorno)
	ALERT("Nenhum opcional foi selecionado, favor selecionar pelo menos um opcional !")
	Return
ELSE 
	MSGINFO("O Opcional  "+ALLTRIM(cRetorno)+"  foi selecionado com sucesso !")
	CloseBrowse()
ENDIF 

DbSelectArea("SG1")
SG1->(dbGoTop())
While SG1->(!EOF())
	SG1->G1_MARK == cMarca
	RecLock("SG1",.F.)
	SG1->G1_MARK := ""
	MsUnLock()
	DbSkip()
ENDDO

Return    
*/