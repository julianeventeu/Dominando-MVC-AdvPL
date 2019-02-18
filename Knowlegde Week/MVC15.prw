#include "protheus.ch"
#include "fwmvcdef.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} MVC05
Exemplo de grid com "markbrowse" (coluna de selecao)

@since 01/06/2018
/*/
//-------------------------------------------------------------------
User Function MVC15()
Local oBrowse
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('ZB5')
	oBrowse:SetDescription('Cadastro de Turma x Aluno x Nota')
	oBrowse:Activate()
Return

Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MVC15' OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.MVC15' OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.MVC15' OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.MVC15' OPERATION 5 ACCESS 0

Return aRotina

Static Function ModelDef()
Local oModel := FWLoadModel("MVC05")
Local oStruZB7 := oModel:GetModel("DETAILZB7"):GetStruct()

    oStruZB7:DeActivate()
    oStruZB7:AddField('SELECT', ' ', 'SELECT', 'L', 1, 0, , , {}, .F.,FWBuildFeature( STRUCT_FEATURE_INIPAD, ".F.")) 
    oStruZB7:Activate()

Return oModel

Static Function ViewDef()
Local oModel := ModelDef() 
Local oView 
Local oStrZB5:= FWFormStruct(2, 'ZB5')   
Local oStrZB6:= FWFormStruct(2, 'ZB6')
Local oStruZB7:= FWFormStruct(2, 'ZB7')  
    
    oStrZB6:RemoveField('ZB6_CODTUR')

    oStruZB7:RemoveField('ZB7_CODTUR')
    oStruZB7:RemoveField('ZB7_RA')
    oStruZB7:AddField( 'SELECT','01','SELECT','SELECT',, 'Check')    

	oView := FWFormView():New()  
	oView:SetModel(oModel)    

	oView:AddField('FORM_TURMA' , oStrZB5,'MASTERZB5' )  
	oView:AddGrid('FORM_ALUNOS' , oStrZB6,'DETAILZB6')  
	oView:AddGrid('FORM_NOTA' , oStruZB7,'DETAILZB7')     
	oView:AddOtherObject("PANEL_SEL",{|oPanel,oOtherObject| criaButtonSel(oPanel,oOtherObject)})

	oView:CreateHorizontalBox( 'BOX_FORM_TURMA', 20)  
	oView:CreateHorizontalBox( 'BOX_FORM_ALUNOS', 35)  
	oView:CreateHorizontalBox( 'BOX_FORM_NOTA', 35)   
	oView:CreateHorizontalBox( "BOX_SEL",10)

 	oView:SetOwnerView('FORM_NOTA','BOX_FORM_NOTA')  
 	oView:SetOwnerView('FORM_ALUNOS','BOX_FORM_ALUNOS')  
 	oView:SetOwnerView('FORM_TURMA','BOX_FORM_TURMA') 	
    oView:SetOwnerView('PANEL_SEL','BOX_SEL')    

Return oView 

Static Function criaButtonSel(oPanel,oOtherObject)
    TButton():New( 01, 10, "Selecionar Todos",oPanel,{|| SelGrid(oOtherObject)}, 60,10,,,.F.,.T.,.F.,,.F.,,,.F. )
Return

Static Function SelGrid(oOtherObject)
Local oGrid := oOtherObject:GetModel():GetModel("DETAILZB7")
Local nX
Local lValue
Local nLine := oGrid:GetLine()

    For nX:=1 to oGrid:Length()
        oGrid:GoLine(nX)
        If !oGrid:isDeleted()
            lValue := oGrid:GetValue("SELECT")
            oGrid:LoadValue("SELECT", !lValue)
        EndIf
    Next nX

    oGrid:GoLine(nLine)
    oOtherObject:oControl:Refresh('FORM_NOTA')

Return