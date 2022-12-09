#include "TOTVS.CH"
#include "Topconn.Ch"

/*__________________________________________________________/
# Tela para rastreamento das medições geradas pelo contrato #
# Renato Ruy - 12/02/2014								    #
/__________________________________________________________*/

User Function CSCGT003()

Local nX,nY,nZ

DEFINE DIALOG oDlg TITLE "Rastreamento de Contrato" FROM 180,180 TO 550,700 PIXEL

aNodes := {}
IMAGE1 := "" 	// Imagem quando nível estiver fechado
IMAGE2  := "" 	// Imagem quando nível estiver aberto
nLoop   := 690  // Quantidade de Loops - irá gerar 20010 Itens
nCount	:= 0	// Simula ID dos itens da Tree
//cTime1 := Time()

// PRIMEIRO NÍVEL
	nCount++	
	IMAGE1 := "FOLDER5"	
	aadd( aNodes, {'00', StrZero(nCount,7), "", "Contrato número: "+;	
	CN9->CN9_NUMERO + "/ Revisão: " + CN9->CN9_REVISA, IMAGE1, IMAGE2} )		
	
	// SEGUNDO NÍVEL
	DbSelectArea("CND")   
	DbSetOrder(1)
	If DbSeek( xFilial("CND") + CN9->CN9_NUMERO + CN9->CN9_REVISA)	
		
		While 	CND->CND_FILIAL == CN9->CN9_FILIAL .AND. ;
				CND->CND_CONTRA == CN9->CN9_NUMERO .AND. ;
				CND->CND_REVISA == CN9->CN9_REVISA
				
		nCount++		
		IMAGE1 := "FOLDER6"		
		aadd( aNodes, {'01', StrZero(nCount,7), "", "Medição: "+;		
		CND->CND_NUMMED, IMAGE1, IMAGE2} )				
	
			// TERCEIRO NÍVEL
			//Busca para encontrar pedidos gerados através do contrato.
			cQuery := " SELECT C5_NUM FROM " + RetSqlName("SC5")
			cQuery += " WHERE "
			cQuery += " C5_MDCONTR = '" + CND->CND_CONTRA + "' AND "
			cQuery += " C5_MDNUMED = '" + CND->CND_NUMMED + "' AND "
			cQuery += " D_E_L_E_T_ = ' ' "

			If Select("TMPGCT") > 0
				DbSelectArea("TMPGCT")
				TMPGCT->(DbCloseArea())
			EndIf

			cQuery := CHANGEQUERY(cQuery)
			TcQuery cQuery New Alias "TMPGCT"

			DbSelectArea("TMPGCT")
			DbGoTop() 
					
			While !Eof("TMPGCT")						
				nCount++			
				IMAGE1 := "FOLDER10"			
				aadd( aNodes, {'02',StrZero(nCount,7),"","Pedido Nº: "+;			
				TMPGCT->C5_NUM, IMAGE1, IMAGE2} )
				DbSelectArea("TMPGCT")
				DbSkip()					
			EndDo			
		DbSelectArea("CND")
		DbSkip()
		EndDo
	EndIf
	
	// Cria o objeto Tree
	oTree := DbTree():New(0,0,160,260,oDlg,,,.T.)
	// Método para carga dos itens da Tree
	
	oTree:PTSendTree( aNodes )
	
	ACTIVATE DIALOG oDlg CENTERED
	
Return