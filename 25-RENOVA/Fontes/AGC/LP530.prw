#Include "PROTHEUS.CH"
#Include "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³LP530 ºAutor ³Microsiga º Data ³ 04/24/12 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc. ³ UTILIZADO PARA BX DE TITULOS REF.FOLHA DE PAGTO.SOMENTE º±±
±±º ³ CONTABILIZADO PELA BX. º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso ³ AP º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
  
Alteração em 04/02/2021 - LMS Para atender ao PRJ:

Conta a Retornar           Se SE2->E2_XCLASS 
2101302010107              "1" - FORNECEDORES NEGOCIADOS CLASSE I - PRJ
2101302010108              "3" - FORNECEDORES NEGOCIADOS CLASSE III - PRJ
2101302010109              "4" - FORNECEDORES NEGOCIADOS CLASSE IV - PRJ

2102101010145              "2" - EMPRESTIMOS CLASSE II - PRJ
2102101010146              "5" - EMPRESTIMOS CLASSE III – PRJ
*/

User Function LP530(cSeq)

Local cConta := ""   // Conta Contábil
//Local aArea := {}  // Area
Local aAreaSA2 := {} // Area SA2
Local aAreaSE2 := {} // Area SE2
Local aAreaSED := {} // Area SED

If cSeq == "001"	// Pagamento do Título - Baixa Normal
	/*Comentado IIF's conforme e-mail do Wellington e Gina na data de 13/03/2018 as 13:17
	If Alltrim(SE2->E2_TIPO)=="ADI"
		cConta := "1119101010101"
	elseif Alltrim(SE2->E2_TIPO)=="131"
		cConta := "1119101010102"
	elseif Alltrim(SE2->E2_TIPO)=="FER"
		cConta := "1119101010103"
	elseif Alltrim(SE2->E2_TIPO)=="TF"
		cConta := "1106201010101"
	elseif Alltrim(SE2->E2_TIPO)=="FOL"
		cConta := "2103101010103"
	elseif Alltrim(SE2->E2_TIPO)=="RES"
		cConta := "2103101010102"
	elseif Alltrim(SE2->E2_TIPO)=="PEN"
		cConta := "2103101010104"
	elseif Alltrim(SE2->E2_TIPO)=="INF"
		cConta := "2103104010101"
	elseif Alltrim(SE2->E2_TIPO)=="FGT"
		cConta := "2103104010102"
	elseif Alltrim(SE2->E2_TIPO)=="IRF"
		cConta := "2103104010103"
	elseif Alltrim(SE2->E2_TIPO)=="SIN"
		cConta := "2103104010104"
	elseif Alltrim(SE2->E2_TIPO)=="PIS"*/
	If Alltrim(SE2->E2_TIPO)=="PIS"
		cConta := "2105101010106"
	elseif Alltrim(SE2->E2_TIPO)=="COF"
		cConta := "2105101010107"
	elseif Alltrim(SE2->E2_TIPO)=="IRP"
		cConta := "210501010101"
	elseif Alltrim(SE2->E2_TIPO)=="CSL"
		cConta := "210501010102"
	/*elseif Alltrim(SE2->E2_TIPO)=="ASM"
		cConta := "6105405010110"
	elseif Alltrim(SE2->E2_TIPO)=="VLA"
		cConta := "6105405010111"
	elseif Alltrim(SE2->E2_TIPO)=="VLT"
		cConta := "6105405010112"
	elseif Alltrim(SE2->E2_TIPO)=="SEV"
		cConta := "6105405010113" */
	elseif Alltrim(SE2->E2_TIPO)=="LIQ" .AND. !ALLTRIM(SE5->E5_NATUREZ)$"2417/2418"
        if AllTrim(SE2->E2_PREFIXO)="PRJ"     		// Alterado por LMS - 04/02/2021 (inicio)
		   do Case
		   		case SE2->E2_XCLASS=="1"
					cConta := "2101302010107"
				case SE2->E2_XCLASS=="2"
					cConta := "2102101010145"
				case SE2->E2_XCLASS=="3"
					cConta := "2101302010108"              
				case SE2->E2_XCLASS=="4"
					cConta := "2101302010109"
				case SE2->E2_XCLASS=="5"
					cConta := "2102101010146"
				otherwise
					Alert("Atenção: Título de Liquidação com Prefixo 'PRJ' e sem a Classe de Título cadastrado!")
				    cConta := "XXXXXXXXXXXXX"
			EndCase
		else 
  			cConta := "2101301010109"  				// Se não for baixa de Liquidação do RJ
		endif										// Alterado por LMS - 04/02/2021 (fim)
	elseif Alltrim(SE2->E2_TIPO)=="LIQ" .AND. ALLTRIM(SE5->E5_NATUREZ)$"2417/2418"
        if AllTrim(SE2->E2_PREFIXO)="PRJ"     		// Alterado por LMS - 04/02/2021 (inicio)
		   do Case
		   		case SE2->E2_XCLASS=="1"
					cConta := "2101302010107"
				case SE2->E2_XCLASS=="2"
					cConta := "2102101010145"
				case SE2->E2_XCLASS=="3"
					cConta := "2101302010108"              
				case SE2->E2_XCLASS=="4"
					cConta := "2101302010109"
				case SE2->E2_XCLASS=="5"
					cConta := "2102101010146"
				otherwise
					Alert("Atenção: Título de Liquidação com Prefixo 'PRJ' e sem a Classe de Título cadastrado!")
				    cConta := "XXXXXXXXXXXXX"
			EndCase
		else                                                                            //PARCELAMENTO DE TRIBUTOS POR LIQUIDAÇÃO
  			cConta := GetAdvFVal("SED","ED_CONTA",xFilial("SED")+SE5->E5_NATUREZ,1,"")  // Se não for baixa de Liquidação do RJ
		endif										                                    // Alterado por LMS - 04/02/2021 (fim)
	//Adicionado Ronaldo Bicudo - 06/03/2018
	elseif Alltrim(SE2->E2_TIPO)=="TX"
	    cConta := GetAdvFVal("SED","ED_CONTA",xFilial("SED")+SE5->E5_NATUREZ,1,"")
	elseif !Empty(SA2->A2_CONTA )
	    cConta := SA2->A2_CONTA
	Else
    	cConta := "2101301010101"
	//Final da Alteração
	Endif

