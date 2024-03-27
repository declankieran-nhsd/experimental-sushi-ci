Instance: RAFlagExample2
InstanceOf: Flag
Title: "RA example 2 of a Flag resource."
Usage: #example
* meta.profile = "https://fhir.nhs.uk/England/StructureDefinition/ProgrammeFlag"

* extension[0].url = "https://fhir.nhs.uk/England/StructureDefinition/Extension-FlagNotes"
* extension[=].valueAnnotation.text = "Example of adjustment notes extension text in adjustment flag"

* status = #active
* category[0] = PatientFlagCategory#NRAF "National Reasonable Adjustments Flag"
* category[+] = RA-FlagCategory#011 "Bespoke Reasonable adjustments"
* code = $sct#73618009 "Autistic spectrum disorder with isolated skills"
* subject = Reference(Patient/PatientExample1)

* contained.resourceType = "Provenance"
* contained.id = "71f8bcda-242d-4401-a59c-6924a6cb1c0e"
* contained.target.reference = "#"
* contained.recorded = "2024-01-01T11:00:00+00:00"
* contained.activity = $v3-DataOperation#CREATE "create"
* contained.agent.role = $CareConnect-SDSJobRoleName-1#R0260 "General Medical Practitioner"
* contained.agent.who.reference = "https://sds.spineservices.nhs.uk/STU3/Practitioner/2ee4tr6a9"
* contained.agent.onBehalfOf.reference = "https://directory.spineservices.nhs.uk/STU3/Organization/a3e5i7"