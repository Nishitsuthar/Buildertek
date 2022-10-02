public with sharing class PreviewPurchaseOrderController {
   
    @AuraEnabled
   public Static List<EmailTemplate> getTemplates(){
    List<Emailtemplate> temrec;
     if(Schema.sObjectType.Emailtemplate.fields.Id.isAccessible()&&
           Schema.sObjectType.Emailtemplate.fields.Name.isAccessible() &&
           Schema.sObjectType.Emailtemplate.fields.folderid.isAccessible() &&
           Schema.sObjectType.Folder.fields.Name.isAccessible()){
          // temrec = [Select Id, Name, folder.name from Emailtemplate where folder.name = 'BT PO' and Name !=:'Purchase Order Line Template'];
           temrec = [Select Id, Name, folder.name from Emailtemplate where folder.name = 'BT PO' and Name !=:'Purchase Order Approved Template' and  DeveloperName !=:'Purchase_Order_Template'];
           }
       return temrec;
   }
//    just coment
   @AuraEnabled
   public static string getPurchaseOrderLines(String recordId, String templateId){
        string templateBody = '';
       string templateBody1 = '';
       string templateBody2 = '';
       Contact con ;
       if(Schema.sObjectType.Contact.fields.Id.isAccessible()&&
           Schema.sObjectType.Contact.fields.Name.isAccessible() &&
           Schema.sObjectType.Contact.fields.email.isAccessible()  ){
           con = [select id, Email from Contact where email != null order by createddate desc limit 1 ];
           }
       String[] toaddres;
       toaddres = new String[]{con.email};
       Savepoint sp = Database.setSavepoint();
       list<Messaging.SingleEmailMessage> msgList= new List<Messaging.SingleEmailMessage>(); 
       list<Messaging.SingleEmailMessage> msgList1= new List<Messaging.SingleEmailMessage>(); 
       List<String> templateList = new List<String>();
       Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
       
       string theTemplate = [SELECT Id FROM EmailTemplate WHERE Id =: templateId].Id; 
       email.setTemplateId(theTemplate);
       email.setWhatId(recordId);                        
       email.setTargetObjectId(con.Id);       
       email.setSaveAsActivity(true);
       email.setToAddresses(toaddres);
       msgList.add(email);
       
       Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
       System.debug('Email Results isSuccess = ' +  r[0].IsSuccess());
       Database.rollback(sp); 
       for (Messaging.SingleEmailMessage emailNew : msgList) {                   
           templateBody1 = emailNew.getHTMLBody(); 
       }
       templateBody = templateBody1 ;
       system.debug('Final templateBody ----------> '+templateBody);
       return templateBody;
       
   }
   
   @AuraEnabled
    public static List<String> sendProposal(String htmlBody, String recordId, String templateId, List<String> to, List<String> cc,String fileid, List<Id> attacheDocs){
        
        List<string> stringList = new List<string>();
        string apexData = 'Start';
        stringList.add(apexData);

        try{

            apexData = 'htmlBody => '+htmlBody;
            stringList.add(apexData);
            apexData = 'recordId => '+recordId;
            stringList.add(apexData);
            apexData = 'templateId => '+templateId;
            stringList.add(apexData);

            apexData = 'Step 1';
            stringList.add(apexData);

            System.debug('attacheDocs ==> '+attacheDocs);
            String body = '';
            //String subject = 'PurchaseOrder';
            String subject = ''; 

            apexData = 'Step 2';
            stringList.add(apexData);

            list<buildertek__Admin_Interface_Node_Configuration__c> adminInterfaceNodeConfigurations = [Select Id,
                                                                                                 buildertek__Quote_Configuration__c,buildertek__Email_Subject__c 
                                                                                                 from buildertek__Admin_Interface_Node_Configuration__c
                                                                                                 WHERE Name=:'Purchase Order Configuration' and buildertek__Email_Subject__c !=null limit 1];
            
            apexData = 'Step 3';
            stringList.add(apexData);

           if(adminInterfaceNodeConfigurations.size()>0){

            apexData = 'Step 4 + adminInterfaceNodeConfigurations[0] => '+adminInterfaceNodeConfigurations[0].Id;
            stringList.add(apexData);

               subject = adminInterfaceNodeConfigurations[0].buildertek__Email_Subject__c;

               apexData = 'Step 5 + buildertek__Email_Subject__c => '+adminInterfaceNodeConfigurations[0].buildertek__Email_Subject__c;
               stringList.add(apexData);

           }else{

            apexData = 'Step 6';
            stringList.add(apexData);

               subject = 'PurchaseOrder'; 

               apexData = 'Step 7';
               stringList.add(apexData);

           } 

           apexData = 'Step 8';
           stringList.add(apexData);

           List<buildertek__ConfirmationPageSiteURL__c> confirmationurl = buildertek__ConfirmationPageSiteURL__c.getall().values();
           
           apexData = 'Step 9';
           stringList.add(apexData);

            string SiteUrl;
            if(confirmationurl.size() > 0){

                apexData = 'Step 10 + confirmationurl => '+confirmationurl[0].Id;
                stringList.add(apexData);

              SiteUrl = confirmationurl[0].buildertek__SiteURL__c ;

              apexData = 'Step 11 + buildertek__SiteURL__c => '+confirmationurl[0].buildertek__SiteURL__c;
              stringList.add(apexData);

            }

            apexData = 'Step 12';
            stringList.add(apexData);

           List<string> strTO = new List<string>();
           List<string> strCC = new List<string>();
           SET<Id> contactIdSet = new SET<Id>();
           List<Contact> conList = new List<Contact>();

           apexData = 'Step 13';
           stringList.add(apexData);

           if(Schema.sObjectType.Contact.fields.Id.isAccessible()
               && Schema.sObjectType.Contact.fields.email.isAccessible()){

                apexData = 'Step 14';
                stringList.add(apexData);

               conList = [Select Id, email from Contact where Id IN:to and email != null];        

               apexData = 'Step 15';
               stringList.add(apexData);

           }

           apexData = 'Step 16';
           stringList.add(apexData);

           system.debug('conList -------> '+conList);
           for(Contact con: conList){

            apexData = 'Step 17 + con => '+con.Id;
            stringList.add(apexData);

               strTO.add(con.email);

               apexData = 'Step 18 + con.email => '+con.email;
               stringList.add(apexData);

           }

           apexData = 'Step 19';
           stringList.add(apexData);

           List<Contact> ccConList = new List<Contact>(); 
           if(cc.size() > 0 && Schema.sObjectType.Contact.fields.Id.isAccessible()
               && Schema.sObjectType.Contact.fields.Email.isAccessible()){

                apexData = 'Step 20';
                stringList.add(apexData);

               ccConList = [Select Id, email from Contact where Id IN:cc and Email != null]; 

               apexData = 'Step 21';
               stringList.add(apexData);

           }

           apexData = 'Step 22';
           stringList.add(apexData);

           if(ccConList.size() > 0){

            apexData = 'Step 23';
            stringList.add(apexData);

               for(Contact con: ccConList){

                apexData = 'Step 24 + conId => '+con.Id;
                stringList.add(apexData);

                   strCC.add(con.email);

                   apexData = 'Step 25 + con.email =>'+con.email;
                   stringList.add(apexData);

               }    

               apexData = 'Step 26';
               stringList.add(apexData);

           }

           apexData = 'Step 27';
           stringList.add(apexData);

           List<ContentVersion> contentList = [SELECT id, Title, Versiondata, FileType FROM ContentVersion WHERE ContentDocumentId IN: attacheDocs];

           apexData = 'Step 28';
           stringList.add(apexData);

           System.debug('contentList => '+contentList);

            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            system.debug('strTO ---------> '+strTO);
            mail.setToAddresses(strTO);

            apexData = 'Step 29';
           stringList.add(apexData);

            if(strCC != null && strCC.size() > 0) {

                apexData = 'Step 30';
                stringList.add(apexData);

                system.debug('strCC -------> '+strCC);
               mail.setCcAddresses(strCC);

                apexData = 'Step 31';
                stringList.add(apexData);

            }

            apexData = 'Step 32';
            stringList.add(apexData);

            EmailServicesAddress eServices;
            if(Schema.sObjectType.EmailServicesAddress.fields.Id.isAccessible()&&
               Schema.sObjectType.EmailServicesAddress.fields.AuthorizedSenders.isAccessible() &&
               Schema.sObjectType.EmailServicesAddress.fields.EmailDomainName.isAccessible() &&
               Schema.sObjectType.EmailServicesAddress.fields.LocalPart.isAccessible() &&
               Schema.sObjectType.EmailServicesAddress.fields.IsActive.isAccessible()){

                apexData = 'Step 32';
                stringList.add(apexData);

                eServices =  [SELECT Id,AuthorizedSenders,EmailDomainName,IsActive,LocalPart FROM EmailServicesAddress where LocalPart = 'projects'];

                apexData = 'Step 33 + eServices => '+eServices;
                stringList.add(apexData);

           } 

            apexData = 'Step 33';
            stringList.add(apexData);

            string fromAddress = eServices.LocalPart+'@'+eServices.EmailDomainName;

            apexData = 'Step 34 + fromAddress => '+fromAddress;
            stringList.add(apexData);

             body += 'Hi, <br/><br/> ';
            body += '</br> Please &nbsp;'; 
            body += '<a href='+ SiteUrl +'buildertek__ConfirmationPage?Id='+recordId+'&templateId='+templateId+'>Click here</a>';
            body += '&nbsp;to confirm your Purchase Order details.' ;

            apexData = 'Step 35 + body => '+body;
            stringList.add(apexData);

            mail.setReplyTo(fromAddress);

            apexData = 'Step 36';
            stringList.add(apexData);

            subject = subject +'[ref:'+recordId+']'; 

            apexData = 'Step 37 + subject => '+subject;
            stringList.add(apexData);

            mail.setSubject(subject);

            apexData = 'Step 38';
            stringList.add(apexData);

            mail.setHTMLBody(body);

            apexData = 'Step 39';
            stringList.add(apexData);
            
            mail.setSaveAsActivity(true);

            apexData = 'Step 40';
            stringList.add(apexData);
            
            List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
            Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
            efa.setFileName('PurchaseOrder.pdf');

            apexData = 'Step 41';
            stringList.add(apexData);

            system.debug('Blob ---> '+setAttachmentBody(recordId, templateId,fileid));
            efa.setBody(setAttachmentBody(recordId, templateId,fileid));

            apexData = 'Step 42';
            stringList.add(apexData);

            apexData = 'Step 43';
            stringList.add(apexData);

            fileAttachments.add(efa); 

            apexData = 'Step 44';
            stringList.add(apexData);

            for (ContentVersion condocs : contentList) {

                apexData = 'Step 45 + condocs => '+condocs.Id;
                stringList.add(apexData);

                System.debug('condocs=> '+condocs);
                Messaging.Emailfileattachment efat = new Messaging.Emailfileattachment();
                efat.setFileName(condocs.Title+'.'+condocs.FileType);

                apexData = 'Step 46 + setFileName => '+condocs.Title+'.'+condocs.FileType;
                stringList.add(apexData);

                efat.setBody(condocs.Versiondata);

                apexData = 'Step 47';
                stringList.add(apexData);

                fileAttachments.add(efat);

                apexData = 'Step 48';
                stringList.add(apexData);

            }

            apexData = 'Step 49';
            stringList.add(apexData);

            System.debug('fileAttachments => '+fileAttachments);
            mail.setFileAttachments(fileAttachments);

            apexData = 'Step 50';
            stringList.add(apexData);

            mails.add(mail);

            apexData = 'Step 51';
            stringList.add(apexData);

            Messaging.SendEmailResult[] results = Messaging.sendEmail(mails);
            String message = 'Success';

            apexData = 'Step 52';
            stringList.add(apexData);
            
               if(results.size() > 0){

                apexData = 'Step 53';
                stringList.add(apexData);
                
               if (results[0].isSuccess()) {

                apexData = 'Step 54';
                stringList.add(apexData);

                   string Toaddresses= '';
                   string CCaddresses= '';
                   integer i = 0;

                   apexData = 'Step 55';
                   stringList.add(apexData);

                   for(String Str : strTO){

                    apexData = 'Step 56 + Str => '+Str;
                    stringList.add(apexData);

                       Toaddresses += Str;

                       apexData = 'Step 56 + Toaddresses => '+Toaddresses;
                       stringList.add(apexData);
                       
                       if(strTO.size() > i){

                        apexData = 'Step 57';
                        stringList.add(apexData);

                           Toaddresses += ';';

                           apexData = 'Step 58 + Toaddresses => '+Toaddresses;
                           stringList.add(apexData);
                       }

                       apexData = 'Step 59';
                       stringList.add(apexData);

                       i++;
                   }

                   apexData = 'Step 60';
                   stringList.add(apexData);

                   for(String Str : strCC){

                    apexData = 'Step + 61 Str => '+Str;
                    stringList.add(apexData);

                       CCaddresses += Str;

                       apexData = 'Step 62 + CCaddresses => '+CCaddresses;
                       stringList.add(apexData);

                       if(strCC.size() > i){

                        apexData = 'Step 63';
                        stringList.add(apexData);

                           CCaddresses += ';';

                           apexData = 'Step 64 + CCaddresses => '+CCaddresses;
                           stringList.add(apexData);

                       }
                       i++;
                       
                       apexData = 'Step 65';
                       stringList.add(apexData);

                   }

                   apexData = 'Step 67';
                   stringList.add(apexData);

                   system.debug('CCaddresses ----------> '+CCaddresses);
                    EmailMessage caseEmailMessage = new EmailMessage();
                   caseEmailMessage.fromAddress= UserInfo.getUserEmail();

                   apexData = 'Step 68 + UserInfo.getUserEmail() => '+UserInfo.getUserEmail();
                   stringList.add(apexData);

                   caseEmailMessage.ToAddress = Toaddresses;

                   apexData = 'Step 69 + Toaddresses => '+Toaddresses;
                   stringList.add(apexData);

                   caseEmailMessage.FromName = UserInfo.getUserName();

                   apexData = 'Step 70 + UserInfo.getUserName() => '+UserInfo.getUserName();
                   stringList.add(apexData);

                   caseEmailMessage.CcAddress = CCaddresses;

                   apexData = 'Step 71 + CCaddresses => '+CCaddresses;
                   stringList.add(apexData);

                   caseEmailMessage.Subject = subject;

                   apexData = 'Step 72';
                   stringList.add(apexData);

                   caseEmailMessage.HtmlBody = body;

                   apexData = 'Step 73';
                   stringList.add(apexData);

                   caseEmailMessage.Incoming= False;

                   apexData = 'Step 74';
                   stringList.add(apexData);

                   //caseEmailMessage.IsTracked=true;
                   caseEmailMessage.buildertek__Is_Incoming_Email__c = false;

                   apexData = 'Step 75';
                   stringList.add(apexData);

                   caseEmailMessage.MessageDate = system.now();

                   apexData = 'Step 76';
                   stringList.add(apexData);

                   caseEmailMessage.TextBody = body.replaceAll('<br/>', '\n');

                   apexData = 'Step 77';
                   stringList.add(apexData);

                   system.debug('Content length ---------> '+body.length());
                   caseEmailMessage.status = '5';

                   apexData = 'Step 78';
                   stringList.add(apexData);

                   caseEmailMessage.RelatedToId = recordId;

                   apexData = 'Step 79';
                   stringList.add(apexData);

                   caseEmailMessage.buildertek__Subject__c = 'Re: '+subject;

                   apexData = 'Step 80';
                   stringList.add(apexData);
                   
                   insert caseEmailMessage;        
                   
                   apexData = 'Step 81';
                   stringList.add(apexData);
                   
                   EmailMessageRelation emr = new EmailMessageRelation();
                   emr.emailMessageId = caseEmailMessage.id;

                   apexData = 'Step 82';
                   stringList.add(apexData);

                   emr.relationId = UserInfo.getUserId(); // user id / contact Id of the sender

                   apexData = 'Step 83';
                   stringList.add(apexData);

                   emr.relationType = 'FromAddress';

                   apexData = 'Step 84';
                   stringList.add(apexData);

                   emr.relationAddress = caseEmailMessage.fromAddress;

                   apexData = 'Step 85';
                   stringList.add(apexData);

                   insert emr;    
                   
                   apexData = 'Step 86';
                   stringList.add(apexData);
                  
               }
           }
            return null;                   
        }
        catch(Exception exp){
            system.debug('Error Message --------> '+exp);
           String message = exp.getMessage();

           String errorMessage = 'Error Message => '+exp.getMessage();
           stringList.add(errorMessage);

           String errorLine = 'Error Line no => '+exp.getLineNumber();
           stringList.add(errorLine);

           return stringList;    
        }
    }
    
     @AuraEnabled
   public static String acceptandsendProposal(String htmlBody, String recordId, String templateId, List<String> to, List<String> cc,string Emailsubject, string fileid){
        try{
            String body = '';
           // String subject = 'PurchaseOrder';
            String subject='';
            list<buildertek__Admin_Interface_Node_Configuration__c> adminInterfaceNodeConfigurations = [Select Id,
                                                                                                 buildertek__Quote_Configuration__c,buildertek__Email_Subject__c 
                                                                                                 from buildertek__Admin_Interface_Node_Configuration__c
                                                                                                 WHERE Name=:'Purchase Order Configuration' and buildertek__Email_Subject__c !=null limit 1];
           if(adminInterfaceNodeConfigurations.size()>0){
               subject = adminInterfaceNodeConfigurations[0].buildertek__Email_Subject__c;
           }else{
               subject = 'PurchaseOrder'; 
           } 
             List<buildertek__ConfirmationPageSiteURL__c> confirmationurl = buildertek__ConfirmationPageSiteURL__c.getall().values();
            string SiteUrl;
            if(confirmationurl.size() > 0){
              SiteUrl = confirmationurl[0].buildertek__SiteURL__c ;
            }

           List<string> strTO = new List<string>();
           List<string> strCC = new List<string>();
           SET<Id> contactIdSet = new SET<Id>();
           List<Contact> conList = new List<Contact>();
           if(Schema.sObjectType.Contact.fields.Id.isAccessible()
               && Schema.sObjectType.Contact.fields.email.isAccessible()){
               conList = [Select Id, email from Contact where Id IN:to and email != null];        
           }
           system.debug('conList -------> '+conList);
           for(Contact con: conList){
               strTO.add(con.email);
           }
           List<Contact> ccConList = new List<Contact>(); 
           if(cc.size() > 0 && Schema.sObjectType.Contact.fields.Id.isAccessible()
               && Schema.sObjectType.Contact.fields.Email.isAccessible()){
               ccConList = [Select Id, email from Contact where Id IN:cc and Email != null];        
           }
           if(ccConList.size() > 0){
               for(Contact con: ccConList){
                   strCC.add(con.email);
               }    
           }
            
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            system.debug('strTO ---------> '+strTO);
            mail.setToAddresses(strTO);
            if(strCC != null && strCC.size() > 0) {
                system.debug('strCC -------> '+strCC);
               mail.setCcAddresses(strCC);
            }
            EmailServicesAddress eServices;
            if(Schema.sObjectType.EmailServicesAddress.fields.Id.isAccessible()&&
               Schema.sObjectType.EmailServicesAddress.fields.AuthorizedSenders.isAccessible() &&
               Schema.sObjectType.EmailServicesAddress.fields.EmailDomainName.isAccessible() &&
               Schema.sObjectType.EmailServicesAddress.fields.LocalPart.isAccessible() &&
               Schema.sObjectType.EmailServicesAddress.fields.IsActive.isAccessible()){
                eServices =  [SELECT Id,AuthorizedSenders,EmailDomainName,IsActive,LocalPart FROM EmailServicesAddress where LocalPart = 'projects'];
           } 
            string fromAddress = eServices.LocalPart+'@'+eServices.EmailDomainName;
             body += 'Hi, <br/><br/> ';
            body += '</br> Please &nbsp;'; 
            body += '<a href='+ SiteUrl +'buildertek__ConfirmationPage?Id='+recordId+'&templateId='+templateId+'>Click here</a>';
            body += '&nbsp;to confirm your Purchase Order details.' ;
            mail.setReplyTo(fromAddress);
            subject = subject +'[ref:'+recordId+']'; 
            mail.setSubject(subject);
            mail.setHTMLBody(body);
            List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
            Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
            efa.setFileName('PurchaseOrder.pdf');
            system.debug('Blob ---> '+setAttachmentBody(recordId, templateId,fileid));
            efa.setBody(setAttachmentBody(recordId, templateId,fileid));
            fileAttachments.add(efa); 
            mail.setFileAttachments(fileAttachments);
            mails.add(mail);
            Messaging.SendEmailResult[] results = Messaging.sendEmail(mails);
            String message = 'Success';
                if(results.size() > 0){
               if (results[0].isSuccess()) {
                   string Toaddresses= '';
                   string CCaddresses= '';
                   integer i = 0;
                   for(String Str : strTO){
                       Toaddresses += Str;
                       if(strTO.size() > i){
                           Toaddresses += ';';
                       }
                       i++;
                   }
                   for(String Str : strCC){
                       CCaddresses += Str;
                       if(strCC.size() > i){
                           CCaddresses += ';';
                       }
                       i++;
                       
                   }
                   system.debug('CCaddresses ----------> '+CCaddresses);
                    EmailMessage caseEmailMessage = new EmailMessage();
                   caseEmailMessage.fromAddress= UserInfo.getUserEmail();
                   caseEmailMessage.ToAddress = Toaddresses;
                   caseEmailMessage.FromName = UserInfo.getUserName();
                   caseEmailMessage.CcAddress = CCaddresses;
                   caseEmailMessage.Subject = subject;
                   caseEmailMessage.HtmlBody = body;
                   caseEmailMessage.Incoming= False;
                   caseEmailMessage.buildertek__Is_Incoming_Email__c = false;
                   caseEmailMessage.MessageDate = system.now();
                   caseEmailMessage.TextBody = body.replaceAll('<br/>', '\n');
                   system.debug('Content length ---------> '+body.length());
                   caseEmailMessage.status = '5';
                   caseEmailMessage.RelatedToId = recordId;
                   caseEmailMessage.buildertek__Subject__c = 'Re: '+subject;
                   
                   insert caseEmailMessage;        
                   
                   
                   
                   EmailMessageRelation emr = new EmailMessageRelation();
                   emr.emailMessageId = caseEmailMessage.id;
                   emr.relationId = UserInfo.getUserId(); // user id / contact Id of the sender
                   emr.relationType = 'FromAddress';
                   emr.relationAddress = caseEmailMessage.fromAddress;
                   insert emr;        
                  
               }
           }
            list<buildertek__Purchase_Order__c> porec = [select id,
                                                               Name,
                                                               buildertek__Status__c,
                                                               buildertek__Customer_Accepted_Date__c,
                                                               buildertek__Date_Confirmed__c
                                                               from buildertek__Purchase_Order__c where Id=:recordId limit 1];
               if(porec.size() > 0 ){
                   porec[0].buildertek__Date_Confirmed__c = System.today();
                   update porec;
               }
               
            return message;                   
        }
        catch(Exception exp){
            system.debug('Error Message --------> '+exp);
           String message = exp.getMessage();
           return message;    
        }
   }
   
    private static Blob setAttachmentBody(String recordId, String templateId, String fileid){
       pagereference pdf;
       pdf = Page.buildertek__BT_GeneratePdf;
       pdf.getParameters().put('recordId',recordId);  
       pdf.getParameters().put('templateId',templateId); 
       pdf.getParameters().put('fileId',fileId);
       pdf.setRedirect(true);
       
       Blob blobbody = !Test.isRunningTest() ? pdf.getContent() : Blob.ValueOf('dummy text');
       return blobbody;
   }
   
   
   
   
    /* To Save the Signature in Files */
   @AuraEnabled
   public static string saveSign(String recId,String base64Data, String contentType,string signName){
       system.debug('base64Data-------------'+base64Data);
       string conversn;
       if(base64Data.length() > 1696 || Test.isRunningTest()){  
           base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');   
           ContentVersion conVer = new ContentVersion();
           conVer.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
           conVer.PathOnClient = 'SignatureName.png'; // The files name, extension is very important here which will help the file in preview.
           conVer.Title = signName; // Display name of the files
           conVer.VersionData = EncodingUtil.base64Decode(base64Data); // converting your binary string to Blog
           insert conVer;    //Insert ContentVersion
           system.debug('*******conVer*******'+conVer);
           // First get the Content Document Id from ContentVersion Object
           Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
           //create ContentDocumentLink  record 
           ContentDocumentLink conDocLink = New ContentDocumentLink();
           conDocLink.LinkedEntityId = recId; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
           conDocLink.ContentDocumentId = conDoc;  //ContentDocumentId Id from ContentVersion
           conDocLink.shareType = 'I';
           insert conDocLink;  
          system.debug('conDocLink---'+conDocLink.id);
          
          list<buildertek__Purchase_Order__c> porec = [select id,
                                                               Name,
                                                               buildertek__Status__c,
                                                               buildertek__Customer_Accepted_Date__c,
                                                               buildertek__Date_Confirmed__c,
                                                               buildertek__Rejection_Reason__c
                                                               from buildertek__Purchase_Order__c where Id=:recId limit 1];
               if(porec.size() > 0 ){
                   porec[0].buildertek__Date_Confirmed__c = System.today();
                   porec[0].buildertek__Status__c = 'Vendor Accepted';
                   update porec;
               }
            conversn = [SELECT Id,VersionData FROM ContentVersion WHERE ContentDocumentId = :conDoc AND IsLatest = true].Id;
           //system.debug('conversn[0].Id ='+conversn[0].Id);
           return conversn;
       }else{
            String message = 'NoImage';
           return message;
       }
       
   } 
   
   
   @AuraEnabled
   public static string rejectSign(String recId,String base64Data, String contentType,string signName,String rejectionReason){
       system.debug('base64Data-------------'+base64Data);
       string conversn;
       if(base64Data.length() > 1696 || Test.isRunningTest()){  
           base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');   
           ContentVersion conVer = new ContentVersion();
           conVer.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
           conVer.PathOnClient = 'SignatureName.png'; // The files name, extension is very important here which will help the file in preview.
           conVer.Title = signName; // Display name of the files
           conVer.VersionData = EncodingUtil.base64Decode(base64Data); // converting your binary string to Blog
           insert conVer;    //Insert ContentVersion
           system.debug('*******conVer*******'+conVer);
           // First get the Content Document Id from ContentVersion Object
           Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
           //create ContentDocumentLink  record 
           ContentDocumentLink conDocLink = New ContentDocumentLink();
           conDocLink.LinkedEntityId = recId; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
           conDocLink.ContentDocumentId = conDoc;  //ContentDocumentId Id from ContentVersion
           conDocLink.shareType = 'I';
           insert conDocLink;  
          system.debug('conDocLink---'+conDocLink.id);
          
          list<buildertek__Purchase_Order__c> porec = [select id,
                                                               Name,
                                                               buildertek__Status__c,
                                                               buildertek__Customer_Accepted_Date__c,
                                                               buildertek__Date_Confirmed__c,
                                                               buildertek__Rejection_Reason__c
                                                               from buildertek__Purchase_Order__c where Id=:recId limit 1];
               if(porec.size() > 0 ){
                   porec[0].buildertek__Date_Confirmed__c = System.today();
                   porec[0].buildertek__Status__c = 'Vendor Rejected';
                   porec[0].buildertek__Rejection_Reason__c = rejectionReason;
                   update porec;
               }
            conversn = [SELECT Id,VersionData FROM ContentVersion WHERE ContentDocumentId = :conDoc AND IsLatest = true].Id;
           //system.debug('conversn[0].Id ='+conversn[0].Id);
           return conversn;
       }else{
            String message = 'NoImage';
           return message;
       }
       
   } 
   
    /* To Save the Signature in Files */
   @AuraEnabled
   public static string rejectionWithReason(String recId,String base64Data, String contentType,string signName,String rejectionReason){
       system.debug('base64Data-------------'+base64Data);
       string conversn;
       if(base64Data.length() > 1696 || Test.isRunningTest()){  
           base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');   
           ContentVersion conVer = new ContentVersion();
           conVer.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
           conVer.PathOnClient = 'SignatureName.png'; // The files name, extension is very important here which will help the file in preview.
           conVer.Title = signName; // Display name of the files
           conVer.VersionData = EncodingUtil.base64Decode(base64Data); // converting your binary string to Blog
           insert conVer;    //Insert ContentVersion
           system.debug('*******conVer*******'+conVer);
           // First get the Content Document Id from ContentVersion Object
           Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
           //create ContentDocumentLink  record 
           ContentDocumentLink conDocLink = New ContentDocumentLink();
           conDocLink.LinkedEntityId = recId; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
           conDocLink.ContentDocumentId = conDoc;  //ContentDocumentId Id from ContentVersion
           conDocLink.shareType = 'I';
           insert conDocLink;  
           system.debug('conDocLink---'+conDocLink.id);
          
          list<buildertek__Purchase_Order__c> porec = [select id,
                                                               Name,
                                                               buildertek__Status__c,
                                                               buildertek__Customer_Accepted_Date__c,
                                                               buildertek__Date_Confirmed__c,
                                                               buildertek__Rejection_Reason__c
                                                               from buildertek__Purchase_Order__c where Id=:recId limit 1];
               if(porec.size() > 0 ){
                   porec[0].buildertek__Date_Confirmed__c = System.today();
                   porec[0].buildertek__Status__c = 'Vendor Rejected';
                   porec[0].buildertek__Rejection_Reason__c = rejectionReason;
                   
                   update porec;
               }
            conversn = [SELECT Id,VersionData FROM ContentVersion WHERE ContentDocumentId = :conDoc AND IsLatest = true].Id;
           //system.debug('conversn[0].Id ='+conversn[0].Id);
           return conversn;
       }else{
            String message = 'NoImage';
           return message;
       }
       
   } 
   
}