ElseIf cSeq == "035"	// Baixa de pagamento de Imposto de Renda
 	if Alltrim(SE2->E2_TIPO)=="LIQ"	
        if AllTrim(SE2->E2_PREFIXO)="PRJ"     		// Alterado por LMS - 04/02/2021 (inicio)
		   do Case
		   		case SE2->E2_XCLASS=="1"
					cConta := "2101302010107"
				case SE2->E2_XCLASS=="2"
					cConta := "2102101010145"
				case SE2->E2_XCLASS=="3"
					cConta := "2101302010108"              
				case SE2->E2_XCLASS=="4"
					cConta := "2101302010109"
				case SE2->E2_XCLASS=="5"
					cConta := "2102101010146"
				otherwise
					Alert("Atenção: Título de Liquidação com Prefixo 'PRJ' e sem a Classe de Título cadastrado!")
				    cConta := "XXXXXXXXXXXXX"
			EndCase
		else 
  			cConta := "2105101010101"  				// Se foi liquidação mas não do RJ - conta original
		endif										
    else
        cConta := "2105101010101"  				    // Se for o título original e não Liquidação do RJ - conta original
    endif                                           // Alterado por LMS - 04/02/2021 (fim)
        
    aAreaSA2 := SA2->(GetArea())
    If !Empty(SE2->E2_TITPAI)                       // Se o título sendo baixado for de Liquidação do RJ, a informação 
        dbSelectArea("SA2")                         // do título pai não existe, portanto não necessita alterar
        dbSetOrder(1)
        dbSeek(xFilial("SA2") + SUBSTR(SE2->E2_TITPAI,19,8))

        If SA2->A2_TIPO = "F"
            cConta :="2105101010102"
        EndIf
    EndIf
    RestArea(aAreaSA2)

