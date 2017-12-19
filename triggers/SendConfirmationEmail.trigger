trigger SendConfirmationEmail on Session_Speaker__c ( after insert ) {
	List<Id> sessionSpeakerIds = new List<Id>();
    List<EmailMessageWrapper> listEmailMessageWrapper = new List<EmailMessageWrapper>();
    for ( Session_Speaker__c newItem : trigger.new ) {
        sessionSpeakerIds.add( newItem.Id );
    }
    
    List<Session_speaker__c> sessionSpeakers =
            [SELECT Session__r.Name,
                    Session__r.Session_Date__c,
                    Speaker__r.First_Name__c,
                    Speaker__r.Last_Name__c,
                    Speaker__r.Email__c
             FROM Session_Speaker__c WHERE Id IN :sessionSpeakerIds];
    if ( sessionSpeakers.size() > 0 ) {
        Session_Speaker__c sessionSpeaker = sessionSpeakers[0];
        if ( sessionSpeaker.Speaker__r.Email__c != null ) {
            String templateName = 'Speaker Confirmation';
            String address = sessionSpeaker.Speaker__r.Email__c;
            String subject = 'Speaker Confirmation';
            Map<String, String> mapBodyParams = new Map<String, String> {
                    '{!Session_Speaker__c.Speaker__r.First_Name__c}' => sessionSpeaker.Speaker__r.First_Name__c,
                    '{!Session_Speaker__c.Session__r.Name}' => sessionSpeaker.Session__r.Name,
                    '{!Session_Speaker__c.Session__r.Session_Date__c}' => sessionSpeaker.Session__r.Session_Date__c.format()
                };

            listEmailMessageWrapper.add(new EmailMessageWrapper('admin@salesforce.com', address, subject, mapBodyParams));
            EmailManager2.sendMailWithTemplate(listEmailMessageWrapper, templateName);
        }
    }

}