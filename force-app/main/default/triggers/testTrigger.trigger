trigger testTrigger on Contact (after insert) {
    // Get the set of matching records from the other object
    Set<String> matchingRecords = new Set<String>();
    for (Contact record : Trigger.new) {
        matchingRecords.add(record.FirstName + record.LastName);
    }
    Map<String, Lead> otherRecords = new Map<String, Lead>([SELECT FirstName, LastName, Phone FROM Lead WHERE  LastName IN :matchingRecords ]);

    // Update the third field on the custom object records
    for (Contact record : Trigger.new) {
        String key = record.FirstName + record.LastName;
        if (otherRecords.containsKey(key)) {
            record.Phone = otherRecords.get(key).Phone;
        }
    }
}