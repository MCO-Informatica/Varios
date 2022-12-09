#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณUPDGE35   บAutor  ณCesar A. Bianchi    บ Data ณ  03/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณExibe tela do tipo wizard para iniciar o compatibilizador doบฑฑ
ฑฑบ          ณdicionario de dados, aplicando as alteracoes da UPDGE35 -   บฑฑ
ฑฑบ          ณMelhoria para contemplar a classificacao geral do candidado บฑฑ
ฑฑบ          ณno processo seletivo, dividido por fases.                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP811 								                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function UPDGE35()
Local cMsg := ""         

cArqEmp := "SigaMAT.Emp"
__cInterNet := Nil

Private cMessage
Private aArqUpd	 := {}
Private aREOPEN	 := {}
Private oMainWnd          

Set Dele On

cMsg += "Este programa tem como objetivo ajustar os dicionแrios e base de dados, "
cMsg += "para compatibilizacao com a melhoria de classifica็ao geral e por curso, "
cMsg += "utilizando os criterios de desempate presentes no arquivo JA1. "
cMsg += "Esta rotina deve ser processada em modo exclusivo! "
cMsg += "Fa็a um backup dos dicionแrios e base de dados antes do processamento!" 

oMainWnd := MSDIALOG():Create()
oMainWnd:cName := "oMainWnd"
oMainWnd:cCaption := "Atualizacao de Cadastros de Classificacao Geral PS"
oMainWnd:nLeft := 0
oMainWnd:nTop := 0
oMainWnd:nWidth := 540
oMainWnd:nHeight := 250
oMainWnd:lShowHint := .F.
oMainWnd:lCentered := .T.
oMainWnd:bInit := {|| if( Aviso( "Atualizador de Base", cMsg, {"Cancelar", "Prosseguir"}, 2 ) == 2 , ( Processa({|lEnd| Ge35Run(@lEnd)} , "Atualizador de Base" ) , oMainWnd:End() ), ( MsgAlert( "Opera็ao cancelada!" ), oMainWnd:End() ) ) }

oMainWnd:Activate()

                                
Return(.T.)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGE35Run   บAutor  ณCesar A. Bianchi    บ Data ณ  03/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCarrega as empresas existentes dentro do arquivo sigamat.empบฑฑ
ฑฑบ          ณe executa para cada uma a funcao de ajuste de dicionarios   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP811		                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/ 

Function GE35Run()
Local cTexto    := '' 				//Exibira o log ao final do processo
Local cMask     := "Arquivos Texto (*.TXT) |*.txt|"
Local nRecno    := 0
Local lOpen     := .F. 				//Retorna se conseguiu acesso exclusivo a base de dados
Private aRecnoSM0 := {}
Private nI       := 0               //Contador para laco


If ( lOpen := MyOpenSm0Ex() )
	dbSelectArea("SM0")
	dbGotop()
	While !Eof() 
  		If Ascan(aRecnoSM0,{ |x| x[2] == M0_CODIGO}) == 0 //--So adiciona no aRecnoSM0 se a empresa for diferente
			aAdd(aRecnoSM0,{Recno(),M0_CODIGO})
		EndIf			
		dbSkip()
	EndDo	
		
	If lOpen
			nI := 1
			While nI <= Len(aRecnoSM0)
			
				SM0->(dbGoto(aRecnoSM0[nI,1]))
				RpcSetType(2) 
				RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)
				lMsFinalAuto := .F.
	
				cTexto += Replicate("-",128)+CHR(13)+CHR(10)
				cTexto += "Empresa : "+SM0->M0_CODIGO+SM0->M0_NOME+CHR(13)+CHR(10)
	
				ProcRegua( nI)
				IncProc("Empresa : "+SM0->M0_CODIGO+SM0->M0_NOME)			
				
				//Cria os Campos e indices novos
				IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Ajustando Dicionแrios")
				Conout( dtoc( Date() )+" "+Time()+" "+"Inicio - Ajustando Dicionแrios")			
				cTexto += "Ajustando Dicionแrios..."+CHR(13)+CHR(10)

			   
				UpdGE35Go()
					
									
				IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Ajuste de Dicionแrios")						
				Conout( dtoc( Date() )+" "+Time()+" "+"Fim - Ajuste de Dicionแrios")
		    	nI++
		    	cTexto := "Fim - Ajuste de Dicionแrios..."+CHR(13)+CHR(10)
		    EndDo
		    
	endif
