public with sharing class EmailManager2 {
	public static void sendMail(String address, String subject, String body) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {address};
        mail.setToAddresses(toAddresses);
        mail.setSubject(subject);
        mail.setPlainTextBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

    public static void sendMailWithTemplate ( List<EmailMessageWrapper> listEmailMessageWrapper, String emailTemplateName ) {
    	List<Messaging.SendEmailResult> listEmailResult = null;

    	List<Messaging.Singleemailmessage> listSingleEmailMessages = new List<Messaging.Singleemailmessage>();

    	EmailTemplate emailTemplate = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE Name = :emailTemplateName];

    	for (EmailMessageWrapper emailMessageWrapper : listEmailMessageWrapper) {

    		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			mail.setSenderDisplayName('Speaker Confirmation');

			//check FromAddress
    		if (emailMessageWrapper.FromAddress != null && emailMessageWrapper.FromAddress.length() > 0) {
    			mail.setReplyTo(emailMessageWrapper.FromAddress);
            }

    		//check ToAddress
    		if (emailMessageWrapper.ToAddress != null && emailMessageWrapper.ToAddress.length() > 0 ) {
    			mail.setToAddresses(new String[] { emailMessageWrapper.ToAddress });
            }
    		else {
    			mail.setTargetObjectId(emailMessageWrapper.ToAddressId);
            }

    		//check Bcc
    		if (emailMessageWrapper.BccAddress != null && emailMessageWrapper.BccAddress.length() > 0) {
    			mail.setBccAddresses(new String[] {emailMessageWrapper.BccAddress });
            }


    		//check subject
			String subject = null;

    		if (emailMessageWrapper.Subject != null && emailMessageWrapper.Subject.length() > 0) {
    			mail.setSubject(emailMessageWrapper.Subject);
    			subject = emailMessageWrapper.Subject;
    		}
    		else {
    			subject = emailTemplate.Subject;
            }

    		
    		//Replace key in subject
    		if (emailMessageWrapper.ParameterSubjectMap != null) {
    			
    			for (String key: emailMessageWrapper.ParameterSubjectMap.keySet()) {
	    			
	    			subject = subject.replace(key, (emailMessageWrapper.ParameterSubjectMap.get(key) == null ? '' : emailMessageWrapper.ParameterSubjectMap.get(key)));
	    		}

	    		mail.setSubject(subject);
    		}
    		
    		
    		//Replace
    		if (emailMessageWrapper.ParameterBodyMap != null) {
	    		String htmlBody = emailTemplate.HtmlValue;
	    		String plainBody = emailTemplate.Body;
	    		
	    		for (String key : emailMessageWrapper.ParameterBodyMap.keySet()) {

	    			htmlBody = htmlBody.replace(key, (emailMessageWrapper.ParameterBodyMap.get(key) == null) ? '' : emailMessageWrapper.ParameterBodyMap.get(key));
	    			plainBody = plainBody.replace(key, (emailMessageWrapper.ParameterBodyMap.get(key) == null) ? '' : emailMessageWrapper.ParameterBodyMap.get(key));
	    			//system.debug(key);
	    		}

	    		mail.setHtmlBody(htmlBody);
	    		mail.setSaveAsActivity(false);
	    		mail.setPlainTextBody(plainBody);
    		}
    		listSingleEmailMessages.add(mail);
    	}
    	if (!Test.isRunningTest()) {
            listEmailResult = Messaging.sendEmail(listSingleEmailMessages);
        }
    }
}