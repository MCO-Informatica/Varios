#INCLUDE "PROTHEUS.CH" 
#INCLUDE "RWMAKE.CH"
#include "tbiconn.ch"

User Function ZTELAY()

  
	MsApp():New('SIGAEST') 
    oApp:CreateEnv()
     
    //Seta o tema do Protheus (SUNSET = Vermelho; OCEAN = Azul)
    PtSetTheme("STANDARD")
   
   
    //Define o programa de inicialização 
    oApp:bMainInit:= {|| MsgRun("Configurando ambiente...","Aguarde...",;
    {|| RpcSetEnv( "01","01", "JOANNIS", "JOANNIS", "", "", {"SZ1"}, , , ,  )}),;
    U_CADSZ1(),;
    Final("R O T I N A    F I N A L I Z A D A")}
    
    //Seta Atributos 
    __lInternet := .T.
    lMsFinalAuto := .F.
    oApp:lMessageBar:= .T. 
    oApp:cModDesc:= 'SIGAEST'
     
    //Inicia a Janela 
    oApp:Activate()
Return Nil