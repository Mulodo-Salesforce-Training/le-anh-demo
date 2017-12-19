trigger ExampleTrigger on Contract (after insert, after delete) {
	if (Trigger.isInsert) {
        Integer recordCount = Trigger.New.size();
       	EmailManager email = new EmailManager();
        email.sendMail('Your email address', 'Trailhead Trigger Tutorial', 
                    recordCount + ' contact(s) were inserted.');
    }
    else if (Trigger.isDelete) {
        // Process after delete
    }
}