ElseIf cSeq == "597"       // USADO NAS LPs 589 e 597 - Para compensação de títulos = Não Muda 
    aAreaSED := SED->(GetArea())
    If SE5->E5_TIPO='PA'
        dbSelectArea("SED")
        dbSetOrder(1)
        dbSeek(XFILIAL("SED")+SE5->E5_NATUREZ)
        cConta := SED->ED_CONTA
    Else
        aAreaSE2 := SE2->(GetArea())
        dbSelectArea("SE2")
        dbSetOrder(1)
        dbSeek(xFilial("SE2") + SUBSTR(SE5->E5_DOCUMEN,1,18) + SE5->(E5_FORNADT + E5_LOJAADT))
        dbSelectArea("SED")
        dbSetOrder(1)
        dbSeek(XFILIAL("SED")+SE2->E2_NATUREZ)
        cConta := SED->ED_CONTA
        RestArea(aAreaSE2)
    EndIf
    RestArea(aAreaSED)

ElseIf cSeq == "D59" 	// Liquidação de Título de Imposto - Conta Débito = Incluido por LMS - 05/02/2021 (inicio)
	// IIF(ALLTRIM(SE5->E5_NATUREZ)=='2405',U_LP530("059"),POSICIONE("SED",1,XFILIAL("SED")+SE5->E5_NATUREZ,"ED_CONTA"))
    cConta := ""    	// Conta Contábil

	do Case								
		case SE2->E2_XCLASS=="1"
			cConta := "2101302010107"
		case SE2->E2_XCLASS=="2"
			cConta := "2102101010145"
		case SE2->E2_XCLASS=="3"
			cConta := "2101302010108"              
		case SE2->E2_XCLASS=="4"
			cConta := "2101302010109"
		case SE2->E2_XCLASS=="5"
			cConta := "2102101010146"
		otherwise                      	// Se foi liquidação mas não do RJ - conta original
			if ALLTRIM(SE5->E5_NATUREZ)=='2405'
				aAreaSE2 := SE2->(GetArea())
        		dbSelectArea("SE2")
        		dbSetOrder(1)
        		dbSeek(xFilial("SE2") + SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA))
        		_cTitPai:= SUBSTR(SE2->E2_TITPAI,19,8)
        		aAreaSA2 := SA2->(GetArea())
        		If !Empty(SE2->E2_TITPAI)
	            	dbSelectArea("SA2")
    	        	dbSetOrder(1)
        	    	dbSeek(xFilial("SA2") + _cTitPai)
            		If SA2->A2_TIPO = "F"
	                	cConta:= "2105101010102"
            		Else
		                cConta:= "2105101010101" // PESSOA JURIDICA
					endif
    	        EndIf
        		RestArea(aAreaSA2)
        		RestArea(aAreaSE2)
			else 
				POSICIONE("SED",1,XFILIAL("SED")+SE5->E5_NATUREZ,"ED_CONTA")
    		EndIf
	endcase

ElseIf cSeq == "C59" 	// Liquidação de Título de Imposto - Conta Crédito = Incluido por LMS - 05/02/2021 (inicio)
	//IIF(ALLTRIM(SE5->E5_NATUREZ)=='2407','2105102010102','2105101010110')
    cConta := ""    	// Conta Contábil

	do Case								
		case SE2->E2_XCLASS=="1"
			cConta := "2101302010107"
		case SE2->E2_XCLASS=="2"
			cConta := "2102101010145"
		case SE2->E2_XCLASS=="3"
			cConta := "2101302010108"              
		case SE2->E2_XCLASS=="4"
			cConta := "2101302010109"
		case SE2->E2_XCLASS=="5"
			cConta := "2102101010146"
		otherwise                      	// Se foi liquidação mas não do RJ - conta original
			if ALLTRIM(SE5->E5_NATUREZ)=='2407'
            	cConta:= "2105102010102"
            Else
		       	cConta:= "2105101010110" 
    	    EndIf
	endcase

