#INCLUDE "PROTHEUS.CH"

/*
+==========================================================+
|Programa: ESTP010 |Autor: Antonio Carlos |Data: 04/05/09  |
+==========================================================+
|Descricao: Este programa tem o objetivo de finalizar os   |
|Romaneios e gerar as Pre-Notas conforme romaneio informado|
+==========================================================+
|Uso: Laselva                                              |
+==========================================================+
*/

User Function ESTP010()

Local cCadastro	:= "Processa Romaneio - Pre-Nota"
Local _lTela	:= .T.     

Private _cNumRom	:= Space(8)
Private aCab     	:=  {}
Private aItens		:=  {}
Private aLinha      := 	{}
Private lMsErroAuto := .F.
		
While _lTela

	DEFINE MSDIALOG oDlg FROM 000,000 TO 220,400 TITLE cCadastro PIXEL

	@ 05,05 TO 80,200 PIXEL			

	@ 010,010 SAY "Esta rotina tem o objetivo de finalizar os romaneios pendentes devido  " PIXEL OF oDlg 
	@ 020,010 SAY "periodo de implantacao gerando os arquivos de Pre-Nota.                " PIXEL OF oDlg                              

	@ 050,050 SAY "Romaneio : " PIXEL OF oDlg
	@ 050,090 MSGET oNumRom VAR _cNumRom SIZE 15,10 PIXEL OF oDlg

	@ 90,055 	BUTTON "Processa"		SIZE 040,015 OF oDlg PIXEL ACTION(LjMsgRun("Aguarde..., Finalizando Romaneio / Processando Nota Fiscal...",, {|| AtuDados() }) ) 
	@ 90,110 	BUTTON "Fechar"  		SIZE 040,015 OF oDlg PIXEL ACTION(_lTela := .F., oDlg:End()) 
  		
	ACTIVATE MSDIALOG oDlg CENTERED
	
EndDo	

Return

Static Function AtuDados()
      
Local cFornecedor	:= ""
Local cLoja			:= ""		

DbSelectArea("PA6")
PA6->( DbSetOrder(1) )
If PA6->( DbSeek( xFilial("PA6")+_cNumRom ) )

	If PA6->PA6_FILDES != cFilAnt
		Alert("O encerramento pode ser feito apenas na filial de destino")
		Return
	EndIf 
	
	SM0->( dbSetOrder(1) )
	SM0->( dbSeek(cEmpAnt + PA6->PA6_FILORI) )

//	cFornecedor := GetAdvFVal("SA2","A2_COD",xFilial("SA2")+SM0->M0_CGC,3)

		cfornecedor := U_LS_GETEMPR(PA6->PA6_FILORI)
  		cLoja       := PA6->PA6_FILORI

                If Empty(cFornecedor) .or. Empty(cLoja)
        	        Alert("A filial " + PA6->PA6_FILORI + " nao esta cadastrada como fornecedor")
                    Return
                EndIf
                                                        
                If !SA2->(DbSeek(xFIlial('SA2') + cFornecedor + cLoja,.f.))
                    Alert("A filial " + PA6->PA6_FILORI + " nao esta cadastrada como fornecedor")
                    Return
                EndIf

