#include "Protheus.ch"
#include "Fileio.ch"
 
User Function LeArqPISCOF()
 
Private nOpc 		:= 0
Private cCadastro 	:= "Ler arquivo texto"
Private aSay 		:= {}
Private aButton 	:= {}
Private aDados	 	:= {} 
Private aDadosSRV	:= {}
Private aRegs		:= {}
Private _aCabec     := {} 
Private _aCabecSRV 	:= {}
Private cVar 		:= " " 
Private nNumero 	:= 0 
Private nSerie 		:= 0       
Private nValor 		:= 0
Private nCount 		:= 0  
Private cNew := " "
Private 	nOpc := 1
Private 	REG
Private		IND_OPER
Private		IND_EMIT
Private		COD_PART
Private		COD_MOD
Private		COD_SIT
Private		SER
Private		NUM_DOC
Private		CHV_NFE
Private		DT_DOC
Private		DT_E_S
Private		VL_DOC
Private		IND_PGTO
Private		VL_DESC
Private		VL_ABAT_NT
Private		VL_MERC
Private		IND_FRT
Private		VL_FRT
Private		VL_SEG
Private		VL_OUT_DA
Private		VL_BC_ICMS
Private		VL_ICMS
Private		VL_BC_ICMS_ST
Private		VL_ICMS_ST
Private		VL_IPI
Private		VL_PIS
Private		VL_COFINS
Private		VL_PIS_ST
Private		VL_COFINS_ST 
Private		SUB
Private 	CHV_NFSE
Private 	DT_EXE_SERV
Private 	VL_BC_PIS
Private		VL_BC_COFINS
Private 	VL_PIS_RET
Private 	VL_COFINS_RET




Aadd(aRegs,{"PISCOFINSA","01","Produto / Serviço           ?","","","mv_chA","N",01,00,01,"C","","mv_par01","Produto","Produto","Produto","","Serviço","Serviço","Serviço","","","","","","","",""})
 
ValidPerg(aRegs,"PISCOFINSA")

Pergunte("PISCOFINSA",.F.)

aAdd(aSay, "O objetivo desta rotina e efetuar a leitura em um arquivo texto") 

aAdd(aButton, {5,.T.,{|| Pergunte("PISCOFINSA",.T. ) } } ) 
aAdd(aButton, {1,.T.,{|| nOpc := 1, FechaBatch()}})
aAdd(aButton, {2,.T.,{|| FechaBatch() }})
 
FormBatch(cCadastro,aSay,aButton)
 
if nOpc == 1
 Processa({|| Import() }, "Processando...")
endif
 
Return
              
Static Function Import()
 
Local cBuffer := ""
Local cFileOpen := ""
Local cTitulo1 := "Selecione o arquivo"
Local cExtens := "Arquivo Txt | *.txt | *. "
Local cMainpath := "C:\"
 
/*
cGetfile(ca,cb,nc,cd,le,nf)
ca - Expressao de filtro
cb - Titulo da janela
nc - Numero de mascara default 1 para *.EXE
cd - Diretorio inicial se necessario
le - .F. botao salvar - .T. botao abrir
nf - Mascara de bits para escolher a visualizacao do objeto
*/                             

//aAdd(_aCabec, {"Nota"},{"Serie"})

 		aAdd( _aCabec	,{	"REG",;
							"IND_OPER",;
							"IND_EMIT",;
							"COD_PART",;
							"COD_MOD",;
							"COD_SIT",;
							"SER",;
							"NUM_DOC",;
							"CHV_NFE",;
							"DT_DOC",;
							"DT_E_S",;
							"VL_DOC",;
							"IND_PGTO",;
							"VL_DESC",;
							"VL_ABAT_NT",;
							"VL_MERC",;
							"IND_FRT",;
							"VL_FRT",;
							"VL_SEG",;
							"VL_OUT_DA",;
							"VL_BC_ICMS",;
							"VL_ICMS",;
							"VL_BC_ICMS_ST",;
							"VL_ICMS_ST",;
							"VL_IPI",;
							"VL_PIS",;
							"VL_COFINS",;
							"VL_PIS_ST",;
							"VL_COFINS_ST", })
							
		aAdd( _aCabecSRV ,{	"REG",;
							"IND_OPER",;
							"IND_EMIT",;
							"COD_PART",;
							"COD_SIT",;
							"SER",;
							"SUB",;
							"NUM_DOC",;
							"CHV_NFSE",;
							"DT_DOC",;
							"DT_EXE_SERV",;
							"VL_DOC",;
							"IND_PGTO",;
							"VL_DESC",;
							"VL_BC_PIS",;
							"VL_PIS",;
							"VL_BC_COFINS",;
							"VL_COFINS",;
							"VL_PIS_RET",;
							"VL_COFINS_RET",;
							"VL_ISS", })   
			  
 