ElseIf cSeq == "C58"     // Liquidação do Título (exceto imposto) = Incluido por LMS - 05/02/2021 (inicio)
	// 2101301010109 - Conta Crédito  ===  A conta débito permanece 2101301010101 (Fornecedores)
	do Case		
		case SE2->E2_XCLASS=="1"
			cConta := "2101302010107"
		case SE2->E2_XCLASS=="2"
			cConta := "2102101010145"
		case SE2->E2_XCLASS=="3"
			cConta := "2101302010108"              
		case SE2->E2_XCLASS=="4"
			cConta := "2101302010109"
		case SE2->E2_XCLASS=="5"
			cConta := "2102101010146"
		otherwise
		    cConta := "2101301010109"
	EndCase

elseif cSeq == "D60"	// Reliquidação de Título - Conta Débito = Incluido por LMS - 05/02/2021 (inicio)
	// 2101301010109
	if AllTrim(SE2->E2_PREFIXO)="PRJ"
		do Case		
			case SE2->E2_XCLASS=="1"
				cConta := "2101302010107"
			case SE2->E2_XCLASS=="2"
				cConta := "2102101010145"
			case SE2->E2_XCLASS=="3"
				cConta := "2101302010108"              
			case SE2->E2_XCLASS=="4"
				cConta := "2101302010109"
			case SE2->E2_XCLASS=="5"
				cConta := "2102101010146"
			otherwise
				Alert("Atenção: Título de Liquidação com Prefixo 'PRJ' e sem a Classe de Título cadastrado!")					
			    cConta := "XXXXXXXXXXXXX"
		endcase
	else
		cConta := "2101301010109"
	endif

elseif cSeq == "C60"	// Reliquidação de Título - Conta Crédito = Incluido por LMS - 05/02/2021
	// 2101301010111
	if AllTrim(SE2->E2_PREFIXO)="PRJ"
		do Case		
			case SE2->E2_XCLASS=="1"
				cConta := "2101302010107"
			case SE2->E2_XCLASS=="2"
				cConta := "2102101010145"
			case SE2->E2_XCLASS=="3"
				cConta := "2101302010108"              
			case SE2->E2_XCLASS=="4"
				cConta := "2101302010109"
			case SE2->E2_XCLASS=="5"
				cConta := "2102101010146"
			otherwise
				Alert("Atenção: Título de Liquidação com Prefixo 'PRJ' e sem a Classe de Título cadastrado!")					
			    cConta := "XXXXXXXXXXXXX"
		Endcase
	else
		cConta := "2101301010111"
	endif

ElseIf cSeq == "D61" 	// Reliquidação de Título de Imposto - Conta Crédito (análogo Crédito C59)  = Incluido por LMS - 05/02/2021
	// SED->ED_CONTA
	if AllTrim(SE2->E2_PREFIXO)="PRJ"
		do Case								
			case SE2->E2_XCLASS=="1"
				cConta := "2101302010107"
			case SE2->E2_XCLASS=="2"
				cConta := "2102101010145"
			case SE2->E2_XCLASS=="3"
				cConta := "2101302010108"              
			case SE2->E2_XCLASS=="4"
				cConta := "2101302010109"
			case SE2->E2_XCLASS=="5"
				cConta := "2102101010146"
			otherwise    
				Alert("Atenção: Título de Liquidação com Prefixo 'PRJ' e sem a Classe de Título cadastrado!")					
			    cConta := "XXXXXXXXXXXXX"
			endcase			
	else		                  	 		// Se foi liquidação mas não do RJ - conta original
		cConta:= SED->ED_CONTA
	endif

