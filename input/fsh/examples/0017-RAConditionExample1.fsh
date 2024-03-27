Instance: RAConditionExample1
InstanceOf: Condition
Title: "RA example 1 of a Condition resource."
Usage: #example
* meta.profile = "https://fhir.nhs.uk/England/StructureDefinition/FlagCondition"

* clinicalStatus = $condition-clinical#active
* category[0] = PatientFlagCategory#NRAF "National Reasonable Adjustments Flag"
* category[+] = RA-ConditionCategory#issue "Issue"
* code = RA-ConditionCode#5 "Learning or understanding or concentrating"
* subject = Reference(Patient/PatientExample1)

* contained.resourceType = "Provenance"
* contained.id = "6a6b18a7-c077-49da-929f-a8dd38468f79"
* contained.target.reference = "#"
* contained.recorded = "2024-01-01T11:00:00+00:00"
* contained.activity = $v3-DataOperation#CREATE "create"
* contained.agent.role = $CareConnect-SDSJobRoleName-1#R0260 "General Medical Practitioner"
* contained.agent.who.reference = "https://sds.spineservices.nhs.uk/STU3/Practitioner/2ee4tr6a9"
* contained.agent.onBehalfOf.reference = "https://directory.spineservices.nhs.uk/STU3/Organization/a3e5i7"