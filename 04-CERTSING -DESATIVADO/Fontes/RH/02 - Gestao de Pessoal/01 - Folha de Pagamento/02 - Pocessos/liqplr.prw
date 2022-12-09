#include "Protheus.ch"  

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Função    ¦ liqplr   ¦ Autor ¦ Mariella Garagatti    ¦ Data ¦16.07.12  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Gera a verba de liquido da PLR na folha e na rescisão      ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ SIGAGPE: Roteiros de calculo da folha e rescisão           ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦		                 Histórico de Alterações		                  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Data      ¦ Analista - Mariella Garagatti                              ¦¦¦
¦¦¦09.08.13  ¦                                                            ¦¦¦ 
¦¦+-----------------------------------------------------------------------+¦¦
¦¦ Descrição: Incluida a variavel c__Roteiro para identificar o roteiro    ¦¦
¦¦            de folha ou rescisão.                                        ¦¦
¦¦            Tratativa no calculo da rescisão quando o pagamento ocorre   ¦¦
¦¦            na rescisão ou quando a PLR já foi paga no mês               ¦¦
¦¦            (SRC-lctos mensais)                                          ¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Data      ¦ Analista - Mariella Garagatti                              ¦¦¦
¦¦¦14.08.13  ¦                                                            ¦¦¦ 
¦¦+-----------------------------------------------------------------------+¦¦
¦¦ Descrição: No roteiro da rescisão para pgto da PLR no mês, após o       ¦¦
¦¦            calculo da folha era gerado em duplicidade as verbas         ¦¦
¦¦            391 e 551, desta forma no calculo da rescisão estas verbas   ¦¦
¦¦            já são deletadas da SRC-lctos mensais.                       ¦¦  
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Data      ¦ Analista - Mariella Garagatti                              ¦¦¦
¦¦¦04.10.13  ¦                                                            ¦¦¦ 
¦¦+-----------------------------------------------------------------------+¦¦
¦¦ Descrição: Ajuste quando o liquido for igual a zero, a verba 579 ser    ¦¦
¦¦            deletada - tratativa para a situação de rescisção complem.   ¦¦ 
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Data      ¦ Analista - Mariella Garagatti                              ¦¦¦
¦¦¦28.11.13  ¦                                                            ¦¦¦ 
¦¦+-----------------------------------------------------------------------+¦¦
¦¦ Descrição: Ajuste na rescisão complementar para que não seja gerada a   ¦¦
¦¦            579 de desconto                                              ¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

User function liqplr

Local _nLiqF := 0   
Local _nLiqR := 0
 
          //*******FOLHA
          If c__Roteiro == "FOL" 
		  	
  			_nLiqF := fbuscapd("391,551,552",,,)  
  			If _nLiqF > 0 
		  		fgeraverba("579",_nLiqF,,,,,,,,,.T.,)
            EndIf
	      EndIf
          	      
	      //********RESCISAO 
	      If c__Roteiro == "RES"    
	      
		  	dbselectarea("SRC")
		  	dbsetorder(1)	   
	      	If SRC->(DbSeek(xFilial("SRA")+SRA->RA_MAT+"391"+SRA->RA_CC+"01")) .AND. SRC->RC_VALOR > 0 //RC_FILIAL+RC_MAT+RC_PD+RC_CC+RC_SEMANA+RC_SEQ	
       			_nLiqR := fbuscapd("391,551,552",,,)
		  		fgeraverba("579",_nLiqR,,,,,,,,,.T.,)  
		  		
		  		Reclock("SRC",.F.)
		  	       dbdelete()
		  	    MsUnlock()
		    EndIf
		    
//		    If SRC->(DbSeek(xFilial("SRA")+SRA->RA_MAT+"391"+SRA->RA_CC+"01")) .AND. SRC->RC_VALOR > 0 
		    	If cCompl == 'S' // Quando não for rescisão complementar
		        	fdelpd("579",,)  
		     	Else
		     		_nLiqR := fbuscapd("391,551,552",,,)  
		     		If _nLiqR > 0
		     			fgeraverba("579",_nLiqR,,,,,,,,,.T.,)   
		     		EndIf
		        EndIf
//	      	EndIf   
	      	
        	If SRC->(DbSeek(xFilial("SRA")+SRA->RA_MAT+"551"+SRA->RA_CC+"01")) //RC_FILIAL+RC_MAT+RC_PD+RC_CC+RC_SEMANA+RC_SEQ	
		  	     Reclock("SRC",.F.)
		  	     	dbdelete()
		  	     MsUnlock()
		  	EndIf
	        
	        If SRC->(DbSeek(xFilial("SRA")+SRA->RA_MAT+"708"+SRA->RA_CC+"01")) //RC_FILIAL+RC_MAT+RC_PD+RC_CC+RC_SEMANA+RC_SEQ	
		  	      Reclock("SRC",.F.)
		  	     	dbdelete()
		  	     MsUnlock()
		  	EndIf                             
	      
	      EndIf
	                                                
	fdelpd("392",,)       
	
	If _nLiqF == 0
		fdelpd("579",,)
	EndIf  
	
	If _nLiqR == 0
		fdelpd("579",,)
	EndIf
	
	

Return(.T.)  