cFileOpen := cGetFile(cExtens,cTitulo1,,cMainpath,.T.)
 
if !File(cFileOpen)
 
 MsgAlert("Arquivo texto: "+cFileOpen+" nao localizado",cCadastro)
 Return
 
endif
 
FT_FUSE(cFileOpen)  //abrir
FT_FGOTOP() //vai para o topo
Procregua(FT_FLASTREC())  //quantos registros para ler

While !FT_FEOF()
 
 IncProc()
 
 //Capturar dados
 cBuffer := FT_FREADLN()  //lendo a linha
 
 cVar := Substr(cBuffer,2,4)   //Grava linha do Sped - Pis/Cofins
 
 If MV_PAR01 == 1              //Nota serie 2
 	If cVar == "C100"
 		
 		I 	 := 1 
 		W 	 := 1 
 		X 	 := 1 
 		w 	 := 2
 	
 		
 		For i:= 1 To Len(cBuffer)  
 		
 		IF i > 2 
 	 		w := i + 1
 	    Endif
 		
 			If Substr(cBuffer,i,x) <> "|"    
 				
 					cNew += Substr(cBuffer,i,x) 
 				    
 				    z:=i+1     
 				    cProx := Substr(cBuffer,z,x)
 				    If cProx == "|"
 				          GravaDadosProd()
 				    Endif
 				
  	     	Elseif Substr(cBuffer,i,x) = "|" .AND. Substr(cBuffer,w,1) = "|"
 	     			
 	     			cNew := "0"
 	     			
 	     			GravaDadosProd()
 	     			
 	     			
 			Endif    
 	   		
 				 			  		    
 		    
 		 Next i
    EndIf 
 Endif
 
 IF MV_PAR01 == 2         // Nota serie RPS
 	If cVar == "A100"
 	  
 		I 	 := 1 
 		W 	 := 1 
 		X 	 := 1 
 		w 	 := 2
 	
 		
 		For i:= 1 To Len(cBuffer)  
 		
 		IF i > 2 
 	 		w := i + 1
 	    Endif
 		
 			If Substr(cBuffer,i,x) <> "|"    
 				
 					cNew += Substr(cBuffer,i,x) 
 				    
 				    z:=i+1     
 				    cProx := Substr(cBuffer,z,x)
 				    If cProx == "|"
 				          U_GravaSrv()
 				    Endif
 				
  	     	Elseif Substr(cBuffer,i,x) = "|" .AND. Substr(cBuffer,w,1) = "|"
 	     			
 	     			cNew := "0"
 	     			
 	     			U_GravaSrv()
 	     			
 	     			
 			Endif    
 	   		
 				 			  		    
 		    
 		 Next i
 				
 	EndIf
 EndIf 
  
 FT_FSKIP()   //proximo registro no arquivo txt
 
Enddo
 
FT_FUSE()  //fecha o arquivo txt 

If MV_PAR01 == 1
	DlgToExcel({ {"ARRAY","SPED - PIS/COFINS", _aCabec, aDados} }) 
	Msginfo("Processo Finalizada - Nota de Produto")
Else
	DlgToExcel({ {"ARRAY","SPED - PIS/COFINS", _aCabecSRV, aDadosSRV} })
	Msginfo("Processo Finalizada - Nota de Servico")
EndIF

Return