endif

MsgAlert('Processamento Finalizado.')

Return    


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณUpdG35Go  บAutor  ณCesar A Bianchi     บ Data ณ  03/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAjuste dicionarios SX's, conforme UPDGE35                   บฑฑ
ฑฑบ          ณCria็ใo da tabela JMX                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP811                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function UpdGE35Go()
Local lRet := .T.
Local aEstrut  := {}
Local aGravaSX := {}
Local i	:= 1 
Local j := 1
Local cReservOpc := 'þA'
Local cUsadoOpc  := '€€€€€€€€€€€€€€€'

dbSelectArea('SX3')
SX3->(dbSetOrder(2))
SX3->(dbSeek('JMR_ITEM')) 


If SX3->(Found())         

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCria a tabela JMXณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea('SX2')
	SX2->(dbSetOrder(1))
	if SX2->(!dbSeek('JMX'))
		RecLock('SX2',.T.) 
		SX2->X2_CHAVE   := 'JMX'
		SX2->X2_ARQUIVO := 'JMX'+alltrim(aRecnoSM0[nI,2]+'0')
		SX2->X2_NOME := 'ANALISA CRITERIOS DE DESEMPATE'         
		SX2->X2_NOMESPA := 'ANALISA CRITERIOS DE DESEMPATE'
		SX2->X2_NOMEENG := 'ANALISA CRITERIOS DE DESEMPATE'
		SX2->X2_MODO    := 'C'
		SX2->X2_DELET   :=  0
		SX2->(msUnlock())
		conout(Dtoc( date() )+" "+Time()+' Tabela JMX gravada com sucesso em SX2'+alltrim(aRecnoSM0[nI,2])+'0')
	endif
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCria os campos da tablea JMXณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea('SX3')
	SX3->(dbSetOrder(2))
	if SX3->(!dbSeek('JMX_FILIAL'))
		//Adiciona os novos campos em um vetor e o utiliza o vetor aEstrut como base no RecLock
		aEstrut:= { "X3_ARQUIVO","X3_ORDEM"  ,"X3_CAMPO"  ,"X3_TIPO"   ,"X3_TAMANHO","X3_DECIMAL","X3_TITULO" ,"X3_TITSPA" ,"X3_TITENG" ,;
					"X3_DESCRIC","X3_DESCSPA","X3_DESCENG","X3_PICTURE","X3_VALID"  ,"X3_USADO"  ,"X3_RELACAO","X3_F3"     ,"X3_NIVEL"  ,;
					"X3_RESERV" ,"X3_CHECK"  ,"X3_TRIGGER","X3_PROPRI" ,"X3_BROWSE" ,"X3_VISUAL" ,"X3_CONTEXT","X3_OBRIGAT","X3_VLDUSER",;
					"X3_CBOX"   ,"X3_CBOXSPA","X3_CBOXENG","X3_PICTVAR","X3_WHEN"   ,"X3_INIBRW" ,"X3_GRPSXG" ,"X3_FOLDER", "X3_PYME"}
		
		aAdd(aGravaSX,{ 'JMX','01','JMX_FILIAL',;    	                                        //Arquivo,  //Ordem,         //Campo,
			   			'C',2,0,;					   				                            //Tipo,     //Tamanho,       //Decimal																    							
			   			'Filial','Sucursal','Branch',;				                            //Titulo,   //Titulo SPA,    //Titulo ENG		    		
			   			'Filial do Sistema','Sucursal','Branch of yhe system',;					//Descricao	//Descricao SPA  //Descricao ENG				
			   			'@!','',cUsadoOpc,;							     			   			//Picture   //VALID          //USADO				
						'','',1,;							   									//RELACAO	//F3   			 //NIVEL							
			   			cReservOpc,'','','','N','A',;						                    //RESERV    //CHECK,         //TRIGGER,     //PROPRI,  //BROWSE, //VISUAL			
			   			'R','','',;						                                    	//CONTEXT,  //OBRIGAT,       //VLDUSER
						'','','',			;													//CBOX,     //CBOX SPA,      //CBOX ENG
			   			'','','','','',''})														//PICTVAR,  //WHEN, 		 //INIBRW, 		//SXG, 	   //FOLDER, //PYME 	                    
		
		
		aAdd(aGravaSX,{ 'JMX','02','JMX_CODCAN',;    	                            			//Arquivo,  //Ordem,         //Campo,
			   			'C', 10,0,;					   				                            //Tipo,     //Tamanho,       //Decimal																    							
			   			'Cod. Candida','Cod. Candida','Cod. Candida',;						    //Titulo,   //Titulo SPA,    //Titulo ENG		    		
			   			'Codigo do Candidato','Codigo do Candidato','Codigo do Candidato',;		//Descricao	//Descricao SPA  //Descricao ENG				
			   			'@!','',cUsadoOpc,;							           				//Picture   //VALID          //USADO				
						'','',1,;								   								//RELACAO	//F3   			 //NIVEL							
			   			cReservOpc,'','','','N','A',;						                    //RESERV    //CHECK,         //TRIGGER,     //PROPRI,  //BROWSE, //VISUAL			
			   			'R','','',;				                                   			 	//CONTEXT,  //OBRIGAT,       //VLDUSER
						'','','',			;													//CBOX,     //CBOX SPA,      //CBOX ENG
			   			'','','','','',''})														//PICTVAR,  //WHEN, 		 //INIBRW, 		//SXG, 	   //FOLDER, //PYME 	                    
		
		
		aAdd(aGravaSX,{ 'JMX','03','JMX_PONTOG',;    	                           				//Arquivo,  //Ordem,         //Campo,
			   			'N',7,2,;					   				                            //Tipo,     //Tamanho,       //Decimal																    							
			   			'Pont. Geral','Pont. Geral','Pont. Geral',;	                            //Titulo,   //Titulo SPA,    //Titulo ENG		    		
			   			'Pontuacao Geral Candidato','Pontuacao Geral Candidato','Pontuacao Geral Candidato',;					//Descricao	//Descricao SPA  //Descricao ENG				
			   			'@E 99,999.99','',cUsadoOpc,;			   											//Picture   //VALID     	 //USADO				
						'','',1,;											   					//RELACAO	//F3   			 //NIVEL							
			   			cReservOpc,'','','','N','A',;						                    //RESERV    //CHECK,         //TRIGGER,     //PROPRI,  //BROWSE, //VISUAL			
			   			'R','','',;				                                  			  	//CONTEXT,  //OBRIGAT,       //VLDUSER
						'','','',			;													//CBOX,     //CBOX SPA,      //CBOX ENG
			   			'','','','','',''})														//PICTVAR,  //WHEN, 		 //INIBRW, 		//SXG, 	   //FOLDER, //PYME 	                    
		
		aAdd(aGravaSX,{ 'JMX','04','JMX_PONTOD',;    	                            			//Arquivo,  //Ordem,         //Campo,
			   			'N',7,2,;					   				                            //Tipo,     //Tamanho,       //Decimal																    							
			   			'Pont. Discip','Pont. Discip','Pont. Discip',;                          //Titulo,   //Titulo SPA,    //Titulo ENG		    		
			   			'Pontuacao Disciplina','Pontuacao Disciplina','Pontuacao Disciplina',;  //Descricao	//Descricao SPA  //Descricao ENG				
			   			'@E 99,999.99','',cUsadoOpc,;   										//Picture   //VALID          //USADO				
						'','',1,;								   								//RELACAO	//F3   			 //NIVEL							
			   			cReservOpc,'','','','N','A',;						                    //RESERV    //CHECK,         //TRIGGER,     //PROPRI,  //BROWSE, //VISUAL			
			   			'R','','',;				                                     			//CONTEXT,  //OBRIGAT,       //VLDUSER
						'','','',			;													//CBOX,     //CBOX SPA,      //CBOX ENG
			   			'','','','','',''})														//PICTVAR,  //WHEN, 		 //INIBRW, 		//SXG, 	   //FOLDER, //PYME 	                    
		
		
		aAdd(aGravaSX,{ 'JMX','05','JMX_CODDIS',;    	                            			//Arquivo,  //Ordem,         //Campo,
			   			'C',15,0,;					   				                            //Tipo,     //Tamanho,       //Decimal																    							
			   			'Cod. Discip','Cod. Discip','Cod. Discip',;	                            //Titulo,   //Titulo SPA,    //Titulo ENG		    		
			   			'Cod Disciplina','Cod Disciplina','Cod Disciplina',;					//Descricao	//Descricao SPA  //Descricao ENG				
			   			'@!','',cUsadoOpc,;							           					//Picture   //VALID          //USADO				
						'','',1,;																//RELACAO	//F3   			 //NIVEL							
			   			cReservOpc,'','','','N','A',;						                    //RESERV    //CHECK,         //TRIGGER,     //PROPRI,  //BROWSE, //VISUAL			
			   			'R','','',;						                                    	//CONTEXT,  //OBRIGAT,       //VLDUSER
						'','','',			;													//CBOX,     //CBOX SPA,      //CBOX ENG
			   			'','','','','',''})														//PICTVAR,  //WHEN, 		 //INIBRW, 		//SXG, 	   //FOLDER, //PYME 	                    
		
		
		aAdd(aGravaSX,{ 'JMX','06','JMX_CODCUR',;    	                          				//Arquivo,  //Ordem,         //Campo,
			   			'C',6,0,;					   				                            //Tipo,     //Tamanho,       //Decimal																    							
			   			'Cod Curso','Cod Curso','Cod Curso',;	                                //Titulo,   //Titulo SPA,    //Titulo ENG		    		
			   			'Codigo Curso Pretendido','Codigo Curso Pretendido','Codigo Curso Pretendido',;	//Descricao	//Descricao SPA  //Descricao ENG				
			   			'@!','',cUsadoOpc,;							        					//Picture   //VALID          //USADO				
						'','',1,;							   						 			//RELACAO	//F3   			 //NIVEL							
			   			cReservOpc,'','','','N','A',;						                    //RESERV    //CHECK,         //TRIGGER,     //PROPRI,  //BROWSE, //VISUAL			
			   			'R','','',;						                                    	//CONTEXT,  //OBRIGAT,       //VLDUSER
						'','','',;																//CBOX,     //CBOX SPA,      //CBOX ENG
			   			'','','','','',''})										     			//PICTVAR,  //WHEN, 		 //INIBRW, 		//SXG, 	   //FOLDER, //PYME 	                    
			   			
		aAdd(aGravaSX,{ 'JMX','07','JMX_PROCES',;    	                          				//Arquivo,  //Ordem,         //Campo,
			   			'C',6,0,;					   				                            //Tipo,     //Tamanho,       //Decimal																    							
			   			'Cod Processo','Cod Processo','Cod Processo',;	                                //Titulo,   //Titulo SPA,    //Titulo ENG		    		
			   			'Codigo Processo Seletivo','Codigo Processo Seletivo','Codigo Processo Seletivo',;	//Descricao	//Descricao SPA  //Descricao ENG				
			   			'@!','',cUsadoOpc,;							        					//Picture   //VALID          //USADO				
						'','',1,;							   						 			//RELACAO	//F3   			 //NIVEL							
			   			cReservOpc,'','','','N','A',;						                    //RESERV    //CHECK,         //TRIGGER,     //PROPRI,  //BROWSE, //VISUAL			
			   			'R','','',;						                                    	//CONTEXT,  //OBRIGAT,       //VLDUSER
						'','','',;																//CBOX,     //CBOX SPA,      //CBOX ENG
			   			'','','','','',''})										     			//PICTVAR,  //WHEN, 		 //INIBRW
	                                                                                
		aAdd(aGravaSX,{ 'JMX','08','JMX_FASE',;    	                          			   		//Arquivo,  //Ordem,         //Campo,
			   			'C',3,0,;					   				                            //Tipo,     //Tamanho,       //Decimal																    							
			   			'Cod Fase PS','Cod Fase PS','Cod Fase PS',;	                            //Titulo,   //Titulo SPA,    //Titulo ENG		    		
			   			'Codigo da Fase do Process','Codigo da Fase do Process','Codigo da Fase do Process',;	//Descricao	//Descricao SPA  //Descricao ENG				
			   			'@!','',cUsadoOpc,;							        					//Picture   //VALID          //USADO				
						'','',1,;							   						 			//RELACAO	//F3   			 //NIVEL							
			   			cReservOpc,'','','','N','A',;						                    //RESERV    //CHECK,         //TRIGGER,     //PROPRI,  //BROWSE, //VISUAL			
			   			'R','','',;						                                    	//CONTEXT,  //OBRIGAT,       //VLDUSER
						'','','',;																//CBOX,     //CBOX SPA,      //CBOX ENG
			   			'','','','','',''})										     			//PICTVAR,  //WHEN, 		 //INIBRW
		
		aAdd(aGravaSX,{ 'JMX','09','JMX_DTNASC',;    	                          				//Arquivo,  //Ordem,         //Campo,
			   			'D',8,0,;					   				                            //Tipo,     //Tamanho,       //Decimal																    							
			   			'Data Nascime','Data Nascime','Data Nascime',;	                                //Titulo,   //Titulo SPA,    //Titulo ENG		    		
			   			'Data nascimento do Candid','Data nascimento do Candid','Data nascimento do Candid',;	//Descricao	//Descricao SPA  //Descricao ENG				
			   			'','',cUsadoOpc,;							        					//Picture   //VALID          //USADO				
						'','',1,;							   						 			//RELACAO	//F3   			 //NIVEL							
			   			cReservOpc,'','','','N','A',;						                    //RESERV    //CHECK,         //TRIGGER,     //PROPRI,  //BROWSE, //VISUAL			
			   			'R','','',;						                                    	//CONTEXT,  //OBRIGAT,       //VLDUSER
						'','','',;																//CBOX,     //CBOX SPA,      //CBOX ENG
			   			'','','','','',''})										     			//PICTVAR,  //WHEN, 		 //INIBRW
			   			
		aAdd(aGravaSX,{ 'JMX','10','JMX_PONMIN',;    	                          				//Arquivo,  //Ordem,         //Campo,
			   			'N',7,2,;					   				                            //Tipo,     //Tamanho,       //Decimal																    							
			   			'Pontua Min','Pontua Min','Pontua Min',;	                                //Titulo,   //Titulo SPA,    //Titulo ENG		    		
			   			'Pontuacao Minima Discipli','Pontuacao Minima Discipli','Pontuacao Minima Discipli',;	//Descricao	//Descricao SPA  //Descricao ENG				
			   			'@E 999,999.99','',cUsadoOpc,;							        					//Picture   //VALID          //USADO				
						'','',1,;							   						 			//RELACAO	//F3   			 //NIVEL							
			   			cReservOpc,'','','','N','A',;						                    //RESERV    //CHECK,         //TRIGGER,     //PROPRI,  //BROWSE, //VISUAL			
			   			'R','','',;						                                    	//CONTEXT,  //OBRIGAT,       //VLDUSER
						'','','',;																//CBOX,     //CBOX SPA,      //CBOX ENG
			   			'','','','','',''})										     			//PICTVAR,  //WHEN, 		 //INIBRW
	                                                                                
		aAdd(aGravaSX,{ 'JMX','11','JMX_PONSUB',;    	                          				//Arquivo,  //Ordem,         //Campo,
			   			'N',7,2,;					   				                            //Tipo,     //Tamanho,       //Decimal																    							
			   			'Pontua Subje','Pontua Subje','Pontua Subje',;	                        //Titulo,   //Titulo SPA,    //Titulo ENG		    		
			   			'Pontuacao Avaliacao Subje','Pontuacao Avaliacao Subje','Pontuacao Avaliacao Subje',;	//Descricao	//Descricao SPA  //Descricao ENG				
			   			'@E 999,999.99','',cUsadoOpc,;							        					//Picture   //VALID          //USADO				
						'','',1,;							   						 			//RELACAO	//F3   			 //NIVEL							
			   			cReservOpc,'','','','N','A',;						                    //RESERV    //CHECK,         //TRIGGER,     //PROPRI,  //BROWSE, //VISUAL			
			   			'R','','',;						                                    	//CONTEXT,  //OBRIGAT,       //VLDUSER
						'','','',;																//CBOX,     //CBOX SPA,      //CBOX ENG
			   			'','','','','',''})										     			//PICTVAR,  //WHEN, 		 //INIBRW
		
		aAdd(aGravaSX,{ 'JMX','12','JMX_DESEM',;    	                          				//Arquivo,  //Ordem,         //Campo,
			   			'C',1,0,;					   				                            //Tipo,     //Tamanho,       //Decimal																    							
			   			'Flag: Desemp','Flag: Desemp','Flag: Desemp',;	                        //Titulo,   //Titulo SPA,    //Titulo ENG		    		
			   			'Desempatou Candidato','Desempatou Candidato','Desempatou Candidato',;	//Descricao	//Descricao SPA  //Descricao ENG				
			   			'@!','',cUsadoOpc,;							        					//Picture   //VALID          //USADO				
						'','',1,;							   						 			//RELACAO	//F3   			 //NIVEL							
			   			cReservOpc,'','','','N','A',;						                    //RESERV    //CHECK,         //TRIGGER,     //PROPRI,  //BROWSE, //VISUAL			
			   			'R','','',;						                                    	//CONTEXT,  //OBRIGAT,       //VLDUSER
						'1=SIM;2=NAO','','',;													//CBOX,     //CBOX SPA,      //CBOX ENG
			   			'','','','','',''})										     			//PICTVAR,  //WHEN, 		 //INIBRW
			   			
		aAdd(aGravaSX,{ 'JMX','13','JMX_POSIPR',;    	                          				//Arquivo,  //Ordem,         //Campo,
			   			'C',5,0,;					   				                            //Tipo,     //Tamanho,       //Decimal																    							
			   			'Posicao Gera','Posicao Gera','Posicao Gera',;	                        //Titulo,   //Titulo SPA,    //Titulo ENG		    		
			   			'Posicao geral do candidat','Posicao geral do candidat','Posicao geral do candidat',;	//Descricao	//Descricao SPA  //Descricao ENG				
			   			'@!','',cUsadoOpc,;							        					//Picture   //VALID          //USADO				
						'','',1,;							   						 			//RELACAO	//F3   			 //NIVEL							
			   			cReservOpc,'','','','N','A',;						                    //RESERV    //CHECK,         //TRIGGER,     //PROPRI,  //BROWSE, //VISUAL			
			   			'R','','',;						                                    	//CONTEXT,  //OBRIGAT,       //VLDUSER
						'','','',;																//CBOX,     //CBOX SPA,      //CBOX ENG
			   			'','','','','',''})										     			//PICTVAR,  //WHEN, 		 //INIBRW
		
		aAdd(aGravaSX,{ 'JMX','14','JMX_ATGMIN',;    	                          				//Arquivo,  //Ordem,         //Campo,
			   			'C',1,0,;					   				                            //Tipo,     //Tamanho,       //Decimal																    							
			   			'Maior P.Min','Maior P.Min','Maior P.Min',;	                        //Titulo,   //Titulo SPA,    //Titulo ENG		    		
			   			'Atingiu Pontuacao Minima','Atingiu Pontuacao Minima','Atingiu Pontuacao Minima',;	//Descricao	//Descricao SPA  //Descricao ENG				
			   			'@!','',cUsadoOpc,;							        					//Picture   //VALID          //USADO				
						'','',1,;							   						 			//RELACAO	//F3   			 //NIVEL							
			   			cReservOpc,'','','','N','A',;						                    //RESERV    //CHECK,         //TRIGGER,     //PROPRI,  //BROWSE, //VISUAL			
			   			'R','','',;						                                    	//CONTEXT,  //OBRIGAT,       //VLDUSER
						'1=SIM;2=NAO','1=SIM;2=NAO','1=SIM;2=NAO',;								//CBOX,     //CBOX SPA,      //CBOX ENG
			   			'','','','','',''})										     			//PICTVAR,  //WHEN, 		 //INIBRW
			   				   					
		aAdd(aGravaSX,{ 'JMX','15','JMX_ORDEM ',;    	                          				//Arquivo,  //Ordem,         //Campo,
			   			'N',2,0,;					   				                            //Tipo,     //Tamanho,       //Decimal																    							
			   			'Ordem Desemp','Ordem Desemp','Ordem Desemp',;	                        //Titulo,   //Titulo SPA,    //Titulo ENG		    		
			   			'Ordem Desemp Discip','Ordem Desemp Discip','Ordem Desemp Discip',;	//Descricao	//Descricao SPA  //Descricao ENG				
			   			'99','',cUsadoOpc,;							        					//Picture   //VALID          //USADO				
						'','',1,;							   						 			//RELACAO	//F3   			 //NIVEL							
			   			cReservOpc,'','','','N','A',;						                    //RESERV    //CHECK,         //TRIGGER,     //PROPRI,  //BROWSE, //VISUAL			
			   			'R','','',;						                                    	//CONTEXT,  //OBRIGAT,       //VLDUSER
						'','','',;							  									//CBOX,     //CBOX SPA,      //CBOX ENG
			   			'','','','','',''})										     			//PICTVAR,  //WHEN, 		 //INIBRW
		
		
		//Grava tudo do vetor aGravaSx no SX3
		For i:= 1 to len(aGravaSX)	
			RecLock("SX3",.T.)
			For j:=1 To Len(aGravaSX[i])
				If FieldPos(aEstrut[j])>0 .And. aGravaSX[i,j] != NIL
					FieldPut(FieldPos(aEstrut[j]),aGravaSX[i,j])
				EndIf
			Next j
			SX3->(MsUnLock())
		Next i
		conout(Dtoc( date() )+" "+Time()+' Tabela JMX gravada com sucesso em SX3'+alltrim(aRecnoSM0[nI,2])+'0')
	endif
	    
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCria os indices da tabela JMX ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 
	dbSelectArea('SIX')
	SIX->(dbSetOrder(1))
	if SIX->(!dbSeek('JMX'))
		aGravaSx := {}
		                        
		//Adiciona os novos campos em um vetor e o utiliza o vetor aEstrut como base no RecLock
		aEstrut    := {"INDICE","ORDEM","CHAVE","DESCRICAO","DESCSPA","DESCENG","PROPRI","F3","NICKNAME","SHOWPESQ"}
		aAdd(aGravaSx,{"JMX","1","JMX_FILIAL+JMX_CODCAN","Cod. Candida","Cod. Candida","Cod. Candida",'S',"","","S"})
		aAdd(aGravaSx,{"JMX","2","JMX_FILIAL+JMX_PROCES+JMX_FASE+JMX_CODCUR","Cod Processo+Cod Fase PS+Cod Curso","Cod Processo+Cod Fase PS+Cod Curso","Cod Processo+Cod Fase PS+Cod Curso",'S',"","","S"})		
		aAdd(aGravaSx,{"JMX","3","JMX_FILIAL+JMX_CODCUR","Cod Curso.","Cod Curso.","Cod Curso.",'S',"","","S"})		
		aAdd(aGravaSx,{"JMX","4","JMX_FILIAL+JMX_PROCES+JMX_FASE","Cod Processo+Cod Fase PS","Cod Processo+Cod Fase PS","Cod Processo+Cod Fase PS",'S',"","","S"})		
		//Grava tudo do vetor aGravaSx no SIX
		For i:=1 to Len(aGravaSx)
			RecLock('SIX',.T.)	
			For j:=1 To Len(aGravaSx[i])
				If FieldPos(aEstrut[j])>0
					FieldPut(FieldPos(aEstrut[j]),aGravaSx[i,j])
				EndIf
			Next j
			MsUnLock()
		Next i
		
		conout(Dtoc( date() )+" "+Time()+' Tabela JMX gravada com sucesso em SIX'+alltrim(aRecnoSM0[nI,2])+'0')
	endif
	     
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAtualiza o banco de dadosณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	X31UpdTable('JMX')
	TcRefresh("JMX")
	dbSelectArea('JMX')
	JMX->(dbSetOrder(1))
	JMX->(dbSetOrder(2))
	JMX->(dbSetOrder(3))
	JMX->(dbCloseArea())   
	
	
	

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCria o campo JAV_POSIPR (posicao geral do candidato no processo seletivoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
	dbSelectArea('SX3')
	SX3->(dbSetOrder(2))
	if SX3->(!dbSeek('JAV_POSIPR'))
			RecLock('SX3',.T.)
			SX3->X3_ARQUIVO :=  'JAV'
			SX3->X3_ORDEM   :=  '28'
			SX3->X3_CAMPO   :=  'JAV_POSIPR'
			SX3->X3_TIPO    :=  'N'
			SX3->X3_TAMANHO :=  5
			SX3->X3_DECIMAL :=  0
			SX3->X3_TITULO  :=  'Pos. Processo'
			SX3->X3_TITSPA  :=  'Pos. Processo'
			SX3->X3_TITENG  :=  'Pos. Processo'
			SX3->X3_DESCRIC :=  'Classificacao Geral PS'
			SX3->X3_DESCSPA :=  'Classificacao Geral PS'
			SX3->X3_DESCENG :=  'Classificacao Geral PS'
			SX3->X3_PICTURE :=  '99999'
			SX3->X3_VALID   :=  ''
			SX3->X3_USADO   :=  '€€€€€€€€€€€€€€ '
			SX3->X3_RELACAO :=  ''
			SX3->X3_NIVEL   :=  1
			SX3->X3_BROWSE  :=  'N'
			SX3->X3_VISUAL  :=  'A'
			SX3->X3_CONTEXT :=  'R'
			SX3->(msUnlock())
	
			X31UpdTable('JAV')
			TcRefresh("JAV")
	endif

	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAjusta descri็ใo JAV_POSICAณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
	dbSelectArea('SX3')
	SX3->(dbSetOrder(2))
	if SX3->(dbSeek('JAV_POSICA'))  
		 if RecLock('SX3',.F.)
		 	SX3->X3_TITULO  :=  'Pos. Curso'
			SX3->X3_TITSPA  :=  'Pos. Curso'
			SX3->X3_TITENG  :=  'Pos. Curso'
			SX3->X3_DESCRIC :=  'Classificacao por Curso'
			SX3->X3_DESCSPA :=  'Classificacao por Curso'
			SX3->X3_DESCENG :=  'Classificacao por Curso'
		 	SX3->(msUnlock())
		 endif
	endif
else	
	msgAlert('Imposs้vel continuar com a atualizacao na empresa '+aRecnoSM0[nI,2]+' O Sistema nใo possui a update 02 aplicada. Execute a atualizacao updgac02 antes de implementar esta atualiza็ใo')
	lRet := .F.
	
endif

Return(lRet)
                 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณMyOpenSM0Exณ Autor ณSergio Silveira       ณ Data ณ07/01/2003ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Efetua a abertura do SM0 exclusivo                         ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Atualizacao FIS                                            ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function MyOpenSM0Ex()
Local lOpen := .F. 
Local nLoop := 0 

For nLoop := 1 To 20  
	dbUseArea( .T.,, "sigamat.emp", "SM0", .F., .F. ) 	
	If !Empty( Select( "SM0" ) ) 
		lOpen := .T. 
		dbSetIndex("sigamat.ind") 
		Exit	
	EndIf
	Sleep( 500 ) 
Next nLoop

If !lOpen
	Aviso( "Atencao !", "Nao foi possivel a abertura da tabela de empresas de forma exclusiva !", { "Ok" }, 2 ) 
EndIf

Return(lOpen)