elseif cSeq == "C61"	// Reliquidação de Título de Impostos - Conta Crédito  = Incluido por LMS - 05/02/2021
	// 2105101010111
	if AllTrim(SE2->E2_PREFIXO)="PRJ"
		do Case		
			case SE2->E2_XCLASS=="1"
				cConta := "2101302010107"
			case SE2->E2_XCLASS=="2"
				cConta := "2102101010145"
			case SE2->E2_XCLASS=="3"
				cConta := "2101302010108"              
			case SE2->E2_XCLASS=="4"
				cConta := "2101302010109"
			case SE2->E2_XCLASS=="5"
				cConta := "2102101010146"
			otherwise
				Alert("Atenção: Título de Liquidação com Prefixo 'PRJ' e sem a Classe de Título cadastrado!")					
			    cConta := "XXXXXXXXXXXXX"
		Endcase
	else
		cConta := "2105101010111"
	endif

elseif cSeq == "C62"	// Liquidação/Reliquidação de Juros - Conta Crédito = Incluido por LMS - 05/02/2021
	// IIF(!ALLTRIM(SE5->E5_NATUREZ)$FORMULA("001"),'2101301010109',IF(ALLTRIM(SE5->E5_NATUREZ)$'2407/2418','2105102010102','2105101010110'))
	// A conta débito é de resultado e essa situação não está prevista na relação de contas novas (PRJ)
		do Case		
			case SE2->E2_XCLASS=="1"
				cConta := "2101302010107"
			case SE2->E2_XCLASS=="2"
				cConta := "2102101010145"
			case SE2->E2_XCLASS=="3"
				cConta := "2101302010108"              
			case SE2->E2_XCLASS=="4"
				cConta := "2101302010109"
			case SE2->E2_XCLASS=="5"
				cConta := "2102101010146"
			otherwise
				if !ALLTRIM(SE5->E5_NATUREZ)$FORMULA("001")
					cConta := "2101301010109"
				else
					if ALLTRIM(SE5->E5_NATUREZ)$'2407/2418'
						cConta := "2105102010102"
					else
						cConta := "2105101010110"
					Endif
				endif
		endcase

elseif cSeq == "D63"	// Liquidação/Reliquidação de Descontos = Incluido por LMS - 05/02/2021
	// IIF(!ALLTRIM(SE5->E5_NATUREZ)$FORMULA("001"),'2101301010109',IF(ALLTRIM(SE5->E5_NATUREZ)=='2407','2105102010102','2105101010110'))
	// A conta crédito é de resultado e essa situação não está prevista na relação de contas novas (PRJ)
		do Case		
			case SE2->E2_XCLASS=="1"
				cConta := "2101302010107"
			case SE2->E2_XCLASS=="2"
				cConta := "2102101010145"
			case SE2->E2_XCLASS=="3"
				cConta := "2101302010108"              
			case SE2->E2_XCLASS=="4"
				cConta := "2101302010109"
			case SE2->E2_XCLASS=="5"
				cConta := "2102101010146"
			otherwise
				if !ALLTRIM(SE5->E5_NATUREZ)$FORMULA("001")
					cConta := "2101301010109"
				else
					if ALLTRIM(SE5->E5_NATUREZ)$'2407'
						cConta := "2105102010102"
					else
						cConta := "2105101010110"
					Endif
				endif
		endcase