Static Function GravaDadosProd()     

 	   		Do Case 
 	   		Case nOpc == 1
 	   		REG := cNew
   			Case nOpc == 2
   			IND_OPER:= cNew
			Case nOpc == 3
			IND_EMIT:= cNew
			Case nOpc ==  4
			COD_PART:= cNew
			Case nOpc ==  5
			COD_MOD:= cNew
			Case nOpc == 6
			COD_SIT:= cNew
			Case nOpc ==  7
			SER:= cNew
			Case nOpc == 8
			NUM_DOC:= cNew
			Case nOpc == 9
			CHV_NFE:= cNew
			Case nOpc == 10
			DT_DOC:= cNew
			Case nOpc == 11
			DT_E_S:= cNew
			Case nOpc == 12
			VL_DOC:= cNew
			Case nOpc == 13
			IND_PGTO:= cNew
			Case nOpc == 14
			VL_DESC:= cNew
			Case nOpc == 15
			VL_ABAT_NT:= cNew
			Case nOpc == 16
			VL_MERC:= cNew
			Case nOpc == 17
			IND_FRT:= cNew
			Case nOpc == 18
			VL_FRT:= cNew
			Case nOpc == 19
			VL_SEG:= cNew
			Case nOpc == 20
			VL_OUT_DA:= cNew
			Case nOpc == 21
			VL_BC_ICMS:= cNew
			Case nOpc == 22
			VL_ICMS:= cNew
			Case nOpc == 23
			VL_BC_ICMS_ST:= cNew
			Case nOpc == 24
			VL_ICMS_ST:= cNew
			Case nOpc == 25
			VL_IPI:= cNew
			Case nOpc == 26
			VL_PIS:= cNew
			Case nOpc == 27
			VL_COFINS:= cNew
			Case nOpc == 28
			VL_PIS_ST:= cNew
			Case nOpc == 29
			VL_COFINS_ST:= cNew
			EndCase
			
			cNew := " " 
			
			IF nOpc == 29
	
	 		aAdd( aDados,{	REG,;
							IND_OPER,;
							IND_EMIT,;
							COD_PART,;
							COD_MOD,;
							COD_SIT,;
							SER,;
							NUM_DOC,;
							CHV_NFE,;
							DT_DOC,;
							DT_E_S,;
							VL_DOC,;
							IND_PGTO,;
							VL_DESC,;
							VL_ABAT_NT,;
							VL_MERC,;
							IND_FRT,;
							VL_FRT,;
							VL_SEG,;
							VL_OUT_DA,;
							VL_BC_ICMS,;
							VL_ICMS,;
							VL_BC_ICMS_ST,;
							VL_ICMS_ST,;
							VL_IPI,;
							VL_PIS,;
							VL_COFINS,;
							VL_PIS_ST,;
							VL_COFINS_ST, })
			
		            nOpc := 0
				

	Endif
		
			nOpc++ 
Return
			
			
User Function GravaSrv() 	 

	Do Case 
 	   		Case nOpc == 1
 	   		REG := cNew
   			Case nOpc == 2
   			IND_OPER:= cNew
			Case nOpc == 3
			IND_EMIT:= cNew
			Case nOpc ==  4
			COD_PART:= cNew
			Case nOpc ==  5
			COD_SIT:= cNew
			Case nOpc == 6
			SER:= cNew
			Case nOpc ==  7
			SUB:= cNew  
			Case nOpc == 8
			NUM_DOC:= cNew
			Case nOpc == 9
			CHV_NFSE:= cNew
			Case nOpc == 10   
			DT_DOC := cNew
			Case nOpc == 11
			DT_EXE_SERV := cNew
			Case nOpc == 12
			VL_DOC := cNew
			Case nOpc == 13 
			IND_PGTO := cNew
			Case nOpc == 14
			VL_DESC := cNew
			Case nOpc == 15
			VL_BC_PIS := cNew
			Case nOpc == 16
			VL_PIS := cNew
			Case nOpc == 17
			VL_BC_COFINS := cNew
			Case nOpc == 18
			VL_COFINS := cNew
			Case nOpc == 19
			VL_PIS_RET := cNew
			Case nOpc == 20
			VL_COFINS_RET := cNew
			Case nOpc == 21
			VL_ISS := cNew	
	EndCase	
     
	cNew := " "
            If nOpc >= 21
             
			aAdd( aDadosSRV,{	REG,;
								IND_OPER,;
								IND_EMIT,;
								COD_PART,;
								COD_SIT,;
								SER,;
								SUB,;
								NUM_DOC,;
								CHV_NFSE,;
								DT_DOC,;
								DT_EXE_SERV,;
								VL_DOC,;
								IND_PGTO,;
								VL_DESC,;
								VL_BC_PIS,;
								VL_PIS,;
								VL_BC_COFINS,;
								VL_COFINS,;
								VL_PIS_RET,;
								VL_COFINS_RET,;
								VL_ISS, }) 
								
								nOpc:= 0  
				Endif
								
				nOpc++

Return	