/*	cLoja		:= SM0->M0_CODFIL

	If Empty(cFornecedor) .or. Empty(cLoja)
		Alert("A filial " + SM0->M0_FILIAL+ " nao esta cadastrada como fornecedor")
		Return
	EndIf*/
	
	If PA6->PA6_STATUS == "06"  //Encerrado
		Alert("Este romaneio já foi encerrado.")
		Return(.T.)
	EndIf

	//If PA6->PA6_STATUS <> "05"  //Recebimento Ok
		//Alert("Este romaneio ainda não foi recebido. Não pode ser encerrado.")
		//Return(.T.)
	//EndIf

	SF2->(DbSetOrder(1))
	SF2->(DbGoTop())
	If !SF2->(DbSeek(PA6->PA6_FILORI+PA6->PA6_NFS+PA6->PA6_SERIE))
		Alert("Nota fiscal " + PA6_NFS + " não encontrada na filial " + PA6->PA6_FILORI) 
		Return 
	EndIf   

	SF1->(DbSetOrder(1))
	If SF1->(DbSeek(PA6->PA6_FILDES+strzero(val(PA6->PA6_NFS),9)+PA6->PA6_SERIE+cFornecedor+cLoja))
		Alert("Nota fiscal de entrada já foi incluida. O romaneiro será encerrado.") 
		RecLock('PA6',.f.)
		PA6->PA6_NFE    := strzero(val(PA6->PA6_NFS),9)
		PA6->PA6_STATUS := '06'
		MsUnLock()
		Return 
	ElseIf SF1->(DbSeek(PA6->PA6_FILDES+PA6->PA6_NFS+PA6->PA6_SERIE+cFornecedor+cLoja))
		Alert("Nota fiscal de entrada já foi incluida. O romaneiro será encerrado.") 
		RecLock('PA6',.f.)
		PA6->PA6_NFE    := PA6->PA6_NFS
		PA6->PA6_STATUS := '06'
		MsUnLock()
		Return 
	EndIf   

	aAdd(aCab,{"F1_TIPO",			"N" 			})	
	aAdd(aCab,{"F1_FORMUL",      	"N" 			})
	aAdd(aCab,{"F1_DOC",         	strzero(val(PA6->PA6_NFS),9)	})  
	aAdd(aCab,{"F1_SERIE",      	SF2->F2_SERIE	}) 
	aAdd(aCab,{"F1_EMISSAO",     	SF2->F2_EMISSAO	}) 
	aAdd(aCab,{"F1_FORNECE",     	cFornecedor	}) 
	aAdd(aCab,{"F1_LOJA",        	cLoja	})    
	aAdd(aCab,{"F1_ESPECIE",     	"NFE"			})  
	aAdd(aCab,{"F1_COND",			"001"			})


	//Localizar item da NF
	//Indice 3 -D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
	SD2->(DbSetOrder(3))
	If !SD2->(DbSeek(PA6->PA6_FILORI+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))   
    	Alert("Nota fiscal " + F2_DOC + " não tem item ")
	    Return  
	EndIf    
	
	_aBloqs := {}
	While !SD2->(Eof()) .And. (SD2->D2_FILIAL	== PA6->PA6_FILORI;
                    	 .And. SD2->D2_DOC		== SF2->F2_DOC;
                         .And. SD2->D2_SERIE	== SF2->F2_SERIE;
                         .And. SD2->D2_CLIENTE	== SF2->F2_CLIENTE;
                         .And. SD2->D2_LOJA		== SF2->F2_LOJA)

 		If Posicione('SB1',1,xFilial('SB1') + SD2->D2_COD,'B1_MSBLQL') == '1'
 			aAdd(_aBloqs,SD2->D2_COD)
 			RecLock('SB1',.f.)
 			SB1->B1_MSBLQL := '2'
 			MsUnLock()
 		EndIf

		aAdd(aLinha,{"D1_COD", 		SD2->D2_COD, 		   		Nil	})
		aAdd(aLinha,{"D1_UM", 		SD2->D2_UM,    		   		Nil	})   	
		aAdd(aLinha,{"D1_QUANT",	SD2->D2_QUANT, 				Nil	})    
		aAdd(aLinha,{"D1_VUNIT",	SD2->D2_TOTAL/SD2->D2_QUANT,				Nil	})    
		aAdd(aLinha,{"D1_TOTAL",	SD2->D2_TOTAL, 		   		Nil	})    
		aAdd(aLinha,{"D1_LOCAL",	SD2->D2_LOCAL, 				Nil	})   


		aAdd(aLinha,{"D1_ITEM",		strzero(VAL(SD2->D2_ITEM)+1,4),	Nil	}) 
//		aAdd(aLinha,{"D1_ITEM",		SD2->D2_ITEM,  		   		Nil	})    
		aAdd(aLinha,{"D1_PESO",		SD2->D2_PESO,  		   		Nil	})     
		aAdd(aLinha,{"D1_TP",		SD2->D2_TP, 		  		Nil	})       
		
    	SD2->( DbSkip() )
	    aAdd( aItens, aLinha )
    	aLinha := {}
	EndDo

	MsAguarde({|| MATA140(aCab,aItens)},"Aguarde...","Gerando pre nota",.T.)

	DbSelectArea('SB1')
 	For _nI := 1 to len(_aBloqs)
 		DbSeek(xFIlial('SB1') + _aBloqs[_nI],.f.)
 		RecLock('SB1',.f.)
 		SB1->B1_MSBLQL := '1'
 		MsUnLock()
 	Next

	If lMsErroAuto
    	MostraErro()
	    Return
	Else       
    	Alert("Classifique a pre nota:  " + SF2->F2_DOC)      
    	RecLock("PA6",.F.)
		PA6->PA6_STATUS := "06"	//Encerrado
		PA6->PA6_NFE    := 	SF2->F2_DOC
		PA6->( Msunlock() )
		
		_cNumRom	:= Space(8)

	EndIf	

Else
	
	Alert("Romaneio " + PA6->PA6_NUMROM + " não encontrado na filial " + PA6->PA6_FILORI) 
	_cNumRom := Space(8)

EndIf

Return