public class QualifiedEmailController {

public static void sendEmail(Set<Id> accountIds){
    system.debug('Trigger callled'+accountIds);
    buildertek__MSA_Settings__c msaSettings = [Select Id, buildertek__Site_URL__c,
                                                        buildertek__MSA_PDF_Template__c,
                                                        buildertek__MSA_Template__c,buildertek__Send_MSA_Template_Name__c
                                                        from buildertek__MSA_Settings__c
                                                        WHERE Name = 'MSA Settings' LIMIT 1];
    list<Account> accountlist = [select id,Name,buildertek__MSA_Additional_Email__c,buildertek__Pre_Qual_Contact__c from Account where id IN: accountIds];
   // List<Contact> contacts = [SELECT Id,Email, AccountId,Account.buildertek__MSA_Additional_Email__c FROM Contact WHERE AccountId IN: accountIds];
   List<Contact> contactsList = [SELECT Id, Name, Email FROM Contact WHERE id =: accountlist[0].buildertek__Pre_Qual_Contact__c];
   List<EmailTemplate> template = [SELECT Id, Name, Subject, Body,htmlvalue FROM EmailTemplate  WHERE Name =:msaSettings.buildertek__Send_MSA_Template_Name__c];
   string body ='';
   if(template.size()>0){
      body= template[0].htmlvalue;
    }
    List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
    buildertek__MSA_Settings__c sitesUrl = [SELECT Id, buildertek__Site_URL__c FROM buildertek__MSA_Settings__c LIMIT 1];
    string link ='<a href="'+sitesUrl.buildertek__Site_URL__c+'/'+msaSettings.buildertek__MSA_Template__c+'?id='+accountlist[0].Id+'&isresend=false">Click here to open the Web Form</a>';
    string emailSubject;
    if(body.Contains('{!URL}')){
        body = body.replace('{!URL}',link);
     }
     if(template.size()>0){
         emailSubject = template[0].Subject;
     }
    List<String> toAddresses = new List<String>();
    //system.debug(contactsList[0].Email);
    system.debug(accountlist[0].buildertek__MSA_Additional_Email__c);
      if(contactsList.size() > 0 && contactsList[0].Email != null){
        system.debug('1');
         toAddresses.add(contactsList[0].Email);
    }else if(accountlist[0].buildertek__MSA_Additional_Email__c != null){
           system.debug('2');
         toAddresses.add(accountlist[0].buildertek__MSA_Additional_Email__c);
         system.debug('!!!'+toAddresses);
    }
    system.debug(toAddresses);
     system.debug(toAddresses.isEmpty());
    system.debug(toAddresses.size());
    if(toAddresses.size() > 0){
    system.debug('hi');
    
    
 
List<ContentDocumentLink> accdoc = [SELECT ContentDocumentId, LinkedEntityId  FROM ContentDocumentLink where LinkedEntityId IN :accountIds];
List<String> ContentDocumentIdList = new List<String>();
for(ContentDocumentLink con:accdoc){
ContentDocumentIdList.add(con.ContentDocumentId);
}
system.debug(ContentDocumentIdList);
List<ContentVersion> verList = [Select id,Title,VersionData,PathOnClient,ContentDocumentId from ContentVersion where ContentDocumentId IN:ContentDocumentIdList AND Title LIKE '%-Qualification%'];
system.debug(verList);


    for(account acc : accountlist){
         //toAddresses = new String[] {acc.buildertek__MSA_Additional_Email__c};
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(toAddresses);
            //string emailSubject = 'PreQualified Email';
            email.setSubject(emailSubject);
            //String body = '<html><body><p><span>Congratulations, you have been pre-qualified. You will be receiving additional instructions shortly on next steps.  Please fill out our MSA form.  If you have any questions please let us know.';
            //body += '</span><br/><span><a href="'+msaSettings.buildertek__Site_URL__c+'/'+msaSettings.buildertek__MSA_Template__c+'?id='+Acc.Id+'">Click here to open the Web Form</a>';
            //body += '</span></p></body></html>'; 
            email.setHtmlBody(body);
            List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
            for(ContentVersion ver:verList){
                Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                efa.setFileName(ver.PathOnClient);
                //efa.setBody(EncodingUtil.Base64Encode(Blob.valueOf(inn[0].fileContent)));
                efa.setBody(ver.VersionData);
                fileAttachments.add(efa);
                 email.setFileAttachments(fileAttachments);
            }
            mails.add(email);   
    }
             string addresses= '';
            string CCaddresses= '';
    Messaging.SendEmailResult[] results = Messaging.sendEmail(mails);
    if(results.size() > 0 ){
            if (results[0].isSuccess()) {
                List<Account> accountsList = [SELECT Id, buildertek__Qualification_Date__c,buildertek__Qualification_Stage__c FROM Account WHERE Id IN: accountIds];
                for(Account acc : accountsList){
                    acc.buildertek__Qualification_Date__c = system.now();
                    acc.buildertek__Qualification_Stage__c = 'MSA Sent';    
                }
                update accountsList;
                integer i = 0;
                for(String Str : toAddresses){
                    addresses += Str;
                    if(toAddresses.size() > i){
                        addresses += ';';
                    }
                    i++;
                }
                EmailMessage caseEmailMessage = new EmailMessage();
                caseEmailMessage.fromAddress= UserInfo.getUserEmail();
                caseEmailMessage.ToAddress = addresses;
                caseEmailMessage.FromName = UserInfo.getUserName();
                caseEmailMessage.CcAddress = CCaddresses;
                caseEmailMessage.Subject = emailSubject;
                caseEmailMessage.HtmlBody = body;
                caseEmailMessage.Incoming= False;
                caseEmailMessage.buildertek__Is_Incoming_Email__c = false;
                caseEmailMessage.MessageDate = system.now();
                caseEmailMessage.TextBody = body.replaceAll('<br/>', '\n');
                system.debug('Content length ---------> '+body.length());
                caseEmailMessage.status = '5';
                caseEmailMessage.RelatedToId = accountlist[0].id;
                caseEmailMessage.buildertek__Subject__c = emailSubject;
                
                insert caseEmailMessage;
            }
        }
    }else{
        //accountlist[0].Name.addError('Error added to Name on trigger');
    }
}

}