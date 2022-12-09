#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณUPDGAC05  บAutor  ณCesar A. Bianchi    บ Data ณ  22/04/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMelhoria disponibilizada a partir do  BOPS 00000144126,     บฑฑ
ฑฑบ          ณpara re-estruturar a consulta acervos do SIGAGAC (gacc010)  บฑฑ 
ฑฑบ          ณeliminando a consulta via query-dinamica, pois esta em deterบฑฑ 
ฑฑบ       	 ณminados momentos excede o tamanho maximo permitido pelo top บฑฑ
ฑฑบ       	 ณ(Query Than 15980 bytes). Para ajuste da base de dados,     บฑฑ
ฑฑบ       	 ณorienta-se a execu็ใo da fix U_FIX144126()                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP811                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function UPDGAC05()
Local cMsg := ""         

cArqEmp := "SigaMAT.Emp"
__cInterNet := Nil

Private cMessage
Private aArqUpd	 := {}
Private aREOPEN	 := {}
Private oMainWnd          

Set Dele On

cMsg += "Este programa tem como objetivo ajustar os dicionแrios e base de dados, "
cMsg += "para compatibiliza็ใo com a melhoria de Consulta de Acervos. "
cMsg += "Esta rotina deve ser processada em modo exclusivo. "
cMsg += "Fa็a um backup dos dicionแrios e base de dados antes do processamento." 

oMainWnd := MSDIALOG():Create()
oMainWnd:cName := "oMainWnd"
oMainWnd:cCaption := "Atualiza็ใo do Cadastro de Publica็๕es x Autores"
oMainWnd:nLeft := 0
oMainWnd:nTop := 0
oMainWnd:nWidth := 640
oMainWnd:nHeight := 460
oMainWnd:lShowHint := .F.
oMainWnd:lCentered := .T.
oMainWnd:bInit := {|| if( Aviso( "Atualizador de Base", cMsg, {"Cancelar", "Prosseguir"}, 2 ) == 2 , ( Processa({|lEnd| Gac05Run(@lEnd)} , "Atualizador de Base" ) , oMainWnd:End() ), ( MsgAlert( "Opera็ao cancelada!" ), oMainWnd:End() ) ) }

oMainWnd:Activate()

                                
Return(.T.)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGac05Run  บAutor  ณCesar A Bianchi     บ Data ณ  22/04/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAjuste dicionarios SX's                                     บฑฑ
ฑฑบ          ณExecuta a Funcao de Ajuste de Dicionarios p/ cada empresa   บฑฑ
ฑฑบ		     ณpresente no sigamat.emp	                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP811                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function Gac05Run(lEnd)
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
				
			    //Ajuste
				UpdGAC05Go()
											
				IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Ajuste de Dicionแrios")						
				Conout( dtoc( Date() )+" "+Time()+" "+"Fim - Ajuste de Dicionแrios")
		    	nI++
		    	cTexto := "Fim - Ajuste de Dicionแrios..."+CHR(13)+CHR(10)
		    EndDo
		    
	endif
endif

MsgAlert('Processamento Finalizado.')
	         
Return()    

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณUpdGAC05GoบAutor  ณCesar A Bianchi     บ Data ณ  17/04/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Realiza o ajuste do dicionario de dados                    บฑฑ  
ฑฑบ          ณ Cria os campos e indices _public nas tabelas JMR e JMS     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function UpdGAC05Go()
Local aArea := getArea()
Local aGravaSx := {}
Local i := 1
Local j := 1 
                   
//Cria os campo _public nas tabelas JMR e JMS
dbSelectArea('SX3')
SX3->(dbSetOrder(2))
if SX3->(!dbSeek('JMR_PUBLIC') )
    RecLock('SX3',.T.)
	SX3->X3_ARQUIVO := 'JMR'
	SX3->X3_ORDEM := '07'
	SX3->X3_CAMPO := 'JMR_PUBLIC'
	SX3->X3_PICTURE  := '@!'
	SX3->X3_TAMANHO  := 10
	SX3->X3_DECIMAL  := 0
	SX3->X3_VALID    := ''
	SX3->X3_USADO    := '€€€€€€€€€€€€€€ฐ'
	SX3->X3_TIPO     := 'C'
	SX3->X3_VISUAL   := 'V'	
	SX3->X3_RELACAO  := 'M->JM0_PUBLIC'	
	SX3->X3_TITULO   := 'C๓d. Public'	
	SX3->X3_PROPRI   := 'S'	
	SX3->X3_CONTEXT  := 'R'   
	SX3->X3_NIVEL	 := 1
	SX3->(msUnlock())     
endif

if SX3->(!dbSeek('JMS_PUBLIC') )
    RecLock('SX3',.T.)
	SX3->X3_ARQUIVO := 'JMS'
	SX3->X3_ORDEM := '07'
	SX3->X3_CAMPO := 'JMS_PUBLIC'
	SX3->X3_PICTURE  := '@!'
	SX3->X3_TAMANHO  := 10
	SX3->X3_DECIMAL  := 0
	SX3->X3_VALID    := ''
	SX3->X3_USADO    := '€€€€€€€€€€€€€€ฐ'
	SX3->X3_TIPO     := 'C'
	SX3->X3_CONTEXT  := 'R'
	SX3->X3_TITULO   := 'C๓d. Public'  
	SX3->X3_RELACAO  := 'M->JM0_PUBLIC'	
	SX3->X3_VISUAL   := 'V'			
	SX3->X3_PROPRI   := 'S'
	SX3->X3_NIVEL	 := 1
	SX3->(msUnlock())    
endif
         
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCria os indices das tabelas JMS e JMR ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 
	dbSelectArea('SIX')
	SIX->(dbSetOrder(1))
	if SIX->(!dbSeek('JMR3'))
		aGravaSx := {}
		                        
		//Adiciona os novos campos em um vetor e o utiliza o vetor aEstrut como base no RecLock
		aEstrut    := {"INDICE","ORDEM","CHAVE","DESCRICAO","DESCSPA","DESCENG","PROPRI","F3","NICKNAME","SHOWPESQ"}
		aAdd(aGravaSx,{"JMR","3","JMR_FILIAL+JMR_PUBLIC","Cod Publica.","Cod Publica.","Cod Publica.",'S',"","","S"})
		aAdd(aGravaSx,{"JMS","3","JMS_FILIAL+JMS_PUBLIC","Cod Publica","Cod Publica","Cod Publica",'S',"","","S"})		
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
	endif     
     
        
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAtualiza o banco de dadosณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//JMS
	X31UpdTable('JMS')
	TcRefresh("JMS")
	dbSelectArea('JMS')
	JMS->(dbSetOrder(3))
	JMS->(dbCloseArea()) 
	//JMR
	X31UpdTable('JMR')
	TcRefresh("JMR")
	dbSelectArea('JMR')
	JMR->(dbSetOrder(3))
	JMR->(dbCloseArea())      

restArea(aArea)
Return 
            

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
