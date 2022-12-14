({
    doInit: function(component, event, helper) {
        helper.getcurr(component, event, helper);
        helper.getmulticur(component, event, helper);
        component.set('v.now', Date.now());
        component.set('v.islistview', true);
          component.set('v.Ispin', true); 
        component.set('v.columns', [
               {label: 'RFQ #', fieldName: 'Id', type: 'url',
               typeAttributes: {
               label: {
               fieldName: 'WhatName'
               },
               target: '_self'
               }
               },
               //{label: 'RFQ', fieldName: 'RFQName', type: 'text'},
               /*{label: 'RFQ', fieldName: 'RFQName', type: 'url',
            typeAttributes: {
            label: {
            fieldName: 'RFQID'
            },
            target: '_self'
            }},*/
               {label: 'RFQ Description', fieldName: 'RFQName', type: 'Text'},
               {label: 'Status', fieldName: 'buildertek__Status__c', type: 'Picklist'},
               /*{label: 'Quote Amount', fieldName: 'buildertek__Quote_Amount__c', type: 'currency'},*/
                   {label: 'Quote Amount', fieldName: 'buildertek__Quote_Amount__c', type: 'currency',
                    typeAttributes: { currencyCode: { fieldName: 'CurrencyIso' }, currencyDisplayAs: "code" },
                    cellAttributes: {
                        class: 'slds-grid slds-grid_align-spread',
                    },
                   },
               {label: 'Open RFI', fieldName: 'buildertek__Open_RFI__c', type: 'Number'},
               
           ]);   
           
       // helper.getrelatedrfqvendorlist(component, event, helper);
            var testabc = component.get('v.columns');
            console.log('testing ==> ',testabc);
            helper.getuser(component, event, helper);
            helper.getvalues(component, event, helper);
            helper.getRFQListViews(component, event, helper);
            
            
        
    },
    viewRecord : function(component, event, helper) {
        var recId = event.getParam('row').Id;
        var actionName = event.getParam('action').name;
        if ( actionName == 'Edit' ) {
            // alert('Edit');
            var editRecordEvent = $A.get("e.force:editRecord");
            editRecordEvent.setParams({
                "recordId": recId
            });
            editRecordEvent.fire();
        } else if ( actionName == 'View') {
            //alert('view');
            var viewRecordEvent = $A.get("e.force:navigateToURL");
            viewRecordEvent.setParams({
                "url": "/" + recId
            });
            viewRecordEvent.fire();
        }
    }
    ,
    
    onSave : function( component, event, helper ) {   
        
        var updatedRecords = component.find( "itemsTable" ).get( "v.draftValues" );  
        //alert('hi');
        //alert(updatedRecords);
        //alert(JSON.stringify(updatedRecords));
        //alert(JSON.stringify(component.get("v.UpdatedList")));
        var action = component.get( "c.updateVendorItems" );  
        action.setParams({  
            
            'updatedItemsList' : updatedRecords  
            
        });  
        action.setCallback( this, function( response ) {  
            
            var state = response.getState();  
            //alert(state); 
            //alert(response.getReturnValue()); 
            if ( state === "SUCCESS" ) {  
                
                if ( response.getReturnValue() === true ) {  
                    
                    helper.toastMsg( 'success', 'Records Saved Successfully.' );  
                    //component.find( "itemsTable" ).set( "v.draftValues", null );  
                    location.reload();
                } else {   
                    
                    helper.toastMsg( 'error', 'Something went wrong. Contact your system administrator.' );  
                    
                }  
                
            } else {  
                
                helper.toastMsg( 'error', 'Something went wrong. Contact your system administrator.' );  
                
            }  
            
        });  
        $A.enqueueAction( action );  
        
    },
    
    searchKeyChange: function(component, event) {
        var list = component.get("v.RFQVendorLineList");
        var lis = component.get("v.selectedListViewName");
       // alert(lis);
           // alert('list'+ JSON.stringify(list));
           // alert(component.get("v.selectedListViewName"))
        var searchKey = component.find("searchKey").get("v.value");
           // alert('searchKey....'+searchKey);
        var action = component.get("c.findByName");
        action.setParams({
            "searchKey": searchKey,
             recId : component.get("v.rfqrecordId"),
            listname : component.get("v.selectedListViewName"),
        });
        action.setCallback(this, function(a) {
            var result = a.getReturnValue();
            //alert( JSON.stringify(result));
            for ( var i = 0; i < result.length; i++ ) {
                var row = result[i];
               // alert(row);
                row.RFQName = row.buildertek__RFQ__r.Name;
                var rfqauto =  row.buildertek__RFQ__r.buildertek__Auto_Number__c.split("-");
                row.WhatName = 'RFQ' +' - '+ rfqauto[1]; 
                row.Id = '/vendor/s/rfq-to-vendor/' + row.Id;
            }
            console.log('RFQVendorLineList 1 => ', {result});
            component.set("v.RFQVendorLineList",result);
        });
        $A.enqueueAction(action);
/*if(searchKey == ''){
    alert("hai");
     
    
}*/
        
    },
    
         handleClick : function( component, event, helper ) { 
           //  alert("hai");
         component.set('v.Ispinned', true); 
        component.set('v.Ispin', false);  
        var listViewMap = JSON.parse(JSON.stringify(component.get("v.listViewMap")));
        var listviewid = component.get("v.listviewName");
        var listviewname = component.get("v.selectedListViewName");
             
      //  alert(component.get("v.listviewName"));
      //  alert(component.get("v.selectedListViewName")); 
         var action = component.get("c.updatecustomsettings");
         action.setParams({
                "listviewid":component.get("v.listviewName"),
                "listviewname" :component.get("v.selectedListViewName")
                
            })
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                 component.set('v.Ispinned', true);
                $A.get('e.force:refreshView').fire();
                var results= response.getReturnValue(); 
               
            }
        });
        $A.enqueueAction(action);
        
          
        
    },
    

    
    handleListViewChange : function( component, event, helper ) { 
        //alert(component.get("v.listviewName"));
        component.set("v.loaded", true);

           var listview = component.get("v.listviewName");
           console.log({listview});
         var listviews = component.get("v.selectedListViewName");
        var currentuser = component.get("v.currentUserList");
        console.log({currentuser});
        var customsettings = component.get("v.Vendorlist");
        console.log({customsettings});
        if(customsettings[0]['RFQListId__c'] == listview ){
            component.set('v.Ispin', false);
            component.set('v.Ispinned', true);
        }else{
            component.set('v.Ispin', true);
            component.set('v.Ispinned', false);
        }
         if(customsettings[0]['RFQUser__c'] != currentuser && customsettings[0]['RFQListId__c'] == listview ){
            // alert("oye");
            component.set('v.Ispin', true);
            component.set('v.Ispinned', false);
        
        }
        var listViewMap = JSON.parse(JSON.stringify(component.get("v.listViewMap")))
        console.log(listViewMap)
      /*  const output = listViewMap.reduce((acc, a) => 
                                    ((acc[''+a.key] = acc[''+a.key] || []).push(a), acc), {})
        console.log(output);*/
        
        var selectedView = ''
        for(var i=0;i<listViewMap.length;i++){
            if(listViewMap[i]['key'] == event.getSource().get("v.value")){
                selectedView = listViewMap[i]['value']
                break;
            }
        }
        component.set("v.selectedListViewName",selectedView)
        if(selectedView == 'All'){
            helper.getrelatedrfqvendorlist(component, event, helper);
            
            //$A.get('e.force:refreshView').fire();
            //location.reload();
           //  var action = component.get("c.doInit");
            //$A.enqueueAction(action)
           
        }else{
            var action = component.get("c.getListViewQuery");
            
            action.setParams({
                "listViewId":component.get("v.listviewName"),
                "objName" : "buildertek__RFQ_To_Vendor__c"
                
            })
            action.setCallback(this,function(response){
                
                console.log(JSON.stringify(response.getReturnValue()));
                
                var result = response.getReturnValue().RFQVendorList;
             //  alert('result'+JSON.stringify(result));
                console.log(JSON.stringify(result));
                console.log({result});
				console.log('GET List View');
                console.log('state>>>'+response.getState());
                if(response.getState() == 'SUCCESS'){
                    if(response.getReturnValue().Issuccess == true){
                    //console.log('!!!!!'+JSON.stringify(result));
                    
                    for ( var i = 0; i < result.length; i++ ) {
                        var row = result[i];
                       
                        // if ( row.buildertek__RFQ__c) {
                        row.RFQName = row.buildertek__RFQ__r.Name;
                        
                        var rfqauto =  row.buildertek__RFQ__r.buildertek__Auto_Number__c.split("-");
                        row.WhatName = 'RFQ ' +' - '+ rfqauto[1]; 
                        row.Id = '/vendor/s/rfq-to-vendor/' + row.Id;
                    }
                    
                       
                    console.log('RFQVendorLineList 2 => ', {result});
                    component.set("v.RFQVendorLineList",result);
                }else{
                    console.log(response.getReturnValue().message);
                }
                component.set("v.loaded", false);
                    
                }else{
                    component.set("v.loaded", false);
                    //alert('ERROR');
                    //alert(JSON.stringify(response.getError()));
                }
                
            });
            $A.enqueueAction(action);
        }
        
        
    }
    
    
})