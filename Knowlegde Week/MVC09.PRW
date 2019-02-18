#include "protheus.ch"
#include "fwmvcdef.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} MVC09
Exemplo de subView, o uso da funcionalidade é chamado no 
MenuDef do fonte MVC05

@since 01/06/2018
/*/
//-------------------------------------------------------------------
Static Function ViewDef()
Local oModel := FWLoadModel("MVC05")
Local oView := FWFormView():New()
Local oStrZB5:= FWFormStruct(2, 'ZB5')   
Local oStrZB6:= FWFormStruct(2, 'ZB6')

    oStrZB6:RemoveField('ZB6_CODTUR')

    oView:SetModel(oModel)       
    
	oView := FWFormView():New()  
	oView:SetModel(oModel)    

	oView:AddField('FORM_TURMA' , oStrZB5,'MASTERZB5' )  
	oView:AddGrid('FORM_ALUNOS' , oStrZB6,'DETAILZB6')  
			
	oView:CreateHorizontalBox( 'BOX_FORM_TURMA', 30)  
	oView:CreateHorizontalBox( 'BOX_FORM_ALUNOS', 70)  
			
 	oView:SetOwnerView('FORM_TURMA','BOX_FORM_TURMA')  
 	oView:SetOwnerView('FORM_ALUNOS','BOX_FORM_ALUNOS')  
 	    
    oView:AddUserButton('Notas do Aluno','',{|oView|ShowNotas(oView)},'Adiciona notas para um aluno')
Return oView 

Static Function ShowNotas(oView)
Local oViewNotas := getViewNotas(oView)

    oExecView := FWViewExec():New()
    oExecView:setTitle("Notas do Aluno")
    oExecView:setView(oViewNotas)    
    oExecView:setReduction(10)					
    oExecView:setOperation(oView:GetModel():GetOperation())
    oExecView:openView(.F.)
    
Return

Static Function getViewNotas(oViewOwner)
Local oViewNotas := FWFormView():New(oViewOwner)
Local oModel := oViewOwner:GetModel()
Local oStruZB7:= FWFormStruct(2, 'ZB7')

    oStruZB7:RemoveField('ZB7_CODTUR')
    oStruZB7:RemoveField('ZB7_RA')

    oViewNotas:SetModel(oModel)
    oViewNotas:AddGrid('FORM_NOTA' , oStruZB7,'DETAILZB7')     
    oViewNotas:CreateHorizontalBox( 'BOX_FORM_NOTA', 100)
    oViewNotas:SetOwnerView('FORM_NOTA','BOX_FORM_NOTA') 	
    oViewNotas:SetCloseOnOk({|| .T.})

Return oViewNotas