elseif cSeq == "D64"	// BX RELIQ PAGAR PRINCIPAL EXCETO IMP TRAN - Conta Débido = Incluido por LMS - 05/02/2021
	// 2101301010111
	if AllTrim(SE2->E2_PREFIXO)="PRJ"
		do Case		
			case SE2->E2_XCLASS=="1"
				cConta := "2101302010107"
			case SE2->E2_XCLASS=="2"
				cConta := "2102101010145"
			case SE2->E2_XCLASS=="3"
				cConta := "2101302010108"              
			case SE2->E2_XCLASS=="4"
				cConta := "2101302010109"
			case SE2->E2_XCLASS=="5"
				cConta := "2102101010146"
			otherwise
				Alert("Atenção: Título de Liquidação com Prefixo 'PRJ' e sem a Classe de Título cadastrado!")					
			    cConta := "XXXXXXXXXXXXX"
		Endcase
	else
		cConta := "2101301010111"
	endif

elseif cSeq == "C64"	// BX RELIQ PAGAR PRINCIPAL EXCETO IMP TRAN - Conta Crédito = Incluido por LMS - 05/02/2021
	// 2101301010109
	if AllTrim(SE2->E2_PREFIXO)="PRJ" .or. (AllTrim(SE2->E2_PREFIXO) = "TAQ" .and. SE2->E2_XRJ = "S")
		do Case		
			case SE2->E2_XCLASS=="1"
				cConta := "2101302010107"
			case SE2->E2_XCLASS=="2"
				cConta := "2102101010145"
			case SE2->E2_XCLASS=="3"
				cConta := "2101302010108"              
			case SE2->E2_XCLASS=="4"
				cConta := "2101302010109"
			case SE2->E2_XCLASS=="5"
				cConta := "2102101010146"
			otherwise
				Alert("Atenção: Título de Liquidação com Prefixo 'PRJ' e sem a Classe de Título cadastrado!")					
			    cConta := "XXXXXXXXXXXXX"
		endcase
	else
		cConta := "2101301010109"
	endif

elseif cSeq == "D65"	// BX RELIQ PAGAR PRINCIPAL IMPOSTOS TRAN  -  Conta Débito = Incluido por LMS - 05/02/2021
	// 2105101010111
	if AllTrim(SE2->E2_PREFIXO)="PRJ" .or. (AllTrim(SE2->E2_PREFIXO) = "TAQ" .and. SE2->E2_XRJ = "S")
		do Case		
			case SE2->E2_XCLASS=="1"
				cConta := "2101302010107"
			case SE2->E2_XCLASS=="2"
				cConta := "2102101010145"
			case SE2->E2_XCLASS=="3"
				cConta := "2101302010108"              
			case SE2->E2_XCLASS=="4"
				cConta := "2101302010109"
			case SE2->E2_XCLASS=="5"
				cConta := "2102101010146"
			otherwise
				Alert("Atenção: Título de Liquidação com Prefixo 'PRJ' e sem a Classe de Título cadastrado!")					
			    cConta := "XXXXXXXXXXXXX"
		Endcase
	else
		cConta := "2105101010111"
	endif

elseif cSeq == "C65"	// BX RELIQ PAGAR PRINCIPAL IMPOSTOS TRAN  -  Conta Crédito = Incluido por LMS - 05/02/2021
	// SED->ED_CONTA
	if AllTrim(SE2->E2_PREFIXO)="PRJ" .or. (AllTrim(SE2->E2_PREFIXO) = "TAQ" .and. SE2->E2_XRJ = "S")
		do Case								
			case SE2->E2_XCLASS=="1"
				cConta := "2101302010107"
			case SE2->E2_XCLASS=="2"
				cConta := "2102101010145"
			case SE2->E2_XCLASS=="3"
				cConta := "2101302010108"              
			case SE2->E2_XCLASS=="4"
				cConta := "2101302010109"
			case SE2->E2_XCLASS=="5"
				cConta := "2102101010146"
			otherwise    
				Alert("Atenção: Título de Liquidação com Prefixo 'PRJ' e sem a Classe de Título cadastrado!")					
			    cConta := "XXXXXXXXXXXXX"
			endcase			
	else		                  	 		// Se foi liquidação mas não do RJ - conta original
		cConta:= SED->ED_CONTA
	endif

endif


Return(cConta)
